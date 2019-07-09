Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFE5A62F43
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 06:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfGIERu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 00:17:50 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41261 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727305AbfGIERu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 00:17:50 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 9 Jul 2019 07:17:46 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x694Hffi007381;
        Tue, 9 Jul 2019 07:17:45 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com,
        jakub.kicinski@netronome.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next v6 2/5] devlink: Return physical port fields only for applicable port flavours
Date:   Mon,  8 Jul 2019 23:17:36 -0500
Message-Id: <20190709041739.44292-3-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190709041739.44292-1-parav@mellanox.com>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190709041739.44292-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Physical port number and split group fields are applicable only to
physical port flavours such as PHYSICAL, CPU and DSA.
Hence limit returning those values in netlink response to such port
flavours.

Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 net/core/devlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index eacaf37b5108..a9c4e5d8a99c 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -515,6 +515,10 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 		return 0;
 	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_FLAVOUR, attrs->flavour))
 		return -EMSGSIZE;
+	if (devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_PHYSICAL &&
+	    devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_CPU &&
+	    devlink_port->attrs.flavour != DEVLINK_PORT_FLAVOUR_DSA)
+		return 0;
 	if (nla_put_u32(msg, DEVLINK_ATTR_PORT_NUMBER,
 			attrs->phys.port_number))
 		return -EMSGSIZE;
-- 
2.19.2

