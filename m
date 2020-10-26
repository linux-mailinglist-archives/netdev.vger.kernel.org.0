Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BBC298C0A
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 12:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773561AbgJZLXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 07:23:51 -0400
Received: from mail-eopbgr70070.outbound.protection.outlook.com ([40.107.7.70]:11845
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1769188AbgJZLXu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 07:23:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMhF+iLtMu6BsS6D45TpV8nce8172ViIRkd/93HhShNtjJyf6EXNUwZdpeLWy1ixIhxXWpZwoblB9U5JVWZ1xCSVzcw2NmWY7jpM69GyVZC22/rgr1wmO29k9/A2DHjdFH4CoXzJ3+Mb5rdoyXv0lgkyfWbsoBTsb/7w0kzgxTmT6b82Hqyj5yBwrY7KHOv73BRS3LpZvX0kjTAGOH1FjOCVJGchzI6cTEqucto0fQyC4dz3z1Tn2uO3bdFOZeoq3db86LFoSL3rXYU2kCQUJdpUKTA3L5IldYUXj0qkpaDCXcEP5iyjp+d7wX8saeYGJFA83yZnkYHB4BKSopk5Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IC/HKPZ46hvXjohoTFV/lfx27ApKYdp8xUCKODmJoPE=;
 b=n4rg8l9bac65UyLewus7CyOP/LVbACHRKUwsvQ64dEo0E1fLzaNnvQrXsobJgeoXNIOEt12NaZG2kI/NAyyMkHGudDGKHurEP1CSAnmBwTDeh6nq7SFySXiz6xa6uYWE8txDS70UEvhJiqwqtisbOKUx5YNZg5b3ZVcSHeVd8pZn7bBu+v/IanqSfvjsBVKDjOfLsgB0hs38L5fz45fUWdBKJ1VwfJXwirOED+qafLx6lpHPtNMQguKk8R5wHR3CTZ4g0SsGTcL6xpgTWdatvrH4BePU33jez6jt7Kc8s7U0+AjFA3P5mMZ+uwiIEAxmYPLUFnJipo2OQJ2WCbh2cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IC/HKPZ46hvXjohoTFV/lfx27ApKYdp8xUCKODmJoPE=;
 b=B3KPyVJOCIJp7OYy1F5HwzeLgDS/BIMnAvHDJZIN1yeLjZy/Yzw0tZezjjWEIQlxuWBOr55FyTXIww7J/qNO5teItH0Ui63VhRR84De4uwnWKcIP2CFPNXmCGOiS1HeFiQKBdmQvaQIcmW78WjFJIYn01dpALu6dK5yaHFRqVf4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4910.eurprd04.prod.outlook.com (2603:10a6:803:5c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Mon, 26 Oct
 2020 11:23:43 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.018; Mon, 26 Oct 2020
 11:23:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, kuba@kernel.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net] net: mscc: ocelot: populate the entry type in ocelot_mact_read
Date:   Mon, 26 Oct 2020 13:22:57 +0200
Message-Id: <20201026112257.1371229-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: AM0PR10CA0060.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::40) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by AM0PR10CA0060.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24 via Frontend Transport; Mon, 26 Oct 2020 11:23:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 394a778a-560d-462c-e5af-08d879a198b0
X-MS-TrafficTypeDiagnostic: VI1PR04MB4910:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4910734C32778E2284AE06CDE0190@VI1PR04MB4910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vrr8OJTnfuc0lEbQ6OHTC7lX+jp/DalNSwcfGTvL36/NWbKnHMVkwQJGh0IK6gwa+KqrCRhEtdb+rUbJvERABHbbWMUJy9srDG75BcmXPP9MoJXtCrJebbpYl3/4apUPO+4AcQMm5nwns2QKHxU3/XdxiODcMnZxPK8muTZ+zw2oAf7QF8k0MmlqkBRth2+YzNwv4XpaF4lezhdznS1rpjljnvuHucb8bGaWTqV8r1iuJXbYWgW3f6VeqFZnKrwdKHplS35gOE7kMVUKX2/h+WAV2Sj7k4HjywSbPpgitAEDQiPJf9zXrGRQ1QGwrI6Or+0rHGJ+XlfRccFHdYVbyMU+1UUHaedj3B+xztpq8Kr/biRXmJLVvVtRCT4w8dky
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(52116002)(26005)(478600001)(44832011)(316002)(6506007)(86362001)(4326008)(16526019)(8936002)(6916009)(2906002)(6512007)(66476007)(956004)(36756003)(4744005)(186003)(2616005)(6486002)(66946007)(6666004)(5660300002)(66556008)(1076003)(8676002)(69590400008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /Zkw8fHII2GnE3+RhIY5AUMoRg8LZmEth1OHJRxWLNZNrD3bziVGmTgIkjHVVV1r/PV2Wd83D9Gevsse5VKVStHWGOTJ87eRqvmOh7YQS+Qg3LHGgfRmu8DqsdFKqks/ZmVKCuk5PPPqGLbNV6yKNhHVBaj440/TvoCQ3bUgKvbkcSCAcITDoJHNloD72cbn+R2rSjlrseo668aixZbXL6g4K7uag6IEBCEYiYKI6wRo/tvHk2BjDYJ96AQyK+cISRPCn7joGq+bTxYa9yHAXS4ra5IzZxbvOjJ0R5v7Z7We4j5U6Pf3BWGZNJLWu8RVJLj6B//1C6DGES6/guzABPrRN3WO5vVcsEyXF6GQE0TquKM9q5zx6FxCyyIU3vo5Bi99n3IfGlQSYQx7VHcRVr2KopUjHHA9XeiIOkEUPEpcfvi3cGCO2IINhFYs6UAQjzgli6i3O14MTE5nQZFWc7Y/YR57wtohWDRO30cKjv/6e88E5PUfSmK9Lxmjd3Sb/MgJwnj6Fm4UH/0O38ijrJm/2qcO8y9+Dl8Xmx2yjWoNABQF/d48vFWr9Nzrfv9JmB9SOLxmQbrHjunoasK3eRgp5A6XREFcZIiGkdDgXgoAWdzJntCA+L7wyqdNDqV5RmQbnurIY5S5rzNXWki8OA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 394a778a-560d-462c-e5af-08d879a198b0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2020 11:23:43.3669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rz73Uwfc3xXQLX6vDqzk8gD13+BO5rzLq9kAJ7Xv7RlOmQJFp6lnJamW5thPWo2CaNaX4uvIm5Poc2+Xv+KyLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4910
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently this boolean in ocelot_fdb_dump will always be set to false:

is_static = (entry.type == ENTRYTYPE_LOCKED);

Fix it by ensuring the entry type is always read from hardware.

Fixes: 64bfb05b74ad ("net: mscc: ocelot: break out fdb operations into abstract implementations")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 70bf8c67d7ef..860cd2390670 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -647,6 +647,8 @@ static int ocelot_mact_read(struct ocelot *ocelot, int port, int row, int col,
 	if (dst != port)
 		return -EINVAL;
 
+	entry->type = ANA_TABLES_MACACCESS_ENTRYTYPE_X(val);
+
 	/* Get the entry's MAC address and VLAN id */
 	macl = ocelot_read(ocelot, ANA_TABLES_MACLDATA);
 	mach = ocelot_read(ocelot, ANA_TABLES_MACHDATA);
-- 
2.25.1

