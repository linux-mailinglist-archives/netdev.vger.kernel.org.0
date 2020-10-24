Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D6E297C9C
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 15:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761760AbgJXNiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 09:38:10 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:42543 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1761751AbgJXNiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Oct 2020 09:38:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 4C2B1CB4;
        Sat, 24 Oct 2020 09:38:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 24 Oct 2020 09:38:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=MQSD4PTUAQFUEciJle/Z0kLfBHVMsCQWy8FD5L0+4AQ=; b=d0FwmaQs
        GwMMffayKZ5GrgmcnTjpR2TreaBHNTIsTQzVlmvuOl5TcgFsVu+GmCOpXv3czkh5
        hLuS9xMfMyF6PLyRBgtWFxyFxJ7mANwhptqFme57c4M2zKh9LgOjMWHxR7KGKuXf
        xZ7DULWQc7sOVzcSrSB2pOeQJDNRtwKPsK6BMCwwShVBt3ltyoUr3NwTSlDoADa/
        nR7XRMHCuIJAQW17mtxRKsHQUS4FkdiDzMPDBvBvDo3CK/5usrURFrIvPcvg1BfZ
        W79eBf/jHVjBRM9c0+DY0V2gLBWFdxNydQQU52K+0OxMN7TScTX4P8qBk/VSg4T8
        jYePX262rChf4w==
X-ME-Sender: <xms:PS6UX0vhNsH1s2VDPCSbiHdr19Uyt6I5BCp_dRlifVhes6V_638baA>
    <xme:PS6UXxdr4ZUqNh3rc6drYq7vVUIjA9js0sYs38PoT9_uEkNdOc6mykQqJCK89HBFL
    tpNlYZ_TOCGXcI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrvddvkeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:PS6UX_yaxfmf86KDsTFgQ3u49jT4c4y81dzrII-lzzFucsf9HUojJg>
    <xmx:PS6UX3PRlI-mxJRezif1oRBdap10iy9Wut4BCITqKm8nm55WDf0jmQ>
    <xmx:PS6UX09E0uJzJwgMMnJjNr_io_gDparCiwZByQ8IRIWF0urYTEk7DQ>
    <xmx:PS6UXza7lEJF4zQyW1z-tiHXPwpgZd98Gg-nASqVxIkMYJ7HnwKRIw>
Received: from shredder.mtl.com (igld-84-229-37-228.inter.net.il [84.229.37.228])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8296B3280060;
        Sat, 24 Oct 2020 09:38:04 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 2/3] mlxsw: core: Fix memory leak on module removal
Date:   Sat, 24 Oct 2020 16:37:32 +0300
Message-Id: <20201024133733.2107509-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201024133733.2107509-1-idosch@idosch.org>
References: <20201024133733.2107509-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Free the devlink instance during the teardown sequence in the non-reload
case to avoid the following memory leak.

unreferenced object 0xffff888232895000 (size 2048):
  comm "modprobe", pid 1073, jiffies 4295568857 (age 164.871s)
  hex dump (first 32 bytes):
    00 01 00 00 00 00 ad de 22 01 00 00 00 00 ad de  ........".......
    10 50 89 32 82 88 ff ff 10 50 89 32 82 88 ff ff  .P.2.....P.2....
  backtrace:
    [<00000000c704e9a6>] __kmalloc+0x13a/0x2a0
    [<00000000ee30129d>] devlink_alloc+0xff/0x760
    [<0000000092ab3e5d>] 0xffffffffa042e5b0
    [<000000004f3f8a31>] 0xffffffffa042f6ad
    [<0000000092800b4b>] 0xffffffffa0491df3
    [<00000000c4843903>] local_pci_probe+0xcb/0x170
    [<000000006993ded7>] pci_device_probe+0x2c2/0x4e0
    [<00000000a8e0de75>] really_probe+0x2c5/0xf90
    [<00000000d42ba75d>] driver_probe_device+0x1eb/0x340
    [<00000000bcc95e05>] device_driver_attach+0x294/0x300
    [<000000000e2bc177>] __driver_attach+0x167/0x2f0
    [<000000007d44cd6e>] bus_for_each_dev+0x148/0x1f0
    [<000000003cd5a91e>] driver_attach+0x45/0x60
    [<000000000041ce51>] bus_add_driver+0x3b8/0x720
    [<00000000f5215476>] driver_register+0x230/0x4e0
    [<00000000d79356f5>] __pci_register_driver+0x190/0x200

Fixes: a22712a96291 ("mlxsw: core: Fix devlink unregister flow")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reported-by: Vadim Pasternak <vadimp@nvidia.com>
Tested-by: Oleksandr Shamray <oleksandrs@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 7f77c2a71d1c..a2efbb1e3cf4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2064,6 +2064,8 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 	if (!reload)
 		devlink_resources_unregister(devlink, NULL);
 	mlxsw_core->bus->fini(mlxsw_core->bus_priv);
+	if (!reload)
+		devlink_free(devlink);
 
 	return;
 
-- 
2.26.2

