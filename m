Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 457AAF50E2
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfKHQTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:19:07 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60302 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727558AbfKHQTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 11:19:06 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yuvalav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Nov 2019 18:19:03 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (sw-mtx-008.mtx.labs.mlnx [10.9.150.35])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA8GJ1dU003203;
        Fri, 8 Nov 2019 18:19:02 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (localhost [127.0.0.1])
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7) with ESMTP id xA8GJ1Cq030098;
        Fri, 8 Nov 2019 18:19:01 +0200
Received: (from yuvalav@localhost)
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7/Submit) id xA8GJ1ed030097;
        Fri, 8 Nov 2019 18:19:01 +0200
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        shuah@kernel.org, danielj@mellanox.com, parav@mellanox.com,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next v2 05/10] devlink: Support subdev HW address set
Date:   Fri,  8 Nov 2019 18:18:41 +0200
Message-Id: <1573229926-30040-6-git-send-email-yuvalav@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
References: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow privileged user to set the HW address of a subdev.

Example:

$ devlink subdev set pci/0000:03:00.0/1 hw_addr 00:23:35:af:35:34

$ devlink subdev show pci/0000:03:00.0/1
pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0 port_index 1 hw_addr 00:23:35:af:35:34

$ devlink subdev show pci/0000:03:00.0/1 -pj
{
    "subdev": {
        "pci/0000:03:00.0/1": {
            "flavour": "pcivf",
            "pf": 0,
            "vf": 0,
            "port_index": 1,
            "hw_addr": "00:23:35:af:35:34"
        }
    }
}

Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h |  2 ++
 net/core/devlink.c    | 17 +++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 5917260e5748..b2cd3505bba4 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -765,6 +765,8 @@ struct devlink_ops {
 };
 
 struct devlink_subdev_ops {
+	int (*hw_addr_set)(struct devlink_subdev *subdev,
+			   u8 *hw_addr, struct netlink_ext_ack *extack);
 	int (*hw_addr_get)(struct devlink_subdev *subdev,
 			   u8 *hw_addr, struct netlink_ext_ack *extack);
 	unsigned int hw_addr_len;
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7d6e3da8a64c..10867f82b7d3 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1067,6 +1067,23 @@ static int devlink_nl_cmd_subdev_get_dumpit(struct sk_buff *msg,
 static int devlink_nl_cmd_subdev_set_doit(struct sk_buff *skb,
 					  struct genl_info *info)
 {
+	struct nlattr *nla_hw_addr = info->attrs[DEVLINK_ATTR_SUBDEV_HW_ADDR];
+	struct devlink_subdev *devlink_subdev = info->user_ptr[0];
+	const struct devlink_subdev_ops *ops;
+	int err;
+
+	ops = devlink_subdev->ops;
+	if (nla_hw_addr) {
+		u8 *hw_addr;
+
+		if (!ops || !ops->hw_addr_set)
+			return -EOPNOTSUPP;
+
+		hw_addr = nla_data(nla_hw_addr);
+		err = ops->hw_addr_set(devlink_subdev, hw_addr, info->extack);
+		if (err)
+			return err;
+	}
 	return 0;
 }
 
-- 
2.17.1

