Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBE8177883
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 15:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgCCONA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 09:13:00 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41649 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726368AbgCCONA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 09:13:00 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 3 Mar 2020 16:12:56 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 023ECqq4022152;
        Tue, 3 Mar 2020 16:12:54 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     parav@mellanox.com, jiri@mellanox.com, moshe@mellanox.com,
        vladyslavt@mellanox.com, saeedm@mellanox.com, leon@kernel.org
Subject: [PATCH net-next 1/2] devlink: Introduce devlink port flavour virtual
Date:   Tue,  3 Mar 2020 08:12:42 -0600
Message-Id: <20200303141243.7608-2-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200303141243.7608-1-parav@mellanox.com>
References: <20200303141243.7608-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently mlx5 PCI PF and VF devlink devices register their ports as
physical port in non-representors mode.

Introduce a new port flavour as virtual so that virtual devices can
register 'virtual' flavour to make it more clear to users.

An example of one PCI PF and 2 PCI virtual functions, each having
one devlink port.

$ devlink port show
pci/0000:06:00.0/1: type eth netdev ens2f0 flavour physical port 0
pci/0000:06:00.2/1: type eth netdev ens2f2 flavour virtual port 0
pci/0000:06:00.3/1: type eth netdev ens2f3 flavour virtual port 0

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 include/uapi/linux/devlink.h | 1 +
 net/core/devlink.c           | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index be2a2948f452..dfdffc42e87d 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -187,6 +187,7 @@ enum devlink_port_flavour {
 				      * for the PCI VF. It is an internal
 				      * port that faces the PCI VF.
 				      */
+	DEVLINK_PORT_FLAVOUR_VIRTUAL, /* Any virtual port facing the user. */
 };
 
 enum devlink_param_cmode {
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 231b18d6310c..20a0e1b5e04b 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -545,6 +545,7 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
 	case DEVLINK_PORT_FLAVOUR_CPU:
 	case DEVLINK_PORT_FLAVOUR_DSA:
+	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
 		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER,
 				attrs->phys.port_number))
 			return -EMSGSIZE;
@@ -6807,6 +6808,7 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 
 	switch (attrs->flavour) {
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
+	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
 		if (!attrs->split)
 			n = snprintf(name, len, "p%u", attrs->phys.port_number);
 		else
-- 
2.19.2

