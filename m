Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42DEB6658D9
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 11:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbjAKKU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 05:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236139AbjAKKUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 05:20:03 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2100.outbound.protection.outlook.com [40.107.96.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CABCE2;
        Wed, 11 Jan 2023 02:19:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CaxOIkkLzwXo9vogIurPCWdKycCP+XJCB7jykWctnjKQ3GWXkUmrcNJB/6G3hxidUnmWvpE/gfHCxZZ1NZDLNlR4IUKNYtXKUElBdOyJAzArqTsGHyQ2Xg5KACCgECivoXTNAzwvIfBtfCQIM61UayiaV6Wnkn1CTcjYU/zfS1Q8t/3EQmc1SEjPRs/Us+th9oycZ2H7/I153QQuD6gFlsWdW233fP+n0k475PgEjCfl64/NCDIKvr84msY/w8gtQgJPtB6d2aH0+z5Snwo2hXDkHqxVLHRySG4z41chIhXmEM/8A8zKcQbDlty0q1DHeU8fnUJPh/1bHYS9sKqHBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AyRQPH0TU4et7uhKBSWBWlXAYSpTv1Jdjy3Kfuhp2Rk=;
 b=C7EKg0YojALha9UdAt0kBNIYrTRH223JUhKDg0QprwldpSAL4Drr6efqGGj6piPJBiy8NBDe+zK7ZQyc2Co29BDEeZljfcA0InMfbyiNv3i4TY/moGuZ5p/bTm1HmD2b/HNPlc70zJygPUWU17U/osljI6J1UCcIOSA29XvWjnm0irx9nnbpn+cnMfEXARP3O9cIWjX6TyCK/uejRhosE0GE3TDUUbokSDcRc2nlVuylHZVNHghcG4yQy3RhUtJs2wne9PQhyrQpSUb+h+SYPiPb3FWr5SFJaf0JBzBpnOk7kiPpNGirB/aja4yI3frnDDK2uOd2gQ66Jso3jXIYUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AyRQPH0TU4et7uhKBSWBWlXAYSpTv1Jdjy3Kfuhp2Rk=;
 b=ud/CDNGH+DLESKlX9xDeQKhPM2ajlku+7T0xw77wMvNqGtWa6uaAiU+0M00+UvKcT8QibgkDDDAUZrxU8qEDF+uSzTZEqJuU4oFbKsETA9kvadcPkdrMT96Ps/dNNog9Ac3N4VMozyqffPGrOY/kbGge9Ge5yklnzHSZxyWzNG4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5197.namprd13.prod.outlook.com (2603:10b6:408:154::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 11 Jan
 2023 10:19:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 10:19:55 +0000
Date:   Wed, 11 Jan 2023 11:19:47 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH] netfilter: ipset: Fix overflow before widen in the
 bitmap_ip_create() function.
Message-ID: <Y76NQ7tQVB7kE0dG@corigine.com>
References: <20230109115432.3001636-1-Ilia.Gavrilov@infotecs.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109115432.3001636-1-Ilia.Gavrilov@infotecs.ru>
X-ClientProxiedBy: AM3PR05CA0131.eurprd05.prod.outlook.com
 (2603:10a6:207:2::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5197:EE_
X-MS-Office365-Filtering-Correlation-Id: 5154c18d-8d38-47e1-aca3-08daf3bd6236
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tRq1h4zX7tvMB3aEYBFcu/qhGX62AL8+vfd3TLO8yyvaxRRJ/3AYqr2Ao5B1BsnQfxwXXjqWRGTmXyHowa+nUtgaFh7tU3Gqd4YHtlNYAcYU0jAXgXTDfNlPXYwes64pRvBPJKQZpQJgpNd6pjXUmn7fgCSQdV3mifrkTReWWSQSjw1FRc59K/x4qWe1hPX2db/s0LlpMtcD+KVpIy28S9XnD7hQDKl4UfZO4Z5Udyqlxm8etpoUJqSxRvWlp8ySxO1MAWYjMGlaSQ54Bpr7axqipIj4YadH2HpPQB5NiDBjdCQ7oC/ObwH7GX1j8qtJmfdo3qupL41qRzBWkZyjSxM8AHtvoTKB0OebPYyGMsAacpv5rIG2fbNSzB/jGUnWVinCCa3DJtvtvni177LzMmdoQY/+x+zTBK77AQsP0khyEwn2jX4KuWJQemvEidAXH+bWKlvmuEGbrFotqsyvaoE5+Pb7EGP8VjdaQ5KJjHH8PlaHidaPNUxj4steULvPienac/cpBEcKTYCcdPrXV8TqrrHBR8Abc+j74AjMCVmKJBywOB9pbr6DuDXXs8+fCqotoT0C+jJCDE+3CPNumAdIBfD3W6bt7yPL7Xew6r4Kv9NtedSk40c7ME346wPZKIc6iwde8JwfUZRwI6G/0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(39840400004)(366004)(376002)(451199015)(7416002)(6666004)(6506007)(2906002)(6512007)(8676002)(66476007)(66556008)(36756003)(5660300002)(8936002)(44832011)(83380400001)(6916009)(38100700002)(4326008)(41300700001)(478600001)(6486002)(186003)(66946007)(86362001)(316002)(2616005)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4CjDzTURuP6LJ0lxXFjsrTTxKLLYl6UHgM7JoBP0PkN+ck46r5GUmmOnQIHf?=
 =?us-ascii?Q?NVsqvuH2TlAtvgBP+rxpp7g+2hGp80n/4MRQnmhGnXsaqS/bIy/30ckCCB9F?=
 =?us-ascii?Q?FyNBF5Wc7JGaUDHMyIwC1bUImvz8DW2I0Nt+UMsif5crvjwWu1YyyHdUH0rW?=
 =?us-ascii?Q?n6tKeMPCpmUbZgs4a4j/zXJ7rhEfwqnfkgYt0Rs1gO8g+W+or4ofL+IQO7Wl?=
 =?us-ascii?Q?9VmZ5EhxmgLOtN7St5eNv1wNvkZdcF5KKCcpfSCQYNq9J3wUbbXKhXlkkaxE?=
 =?us-ascii?Q?ypsZCat5uRL3W6b5jWy6b9AT0BHSP1Qyz+4mxwQtynFEqxE4i4kDZVOfROMX?=
 =?us-ascii?Q?T/oiQflw+RGY+322HF0nLAoetSb5IY+eO2u5DoImj53GvJOdkBruapQhCvS3?=
 =?us-ascii?Q?iwha2loIslMM+5A1+avG3aK5wU9Px8X9NgJDvcVeq55qrhu/jh7DoXZXXecA?=
 =?us-ascii?Q?a2QGn0Ztnd1deCguO4ioqVH3IwO/OYU4G56M6xW31zl0O0wCGHaT0pcGd3Wv?=
 =?us-ascii?Q?41z+5fENf8y+Q1yBb1BCvv0gk6h09GyW3YBuBVoH9nhp5tuMzBOyN5eTCJ05?=
 =?us-ascii?Q?Z8eyfTQxn7oppSKGbp5ltKUXuqPJXxLPmfm6+IMyurtqOxbvKiuTHm1ORRlw?=
 =?us-ascii?Q?IZbl4Hp03SBwOdj4o49489jYYq4IAYjziNTeT7YuPNJfZWN5jNvPtcpQex4Z?=
 =?us-ascii?Q?hss0rkEpgc0X7xRdrKpVGrEesOCc7ET5LG1P1/gJdclhNKqMppu/E4jJI09E?=
 =?us-ascii?Q?L5T3tQNx9hTYGwfHKluRDozpSF0QJysjw0T8tnEmgCQodt9om3pT7XVqRh8B?=
 =?us-ascii?Q?0NWQq5vNeLqXZATu+U0SaaMqOkcsdq+fCDBtSmTe3rQP4EXGwedT25a1FARh?=
 =?us-ascii?Q?7aBrVBAiutwp3M6g/y5F5QyY9TxYblWbHxtQRciq/6cgjl8P84BbdBPIjIeT?=
 =?us-ascii?Q?bgzV6wkKRrUd8C42KKgxThDBTBfqaXzq7OVybFyXRp52A33cuMkjs0MWiovF?=
 =?us-ascii?Q?YNVekwiM7VuDdQt3/snOqUISmf0UahcpxEq3gioNDnm5EK6vhkpHILWR9lYW?=
 =?us-ascii?Q?VoQDZZmSEBRShjQZakQpsShBMDPVbaCkR14PTbdvYEsrgTRcn8W8kQpSV67f?=
 =?us-ascii?Q?1rL7S7FcSTDf1S9Z8jEzlGuYvb44QXtktFgMNksExrTvcCru8c9bk6g1DH99?=
 =?us-ascii?Q?oTws45UhgS472P/Px494I1NGwIsNf5v6cV9XyukOHbQk9k3jD+7Uguktl+Yx?=
 =?us-ascii?Q?acZoEq6SSb2JhYvSgvSPqidKtpU/nmyeoZbSDaa2PdPRAzL4RFwYJKvjgJI7?=
 =?us-ascii?Q?w5Tz3fi9xGdvYZvo/KvePUMH0E7tF+mrspPFVUMWw82VU+b4BgduAIxYEbC4?=
 =?us-ascii?Q?ayO4sjnbMucX6v3+zKEQ5tXAqYVkAfiw0urPE8AwxiR06PdomtsObAEQt6lx?=
 =?us-ascii?Q?1WU/DB2T0JOSmTU9PHWSQRb6H28srUtoQvW1qEV0M2zxJYNmxj8Evj4vK/lK?=
 =?us-ascii?Q?Y5Nn3s+iaUmzERjdfkhW7Hhq7Nwmk95SZdWdNf2AkWCzkzg8/AUjulR202p1?=
 =?us-ascii?Q?QffSh/D8c213PafxCd4C83TvYMETdUbqOerxLTidJhbLqHalSq1J0EaSdSdT?=
 =?us-ascii?Q?SOvm92N2KlT2Uj79CclYq8KLHmKuhkCkrN0s528Rz69PxIA1SGyAK2pc4izm?=
 =?us-ascii?Q?dVN10g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5154c18d-8d38-47e1-aca3-08daf3bd6236
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 10:19:55.0183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: shcwWUEYf/CxxRFaUy4ex+81NJJfIhe6R/v1EdtpflACVxTydkOo/ei3m76oYEBSC/OnTN0y0SqCHjCp2O7lzA5c9EtKae1rO3NkWaUwop0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5197
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gavrilov,

On Mon, Jan 09, 2023 at 11:54:02AM +0000, Gavrilov Ilia wrote:
> When first_ip is 0, last_ip is 0xFFFFFFF, and netmask is 31, the value of
> an arithmetic expression 2 << (netmask - mask_bits - 1) is subject
> to overflow due to a failure casting operands to a larger data type
> before performing the arithmetic.
> 
> Note that it's harmless since the value will be checked at the next step.

Do you mean 0xFFFFFFFF (8 rather than 8 'F's) ?
If so, I agree with this patch.

> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
> 
> Fixes: b9fed748185a ("netfilter: ipset: Check and reject crazy /0 input parameters")
> Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
> ---
>  net/netfilter/ipset/ip_set_bitmap_ip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
> index a8ce04a4bb72..b8f0fb37378f 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_ip.c
> +++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
> @@ -309,7 +309,7 @@ bitmap_ip_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
>  
>  		pr_debug("mask_bits %u, netmask %u\n", mask_bits, netmask);
>  		hosts = 2 << (32 - netmask - 1);

I think that hosts also overflows, in the case you have described.
Although it also doesn't matter for the same reason you state.
But from a correctness point of view perhaps it should also be addressed?

> -		elements = 2 << (netmask - mask_bits - 1);
> +		elements = 2UL << (netmask - mask_bits - 1);
>  	}
>  	if (elements > IPSET_BITMAP_MAX_RANGE + 1)
>  		return -IPSET_ERR_BITMAP_RANGE_SIZE;
> -- 
> 2.30.2
> 
