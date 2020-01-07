Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDC5132205
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 10:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbgAGJQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 04:16:09 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:52787 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbgAGJQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 04:16:09 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id E47CE5C1C3D;
        Tue,  7 Jan 2020 17:16:06 +0800 (CST)
From:   wenxu@ucloud.cn
To:     paulb@mellanox.com, saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2] net/mlx5e: Add mlx5e_flower_parse_meta support
Date:   Tue,  7 Jan 2020 17:16:06 +0800
Message-Id: <1578388566-27310-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJQ09CQkJDT0xPSklKSllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PRQ6MBw5MTg3PD8YHRJRCRwC
        CQgKCjVVSlVKTkxDSENDTk1MTEpIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhMSko3Bg++
X-HM-Tid: 0a6f7f4a33dd2087kuqye47ce5c1c3d
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

In the flowtables offload all the devices in the flowtables
share the same flow_block. An offload rule will be installed on
all the devices. This scenario is not correct.

It is no problem if there are only two devices in the flowtable,
The rule with ingress and egress on the same device can be reject
by driver.

But more than two devices in the flowtable will install the wrong
rules on hardware.

For example:
Three devices in a offload flowtables: dev_a, dev_b, dev_c

A rule ingress from dev_a and egress to dev_b:
The rule will install on device dev_a.
The rule will try to install on dev_b but failed for ingress
and egress on the same device.
The rule will install on dev_c. This is not correct.

The flowtables offload avoid this case through restricting the ingress dev
with FLOW_DISSECTOR_KEY_META as following patch.
http://patchwork.ozlabs.org/patch/1218109/

So the mlx5e driver also should support the FLOW_DISSECTOR_KEY_META parse.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v2: remap the patch description

 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 39 +++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 9b32a9c..33d1ce5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1805,6 +1805,40 @@ static void *get_match_headers_value(u32 flags,
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
@@ -1825,6 +1859,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 	u16 addr_type = 0;
 	u8 ip_proto = 0;
 	u8 *match_level;
+	int err;
 
 	match_level = outer_match_level;
 
@@ -1868,6 +1903,10 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
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

