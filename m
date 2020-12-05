Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5672CFE2C
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 20:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbgLETUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 14:20:21 -0500
Received: from mail-am6eur05on2131.outbound.protection.outlook.com ([40.107.22.131]:50144
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727219AbgLETUP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 14:20:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dRekDYkgkWELwYlsYBVN0e6ydF8zRrPggj09g8v3qmkwkSi0FtofJiCDHm8eAFH8sFUSFwyA7VVa+5BfV1QJdCjceWq9hOasDE1SynI7MBdavyBK3rHOcAWJrsSGaMNDME6OD7sjk9I1gDT/TJZrHIUXD07EY3M8rVKykOJlQog9sM7ICC5zvQ+5RivXlbbq7BG4U0oNkSFXn3OxpoOwz/sDn0z0qjIJfwycYwd59iPf+lmu9HXtk0L2zY7jgXJMc5eXwqNqH+EhL8h0Y0UZkkZ5Zd++U424LgyxrmWQNmhqYlk9BWZjzGaiqX2Xi5ldR+UvRtzjDjSGln2WAncwKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0c6DCeQUPdcOmQBZd7+6P1NAsOpFKmL0m9kM3uKgNH0=;
 b=OxR49+evJq2/96kGMFDDsLzapvudNZ0DI4v9sl9lOs9NCu3KDkEmP6Iy8GWp0wnKbpl0fpm6jAlRJ90vLdSfbMLXU/AQZoJNix8C5xL3HORX0vPMH11RTEnt39D+MMu14gSq2gtKmz5g136KzirijNdd0tiznPqOqBqtBp8nidpvY/QT+JI39sH0DfFpLIr5h7O9mUpkqvZ3bo8YZTqGCtWVuz3JAoLkJveQqqUGmmlT9eUW+rgZpSImWqwNo25RDzzqBSaUn1c6fREjCHaPO2SWEe0Dxx4bqo9reFqEyaQFVmSDYnGb5ZnCirH9kB4HduOL0DLzS/x8aoezNTQekw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0c6DCeQUPdcOmQBZd7+6P1NAsOpFKmL0m9kM3uKgNH0=;
 b=lremdom1X7vaCPDVhAzjmzdiHRhIrQGA8M9hU4zxPyEWGm62cCNs64C4+pj27qw3n5CoEFvZpNryfttHojs4J++pYKKH/TaXcJLPToyh/9cB6Z7n55eQmCcVxnka43ABWgeubZpdt1O12284v4WPgBvtqQ529UlTAmHsymfdRbI=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:200:99::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Sat, 5 Dec
 2020 19:18:27 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.021; Sat, 5 Dec 2020
 19:18:27 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Li Yang <leoyang.li@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Zhao Qiang <qiang.zhao@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/20] ethernet: ucc_geth: factor out parsing of {rx,tx}-clock{,-name} properties
Date:   Sat,  5 Dec 2020 20:17:35 +0100
Message-Id: <20201205191744.7847-13-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
References: <20201205191744.7847-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0701CA0063.eurprd07.prod.outlook.com
 (2603:10a6:203:2::25) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0701CA0063.eurprd07.prod.outlook.com (2603:10a6:203:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Sat, 5 Dec 2020 19:18:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44ad12ca-7f50-4a56-b187-08d899528b03
X-MS-TrafficTypeDiagnostic: AM4PR1001MB1363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR1001MB136358B355E1D335C1B6C94593F00@AM4PR1001MB1363.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:252;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sQP72cvjCOMc3uBqNMI4VWMZRRplBrWojh0dxhDH37Bc+sU35iUaQtyaVtPZvWeVLppIMseDvntuN9NHAoFP5RydyyCL6dNJrZY9jNv8lgpVlYzLxctCLKlDAf12vjTxoDet0avGcHsVEZHDGVxQ1ruuPZHUbeNRGZuqYStLVL/meWUqPv3t/jLqWLHm8GhtK0aC46I94lYauufnfRCnApWaFvJwYPj+JySav7jEUDC9iX8ou/ION+zjrDeC1mBpjvKWLKUGlql8scl0cBK2MufdQifYAMQxIMd2fksxcacUHMc0cHRaeZZ8fjhCShfHlrl3qMvInVgq8ZtL16BbIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(39840400004)(346002)(136003)(366004)(376002)(2616005)(2906002)(8676002)(8936002)(83380400001)(52116002)(36756003)(66476007)(66946007)(66556008)(4326008)(8976002)(5660300002)(1076003)(6486002)(44832011)(6512007)(186003)(26005)(6666004)(110136005)(316002)(86362001)(478600001)(16526019)(54906003)(956004)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DWzUu3isIR7e8wjRD9BNiEUNnyVBYvNAtD5eHTJyFCVE6xgND/7lWAAY1B2Q?=
 =?us-ascii?Q?ei1xa5IBeqnidQT5xBJO4/3NUzqry2W+ND8aqvpCfQxGkrarrf9g/h0dhosr?=
 =?us-ascii?Q?VaQsTSHR939H13xDlYzeArJQgkt2x3zYozqj5xkXouwICtw1YI9pCittERVq?=
 =?us-ascii?Q?4T0eXj5Qp+tVSUsO1lTMA6JyprXHeijQW4kKLYwRClcmH3wazR3FGwOa5J6b?=
 =?us-ascii?Q?cSXJAEhAzGSXmrrpJf9V27N/Z7itR84XzH6y/AYnW6bMCOraMpH70uzHkdBn?=
 =?us-ascii?Q?tygfVr11LVSXj8/Yznhd36FioeRjI4e6qgh0bxIlbZFeth698OzFL92L/ChR?=
 =?us-ascii?Q?Z7NepdmfUcMoPKhc4Fqa5gNwNuRLESbGbBOAlwU2zJv+Tnpq+TrHoE5gAKxQ?=
 =?us-ascii?Q?2qx2Pn0k/AsbCqpQYTtL39Rc4+K7BrXF6gXHrT1Q7Apr8mzBdpj9haKzEosR?=
 =?us-ascii?Q?CPnAaP6wzX1EfvSZJwEwrJ9dwzcFXzkhwRBCIef/iRTtqccRRrMEhCFJhkPs?=
 =?us-ascii?Q?HIV2tOIvtdNu07eb0cK07gDvKViD9YMwsbzPuVUe+jhCZxxB+ZRtqdItngrD?=
 =?us-ascii?Q?qCXCEBF/PUMuMVwo6YBgJX25NprhPow/UgAISDBT5p1YAa1hVkPtQuVDwGR+?=
 =?us-ascii?Q?QdXPGPJXvVRJmIbNMnZVwEUnJ8+ov6Mx6gEaJ4Al0Z4I+Emwf6RYzNdMEGlR?=
 =?us-ascii?Q?JEeR36Fvyro+NJBpPTP2XpsFt6iGhxgxNgxv3+huZ+yJYaEa7/sF/7D416xS?=
 =?us-ascii?Q?2aru6lNZu7jr8JUzG8TBIJjJQoTw5J9z+dbFijxKJnChtgBTZmDJX9n8CclS?=
 =?us-ascii?Q?xyDmZzBN9n7dYx45AaCz77hPO2hLRJZv1g8C+4IdCM7vSQFfb0Fkbtw61AHe?=
 =?us-ascii?Q?w6zrxPmCh8P/ayyycoRX6QVzGr8WI+AA5nM2goQY63RHI0eN31pie0RqHj6l?=
 =?us-ascii?Q?syzonBMY6llmPqu0hQXLSKWPUPV/SUc91FOM8/anDfH39DfYH6tEedUvtis4?=
 =?us-ascii?Q?XgCJ?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 44ad12ca-7f50-4a56-b187-08d899528b03
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 19:18:27.3477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1tpxAoA78+Ql9Z9DZgnWmXygF2aUZn5tlIeb2XQUi9B31pa76rW3eDNSgfosPucpol70g1rO1iBQxcctFm4w99GlALNxVFzszzPzEquk72s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR1001MB1363
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce the code duplication a bit by moving the parsing of
rx-clock-name and the fallback handling to a helper function.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 79 ++++++++++-------------
 1 file changed, 35 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index ba911d05d36d..700eafef4921 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -3646,6 +3646,35 @@ static const struct net_device_ops ucc_geth_netdev_ops = {
 #endif
 };
 
+static int ucc_geth_parse_clock(struct device_node *np, const char *which,
+				enum qe_clock *out)
+{
+	const char *sprop;
+	char buf[24];
+
+	snprintf(buf, sizeof(buf), "%s-clock-name", which);
+	sprop = of_get_property(np, buf, NULL);
+	if (sprop) {
+		*out = qe_clock_source(sprop);
+	} else {
+		u32 val;
+
+		snprintf(buf, sizeof(buf), "%s-clock", which);
+		if (of_property_read_u32(np, buf, &val)) {
+			/* If both *-clock-name and *-clock are missing,
+			   we want to tell people to use *-clock-name. */
+			pr_err("missing %s-name property\n", buf);
+			return -EINVAL;
+		}
+		*out = val;
+	}
+	if (*out < QE_CLK_NONE || *out > QE_CLK24) {
+		pr_err("invalid %s property\n", buf);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int ucc_geth_probe(struct platform_device* ofdev)
 {
 	struct device *device = &ofdev->dev;
@@ -3656,7 +3685,6 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 	struct resource res;
 	int err, ucc_num, max_speed = 0;
 	const unsigned int *prop;
-	const char *sprop;
 	const void *mac_addr;
 	phy_interface_t phy_interface;
 	static const int enet_to_speed[] = {
@@ -3695,49 +3723,12 @@ static int ucc_geth_probe(struct platform_device* ofdev)
 
 	ug_info->uf_info.ucc_num = ucc_num;
 
-	sprop = of_get_property(np, "rx-clock-name", NULL);
-	if (sprop) {
-		ug_info->uf_info.rx_clock = qe_clock_source(sprop);
-		if ((ug_info->uf_info.rx_clock < QE_CLK_NONE) ||
-		    (ug_info->uf_info.rx_clock > QE_CLK24)) {
-			pr_err("invalid rx-clock-name property\n");
-			return -EINVAL;
-		}
-	} else {
-		prop = of_get_property(np, "rx-clock", NULL);
-		if (!prop) {
-			/* If both rx-clock-name and rx-clock are missing,
-			   we want to tell people to use rx-clock-name. */
-			pr_err("missing rx-clock-name property\n");
-			return -EINVAL;
-		}
-		if ((*prop < QE_CLK_NONE) || (*prop > QE_CLK24)) {
-			pr_err("invalid rx-clock property\n");
-			return -EINVAL;
-		}
-		ug_info->uf_info.rx_clock = *prop;
-	}
-
-	sprop = of_get_property(np, "tx-clock-name", NULL);
-	if (sprop) {
-		ug_info->uf_info.tx_clock = qe_clock_source(sprop);
-		if ((ug_info->uf_info.tx_clock < QE_CLK_NONE) ||
-		    (ug_info->uf_info.tx_clock > QE_CLK24)) {
-			pr_err("invalid tx-clock-name property\n");
-			return -EINVAL;
-		}
-	} else {
-		prop = of_get_property(np, "tx-clock", NULL);
-		if (!prop) {
-			pr_err("missing tx-clock-name property\n");
-			return -EINVAL;
-		}
-		if ((*prop < QE_CLK_NONE) || (*prop > QE_CLK24)) {
-			pr_err("invalid tx-clock property\n");
-			return -EINVAL;
-		}
-		ug_info->uf_info.tx_clock = *prop;
-	}
+	err = ucc_geth_parse_clock(np, "rx", &ug_info->uf_info.rx_clock);
+	if (err)
+		return err;
+	err = ucc_geth_parse_clock(np, "tx", &ug_info->uf_info.tx_clock);
+	if (err)
+		return err;
 
 	err = of_address_to_resource(np, 0, &res);
 	if (err)
-- 
2.23.0

