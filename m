Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6D15285A7
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 15:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243387AbiEPNlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 09:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244306AbiEPNl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 09:41:26 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2123.outbound.protection.outlook.com [40.107.215.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0901E08;
        Mon, 16 May 2022 06:41:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AnRqGWWbH2Fmgge4gKSr+Wi2remwpT/YQtuYHVdMz4oDqwpLkuPITcdGfB3CyfnxYon+2Q2885TGVBxJEM9Bidi+lAE3AW8A+QdE+QdvsLEBHWGy4jUSLBaUy0hYwV1AuYVKyzYn5QOkQ4O9giuBO9+DkYb5ioNl+3Ch3m6L02mFRcVdfhvm3UgsTxGXG5l/L2qE/ug+vLIdk4QQGdKxUPG70AitRsFBIfndeETAszMQDPjilXOa0DnrwB8YfItvvJ/H27aCMKe49+epp1dgny2/eBuUothprCDjmBdpL3cR9j/jUa3wDa7m6H6dH+dvOefxFNX3JmX4BpdazYlW/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T9wclu+zmrPpOXIE0qU/WX8Lxywkg3ZJOX3NOn6R/as=;
 b=NjkEW3F1vt3VwVU8V0w92hKntWzsOmSK6CGOuPvTsTwqyQzSXZPQk9QtaS7jzeN8X7J4HrKKh6qz15oYuwo9VEgvas8yYxqjnN4PM08sd9MUWbdTXkXOD7BV5lcNajyJyJxNklSJ9To7Zhme3T3/9h9v4sL6OCxeWfGh/P0PLySCaRWWCF9e7x25a1eVenBxy+CI2xhVMwxXBoei71ReJHb1evFcQH/3YCcZiNmC9Fp9fFpUe+WjC4HM9xU6CGJOY1ewwLdlEgHAlLW0cHK/O2y+qW1AIqvWW2mSY4WD3jMxIuLkJeuGJD0Ql391p+udWMRHrbOr4+6nMwe7TAESfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9wclu+zmrPpOXIE0qU/WX8Lxywkg3ZJOX3NOn6R/as=;
 b=HrxVeZuLu6WYAGlTIXTDA/xxKgkyQQOd8Cb6b04X5UwIe0TH0wQA0z/UyCn26yUegSXyCm4sj2ozcmbdxA7ucnEHT31YTX/DkZb1HTFb1rga+8KxwRFWruyAe0EE0I+Wrpxjtom5hh7mUcbuh+97Jlp440TiABlt3pDThj2HAIg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by SG2PR06MB3419.apcprd06.prod.outlook.com (2603:1096:4:a1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Mon, 16 May
 2022 13:41:22 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::88e1:dc04:6851:ad08]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::88e1:dc04:6851:ad08%7]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 13:41:22 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org (open list:ATHEROS ATH5K WIRELESS DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc:     zhengkui_guo@outlook.com, Guo Zhengkui <guozhengkui@vivo.com>
Subject: [PATCH linux-next] net: ath: fix minmax.cocci warnings
Date:   Mon, 16 May 2022 21:40:57 +0800
Message-Id: <20220516134057.72365-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0071.jpnprd01.prod.outlook.com
 (2603:1096:405:2::35) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 193e4d9b-9dda-4b36-cd45-08da3741c360
X-MS-TrafficTypeDiagnostic: SG2PR06MB3419:EE_
X-Microsoft-Antispam-PRVS: <SG2PR06MB3419F782F9015FE7EB61D6B3C7CF9@SG2PR06MB3419.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VGGp/PFN/aH/1pC7Z6URjt0nZdDhCHEZB5oWp9bbl+dE7Hp+M5YL18iQIsHBzX3HREpta5ERNk8T8hhbEBEM+qq7XMIeP0jgk5Z+kpNkyH69KgM+KW4t8fj41Xu/V7/cF8zs2eWO3/so1jeydq+7KFBue62Yt71VhlRAMHloa9IRXUEazY9rdqnDTTms0cfxWoGffXHPhRDUS+gtf74M1wPK7LR9SgzL4jELda4djGxdkgCuKAVlsmAM08eleNL3EloN4I8PL78gmRqyORDhs3Ngj2IY/MNrTzM//QlFl2l6V+W81SK56XbOe+rhxpBgyM0wgGfdwUIXp9SF+U4MgejxC9jAAPM7nmqqJqRT3B4UJfHy5xZ4OXQJ/VYWoQpwQKZz5RXWsnAjxg8FAt9il7D5IgONP2vBEAjvCGF9uAbJK18esu46RO4NmiGmJ1U1wxmfgE3/OAaLZG83SKZK3IIgFCEMPALvVPv4ciob+PwhZ10ZUVvJ4cYBzFNA19z5jcgWbasTsP763aUuqzx7ZkS54e31h7LgJ23zZ9R+sAYpeOcqsdudfdqwpThiMnEiz8Sy8PTavl1B6uenjDRm3rXBp4TJuqCcFyTgGFWWaBpQkj6AGs5DZgfFmlQiqU8fYDRNqWt0zEmO5UFbgStFyNcW3+ve+C/USuZoVeNFsUUTqUjxRgwjnsVnmDfb+avezkjWZuTSt+CWpDWNnJgkO3TDaY70ql4kUCYj9S9spzY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(66556008)(7416002)(66946007)(8936002)(4326008)(8676002)(86362001)(186003)(1076003)(5660300002)(508600001)(6486002)(26005)(6506007)(36756003)(2616005)(107886003)(921005)(6666004)(38350700002)(2906002)(38100700002)(83380400001)(6512007)(52116002)(110136005)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/yLEsw6E1sl6KIf7F5qi65Q1z0CjCu9L30xQqBV+E8MOkBQtOXbkWdKhJM1T?=
 =?us-ascii?Q?KMELZ1jWDJV4MjCgKlninOAC9oqsLnj4m7LAQlMP1spfxQ3w7NenV6ZyFEi7?=
 =?us-ascii?Q?UfPyfLC5Kuf5f9LChzB2qjlfXiij0+e7z62GE+TPZhS0rdTq2Th1Oj9cJZez?=
 =?us-ascii?Q?7gM2LoMmoQ2i/5gZ7u64ChbxVj8sPU7gK+sDyYVHj9Qs97VEqwkIyJ4MEmB6?=
 =?us-ascii?Q?D/vQHLCo2aknBrwzC7T49M5k4pqJ588+WULdodJd3LEx8Fv6EavVt0BsWF7h?=
 =?us-ascii?Q?w0awpCjLCnjAhYCoLgaoEkz6kebLUfX86w5TuLMuPjeZFlcehIlP/DfLBl7j?=
 =?us-ascii?Q?g+X1wptHz7j93LknxnSMJTnvCOE7KsnpKr1OSCJOhS5oR7X4ZYE+CjfQXuLP?=
 =?us-ascii?Q?uW0C4cL4S4rj9RiXakqd5v40yG7LgcBBq9rLr9lM5pp+Zem3shRmG8HUK8xk?=
 =?us-ascii?Q?FeEi27U27dLg3oibY+Rlb/CIni0F12JL/aLc13QViu4qUMDjDgnMJN6cdNln?=
 =?us-ascii?Q?d1rKBtlh4vd+eL58zdK3yFpJA8H1Nq4KdTN0+cejrcGPLACBW/2rqMSWgI28?=
 =?us-ascii?Q?GisZ0xo5+SipBVm9LLM5N5V/VyE0JiUyzUbDj7QHFHEdOo9YKRATls3JvCUw?=
 =?us-ascii?Q?YQ95NdDwUaiNlHb87fnz7g5y4pFO7MEgK/YacN55WuIDJK5eUnAaO5nRUHIz?=
 =?us-ascii?Q?meJkvcABU4pyUFMfx1GhVOA99AMbgTaMPdE8x4YhC3ywjIK2DUVNPLKpWXp5?=
 =?us-ascii?Q?EHE0G4J495MLq/X+2T4H5BmUIzx0V73mbtbhIGf6i4jznKAo+mPySeubH223?=
 =?us-ascii?Q?1IKVFz7JWPx6pFe8VuR/XGg/6dsvk9s78fFFu4jHDvMJyEWNM1+i0VPM6ZTV?=
 =?us-ascii?Q?/DF0AkXX6qtoiunb8l2WzjPcgfKZflPnwuMKyptgEs0A5wz18FV1Qgaan73E?=
 =?us-ascii?Q?KsoyIXX0UhamNktX5luUVxN2JPLliVX7ViKi7OjwV0Cxx7mRG4GcNGb9kU6a?=
 =?us-ascii?Q?IzSK0OHBcsEM7TIMTadQqavPrw8D9iICgNz1JTLjBqN3h0br8xUj737MN+cd?=
 =?us-ascii?Q?fQ0IbKSwwOaBQ08cl8zvv8od8PTSL5pgbIqXbIYTP7ok7Y2v8UsUe1mA41Kb?=
 =?us-ascii?Q?Qqhvxfur5A13vEkvwX4ZQsWCtdKkMGdGJU1sFVLllR9sN6SuiB1pThpC7p/k?=
 =?us-ascii?Q?GqRVnyOgkACWulg0sbPiqabxzPC1QwMb4MiWfTYYV6oNdjYHbAXIQ8zLbjWV?=
 =?us-ascii?Q?R0138O464BTxuYSdxCPEyaLXVnsDtAxRKleauw37qqHJvHnLI8x3YUjm3Ezy?=
 =?us-ascii?Q?tc4mAoYlHM+o2g10SLZV2MbM6oZ89QKefb9fAg8HP88LURLoPfU3ccROuOF/?=
 =?us-ascii?Q?FPqpXSp1uxTFDDM0nTEsAQpeHWsA2i4+KbZYDZAfyVjXJrkUws2ro+mKz7AV?=
 =?us-ascii?Q?xiTr9xSk3XFVKUaBKWDHp3mStK5iqADeqW5OTZBj0+pOf4Njt1pZXrX35xi0?=
 =?us-ascii?Q?3Yw2PbGs88nXKGSb4i8QnJT8ZPvStSmuUeByN8udrKcmleFpJNPmERxL4TOq?=
 =?us-ascii?Q?djSI8JYfHYMJ7mf9xDzansG4WfGI7q5I3iF+9DOuwgfpCYr23PYvcgIcJk1Z?=
 =?us-ascii?Q?VEvxT6Vrme3fig5pZC9A5CYOI504P5r3ZS+vntRxDPq3GUg9N1ix500YCB3l?=
 =?us-ascii?Q?c9Fb9hlk6hrOuLV2U6ala/WWC/wpgWcWBWX8h5BnrH1DRjr8Xvhvhf+mi7Ec?=
 =?us-ascii?Q?DYbxqNjpKA=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 193e4d9b-9dda-4b36-cd45-08da3741c360
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 13:41:21.9461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UnW5c7u8oc7BjwoRIUyQ7PTfg3EAjHaauld/U1UQyFlD9V7WjdPm9qn26F+/WKs7rw484D/ue/fMp/YGzO5IBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB3419
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

drivers/net/wireless/ath/ath5k/phy.c:3139:62-63: WARNING
opportunity for min()
drivers/net/wireless/ath/ath9k/dfs.c:249:28-30: WARNING
opportunity for max()

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 drivers/net/wireless/ath/ath5k/phy.c | 2 +-
 drivers/net/wireless/ath/ath9k/dfs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 00f9e347d414..5797ef9c73d7 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -3136,7 +3136,7 @@ ath5k_combine_pwr_to_pdadc_curves(struct ath5k_hw *ah,
 		pdadc_n = gain_boundaries[pdg] + pd_gain_overlap - pwr_min[pdg];
 		/* Limit it to be inside pwr range */
 		table_size = pwr_max[pdg] - pwr_min[pdg];
-		max_idx = (pdadc_n < table_size) ? pdadc_n : table_size;
+		max_idx = min(pdadc_n, table_size);
 
 		/* Fill pdadc_out table */
 		while (pdadc_0 < max_idx && pdadc_i < 128)
diff --git a/drivers/net/wireless/ath/ath9k/dfs.c b/drivers/net/wireless/ath/ath9k/dfs.c
index acb9602aa464..11349218bc21 100644
--- a/drivers/net/wireless/ath/ath9k/dfs.c
+++ b/drivers/net/wireless/ath/ath9k/dfs.c
@@ -246,7 +246,7 @@ ath9k_postprocess_radar_event(struct ath_softc *sc,
 		DFS_STAT_INC(sc, dc_phy_errors);
 
 		/* when both are present use stronger one */
-		rssi = (ard->rssi < ard->ext_rssi) ? ard->ext_rssi : ard->rssi;
+		rssi = max(ard->rssi, ard->ext_rssi);
 		break;
 	default:
 		/*
-- 
2.20.1

