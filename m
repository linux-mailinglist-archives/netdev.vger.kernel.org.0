Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08226EB03D
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 19:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbjDURIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 13:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbjDURIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 13:08:45 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020020.outbound.protection.outlook.com [52.101.61.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67652D56;
        Fri, 21 Apr 2023 10:08:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvH3/riMhqTqmpeSKabzGExQw/rkSfJcl7yNDYrx0DwcHtqjqD6POsx8HdkXYHucYN0SndRroKqLa2wH2w9w3vQTKaAjrnGd0f+zurO/vnyTM/gKvaGWlz8x7aMkBfXcp0grrbxyvWyj3PWYoeO2ZVe7bB9XQwJs+9F01fzQA4qmVbdnBa+w5dj9I++s5AGVErMJj80KzFB8B3k+D5XQkLKiZ/mcR4VwTzo9S1Mcyi085OatZapaAk3OjmQX0BWGDT/gR2xSZArmPj25wGMjVfd23Xtv2opqcZtN3jsakI9nzEe60mMLEhL/LREexdhMoeLQev/lP5XeyDsRQ+75kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1HmhJxV6cmUgswVaDI/a//1gqwtqv777RmGSU5xq7I=;
 b=MfDWTYDEMgx+2m/+gX+Lcc4uwsduwlAjBO2Y+e5bqc41XGpLob4ui3kjXsYk7qad/UdZKvYkr985R9XGIjM+hQos9507boWqj1N4X3vfHT2vjr2VRtSqkRcPsoNmrULKMvXDb637/Z9ho7tWMLMC3Gy93Uw5DY4Fu9wzPpZXDCoriPea3oQT3RPPwevak84/gXziR75JqTbLpG3y8dA5wtM3HTuCZgnjg6S04/A15cP1omWQAqVt1KheNAnjcv9WJVDzMwmhZ2Kpo6428gjBxG1iFxgjC+O7Pq7PbaDBsHCDxOkqbD9eST2Bf3ls1LXX5arV/BhCCz8FJ5mcK3+m/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1HmhJxV6cmUgswVaDI/a//1gqwtqv777RmGSU5xq7I=;
 b=SREZIXHHMM8LuERNkIXC28+cP3oRLsNs+jKUZ5e0eLbEW+gpl8hsi8qAAzZyYlSM5GnR++/4mCnn2bjyAZMe4ljZoiMuyNYTMv28I6BjeIW6KLClRv0jJpe/AL6bragv4X1x6wr6AQtUz3If2OGX2vOm18JE0DHA5nzvOABGfrM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by CO1PR21MB1316.namprd21.prod.outlook.com (2603:10b6:303:153::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.11; Fri, 21 Apr
 2023 17:08:02 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e5b:6d93:ceab:b4c6]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e5b:6d93:ceab:b4c6%4]) with mapi id 15.20.6340.015; Fri, 21 Apr 2023
 17:08:02 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, wei.liu@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
        longli@microsoft.com, ssengar@linux.microsoft.com,
        linux-rdma@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        sharmaajay@microsoft.com, hawk@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next, 2/2] net: mana: Check if netdev/napi_alloc_frag returns single page
Date:   Fri, 21 Apr 2023 10:06:58 -0700
Message-Id: <1682096818-30056-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1682096818-30056-1-git-send-email-haiyangz@microsoft.com>
References: <1682096818-30056-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0102.namprd03.prod.outlook.com
 (2603:10b6:303:b7::17) To BY5PR21MB1443.namprd21.prod.outlook.com
 (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|CO1PR21MB1316:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a78a2f4-ef35-4113-78c7-08db428af71a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wba/7GADcIhlqE372dLxFMN2Ro2+btQwLEUSRjv4tZACp5rhgjQ23Yrk3zVREnVw8i2ssoKY7mivMJLYPTQgWeeB0jiKuQRBrA9BW/zt/Q3wiiDMeTFt5xT3jnCubC+lI4jPdJIBVR24wz1tBsFfeRvAQeZDdLe5Iy9J/ElyE+y9lgTB4ZkwE7AvGJv2HpkyYO4dV8dhFzpw5kq6Bl40R2WoNaZuWOTCOt4dvdRIYoIqhhg+j1aVdGbVigawF1zJC/GGZ1lOrdW6yyeX/uHf3Mc+EgvLwCPNNjDua287612XHECZR1DhKHh9wZHfLBUa83nxfcR/RCwjn9VkEv+aRegeopXVd6evIMqgo+gHSsQzn0NFxA5ZBkaOWujqfWZGdXG1D2696eLHL9IjVcUnptJC+L/TBQ55Qty70IDLxAQ5oAWFH62MvSD2gPY2on4+3FadWG7eQVmNCbWkv0VsOYYqxxzzHPAtskZHbLD8agbl9PxJSmFE8hCov6g4jBE6ucoOjmeYwsh2BLJSnEUQzFR2hk2fhW4WRDMVBo7b4fWRIX7Ek8nlsBdiZnRzqQvVBGcyj6OtqBpPGKWa0xCFs97NJtmrj1TXhTfSVebVXDNc30EdRyChMzcfWBQf/I/KSjsCAqkXCv08v9YEJoOjoF8SguU9HaLFJsMNzqV/IDk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199021)(4326008)(66946007)(7846003)(66556008)(786003)(66476007)(316002)(36756003)(6506007)(26005)(82960400001)(38350700002)(38100700002)(82950400001)(6512007)(2616005)(186003)(83380400001)(5660300002)(41300700001)(8676002)(8936002)(478600001)(52116002)(10290500003)(6666004)(6486002)(7416002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?76mTHPZBkMQoZMTX4AhCw/ko7perv+ya4Tlc+mGY4Od3b6j8lniZm1C53edd?=
 =?us-ascii?Q?c3LAF7USQlAYSBAHEo7EFwrFU8/FS8jakWWT+RdWOJ/b0PLIh9zxp6IRKpdX?=
 =?us-ascii?Q?ofu4eIhu8pLlovu4+3iQ3W6pQC3N+lRR+Gncwv54BhVSkYRFr82YfAjGpUKI?=
 =?us-ascii?Q?m+XUI8EvWAZgRBxsE5kr6HPCNZwHqRy72EIYbasOMORfIRxOF2pauOcDMB8S?=
 =?us-ascii?Q?WPsnARrXjzvI3fRPNUidIZmfC0vicj2X9DSse63/hyLZ47rJMvPLKusU4/3D?=
 =?us-ascii?Q?Ayu0/D30fjjYbzvJ37/N20Ru/+s35ZmWUrFIkazRLaKCdA1hrRwvINL7k8U7?=
 =?us-ascii?Q?3+Kpvrwg2iHaH33PdUSOEWJ05mICZGCFIGK5nOTjPm92dTEwMGEn+RrTbLFn?=
 =?us-ascii?Q?F5k4DpAwW+vX7H3axggP/6g3OImw+zHdDaDfbD6kBBB1d/X5oeW+F1hX/j7G?=
 =?us-ascii?Q?2JOIwd89jSqBh3XXmlSSUS8hOCXvNBPQEhikFk/svqgrjGKG4uUMwN5myJCy?=
 =?us-ascii?Q?ED32gNSSjtYvz3mDVPpfxqNqOA9qMxzUONVgBVrUV+kTGddIClrVdi0H2CIw?=
 =?us-ascii?Q?8e+WijSc2ia1bHYJA3o70AiuKs5C2VcTfEQ7CQ1U8nYul9ckgIeLonXTz6mn?=
 =?us-ascii?Q?lhu7XudA7IFVOR9minuBNnlc4HnB2+YwyWyZ253J9SjNWqq7GaobaI2ZUZAj?=
 =?us-ascii?Q?/yvVuyK6Jgb7hsJe5wcgMMhfjqj4CTrM3gJtnG+AYXhvz9llLw3IOf7h1y1E?=
 =?us-ascii?Q?pXUx+EyDV3+0KbhiNg7fd3Xt78QUl3smrFPnO+HEDQ39YTvtC1iqU/l8EAn+?=
 =?us-ascii?Q?0B/YaLd3SMGfsIzYERNRMBI1f8tpLX/Y9zpTbSdmfP8GZA93Q+lSBZ1iyZEp?=
 =?us-ascii?Q?J2pi2WRC6MwpctfV7hUYNgOyQHgL0R7dXa0pvN/mmrgk0NcwhVrZyaPoR7It?=
 =?us-ascii?Q?WinbrEuPfKpwK6e7YiXAI7MwWuJboZC8gvGXFytbeDuexvqC3YFyJo3f5GzT?=
 =?us-ascii?Q?ase0r8Swu07tr5O1bY1Vcm/RzN8JQ+arDHT7SxIjfrsjf/EixIx5tD2YwqiO?=
 =?us-ascii?Q?uiuxGBZ3x0W9ofp6rXLs6Tgw3FnIO624hDCVQTQYYgViUudcCLVS4inMo8yL?=
 =?us-ascii?Q?SDlT7HQiczWzRwmPdxeeiYg/WdgWzKtsvr6a97g4JKsvf0sxiq7eUud9j209?=
 =?us-ascii?Q?AKC0JIGWkUWt4RZ4rcdBwqqEFEUyJgTBLZEvLaHia6/vCLgqJcQh6YQqPsMy?=
 =?us-ascii?Q?I8xYwOsC77EcE9qPwmC4htEST5BGQs6GaPSTRSTMQxF6JKYjrWRx/EYTkI9J?=
 =?us-ascii?Q?WoPKEZ4wRN15mS9oGARnzhaVtTxzkUa3tSikOrLhjxY6xa1Tv1awKzjk6uT1?=
 =?us-ascii?Q?kzSn85Nt3NjDcgAeuDMTtBrz5LQzVeujinZUO/YDlY7AwRoXx9mT8J/pZL/K?=
 =?us-ascii?Q?dgNoYKF71bGviCoG44QVtTbhv/SfHvK1Px4ih3qbwqgJELqKvVUbbgomozqu?=
 =?us-ascii?Q?yZYaqsuh/9egvHXuZgcKjPXHofHSK2n1vI2H5ARC/6syqSYiAJByhbEa16bF?=
 =?us-ascii?Q?ZWtGAt18O1P6ze9DgrkYXXrM3nQl+h7fSx49WSsD?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a78a2f4-ef35-4113-78c7-08db428af71a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 17:08:02.2854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0V3mpMbzuAt4yHlJy7q8xx4Ro+przExRNcllL+IsMVGqAVfOb43c9vkbeF2UjrEKuWHKVoY7Iqze/71OYjGTrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR21MB1316
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev/napi_alloc_frag() may fall back to single page which is smaller
than the requested size.
Add error checking to avoid memory overwritten.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index db2887e25714..06d6292e09b3 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -553,6 +553,14 @@ static int mana_pre_alloc_rxbufs(struct mana_port_context *mpc, int new_mtu)
 			va = netdev_alloc_frag(mpc->rxbpre_alloc_size);
 			if (!va)
 				goto error;
+
+			page = virt_to_head_page(va);
+			/* Check if the frag falls back to single page */
+			if (compound_order(page) <
+			    get_order(mpc->rxbpre_alloc_size)) {
+				put_page(page);
+				goto error;
+			}
 		} else {
 			page = dev_alloc_page();
 			if (!page)
@@ -1504,6 +1512,13 @@ static void *mana_get_rxfrag(struct mana_rxq *rxq, struct device *dev,
 
 		if (!va)
 			return NULL;
+
+		page = virt_to_head_page(va);
+		/* Check if the frag falls back to single page */
+		if (compound_order(page) < get_order(rxq->alloc_size)) {
+			put_page(page);
+			return NULL;
+		}
 	} else {
 		page = dev_alloc_page();
 		if (!page)
-- 
2.25.1

