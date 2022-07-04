Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD13565DB4
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 21:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbiGDTDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 15:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbiGDTDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 15:03:09 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60059.outbound.protection.outlook.com [40.107.6.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC20DB1F2;
        Mon,  4 Jul 2022 12:03:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=esZZB+0LEMIybGH/zrzIGtWUOWMN+x3kF6mHcHv8GVBZ6H0upy+/1NuhMt9iAh7NvaYTZ+Xy0EYEbJAbZkBDPE9KKYo6oGJr4ExXDVy+DF6RUpo4Ux3bfNhMdE1bdyDbyR936rOwKDeSDkxicr/kG+DgNP2h4H39ssGRuKVbzzh94T5knIBpdoEmbKqf1NAy4sX6W8HXD0VKQ/KOP6RH7g4VrvJ7wza24x9x6Ab8upc7BOgw7ywEh3AmrtxMOFNgDyqDq8qpE1D53+Dg8U4xUAdblTJ8dJwJnHH/qvDj91cMbVjxQFD3KTyRxrkF6zMGMKbrHgGh9jP9P5GADYl+KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q15J7F2/pqSp/ZWwpf0ssOCcrUtsgk/HHZsdLW6tE18=;
 b=Uk/4dHUoUaIsDX5pKeQaeNlr+ngANLX6pB0oJgdaOXxbFbdSrTcKrUAtS3mw+be/3U5rx/TsGj0NhXhCldbBlTZuND7WuhFIBkJI6KJqwfsCOtVf1LPFvDczFNm6QADIY5IEHwI+LyLuKpmtAuZWR3K3jWjEUZ+6Ly/viTQilOW0ah6K47DHMoK3ZxBTVxtQc3RsxrCK2wVePQrFm86TfZoDCWsLcHun+qrdNjsFsbMBEARtTh3SEt9EXg08pCKem8nt98hjcP3er57Xi7fXMNOpsE5NiR0kOVQVvq+5sihf5w9hdDu5MnNRXzFklOIKdgOWfr8lcclgg3km7YsxJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q15J7F2/pqSp/ZWwpf0ssOCcrUtsgk/HHZsdLW6tE18=;
 b=OLrHVPH8FDYga3f/yt8LQ4LhCQI8/tN97SyNgtm/4vQBE7Z8qSnStx41f2lZRwCbefGLvaCtAnI1Z3YYL0v0vhelMOSzvVm9KIiuS+cHSaG1vzX1FyK4p+3C6pTh9MZwihcWS8UcIaN6s9EPklFnUP9EyRoGt3ofxom7fH1cLa0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM5PR0401MB2483.eurprd04.prod.outlook.com (2603:10a6:203:35::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Mon, 4 Jul
 2022 19:03:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.019; Mon, 4 Jul 2022
 19:03:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: dsa: felix: build as module when tc-taprio is module
Date:   Mon,  4 Jul 2022 22:02:41 +0300
Message-Id: <20220704190241.1288847-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220704190241.1288847-1-vladimir.oltean@nxp.com>
References: <20220704190241.1288847-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P18901CA0023.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::33) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 947c3580-44c6-4851-5e0e-08da5defcfcc
X-MS-TrafficTypeDiagnostic: AM5PR0401MB2483:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lWo8ca4nHMR67436V1MUjs7COK1Ibr5LRLOEDT8MPQ/F7086Wfcq7IyythNhltMl7mbrxoT2gEGmmrojQ7+s7bENE7Tj5WGkWMzRkjCl8k8duo7FW4A42R5wqskt1SURs5zZ9IBdbumqv8ou/mwAXU0gU7YZepWy5VWJtLkYLHGdi+cUSEmkS4nosJtVsf4pJPhX6uFe8yV/hPtWNLWFDDIdS54HuGMrpBY4C6kjgoCuda7ts7ed2h6DrH8XB6HIt6BOWLmUxYRVY8R87xR6NdE7XVM45M3vpi1UsSko0Qtd8ePDiT8vtMUX/PfxC2DISj7ubm4KQGJzmQb7ge7Da1UM3JQkRBxSLDgXN1nhEBKgCF2LSGzG58i6grBkXOFtjRapn9/QQTkmWac3U+1fnCk6SRp54EUYiX9ngq0J6ZnW0WWudxA367LMeJ3ebLTdyOGsnJI04kRbB2v+h4JfWKO4Za16OHgfXLVKdIolOTSkmFTJkxbkBfuBgHC9Ez3UjfaIdMKw5Gto5g5FotJQf6X+AHUkE2SMLf/aBDphYtWp/bMfWausvax6e7oqvlqiyIr6o0/1pKubPbvsAOVeXI2v1oKJC+Upud89mYEgFYM2QdXcor4W/6oDqKb3EeptyANodRRnC2y3RQ/FZlW3S3peyjHCeeu3mmESWbjvSpoVrxKtjnzdxLEblpy/3GK7NLnhNhuQ7qSnYcjtyQXxrBPNeCaR3A0e7ZH5KrSyooyuopoLGCorUDleYNXgG9uLkEiLLT9DybgVufLvVTiRGtsxzOQ4ufTExQGRCKmtnoX5U2s7TOb/3HVdyKlMN0YJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(316002)(38350700002)(38100700002)(44832011)(7416002)(36756003)(4744005)(54906003)(6916009)(6512007)(26005)(2906002)(41300700001)(6486002)(8676002)(4326008)(83380400001)(186003)(66476007)(66946007)(66556008)(5660300002)(8936002)(52116002)(478600001)(2616005)(1076003)(6666004)(6506007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Te8CDdCoyiWD8jI+wP0bAxDyaOfvV/8baR5kq48Er4PfZdMiuJlRXZc9PIEZ?=
 =?us-ascii?Q?I+dX8FlYqBE2xlrvC8KU4eJkLU1rI+lsSXs4dNDh4r1TvzYvDY52mXcYTXiZ?=
 =?us-ascii?Q?5lBgPLHoIkvYfnHOU+w/kVRl1JBEE6oBcLuNmMKOXRtcWHMKhmfbM6XbOK+i?=
 =?us-ascii?Q?UD6BDKaSIqa7eRp4q5rMwUoV55eEeKpTz7wQuZ3w7TPX51s5ZnUpZolrGgsp?=
 =?us-ascii?Q?ZtpuZVZuNPO1jfCwAps+VISC9piXoCPl71s3EyB4pggMIdi/2D8/E4w66HY9?=
 =?us-ascii?Q?71nWDktCzUqWBi6AVY1JH9pxSNs4JvFoei26MKlX4ZOQLXyaQ+0wThjGUP/N?=
 =?us-ascii?Q?OWpWRTENERK6JQJXTZwJ5CsmVhbzAJJsMnzzqqNv/SvzI+U1LT3O5CT+DZzL?=
 =?us-ascii?Q?Hq6IyA8Ygy1v1r9flADQDj7HvSbnC+mNyD7U06h7ZHBcxxlsIfNAzUK0+XJX?=
 =?us-ascii?Q?nQjfXQwKDCSb/QzWPzqxyY6lygQ3ej7RnYuXNt9trXJ7ni+hu1eeAve+3+2B?=
 =?us-ascii?Q?vUEi2HpAPKC8XWVrF8fCP0Ui2YpzieRHp4+r/pTxALL6h/h8UrTaHGy5kE1Y?=
 =?us-ascii?Q?sKw8UemqliYGMRMRAZJ2weBNRvjADcyWOffGviaULn0xymG9KSp3xcQ5fkkA?=
 =?us-ascii?Q?a1waPWfTyzqjHsndnjTW0FXHVt0TDOuAoxDRVlgjJql6WJLQLlxC3dSvfll6?=
 =?us-ascii?Q?XAJdgxcUuYr7QiCf7YJIGQeL7jYGQnEzjkZ3/etlxDbsszpuc4MM7fDElG/L?=
 =?us-ascii?Q?mR+t2R6BD2TOYbMUCuIzA8y2ydtx+TJ8ql767cUIVrVyuO98hvGWK1Ws4+vC?=
 =?us-ascii?Q?EvbU47xTR9vUmIUEx+3tkxtLI0380rDhfNPEmuCdUZWJTIyUa1b9culUU6jA?=
 =?us-ascii?Q?UkcHmf1e6BVnRQiRhQAdnIiTFjHfwUJ5P+//f0A/Lv3h8UKTucg9boW9u4ZN?=
 =?us-ascii?Q?Kuzn3CXjotq8dS0av0KwmYiZueC3CA6NcoYFQ7yVKiTi3iJu+pytStrtnCgS?=
 =?us-ascii?Q?xU3nohG+CqPEEpQUfr03K3/8SR0DL2sKfbDzdubkusLodcUvwelbzY9TLvef?=
 =?us-ascii?Q?9XSwluFOJKiYUqT39tcdZEapieTqJCEE+kQ0YR0J6+k4Xv2FpRFl3lELqiEc?=
 =?us-ascii?Q?8qxHCjkha+BgaOnLqiFEPCMokYEIJHktKz8Hh96a4Gmy9oLHbfs0rYMnR9sh?=
 =?us-ascii?Q?vgCh7vswBQYqI3l+Vw+l6Mb+PY7Ba9drkqSZOhPw5NjeOl+t5N/QYWmBZRMn?=
 =?us-ascii?Q?HvfKuhWWE++A9w7BN8BNGKern82vtPVLWSJSWiJrlLi+zCQGsFdZrsp3+wLw?=
 =?us-ascii?Q?/SeVVNDWGOMpc2JE4EJW+kMkhH14gGZTTpvQHT9p1ExAa8QYHe/+SH7hRoAm?=
 =?us-ascii?Q?gnAKBcD/FDTJc9YyEeKiK3ZXrgk6Tigaqe1SAUctlzhUPmQstzFiGJWknLXY?=
 =?us-ascii?Q?m90ts4Vi9SGERBSCEPU9hg5V+u/sJY5jsgGRnADTi0jZ22gDmzdD6jbHvZ2m?=
 =?us-ascii?Q?Rh6rYR5cN2TT4n3xn02zpO8Hmx9N6XlB75z8YdVo4ihP3WpzxZltsPiDJoYF?=
 =?us-ascii?Q?jEPB+lmvc430bag75ABpC6eVAITx7LrfxPDq0FLZO3RtR6STK6mfEKLIjApZ?=
 =?us-ascii?Q?6A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 947c3580-44c6-4851-5e0e-08da5defcfcc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 19:02:59.2752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4DrF8whilMih/11ib1fKuXkWbEdt6IlMPZ9QjjAYHdrv1qaIIQUlImI6JNwu+Y4m2IyDiY5nU/V21ZCxnfWTlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2483
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

felix_vsc9959.c calls taprio_offload_get() and taprio_offload_free(),
symbols exported by net/sched/sch_taprio.c. As such, we must disallow
building the Felix driver as built-in when the symbol exported by
tc-taprio isn't present in the kernel image.

Fixes: 1c9017e44af2 ("net: dsa: felix: keep reference on entire tc-taprio config")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 220b0b027b55..08db9cf76818 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -6,6 +6,7 @@ config NET_DSA_MSCC_FELIX
 	depends on NET_VENDOR_FREESCALE
 	depends on HAS_IOMEM
 	depends on PTP_1588_CLOCK_OPTIONAL
+	depends on NET_SCH_TAPRIO || NET_SCH_TAPRIO=n
 	select MSCC_OCELOT_SWITCH_LIB
 	select NET_DSA_TAG_OCELOT_8021Q
 	select NET_DSA_TAG_OCELOT
-- 
2.25.1

