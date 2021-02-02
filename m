Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0EF30C9C4
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238552AbhBBS23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:28:29 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5125 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238447AbhBBS01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:26:27 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6019991f0000>; Tue, 02 Feb 2021 10:25:35 -0800
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 2 Feb 2021 18:25:33 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mkubecek@suse.cz>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <andrew@lunn.ch>, <mlxsw@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH ethtool v2 3/5] netlink: settings: Expose the number of lanes in use
Date:   Tue, 2 Feb 2021 20:25:11 +0200
Message-ID: <20210202182513.325864-4-danieller@nvidia.com>
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
        t=1612290335; bh=O3XsYI9i7i57xnl0NhZMDMhMKO1byPD2KZ5poayi7KE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=NPhacdgisr2p77R53wdPuhlo/l37TSywxrgu48T0sIBSmbfba+85aXR1o5mzwkme+
         Eugn/09LMa3Q0pUYXGOJpSzkFHwBpxLtWOI1HkDlPI5Q5n0MxtCOYNS11H7SzVJuCw
         EOOZTIirADSrzvvsVoFfMS8l1NEBQ12Vv3hBPRiMSVPJ5W44xtRBvA7GUlZyvnpTQP
         eLL3T7c67WE0jUxvJnlMfFBYcgDN6cK7/uY5rRQkQ45QZvIq2+CvocFlQVVbfeylX5
         yDxYdqMW1yQT/gebzKlhW548lfzzVZzWiZIUzx3zXptAwGpWuyndikvLyER2DASlsp
         aJmRH5bL3n1OQ==
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
index 6cb5d5b..2ebe4c9 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -474,6 +474,12 @@ int linkmodes_reply_cb(const struct nlmsghdr *nlhdr, v=
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

