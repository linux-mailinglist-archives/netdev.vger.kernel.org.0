Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA835641F3
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 20:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbiGBR7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 13:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiGBR7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 13:59:18 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120072.outbound.protection.outlook.com [40.107.12.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6E4D133
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 10:59:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T4P8H1oIYHm5Cb9G08CFoN7atmIF1jckbeg8viwtU+yG6//M315fgKgTocVkLrlsdpWgYtQGZGbuOboRjqwjsjw+nSESQpEi8y6XrCIwyRo6eQhP0Q0Z0qDm8VyJnRNBJiwPESJhvQJ0GzjMmnh8v7v/4inEBQESX9NRIqjwqJQaOUSTrR7kfVVwZ+5vA7k0zoFdEOjpTM8zo1po198e94gEGl8iNQo8eKvPPcEQPShfvFqixsfZcJGEg98ILaZN3KEoJ+cTHyzcc6L4vGXmCbHtQoQNuiCiI6uTeoUgJq7curHYNiNWEy9ab75LfAuQdLDnlIj24FLiMrkO2h+snQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JZO/j/ifXOhvNgqT40I/Ks8AZKTt7twQEcymYPNJzFA=;
 b=Top6K4rrvFATbOQeBeSC5alu7/zqdxntQA1r0g1vGx7X4jqIUI/pyp8QbyPJNMKLVnZ1413AaIwTICspWsJCPBEsd3wxb26bPI+BsJUzaghs6Nh2DY487FWZI5fY13kstaGZCya6T/7IHXxWimiV/9iDpEOMzHmqVLYZVj+EjdJuwQoZbP989bLZbMPFfI3x0dQzmfIhszsXJ8qJpp435PFQFVFMw6dbZmRplIVAl9VQyLvocgzT6IEjKlcO8suXJcPEGlMRv0lhE9gCyryWkeVdsmfGgdhX/0n/LoJj19ei6v0zlwN+iAA7Ijlsd/jmzAHpYu8d52NL64XuSEgYmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=randorisec.fr; dmarc=pass action=none
 header.from=randorisec.fr; dkim=pass header.d=randorisec.fr; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=randorisec.fr;
Received: from MR1P264MB4211.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:25::15)
 by MRZP264MB2523.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:1c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Sat, 2 Jul
 2022 17:59:13 +0000
Received: from MR1P264MB4211.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b0f9:b415:c28:9138]) by MR1P264MB4211.FRAP264.PROD.OUTLOOK.COM
 ([fe80::b0f9:b415:c28:9138%3]) with mapi id 15.20.5395.018; Sat, 2 Jul 2022
 17:59:12 +0000
Message-ID: <271d4a36-2212-5bce-5efb-f5bad53fa49e@randorisec.fr>
Date:   Sat, 2 Jul 2022 19:59:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     security@kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, davy <davy@randorisec.fr>, amongodin@randorisec.fr,
        kuba@kernel.org, torvalds@linuxfoundation.org
From:   Hugues ANGUELKOV <hanguelkov@randorisec.fr>
Subject: [PATCH v1] netfilter: nf_tables: fix nft_set_elem_init heap buffer
 overflow
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PAZP264CA0117.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1ef::8) To MR1P264MB4211.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:25::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc7cd0ae-4933-460a-bbba-08da5c54923b
X-MS-TrafficTypeDiagnostic: MRZP264MB2523:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OeWrUCzn2GMovp7Q1YlElwH5WdgTCG4uxkwdj+zMVgaBEFLAJ6MZsSrhxFBjCxDhTevTLYwFmOWrtqIL10iorv0LcxsQxamYhG560g8uCccjghwikR9J4ZiAEcAehR0TJBWydvx4eiaA1wPWatHfwK+6vFJQhwUblLZpMdfqzN2gZUi7Fegph4E25QrxFXwATHvBrXi3g8EIh5Ak7EvbZVOcrLck2kHvVjK4DFp8LHGOspup7qFetGuiabCvgget6Pkj9Ac/1pPHlsNLOqKO5QlUnFqyjFD1s3xNV/1ffmJcL7IDTi5V9Vr6/3+eAd/IabUNl+1yO7CPva60BcU7TKCeqZiGctsIAdlaiPqk1VxQsoz4/VyfU75zTm0LEsnZhtbnelsCB9gUzRBKrUvztWM968EDwkWqDfL5W8phvy9mZTs40zUfKxIcguMhm/9JJ9doL7PVRf+JnyYwCFMYHsD+m7D4BoAV2GS0UX/9tcoBvDmearIh4WVgFY2qflIs8W9VSn2g706m5OLjaF2m6L9JlSc7bN3izQKOPSEoAvNtLaafcUcQGK1RCXdjWowiSSNKtQbOr6QLFbxHWkh42XnucTTO/PQDRjo/WcQyYfsoGD8saVWq7bZkP9kdBFyLD6x5idDOb0QjHuM+Kfb1+wCHyqbw+LzrWqhyEnvPR+Ps/PKhnFxfUShaJ9c37l96t4LNJrFBDK15b/kyRjXUfzPPSZg7tENpUbjxLs2TjDIk3+UfhUQOlFvv4YK43pph4tSKJHDXkQ8qZs3adI/i7mXe3rFV0d+yo2rBDthJEiszmCvxGs/IwQOj1xAJMnDmFAhSo773St0I5utNGcR8jVQMnlWS7n7NUx6UKeMgb/4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MR1P264MB4211.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(396003)(39830400003)(366004)(376002)(346002)(136003)(31696002)(86362001)(6916009)(38100700002)(8936002)(478600001)(6486002)(2906002)(41300700001)(5660300002)(316002)(4326008)(8676002)(66476007)(66556008)(66946007)(186003)(83380400001)(26005)(53546011)(6506007)(2616005)(6512007)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVYrY3Q3aDVSWk5jYVovSDNOYUwySGlYWUJCSGY2b3lUOXlIV3ZrbWpyTEpy?=
 =?utf-8?B?bDh6SWt2RG5aTG5Pa2tiQWVab2kzZk83R1o2M2tQQ1pzQXBOcWVsN0tqQnBt?=
 =?utf-8?B?dWFBQ0kzNCsvODJ0ZkMweUJUTUtrMk85NCswcFFJWVJXS2RWOTBtVlU3S3Y4?=
 =?utf-8?B?WkpSazZ0NFlEYXVsQ3JVOG01VDByWkllY245NjloU3ZRR2ZkSlpnVnF6Z2py?=
 =?utf-8?B?eDJINmhBbmpvVElqUzJrVGFxaVBReW5kWGlQSFREaTh5NzRBOS9qQ0ZaSjVw?=
 =?utf-8?B?Sy81bWphRGpGSkF5ZFhUcnV3ME9MZ1o3WWdlWVZERjJQaDdpT2o0MEpGL1pU?=
 =?utf-8?B?YU8rZnNQUVVpeHYwNEt5T0UyQ0ZFV0JJY1ZXMTJJMkdOOEdjMG5JdVJQRXc0?=
 =?utf-8?B?Rk85cE91TDhYcWZadDZNd0lqUnU3VXVXUUIvbTliSS93WkZmcHVQSDYrNlYr?=
 =?utf-8?B?eE5lNS91SDVIS2FFTlpIS3JMUEdmOEVVYU9zTUYycWg5SnplLzNWYzBpUWFt?=
 =?utf-8?B?c1Roa2dYejNGUzBpcFBvdDljekdOMHB1UWZaS1NiaUMxV25tQnFzcEdhMGVS?=
 =?utf-8?B?SWZjZlhpRUFML0ZWYVBCUTErdXhUSXh6MlRVUkdvc3N0b3VZK2NoQTE4SUF0?=
 =?utf-8?B?OG8xSXd0QjlDazNtbTJMaHpxUFc5cFZNWGcwTUFOZEhLZVFEY3FrMHliZkhF?=
 =?utf-8?B?Mnp2emNZTVUxZmRSNUFCSWJ2Wk03aXJTMUh3Wkk3cStuUHl4cU9OeFBTdnp4?=
 =?utf-8?B?cEJSaG5oQ3ZBWnhFY20vak1jYWlDakNkWTdmejF6WWRrQU9rZWxtaU5vMlBZ?=
 =?utf-8?B?Q3prc0hXVlFaVVFNVDJTUU5PYWw0NVhuUVBBN3l0TmU3NFRML0VDUmtmUmk5?=
 =?utf-8?B?S0xvU0FaTXBFS3FxMnd6cFloQS85WmlQOURxcll5amNHV2tGV3Bya2pnR0Nv?=
 =?utf-8?B?UUJTL3JnU2hwbkpZZmNVUysyNVdGZlhyY0dlVDIzQVRSSnZqdmNNOWUwQ3Zw?=
 =?utf-8?B?RVlPSmhMbWZsMVdIS1Q2Um8wM1dVTUk0dkRGaGNmOU9oeGZaVU9ZeVlvOFpi?=
 =?utf-8?B?VGp0Y0JjMXdGQ3F2ZHZTU1k1RVZkNFF5MU11dkhybGFBQ29rV1AwTEJ5RHAy?=
 =?utf-8?B?NndTa2QrZEQrMGpPamJlMWRkTDRIY0U3OWxYOEd1T0VIYkdNR0lZYk83TURx?=
 =?utf-8?B?Y1dzYWdiVDhoN2EvcmFXMTZKSElORytDdW1UODlkYkJ1SXFwWXVTS0ppaEkz?=
 =?utf-8?B?QXdxaFhmUXVkQk41ZkpYSlFvam1qMGtyaWtYMXU3SmVkYmVsc2x5dTBxek43?=
 =?utf-8?B?UkZ6V1cxdzRZWGNMai9kMnVlblc4QlR3dGdoazhIYklCNEF0TjhITVBpMzlH?=
 =?utf-8?B?ak41VmZ2MXBEMytUb3hUR0ovS0FxZ2tGOTRieGtyM1N6Qnp6aDhVZnJGUGZy?=
 =?utf-8?B?UVNnRjhiOUVEdWpOTXRLTTUvVGUvWWk0R1QwYmVlc1V3WFBRbnpHcXVGWm5i?=
 =?utf-8?B?cklld3F1T1RsUWdqTWpTMmQ0OGRnbmxLdmZET01KcjJYWXNPU3V2a3A4YURN?=
 =?utf-8?B?N0FNSkgwcnJNMTBkRDZqVUhVcVhTN0ZyRGI3OWtTMnpwRy9qdjNoSHhJNGlI?=
 =?utf-8?B?YSt5LzdjZHBMUTJOc29VYlRURktIUFNocnNIVUk0VGdwMmRZdytGMVUxS3Q1?=
 =?utf-8?B?THFKY3lHTE90VjB4azQ2RlhuREpGZlhjVGZLclFocGNTZWFiNm5JcXpyYk9K?=
 =?utf-8?B?bFlHN2Q5NnQvNm9pcHJVMDRHcGE4TTI1V2E0bnFVWkNsenA3UFhxVVgyZWJM?=
 =?utf-8?B?elM5azFOWHY5V0RqeUxkV25sL29FRTBZM21ZaTkxRndHN0s2L0c3eEJLZHFa?=
 =?utf-8?B?bjJsUmdRY2Y2eUNKNG96RFFkM0hKSDJFYlNYa3MzZUVVY2c2MnlkQW9IVmxS?=
 =?utf-8?B?SGErZE9EN2pVdmtPQXJCRVh4UDVwK1RCdE8xejZRa3d6MTE5WS9ic1dBNWd5?=
 =?utf-8?B?LzI3SWpsemRRajhjVklqY0t1a2xiNmRjTERTMDNveHcyeFdvcnZvclFKbXZq?=
 =?utf-8?B?aUZFYVRubWRRSFVBRDBvUHBxa2RMSzBLempIMjVlZ2NqQmRBcTZraEZqbGtG?=
 =?utf-8?B?SVFISFhuMmhieUdSZHNMcTFFVm5ZVVVqdCtHVjBIM0RhS2dpNXl0a0NxcUVT?=
 =?utf-8?B?cUE9PQ==?=
X-OriginatorOrg: randorisec.fr
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7cd0ae-4933-460a-bbba-08da5c54923b
X-MS-Exchange-CrossTenant-AuthSource: MR1P264MB4211.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2022 17:59:12.7524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c1031ca0-4b69-4e1b-9ecb-9b3dcf99bc61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P1uM1VtnN4G0yoSmyHlMaVqJbvuTl6KPCopcvyVnpMRnggMYfx4Yl8FEsuzYsLxkYeLkbRcyDSYwGg2Wy6IBPiOco7xUaeNMJ2b3zGc+aGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRZP264MB2523
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From d91007a18140e02a1f12c9627058a019fe55b8e6 Mon Sep 17 00:00:00 2001
From: Arthur Mongodin <amongodin@randorisec.fr>
Date: Sat, 2 Jul 2022 17:11:48 +0200
Subject: [PATCH v1] netfilter: nf_tables: fix nft_set_elem_init heap buffer
 overflow

The length used for the memcpy in nft_set_elem_init may exceed the bound
of the allocated object due to a weak check in nft_setelem_parse_data.
As a user can add an element with a data type NFT_DATA_VERDICT to a set
with a data type different of NFT_DATA_VERDICT, then the comparison on the
data type of the element allows to avoid the comparaison on the data length
This fix forces the length comparison in nft_setelem_parse_data by removing
the check for NFT_DATA_VERDICT type.

====

BUG: KASAN: slab-out-of-bounds in nft_set_elem_init+0x158/0x1f0
Write of size 64 at addr ffff888007f717b0 by task poc/264

Call Trace:
 <TASK>
 dump_stack_lvl+0x3a/0x4c
 print_report.cold+0x5e/0x5e7
 ? nft_set_elem_init+0x158/0x1f0
 kasan_report+0xaa/0x120
 ? nft_set_elem_init+0x158/0x1f0
 kasan_check_range+0x160/0x1c0
 memcpy+0x3b/0x60
 nft_set_elem_init+0x158/0x1f0
 ...

Allocated by task 264:
 kasan_save_stack+0x26/0x50
 __kasan_kmalloc+0x95/0xc0
 __kmalloc+0x29a/0x4d0
 nft_set_elem_init+0x68/0x1f0
 ...

Fixes: fdb9c405e35b ("netfilter: nf_tables: allow up to 64 bytes in the set element data area")
Signed-off-by: Arthur Mongodin <amongodin@randorisec.fr>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 51144fc66889..07845f211f3e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5219,7 +5219,7 @@ static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		return err;
 
-	if (desc->type != NFT_DATA_VERDICT && desc->len != set->dlen) {
+	if (desc->len != set->dlen) {
 		nft_data_release(data, desc->type);
 		return -EINVAL;
 	}
-- 
2.36.1
