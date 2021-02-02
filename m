Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA5030C9C6
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238586AbhBBS2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:28:40 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11004 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238590AbhBBS01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:26:27 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6019991d0002>; Tue, 02 Feb 2021 10:25:33 -0800
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 2 Feb 2021 18:25:31 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mkubecek@suse.cz>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <andrew@lunn.ch>, <mlxsw@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH ethtool v2 2/5] netlink: settings: Add netlink support for lanes parameter
Date:   Tue, 2 Feb 2021 20:25:10 +0200
Message-ID: <20210202182513.325864-3-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210202182513.325864-1-danieller@nvidia.com>
References: <20210202182513.325864-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612290333; bh=4yo+lPM3qtXm6SBubwf13EIprAXPgGk4BZQNGBP+YUM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=HUBOCAbf4twbTxx/De35kuJ+tYh120gpgr3+ZajVaRQedr37CCRPgPEvzJyYnSAt1
         TaEwEg/mJ3bLFvrc5b4V3dDl+oOFSsQVQnxOECkCgvA0sbNqxewyBnb2fdBeJIMsMn
         X7/9LpsGzUJ0pFD/k1t9LT0QVCnPi1qo1sdlFiuAE5q0qoOAlHXMOtUzdLF4kF8jVm
         WYfsWr8ogJhBTktJqhkZUqWE3VUOPQWI70fzetnVYBWhhqRNNeraUsmHm8DrNJ11Pg
         CaEUv8qYRFlqGj/6rSo+itj0bIa2QE21nHqd0gBUDevgHGb5jN2tp9gvs/ssjjkjnT
         290XmJSV0Dvpg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for "ethtool -s <dev> lanes N ..." for setting a specific
number of lanes.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 ethtool.c          | 1 +
 netlink/settings.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index 585aafa..fcb09f7 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5620,6 +5620,7 @@ static const struct option args[] =3D {
 		.nlfunc	=3D nl_sset,
 		.help	=3D "Change generic options",
 		.xhelp	=3D "		[ speed %d ]\n"
+			  "		[ lanes %d ]\n"
 			  "		[ duplex half|full ]\n"
 			  "		[ port tp|aui|bnc|mii|fibre|da ]\n"
 			  "		[ mdix auto|on|off ]\n"
diff --git a/netlink/settings.c b/netlink/settings.c
index 90c28b1..6cb5d5b 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -20,6 +20,7 @@
 struct link_mode_info {
 	enum link_mode_class	class;
 	u32			speed;
+	u32			lanes;
 	u8			duplex;
 };
=20
@@ -1067,6 +1068,13 @@ static const struct param_parser sset_params[] =3D {
 		.handler	=3D nl_parse_direct_u32,
 		.min_argc	=3D 1,
 	},
+	{
+		.arg		=3D "lanes",
+		.group		=3D ETHTOOL_MSG_LINKMODES_SET,
+		.type		=3D ETHTOOL_A_LINKMODES_LANES,
+		.handler	=3D nl_parse_direct_u32,
+		.min_argc	=3D 1,
+	},
 	{
 		.arg		=3D "duplex",
 		.group		=3D ETHTOOL_MSG_LINKMODES_SET,
--=20
2.26.2

