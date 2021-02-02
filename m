Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2582930C9C3
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238661AbhBBS2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:28:14 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5118 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238586AbhBBS01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:26:27 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6019991b0000>; Tue, 02 Feb 2021 10:25:31 -0800
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 2 Feb 2021 18:25:29 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mkubecek@suse.cz>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <andrew@lunn.ch>, <mlxsw@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH ethtool v2 1/5] ethtool: Extend ethtool link modes settings uAPI with lanes
Date:   Tue, 2 Feb 2021 20:25:09 +0200
Message-ID: <20210202182513.325864-2-danieller@nvidia.com>
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
        t=1612290331; bh=RHKn4D6rGYaXM53ERofw/wQjiB4afNfRMa+qDFZOj98=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=IkNyKTtH6lAM1KW9pJrfvJvRJ63ZbQ7HZaFCegN9fVHNXcyMzz251qPaY7FmyRYV6
         z87ZbKZaEmEDjjj6U/1pIUH6/h6SjqTVY4fFkr/eVScMcYtXkdkI6VZaZkCX45cWvK
         +qDBdV64aqKeQ7QdKXQyDkMxXTvs1KEpDc+Z7cr5YZbxGEBWZh1SnIjgbtavH8Y9Xk
         kWnezFE1AxLNjGjAclAjrS4VtuT29XIFyc8JlI0flVEgKZgNHNYse2GcbWeZe6cV1E
         LVuWOu1dujfj0/slG4PJa3sKPvkYrJ7i9Jrm7S/VbXmnl6B7cQvuBbkwo38N+2uYkT
         NFoxWZLTHyyNQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ETHTOOL_A_LINKMODES_LANES, expand ethtool_link_settings with
lanes attribute and define valid lanes in order to support a new
lanes-selector.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---

Notes:
    v2:
    	* Update headers after changes in upstream patches.

 netlink/desc-ethtool.c       | 1 +
 uapi/linux/ethtool_netlink.h | 1 +
 2 files changed, 2 insertions(+)

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
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index c022883..0cd6906 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -227,6 +227,7 @@ enum {
 	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
 	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
+	ETHTOOL_A_LINKMODES_LANES,		/* u32 */
=20
 	/* add new constants above here */
 	__ETHTOOL_A_LINKMODES_CNT,
--=20
2.26.2

