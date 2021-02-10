Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C565A31684B
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 14:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhBJNuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 08:50:12 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15462 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhBJNuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 08:50:01 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6023e4600000>; Wed, 10 Feb 2021 05:49:20 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 13:49:19 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 10 Feb 2021 13:49:17 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mkubecek@suse.cz>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <andrew@lunn.ch>, <mlxsw@nvidia.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: [PATCH ethtool v3 2/5] netlink: settings: Add netlink support for lanes parameter
Date:   Wed, 10 Feb 2021 15:48:37 +0200
Message-ID: <20210210134840.2187696-3-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210134840.2187696-1-danieller@nvidia.com>
References: <20210210134840.2187696-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612964960; bh=o3097n6D5EINUTBOgkzGiaYjcMwEHJdZnEKSiAyDcMM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=cQqm7JX94aPXmuuDLkXhbkvf5yvkIx8v4J0hrW1bXlKUDAJL9UrijMyFp7DPGtKZz
         zoDNaSctubVAVaXQrgnTvwh6+FSOi1KwoZI9alW6xW5nK5IMZm1yWJMRUCCEBGyut8
         UTrsYcTugGx4DRvSoaj7IB6YPm0nC592zSoqcktT5U2lpNdEPtDgYWLKUeBkTogLPC
         Z+Gi2/zeZ7ZRA+sokwhbB9cGW27pkndZO0bUzXCICRh6bLIFYs1D/RZSVB2RB4vkN7
         KbSYeok8wfOpuC12LLMAju0oEyTfOUOJuhZcLJ0hkdbgJI8mdub9+sYPJryBlFNc2E
         9jfjr/PigONng==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

Add support for "ethtool -s <dev> lanes N ..." for setting a specific
number of lanes.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
---

Notes:
    v3:
    	* Remove a leftover.
    	* After adding a seperated patch for uapi headers, squash rest of
    	  the first patch.

 ethtool.c              | 1 +
 netlink/desc-ethtool.c | 1 +
 netlink/settings.c     | 7 +++++++
 3 files changed, 9 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index fb90e9e..a8339c8 100644
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
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index 96291b9..fe5d7ba 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -87,6 +87,7 @@ static const struct pretty_nla_desc __linkmodes_desc[] =
=3D {
 	NLATTR_DESC_U8(ETHTOOL_A_LINKMODES_DUPLEX),
 	NLATTR_DESC_U8(ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG),
 	NLATTR_DESC_U8(ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE),
+	NLATTR_DESC_U32(ETHTOOL_A_LINKMODES_LANES),
 };
=20
 static const struct pretty_nla_desc __linkstate_desc[] =3D {
diff --git a/netlink/settings.c b/netlink/settings.c
index 90c28b1..c54fe56 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -1067,6 +1067,13 @@ static const struct param_parser sset_params[] =3D {
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

