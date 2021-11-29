Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010D1460C80
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 03:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235473AbhK2CDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 21:03:12 -0500
Received: from mail-dm6nam12on2124.outbound.protection.outlook.com ([40.107.243.124]:33505
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236845AbhK2CBI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Nov 2021 21:01:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/by+zlerkSpdM8G6uIFMO/ZPuY1OLx7kwmPnnW3Sp5Ry4Fm3GTozFn8vM3jOdMsE4hmrAelNGEN2nFmjNjjUixq/pNq+sWEJ2xYCdxWqdY/HRIQoO+XaexPZute7WJsjUUZ/RkK41ExO2Pdu+xTRO8a3zh27rEf+9sVFiKowe5ZuZ0OXM8Y6OjqR3Brjz54nsiEgLyVEKl8bDhAGzlNIPYtJ4X81IOBP3wOhxlp5yyM/kJA8rqk7R61BkVy13nyv/PEBK27xWEN+T/GeCismKpUOLE6nhmMmqgFljwC48KC0y/O5S/ORem1n5DzSMm3S68Y8C2lYfBTgb0OS625fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bh7cACjzxCrm27bR9NUkHajiXgmcNvqqUiTeVbN2pIo=;
 b=IdG42k5Tg9H3kaREZ9v6baUtlQbrv5r2wWfLj4jqcMjvTXFFfIZB7/uA6HctKER5/k7QAkXd45nQXKBzGSiPBBKYaIExkuj05BXAWHwgnQ3V7nOo/iEJEbr06laKfZsG3MpwBOlRWYD1mGjlud5ndFz2cpvfVlGbCVhQ1CBqNq1Zu15ku1IC89G/ukXVyHAzHbxeZs+ctKDIz5Xly1Us0mwREGQpHmBlxmTGTRB9I8hh71kX8gjxiGNVpNvqO5cAm53/94HH2sX/ximD4iLWgQsnypAeYA10QT2hLxstdYCs2UYMd/Elsf0l0bFKstueAptFMm7PlFzha3lK5CI+wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bh7cACjzxCrm27bR9NUkHajiXgmcNvqqUiTeVbN2pIo=;
 b=MAp+1t5slAOI5T2loT++HfAMJHaOOcY8GkoYLM4U7zAyBWwJqbtdb1vNQivK4hyGO+iQJ83alka4UX5ykO1KoqlWwkEjuQLFGnGYAPsQaOn8p18zhDzvOF1GKPCVCovNhWUzMzGwfekAqpwmIzALZAeyLbqQ6F4qWJccYUb1Ahc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1341.namprd10.prod.outlook.com
 (2603:10b6:300:20::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Mon, 29 Nov
 2021 01:57:48 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4734.023; Mon, 29 Nov 2021
 01:57:48 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v3 net-next 2/3] net: dsa: ocelot: seville: utilize of_mdiobus_register
Date:   Sun, 28 Nov 2021 17:57:36 -0800
Message-Id: <20211129015737.132054-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211129015737.132054-1-colin.foster@in-advantage.com>
References: <20211129015737.132054-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0050.namprd04.prod.outlook.com
 (2603:10b6:303:6a::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MW4PR04CA0050.namprd04.prod.outlook.com (2603:10b6:303:6a::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Mon, 29 Nov 2021 01:57:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 97eb868d-7aae-40f1-f1be-08d9b2dba507
X-MS-TrafficTypeDiagnostic: MWHPR10MB1341:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1341A22AF5C5AA5D27E35CDCA4669@MWHPR10MB1341.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ghOlvo7Ors/jwQzZkNl1kP6dudSTq2MGFJB8k4EuruCYrFDlDcAjrKxZE8nZbN2fisON+AQdixFVFTK4gchA2ElglawTTpglqgEoOGzyZudaRIcXeTu3IIA8aqukA17/ysEOWSZHTO9IIVlkvj14cAMJbxa+azoZCgNi2s/N3He1TmGTMzhxBAWgVhn44tOUD8ABG3CG0DEfq/7wZKaoAXWiR9RKHxFyAAPGe1SF/tOgLrZjxtLiINOvp8muRAq0CkRCEFY7m71aGAiCezCPP5/SvLXlP3MbGcWYA70AA5Ou+RGLz/7fIoeSvEBmNOyzXBdy6iK4HgELmoxxiYVGXm+HvxI3LtHdTcBd4AdOJ8zcevEpWMOC0kkdlcbo0gCHDBuY4qr1GVKgSmyqyDxOZt/LZkEnRcVzyRtrL81khmGXymWoOkSqghlqqy4HsjyNyndb2WvMz6nxARglT4ryigBFop5BAhXQc1UZJOHYyuyBaYYQnYw+tB0xqMBZO+FeYLfEKPAFdWiR+l+RnB/r3NieJ6LGTOWxDHYVorLh6wF4j4AoTjy2t2hF2KTnjxFwZgzlFRAl5loLLQVV0OLpu2gsnyiVycy3KYeBqssLp6aOhf6FPCkX6LiyFf2reStLFHdaaaBaf2BGoCROr2Yq8ez0UTOVuJZCrPm4D5xq/vRW0JGZu7hRF/Id8L8DwLubhzg1Hp0k44viCcvND2ILIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(346002)(396003)(136003)(376002)(366004)(26005)(66556008)(66476007)(66946007)(38100700002)(38350700002)(186003)(8676002)(316002)(83380400001)(6506007)(8936002)(2906002)(508600001)(36756003)(6486002)(54906003)(4326008)(5660300002)(52116002)(6512007)(44832011)(7416002)(6666004)(956004)(2616005)(86362001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pkNjRqNObLs9LIWcjKPJ8uEelD/Wxc+rzg/isJbeIFnRRQFIiXpgvREF5+bE?=
 =?us-ascii?Q?32HNc0TnRlEZp+wafYzCt/4RSFdypWU1V1/ksdrRYdRcZMnxy1aVNctP1UgI?=
 =?us-ascii?Q?aFT8G6OWr/RZI6mLV+x3DrTwiH5otVQUCUOSuCgcN+BR0rDcdnoCZtfPo5qG?=
 =?us-ascii?Q?tZ7Dw5p273eiPC2j4qtfDVAm/Elq9Q6W45EkG0eBIS/YhodRubsWAFaxiI7k?=
 =?us-ascii?Q?DyZm5ujsm5WXpbNT/c+g1N3cGuuDufaFkIHbhNPDrwhMjcmybUeqw9mAFy5t?=
 =?us-ascii?Q?A/06t2rDlXPWX/xXDyMNugDgXSzjrQxaZy73LO8Jywacb8DSFToxyB6o9FgI?=
 =?us-ascii?Q?r7jRf7ZhVrTR32QibvRF+BeKBBW9rNsFh1V/ynr8U010Uazc+C/n3wcB1EmW?=
 =?us-ascii?Q?tu/WP8uUFACat+5fjBq1Ysk0YlBKfSDYxLq+HQEDzGqftZM7zWj1Mt+tJLZW?=
 =?us-ascii?Q?Gh7y0e5zmtYpXfqgPZbYxnT0/e+1cuNs9btnlseiu2fCdOLWZ8/B/9uuqo4t?=
 =?us-ascii?Q?N0qhDbauRZIb1RhfBNFG7VngP9BJBZJCyzY4qDvqC0FsZ8rpd9FeuereM1b4?=
 =?us-ascii?Q?1ovJdaLzaXpatU8yHDFGG6STIY86AL5jQBQEXf8K50YsE8284pu/In/pc+5V?=
 =?us-ascii?Q?7ndj91zlDF48ZxOcJT1/eRwpL4vrihWuSagxfxS0zjwr+eSvc7kk9FlnQwPH?=
 =?us-ascii?Q?ldWSWeDBlh/haZ35VmJ/rJVh+jOtgXXYs7WogKsTPVcPed7cDRKbku5CX38q?=
 =?us-ascii?Q?nXIfqX2HYbvZ1l7/QTYjaK0dRopjIOvh8xPoCsSz9PoqSTOBVCXYuU6vi2/W?=
 =?us-ascii?Q?ingfdi/Zi7/VuEjXoF30Mb7mBIKwD6CH1DGIaRRVAeEQjnTp22gydG2qV748?=
 =?us-ascii?Q?NneautGHhnOgMYZv8BEkZzaiNPeSqog0IJe1YpD/JnifChConIbEO+1UbqIr?=
 =?us-ascii?Q?RWIIZpcqJBMgXvRWvsf8b+EEZLMViMoGjmo3OZLjIBOGtf9iTlFguDwC5/MD?=
 =?us-ascii?Q?LWjlrkNSxoje7Bir2pShiaqS3CcmcUtKCWpk+uiR80wF7Lblmo/ROQvKhUqc?=
 =?us-ascii?Q?NqLMNX5t9JMOUYD5LqqCnIQdHWZBMHMq9RqV/PHmVmI0AbQhwoPKLhvjwPfH?=
 =?us-ascii?Q?vWWmqI8cXEYIvaBz4qTgBAH+wB61TAPl5aVhl1Zo3UPWnPc+Z4RqyboNpvqo?=
 =?us-ascii?Q?gVctdsPuZwSZKhVyrrUsDE/2nfvtYs2xAIPif0Tj3VVxiIXTV0+qIjDRczJ7?=
 =?us-ascii?Q?fo+bNpnfqnFHllYKhUe9fnjcZqh7ueAZ2aPtL7y2t8CitaFq8tUOKzzk7Luo?=
 =?us-ascii?Q?Yyj5kt7/P4x9xyktuKaKQGvFUJ15cR2fUBtJmTMKjswsgJfV9KATXRlnXcGJ?=
 =?us-ascii?Q?wWjbLq8keU6eYQdwex7koBRyTKlTiF+LrSF1dc7SAiNpJHB36zNB39Wy6diV?=
 =?us-ascii?Q?EMMxoHBwuWHXg3+IUiWKOUN8eq3xHUs8gQKFv9FbSEmPr2+gUlIZe9R90nPw?=
 =?us-ascii?Q?VMS1ddJqUiAtwVTPNxRNWotZGYD/e6ERRiS4XmXKcRMKzEalTVUOOZO11pZb?=
 =?us-ascii?Q?DIZdcfi3cIpiKqcx0OnCuB4zfKOaEO8dSrcQxJvpfZp1bsYu51cNq8WHDVIr?=
 =?us-ascii?Q?3eGC9GqdBnVwrIPBWEiX0Qn2w7y24Od+ssY+SPI5Jl5dDLcmsp4L6//iHOz5?=
 =?us-ascii?Q?J09Stw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97eb868d-7aae-40f1-f1be-08d9b2dba507
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 01:57:48.7897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BrqS6L33yn97Jp3n/K+ndswyjowkQLxkDnWvPuNZUbE/+cd4NMCq7/nE16u6m479kWNEzpI0ED0pv3RieImzRkKuzNBGpRJVUo29kyza6xM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch seville to use of_mdiobus_register(bus, NULL) instead of just
mdiobus_register. This code is about to be pulled into a separate module
that can optionally define ports by the device_node.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 899b98193b4a..db124922c374 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -10,6 +10,7 @@
 #include <linux/pcs-lynx.h>
 #include <linux/dsa/ocelot.h>
 #include <linux/iopoll.h>
+#include <linux/of_mdio.h>
 #include "felix.h"
 
 #define MSCC_MIIM_CMD_OPR_WRITE			BIT(1)
@@ -1112,7 +1113,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
 
 	/* Needed in order to initialize the bus mutex lock */
-	rc = mdiobus_register(bus);
+	rc = of_mdiobus_register(bus, NULL);
 	if (rc < 0) {
 		dev_err(dev, "failed to register MDIO bus\n");
 		return rc;
-- 
2.25.1

