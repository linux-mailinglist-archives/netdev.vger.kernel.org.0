Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70BC3743D1
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbhEEQwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:52:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235933AbhEEQsk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:48:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46AF861949;
        Wed,  5 May 2021 16:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232625;
        bh=DNyrzPIYnIKT/yacSx+rHOBrxPl3lZ0BfgEYN9f/8NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGVIk2uD5+42xfhc1Q4I4wYejdkMH2IreVX72JAUY4n0w53RNQ9tbpZOT41VSkzvo
         8bDapXpAPeFwGRv6+lMZFAKCzr7/UKlnEZ1IaxZ5Cdw/8FgZ91kLiLQ5g/LAKFziDr
         dM+bE7MUQmwN1FzIyu8AGy8piUeXfMLrNzzFLqwx7cWOVldDAwl+3DPj57TWDwGVF1
         LZYkhNuY0ay4yp1S/adV7yeaB+Hz0C8Xw7jc1xIICwLkGlYFrh82bYw0oe7T2pODGi
         HaUxiFi2kxIoJb4AZ1qbg1GYUt5rUgyiKxE6mVpY+P3wnFsn3npYHymL/mwpHqGD2C
         ErZHzB1PAb9ew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/85] Documentation: networking: switchdev: fix command for static FDB entries
Date:   Wed,  5 May 2021 12:35:34 -0400
Message-Id: <20210505163648.3462507-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 787a4109f46847975ffae7d528a55c6b768ef0aa ]

The "bridge fdb add" command provided in the switchdev documentation is
junk now, not only because it is syntactically incorrect and rejected by
the iproute2 bridge program, but also because it was not updated in
light of Arkadi Sharshevsky's radical switchdev refactoring in commit
29ab586c3d83 ("net: switchdev: Remove bridge bypass support from
switchdev"). Try to explain what the intended usage pattern is with the
new kernel implementation.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/switchdev.rst | 47 +++++++++++++++++++-------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/Documentation/networking/switchdev.rst b/Documentation/networking/switchdev.rst
index ddc3f35775dc..650553cdec79 100644
--- a/Documentation/networking/switchdev.rst
+++ b/Documentation/networking/switchdev.rst
@@ -181,18 +181,41 @@ To offloading L2 bridging, the switchdev driver/device should support:
 Static FDB Entries
 ^^^^^^^^^^^^^^^^^^
 
-The switchdev driver should implement ndo_fdb_add, ndo_fdb_del and ndo_fdb_dump
-to support static FDB entries installed to the device.  Static bridge FDB
-entries are installed, for example, using iproute2 bridge cmd::
-
-	bridge fdb add ADDR dev DEV [vlan VID] [self]
-
-The driver should use the helper switchdev_port_fdb_xxx ops for ndo_fdb_xxx
-ops, and handle add/delete/dump of SWITCHDEV_OBJ_ID_PORT_FDB object using
-switchdev_port_obj_xxx ops.
-
-XXX: what should be done if offloading this rule to hardware fails (for
-example, due to full capacity in hardware tables) ?
+A driver which implements the ``ndo_fdb_add``, ``ndo_fdb_del`` and
+``ndo_fdb_dump`` operations is able to support the command below, which adds a
+static bridge FDB entry::
+
+        bridge fdb add dev DEV ADDRESS [vlan VID] [self] static
+
+(the "static" keyword is non-optional: if not specified, the entry defaults to
+being "local", which means that it should not be forwarded)
+
+The "self" keyword (optional because it is implicit) has the role of
+instructing the kernel to fulfill the operation through the ``ndo_fdb_add``
+implementation of the ``DEV`` device itself. If ``DEV`` is a bridge port, this
+will bypass the bridge and therefore leave the software database out of sync
+with the hardware one.
+
+To avoid this, the "master" keyword can be used::
+
+        bridge fdb add dev DEV ADDRESS [vlan VID] master static
+
+The above command instructs the kernel to search for a master interface of
+``DEV`` and fulfill the operation through the ``ndo_fdb_add`` method of that.
+This time, the bridge generates a ``SWITCHDEV_FDB_ADD_TO_DEVICE`` notification
+which the port driver can handle and use it to program its hardware table. This
+way, the software and the hardware database will both contain this static FDB
+entry.
+
+Note: for new switchdev drivers that offload the Linux bridge, implementing the
+``ndo_fdb_add`` and ``ndo_fdb_del`` bridge bypass methods is strongly
+discouraged: all static FDB entries should be added on a bridge port using the
+"master" flag. The ``ndo_fdb_dump`` is an exception and can be implemented to
+visualize the hardware tables, if the device does not have an interrupt for
+notifying the operating system of newly learned/forgotten dynamic FDB
+addresses. In that case, the hardware FDB might end up having entries that the
+software FDB does not, and implementing ``ndo_fdb_dump`` is the only way to see
+them.
 
 Note: by default, the bridge does not filter on VLAN and only bridges untagged
 traffic.  To enable VLAN support, turn on VLAN filtering::
-- 
2.30.2

