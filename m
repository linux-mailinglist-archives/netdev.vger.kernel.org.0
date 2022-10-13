Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104DD5FDB12
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 15:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJMNju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 09:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiJMNjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 09:39:44 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2079.outbound.protection.outlook.com [40.107.247.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1F71AF
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 06:39:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XSMleEuSu1qH8zcc6FOU2d3qCvJrC5HC4A0UHPQRVejvAesXB+ue3xtH4znPqI0od1+PdXF7k0DWQcvMPN/ftLkrmFITsmnGS7bzpGu87tsm94dAPstlTRXI0jEQDirJMaptHWT6PiaAfvi1gYM2h2zuLT49tCGbo+vtjXw/vvE4mPhvmg1NJpefZhL7LG+wA7dEn7SmszRtWtlcNAp8vd7DyaTxxVexSV97cOo6lxwgkdK0Rck+s2UBzubWYr/yQY7g3/CzDxqIaInCCk30qJfl2T/+RmkjBugQaAZ81vnkbQoprfYDkDQeYie8AVSLU2sObfO3bRoSeHBD0eEuzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Up+HCRFI/ixMfUUTiBA4idXYXTMRKvEGWADMTLPGyHI=;
 b=USc23n5fUNz3hwVaO4KGMoiJcO9Lm5BZ0qKKHiVMqlmqsHBWwyQ6kHLv14uCRWQiwL0GPmSH5qtK4tyMN6/NU7Xx7glc0/o+u/XQYEhohWIZVkbW2WLQgGjNuT4gBq+nfFLph0BvWqRGnWYfnx1KCMNGZoemKfi9xLTvwpOQR4uQ4wb65Dy6GAdp3MM5dYYo1euMo7+7cYsU4r76Ctld3B3Jtrz+1sXudMSE9igb1vleNU0Y/b8t5in+JiefMeZsVYwcEDo8yRg6/pL5PgckRg24jHTjwpW4bEUtX1SBVVRgllZyaE1+A2QUHw0IVgD0nCSA3RgVDdjzP+7KEmkH4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Up+HCRFI/ixMfUUTiBA4idXYXTMRKvEGWADMTLPGyHI=;
 b=C8l0RbbR1FwFK1XKzpzoYkr0Kvoy1Vve06db3Zxp9Djw2r6gJvwau8wPgptsjOb7csTIZg3vIlcr1P7h1la7qOWLdi1JXOZRum4avpn3GC+c7kCQXhWG9Fp4AR4VMP3aUEjLo/eVsbDYdHVqJz/f9V9fl5xYVQ1t2u8YqlIdqSc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AM7PR04MB7141.eurprd04.prod.outlook.com (2603:10a6:20b:11d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Thu, 13 Oct
 2022 13:39:40 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563%5]) with mapi id 15.20.5709.015; Thu, 13 Oct 2022
 13:39:40 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v5 1/2] net: phylink: add mac_managed_pm in phylink_config structure
Date:   Thu, 13 Oct 2022 08:39:03 -0500
Message-Id: <20221013133904.978802-2-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221013133904.978802-1-shenwei.wang@nxp.com>
References: <20221013133904.978802-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0069.namprd05.prod.outlook.com
 (2603:10b6:a03:332::14) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AM7PR04MB7141:EE_
X-MS-Office365-Filtering-Correlation-Id: a1705d8c-971a-4c09-cec4-08daad2060f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VNVa8WcocWRPCeqBWkhGNdb592fLxvSmpAjSeLg28pC7EaTuZ2rio7kfAxGClHBtdudfVYKZ4gUn4VhS0aGSrX0yVmS4ze5gsYj/u4GCf3Nuv7IUWzlt6t/wf3CSZ8A/E8GU104LkRFsDKkaHc6UgDjxxKMj63pC/Pr1RDnESwk9zLwQuowwaID3xUSAW2UHvkebc5gSZDCa0AuwjosfdQfL+W33qqbD+ayEbPbt7qDMyAE4aqoAjJDEvDnTQ6QlgdLMw2HTbqYvhBU6+QgbivvJ5fnr4pqpo5gOCfoDULcNLI7fFoMsxbJY0ppXQ5c1cLgiCPIho04sqwJAON5RfKkdkGP7RMGT7zz1cN+519FumcPVIJLYe542lRXernYt0JYh3rQ4riEEhuTKcQs2SHbacUMTZBfhrVLnfEFcf8b9Imyx+8mw+1mNILqOdqRpxX/6d0QrMqXzi72hKYZch8jxJiyZuNhve1LIMK7gzM8fAXSnReJk8NyFlucXZvU3axsIe3jWbSrzZdDIzoa3CpK0CTCAsKEfcXq0ABu+iPtQxuipfn+XOp5SBw2x6acHd7IfaiNBNFX0KBnGV8TKUPrw2z/Q4akxf1nRrpXLk4m6IfsS6wrA9QF2ybCeVYiyw0PDZfAs3cLcN9x9CcQH+FhQ1ikVzYHRevIgu47M0hmMpV45CP/9cMDFIDwP9hIlat4NNAHBsVK7YjAi5RlD2H4/WqMvAs7kGCyxhN9VoHVAW0zbSdPEb5BG6h0SsU7Szo/OpdZUq3oxrzjxmByyKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(451199015)(6486002)(478600001)(316002)(110136005)(54906003)(6666004)(8676002)(41300700001)(66946007)(66556008)(66476007)(6506007)(52116002)(5660300002)(26005)(6512007)(55236004)(8936002)(4326008)(36756003)(7416002)(44832011)(86362001)(1076003)(186003)(83380400001)(2616005)(2906002)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0KI64rEG5ArIEP9qcaRJfsAqSmQk8J39HvUgXcsxAA0bpWZ9NAz5wV/0v1x+?=
 =?us-ascii?Q?AiKni6kVb9Exz25nTsTzRe9B7wbb5oT0ayqjkuECu0PA7eNRE737g6BYM/5T?=
 =?us-ascii?Q?WxRNi6G3WVvd2n1m31wZ22AwSObZZ6UhvtvpnBLP4cFKrNBFE/Mhu9hlef3S?=
 =?us-ascii?Q?1+xEhNkPk9Yyal0Kt5baaOfZ9alN58a6IEXFiKzDoa1B6bHAMAXzHKie14Oh?=
 =?us-ascii?Q?z2Jt/1X0Gbj8UvCepX/6+2LJat+uTIl+OTNgpKtj9m8QBXSYvpAfQzVnA6xL?=
 =?us-ascii?Q?iZoERtdp0k3Fn6IX9SRSsK27cIXWxcwX+trDr0opVV+JaERKXxn86ERAJG5T?=
 =?us-ascii?Q?QXvigFeifePjl0vlozrWU5aSVa2tWn8xtqlU1UmrhhbQ0yCuOA2WM9VrNuol?=
 =?us-ascii?Q?oa3rgcCFoWog0rqMl3Hf8YntGyYHuotlGNr5iBVDVaygl3mvSsARpiaY1vEU?=
 =?us-ascii?Q?ZknqdnzL7wGuvNGuWIzi8xaOTf24tBq63bOZoTH4EU4OVEy4Icru6+Adg4zt?=
 =?us-ascii?Q?l55ixbkWppSf21tf7QzZ7HUFH4pLTKU658+/zAjiRWXfhJBR63B1Spnj0Cu7?=
 =?us-ascii?Q?2y6j5WqvkUg/0e8pNW9waYIWBus5YVgMxoCJa8pm6Qr9r3/fzzdlfqg2cO9i?=
 =?us-ascii?Q?zMrPSKWxr1JyOyXnxfx7ZIW2K3Ibs5ECXNEXbh907m0AHIkQzaukCQeMWLAp?=
 =?us-ascii?Q?lFRYqCe9BFiIopgMWW2OsUWk8FjipAelW/21Xl+fq5uOM9YZKPPIwQGshiMc?=
 =?us-ascii?Q?qTa9mnV+MilTTCYhgcpT1WPhDt83dZIb8i8265jPWyXSmh+I8iKJxU/33ryG?=
 =?us-ascii?Q?IVjIXbPbfz8RBXkB2a++AHEMJmLYZCHHAO8Tk8byPBu3AWJ1dCyyomhJKKaY?=
 =?us-ascii?Q?TXLwN396au+pCgi2Qe5Zo1nC6/Va60/nGuMnvIldNaDiocufTGjvM5cVbzMh?=
 =?us-ascii?Q?ONV1N8xLjY1SCR9LAY7pxlxoZkooMGUG8mFGJw9UxqEWhuA0umA/og3DzfKA?=
 =?us-ascii?Q?HMr7yc13mcwuXXRUEr6GXUDbB/imDNJyMcnOkZU3Mbmv43wgMfi1DnkiNigO?=
 =?us-ascii?Q?8VZ7KoS5IrRWzrkiIiZzi2MssVOL19ZpqA2jIiyLvSgGNI1rPZerCdwtgXQC?=
 =?us-ascii?Q?102dn0tsZ9WLzu9vZ82RvhKX0XYViHrRKBCirBDOHIQ8ECQwQVRQE2HwQAnL?=
 =?us-ascii?Q?fBMW5GWqnosC0JnfSzxfU/af5qtUMa72nCsEsBjXwF//+DH674u26jZtOAGT?=
 =?us-ascii?Q?/9tnseUXEIhxPim+1kiZGSrKzbEWd359t5mR510TvVQbJUg2qB70qzq2FxuK?=
 =?us-ascii?Q?btxMXyI11ehoVdJ2Krs2Fd3g/Z6gHenm6Tdh87wtKnjxbA2YIWzQTaNL4UCx?=
 =?us-ascii?Q?NPzF8F7kz8OcjRQZcWtYtPmeREayxobJG212JJjYqehY4t1j8llnCrMQBcsH?=
 =?us-ascii?Q?BIdlyJU7S6yFKaMLsGRygNvC4n6aMnVHZtq3oSDtlF3kcYFO+0YklhoJGVt3?=
 =?us-ascii?Q?qWG+ZA+RFrK15H7xBLV7pGnCo8RB5mDgeA/dQjVdTUmoMQMzm4IwqVMCcKcf?=
 =?us-ascii?Q?/iRc/vm4aBCqBSFmakFQz7eMNM8R6eSTYiSGdwAS?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1705d8c-971a-4c09-cec4-08daad2060f1
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 13:39:40.5552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FSK+coDnv7nU90+4AtNGFRYUHJpjuVCEGP1chxHL8gMO3t8G0SKR2uz3JgUyZBbNZYdi8KBMmwuaFNUWVSGctQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7141
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recent commit

'commit 47ac7b2f6a1f ("net: phy: Warn about incorrect
mdio_bus_phy_resume() state")'

requires the MAC driver explicitly tell the phy driver who is
managing the PM, otherwise you will see warning during resume
stage.

Add a boolean property in the phylink_config structure so that
the MAC driver can use it to tell the PHY driver if it wants to
manage the PM.

'Fixes: 47ac7b2f6a1f ("net: phy: Warn about incorrect
mdio_bus_phy_resume() state")'

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 3 +++
 include/linux/phylink.h   | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 75464df191ef..6547b6cc6cbe 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1661,6 +1661,9 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	if (phy_interrupt_is_valid(phy))
 		phy_request_interrupt(phy);

+	if (pl->config->mac_managed_pm)
+		phy->mac_managed_pm = true;
+
 	return 0;
 }

diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 664dd409feb9..3f01ac8017e0 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -122,6 +122,7 @@ enum phylink_op_type {
  *	(See commit 7cceb599d15d ("net: phylink: avoid mac_config calls")
  * @poll_fixed_state: if true, starts link_poll,
  *		      if MAC link is at %MLO_AN_FIXED mode.
+ * @mac_managed_pm: if true, indicate the MAC driver is responsible for PHY PM.
  * @ovr_an_inband: if true, override PCS to MLO_AN_INBAND
  * @get_fixed_state: callback to execute to determine the fixed link state,
  *		     if MAC link is at %MLO_AN_FIXED mode.
@@ -134,6 +135,7 @@ struct phylink_config {
 	enum phylink_op_type type;
 	bool legacy_pre_march2020;
 	bool poll_fixed_state;
+	bool mac_managed_pm;
 	bool ovr_an_inband;
 	void (*get_fixed_state)(struct phylink_config *config,
 				struct phylink_link_state *state);
--
2.34.1

