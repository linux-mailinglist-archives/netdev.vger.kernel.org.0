Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7071F1E86C5
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgE2ShZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:37:25 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41955 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727094AbgE2ShX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:37:23 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id D6BB05C00B1;
        Fri, 29 May 2020 14:37:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 29 May 2020 14:37:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=iVnbMSLCBscquGRsD/83y/jKMbzqhJYcpctoFkynl0Q=; b=GQKP03pj
        7URh6b0PVf6jI503yuTiIpwb6sl8YmvVUEKdi9EqXm1bJmFbOUkR+YWRcK5eDtNA
        EE9kRAhu4S3u13qwxR/gpmK737PDEIaO/gwzXbuuELvy42JFd61ssMJ2iVPytLGn
        bLd8lxi3R/6a+QUJVfnl3HYcXax3KNIplT83G6wksmLjQBLzy78Il/l8OwGFC04w
        IWZuO8yy5r8ell+V+nIqyfLLq43NUP7SjotTxcBJYXykCg281TGXQtS5CzP9wVwT
        twRbTl5LH3EC6B/biVhNt3x915P/k6WQuCOCJPzSNJlWwu0UHMy7d+I13FMFOVO5
        J0HGqM35FGBeKQ==
X-ME-Sender: <xms:YlbRXuAnNgyhcNC1I2HMJmtuEHN2dpyA0-_CSuoVWo6CJU3zFHL_Xw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvkedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddujeeirddvgedruddt
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:YlbRXohWWCWP7Z7rlcvOqqmWYeadY1Nfj31DRYWm9J6Gr7DUZkYXLQ>
    <xmx:YlbRXhlgG_H2fRtvgQnkeM9QPfrQ75IUD3cqmhcbZ1_wC3oxBk3aSA>
    <xmx:YlbRXszM7crTndTAZ-fZsiXmexRzVT2fJx43NNGw-nvcko2yZJpIjQ>
    <xmx:YlbRXqIlrUOibXUnZOACXtBbtxbHkmIMlVMgySQ0aY66SNDjZbXODg>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A693E3060F09;
        Fri, 29 May 2020 14:37:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 01/14] devlink: Create dedicated trap group for layer 3 exceptions
Date:   Fri, 29 May 2020 21:36:36 +0300
Message-Id: <20200529183649.1602091-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529183649.1602091-1-idosch@idosch.org>
References: <20200529183649.1602091-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Packets that hit exceptions during layer 3 forwarding must be trapped to
the CPU for the control plane to function properly. Create a dedicated
group for them, so that user space could choose to assign a different
policer for them.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 Documentation/networking/devlink/devlink-trap.rst | 7 +++++--
 include/net/devlink.h                             | 3 +++
 net/core/devlink.c                                | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index fe089acb7783..4ca241e70064 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -277,8 +277,11 @@ narrow. The description of these groups must be added to the following table:
      - Contains packet traps for packets that were dropped by the device during
        layer 2 forwarding (i.e., bridge)
    * - ``l3_drops``
-     - Contains packet traps for packets that were dropped by the device or hit
-       an exception (e.g., TTL error) during layer 3 forwarding
+     - Contains packet traps for packets that were dropped by the device during
+       layer 3 forwarding
+   * - ``l3_exceptions``
+     - Contains packet traps for packets that hit an exception (e.g., TTL
+       error) during layer 3 forwarding
    * - ``buffer_drops``
      - Contains packet traps for packets that were dropped by the device due to
        an enqueue decision
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8ffc1b5cd89b..851388c9d795 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -657,6 +657,7 @@ enum devlink_trap_generic_id {
 enum devlink_trap_group_generic_id {
 	DEVLINK_TRAP_GROUP_GENERIC_ID_L2_DROPS,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_L3_DROPS,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_L3_EXCEPTIONS,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_BUFFER_DROPS,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_TUNNEL_DROPS,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_ACL_DROPS,
@@ -730,6 +731,8 @@ enum devlink_trap_group_generic_id {
 	"l2_drops"
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_L3_DROPS \
 	"l3_drops"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_L3_EXCEPTIONS \
+	"l3_exceptions"
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_BUFFER_DROPS \
 	"buffer_drops"
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_TUNNEL_DROPS \
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7b76e5fffc10..d9fff7083f02 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8505,6 +8505,7 @@ static const struct devlink_trap devlink_trap_generic[] = {
 static const struct devlink_trap_group devlink_trap_group_generic[] = {
 	DEVLINK_TRAP_GROUP(L2_DROPS),
 	DEVLINK_TRAP_GROUP(L3_DROPS),
+	DEVLINK_TRAP_GROUP(L3_EXCEPTIONS),
 	DEVLINK_TRAP_GROUP(BUFFER_DROPS),
 	DEVLINK_TRAP_GROUP(TUNNEL_DROPS),
 	DEVLINK_TRAP_GROUP(ACL_DROPS),
-- 
2.26.2

