Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF845F86C3
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 20:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiJHSwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 14:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiJHSwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 14:52:10 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2102.outbound.protection.outlook.com [40.107.94.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205053F303;
        Sat,  8 Oct 2022 11:52:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=caQYjFfmJ3xG8sEAgcffQx2xvEdwcNMfssChTriB2/RgvJ/ZKyepyOSm2xaq0j61G04As9L5120bYzjwkn7uCR/Ul3HlG9q+dL2mcjf5rQXCeAj/GUsALXMnXW4GNR54hdtV7dDR7bRjqLuJDBB6qjhLrOgtamVdorDZLbJ8TV1leQFvGVB8SQA0XZZxaCYiFd06mEKBgbvrJEuffnQgtKxipdnNU8ZQtavsWLX7g3EJyQje/6qx+N3xq1v4fQRhnfhdqi8byiWgMUO9bZVwleCpeooJ9uVxCO4/1/+Q/hWRglAn0boSOnm2auZR568FU5YVSRNZccrSE/YHRmh3XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V9X84gh9vCThnj4/kp+VyOwhl56grnNW+bYMKvfayrI=;
 b=OzoXrXhAUncAtsCMGOkUzd1Cba/57u2xLVZna9Fn+2y2apqFRale8iuc48HuWWBz6N3XY28dYAFVhyIbfMiLsQE5yBPzaTGlN+l+rislUOr16HYaHlmmwZaplhAwVUcP+mf8u3aoUlPFvuP/gfx1mY5ee+XoH/wdJAbB4guTwrmU35npH/MRktLXe9qYrmDenM3Hw4/W+ABKSWqafKgNRSgFmK0xtxcQGz6pVCkOcnhX7rLpv0qJH+eWAbNWFNuMKonybHOMqw9AuCv5OgGRD5zQOtu5ue7KBNbtk4xsxnXbvqMRQhv2Cme5B4NiNkcfKoHj2fidkAjmyZdjjvQp5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9X84gh9vCThnj4/kp+VyOwhl56grnNW+bYMKvfayrI=;
 b=jO3ahK/hJTcbpMc+BUpzQHf/8v9idv6kZfZJYr0XTHOOTRtAuEI+lRXSY+OLZYwMmmriFkiEBaB4G+SO/Ii08HW5nrqdmxgMNlqqxXqzC2HNbar7Fd37TUC2qAJVMxsk80qjS0CECnz0W2jgZYgcAkDZD8Afoifg48U4vXVNFK0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6129.namprd10.prod.outlook.com
 (2603:10b6:510:1f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Sat, 8 Oct
 2022 18:52:06 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Sat, 8 Oct 2022
 18:52:06 +0000
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
Subject: [RFC v4 net-next 04/17] net: mscc: ocelot: expose vcap_props structure
Date:   Sat,  8 Oct 2022 11:51:39 -0700
Message-Id: <20221008185152.2411007-5-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1ec486f4-8b98-4e88-bec4-08daa95e31ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O/xpbww8oENWK4/ADep0oZOwqo5L/aFwEVMRRHK/ypS0YcIH12XZpR+mjl5V8JFaRc8QnOkLwVAcv6StwzMo5SQAduH+/pbyCYvaP14sawOrPk0aipbT+3DjI3T/rIR4pV7PQvQbow6bNfhSalS9WQf5aQAz/n0JUEmolKsV4+ofkaqICQELKjqei5QPv96u8taiX/4hel0zialuyNXZJwD7T7913a8al7m71GRFIrI7w9FsEwyIckpbawUYtjhO1AD0p67Ga9c+334bi/4B3A4+ew3qt9uL3fdXKrtRBK4jypxk4GY4N9GMfbdPVw7OIv/qrWf9PxwSvy8t0Z+a7CceCBd7nyXeZQFmH6xfZqmNOryefJ1mkxSyQXibN/Oh7xlPhELbZZoy5MHr7HbiuGQJEkVnFyvVr0i/7IX460Gaj/ezk9q9ZPF05xwduyGuFyNWrs4dya2wkEol7MP9LWjdQ4jwcNo7dUZV07XIEgYeUG/0x1XJdqtdwrs5ss1oJxWWg7oLO5QeBtTySz6tRWcBkh8aXdoRRFl49UXQcC159S/oa+FnLjUzSQUOy6tTlMrO8IpKX3X2dyEtbKIxNehHUrk0RTQZATE6U5UL5ZtbST6JBUuxpgBUfica6zrs8Jy3Jt5i4SnXGczgq0JwCUXLtKqbYRvPVwKGMz4+nxRJ8R9xy492/c3Ln2uZuNFg5ygF42FacVPCqY3PjAorYGYY1m9GSxkFeGkb+QyuNSBveBSQ5ys+UCMwxOVu4X15zBpNwhfVqCvqNcsnqyvdRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39830400003)(376002)(366004)(136003)(396003)(451199015)(44832011)(186003)(6512007)(6666004)(26005)(6486002)(6506007)(2616005)(316002)(54906003)(38100700002)(38350700002)(52116002)(4326008)(86362001)(83380400001)(1076003)(478600001)(36756003)(7416002)(2906002)(41300700001)(8676002)(66476007)(8936002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nsh9aT1vOr7aO26v4YiAkC1/7VrKaft2+5uNxmDr/qrCI8fDbtHLD+lxtf3M?=
 =?us-ascii?Q?VjWx+/DcpQnEPWTGhTdOtOgSzz127cRkg2YCJwclZjYu8ruSzF+T7Kz4OoMN?=
 =?us-ascii?Q?q8oQtW5DJ5SzhsA1b7iRKwHxk/YOAF7SxtRqHBV+1e/6O7JQetSNxSjULxLQ?=
 =?us-ascii?Q?hltqsiqV5zy2CViSZo4IVREB9hztAryYfZzwydrATZ+61a9+lmjv+LjU+uyz?=
 =?us-ascii?Q?JxEwEAgwkscd/42AOstJyYhoWqe9fmCxv7J/iH7PKq2gsElXdK/NsJ67lApu?=
 =?us-ascii?Q?9SVoRT6ojWdZgaeGuazBjaIFiOdEeQpkxqz0LmFYAXofMfMkS3KsSWp/ErIj?=
 =?us-ascii?Q?VCdX5m4MDo/y1osZ5fc0J+oGKm6IsI3xnjRS7vcEb6Q/dFeC2OqTb0qval3B?=
 =?us-ascii?Q?rlHdxJ29yePHXoUrMCnl1R123POcJv7c/nC4ccy27CvyWe/ZuXz5BDOd5HBg?=
 =?us-ascii?Q?NH0Fr2VVjZImR5mMCfE7HhCGS/cgOZBU/sAZYZrHQE9Kq4e69HOhK9UDQ7iy?=
 =?us-ascii?Q?ZQYZWDk6qidYqNnIdRmXMnQjp+DMoa2sa/RCiwMpUoXIwQHwkfs42QSkgOX0?=
 =?us-ascii?Q?cKaGve+1LTjQ0mdZS4EwdA8F4WfY4Zf811GAPfVI0Se+qQeNm3Sht1zjWpwZ?=
 =?us-ascii?Q?c2TpQJyc0LrRC1fdn/+irY5GtbZCBosAXBuiNM93cRaAbiXQI7OFXvirXEPV?=
 =?us-ascii?Q?Uq2hC2cRJv6zclCkUy3lkyKa4aUSQ+04qxZamqe1oNMLqf8aNNeFa58lqKky?=
 =?us-ascii?Q?q9GFtteVaMR8lPdCliTe/pKMPu06HMhtir+pdNIn0KgR4XyP8KrmlNrs6YVi?=
 =?us-ascii?Q?rTASLbZ+zSVPguhBaSAj5LQpRsj7x6AdBnHIPOsjbMCIowlCRIT/cVtXgJFW?=
 =?us-ascii?Q?Dc30jD/WgElDzWbA2NYHS7Gu3mu0lnBrIt4iwcRtacw4Y7g0hYpymjCsxMUg?=
 =?us-ascii?Q?eQwJtME4lBZu0wXDbgTd5F8OLKQCI+YwywlmsctmQLFe6uWoFRBT2i+a4NtQ?=
 =?us-ascii?Q?hcJsJbOETGoacHMm/TZZeHZDzzUNuA4hbsIL/WIcGYeA/vQi+g+zT0Lgz/OW?=
 =?us-ascii?Q?9G5gvW0grRlSs//z8k3hqezfv74oLMveh5ESJuoV7fl9XmA+ZDlktZkhbAs6?=
 =?us-ascii?Q?FL/IMfpEzxGoFGD5UguqHsHaHc5rpuA79OOm/ThFqJ8SuaWs2+tbhcmng8If?=
 =?us-ascii?Q?l+2lnvAx7EPyvuLW5oPvwODEIhlkAzN+OAYOlP/pK9tG66kjVzGVp09H1zOf?=
 =?us-ascii?Q?W+IodVgld8w/JF5oV6qwZ3w22eJBOtaLMOMo9LHijKm/PZEoPZf3mmixTFF3?=
 =?us-ascii?Q?XJJNN054VR9XeN8Ltdsv/DTprOkrNu6P1yl7b6i+GBitbFKNvf1twuT5QBkr?=
 =?us-ascii?Q?peLlvG53VzpPt59QRSEaznqKW/pXYsUNwWRVCEXYIBPsY/RvdquG8KJUsh2i?=
 =?us-ascii?Q?+uRnf0mjPDHIwx7uRga7HMySdPrMcz7oQL+APsKdupq8+/ROcua/0tVrvoVa?=
 =?us-ascii?Q?3qYTGdnjAQuPy38piGXULXT5Fqw93vjUZgZDrLTdzfyFCJDKZdmdRaN5iMGE?=
 =?us-ascii?Q?VGlLJBUbty+4IG3QS6DwnqLnP12YHJBt7FSl5H8sXiheHMkHsc685dLdGhDp?=
 =?us-ascii?Q?Mw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ec486f4-8b98-4e88-bec4-08daa95e31ef
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 18:52:05.7568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 54HsoY6HTUHEvx6+RMbPuAILE8DtcMj01watjroucQIvEl6QEdq70KBdy5FPGMSsWNl7GSS8FU9KjnHDs393GyO8P/0daZzqEwEQGRsrugo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6129
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The vcap_props structure is common to other devices, specifically the
VSC7512 chip that can only be controlled externally. Export this structure
so it doesn't need to be recreated.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v1 - v4 from previous RFC:
    * No changes

---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 43 ---------------------
 drivers/net/ethernet/mscc/vsc7514_regs.c   | 44 ++++++++++++++++++++++
 include/soc/mscc/vsc7514_regs.h            |  1 +
 3 files changed, 45 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 4fb525f071ac..19e5486d1dbd 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -181,49 +181,6 @@ static const struct ocelot_ops ocelot_ops = {
 	.netdev_to_port		= ocelot_netdev_to_port,
 };
 
-static struct vcap_props vsc7514_vcap_props[] = {
-	[VCAP_ES0] = {
-		.action_type_width = 0,
-		.action_table = {
-			[ES0_ACTION_TYPE_NORMAL] = {
-				.width = 73, /* HIT_STICKY not included */
-				.count = 1,
-			},
-		},
-		.target = S0,
-		.keys = vsc7514_vcap_es0_keys,
-		.actions = vsc7514_vcap_es0_actions,
-	},
-	[VCAP_IS1] = {
-		.action_type_width = 0,
-		.action_table = {
-			[IS1_ACTION_TYPE_NORMAL] = {
-				.width = 78, /* HIT_STICKY not included */
-				.count = 4,
-			},
-		},
-		.target = S1,
-		.keys = vsc7514_vcap_is1_keys,
-		.actions = vsc7514_vcap_is1_actions,
-	},
-	[VCAP_IS2] = {
-		.action_type_width = 1,
-		.action_table = {
-			[IS2_ACTION_TYPE_NORMAL] = {
-				.width = 49,
-				.count = 2
-			},
-			[IS2_ACTION_TYPE_SMAC_SIP] = {
-				.width = 6,
-				.count = 4
-			},
-		},
-		.target = S2,
-		.keys = vsc7514_vcap_is2_keys,
-		.actions = vsc7514_vcap_is2_actions,
-	},
-};
-
 static struct ptp_clock_info ocelot_ptp_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "ocelot ptp",
diff --git a/drivers/net/ethernet/mscc/vsc7514_regs.c b/drivers/net/ethernet/mscc/vsc7514_regs.c
index d665522e18c6..c943da4dd1f1 100644
--- a/drivers/net/ethernet/mscc/vsc7514_regs.c
+++ b/drivers/net/ethernet/mscc/vsc7514_regs.c
@@ -644,3 +644,47 @@ const struct vcap_field vsc7514_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_HIT_CNT]			= { 49, 32 },
 };
 EXPORT_SYMBOL(vsc7514_vcap_is2_actions);
+
+struct vcap_props vsc7514_vcap_props[] = {
+	[VCAP_ES0] = {
+		.action_type_width = 0,
+		.action_table = {
+			[ES0_ACTION_TYPE_NORMAL] = {
+				.width = 73, /* HIT_STICKY not included */
+				.count = 1,
+			},
+		},
+		.target = S0,
+		.keys = vsc7514_vcap_es0_keys,
+		.actions = vsc7514_vcap_es0_actions,
+	},
+	[VCAP_IS1] = {
+		.action_type_width = 0,
+		.action_table = {
+			[IS1_ACTION_TYPE_NORMAL] = {
+				.width = 78, /* HIT_STICKY not included */
+				.count = 4,
+			},
+		},
+		.target = S1,
+		.keys = vsc7514_vcap_is1_keys,
+		.actions = vsc7514_vcap_is1_actions,
+	},
+	[VCAP_IS2] = {
+		.action_type_width = 1,
+		.action_table = {
+			[IS2_ACTION_TYPE_NORMAL] = {
+				.width = 49,
+				.count = 2
+			},
+			[IS2_ACTION_TYPE_SMAC_SIP] = {
+				.width = 6,
+				.count = 4
+			},
+		},
+		.target = S2,
+		.keys = vsc7514_vcap_is2_keys,
+		.actions = vsc7514_vcap_is2_actions,
+	},
+};
+EXPORT_SYMBOL(vsc7514_vcap_props);
diff --git a/include/soc/mscc/vsc7514_regs.h b/include/soc/mscc/vsc7514_regs.h
index d2b5b6b86aff..a939849efd91 100644
--- a/include/soc/mscc/vsc7514_regs.h
+++ b/include/soc/mscc/vsc7514_regs.h
@@ -12,6 +12,7 @@
 #include <soc/mscc/ocelot_vcap.h>
 
 extern const struct ocelot_stat_layout vsc7514_stats_layout[];
+extern struct vcap_props vsc7514_vcap_props[];
 
 extern const struct reg_field vsc7514_regfields[REGFIELD_MAX];
 
-- 
2.25.1

