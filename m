Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704D76387EE
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 11:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiKYKxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 05:53:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiKYKxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 05:53:21 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2060.outbound.protection.outlook.com [40.107.105.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D986423BDF;
        Fri, 25 Nov 2022 02:53:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B9739MAFypZOWhszxvK7wA0P8jtGzA+gLiuR5890WkOmOXauC0WP+/lZbtmcdyEMKl+d4tklWsug+ahxFdm529xmDEbQVKejmsUF31Pl0HBs8RQKHdFzZ5Iq/R3VAFUk+TbhiSjca+gEjEgMYEDor96NxNhnGowt9JbPgyy/Ziq+0CD0YeAW2C4HH1HHdoHsFRV3a9keIq8JvhWdpPUttKaM5pHpZpF0HK1MtlbAMY104rrxwidpdnb4FTZhZerEt7zeeUz5Iv5PtWboqglkbPu9K2VwTurI+snUj0DxVXopVTIyflIMxi1poFKcntsngZDCGopDbQW0MnKOdayNhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=96UVIKS9iwrJwzzqr8dtCXovSzCH/aKgT0f0uz/BaRs=;
 b=XgRs+UTs8xaEcDKe416JKJRsDhx7nlCLM4HmaNig2OFLARNUuv4A4aWp8s0TpqVQxa4JG41S6QJGgdfo+i0jxYnWbybXmGm9Uasb7KXGJ1Qq0PFEQSNnKafgcdooXKnQBA7cDl3d4r5YyFDXwggSOFCtoZRx2hQ1rfnbf7q0UkMjGudlmShzYpGxcjNRAulL5S6/wRvqyT2WGtY57xsS1P2kjeWy4IZi2BGLRmfIqgchz/rWQ+YrBoNKY4rxNAK0HgtR/HYvL5eWxPMA8E0jCjz2RLvxISUX5QP+B5/jh5aiHNy4re7yzqHe97RgH6gYwalJAyp4NCVRCDH3DTyecA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96UVIKS9iwrJwzzqr8dtCXovSzCH/aKgT0f0uz/BaRs=;
 b=C+uCNXZoytLYVn05XLeDl5VlwUGJOJFWapUTrkxxQ73WyXYDbvsAKblUzSL8U9x4B7oJpyDneiu4sOuqIFRUS9KFPD61rdIneriwE+cV2/hId5zWEBHg28mUricaZE7P1ALHmeCe2JJ9DfFaYjjEN2+FZM5HPfbH0/dC+m5JjZI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM7PR04MB6902.eurprd04.prod.outlook.com (2603:10a6:20b:107::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 10:53:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Fri, 25 Nov 2022
 10:53:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Yang Yang <yang.yang29@zte.com>,
        Xu Panda <xu.panda@zte.com.cn>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] Revert "net: stmmac: use sysfs_streq() instead of strncmp()"
Date:   Fri, 25 Nov 2022 12:53:04 +0200
Message-Id: <20221125105304.3012153-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BEXP281CA0010.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::20)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM7PR04MB6902:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e7b418c-bfe9-430d-dce7-08daced341ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H1c/tPiIWBbgApMwVFuqQYpN1cG8Sh47NSv61bL8nMrrSuhul/aIBp2xJdylBVx4mkdrbNIO4z2ILWlD6n98z0bnlZWvwRy9L4F9TNm9acRmP/WCg1CCWaVfxt1JHkZ1NbJRGS0x6U235Xu6V3UEVxKcMj/b6vWRT4pbIMnM9F5PLElPCsRu419tIF2EPOxg8eKGjbbQxO/W5NavKs9nZIzczzG5EaA4tluKhx6dJ3SPf1QZii6qNE001IAQmLVyqLlz2yfW2xfuRfXPo6V+kXWRUPJZZxn/5IhD2W2UmJIRYvBA+aAf1i/FTDcJBH3LUJ7z7MacrnkFg7GiYyDxgZ5l2Ux8PaR/8EJhG5WljiAuJSw9xMfTlRVG1zG1Zm3jU4arHCCl3k7plBngwmMBKRID/aQ0JhT2wwnoyheOoYM5YSTLD80+U55Z98kwGrgRua1ep5ZB5eoW+2JZ2nD0N6BVWG8p9M6/c7IKDQRElJ4ncDPINkvujwdpEaal1muGFgsRRjeJocXqpSglfHNEQe0y7xe9509/mxnY3QfVN+wQ6/tX+WnZbcHRks8Dk6qyVLo2zRIy9jehbTJ8x4EaT+RuuQF8MyO8IGLHVQjovLro0Ra/PJWvd15/K5iwCCEyLmOkDNP+P5zwTsFHxv8WSsf61ZQA6QmeHTVeCTQEkYfxsaVKTsHnTs/0MV7CjTGb3nVchF9Sf6pkaa966i9Fmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(451199015)(36756003)(86362001)(66946007)(6486002)(6916009)(316002)(38350700002)(38100700002)(54906003)(6666004)(83380400001)(2616005)(478600001)(66556008)(6506007)(6512007)(52116002)(26005)(2906002)(66476007)(8676002)(4326008)(5660300002)(44832011)(7416002)(1076003)(186003)(41300700001)(8936002)(133343001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejJISllMSGpENE14d1hURkJMMHRNMlA3RTdBNGphWmQyVXA5c1JzbGg0Z0d3?=
 =?utf-8?B?S0h1eEYyMnExeHNqeDByT0V6NElUdkhxQVFEVEE5TXpuRmpHWW0xRis1NmpL?=
 =?utf-8?B?amlPaWJGaWpXTWdyOTJRcVRDQVFycE1aaHExdHhib1gyVFZSWG10ZHRCZjRj?=
 =?utf-8?B?TFRRTHlWY3d0Q2hXbXhTTWVwQUNBVEZiemIrZmVFeEhTeVFxTHppUE1QOXls?=
 =?utf-8?B?Q1cvT2FBbExWNWZtTDE0Z0t5dUExNkJMRW1FNG5xakJodnk4R0hlZmZEbGM0?=
 =?utf-8?B?VjBhOVFmbnNjZ1h3WldSYkFvd0V4YURoZHhxc1JWNTgxWTc4U2YxRzVGTW5K?=
 =?utf-8?B?ZjZMQ3pBSG9FR3EwK0JNRDFCd3U5b0lFejBxTWtnRVZKWXRZS1JRREpkVGFV?=
 =?utf-8?B?US84OEpzQ21leS93ZzJJd2RHY09WMkZvRGlTaW9LSi9VdjdsKzk2NDVMOVJZ?=
 =?utf-8?B?Z3BaUHQ0cS9MdjI5cmJ4TXRkS0lLZ3Fldm8xejkyd2Q0QzB5YlE1Q2JNdURq?=
 =?utf-8?B?U09zQmZRQXV5SkFYQmd5Wm9rM0RMdFNNaGJZaVYxc0toU2V1VE1qbzNQWDdO?=
 =?utf-8?B?SXU2YmpEUmJLV21aSTR4ZFpiWm5aV1dqMCtOc3FEU3Q4OGFqL2hjMkUzTk9I?=
 =?utf-8?B?NUtpQ3FnbVBEU2dBYlo5ZXoxTUJPWml1WC9WTTFBRWNnRERBd1F5azhySGhj?=
 =?utf-8?B?NlRSN2U1dnJSc0ViTDFmb3BpQm1wSTAvT2NUYTZGVnordjdjdXhldnJwSmRF?=
 =?utf-8?B?eVl0cEpvVDNzcWRXRXl0SG5leGp3c1pmdFdFMW02N3JDUmNaR0pTT3NER2k4?=
 =?utf-8?B?RXpYeVRVeVIyTTJHaXJTdVBWVTZRbHNBK0UrVWdlMkFqN0ZoVWMzUGtlU2VS?=
 =?utf-8?B?bGpEZWovd0UwUEF2dVJJcU1EVEdvMzFEN0lPZDNvelVkZWRTQ0xpTTFYVksx?=
 =?utf-8?B?Q3RNNlR2cmhZcncxa3VKTGozM0xKbU9VUTV6UnlQWk10dzV4ak45Q3VBa0Q5?=
 =?utf-8?B?YVcrdnYyRU8yTUxRaWpMZlVQdUJCUnhKeDg5Z1ZtaDVkVTV3a29CM2JPUENK?=
 =?utf-8?B?UDE3YUtERW1rRE94MG9yOGcwclZMVFFaOStzdk5ZRGdMcFVYd3BDeDlCMjQ2?=
 =?utf-8?B?UzQ2N1RiN1RqTEIzUVMyL25RaUo0VzlEMFdTemJDeEZuK2dXOWxMYXlCV0Vi?=
 =?utf-8?B?Y2lCcFBXYW5tL1UzMTlUZng3eHcrUVlyY2RlV1Q1MUdrdFVHWCswb1RHcjdz?=
 =?utf-8?B?RU9KQ1pCU0l5dXRyak9EQUplZFYwMmFhUHJjZTFVOFc3aDVrdllYNWtvc1Ux?=
 =?utf-8?B?NTV5NG5tWWVxM2Z4ZS91L2RqSm9uQW1HMS84bmwxbUlTTXk4VFdLMG9ISDcx?=
 =?utf-8?B?SlZDWmdzeWhQQXRZRE03ZEljU0xYZzhkTUVFUTFZR29ZVHRXOHcrU0Z2WTAz?=
 =?utf-8?B?YVNxaDJpTnBSNXJWeUljWDZ0REhqZXNSeTVKZW5tR09TSkgyUU4rTXg4TEFP?=
 =?utf-8?B?bHB6b3VDUGU0K0VhZENMblJaWHdNN05lUWZpNG90a0UvdVdBNmI3eXJTYzBN?=
 =?utf-8?B?OGloTGkyWitxYkorWHRRWkdNVzRsczRFdjdhcjh6aHFZeGRyQUMyU3dGUHVt?=
 =?utf-8?B?YUZYNjdrdDE0OGRWYkZKTk84c0E5NUo3Y1U4K2hVdmlYckNrdFBVZEZWaXJJ?=
 =?utf-8?B?YTlCOWNKcW9KV0JWM0hGSUZMNjBURjJ0eE84WEVXazcwNUhEMkxTSFhlS1pE?=
 =?utf-8?B?OU94WjRuRloveU5pQm8wOG5xQU9EN1RUSDNXTXFnN3hBQkdpQ282Yy9Dalpq?=
 =?utf-8?B?L1J6NlpiUGE4cWRoWjRGQm9vTFNrNU9IMDUzNXFhejBEb015ZDdHVnIyWmFm?=
 =?utf-8?B?dEJoaEc1U2Q5VnI2NzRyRFdMS0tLYUtZbjhOM3FRYWRLMjNNVmZ3ZTVQdnFp?=
 =?utf-8?B?V094MHljalR5WWwxS0xOaVgvcGNscnppQld6a01OU2l6YjNQM2I1cW03STQz?=
 =?utf-8?B?eTNxWko3U3dYWWJuck9JK2trSkFFY1kxUTNqcUFITzBLZzBLTWxQMTArdis3?=
 =?utf-8?B?MDNnTkkrek16Z0M4cVA0WjAwNVppbUZOeENHRW00cFZEQldrQllHQVVMSk1J?=
 =?utf-8?B?eEU4TTB1OHZCQXNPNWZUTnNYZXdUdm5wVExXY24rdHZNZXNnbGhpSFZsYUdi?=
 =?utf-8?B?OWc9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e7b418c-bfe9-430d-dce7-08daced341ec
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 10:53:17.3778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wv+VYZp1VQIC0lkpwmtC6nFaVD7Cqf6Ww6IUJK/u8CT7GbOU3CCShb1Zr4jL1epe6oiQLDqBgATU9fsNhnJ4WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6902
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit f72cd76b05ea1ce9258484e8127932d0ea928f22.
This patch is so broken, it hurts. Apparently no one reviewed it and it
passed the build testing (because the code was compiled out), but it was
obviously never compile-tested, since it produces the following build
error, due to an incomplete conversion where an extra argument was left,
although the function being called was left:

stmmac_main.c: In function ‘stmmac_cmdline_opt’:
stmmac_main.c:7586:28: error: too many arguments to function ‘sysfs_streq’
 7586 |                 } else if (sysfs_streq(opt, "pause:", 6)) {
      |                            ^~~~~~~~~~~
In file included from ../include/linux/bitmap.h:11,
                 from ../include/linux/cpumask.h:12,
                 from ../include/linux/smp.h:13,
                 from ../include/linux/lockdep.h:14,
                 from ../include/linux/mutex.h:17,
                 from ../include/linux/notifier.h:14,
                 from ../include/linux/clk.h:14,
                 from ../drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:17:
../include/linux/string.h:185:13: note: declared here
  185 | extern bool sysfs_streq(const char *s1, const char *s2);
      |             ^~~~~~~~~~~

What's even worse is that the patch is flat out wrong. The stmmac_cmdline_opt()
function does not parse sysfs input, but cmdline input such as
"stmmaceth=tc:1,pause:1". The pattern of using strsep() followed by
strncmp() for such strings is not unique to stmmac, it can also be found
mainly in drivers under drivers/video/fbdev/.

With strncmp("tc:", 3), the code matches on the "tc:1" token properly.
With sysfs_streq("tc:"), it doesn't.

Fixes: f72cd76b05ea ("net: stmmac: use sysfs_streq() instead of strncmp()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c  | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1a86e66e4560..3affb7d3a005 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7565,31 +7565,31 @@ static int __init stmmac_cmdline_opt(char *str)
 	if (!str || !*str)
 		return 1;
 	while ((opt = strsep(&str, ",")) != NULL) {
-		if (sysfs_streq(opt, "debug:")) {
+		if (!strncmp(opt, "debug:", 6)) {
 			if (kstrtoint(opt + 6, 0, &debug))
 				goto err;
-		} else if (sysfs_streq(opt, "phyaddr:")) {
+		} else if (!strncmp(opt, "phyaddr:", 8)) {
 			if (kstrtoint(opt + 8, 0, &phyaddr))
 				goto err;
-		} else if (sysfs_streq(opt, "buf_sz:")) {
+		} else if (!strncmp(opt, "buf_sz:", 7)) {
 			if (kstrtoint(opt + 7, 0, &buf_sz))
 				goto err;
-		} else if (sysfs_streq(opt, "tc:")) {
+		} else if (!strncmp(opt, "tc:", 3)) {
 			if (kstrtoint(opt + 3, 0, &tc))
 				goto err;
-		} else if (sysfs_streq(opt, "watchdog:")) {
+		} else if (!strncmp(opt, "watchdog:", 9)) {
 			if (kstrtoint(opt + 9, 0, &watchdog))
 				goto err;
-		} else if (sysfs_streq(opt, "flow_ctrl:")) {
+		} else if (!strncmp(opt, "flow_ctrl:", 10)) {
 			if (kstrtoint(opt + 10, 0, &flow_ctrl))
 				goto err;
-		} else if (sysfs_streq(opt, "pause:", 6)) {
+		} else if (!strncmp(opt, "pause:", 6)) {
 			if (kstrtoint(opt + 6, 0, &pause))
 				goto err;
-		} else if (sysfs_streq(opt, "eee_timer:")) {
+		} else if (!strncmp(opt, "eee_timer:", 10)) {
 			if (kstrtoint(opt + 10, 0, &eee_timer))
 				goto err;
-		} else if (sysfs_streq(opt, "chain_mode:")) {
+		} else if (!strncmp(opt, "chain_mode:", 11)) {
 			if (kstrtoint(opt + 11, 0, &chain_mode))
 				goto err;
 		}
-- 
2.34.1

