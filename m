Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8ACD5F86D8
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 20:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiJHSw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 14:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiJHSwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 14:52:17 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2118.outbound.protection.outlook.com [40.107.94.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09893F315;
        Sat,  8 Oct 2022 11:52:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjAvYLK8nmPkkuiQPOg9e33CRGCBkQ+ENJ8qhXUh4FJbnp8f4lkPH9In1J6E1v4f7wtf3BuuTeO6yOO6E+n0chnDMhSOMnqxKdh3cjpk/yLE9pkkcQv4BPKeu+dhhgr/KCP59VG+OG2vOTfqRDsJNYD8scfkVQqcRGth0praYyXGDwEfD2aDcs1bfl1LEGLmw98HRMrwI0tZ/RuGyiGEutwUV7ynFUxN9iAhtgASiDPL0UteR0gil6j7YCNpRuuqzJTJowK69A14jVfEGl8NiM96OMSLndmuQe3uepgtNxESK74e6SeD/ncynwcDNbQHsFGZE32wly6AE19mQCv9hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s9C2cB/cNu1wPrGU1Va66eSBDv15hq/BGirkJxced2s=;
 b=PUXrn/65u50nZm+YDZ5r9BVxHM6vUbZwZarcLhJVYL1C3hG7FxDEoc35UZRYvWTqvqk+k1+Lp7Gr3O1joeEhsy+mFyZkGq3Ugm/X6vYa5eJ09U1NngSvTONiBnXlT1CS0BhqOrimF7EdvIBlMulCUw0hzD9rGy2JghbVf1/Ozr695XkIHcyKDDPMmis/Q4wXEN8oXrEtRIpm/tkcYRJ0uDz1PmiFs3vTJuf4aEkJv4ombr9z4Q06RqNvLwLsmQkLGvvNy09c7gP3RUutQWyKg58dlUnD0avx+tV19Lbls+xSjoj/JMAzLVn+93G7+vWq0DfFia6sm/JwTGQYfFTZ6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9C2cB/cNu1wPrGU1Va66eSBDv15hq/BGirkJxced2s=;
 b=PraPQvh8uUE0ay8iBkJmCsNgH6+rNALbFmPjWcbjs6GR5Pj8H5wVcIM5MovxUHJaN6hEi19snz6atuTeO8q3CT92jzTqbt6/ReAxX1SuYmoTeSx6+HBn+7f62gGdQ56e83ZUwlOH9+nq1loqsMnPXfAq8wolvoRK5/C+dY9K5bA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6129.namprd10.prod.outlook.com
 (2603:10b6:510:1f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Sat, 8 Oct
 2022 18:52:09 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Sat, 8 Oct 2022
 18:52:09 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [RFC v4 net-next 10/17] net: dsa: felix: add functionality when not all ports are supported
Date:   Sat,  8 Oct 2022 11:51:45 -0700
Message-Id: <20221008185152.2411007-11-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221008185152.2411007-1-colin.foster@in-advantage.com>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6129:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a2e67fb-0370-4004-da78-08daa95e33da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gXzwuwxnWbJPvk2o9FAY1Jw4BXx4rLZgv3mh3gXMO7bgQWJr2DjaLg/P/SbrRdedHaf2kVCPkoR3B2odC2oFZyJPeA4jw2H9YPfxcIT20r3kvsdjqoe/JHt3Z6Ia6T97KhNoTmCh1EOUf6xdt3xG+OFnmpS9YcEsHuXhqGplBVFepkdBlW+91F8Cg/9n1DpHMJ5hUKKKCawuXavXKYERv6+pJr7xp966lk2zt2i/nDSG1V4DUpp1e/5AaW4YteyYuMXhqSvlaYcUFoVPWEDM2bH7wdSxKlbhT9ibQGvHJv4kISB63eLs5IJfLgcEJAHdajPwx8IWpl8yxE7soPgH58JBQvdyn4zuzGbtBtFrzyldlzxU/Q7ySNJfU2hKc91b+8OLy3HMIqDCw+ElNIyo6VKobXtBdLEOX/wHxwbnf5U+V3HUPkXCI2iUfv+dzFJGcZMsKO4NRS+c0NhZb5QeVNuEtg3hybsrO+HgChafrX4u3zGLRXMOB283766CNujSzk7rZ9ZK5okY9NX/fXqL0VxmAzpqVgUIe3Tmb/XWgOOegBEl4Avw0UtcjM9VO3NXPC9n7UtavtXwcVPbdefN3NkLPi7XS6m2n5ufPyIV+7kddKQdcH2g/ptE2CCfHvddZiTUHHxEAUhl7wYpRey/BI6Qfl470Tpqs3Qw3dHyT4bFLLKXvNWtvfpLNcNDA6ITJfz9YZKe8Zcy0Ma04hztMEMt5kVrHW+0Clr0A1QA3T9OaJ5eNi/9e+TbFO90ZgE8YrdRyjaSlsVgvFE7qiyBtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39830400003)(376002)(366004)(136003)(396003)(451199015)(44832011)(186003)(6512007)(6666004)(26005)(6486002)(6506007)(2616005)(316002)(54906003)(38100700002)(38350700002)(52116002)(4326008)(86362001)(83380400001)(1076003)(478600001)(36756003)(7416002)(2906002)(41300700001)(8676002)(66476007)(8936002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o+ivObe4GcEr2uvSPWKjB86kPKXvKB8eJtjEoItiIY5PGNvF0A6FBg26LfES?=
 =?us-ascii?Q?lPGpZTF+oRmWe82RMZiv/sHIJWGVNDKd9saDHj9Tmb/MZETWZGZAcRF8VXEo?=
 =?us-ascii?Q?s4FhRK5Z1wMOiSPejM0eFPyqzuvOQq06u2r2ZvTQxCygb1tyG0QlsIE5YE90?=
 =?us-ascii?Q?uEUKAkoGJAP4qtxGXJskV7BKKKYc7A2zzK1l755+yoG+9Iz59Po6V7sIHLOO?=
 =?us-ascii?Q?fqRRT65GfC4gBrbCfoojek3WE0LgHZb+VX6bQEs2vGbncyWKLhAJKAsfB61e?=
 =?us-ascii?Q?UxXrQ6tvgs8Jd5MCkAPAo2hr5iaEPdMo5N6kjNsSPVntI0I7Cj0aJe9jtsbk?=
 =?us-ascii?Q?zUR+8m7+CoJPH5gt+pDzsbyeg0dPjev2R9aoR/NLf0ec7PProrGYUW3USxGJ?=
 =?us-ascii?Q?JV54X/EHBFqoQJEIe/6mlt9tdgfUFno4ollbDcQDFj2EhSO0rrDta3EY5Cui?=
 =?us-ascii?Q?AGTsuQ28TKfdDBrEkTLmC3P+jBMDiEJgCBuCwPWh36zhZVOWruJ6Rp0l7q7W?=
 =?us-ascii?Q?NHDDcy7j++lXpBBEIT1azf2CxCek8gfDPkRwE6W7NhalsgrVJUCgRWSaxvji?=
 =?us-ascii?Q?mGedZKZw6crkNg3O7kVEJKy/qJFWYf497mSuMjR8x8y0p7eQW7JlH6Fvw7FV?=
 =?us-ascii?Q?XQSuhqUi3xDs79U5hqIpwoY6U9QTe3tNd9mtu1f7W3Y9gHC5AEOasM1HElVN?=
 =?us-ascii?Q?tGdQIBCJBgl8eGSRTj3sszjCMncbLbHNqNchsFB84dTTskBwMQMdw28zvWj/?=
 =?us-ascii?Q?gLT1nAo6iKpOrcFDin3VrSehmv5lr+08CWEwxkrXJgqSkPdJ4Kp06oKs5FG4?=
 =?us-ascii?Q?BHq0+LPflHj4VJG1DDUKSi6IqR2FX7cW7t0rfEkp1mqhG006J17ZGMMxkdEW?=
 =?us-ascii?Q?M9wnyI4iQP+lGhQiIALab69twd5SZ3Af8DEvs6yUqa8hHO+xNN3/2xGf7dUR?=
 =?us-ascii?Q?VNElyIhHbvDK7oNOpSeQXRZOOtAURCsBMozmnB7hVGSIXiJEeooRGDPsJTyA?=
 =?us-ascii?Q?gcQFu+gEClmwW/N5i7R3uoTYNqEiFLSIJFOVRbNMlKJDnY1ri8x+eOPCBymk?=
 =?us-ascii?Q?JNIVsX72f9Hg2ylizlOt3ijmldIGFnrxIOldcR4gdBviDP9OR2I4jVe+JeMN?=
 =?us-ascii?Q?dmsoy+9J640QmUXJBzdDSZchYXO5gW8y+TVGELj8kmD0NUjrQplyfKYCLM4x?=
 =?us-ascii?Q?D8Z9R0xU05vQd2XrPKthbA86Zy6upq7FMpMv1SFWWFvYKxciMac7aUSoqPb8?=
 =?us-ascii?Q?fMZkWd5RtxPDMJHl7ZWUwuTyhS4/6y7Th5N4i8X2VGiDG7n7J5pAh2Pm5qzA?=
 =?us-ascii?Q?1HApgAn5tpXFWLGulMCpu63HzMvFCeD2LpBWAJOLuz2fRnipFSXUjw7XYDp0?=
 =?us-ascii?Q?xv4zCeGmEnwv8SzpgS2I2VYU+LmDfPpdNdFepICtFF+EXcuVjwmPBVB7Dp0T?=
 =?us-ascii?Q?xJXkuEiEVPFDMeRVhzasGxUHRASSn/CjcW3G7SjOHcwMzTGK9djPVfZsE1yO?=
 =?us-ascii?Q?4Q8MXcVjy8fmxyfaIdeeI5ZbJM1I4RmD8h8ScVXsyuIoYCGcye8eIFkMkurL?=
 =?us-ascii?Q?N553TOzknaghKJHoDiDE4PjcyUnzKInnhNdUkSNBpxqMgeKK1ETEVq1r1UnR?=
 =?us-ascii?Q?DgdCsTbFhINShO4d//+NrfM=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a2e67fb-0370-4004-da78-08daa95e33da
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 18:52:08.9909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +r4dP3YC1gERAUxi2bk2zfczWsCJ1yFpDWmGpv3XJVM/XsHfrRmqmdA9YjpfKkpRBjBIGTczEthTtKzyxozWh9xsj2ZwlmTkD12VpMmbWhQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the Felix driver would probe the ports and verify functionality, it
would fail if it hit single port mode that wasn't supported by the driver.

The initial case for the VSC7512 driver will have physical ports that
exist, but aren't supported by the driver implementation. Add the
OCELOT_PORT_MODE_NONE macro to handle this scenario, and allow the Felix
driver to continue with all the ports that are currently functional.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v4
    * New patch

---
 drivers/net/dsa/ocelot/felix.c | 11 ++++++++---
 drivers/net/dsa/ocelot/felix.h |  1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index fb0a0f7e42ac..70c3e4e203c2 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1283,10 +1283,15 @@ static int felix_parse_ports_node(struct felix *felix,
 
 		err = felix_validate_phy_mode(felix, port, phy_mode);
 		if (err < 0) {
-			dev_err(dev, "Unsupported PHY mode %s on port %d\n",
-				phy_modes(phy_mode), port);
+			dev_info(dev, "Unsupported PHY mode %s on port %d\n",
+				 phy_modes(phy_mode), port);
 			of_node_put(child);
-			return err;
+
+			/* Leave port_phy_modes[port] = 0, which is also
+			 * PHY_INTERFACE_MODE_NA. This will perform a
+			 * best-effort to bring up as many ports as possible.
+			 */
+			continue;
 		}
 
 		port_phy_modes[port] = phy_mode;
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index e6b7021036c2..90e04df0276a 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -7,6 +7,7 @@
 #define ocelot_to_felix(o)		container_of((o), struct felix, ocelot)
 #define FELIX_MAC_QUIRKS		OCELOT_QUIRK_PCS_PERFORMS_RATE_ADAPTATION
 
+#define OCELOT_PORT_MODE_NONE		0
 #define OCELOT_PORT_MODE_INTERNAL	BIT(0)
 #define OCELOT_PORT_MODE_SGMII		BIT(1)
 #define OCELOT_PORT_MODE_QSGMII		BIT(2)
-- 
2.25.1

