Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7652F619C9
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 06:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfGHEQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 00:16:00 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59639 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726238AbfGHEQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 00:16:00 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Jul 2019 07:15:57 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x684Fol6028463;
        Mon, 8 Jul 2019 07:15:55 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com,
        jakub.kicinski@netronome.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next v5 2/5] devlink: Return physical port fields only for applicable port flavours
Date:   Sun,  7 Jul 2019 23:15:46 -0500
Message-Id: <20190708041549.56601-3-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190708041549.56601-1-parav@mellanox.com>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190708041549.56601-1-parav@mellanox.com>
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

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 net/core/devlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index abe50a8e25c6..3e5f8204c36f 100644
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
 			attrs->physical.port_number))
 		return -EMSGSIZE;
-- 
2.19.2

