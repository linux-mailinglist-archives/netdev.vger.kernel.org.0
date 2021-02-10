Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B3D31684E
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 14:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhBJNus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 08:50:48 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15533 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbhBJNuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 08:50:39 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6023e4620000>; Wed, 10 Feb 2021 05:49:22 -0800
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 10 Feb
 2021 13:49:22 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 10 Feb 2021 13:49:20 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mkubecek@suse.cz>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <andrew@lunn.ch>, <mlxsw@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH ethtool v3 3/5] netlink: settings: Expose the number of lanes in use
Date:   Wed, 10 Feb 2021 15:48:38 +0200
Message-ID: <20210210134840.2187696-4-danieller@nvidia.com>
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
        t=1612964962; bh=zO/7Ow2N5qOqLq/7Pqs3P1b1ygTD0xz9CPJyoSVKLis=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=JVDZ55bMhO6N+vG3QClT/TuUmAc+zKJR0PyVu+As5+EEA3Gx5atzKCttk3GVP8Pu7
         eiyHJdPC0UkwWscWMMKwuEwuSVS13xrC7ryBdjg8v44fih/BhI2kYN3LRXvazH5w9z
         XxV3Ta951IW2B4BlUz8LrjsFcOlhWQUpVKxV1pSv6UvGqSQQYlfWQnAWCSjBbl945i
         8tsz/YJaHuqENQKBhga7Gy8Hg871S/L7gWIh6xbd+uJl5ql1F/M5uNFazTuduIFeLp
         sxnJUrsAyP1ykAxtyUWhqwLMxdeoEHA1UcwpmLya15n4fduYem2rZz5KjvqD8mffu6
         KUlv0Y6M1VPcw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the user does not have the information regarding how many lanes
are used when the link is up.

After adding a possibility to advertise or force a specific number of
lanes this information becomes helpful.

Expose the number of lanes in use if the information is passed from
kernel.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---

Notes:
    v2:
        	* Remove possibility for printing unknown lanes, as now unknown
        	  lanes attribute doesn't pass to netlink.

 netlink/settings.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/netlink/settings.c b/netlink/settings.c
index c54fe56..e47a38f 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -473,6 +473,12 @@ int linkmodes_reply_cb(const struct nlmsghdr *nlhdr, v=
oid *data)
 		else
 			printf("\tSpeed: %uMb/s\n", val);
 	}
+	if (tb[ETHTOOL_A_LINKMODES_LANES]) {
+		uint32_t val =3D mnl_attr_get_u32(tb[ETHTOOL_A_LINKMODES_LANES]);
+
+		print_banner(nlctx);
+		printf("\tLanes: %u\n", val);
+	}
 	if (tb[ETHTOOL_A_LINKMODES_DUPLEX]) {
 		uint8_t val =3D mnl_attr_get_u8(tb[ETHTOOL_A_LINKMODES_DUPLEX]);
=20
--=20
2.26.2

