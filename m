Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E98851EF2D
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbiEHTGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382586AbiEHS5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 14:57:55 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2120.outbound.protection.outlook.com [40.107.220.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E427DBC08;
        Sun,  8 May 2022 11:54:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bpZKIv0NOMsR84cAethfKsjqu4r/8ioYJRCcodY1FygW9G5B41XudC5z9o0EGZ8xu5RTTEiZ36ZUwY606D5Y+XiJGPMa9lqIHHPNETZUPcNh33f4Lcxr8gLM6jMGu+IdWQEx4c0IQMlOGUA5pYEA4qy0fWrsDRE5AReJgnvtGfULQFew/aE/6QMEL63d34JJiPLnWAAeFvsO0a8orvLYBfD6TGrzX2Z3hOUO9stXMd2cU2tGhxuQJORY3vhVdK4p3+k7MVvMlyjUmLnP3j8/6spw+Wi+TaDYFvxIIyW9mJYFoIUWafCjbY1OCNEB04K9a4djbBHLMYzjnPmKg0guvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=klkHYxiwmtQKjgQCKVSJBS52EVCMHgIGfrapPeWTcT0=;
 b=AqLLcQxfXG9gsuRp2ix4D7auGTf0b8OVjJA9WvxrJx+EM6OtpzoRQeCzBYcg4vFvS8xsdhpXsmYTpotNMF06ri05kNLoUmdyru1wtlRPo/EfKXkctvsu+LdKeg1XUSrbJU04au7wS4AqYpQSBoqOiB1IsngxsfbTVpWk/zS9Yk6I9tylIpXHMeyNy6QExEDIIMMkO+DRtxwmg5H7ybjyYPooktV8wYx3x3Il/kI4XiNx6LdvjnoX6XBu0yFKgCBYLL/HsXT1P4EpfYUV1dCazsHiXKBRl4ZmLAcz0MZyEzain+VlqgiCqwJBTgsjljJHcQMXV17V/CxJzmUgKY6fIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=klkHYxiwmtQKjgQCKVSJBS52EVCMHgIGfrapPeWTcT0=;
 b=SUDBOOoD36HmacAoYrEskyHhyPw0HmDvg/3gOlJhgfXBMm+DbPESHrZyNrQMa+DvsNswzeUyrSbrnF8s0mkHP4MKmy0xIHXM8ZiIAisvia1udCDeqOmDe7Ddtv0gdyHCgN1sNWPbsYyNXkMY+2ugTgKim3xDtFXkPrH0MeD3LGQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5672.namprd10.prod.outlook.com
 (2603:10b6:a03:3ef::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Sun, 8 May
 2022 18:54:03 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Sun, 8 May 2022
 18:54:03 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>, Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v8 net-next 15/16] net: dsa: felix: add phylink_get_caps capability
Date:   Sun,  8 May 2022 11:53:12 -0700
Message-Id: <20220508185313.2222956-16-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185313.2222956-1-colin.foster@in-advantage.com>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3f01866-f363-43fa-18c1-08da31241f08
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5672:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5672E3469A0C2C65D41E972BA4C79@SJ0PR10MB5672.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eto3a/SxddKm3CrpI3G1WHQlo4hieVpMWQ6yG6Im1MXbvKoThSyPFek5b8vo06B76rvtya+qUSj/OKsLZ6vX3WzdJnq32z+CtFGorRT8rgmr5bDchN8mRRkReswK75KISFHIpusuXCsrOyqhTurx0oMCEQFObYzR6LYA8xP76npejWxuFvBupVgx8UFZEH2egap+mMTfED49W/zX1hfRQOSpHW6CAu4e/O5a1BK/GUY8awmoE3dcmvp5xcAb3CzaAUp/qs2dmKCXr5uQiZASQtMQ8QGVJMI0GqiG1LQtCCsv+/OoeDw6MyKJXLKaD8kntdG19q0rLvLyDWQGZNw/IioXAeL5KTAZARe3VruUq5HMqDKoPvCJj4kN4Hb3YGyGuCLCVUynYkJMnZffKifpIeJ+94og9xU6/T4QjcS4xFenZN7Oc051vmaTR1yd4RHNkykZ2Hr6J3MPGQJFW8KE+njciQ+h8niWDF/drGqVifg7ew8L96HeoFWxWTRpJcXDweoCyK+mF4pD0un/1BR7c3bzkt5o3c6XD4XZ+zB5/KdGOFRdLMHsMo/Ugf/RJXO+g/dzHTtduob6oPuZ2E944SwhO097AUjEcLyYgAVQfYBKaPLqWr62xEm/aCAurC4/CmcCO3Phltb6HdukMHacRyfpbNxQ+k4+7ehNWZBmIIfos1ZoVEoXYwoNqrw7j3Lu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(39840400004)(366004)(346002)(376002)(136003)(6506007)(6666004)(6512007)(2906002)(8676002)(7416002)(52116002)(8936002)(4326008)(36756003)(5660300002)(86362001)(44832011)(66556008)(66476007)(26005)(2616005)(66946007)(6486002)(508600001)(38350700002)(1076003)(38100700002)(54906003)(186003)(316002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r/l9BDHdkzOYCiaBY7c9tcmZUXIrZplRxgdjzXCYUL2ixCtHPaWcGiqed8PP?=
 =?us-ascii?Q?pwki4HKJQffrFJkRpVlJeRVAK88812QEX8RsU+J63TCklzjCfRMX3ikNOfmf?=
 =?us-ascii?Q?5FwpuBCGOZpfbbVMXoxm2dup9FxE+Qf3kbpv+cl3NSJJQ4P4v3Ll87tXG3oG?=
 =?us-ascii?Q?Poan4cGHxsaQ9/Ewer39frzTRYkUP4DQ4ckkDShqTG4VglJsIVmel24T+Zq9?=
 =?us-ascii?Q?FyP5y2kSobo9sMErxipvHrRn0hFDq8RQ+S77Z+IZt09YZGtUZ5luHL3AF2wv?=
 =?us-ascii?Q?WBAOXwale8R5UccivshDd1QiCHJTo5YGSp9WLCtxDX8+fQr6YAkzL3/TLxCH?=
 =?us-ascii?Q?m52x/sQXvmLdO0Ghl7nxy/x9V6mjvnBJuW86WuniZFgXF8Gal31qTjXP2gzH?=
 =?us-ascii?Q?YvoG/EuXaaRl3G797JoiJlvDXbugjwtFlxNW5OUiaKbOFg/VL3/vANo0A4mu?=
 =?us-ascii?Q?hFRshuevl1oSeXzoMblZOjizuL+hugfvmpjcQujXhA5TW5WfgX+SuVYEFelK?=
 =?us-ascii?Q?ioLbr3CUNh6DYIqeFoKoP+V2bSghlBB54nE0DkE3vt8VctxSk8hkMr1KzWiP?=
 =?us-ascii?Q?1EbJog3BniFpFy6TG3Nq1G96Zr9izgMk1BQj+HKR1m3QEDgRaF9p+nGrh3+s?=
 =?us-ascii?Q?WiSmciiYRoUxb79wFXai6hRKQ/4vUibMn4UDdU9TWQl4diuvhTKBIw0p+ez5?=
 =?us-ascii?Q?TPwmeIXmtKjA6tuT5zDf9d/f+RQ1kZCyO66jX+CW7Aja8zq0xiQ1x7fzxITI?=
 =?us-ascii?Q?z+z4eOtpEPzlUEoqiXttWRftOm7yiYVH6G4b08Y4+I2AWTSurk3mbN2BjlgO?=
 =?us-ascii?Q?8DdauqA6eZKYIVO/h6kMDUjgERp3xKuKLKa9HrAspShnEXFFUqPkEBw+CNOD?=
 =?us-ascii?Q?gxyZfxYgVKG64j7AyesEhejYJ73PMXtaV9cajJeZokzIrVkG9bBz+OqyQ5+y?=
 =?us-ascii?Q?z+GhnrWrgUBtu1YRVQYIPEH62N41/xlKXUjKbczB49gaav1u8MQs0E3s1uWR?=
 =?us-ascii?Q?MNt/sNTwGhaAguKv2cw3qCpG9w4T/IUkQWqxWvRhoeVneWSOOn1NQIfOn2Zs?=
 =?us-ascii?Q?T6ID7lk59TQrkoYS8JKbiy/jcdhA7CgbNyDEchDUyhRdOLU+l41aWK3d/Ul5?=
 =?us-ascii?Q?vHlpzWQHjF/88z1Cm0TB+DDnrTf+9GYkMA5mzOATkwlDWNQBM4JwQ/E/TN4G?=
 =?us-ascii?Q?uaAjf1cW3mRDT/WcaYuEGRBjZY3mkWsuYgmekjFlS0HqiGNS441S9OWGSPCa?=
 =?us-ascii?Q?852eTB6Cw+OAx1TQWNkErz0285Xfvs2dozNdeYZ95XfaVr4evxCqAbnUjMjz?=
 =?us-ascii?Q?tNpDvtG8dsMWG7MfEQLHp6J82HWIP9NLIDCYe9GTFSe0jUK2Pr55RZdWAAHD?=
 =?us-ascii?Q?sUmatRlEJuPDWzSdvZYBIqXoxxoIAzFnNa6ScuDIROExjpQUwvcrcL/n7PLI?=
 =?us-ascii?Q?RZyjIlEsWAOt4wJ7IQPpEM14wfsew1tHb6jcJFFkRLy9NzjJ53o658IV3hQA?=
 =?us-ascii?Q?TyHNB3hk9tz9uHdUYB/iOTrmLxofZXGNtyprlcrGevBLz4s276UH+wM8ei0I?=
 =?us-ascii?Q?gWNJdY/g2vtJFms2d8zEBlWiQDjE8fokMfHwIxVLNbZZA6hCtxWqELGqQ4Fu?=
 =?us-ascii?Q?8swWcDVF00qoXaFguMTgSV2bomD67J+n5SJpx5L1FVsNNudfqfyTapNBbcUb?=
 =?us-ascii?Q?ftNoj1zvrDcseg5Uff6YsqOo/QZHT2OkF0yvEt7Dhfqgl93V3Aa+u8jwCkVR?=
 =?us-ascii?Q?cqyPvPa2Ebb0IV5DRulpogb5q9RhHLYJ/XYY4Uw6v6sT1SeqE0Sf?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f01866-f363-43fa-18c1-08da31241f08
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 18:54:03.7898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fmjs4E/dRn8eInOx55FW9timfPqiTSYwkZIQUGbEZ5wA6bmq2nZxmqKDYM1X2ALgG+vNrDJPlYC7/Gi3kaRSTzjwa2OBq7zT1JLP7SJMajk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5672
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the ability for felix users to announce their capabilities to DSA
switches by way of phylink_get_caps. This will allow those users the
ability to use phylink_generic_validate, which otherwise wouldn't be
possible.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c | 22 +++++++++++++++-------
 drivers/net/dsa/ocelot/felix.h |  2 ++
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index d09408baaab7..32ed093f47c6 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -982,15 +982,23 @@ static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
 				   struct phylink_config *config)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct felix *felix;
 
-	/* This driver does not make use of the speed, duplex, pause or the
-	 * advertisement in its mac_config, so it is safe to mark this driver
-	 * as non-legacy.
-	 */
-	config->legacy_pre_march2020 = false;
+	felix = ocelot_to_felix(ocelot);
+
+	if (felix->info->phylink_get_caps) {
+		felix->info->phylink_get_caps(ocelot, port, config);
+	} else {
 
-	__set_bit(ocelot->ports[port]->phy_mode,
-		  config->supported_interfaces);
+		/* This driver does not make use of the speed, duplex, pause or
+		 * the advertisement in its mac_config, so it is safe to mark
+		 * this driver as non-legacy.
+		 */
+		config->legacy_pre_march2020 = false;
+
+		__set_bit(ocelot->ports[port]->phy_mode,
+			  config->supported_interfaces);
+	}
 }
 
 static void felix_phylink_validate(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 3ecac79bbf09..33281370f415 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -57,6 +57,8 @@ struct felix_info {
 					u32 speed);
 	struct regmap *(*init_regmap)(struct ocelot *ocelot,
 				      struct resource *res);
+	void	(*phylink_get_caps)(struct ocelot *ocelot, int port,
+				    struct phylink_config *pl_config);
 };
 
 extern const struct dsa_switch_ops felix_switch_ops;
-- 
2.25.1

