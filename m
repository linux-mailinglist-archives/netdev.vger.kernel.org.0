Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9687D9B668
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 20:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406024AbfHWSvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 14:51:35 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44610 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390928AbfHWSv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 14:51:26 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Aug 2019 21:51:20 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7NIpJEK012807;
        Fri, 23 Aug 2019 21:51:20 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        pablo@netfilter.org, Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v2 09/10] net: sched: copy tunnel info when setting flow_action entry->tunnel
Date:   Fri, 23 Aug 2019 21:50:55 +0300
Message-Id: <20190823185056.12536-10-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190823185056.12536-1-vladbu@mellanox.com>
References: <20190823185056.12536-1-vladbu@mellanox.com>
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
index 622146aafb06..c00c836cd155 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3274,6 +3274,9 @@ void tc_cleanup_flow_action(struct flow_action *flow_action)
 			if (entry->dev)
 				dev_put(entry->dev);
 			break;
+		case FLOW_ACTION_TUNNEL_ENCAP:
+			kfree(entry->tunnel);
+			break;
 		default:
 			break;
 		}
@@ -3350,7 +3353,11 @@ int tc_setup_flow_action(struct flow_action *flow_action,
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

