Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2482B3C6DA6
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 11:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235177AbhGMJn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 05:43:28 -0400
Received: from mail-eopbgr40077.outbound.protection.outlook.com ([40.107.4.77]:33926
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234944AbhGMJn1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Jul 2021 05:43:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEj+i3z8dq3NQAv7JX2hdwEtBlIMkpcQFpPebLJgUyuFwDrQ8vpHNFnG3vE9cKL2XMwAAjRP9vlGebQ8m41EV4gP5v8V8HCWv6a+fguLchIZGJcD0guetqAvmAKCstLt2fx/gkB04LHmcGBhHiWzRf0gfjLncOdZO8FAakjxw0W670+wcysEROKFE8FIr+1zKu8W5Xt3pRFgBvpLvLuOhVtPH+gK1FqytgJ4MXX4Dmke6T0CxCo/0+6Z8R45IfWYxzeIp1ynj0j5Wbfnt3rZBqSBPssACtel1nHdcPzep/DXSgpD0sCXtEycOdnQjHFtAN1o3eJr9aOXnJKq4r85Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwyabCmZdUj4Ta2S96xQVcaXiDmcE22NcscGRpbxZog=;
 b=SW1ZsOT1O6Lo8dvTL1cC6BO6rVeWmOLPoApgbGPpdxBh4atKqYaT/CsuBTp/6L6RK/QVCfIYlMMFeNtuIKO7h2CB64rDWPGaaStEL88iDjRib89JMiGMvrug/8rX+4NAUqVPkQswhTVDzSwF6ViqsDM1BYjVds5X0mnZeoHwuhEN0R6xfDnCaI+QpfHnjw5JmQRDPH7zkXC2Pgy1lsxr0OkRsS/wUL5ai+N4YC90+R6GkxbGAa2Zk8A2Gcvb/mnuj/MX6bMxiOenm51Zcc2+GPDGjCiK2oHS/dBFjxqbEOiAj3QvM481pGT9GPA85duIEDGdUIPV73FXUFYzO4uMMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwyabCmZdUj4Ta2S96xQVcaXiDmcE22NcscGRpbxZog=;
 b=CS989OVVZLSu6jwwxQVWmi6ScOEM/D54MyfJS3b5ep844liBgu1Rs97IHczySjVdEyhBguZ0UF4x7BxWvklVqiTKIwHWniO8pqlUXoa0TC2hXBssDYEfL2xbLRY+LFsjNTVy0ZBEYOAvfs6utZTVFdfdrpe1l0cZahBhfC4VyCE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Tue, 13 Jul
 2021 09:40:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 09:40:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net] net: dsa: properly check for the bridge_leave methods in dsa_switch_bridge_leave()
Date:   Tue, 13 Jul 2021 12:40:21 +0300
Message-Id: <20210713094021.941201-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P250CA0010.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:102:57::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by PR3P250CA0010.EURP250.PROD.OUTLOOK.COM (2603:10a6:102:57::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 09:40:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 491a0160-2c62-493c-2d12-08d945e243e5
X-MS-TrafficTypeDiagnostic: VI1PR04MB5693:
X-Microsoft-Antispam-PRVS: <VI1PR04MB56937EBBBF91CF3F9F287C9AE0149@VI1PR04MB5693.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8UVaMzFAAry0M1UGhEznFW/A72jzcBdInv2vBdnhYu9iO4rGhmCeoKSE1grG6qmmAhr/Um7bA7N/MubgPTwitBQgw5PMhQkcdYrDvCBAx8doVx6UyP+5V/U89DTD0r87dOyeKjo2CtvT0/SGWKb/UuBbRmvo2+dUro5O1719cJzv37vnpvsDqvyt9dXugWuHT4W406WTBZWyX+8WGIytDz7H312wnkUlJZvBcmIB+cA7qkXzj90Hvfv79wXAAYQuRD1mPdBcp+cB+tm7HA0Xd7OU4fqqObH7r6C05POX+rQ9RAM9x5I1WpBAdbNFET7O2ouvB8q7F1qbkYUaEuYHRos7AVornBEsfpQHNZBW++R6CDx8yvUdoWgswSE9k2/qQVIPi87rX6ofizkvN4rX1Yw6aF4O8Ak4fOb3x0eYEy8ZgotjgXUufVSuTIFInK/2ah5MRa/OHKofqjzIn9Ek0cIYP9yrL/6iHYT5s+5pv2fR4KF2FDFJOEKLkDMTDApk0+vW82nfMgg493SRJC1wN1qBSVJKpCh9N/1WtSaWuiKV9WRN7mv4tzhTFv2A88IEupZf7NmD9IhOmo5EpvZ8JTyEIn76T8yqrjU48Z1mSBQPy5Wmi9KdZCSVl3XbTXM0pgXF0KJa+EAUT1sgJygcm3lGFLnNDJyxIge8KL356+gcAMTbn1/zvBrP3ZVHOxpQYQBSriUNrZVRXizX7adOaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(86362001)(54906003)(6506007)(38350700002)(6486002)(38100700002)(4326008)(52116002)(26005)(6512007)(186003)(83380400001)(110136005)(478600001)(316002)(6666004)(1076003)(44832011)(5660300002)(66946007)(2906002)(8676002)(66476007)(66556008)(2616005)(36756003)(8936002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VkfmFeZAEs+SDoCR+vnzZQTlhF6lNuBUyj7ncVS2AleLtlompo7pEqM5DPOH?=
 =?us-ascii?Q?t6+LP2Up4irb3TCszydXXe+T4rdIqdM9pQ5Veb2xjgoYMZvqyVPnU6mJpdFu?=
 =?us-ascii?Q?5hntiu8It9zUClgZysBbEUpqLBJZkZJpFdP4cVx0u5qyXeOxKo4sCLVh5qLl?=
 =?us-ascii?Q?pAgCzdkboINq8snXg6OVHyveNDPmakUlgDbYtwpM3vQNXGdTCnbGDWzzCtbB?=
 =?us-ascii?Q?SE/YbYZErgeUfAvveJ2ojhc2YH8iu496yPVciTa/eD2nQ8mD2lWqo3qLOB8U?=
 =?us-ascii?Q?9dCXgYATFtNyNQC/N8eL82i7//+0FQJzPrDKdyb2KmaQ82QlX61le31K+4FE?=
 =?us-ascii?Q?iqntoU6SQvyQfXCUxKdi/tztDKRlbzaycE8lQyF03Lqry2JPcTAHGMtodNDu?=
 =?us-ascii?Q?XNuYoncUi3N3V45iuWnR53le5rX2EesQ7lGHwe/iy3QC2pFDcy53gnGsIY1t?=
 =?us-ascii?Q?auxfeuksy+v7KyJXkqpMsljVxvfkcbU8NVkkogFK37StzpVUoMRlXudWViGZ?=
 =?us-ascii?Q?DufnhgX5j81SfjiA9ueNBwvrf+Xp1+JIaS7l+oT1geX+7nX6o8v/dVhSRjl9?=
 =?us-ascii?Q?v3VHOpZG178YG4FOqRReKy0haNt7ijhKUdeiL4g3EeH82M5KIRiDsMOp/fiA?=
 =?us-ascii?Q?kwBvkQCK/ISjkMiep82jAA/n5AjTy8eQwj2LwmolrxiHTD1mRZ819zq6wvJA?=
 =?us-ascii?Q?zn7C0o2lqt7EpAuqZdcIZy+sqeL4Niw7XKXzBI2hm2MDzdSSF4NXl8UZZN95?=
 =?us-ascii?Q?FEEuVGNdU7vyhuZQgaRDIp1TmJpHhgGj2k9siBdp2R4b76piWG3oTAyuKraO?=
 =?us-ascii?Q?ub1FzMSrhVQL8Nw9gyG63UdZc6bAbggeA5Ifj6ZIgg5HWINBRrHj2AwMiARb?=
 =?us-ascii?Q?J/ILN0TmzszKfcF54fUERKnaUkT4lvPmM/pUXNTZ5x3Jngpe+4TPLQN6mb2Q?=
 =?us-ascii?Q?dfEU2rWFJG+zTXtZvTBkzaSJz17SZt3/MD/rS9AOlF3EMb+uKdJ7LcAzGirn?=
 =?us-ascii?Q?J964H7M2LB7tN/IkHcTSqKo4OEm7eMLUMMNrmuEKEJZD5TdBhxVHMIoAleAw?=
 =?us-ascii?Q?Ge5o+roryYyCpScYw5qGqjeAbedXCcRFrGutBnezBo7z+kKeIbp4aIFzBvXS?=
 =?us-ascii?Q?11F4FpNNJN+F4jEVCeYEF/XODPGexeIIIRc1AeRKbqC9JVEw8fEuOgcEYSD7?=
 =?us-ascii?Q?nxoBNOIH0zQiPgThyFVi/Lq7nz4tJh+vD/I2ofKP48PZ50fjCqYwZ/FArDmX?=
 =?us-ascii?Q?uV5nQjACDAte2Moqc209A3HFEq1EFwZNWeaRiw2TY1vQ/1AzJShBFsIXji6b?=
 =?us-ascii?Q?yi3+29exEb3I/I8TJoLPiFN3?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 491a0160-2c62-493c-2d12-08d945e243e5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 09:40:35.5013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /6lgKm9Lpj01kpneBNltAhfYW/m2VR5x1Eyx+ecYr8woJ3tyvPT71inNz8tdI5A4yhyErvMphm5BJUa/97kUVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This was not caught because there is no switch driver which implements
the .port_bridge_join but not .port_bridge_leave method, but it should
nonetheless be fixed, as in certain conditions (driver development) it
might lead to NULL pointer dereference.

Fixes: f66a6a69f97a ("net: dsa: permit cross-chip bridging between all trees in the system")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/switch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 248455145982..5ece05dfd8f2 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -113,11 +113,11 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 	int err, port;
 
 	if (dst->index == info->tree_index && ds->index == info->sw_index &&
-	    ds->ops->port_bridge_join)
+	    ds->ops->port_bridge_leave)
 		ds->ops->port_bridge_leave(ds, info->port, info->br);
 
 	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
-	    ds->ops->crosschip_bridge_join)
+	    ds->ops->crosschip_bridge_leave)
 		ds->ops->crosschip_bridge_leave(ds, info->tree_index,
 						info->sw_index, info->port,
 						info->br);
-- 
2.25.1

