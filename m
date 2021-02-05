Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261813115EC
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhBEWpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:45:30 -0500
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:62982
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232479AbhBENGJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:06:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZXHvNcrEOYV0D5ocjKYSNodeIjx7OD7dGCOnd85OiCNvh0qO2NfkOdRTUkRfbWnOXOaTehPmVu2bywhOiD1IQ/JD6Bz3FVTGGys5xG3obLCBWmy6CcBFwbDEUN9Rv6rOt/dzw2KM84MrkapzAlAC8wFfztTdZ+6wEK2qLEHdkiC6DgPE53YWVJq4exZC5T11/ZZl1Ps/Uzo9pQfHRd8xv8srmeMIu99GWNNWTa8Gm/67M5/GlX2MLS9xsjTaxu9U2whrloNJyzHYAVYfQ57HTAm8rDmBvIzvIX4k1Nkl6Ca0e7zAkYrUD9nTr19h7F1OVNHZGW+uC1Zud+ZuBZBRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/xkEsjhw4O+AZC+W/j/4Jo6Rqste4fXU5SIsP9OU2c=;
 b=kkl7YYBotYm3GuSF+cp4+PdovBxGyT1jP0doW31Pnnu9TrMaHGJaS0tAuzBFjxByk6dNa0qMFzkt0+oC+UvCUAnMFcZG8QptCOOV9MbyJvxiUbOMoIVWPOO1sr4LW6/hwOZ9/EIrEqDrWJwIniMxSVNsev1kPCEUKa5pBc122ooGN4DP1oyGEXN/Rpe2UZbTpkZJinBonuAtC5aIi7pcNVLaHkEGGTk9M00R9ATm9EMzOJF3duWbxFi8Ttg4Z1JWiE6L/ujqYLm74+hCrRj+YnTNyw3D465XLu6aUQN9hLWgscU9dL8LTpYTwBWLlDnBKNWkxZGUaDwiVIqmiMiRyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/xkEsjhw4O+AZC+W/j/4Jo6Rqste4fXU5SIsP9OU2c=;
 b=TZ+dWNy0NoKA3Yk4/sFERre0Y46q6k4Y+wYlf1Y8CKwXRAvlPHvgSJlgW/xCpn+cmPkERgXhvDpxlLOnQtarAWTr9gQ56vx8w/L8z+NlARsMrqRPV93cDn1jBcPF7ih87iD53zy09iOE7NFgCuD+fRzXcC+vsVr6D43ogcIZ3Dw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2863.eurprd04.prod.outlook.com (2603:10a6:800:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 13:03:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 13:03:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v3 net-next 06/12] net: mscc: ocelot: avoid unneeded "lp" variable in LAG join
Date:   Fri,  5 Feb 2021 15:02:34 +0200
Message-Id: <20210205130240.4072854-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205130240.4072854-1-vladimir.oltean@nxp.com>
References: <20210205130240.4072854-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.227.87]
X-ClientProxiedBy: VI1PR0502CA0004.eurprd05.prod.outlook.com
 (2603:10a6:803:1::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.227.87) by VI1PR0502CA0004.eurprd05.prod.outlook.com (2603:10a6:803:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 13:03:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 422c3cf6-de22-48b7-79f6-08d8c9d65ee5
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2863:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2863B79249DC40818ED448B2E0B29@VI1PR0402MB2863.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Gv0LD1k8at1GTGMI4HzXVumg4jx441qOudywccJOYlCotEGKGMTUcpGo0l/TK3u23es/Gy5OCZiPjMLAnJEO+TAl1Sd7JGsKQIL+CSh8TQVtGqNnoLEDYAbNcsOVAfesyjBBBNMIts1HShwdZozYTeqPgjKhW7MspD+nVyoDkvrUTeAgOsDeZcEMdBf0lwAj79Aa8Phamzg3A+3crfc0nT3heVeDCHxggJo5X+n4+TYr2Fx/ltNcVUXHfSxWnlEgu9TJVnUCyFsWeHmBKnBw/JR6BreL4/1wHxaYXyTeInwzHkpawDIIDN1Aca/fsDYmrbOu7hq0OF4I9vETJMJbMWDAm0X5QdYadK6CA+TXY6QvFNNLpXG0Juyr6ADUHapUyOdUj7VJarwFGDSAcmarIkZXhL75kr4OH/x5x9Q8iDKv2Z+MXgI6V9c8kIB76seonQQuJgQHXFaeNo/jis2R6g82f33U8djyDP/rppnNyfDTnGb6sq8kXfN9OFAY6nUwOsHhitzMNvMmO2bn6KRDPVdaGCOGAv/yXTM8TSNfnszKMCQfjiSChyYk+KBeC5GBbn0aIJlpIa79pYBgXANog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39850400004)(376002)(66946007)(316002)(26005)(86362001)(6486002)(83380400001)(186003)(16526019)(6506007)(69590400011)(2906002)(5660300002)(44832011)(478600001)(8936002)(6512007)(4326008)(52116002)(54906003)(2616005)(110136005)(956004)(6666004)(8676002)(66476007)(1076003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UnPS7Or/+KiQwSBIfgjOhpi47nzoe8sbUObe83zYd+x+N8WfEH/ebE9AwyHi?=
 =?us-ascii?Q?Ulewpd2N/vi4yTcvzBUBY/u/YiVafq150G5Pk5iPznvOBz9IObrSDTaW6i8K?=
 =?us-ascii?Q?ZrJUownJAvk2Xeo3nj7z7FyjFPuYeYlZpXgfneHjv5Lhev6MvmKHyvxrrGyY?=
 =?us-ascii?Q?dKJ6q26y+EGy7z6+Ke9xv7XVnaobt0bmDdIrkYo67NeGXe0RQZknRvyZ9ya3?=
 =?us-ascii?Q?mpBMp3yWi4hF0SkFr2IDDia0X+ZZ1xdXVNGFSSeOzIXNWZG8qG/8v6016H/t?=
 =?us-ascii?Q?p0ouBiEKD8kWXPRlUlz3Gc/zXJY8b85NvzDxiMXSrVv0eFLgl+KlPQkJOACW?=
 =?us-ascii?Q?BXffbXmun+SVlzD5kNgauXyYMougcCGyg/JLw/8pBCmbzHOgCUQxX3nt+apb?=
 =?us-ascii?Q?UNKSHVmtIiGlWUSxSmaWbqntGZRmoAx+v4am52i3XkaPixpArCuiSr64CCDc?=
 =?us-ascii?Q?SbBhTyfGKgqK5h6kYtPnMM9DrdNi1qgKrRu3JIgfDX75ad6fGIX10tqeDVhe?=
 =?us-ascii?Q?YauV76AwE3Z3aVEpuWGhfeSlWhFV7kEpj1dt4lrqFRJRQ+wx3ZuQWPeA+SU/?=
 =?us-ascii?Q?mhXqMD5V4CbNrsGH0m44LyyHs/zABvf5ggD5l1SfeyKYFhwlm+/+wsgv2WeZ?=
 =?us-ascii?Q?hHF9Wc/1EQHNU8poV0KZWw++HYOcsO914tWFm2ICklGY+5izH+wt0AdazDEx?=
 =?us-ascii?Q?mnIOTf5bmOKHdn8nZtXyO5JnZW8UDmtKWZ+qz7o3RxRk+61jXieuzrqEXmI5?=
 =?us-ascii?Q?t+cWQVpxct3YiPyOEslBJWFAx2q9VC8QHrpKOpbMC3Mabye6Q/DyQoGiNn2G?=
 =?us-ascii?Q?m9AjII1l3mWhucwU/wLfh2S51Oqt25VFaLTqlAUFN/4P4ZWv9nmfAp4dUXs0?=
 =?us-ascii?Q?iy28BH15LdX57y9Qh9Lbik7Se+fPVzVfGlNgxtHzfxQFmPSnz2bUKfHwE4Vo?=
 =?us-ascii?Q?2oOj+peizsrdPwauT0KldGAEmHi/DovZKhlLzHqGLd+qG0TYWkUIgTbp2sX4?=
 =?us-ascii?Q?+UpW+pwGALmlC0MLKdGiElEGfTERdDwe1ophxvmUGMT9hn2bT2JMAQOSzVOx?=
 =?us-ascii?Q?qOjIUdtVfbpfyCSbffvyUUtKT2vTp/DYzUU7iGMfktFT2WTxMt164lGsGrEc?=
 =?us-ascii?Q?c2LUlWJkzQYyCl1G9UOmZg6869dhzBHirn9FfBO5e+ChKFVfjNbDLWnGvMfU?=
 =?us-ascii?Q?Z1TT9lnwVZZVTmSoJWHJrv1sJPF4uxQLFQLFldKG1gnlaDHocrYvk3TiYlcX?=
 =?us-ascii?Q?StylshU5XWp3hz3zrHrwFJK0wncTGkUTVLCsKETjA1x83AbaufqPIBZX+IOf?=
 =?us-ascii?Q?BpJPQ9qPIHHAgzQhu4oeNElX?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 422c3cf6-de22-48b7-79f6-08d8c9d65ee5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 13:03:02.6715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x3QMXSW2/qxg4x8NOOgC+2BQMPMjo1gKYCKJvUie3VT6otWprWV0xWqgNHbZbQpbcjJB/OL4har85R2lsIAMtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The index of the LAG is equal to the logical port ID that all the
physical port members have, which is further equal to the index of the
first physical port that is a member of the LAG.

The code gets a bit carried away with logic like this:

	if (a == b)
		c = a;
	else
		c = b;

which can be simplified, of course, into:

	c = b;

(with a being port, b being lp, c being lag)

This further makes the "lp" variable redundant, since we can use "lag"
everywhere where "lp" (logical port) was used. So instead of a "c = b"
assignment, we can do a complete deletion of b. Only one comment here:

		if (bond_mask) {
			lp = __ffs(bond_mask);
			ocelot->lags[lp] = 0;
		}

lp was clobbered before, because it was used as a temporary variable to
hold the new smallest port ID from the bond. Now that we don't have "lp"
any longer, we'll just avoid the temporary variable and zeroize the
bonding mask directly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 127beedcccde..7f6fb872f588 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1338,7 +1338,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct netdev_lag_upper_info *info)
 {
 	u32 bond_mask = 0;
-	int lag, lp;
+	int lag;
 
 	if (info->tx_type != NETDEV_LAG_TX_TYPE_HASH)
 		return -EOPNOTSUPP;
@@ -1347,22 +1347,18 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 
 	bond_mask = ocelot_get_bond_mask(ocelot, bond);
 
-	lp = __ffs(bond_mask);
+	lag = __ffs(bond_mask);
 
 	/* If the new port is the lowest one, use it as the logical port from
 	 * now on
 	 */
-	if (port == lp) {
-		lag = port;
+	if (port == lag) {
 		ocelot->lags[port] = bond_mask;
 		bond_mask &= ~BIT(port);
-		if (bond_mask) {
-			lp = __ffs(bond_mask);
-			ocelot->lags[lp] = 0;
-		}
+		if (bond_mask)
+			ocelot->lags[__ffs(bond_mask)] = 0;
 	} else {
-		lag = lp;
-		ocelot->lags[lp] |= BIT(port);
+		ocelot->lags[lag] |= BIT(port);
 	}
 
 	ocelot_setup_lag(ocelot, lag);
-- 
2.25.1

