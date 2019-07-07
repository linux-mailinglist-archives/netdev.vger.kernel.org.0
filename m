Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98B016144C
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 09:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfGGH7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 03:59:53 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:35549 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfGGH7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 03:59:52 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 17B7426BA;
        Sun,  7 Jul 2019 03:59:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 03:59:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=epTN4h+lk0G5dF79hvEeB9l+4EUUUzVJZSkNKrqt0vw=; b=HUPNaSyF
        HVuyfbDv7uq7p/jTP7hBkqV5ftKI146Aw3vVtiJvbj2Pcb9NIzDJETQgxggJVT8x
        w63zSuI2+4H3hMjSBVRT5etMmpbhROb3B6FnqpQWlKRHOyonIcrFoau4jw7eN9T9
        pqDaaE9Wz4cIBAxIKYAW/qNgr21WjoaMK2CWqWEWJjkVSK+3IOUvoVgBaSqbk5+A
        pxOlqN3vTQdPDRlVfWobL5K3uYAX41TmCta2Z8cGJHYgQQAEcs6hdsc2xceQzmXw
        mLKQDl2vYe5GX1p9IcgzE4kxwQYLgg6Wi27X1S23MXArgzCkhY0ZwUvAOaYUIbj8
        /65PaJvbiGLgyA==
X-ME-Sender: <xms:d6YhXf6fWqlKGeZa2HklGRt5VC_itYBBEEZS8gGcJw4gl_oraiN5Xw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:d6YhXcEyNxomQnZryENfB0BfrjiCgcB9ghfTYyXpLCrZSfIvQefmOQ>
    <xmx:d6YhXYsFONSo-_dG-HEhTaAFYkD9R5cbfGuyqiU3_AGoCNJqQsA6Dw>
    <xmx:d6YhXY-W35-2QZt-EPDwRRscjENrMN5FhS8EZTZqd48xbHjpGdIXOg>
    <xmx:eKYhXVhuQJRwFqB_jAHswVuIUKvE0ALNUk-_nsUM_pRdN1vQg_jL-A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 73603380075;
        Sun,  7 Jul 2019 03:59:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/11] devlink: Create helper to fill port type information
Date:   Sun,  7 Jul 2019 10:58:18 +0300
Message-Id: <20190707075828.3315-2-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707075828.3315-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The function that fills port attributes in a netlink message fills the
port type attributes together with other attributes such as the device
handle.

The port type attributes will also need to be filled for trapped packets
by a subsequent patch.

Prevent code duplication and create a helper that can be used from both
places.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 49 +++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 89c533778135..755a9a32015e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -527,6 +527,33 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 	return 0;
 }
 
+static int devlink_nl_port_type_fill(struct sk_buff *msg,
+				     const struct devlink_port *devlink_port)
+{
+	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_TYPE, devlink_port->type))
+		return -EMSGSIZE;
+
+	if (devlink_port->type == DEVLINK_PORT_TYPE_ETH) {
+		struct net_device *netdev = devlink_port->type_dev;
+
+		if (netdev &&
+		    (nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX,
+				 netdev->ifindex) ||
+		     nla_put_string(msg, DEVLINK_ATTR_PORT_NETDEV_NAME,
+				    netdev->name)))
+			return -EMSGSIZE;
+	} else if (devlink_port->type == DEVLINK_PORT_TYPE_IB) {
+		struct ib_device *ibdev = devlink_port->type_dev;
+
+		if (ibdev &&
+		    nla_put_string(msg, DEVLINK_ATTR_PORT_IBDEV_NAME,
+				   ibdev->name))
+			return -EMSGSIZE;
+	}
+
+	return 0;
+}
+
 static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devlink,
 				struct devlink_port *devlink_port,
 				enum devlink_command cmd, u32 portid,
@@ -544,30 +571,12 @@ static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devlink,
 		goto nla_put_failure;
 
 	spin_lock(&devlink_port->type_lock);
-	if (nla_put_u16(msg, DEVLINK_ATTR_PORT_TYPE, devlink_port->type))
-		goto nla_put_failure_type_locked;
 	if (devlink_port->desired_type != DEVLINK_PORT_TYPE_NOTSET &&
 	    nla_put_u16(msg, DEVLINK_ATTR_PORT_DESIRED_TYPE,
 			devlink_port->desired_type))
 		goto nla_put_failure_type_locked;
-	if (devlink_port->type == DEVLINK_PORT_TYPE_ETH) {
-		struct net_device *netdev = devlink_port->type_dev;
-
-		if (netdev &&
-		    (nla_put_u32(msg, DEVLINK_ATTR_PORT_NETDEV_IFINDEX,
-				 netdev->ifindex) ||
-		     nla_put_string(msg, DEVLINK_ATTR_PORT_NETDEV_NAME,
-				    netdev->name)))
-			goto nla_put_failure_type_locked;
-	}
-	if (devlink_port->type == DEVLINK_PORT_TYPE_IB) {
-		struct ib_device *ibdev = devlink_port->type_dev;
-
-		if (ibdev &&
-		    nla_put_string(msg, DEVLINK_ATTR_PORT_IBDEV_NAME,
-				   ibdev->name))
-			goto nla_put_failure_type_locked;
-	}
+	if (devlink_nl_port_type_fill(msg, devlink_port))
+		goto nla_put_failure_type_locked;
 	spin_unlock(&devlink_port->type_lock);
 	if (devlink_nl_port_attrs_put(msg, devlink_port))
 		goto nla_put_failure;
-- 
2.20.1

