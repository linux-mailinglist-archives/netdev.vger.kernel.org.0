Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D189E5B79C7
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 20:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiIMSkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 14:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbiIMSkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 14:40:16 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2099.outbound.protection.outlook.com [40.107.20.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7C386880;
        Tue, 13 Sep 2022 11:10:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQHUtEU3OR8F7WHe3VGcLv4o8DrFd+y7UwM6qahuHHh7mX84y15LBXjIR+mNO3R2CurmaULhX+67fgwf7Iq/DQ2lkVva4CWJ2GUxNn/pAoBxNPeExX7aQA4tqu6G6q4MzdLsf5nYZKXyoDcID7fEsEc0ih/ix/8Mz7/shmWaubowxgfowCvKusakd4RNMmzH3MVtq7LZ9kB3NP7BkALa56QKJ7LnnwsoPQ+l7HfgQNLyIE3egheVRc1458T/Gbm88cyehb81EM0XVjlv8HY+tCk33TUFfufvKw8uBLNj3PAndsiXGve62SICPkltlZxX5MQrnVC5uVNVllxwT4Q49A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYnHTTlZ7PR7iL0ei+lrOTx9YTvifsk3GTtsbJd5bUs=;
 b=JLD41VK8jxuU6iTfh1mJ5JYR/HEDBmbdz6cD0gfEECZdiW+GVddKVF4VgaUSOFbUj287C9s1USqz1hOuN3qJKnBVE/WqC/5Ax6RVUWNjCMIpsfDlBIJmezBgcyHIZBczsnAarNkZn3jZz5ZqlRCdngTKqNlwn2IPiBuYmmVpDrE3dNGUWaU6G2fRvqALa5NGIofIDzWq39ARpgW0MmENLmIEYnxQ9Qz/dZ9p34r20QOmz67xLHRMmqBEMuYyledMYaNaB2pAVinpjmMBRGrpmVTp32VRM6YMYpsdUOZUan9PK/r+mk1GDKEZE0Xbwd8K+tIyokqsM0NpA/+/RiKCmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYnHTTlZ7PR7iL0ei+lrOTx9YTvifsk3GTtsbJd5bUs=;
 b=FkU+abmSRvNyFfnoVSUUUrWLxVPLQJMK63t8AiwA1BNuxqZPGABQ+MAg5e+8phZhMAiDsh6CqjJ10BisMxBmuUpkSrpNMi6cSEBpK+PrVFFGchch9HuLnkbormvgjNBqwVoo8uZrZ6l0z3EHFnJ2zEIpyBQxwUyS/8D2ef7ekas=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by PAXP190MB1789.EURP190.PROD.OUTLOOK.COM (2603:10a6:102:283::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Tue, 13 Sep
 2022 18:10:24 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::c761:b659:8b7a:80ea]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::c761:b659:8b7a:80ea%5]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 18:10:24 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, hkallweit1@gmail.com, andrew@lunn.ch,
        linux@armlinux.org.uk,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH 2/2] net: sfp: add quirk for FINISAR FTLF8536P4BCL SFP module
Date:   Tue, 13 Sep 2022 21:10:09 +0300
Message-Id: <20220913181009.13693-3-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220913181009.13693-1-oleksandr.mazur@plvision.eu>
References: <20220913181009.13693-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0180.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::13) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1P190MB2019:EE_|PAXP190MB1789:EE_
X-MS-Office365-Filtering-Correlation-Id: 73ca270f-609f-43e5-e7cc-08da95b33aa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0rBwyiOoPVT2C7M2vbZVxV2ulT2HvbaWD5SFLCkAr8g8LjMggQnQjOxzBPs8p8hGeyvaFb4Js30FTyWoh8XmiihCaVpKcGNiB4hjZy4SHgAsMdgOMBEGedJwGIEZjcNIDrAA9VBCmHbTQ1suxdyq8PokPXoWWnVBbSOYerg7tDrdCvNWg6Kls4kejS2Cs0/0jajHvGyN3r9ylwt5u6mKbaegcRorfhIY6/aA53sq4a0kJSpipaqHUppRvOW5cOZkX5+liwZDGzcZN50GWlPOCRXTIFKzvF76dFK/unTbgGSfPtCC9Kgk5se2fcG0uA96ORXfrCtxXl67F2MCYlttxRRWUQ12W6Wytjgc/bUH/c3T/haqClzNUy0Y6QFg5UNv8KXvA/j9fZXhUJQd12XCXVOUiH6DMSLVHE3wEf2cTZHe6gjbDb5fgJMwUhg9o3AIw8QusE6s4WHlUy01SCBeLYwQkTNwpNLk3AnF0ykCRWUxWj/yrP1z+5CEj5DGsL9DWgBj+T6FFxIdxKEWkBNb9BhDcsUTd+fOpnEcZPMimUBbE/vnQdV2g/ya+H0dckem0rKxsIlUYRNyRwdA3Iph8bXb5iYOxsYvN3IhqvMByGNLLAztJoD8OH9gq6xK5lczy3WHWU2bYpUQzgLwJtwqNN5R5mGwOgr1zzDLxvj198pFYPSWb8bSdrtkDqbnoe40TelyWO7CYYPRwxMzRv1DQxyc5dBVS0T2Lp9eKTh0Y9kdVdMAcJ76RIARaEvQC1DWRNAQBSofCdrVY1C/F9XDRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39840400004)(376002)(366004)(346002)(396003)(136003)(451199015)(52116002)(66946007)(8676002)(186003)(66476007)(5660300002)(478600001)(1076003)(66556008)(107886003)(44832011)(38100700002)(38350700002)(86362001)(8936002)(41300700001)(26005)(6666004)(6512007)(6486002)(6506007)(316002)(2906002)(2616005)(4326008)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VPeEWPjka1W3ybJo8UI6eJ3UDiawpr3VQrvFAJG7lQ5uems4Y70Ia276ATE1?=
 =?us-ascii?Q?XaU+YXXHYy7Gsb1AVbrEItiHCxiqLhpQtiLkE6MotDFwXDk0DqHN8h4/fdue?=
 =?us-ascii?Q?RdlMXS/ZJUg690wIn1tyvQYNThEBxrjuhW7EDaeYDjlP+hqPhP+5eAYg9I1a?=
 =?us-ascii?Q?Itgy3UtfxkU3sUpsgBYLtS6oqzoWtPGS0Fol2C+HJb7YLcNfHDDmB+FcwQkb?=
 =?us-ascii?Q?MZQMTH/6ijDag/klat/EVBtxEbgkNiLezUba/vL9lYQd3UkTldiDjRH7SJFL?=
 =?us-ascii?Q?t6XmLtm425swySKBFgENYfZueGe4buI5DGeum/NdIEsyM3lDTsA5qHCx6M6r?=
 =?us-ascii?Q?Af8Q/7eMV9vQLNkBcnuXXqXZlq6g8nXkHPdR5pMXNHF6OxfpujGA1bfH3tFP?=
 =?us-ascii?Q?ZgEWZp1FuZrlemASMn1hhSu9lWJuopgnfcQzvdzmmB46OWUhNYConGYAatf7?=
 =?us-ascii?Q?Rni9jdD5b7JvDqPIbLl4eNNXhS/THYa3eOgNyTis1gfNdvjgnaqEfdykMbXu?=
 =?us-ascii?Q?uBZPjgt86K1Ls/buKBB5xx+hlRLblcervL22Cu9hOOapuHxdupaZMD7mZ4xD?=
 =?us-ascii?Q?BQh6YkNlFQ4QdJAJJV5+OzjWPuKZHYRUtaKQeCxhjerlo+dgeDY2Op6jykKD?=
 =?us-ascii?Q?PRgaGL+PzKMEmH85bxwz4Lt0y4zaPsnSrv63WKtqVOKvvOOwpBkrCvws3xZ5?=
 =?us-ascii?Q?9ZAI1e2TX8HQJThkBsFlpToYvhzrvGJ8ePTUFL6a78pGA+1sgVcq/pHU/dQj?=
 =?us-ascii?Q?g6ybFSavbDfC+zATb3Uc+EqQZF9R/4XC3DGBc+cGZ3gw2xiNvkuLrpYqDsak?=
 =?us-ascii?Q?dqCDVmRiSIHjiMbjQitQ2zwTIz3uI3PzcqPhlzjpx6fxup3U59FRavLyUQ1N?=
 =?us-ascii?Q?SNMuGhWUu+FkXfreHFYvg9UBVtbaOF3bmfuLGcKUnQeeYm2uZzrJoPEebvro?=
 =?us-ascii?Q?Q5sENV4ntZPjO0CwBJn0U+9Jy3Ozn4yGMihNyak4C+oMb0NcIcGnSMpJ8ANJ?=
 =?us-ascii?Q?OK9pXqEjWynYlW3r+IRPHJdkE7AAnRWiN7mSBU2muznVI/UbDgKqlCepbcJz?=
 =?us-ascii?Q?dvNDJW/iqOt+wTlinGY1B96E6UBfDZj4rnZXxBeNHGns6pcbY7PCI8p+s3SO?=
 =?us-ascii?Q?Oytz6k+ev28TeHEP2Gp5X+XbeQmu5CIzc2J4TUqf+/pWCU7zkWBCyV9jDStw?=
 =?us-ascii?Q?bDT/DU0vlVtz8JOGQNufSv72ksbQYvsyVNz4mEzzX6LF1ui+fv8V4JJYle/S?=
 =?us-ascii?Q?DlOXSjYysMRufFpBnhkdIw6c35KDBlpjcATtAKUgEKGIKU8TeNUAZ92pC3hX?=
 =?us-ascii?Q?DT76bN6975mOdbofULx8NOpbDzlZZIRoBikJvSjCWFMUFh4tPYUzMLNNWk2R?=
 =?us-ascii?Q?WI/1NkFH2sL+VPygmfJdr1g1GgKxygiVb5MIQv9N2JJi/RqqbWKAhROwTzUE?=
 =?us-ascii?Q?qhUrbJum3dhFWCVquxoq9SSs/5YpjlS2A9USy/gVVFWXTB2ooBHbH+SgKcY7?=
 =?us-ascii?Q?KpF0eyElLrlyQZfyEK3KlBEjMjN4PZ8y26/SKjIjOWXrlutJBLI6VQegAEUK?=
 =?us-ascii?Q?nXEgFC0rWBLP/RxSPX19NlJrM2qHIdYv07/nR8u0nxHgtkr8LZ/wg/R2Ol0m?=
 =?us-ascii?Q?Og=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 73ca270f-609f-43e5-e7cc-08da95b33aa0
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 18:10:24.2904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uhuOI4FJ21/dFeGxMt7qgwxS/mBU53YKkdpOl5A8ndr3SxoHFna/kg5qElv9vzT14q8udFZwYkYMtN02ApucRNPS5Scdw6w4peKW18/V2G8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP190MB1789
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FINISAR FTLF8536P4BCL reports 25G & 100GBd SR in it's EEPROM,
but supports only 1000base-X and 10000base-SR modes.

Add quirk to clear unsupported modes, and set only the ones that
module actually supports: 1000base-X and 10000base-SR.

EEPROM content of this SFP module is (where XX is serial number):

00:  03 04 07 00 00 00 00 00  00 00 00 06 ff 00 00 00  |................|
10:  02 00 0a 07 46 49 4e 49  53 41 52 20 43 4f 52 50  |....FINISAR CORP|
20:  2e 20 20 20 02 00 90 65  46 54 4c 46 38 35 33 36  |.   ...eFTLF8536|
30:  50 34 42 43 4c 20 20 20  41 20 20 20 03 52 00 b8  |P4BCL   A   .R..|
40:  08 1a 70 00 55 55 XX XX  XX XX XX XX XX XX XX XX  |..p.UUXXXXXXXXXX|
50:  20 20 20 20 31 36 30 32  31 30 20 20 68 f0 08 62  |    160210  h..b|

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Change-Id: I320058dee38724d3564fc2500ae2e3abfe3d47bb
---
 drivers/net/phy/sfp-bus.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index c3df85501836..a7799162e3a7 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -61,6 +61,17 @@ static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
 	phylink_set(modes, 1000baseX_Full);
 }
 
+static void sfp_quirk_finisar_ftlf8536p4bcl(const struct sfp_eeprom_id *id,
+					    unsigned long *modes)
+{
+	/* Finisar FTLF8536P4BCL module claims  25G & 100GBd SR support in it's
+	 * EEPROM, but can also support both 1000BaseX and 10000Base-SR modes.
+	 * Set additionally supported modes: 1000baseX_Full and 10000baseSR_Full.
+	 */
+	phylink_set(modes, 1000baseX_Full);
+	phylink_set(modes, 10000baseSR_Full);
+}
+
 static const struct sfp_quirk sfp_quirks[] = {
 	{
 		// Alcatel Lucent G-010S-P can operate at 2500base-X, but
@@ -100,6 +111,12 @@ static const struct sfp_quirk sfp_quirks[] = {
 		.vendor = "FINISAR CORP.",
 		.part = "FTLX8574D3BCL",
 		.modes = sfp_quirk_1000basex,
+	}, {
+		// Finisar FTLF8536P4BCL can operate at 1000base-X and 10000base-SR,
+		// but reports 25G & 100GBd SR in it's EEPROM
+		.vendor = "FINISAR CORP.",
+		.part = "FTLF8536P4BCL",
+		.modes = sfp_quirk_finisar_ftlf8536p4bcl,
 	},
 };
 
-- 
2.17.1

