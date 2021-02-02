Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5111530C914
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238329AbhBBSJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:09:27 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17801 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbhBBSHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:07:14 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601994a70000>; Tue, 02 Feb 2021 10:06:31 -0800
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 2 Feb 2021 18:06:28 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <mkubecek@suse.cz>,
        <mlxsw@nvidia.com>, <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v4 1/8] ethtool: Validate master slave configuration before rtnl_lock()
Date:   Tue, 2 Feb 2021 20:06:05 +0200
Message-ID: <20210202180612.325099-2-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210202180612.325099-1-danieller@nvidia.com>
References: <20210202180612.325099-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612289191; bh=xf0aHQSrZvWGaG82SeAjhwCe+oOtFdzTy+a0ucNFXv8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=DkdQL2eCFESmhxlL4E4O5dneT3BZcmuyR98Ba5R4/pRfVpYnjhhZ+3c81feQD2N+o
         HzfnSkUhucbthOTW4aTpGLavbjHapcTKRD3iEPUYl2waSlAcv1o/OPKhQ6ZLV5BMm1
         6Li9SSq5lY+D/QdxBIAGKKFv+YAUvrA6WsifBl6ELCa9b0rZ8cFn33KXoiMKv1VitP
         imGSJUtuq92EPmtVlt40YC0IP0mdB4DNFxcjyFMNXGJl1BGZGwffX+a22CXXBO+b2w
         WG0Ml0YavydNtJd8ho5iDDXlsyycFOlzbTMv6KSrYt4TzRs3itUNKg0AJ1V9A4/3dt
         oq20KYOWP/t7Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new function for input validations to be called before
rtnl_lock() and move the master slave validation to that function.

This would be a cleanup for next patch that would add another validation
to the new function.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---
 net/ethtool/linkmodes.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index c5bcb9abc8b9..bb8a3351fb72 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -325,6 +325,21 @@ static bool ethnl_validate_master_slave_cfg(u8 cfg)
 	return false;
 }
=20
+static int ethnl_check_linkmodes(struct genl_info *info, struct nlattr **t=
b)
+{
+	const struct nlattr *master_slave_cfg;
+
+	master_slave_cfg =3D tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG];
+	if (master_slave_cfg &&
+	    !ethnl_validate_master_slave_cfg(nla_get_u8(master_slave_cfg))) {
+		NL_SET_ERR_MSG_ATTR(info->extack, master_slave_cfg,
+				    "master/slave value is invalid");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int ethnl_update_linkmodes(struct genl_info *info, struct nlattr **=
tb,
 				  struct ethtool_link_ksettings *ksettings,
 				  bool *mod)
@@ -336,19 +351,11 @@ static int ethnl_update_linkmodes(struct genl_info *i=
nfo, struct nlattr **tb,
=20
 	master_slave_cfg =3D tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG];
 	if (master_slave_cfg) {
-		u8 cfg =3D nla_get_u8(master_slave_cfg);
-
 		if (lsettings->master_slave_cfg =3D=3D MASTER_SLAVE_CFG_UNSUPPORTED) {
 			NL_SET_ERR_MSG_ATTR(info->extack, master_slave_cfg,
 					    "master/slave configuration not supported by device");
 			return -EOPNOTSUPP;
 		}
-
-		if (!ethnl_validate_master_slave_cfg(cfg)) {
-			NL_SET_ERR_MSG_ATTR(info->extack, master_slave_cfg,
-					    "master/slave value is invalid");
-			return -EOPNOTSUPP;
-		}
 	}
=20
 	*mod =3D false;
@@ -386,6 +393,10 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct ge=
nl_info *info)
 	bool mod =3D false;
 	int ret;
=20
+	ret =3D ethnl_check_linkmodes(info, tb);
+	if (ret < 0)
+		return ret;
+
 	ret =3D ethnl_parse_header_dev_get(&req_info,
 					 tb[ETHTOOL_A_LINKMODES_HEADER],
 					 genl_info_net(info), info->extack,
--=20
2.26.2

