Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96F06F1EB9
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 21:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346272AbjD1TY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 15:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346225AbjD1TYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 15:24:54 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2090.outbound.protection.outlook.com [40.107.244.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C34B3AB9;
        Fri, 28 Apr 2023 12:24:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5CtVE/TraSNawBxx4U4qW2fQHEGECSY8i4qqg2T76IqHCO/fskFUn1a41UNjG/k2jdJP0TPvTUv/PPIlDeSZ4ZWf4TccZ9Ihf6z5a2QIcHeq2lDpxCc9zJcC6rdmSISz87UgW2P1P8laYD6h0fZtSkrs7BnnhjAP0NJie/91sd68UntdPesWsyvYcLnQXLKJCHoIPlW6kwVe4rZr/TVWS0MTq0sA9xA4EKiAUeiW530ecHLS3f9BjfgMUbU0Vk/6ewsuGOrme0tIo02GYq7GhVOuRZ7nj5Cn1eKsfKsH1MntQVU3moRagNEft4OMFPcRpRDlBxfTBIx24BT3vbGQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tR2Dk7H+5UxhwowA9bgOr3SwcdZcUnjJuVHXobsno1U=;
 b=UjLrtLQrz2/00QniyxjHGuCcMIkxgUeVP0b/3BoA3mRgYX5md+h9YED01j45zTMAvi4fTjbl8eKlNoX8uWlFe77qf7HBJydxbAsQOlfj59qsGzk0bo1eGwjx2hs5WVBMVIpFH+sEBGuEDfRX21Z/RjONGC0H7oQMQCrspPWmMDwNZr8MA78uHvqbh4bdQJ/OWCzUFkKdHSmNptyyFF1ZA6NpTabFrnfslDmzT3ZJoRR48CRbKqaHdLomAtqtM01ExpEx8kmfV1AaBzZgWOU/Ahlh0HBaAK/fsQu2YglJN50401GfpuEOibkRT2c7DomsMmlCWQ3GZetcfjrNiyeRag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tR2Dk7H+5UxhwowA9bgOr3SwcdZcUnjJuVHXobsno1U=;
 b=ZlpktdyK7x8jVB9+3WQiNau5xACSrUKVdrIJB6KXciqm/w3QhdcWmevDwUJc7SqICRdb5pNrXJxyypKaPzjKuQ8el8iGrK6H8fiHtxbYX8orT4BvLJ80z/GsSsprrZC+4y8Q5H0MDEhl9cBswpimzXFGYaGY7I1jkecJYUNPHTA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA3PR13MB6418.namprd13.prod.outlook.com (2603:10b6:806:396::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.9; Fri, 28 Apr
 2023 19:24:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 19:24:49 +0000
Date:   Fri, 28 Apr 2023 21:24:39 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Patrick McHardy <kaber@trash.net>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix the
 ct_sip_parse_numerical_param() return value.
Message-ID: <ZEwdd7Xj4fQtCXoe@corigine.com>
References: <20230426150414.2768070-1-Ilia.Gavrilov@infotecs.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230426150414.2768070-1-Ilia.Gavrilov@infotecs.ru>
X-ClientProxiedBy: AM0PR04CA0095.eurprd04.prod.outlook.com
 (2603:10a6:208:be::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA3PR13MB6418:EE_
X-MS-Office365-Filtering-Correlation-Id: 371f941e-72de-4cff-bbe2-08db481e3b59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IHUgkb3Bx/jUEOoQnfBdhHRWEtw7BZbVQCe+7DBXg06CLnq9BZg19pGe2zng8afNGH1gTkRVsWMTXJLe9j0pD++HHSZteQYwM6bobTT/621KSgny6GiBdZSPkgh3oP1OETsy8giVtexCM1zCUz0q5lteEDVpGdu/jK4URmUhgOyLLynOsLE5soI0bs/nOfskKXS8tljYthOj4zTefF1Ix/W07pVANM7vrn8cuxCYmeatqCWUyoEBZpqspe9HuxKjKDUkdF7Y/S+QLf19EKHaj3yJHpmX9FuooEld27/D72A15Vrg8ep4bet4ffRQ9D94U+a2yrLceYdDGnqN0fjYHAbGom5XZq9/fbQ4a7y99Dr9RGsQiwedE2Szrz1s5+6D4eIdG0NMcfdk87pE0ehGEbk2VxC9dmS1Z/klNhXwfo70bnjb2QitcTa6AGgWOyKaVpeeRVxCiESvebHHk4k8P0sIOXb68XUId+WKfZv1M7KXaqpfxLifKyC/FQaVJfVUG6RAIDBWnQUEP6DQ+6bNPVIxhMpDSQDxMyFq17+DgA213ybnQx5BZEjkeHhnwbfMSPyyqnTnRAhrkSXltq5Tt9MSYry9GXidDmZCogp7BL8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(396003)(346002)(39840400004)(136003)(451199021)(66556008)(66946007)(2906002)(4326008)(44832011)(2616005)(86362001)(5660300002)(7416002)(8676002)(8936002)(36756003)(66476007)(6916009)(41300700001)(6486002)(54906003)(316002)(478600001)(6666004)(6512007)(83380400001)(186003)(6506007)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RvOcqDhksF6bD310/OsT2hqcX4JZlnOJ2aAZnntlbWZuvOBEbBpA5+hz76nk?=
 =?us-ascii?Q?BgW2cTL1ZlS1TuozWac+YRqJqDzn5QUBPj8gM3weAujbq0gO3pFXN+BfnEzz?=
 =?us-ascii?Q?EjGGVNOHt7Czf2XQ3/vnxMioGYAWxT9eqZGbEHVf0QLTSrxwnYqBdc9C+8te?=
 =?us-ascii?Q?lx9eIx+yzxcYJB2pwO14O8WoB/jAwtCOXj/dKGIICz/xZEyMw9P07T5QWJTe?=
 =?us-ascii?Q?8OpidBotXHSNp6SbqG+jxwLNdHqmVbfozq0scIecdY7mmNP3b6HG2uSnMHoY?=
 =?us-ascii?Q?Nd0MAKU33sdpqzRomnT/CJrA2BFEFY/cTDRZ4nNj/oK9ZMsKWWLuYHHqt7aA?=
 =?us-ascii?Q?7GkN2AFt4+pEvou1jq/mw9FtD445EcYVoasfoYvyzLY8s+qIZnkIMh2zyDGZ?=
 =?us-ascii?Q?d5kXvso6UDjXFwlV62FJGT6IWZXFxObnfN7gqyBoLxgKoXVuD93N5SxNaFsl?=
 =?us-ascii?Q?TvfoDSGYkOWyIdOI+A8GvMiPR2vEVh9TZO2EE6zxiHV6FHdlpXu52bEE1aRd?=
 =?us-ascii?Q?tnG7SpJ+XlwwLHQQfkFuwA+7vU40Woj05KaeK2eFzf8Rb1SBVVfbJNNTFd77?=
 =?us-ascii?Q?8Aj81SVOuWRePt5cfou6CEW79cJ27xa5K03+fZ+ivC1/BGXL97l77phq7aZX?=
 =?us-ascii?Q?m6MSYzWucwpTaQh8vJTI/t0qOHbfMlEIJO1ZXrkpEh2CeTJGAYdSDTv3YjbU?=
 =?us-ascii?Q?HemXbs1h/qrIbym9w8L7s/RuZGu3lyfXo7DCXJrzSEsTDkcaxdaa2glQnH26?=
 =?us-ascii?Q?JzoXmnYvUSKEnJvz/I9Q6oNKAIFSrbHrvQmu8UpIp7j0C3SWjMx4tcfcL13o?=
 =?us-ascii?Q?0wABybs8FAzZr3EQk7N23iD+8rXSTvCv20RG0GxzsaNqvo/NGH6accZUnWVd?=
 =?us-ascii?Q?KeZVhIfOjsU2mkHT5BXq6PhzBTRNV26GDzG/CCieGDYcC6aVZsoQIjTeL+7s?=
 =?us-ascii?Q?s2VJ0jHwUzvQ0NlSR1qMAlmgM4xT11IHNF5SaYXg8E6kr8yV3lFip4PDAihE?=
 =?us-ascii?Q?W9pTzEwaHXi/vh4G7jSL0MyySlrjLvUjSkpvBbm9UMJiqs+fyVQW3vqPOENJ?=
 =?us-ascii?Q?OZBZ3kg89cTg9T+IbCy8hfHr22JRfDm3Hk+32oK+MjX4QOd+LqP58eSOAx2/?=
 =?us-ascii?Q?5jgFIUklzAhCQ+DF6VKBAxvk/rr/RvMz4LkKhcBfcE07hXspRg7dTzZUqJxw?=
 =?us-ascii?Q?iQ4+GHDBvlesDijmpeREr6HFYTJe8N6V9LwVXkcdDZONHMP1a9TF6ZBXBkTd?=
 =?us-ascii?Q?bNCRMjWDXxk7AaiDxtt0hyvxIe0Syiw9LurED6vNmp4TcHAtI0M/0SOlSD0e?=
 =?us-ascii?Q?Y0qqFbHJokaxgMJn9djxU42QC/0OwutGlhSmRrTWX553P7ePjyxEEJfchaKL?=
 =?us-ascii?Q?kEZs4x0SGS+LLPZyi/nDSAHhK8tz4F9/r/iReHIc9PlojQyCGdVP1qUyZXmb?=
 =?us-ascii?Q?vwE+uvQc/1jt1fxWmJ7q5Fg2FetahjGl1HDpDOnsqjPBI/bvfWv2l9fm0Eq4?=
 =?us-ascii?Q?Keiqw0LyZ1/jLskf+KdIo1xxtSbG5dY+CJefT+PrKvcRunixrNcEdOlHR/ol?=
 =?us-ascii?Q?+U2LsN8179mKva8mqvBRxl3eilKhxX0RjYme082UI1cjT8sDzCoKc2wS9gVd?=
 =?us-ascii?Q?SC5dIqfYukCW35j17CdL5f3XpKi7tYw87NMNbEvstw3IdS8W9PqfJS8eEMlV?=
 =?us-ascii?Q?ZnEOzQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 371f941e-72de-4cff-bbe2-08db481e3b59
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 19:24:49.2241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iNGnYCYKTLlddR7YXv+47dCNmC3YV08ie8x+TkbmHEkvNpaGgFv9DfYsxb9BQLg9+kDD2K96f55W+QrAie+5WT2/S+4i1tJG9h9iuiauD5w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR13MB6418
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 03:04:31PM +0000, Gavrilov Ilia wrote:
> ct_sip_parse_numerical_param() returns only 0 or 1 now.
> But process_register_request() and process_register_response() imply
> checking for a negative value if parsing of a numerical header parameter
> failed. Let's fix it.
> 
> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
> 
> Fixes: 0f32a40fc91a ("[NETFILTER]: nf_conntrack_sip: create signalling expectations")
> Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>

Hi Gavrilov,

although it is a slightly unusual convention for kernel code,
I believe the intention is that this function returns 0 when
it fails (to parse) and 1 on success. So I think that part is fine.

What seems a bit broken is the way that callers use the return value.

1. The call in process_register_response() looks like this:

	ret = ct_sip_parse_numerical_param(...)
	if (ret < 0) {
		nf_ct_helper_log(skb, ct, "cannot parse expires");
		return NF_DROP;
	}

    But ret can only be 0 or 1, so the error handling is never inoked,
    and a failure to parse is ignored. I guess failure doesn't occur in
    practice.

    I suspect this should be:

	ret = ct_sip_parse_numerical_param(...)
	if (!ret) {
		nf_ct_helper_log(skb, ct, "cannot parse expires");
		return NF_DROP;
	}

2. The callprocess_register_request() looks like this:

        if (ct_sip_parse_numerical_param(...)) {
                nf_ct_helper_log(skb, ct, "cannot parse expires");
                return NF_DROP;
        }

   But this seems to treat success as an error and vice versa.

        if (!ct_sip_parse_numerical_param(...)) {
                nf_ct_helper_log(skb, ct, "cannot parse expires");
                return NF_DROP;
        }

  Or, better:

        ret = ct_sip_parse_numerical_param(...);
	if (!ret) {
		...
	}


3. The invocation in nf_nat_sip() looks like this:

	if (ct_sip_parse_numerical_param(...) > 0 &&
	    ...)
	    ...

   This seems correct to me.

> ---
>  net/netfilter/nf_conntrack_sip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
> index 77f5e82d8e3f..d0eac27f6ba0 100644
> --- a/net/netfilter/nf_conntrack_sip.c
> +++ b/net/netfilter/nf_conntrack_sip.c
> @@ -611,7 +611,7 @@ int ct_sip_parse_numerical_param(const struct nf_conn *ct, const char *dptr,
>  	start += strlen(name);
>  	*val = simple_strtoul(start, &end, 0);
>  	if (start == end)
> -		return 0;
> +		return -1;
>  	if (matchoff && matchlen) {
>  		*matchoff = start - dptr;
>  		*matchlen = end - start;
> -- 
> 2.30.2
> 
