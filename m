Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D752D9D0EF
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 15:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732082AbfHZNpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 09:45:25 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52986 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732058AbfHZNpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 09:45:25 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Aug 2019 16:45:15 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7QDjEFX000366;
        Mon, 26 Aug 2019 16:45:15 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v3 09/10] net: sched: copy tunnel info when setting flow_action entry->tunnel
Date:   Mon, 26 Aug 2019 16:45:05 +0300
Message-Id: <20190826134506.9705-10-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190826134506.9705-1-vladbu@mellanox.com>
References: <20190826134506.9705-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to remove dependency on rtnl lock, modify tc_setup_flow_action()
to copy tunnel info, instead of just saving pointer to tunnel_key action
tunnel info. This is necessary to prevent concurrent action overwrite from
releasing tunnel info while it is being used by rtnl-unlocked driver.

Implement helper tcf_tunnel_info_copy() that is used to copy tunnel info
with all its options to dynamically allocated memory block. Modify
tc_cleanup_flow_action() to free dynamically allocated tunnel info.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/tc_act/tc_tunnel_key.h | 17 +++++++++++++++++
 net/sched/cls_api.c                |  9 ++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/net/tc_act/tc_tunnel_key.h b/include/net/tc_act/tc_tunnel_key.h
index 7c3f777c168c..0689d9bcdf84 100644
--- a/include/net/tc_act/tc_tunnel_key.h
+++ b/include/net/tc_act/tc_tunnel_key.h
@@ -59,4 +59,21 @@ static inline struct ip_tunnel_info *tcf_tunnel_info(const struct tc_action *a)
 	return NULL;
 #endif
 }
+
+static inline struct ip_tunnel_info *
+tcf_tunnel_info_copy(const struct tc_action *a)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	struct ip_tunnel_info *tun = tcf_tunnel_info(a);
+
+	if (tun) {
+		size_t tun_size = sizeof(*tun) + tun->options_len;
+		struct ip_tunnel_info *tun_copy = kmemdup(tun, tun_size,
+							  GFP_KERNEL);
+
+		return tun_copy;
+	}
+#endif
+	return NULL;
+}
 #endif /* __NET_TC_TUNNEL_KEY_H */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d988737693e4..671ca905dbb5 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3279,6 +3279,9 @@ void tc_cleanup_flow_action(struct flow_action *flow_action)
 			if (entry->dev)
 				dev_put(entry->dev);
 			break;
+		case FLOW_ACTION_TUNNEL_ENCAP:
+			kfree(entry->tunnel);
+			break;
 		default:
 			break;
 		}
@@ -3355,7 +3358,11 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			}
 		} else if (is_tcf_tunnel_set(act)) {
 			entry->id = FLOW_ACTION_TUNNEL_ENCAP;
-			entry->tunnel = tcf_tunnel_info(act);
+			entry->tunnel = tcf_tunnel_info_copy(act);
+			if (!entry->tunnel) {
+				err = -ENOMEM;
+				goto err_out;
+			}
 		} else if (is_tcf_tunnel_release(act)) {
 			entry->id = FLOW_ACTION_TUNNEL_DECAP;
 		} else if (is_tcf_pedit(act)) {
-- 
2.21.0

