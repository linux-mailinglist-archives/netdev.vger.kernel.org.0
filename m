Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7DE8E0AE7
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 19:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730305AbfJVRn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 13:43:29 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55864 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732302AbfJVRn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 13:43:27 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yuvalav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Oct 2019 19:43:21 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (sw-mtx-008.mtx.labs.mlnx [10.9.150.35])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9MHhKsW005583;
        Tue, 22 Oct 2019 20:43:20 +0300
Received: from sw-mtx-008.mtx.labs.mlnx (localhost [127.0.0.1])
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7) with ESMTP id x9MHhKos023989;
        Tue, 22 Oct 2019 20:43:20 +0300
Received: (from yuvalav@localhost)
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7/Submit) id x9MHhJ7T023988;
        Tue, 22 Oct 2019 20:43:19 +0300
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        shuah@kernel.org, Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next 5/9] devlink: Support vdev HW address set
Date:   Tue, 22 Oct 2019 20:43:06 +0300
Message-Id: <1571766190-23943-6-git-send-email-yuvalav@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow privileged user to set the HW address of a vdev.

Example:

$ devlink vdev set pci/0000:03:00.0/1 hw_addr 00:23:35:af:35:34

$ devlink vdev show pci/0000:03:00.0/1
pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0 port_index 1 hw_addr 00:23:35:af:35:34

$ devlink vdev show pci/0000:03:00.0/1 -pj
{
    "vdev": {
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
index 12550cc92e9d..5ae329813ec8 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -765,6 +765,8 @@ struct devlink_ops {
 };
 
 struct devlink_vdev_ops {
+	int (*hw_addr_set)(struct devlink_vdev *vdev,
+			   u8 *hw_addr, struct netlink_ext_ack *extack);
 	int (*hw_addr_get)(struct devlink_vdev *vdev,
 			   u8 *hw_addr, struct netlink_ext_ack *extack);
 	unsigned int hw_addr_len;
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 94599409f12c..15cc674b05ce 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1063,6 +1063,23 @@ static int devlink_nl_cmd_vdev_get_dumpit(struct sk_buff *msg,
 static int devlink_nl_cmd_vdev_set_doit(struct sk_buff *skb,
 					struct genl_info *info)
 {
+	struct nlattr *nla_hw_addr = info->attrs[DEVLINK_ATTR_VDEV_HW_ADDR];
+	struct devlink_vdev *devlink_vdev = info->user_ptr[0];
+	const struct devlink_vdev_ops *ops;
+	int err;
+
+	ops = devlink_vdev->ops;
+	if (nla_hw_addr) {
+		u8 *hw_addr;
+
+		if (!ops || !ops->hw_addr_set)
+			return -EOPNOTSUPP;
+
+		hw_addr = nla_data(nla_hw_addr);
+		err = ops->hw_addr_set(devlink_vdev, hw_addr, info->extack);
+		if (err)
+			return err;
+	}
 	return 0;
 }
 
-- 
2.17.1

