Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E7E305E71
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 15:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbhA0Og3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 09:36:29 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:46340 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S234262AbhA0Odm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 09:33:42 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@nvidia.com)
        with SMTP; 27 Jan 2021 16:32:49 +0200
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (reg-r-vrt-019-180.mtr.labs.mlnx [10.213.19.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10REWnmq010762;
        Wed, 27 Jan 2021 16:32:49 +0200
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, netdev@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 1/3] net/sched: cls_flower: Add match on the ct_state reply flag
Date:   Wed, 27 Jan 2021 16:32:45 +0200
Message-Id: <1611757967-18236-2-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1611757967-18236-1-git-send-email-paulb@nvidia.com>
References: <1611757967-18236-1-git-send-email-paulb@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add match on the ct_state reply flag.

Example:
$ tc filter add dev ens1f0_0 ingress prio 1 chain 1 proto ip flower \
  ct_state +trk+est+rpl \
  action mirred egress redirect dev ens1f0_1
$ tc filter add dev ens1f0_1 ingress prio 1 chain 1 proto ip flower \
  ct_state +trk+est-rpl \
  action mirred egress redirect dev ens1f0_0

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 include/uapi/linux/pkt_cls.h | 1 +
 net/sched/cls_flower.c       | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 709668e..afe6836 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -592,6 +592,7 @@ enum {
 	TCA_FLOWER_KEY_CT_FLAGS_RELATED = 1 << 2, /* Related to an established connection. */
 	TCA_FLOWER_KEY_CT_FLAGS_TRACKED = 1 << 3, /* Conntrack has occurred. */
 	TCA_FLOWER_KEY_CT_FLAGS_INVALID = 1 << 4, /* Conntrack is invalid. */
+	TCA_FLOWER_KEY_CT_FLAGS_REPLY = 1 << 5, /* Packet is in the reply direction. */
 };
 
 enum {
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 4a9297a..caf7643 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -291,9 +291,11 @@ struct cls_fl_filter *fl_mask_lookup(struct fl_flow_mask *mask, struct fl_flow_k
 	[IP_CT_RELATED] =		TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
 					TCA_FLOWER_KEY_CT_FLAGS_RELATED,
 	[IP_CT_ESTABLISHED_REPLY] =	TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
-					TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED,
+					TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED |
+					TCA_FLOWER_KEY_CT_FLAGS_REPLY,
 	[IP_CT_RELATED_REPLY] =		TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
-					TCA_FLOWER_KEY_CT_FLAGS_RELATED,
+					TCA_FLOWER_KEY_CT_FLAGS_RELATED |
+					TCA_FLOWER_KEY_CT_FLAGS_REPLY,
 	[IP_CT_NEW] =			TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
 					TCA_FLOWER_KEY_CT_FLAGS_NEW,
 };
-- 
1.8.3.1

