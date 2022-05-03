Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA7A5183A0
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 13:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbiECMBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 08:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234980AbiECMB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 08:01:29 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80054.outbound.protection.outlook.com [40.107.8.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55A72DAB6
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 04:57:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOxwJrSh/Vwsqb/4lzOMPS+Sc81jKvhwUIVji6qTwV++mdYs0A5MN2AJg5zysJB7z14lfEYIqUkm5eK5iZIycknL4vgn0H9Oz5qQ12STfjyHs23gQOmDcV463brfFN+ZKANul/mp6njcJAkk+GLm/wxMzwkbpqqTUWYB8cdGXFl5Bj+FprtT82MAUtVavniWWcW0GKmzPVu39BOspunaQ7wwrbRmNbZ7J+vDoMrsMs+hJEVgXqdGWHxyj+WPop0GDNgcVhKFmu7pch8mzxw2tguMhlT4MOQZumr6RU17TfHpGrvoOnYbI0R4Cn6YoVDVjMIrDOT80/9Qpe0IMWN+Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZDuo9nD1XVXSjfbiCviVSvPSLbhpczxubl9E7hV4bRo=;
 b=IPOuNVaD3/AIKUhaomcvm/Z8g+M46d/8rEQAxh6TF3Ura/Dq5MLn7Cn2i8c59B5afnKZNUyFNbT60RVTJuWGNx/P/hiSjTRQhnmOTNRNuyguhBRdM8lggzGGxJtmNrwe4rrGbRw+Uh3SSUjdKcyLWUVC8el/v1eNBjd0qNbHQvv5d9slBjVm93fPolqAV5vo3DgL4ExdMsc0TfVy915hgqSc19XFgeDg2v2DkZM6LRsWfooIoC0o+xIxW4bK2BMgEkELeHQclxUdO3O/8ZsRI0CkZ/Uyhek7Z1GSCiZxn6rwtw4dsqurZZ5IuyviBUnSqXpCxJYdcJ0RTrmGhttFhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZDuo9nD1XVXSjfbiCviVSvPSLbhpczxubl9E7hV4bRo=;
 b=OiD90QB5IokFqfRGol6wppK4SGXUvZ4P+g79Lm+JMkEVbtZX70W+htyA45q3U+6ERnj6iVv47Shm10R3CeKqpI19TfWARAnIj+YgB4tA3t5Bbiv2ysS5N9YDE1ktZDqnL9QYr2R5//88sFhoyTP+hfdkcCu9bGjeOny/RfNbvX0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB7PR04MB5513.eurprd04.prod.outlook.com (2603:10a6:10:88::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 11:57:54 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 11:57:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net 4/6] net: mscc: ocelot: fix VCAP IS2 filters matching on both lookups
Date:   Tue,  3 May 2022 14:57:26 +0300
Message-Id: <20220503115728.834457-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220503115728.834457-1-vladimir.oltean@nxp.com>
References: <20220503115728.834457-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::22) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 026bd613-1e5b-481f-24c7-08da2cfc284b
X-MS-TrafficTypeDiagnostic: DB7PR04MB5513:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB55137408603AA10F48B20165E0C09@DB7PR04MB5513.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lg+FDTN88giKVTtCvFA7ucDTVkUthc5zLdeyXKz+nSV+Bwjlb+R9/HVIzXkHkUAh8/BvR8z1jJMqdd5HANo+/HeNOQSMhQFdFHb+LYr7858EnQkA/QGDdScCVKhZF3RmR9SRNTxGRr30F4uvWWV4wAb6ciUnHBKYJbdWX5cKgWT183TGX73S8UBOxOcY4Injp1q6+8Gs0/PFSHC6IeiloL7A5DmNjE23UKFNj0s2VlHND1cxoxUj11CngMhlujEWZoDaM2EbdI/mwBTYOHzaV21blKttj6xBaY6vQQNY50c1c73xCezaRpV+dPKEwriClT//RexM63m3W2sm0bua5rNsQohn5efo2Xsb5pZqktsXaKrbPu9i9CStpdDibLQlim3NJ1olPfzkapAJrXyZ0BCzMOEq6Sv3JA1kpTAFjOYgaTrd6+hZFhJD+pLAbj6RelSmKTCgvARfF20OCitQ3SDYMWozO+73T3t3/Jxz/6wkEGpiexQLgisKirSJTtkhGIQBo7L/6igkbbezeyxNscNHB9iJ/P5Yg9VBFX9ReSucZc5+8Q6TVxYBzDMz8nNV+EfCzVboGDc/7qhw8wmvxaAgnqHjS5CLuEInwzfyEIiuouq/n16pxtO+XoIa55w793HF2vyCgGR+cAJtMAoJIsLjkXosfxgQC4Nzz+R32Zcbb512WgH7AzTcYm9eG3I2C9Nm87s/Pev886qzBgCeqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(26005)(6512007)(6506007)(83380400001)(2616005)(186003)(54906003)(1076003)(86362001)(8936002)(4326008)(8676002)(66476007)(66556008)(66946007)(6486002)(6666004)(2906002)(316002)(7416002)(508600001)(5660300002)(44832011)(38350700002)(38100700002)(36756003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hMlXW7xBazENO9TmlKC/cRyOI48gpRSTF6UAY5mUPW8aZpbPecZIyxjp/wUA?=
 =?us-ascii?Q?S2g2bPDDuRZY6f1Fsu4ZnGD9VYQgTv23FvpqEydxw+w6cVD4hEE5kxnMLcfX?=
 =?us-ascii?Q?znzLudMSeLDjZTbtwS2L7Uwwy1cHqfkmzOT26VSW5wiOJel/lCdXHGEwyslV?=
 =?us-ascii?Q?kfUdH8RvZH3nl4kGSO0KIU51p6l6ibI7O1n+mGufTJuxCJAeoXxmtbNskmRB?=
 =?us-ascii?Q?auTCH/ES0h80IvmijLVZlDjSYLMoarTGZ3fNBn1Tvakwk96Be9MfEtwNdubJ?=
 =?us-ascii?Q?psay5QC1sNFU2ub67FcEsluvSV/rfCkn+ppkrTd0WMZTWI9gXnmPc1Grd/Fa?=
 =?us-ascii?Q?rQrAB8/ARhmrG5m3L5SrnKgJ1sBTnndDdavyMwswCiJMOdy2/XqwC6iivjKo?=
 =?us-ascii?Q?iYEvR+TcYXVMTyNq68Av2GhQ2Nzavf54uEid61j8LppRIHZHWdtkSOdayX57?=
 =?us-ascii?Q?gdcheuk6dJ0U11FbUYzD5z+stAPI9x25S5Pu0ziiMo9b5EK55DyR2wmUg/Hg?=
 =?us-ascii?Q?F3D2bZt1rwcCY/UBiqyNgZMcZ1B3Voh0NnQQEolC3T1Dn/Bh4Rn9E5i+coYy?=
 =?us-ascii?Q?LTDI11v4dM5e2/mt6x3ZSGBs4MpxSwpkouazV4lsPAc1geKmFPWAzA7ucX6+?=
 =?us-ascii?Q?gytLlx7MmH+btdHYIrI37PT98TXCCS29IEHhFmhsaCVxOGa6UYogdiiEIUEy?=
 =?us-ascii?Q?ShDNmx5WDhmfAB91lX5vN/o+vzOkAbAyqjNTvSVsRJD+9nUNxPefGNSTe0gM?=
 =?us-ascii?Q?ijabHjabbTbPYYQvWXE4QZ1ag6/D7AuoeceATOOuwHw+YXQXY8ypnnI7FdtN?=
 =?us-ascii?Q?2jTwwn8pooRZQ2QRzAi4UXi9oFHVbG3ls658XW/cE0st0xkgriXIsewZw8LJ?=
 =?us-ascii?Q?qXkzCjg6IVJ+hMJs8l+pSAaNZktM06PBX7usWBFPfqiSNxnXKEAjhwx6Sp+o?=
 =?us-ascii?Q?L4Bo7/E7Pazdv1tz1IrGPpA8FerxSiS3vavHcP/Qhx7Vbw5oXM8LpRjXWm59?=
 =?us-ascii?Q?MDSyXPiM83+Tg5MVxtJhB2are15dNbQyOSunCYnkWbdkUumyDQ00saP3oTKH?=
 =?us-ascii?Q?lC4J6GOK9BmJ8fJRvaBbkN9MsMjgwJioXAB3Ms0b/zGrqw0lwB1KH2WYvBXH?=
 =?us-ascii?Q?mgg4tgC3ifogTlJNFiVxXO0Y0QgSP4eLSHfzkQoZUGfyatffh1W4LpkUdq0q?=
 =?us-ascii?Q?k79j+SXZJmgHcpILrJBwtL4hQ2ADrE3lGSTG83eWbdhqXqo5ta0Up9FfwNbg?=
 =?us-ascii?Q?tPjXG5BlftwQEaD30itakDlaei7z20pI+UemZvB7AzHwCHshk7b1pEw9b9lT?=
 =?us-ascii?Q?cNMhwsebGKiPE8WQyPIJoztdNYriySPKV1+JYmjphgDIcYUI9UcBAg56PKSM?=
 =?us-ascii?Q?s0/N0+pr3RAKuYDsNhdPqoDXro2M/Qnn1e2B5QyHnKpnDbMjoadNCrALBMk7?=
 =?us-ascii?Q?rsdY0kN0LNyhcztcvWXvY8mhnSDnzguru8STBdp4ZcgQ6zqRDw6u7g0nZxXX?=
 =?us-ascii?Q?z8CP/24B/oGSi5ao1VD9GKe3sAippLPoutAdFb4w4y9X6vUDVg1ZYikbqzUC?=
 =?us-ascii?Q?lxofyMmuMI9a+9A8auygNYy6WYk73/D1RCipRAqM1SCx4vpxTJnVxWPsQ0QV?=
 =?us-ascii?Q?F6EpXCCrMBsv06WFSpZN6HaSgoRR4NzzwXaGYzhbWo3F+2kekHke2dcGY00X?=
 =?us-ascii?Q?2YXJ90Tza1oGuDg64slmhqdKFgYFLBOKtUzah3UOEHwG1ddN/xu+1ZY+G4hY?=
 =?us-ascii?Q?pWP750O3ag8hQ96nrTkw/csVlDLzoac=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 026bd613-1e5b-481f-24c7-08da2cfc284b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 11:57:54.8865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C6NBPoynC1/NvlCsdW49yym2Qj16xuMNP0Rzcw2C6FMPTKxpYnw0Tmft2pE1I5Y2NZRfbqic4BzPbdOJEOIB2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5513
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VCAP IS2 TCAM is looked up twice per packet, and each filter can be
configured to only match during the first, second lookup, or both, or
none.

The blamed commit wrote the code for making VCAP IS2 filters match only
on the given lookup. But right below that code, there was another line
that explicitly made the lookup a "don't care", and this is overwriting
the lookup we've selected. So the code had no effect.

Some of the more noticeable effects of having filters match on both
lookups:

- in "tc -s filter show dev swp0 ingress", we see each packet matching a
  VCAP IS2 filter counted twice. This throws off scripts such as
  tools/testing/selftests/net/forwarding/tc_actions.sh and makes them
  fail.

- a "tc-drop" action offloaded to VCAP IS2 needs a policer as well,
  because once the CPU port becomes a member of the destination port
  mask of a packet, nothing removes it, not even a PERMIT/DENY mask mode
  with a port mask of 0. But VCAP IS2 rules with the POLICE_ENA bit in
  the action vector can only appear in the first lookup. What happens
  when a filter matches both lookups is that the action vector is
  combined, and this makes the POLICE_ENA bit ineffective, since the
  last lookup in which it has appeared is the second one. In other
  words, "tc-drop" actions do not drop packets for the CPU port, dropped
  packets are still seen by software unless there was an FDB entry that
  directed those packets to some other place different from the CPU.

The last bit used to work, because in the initial commit b596229448dd
("net: mscc: ocelot: Add support for tcam"), we were writing the FIRST
field of the VCAP IS2 half key with a 1, not with a "don't care".
The change to "don't care" was made inadvertently by me in commit
c1c3993edb7c ("net: mscc: ocelot: generalize existing code for VCAP"),
which I just realized, and which needs a separate fix from this one,
for "stable" kernels that lack the commit blamed below.

Fixes: 226e9cd82a96 ("net: mscc: ocelot: only install TCAM entries into a specific lookup and PAG")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 469145205312..a4e3ff160890 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -374,7 +374,6 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 			 OCELOT_VCAP_BIT_0);
 	vcap_key_set(vcap, &data, VCAP_IS2_HK_IGR_PORT_MASK, 0,
 		     ~filter->ingress_port_mask);
-	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_FIRST, OCELOT_VCAP_BIT_ANY);
 	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_HOST_MATCH,
 			 OCELOT_VCAP_BIT_ANY);
 	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_L2_MC, filter->dmac_mc);
-- 
2.25.1

