Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD01955F2C4
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 03:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiF2B3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 21:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiF2B3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 21:29:54 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30107.outbound.protection.outlook.com [40.107.3.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718EA1FCE6;
        Tue, 28 Jun 2022 18:29:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DRKyEgqPr1i8ER/rdNU197gTyoxjCn+T16kT3ez1croir3R4yzO/8zefqYF9jEuaXGUVnv80jBlZjBlOuM0ht3O21FxsFPWGBDO9Ji6swjbC4I9TKYNgOnoIc5xMdDdQ29lrdgqKclMDO1laSunjJqMhnWsOxAzcQrt/+3/XK48S769D4rsbeOVD+bdIP3PC5hP1bnF/RZE4jnQpUNSmWFH+dxFnTKDlElwMV9A9UGWl3IlaSNZ6hUrhmJa0EooesXJCiHWDqPpRymPhouH0rxN4S/jlHzqOnT7obkl+g9AlJW3F9rcDgCB+qu+54w5KutILFrhAo6/TDOp2C8yrpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FQl8HpDFJr9iSS/HnVj7pSsOP+HDHNcSQnbHR4GVpbo=;
 b=KjVJhRh7W3IZ2O1d7oIde8mnCp+vBPMffO6se+G+6D6wpwBhG/A1OTAHTnk2fQJvMowKjb21zR2JmqHfPPgQWbnIG/p018oWGg8++KNAyleLP1szisakDKe1YdY4SAEjCPLcICgTAZQyAXFJdrA/zV+DYYL16UK8LPL6DU5InBpmJewbqcuGEFkpIEalYFJuVPa8rlDqYaMItYTIrYU8po1XXFEgZs0uo9p7K8B9EgZsyTEKXPAU2nm8nmZfMK4qqJSS2FeBJhs9fD7mz52uBY61F1l6HB2BY/AuYioIvYw72ZJxbc3EiIQ3qVTD1QLY7893VkOnl3oKVs5a6r88kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FQl8HpDFJr9iSS/HnVj7pSsOP+HDHNcSQnbHR4GVpbo=;
 b=fln2l0wb/mzIGbbKUf7E9Qrnm+77J3AOLDu+T1Q/I0muPd3q0h6aj1uQAgZLxJwjiJjjOIBK73Y129smOxhYw9tdWyVWV2wJWCXct+BMLIoPydTI4VjIZYKWyFku7ga0h5vstp3zR4/Bqt5MeEVN+3sa9iizaxWFbCXI0b0/dLA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AS4P190MB1782.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:4b2::12)
 by DB6P190MB0408.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:32::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.15; Wed, 29 Jun 2022 01:29:50 +0000
Received: from AS4P190MB1782.EURP190.PROD.OUTLOOK.COM
 ([fe80::f834:619:341d:5cbf]) by AS4P190MB1782.EURP190.PROD.OUTLOOK.COM
 ([fe80::f834:619:341d:5cbf%8]) with mapi id 15.20.5373.018; Wed, 29 Jun 2022
 01:29:50 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: bonding: fix use-after-free after 802.3ad slave unbind
Date:   Wed, 29 Jun 2022 04:29:14 +0300
Message-Id: <20220629012914.361-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0035.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::22) To AS4P190MB1782.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:4b2::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88555e20-055c-4a0e-112f-08da596edc0c
X-MS-TrafficTypeDiagnostic: DB6P190MB0408:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qplRlg4ZA/30GmKG5GnWFTnqKRUvGwkZEpVqbrN0SvkHiE7JCxffryVZqBN+avEFBUmpAiMmCNeTlJzLq0Ovcy9KC93+x1iuY5oiCw4pcFONzxUCb0ea9PuHQpbncN+88P0+N2vWP5DWvo+/7DX9VL0q3+qXJ6odmBcNB8qZtTBGRIhXtUJe6mgoTjLRtXFCXEu7ZB0pv6rWLZRajJQTWaCuGy+Bk+hp4Ruq2fHG7N9M6eWf0NWQO8v+9bOK/9MJl1fUvZkWEnDyvpNsZIUsui4aGETiLJDH1s1qef2omXWyYGh/CPnPybp20ZtwD12920jebRK0lVSz/5Brnl3eTHspUEBgLAlh2j/qE6N8wdneryGRvDuLxfEkNphTFkyKDwxsQCu/ZmqHVyY9SVDpTK/SJ7iMnWEsTdGWZzFB0kPKBGL2lVT/GblPIMMy6EDgjgbRdPxqL7p6/a0fcAhA8Ayo4xqiIfeTNJLS4fNWyhGBbZZF0GvYYSva5FQIBHUnzQs7sT2Hzw6GF4lf8sC4LdNGNko1ClA49rntV5n1306gefKMcr/qI6BRe96Y201KthJPUmsH/beSAzN86PqLKV/K+cDtGUfMx/NaSwSSJbIpRubsYnyuk0M1Ek8XY83MjrwowQdh9Q9I43aSQHD1DW944udtx1rPRpbCff7dQcpA4q4d2FlvuZcsPb5Bygd0zRcSSMSR9nRZsX2dDPrXQ3hDYdoT3nE4Np2fJcgdRbZhiSVG/1/FM8nLP0hv4N54xHNEFKKW8Pt9OuvTHfuj3AfJ6jF2GhrHehdkGrg3EbQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4P190MB1782.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39830400003)(346002)(376002)(366004)(396003)(136003)(38100700002)(41300700001)(66556008)(2906002)(66946007)(38350700002)(478600001)(2616005)(6506007)(186003)(83380400001)(54906003)(316002)(4326008)(6916009)(1076003)(36756003)(66476007)(6666004)(44832011)(52116002)(26005)(8936002)(6512007)(7416002)(8676002)(86362001)(6486002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8tYZ0Uqk1Pc5FxKuVhxwzbUc9B+NWrvcBvN3qf5qzxoTzxmqnq1MKxvZHOyR?=
 =?us-ascii?Q?iRUAdsXqq0hnSnMTpmnmL4TEzGRFAlWEg31KqCPQfF6giSpN5+k8iliHA6Z7?=
 =?us-ascii?Q?DAeJUuykWCNVg7WejGyN4Vsh49Exg0xFuujlaFWUrXHTXe6kTchR/N4DIlDj?=
 =?us-ascii?Q?QIMpM9ISz7PvmM7/4ecPVNaE9SpMLpQe9b2rV9BZF8zr1tNw1s+D5xzWlm8t?=
 =?us-ascii?Q?IPDlzQQmSEttrnS1IazgB+igJbOxxoESxVsh1iqSuYgEei3ZW7V5oLnVKYCF?=
 =?us-ascii?Q?ZllAYEnqtI/CMpmKLblMkzUkMqq81VhIUlgItUjYaH83x5P9BoZmuYkkOWXE?=
 =?us-ascii?Q?mf0wBfrZGZ33/qqUa47mk3B9pl7Pm4R8u3RZ1Hd6p+kPKrS9c2dhD+4bCnBI?=
 =?us-ascii?Q?2gLj2MCo9KORd3uKJcwDQP8ov1f1Ym84JdCuQ9fcgQfZCTkICtDovaohi0dE?=
 =?us-ascii?Q?v53mDFuO4H06yVafyp5qdZXVkrotSwiV3Ij2c+Rea8wlV6QIdfZusQlo9DX1?=
 =?us-ascii?Q?+zFhpbh6f+goHbTmjW7OQAc1omRh3r/OrH+LDvF4+C/0wP7evJih6+U0bUa8?=
 =?us-ascii?Q?5923H7ZcksK5dBvWvutajufmfLpaxDjznBt8HGzu6s12s9RGHEgqhXkv+2Tg?=
 =?us-ascii?Q?5LrUl9E52UXWK8zN0U26WWq3NoyaqCuQ5Yuo+Uk5a6d0JGwC5YTv97qRsSJ+?=
 =?us-ascii?Q?bu8mnUVWnSWF+z+XKtz7KGuZ+nPbJeQHB/jjKpBwl2Gl5zZX2xAIBoyiF2DW?=
 =?us-ascii?Q?1Z0cqwgp90Kigms8gWh6vimiwTaEf6VUkaJyujT7nKFxYhnWIH9t5abBgt3p?=
 =?us-ascii?Q?7NMNk4YZ79dI1neCGtU319SYjHXxEyAhIIoAaeaHYxG5bcAdoYYGCDFWaJjP?=
 =?us-ascii?Q?4LRlAH0tRptiguyX6HNl/ViByOVH5MkTYFH0jmRJadqVji79/kjCfhAQiZwU?=
 =?us-ascii?Q?lcwH6WhJEiJNoOTJpJJkQMPxQrGg+2NGiYash0BGxhPICxXj3y1JzT31Ei8v?=
 =?us-ascii?Q?GAtqs5qBD+lJTMnMxZd06PSgbk60Y/VxF6hk4kbelGYa3KSRGt7zpIHj4KVX?=
 =?us-ascii?Q?a6f3Sx2C7CDXm1tbTSg1Z4a7W6MaF4lyENYwqjqEcV4hDYa8gaxpY8VPJuqK?=
 =?us-ascii?Q?H4miw9KwUj/56oZespgVB3Xe0Cci+7cvk1oZkIuu4nvFoWAnlXckQwPQfXUp?=
 =?us-ascii?Q?rB16CD2+Kxb3HBBvd2neJVSWskDquqbPpwwEo3IxBdeXkeARIgrIjEwshC0W?=
 =?us-ascii?Q?qzXDCFqcrWrf5N/HSqzOPWFm40wp/zZnonm8BQLgL3Ye1OBZhkU1pJGLGlzg?=
 =?us-ascii?Q?PcGi2h4hPzMQTklfzCDWxQfQvQckP44ZHVlkhPtyBnciMoHL08lxpCiZyArI?=
 =?us-ascii?Q?zy1EwTTsQujus1tdniwgiwY6NRvksH7fG9i/Vzo0K8+gbxuGLmVFcRjN2lmO?=
 =?us-ascii?Q?dsBdhnfXHUHhP56ZQ2inCeEemZ26P5PKvEv1PtmOVaJ7U5c1jVb9KFIHf415?=
 =?us-ascii?Q?5vLdt0ZLAe/Fdqk3dReMSr9f1A4UDrgBGz5IT0F4BMIJiHV4uc5TBubN38FE?=
 =?us-ascii?Q?bJLDMhf+cxPAhJdqMxU7MVmcTp3VYJWhxXBmospQu+AsT2RNIrP3xbBv2sPi?=
 =?us-ascii?Q?vw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 88555e20-055c-4a0e-112f-08da596edc0c
X-MS-Exchange-CrossTenant-AuthSource: AS4P190MB1782.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 01:29:50.0649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +aMojuJZTsQ5bonpkRWaDQJSw9P4uz4XAo3jqOPdiSBbqenZ3O6em9xoymO/Grt9CFOEe+RgeFGPB8KUx8TuYqgkJZ0cXs3xkBtZT2vSkK0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6P190MB0408
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 0622cab0341c ("bonding: fix 802.3ad aggregator reselection"),
resolve case, when there is several aggregation groups in the same bond.
bond_3ad_unbind_slave will invalidate (clear) aggregator when
__agg_active_ports return zero. So, ad_clear_agg can be executed even, when
num_of_ports!=0. Than bond_3ad_unbind_slave can be executed again for,
previously cleared aggregator. NOTE: at this time bond_3ad_unbind_slave
will not update slave ports list, because lag_ports==NULL. So, here we
got slave ports, pointing to freed aggregator memory.

Fix with checking actual number of ports in group (as was before
commit 0622cab0341c ("bonding: fix 802.3ad aggregator reselection") ),
before ad_clear_agg().

The KASAN logs are as follows:

[  767.617392] ==================================================================
[  767.630776] BUG: KASAN: use-after-free in bond_3ad_state_machine_handler+0x13dc/0x1470
[  767.638764] Read of size 2 at addr ffff00011ba9d430 by task kworker/u8:7/767
[  767.647361] CPU: 3 PID: 767 Comm: kworker/u8:7 Tainted: G           O 5.15.11 #15
[  767.655329] Hardware name: DNI AmazonGo1 A7040 board (DT)
[  767.660760] Workqueue: lacp_1 bond_3ad_state_machine_handler
[  767.666468] Call trace:
[  767.668930]  dump_backtrace+0x0/0x2d0
[  767.672625]  show_stack+0x24/0x30
[  767.675965]  dump_stack_lvl+0x68/0x84
[  767.679659]  print_address_description.constprop.0+0x74/0x2b8
[  767.685451]  kasan_report+0x1f0/0x260
[  767.689148]  __asan_load2+0x94/0xd0
[  767.692667]  bond_3ad_state_machine_handler+0x13dc/0x1470

Fixes: 0622cab0341c ("bonding: fix 802.3ad aggregator reselection")
Co-developed-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 drivers/net/bonding/bond_3ad.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index a86b1f71762e..d7fb33c078e8 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2228,7 +2228,8 @@ void bond_3ad_unbind_slave(struct slave *slave)
 				temp_aggregator->num_of_ports--;
 				if (__agg_active_ports(temp_aggregator) == 0) {
 					select_new_active_agg = temp_aggregator->is_active;
-					ad_clear_agg(temp_aggregator);
+					if (temp_aggregator->num_of_ports == 0)
+						ad_clear_agg(temp_aggregator);
 					if (select_new_active_agg) {
 						slave_info(bond->dev, slave->dev, "Removing an active aggregator\n");
 						/* select new active aggregator */
-- 
2.17.1

