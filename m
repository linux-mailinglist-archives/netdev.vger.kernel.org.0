Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C49131CBD
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 01:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgAGAYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 19:24:39 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:31881 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbgAGAYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 19:24:39 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 660A341608;
        Tue,  7 Jan 2020 08:24:33 +0800 (CST)
From:   wenxu@ucloud.cn
To:     paulb@mellanox.com, saeedm@mellanox.com
Cc:     pablo@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net/mlx5e: Add FLOW_DISSECTOR_KEY_META parse support
Date:   Tue,  7 Jan 2020 08:24:33 +0800
Message-Id: <1578356673-16448-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVOSkxCQkJDQ0xPTU1PSFlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6ND46Ayo5FTg2Qz8VGR8VLBNC
        MgsaFCFVSlVKTkxDSE5NTUxPS01DVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhJTUI3Bg++
X-HM-Tid: 0a6f7d638b992086kuqy660a341608
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

In the FT_OFFLOAD all the forward devices share the same block.
If there are more than two devices the wrong flows will be
installed on the devices.

For three devices: A, B, C
The flow received from A forward to B will install on device A
forward to B. And install on C forward to B. (The flow install on B
forward to B will be failed). It should be avoid this case through
FLOW_DISSECTOR_KEY_META.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
The flowtable offload will support this as following patch. 
http://patchwork.ozlabs.org/patch/1218109/

 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 39 +++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0d5d84b..eadc608 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1802,6 +1802,40 @@ static void *get_match_headers_value(u32 flags,
 			     outer_headers);
 }
 
+static int mlx5e_flower_parse_meta(struct net_device *filter_dev,
+				   struct flow_cls_offload *f)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	struct netlink_ext_ack *extack = f->common.extack;
+	struct net_device *ingress_dev;
+	struct flow_match_meta match;
+
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_META))
+		return 0;
+
+	flow_rule_match_meta(rule, &match);
+	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex mask");
+		return -EINVAL;
+	}
+
+	ingress_dev = __dev_get_by_index(dev_net(filter_dev),
+					 match.key->ingress_ifindex);
+	if (!ingress_dev) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can't find the ingress port to match on");
+		return -EINVAL;
+	}
+
+	if (ingress_dev != filter_dev) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Can't match on the ingress filter port");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int __parse_cls_flower(struct mlx5e_priv *priv,
 			      struct mlx5_flow_spec *spec,
 			      struct flow_cls_offload *f,
@@ -1822,6 +1856,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 	u16 addr_type = 0;
 	u8 ip_proto = 0;
 	u8 *match_level;
+	int err;
 
 	match_level = outer_match_level;
 
@@ -1865,6 +1900,10 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 						    spec);
 	}
 
+	err = mlx5e_flower_parse_meta(filter_dev, f);
+	if (err)
+		return err;
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
 		struct flow_match_basic match;
 
-- 
1.8.3.1

