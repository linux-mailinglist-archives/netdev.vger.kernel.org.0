Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE2E51FEC8
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 15:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbiEINyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 09:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236507AbiEINyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 09:54:11 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2123.outbound.protection.outlook.com [40.107.255.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A34228247B;
        Mon,  9 May 2022 06:50:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ijG09zM3HdpFA/4xR426a5jEnV83ccZ25uh3ujJcL15pgiZxgSBkiByES2h3nWvvNcIajxQ+epVIsjmyPr3xO1hRiahxUaIpITPQdvuhZA/ZqrCuS5EHS7ek0shuln+M+O/1STeIe8Gmik0g4hL+GWzUu7ipG0hr3BZjhMa3nEyir4QRI2wY3fQmr0m48E8fJSdT1f80aCWtOfMrtd8r2tIldABeNx/hOR0FgNcIPqRDmPHNWt8HsbAhTS/EG0oz9/h/Ysb9pLowOShp4LBqWa37FeYqxuSI6fF1gJhCPyjmm49X23UBmAXkBT50Q+avGwWQ+fZYS1rU9dNTHzN45Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ou2APw0+lNj7/SHwfv+IqVb8Yty4GFxi4Y+50pv+oII=;
 b=S45ugQFCaX2MC8uMvLU1bfyIAYIjlIAHVMSaCu0WrKMar2r2JfKy4BuzP0Tm6FXVEVzEMcx2N9OtzgQ9TSISyzMjUgVR5U1SaN+a7vB9bDM6mlpLGEiDteuk7HSNC4f83xq9374kj1eU1P0z3+gaQp2GNoGbDUiVXwqrDByXMG3+f6+lrCmKHidbliGI14LOByvDfPil+tduomcMhkwAXYlQDLAoxaq6VXKKVTVu/HST2wE5PROf/2fZ3+H2xIJyvXwUSOYoJnLxUNCU7iIEv4q63WJe3i7GQqs+T/f9LKluXc3S90c5hfE4+6EdRtTqbRVimRs/DD5LSVR0sG+AQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ou2APw0+lNj7/SHwfv+IqVb8Yty4GFxi4Y+50pv+oII=;
 b=j6R+Naz73x+X36IqDGzRDufSPWzUnMhhJy++hf7sqgRLnNJEvajWhEFzSA5DSGcboyjSIseR9b1Ywt4tnn3oblKhyM1P2c+vGUvjX4m2s3e8caPmwC10TKTbPLLbjO7GrUh3qBGKureLo2qszi3WPpJiSq6PcK2OvcOYaQj2DVk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 HK0PR06MB2995.apcprd06.prod.outlook.com (2603:1096:203:80::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.22; Mon, 9 May 2022 13:50:08 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5227.022; Mon, 9 May 2022
 13:50:08 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] net: phy: micrel: Fix incorret variable type in micrel
Date:   Mon,  9 May 2022 21:49:51 +0800
Message-Id: <20220509134951.2327924-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.36.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0200.apcprd02.prod.outlook.com
 (2603:1096:201:20::12) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5aa0408a-5b12-47d7-7e35-08da31c2d48a
X-MS-TrafficTypeDiagnostic: HK0PR06MB2995:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB29951CE6B9CBB078FF4A9D2DABC69@HK0PR06MB2995.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M6hqImYY1cCFey2/Mzy3qDMwga8xEMcsvUJ1JcZ0R7RbuxP3NGXnEWKvbdW1vhfVe9V0xXoia7eerxZpnNEa7Akt57wkLlaLQoFqiJZD6iRrXbeX9r1NKsjzbS/8t2sLMPJZ0FTnGBEL3ifLLKeKoDP5Q+hShJJ6sJ5CJkqQQidGeEdBZ33XKONSIag7CBhAk9WOGKbG/thRdOdciWvwvn+frmq6wbwJSMKMHFw5WItBnhpxLpjmGlqvs6vuQU63Y+t7UGYxUgWJ4IUwuuDz8LPR34zXUpwju8C0lyoFhtetVEk4NXHiO7M4TObjNpRmkL5jOwgcaDT5pPdLpLWckDvsyKZ0XQfETc0lIuWQlCcidhTZPJnI31C2TFvvJ2aXs6yyeJIeHhHQdMENpaWanpJE8hX5VHqo/08Rh5YaQo0x5cRJF0FUCj4aYr2XzhED8teyJ99HXNC5UaNQJQQldI7zUqtra2Veukit2Bj23wTiRY1Zt9W+469RKvFn3g5nk4XiHcx/bLd/ZvOArwCsAOe/C4LDGfy3HGK0OD+7VKpfTcUtEfkOt6z2Fho7xTs5/lfMDO5p6UXAExNM5JFlgAnOAiI+R4VUAh5QwegN043du11fNAoPAuOXHqlGWGSPlsRwEM0KC6qAP4l11ZA/Nvv/fx/wDoaGIWp978gCOtWiSHydqRDUmEMhukHfS5PE9AWP2qGhsL7ErCM5I8ZH0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6486002)(6512007)(26005)(107886003)(2906002)(86362001)(1076003)(186003)(6666004)(6506007)(52116002)(5660300002)(2616005)(83380400001)(36756003)(316002)(4326008)(8676002)(66476007)(66946007)(66556008)(38350700002)(38100700002)(8936002)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SMw0J/4+EhInY4WZ2farqIdcMyG4avYpk8XQpFp2ltbIILJj1R75gwR7efyM?=
 =?us-ascii?Q?cOCjkhdjpOeXHAs23RVoqM/0N28+LHXysGQlBJQT9KIrSmul5HTKVyNyb6Wj?=
 =?us-ascii?Q?GIj+3lYwFxIFjavE/eJNWtTIqaIHb03URWk4yheo2lhxMJJFJVS2EdUBCJKW?=
 =?us-ascii?Q?FWjDaOjweYwYLDHpC64j433cxiFBie6BJEmi0+Rh9C1p5H0Y909PHFflD4jR?=
 =?us-ascii?Q?jqBspgVqhKQk3T4vVXQUXiJjaWCShjMlHLWLodbgTcyyeQrCLNlwEhSWTxDP?=
 =?us-ascii?Q?4aQSc+aZce4zfLJIaCU5Zd+ky10vVqyGIVLyZzGrMpZl5hgDeDYBQgBSH3Mx?=
 =?us-ascii?Q?0Bez87LF2bloX7+ZZhIJlwmoXOasmiMzklNZr7cfQTs50tWR6EO2QMDcoRps?=
 =?us-ascii?Q?9JmwP1IkZBAKWZ0ZQqh81DRv7065Be+w8GC0naFQUBB6Txe0zqMYMBzrIhXq?=
 =?us-ascii?Q?fWeS9UQVQbZlcur80FVoRYnO5IwQeAu3vktPcJnhx2/FGrsdxwFgP3MoH7W/?=
 =?us-ascii?Q?HRyfezlwrroZFJU4h7UU+lH5FhHtUF790g9peCBRVGiBO2vUyZX+xAPvDrcD?=
 =?us-ascii?Q?kcar+C1OKuhR2gX1x6e92eMTzrQ4UBFcck8HaTylF0+jVXrORd7yHBes1Jkf?=
 =?us-ascii?Q?DaskymFcmijb0+/zvxl0FG1kSvzHtxHp+jpRnRnQxyji3bXSPjAN30pqLbyl?=
 =?us-ascii?Q?Ywb2rHTjTqmypmigu/fWMKHVpZPXMKGxtSN0Nffcp08vW644aP09UvQIFgSS?=
 =?us-ascii?Q?TOWR39m/8ro1Nf8XzoDFVlspfgKWQf3nrK5cL9WSw4fMJSIaK+mlFrbrckal?=
 =?us-ascii?Q?BBshyRRHsTFlCbI9dxK5k7yrz2yeJT2ud5duroFHDaRUJvHcxV+D+CTZFCBM?=
 =?us-ascii?Q?aI0/97bR48zseZAU8S2k0ysXHINTNwaWbob8Z56MJfccjiEa8lmYtdD1zoHW?=
 =?us-ascii?Q?BSGhr3ntfFGYOEdjo9akW2ZiZ/+vQAGgeXIq9DQy/2IU7KJk+9yblyWvjWK0?=
 =?us-ascii?Q?S/yHLjBOZoN3ff9ZplK8uCw7tnRS3NbYtxY3tT3UgpGvCYPae6fY6xtU5EQO?=
 =?us-ascii?Q?ZZLxDBx83qxENaN1p638o1zwM9oXFl+OizzLUMpmXGGSCll2z7V8WMmrRR/x?=
 =?us-ascii?Q?BJOfa8rRjFeb94/oihmHZ0GeVhWyrbwehtSzGrK3p9Ex9oBWPqbERdbdnUQ7?=
 =?us-ascii?Q?qYOXaVd5bWNNGdePHo1Pqn8W6+BEwfcPcseiQOaJIwVMqfM1Ne8J0yhyb26Y?=
 =?us-ascii?Q?9AfuS/CWGOmmFUcsj8nIgBQLNFVZozOKuiJmSCO26f5DqcxBSnYFRa3v/dqa?=
 =?us-ascii?Q?jH0+ta1fbootgJ3dGRL3FYpT/UeSGC/f+K9sI8dll+HkYaCj2pt0CY6N4Vx1?=
 =?us-ascii?Q?6L+sh5Ab4ltjHiIUktJq+IplgO+oxFjtpUFmpM8cRrFjQ58VdvOGusHUBIMX?=
 =?us-ascii?Q?/ClY37Xy9fYgsATCQoBHcTFSHximomRfhFSHgDckhBI8IrbgKFsXttoJsA1K?=
 =?us-ascii?Q?EzIALfGMuZeZZGW+k0GxTIe9J5nBrhjO7EvFlpYcz2Om5QQ3zwnOh3eiXPLL?=
 =?us-ascii?Q?lHMhL/64Mu9PedhtnSlDzjEJ505ThnmqSgvh0mqW4gqQgqnPql6nm6yAbkef?=
 =?us-ascii?Q?gPHcGTCY/fC4Ti33dNgl1SLo989JKQkUINuAFDYlc2UTH8lbCTUlVq4qljvI?=
 =?us-ascii?Q?4l5r92t6v1PhpP5rr/3wj303SAfH+fcQvDevQxbnW3b1LqoZrDFo8PlCR51A?=
 =?us-ascii?Q?22J51Qv3eA=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aa0408a-5b12-47d7-7e35-08da31c2d48a
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 13:50:08.7483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2m0IP+gz4pjUk1R4cOcL33V1uL8nmw/2h5y/XN6m5ahnjoTpULCnlD2X1Q9TfBMtPkLfeMBGt91cogAaRVpoVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2995
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In lanphy_read_page_reg, calling __phy_read() might return a negative
error code. Use 'int' to check the negative error code.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/phy/micrel.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index a06661c07ca8..c34a93403d1e 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1959,7 +1959,7 @@ static int ksz886x_cable_test_get_status(struct phy_device *phydev,
 
 static int lanphy_read_page_reg(struct phy_device *phydev, int page, u32 addr)
 {
-	u32 data;
+	int data;
 
 	phy_lock_mdio_bus(phydev);
 	__phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
@@ -2660,8 +2660,7 @@ static int lan8804_config_init(struct phy_device *phydev)
 
 static irqreturn_t lan8814_handle_interrupt(struct phy_device *phydev)
 {
-	u16 tsu_irq_status;
-	int irq_status;
+	int irq_status, tsu_irq_status;
 
 	irq_status = phy_read(phydev, LAN8814_INTS);
 	if (irq_status > 0 && (irq_status & LAN8814_INT_LINK))
-- 
2.36.0

