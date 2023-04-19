Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943CE6E7D12
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjDSOlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbjDSOlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:41:21 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2101.outbound.protection.outlook.com [40.107.94.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36FF7ED1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:41:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jqJZPGKXRh7IN6RE2ln/qib1Sne/VrBTygtivIsX9sR9gWaqWe64Y9TVZeHq1c3f3Lp21G10i9nXxJwcyV/UKphmAizxv7/a/HaOeZCXEK6A6K3kwG5OuHwrLm2lc8bs2xOvWCR9DAX5aoKxZ3J2QseNduChE4ga82gLXOKEZDH2dq6e15Y1I7B0dTdmkQfR6I78mo6C9sFwdUGup4w+wiK/HYkGH1nJ6N7pVjy4RMdKXzuRAUx2MigiLLUl4Rumm63yACVKte9xHBXqo/mGUX1pXWs3Vh6CNQJF6QDY9XgBchzfN+wYkCjpqc6/iuB3jtrlt0ulQUWRSgWlUfSC4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qt7S0xcnvgGe7/dlTDuBQg0J7FN/Bs0d/zl4f2OjT4Y=;
 b=n0yWSaemzhB3l+XxRZkZN6TKyxkczBccNu0OZdLioNix6vXWSriyBcPxtuD5u7C4/YpLr3oiWOKBqpe/am+oHLl3dY6qtj7pHQSo2YG72d94tWqVD6Sgo9pt5N3x78XxEKQ6OX7NaWKN4V2Hw0adGKKPw5F+2/7DVMUdEk2gY6UIRUSx5PiuPHc73NRZhjPBZI8Asm+aKdvASkRn4vaTEDj79L/RVee5+Qsd+s7uuZ1uCGgVAm9vVbIZrUuY+ib6tGKXwPItF3PRGIRjjU5FxJc/yPaWdJMnSiGVW75u9GzC29jukOZ0R8pqWM3DPh1i38MQR32X/jslX/OLKOHCcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qt7S0xcnvgGe7/dlTDuBQg0J7FN/Bs0d/zl4f2OjT4Y=;
 b=oc+bmDC2tMKskvuy5gaCDGMTo7ZL1A6n5N2b5FRdd8pKgTGUB59cEHWLvjhSSYUt1YNy3TQn4tNYnmbiN4hXfjqzhlJ6SE+M54MD9y+Vc8cW4AkLQQS1BTcBynF/yYe6YCQCYFuI9ZqdWMg6CtN4iTuGwSzOeMfXYyZWUY+NZRk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4467.namprd13.prod.outlook.com (2603:10b6:208:1c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Wed, 19 Apr
 2023 14:41:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 14:41:11 +0000
Date:   Wed, 19 Apr 2023 16:40:33 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Zahari Doychev <zahari.doychev@linux.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v3 2/3] net: flower: add support for matching
 cfm fields
Message-ID: <ZD/9YejX9YQsRwkH@corigine.com>
References: <20230417213233.525380-1-zahari.doychev@linux.com>
 <20230417213233.525380-3-zahari.doychev@linux.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417213233.525380-3-zahari.doychev@linux.com>
X-ClientProxiedBy: AM0PR02CA0175.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4467:EE_
X-MS-Office365-Filtering-Correlation-Id: 241f1bcb-8ce3-4d07-4531-08db40e41e52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v7yuP7GtMiu+gPt0pQ6qCtQd+JkKSrcedjnuffxV0YyGH6eg8wpoVycv40gezDauCGfWJfgRuC39bDvAJF1Set8g11JBdo82K0oMD/ukiq6svktxiJqRdX8aH8v61qFLjALuMw8KCwkEEbC5OtatQYNuVfr7QsR5mqCxsnPuo+TFFBVftV0J7gT1ZhhUz60abHdbDvk4kMGMTwWWE+wfID5uR3ndAooQ+ZpLFe4wo2uflnBSzvDVU4/n1HuSs5qJJ8Ao8NMX8UPW0UD5V1r8gSRk3GKHUn3BPBROXu8A5RPCylI34TpOfVdyVN3sr7IABpUt6+MEzD1TSzDjxEN/ZLgM4gQlsw4JYTm6j0DRqAdZm96V4yTEeYteVnmCA8W+/DiY58lM2KffyxHqiq0gJzgK37mbhlVbenRmTwXmAKO76tZ31PeWle27q6XgnE4DkX8xmbxw/9pqYZGHCh1EqrBL8Ezko6fDnoJ2gWcK7a7aMoNWUk9j7JjZaj9hqSQCdFlP/Jal5Ft+3S6WdMAzd50GK0O7wNNdiAaKz67iSITLvYU9XP9DEWewvSGTt6Ewr6/r3DZUzvRSh54uL1uXdj3LfSvQZ7ncVmAIDFzSF2k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(376002)(39830400003)(366004)(451199021)(2616005)(186003)(36756003)(478600001)(2906002)(44832011)(7416002)(6486002)(6666004)(6916009)(4326008)(66946007)(66556008)(66476007)(8676002)(8936002)(38100700002)(316002)(5660300002)(41300700001)(6512007)(6506007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/3fUwuJGt0xZlo22V9nrwdQUa3cd3WYWFPMoNSrY1WIiLd247W3ovbRAjcSZ?=
 =?us-ascii?Q?tZt/I0Px+6uVPMG3iB0WNGNCR9MRWBdn51u0QtRQAhLwdd3IO53jEP1cAOSh?=
 =?us-ascii?Q?Ug2A0oKzwb0JfdH/FTwo3FvKjMF/azDvlsgP8LCn13lI/f7EemvRsZIrx90j?=
 =?us-ascii?Q?75eVvHZGYfUy8lpcfIxLp3HZP7GZdT2hzCAQMcKmh8GZ59R0HlhaUbeQw2D9?=
 =?us-ascii?Q?09Q3khpdX7moeIhG1adlziBN6lk790YvocHM3/Zg1EKhmYyJ3PlgGSlKR5+q?=
 =?us-ascii?Q?55Lv4U2iFrInTtT1Ezd16pQRFCY2AFw/8KAoDUQhAbpBEgueD9hNckhn8Pxc?=
 =?us-ascii?Q?ERsPEMuoHruBLF3s+tuiGtluGLK4DK5Pu42gK19qySk02SZaatJ4Z3+V9kGT?=
 =?us-ascii?Q?aqmbzExt+1qLLdH4leqmbR7a0RAuGK13zUKmertRHJ+8ClF0yONcpG0ExMoY?=
 =?us-ascii?Q?tmjVwLcbdlU1yenV5ZUbm5kYOC+ZDPeXDPh95y0c6nUKN+CVs6KaPjaoXx3B?=
 =?us-ascii?Q?nOpD5ffn25UlBas6LfkBSxbrdHxcnOHWW3cHxdc0AxnIRSVzX6JLfv9QcCeT?=
 =?us-ascii?Q?KoyifSNQmYuLNUdiJEcUg/B0F5uhRWyejdfxKbfEI01ZtzfEsSjZU2b/pPj9?=
 =?us-ascii?Q?VoSECzSafQhH3o65u8WXSKtx/6ils88y7YDSYyrIqy8aDX6becCe35sdfL2g?=
 =?us-ascii?Q?AtzkaJoUwPgyPKQi70oKyNb1odDIk9XqauzRcpfDaRCdFEJcdAuTfXf7TZNv?=
 =?us-ascii?Q?WXt0gPC65vRXtAAz8xfagtmLpGSkPsS1xKYTTe14BKVwyp1VjKzk5CdG0u2A?=
 =?us-ascii?Q?xU4M7AS2RK6jaPbSgAmNhR59XBGCMmekGqoMfrPd73uWh1Q7nQkVpikVdXee?=
 =?us-ascii?Q?OMw/iAwLLJbxOur13LZve1FGIS9+WdbPGKSVxX74H5xwb3ms5Jcy31LXQspF?=
 =?us-ascii?Q?+ns5kCEwVv8OCL8XpsQHPOynkQU/5K3bcIT4qamij2YpovXv+jNRKe/R1hxy?=
 =?us-ascii?Q?Ta7F19/exctPaEBoR5trlg97n0Rncu+Ye5lhDzz7fEI/eogpDNfET0BSVgZM?=
 =?us-ascii?Q?Dil/jMmo/IVklJhMfV7o44zXcrvC6iBQ9Xt0zNRo1Q0Yy7/SV1C4v/j2S1bj?=
 =?us-ascii?Q?/dSvQfLVqhIr/cGaGjDghImOK2QZyaoXdyqL/ngmUOwEs0i3uqK7BJ90uGU4?=
 =?us-ascii?Q?cE73Y5UJURNKmo9w4oE2s2eiGkIdb8ZUYrZN7X6BpI5ufrhEMS5TVqzAHWaK?=
 =?us-ascii?Q?2SCvFmQ8jh2UEyU4VgwOVIg2uMwUDD+pD1JI6HWVumgHoOs6Mk3bbIsd83tv?=
 =?us-ascii?Q?abUXsGUlb+0OSgX6i2PZHIBVT14LDi7P8xfpxrjVlg4KHqPw7fzb1MKSxAX3?=
 =?us-ascii?Q?3mxwF2d4lCYz+2/3H8BDcwA1FL/2qULv2Fsf3EysN1RBXDt+HqnyGOwPwiFR?=
 =?us-ascii?Q?1oyvWI0/Eqy/nPgy+2qu+BNxSr4lTqncTbJbmNv0CsyMcxwSS3RwO/6M2ZK7?=
 =?us-ascii?Q?4ZeJ2xyLHcxMt9zenq+UGdZAbMXpaDpMUHVhEYEhoA5ZsSXGzScFvQ5oWoip?=
 =?us-ascii?Q?mott1qweXgGDyWgNmVFIeiuamtGgALN0lYRA/vJSEw1bJa+BQ8vkGbRoeCTu?=
 =?us-ascii?Q?t0usg2iAvOnemXMvTj1AxTnHPqv2Xl6TOgCPa7kVneYt3ItksdrifEyTdd35?=
 =?us-ascii?Q?+eLQJQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 241f1bcb-8ce3-4d07-4531-08db40e41e52
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 14:41:11.1589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ge913MJms0VxIrtkaKgYpBJYnsthWrtGZbOFB7QYF5SlPFo13Cdr9oGy9toao6CuQgrSf3LJEEeVtSODXX3hdhZ2J7ASnyCjjzQuyPKdNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4467
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 11:32:32PM +0200, Zahari Doychev wrote:
> From: Zahari Doychev <zdoychev@maxlinear.com>
> 
> Add support to the tc flower classifier to match based on fields in CFM
> information elements like level and opcode.
> 
> tc filter add dev ens6 ingress protocol 802.1q \
> 	flower vlan_id 698 vlan_ethtype 0x8902 cfm mdl 5 op 46 \
> 	action drop
> 
> Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>

...

> +static int fl_dump_key_cfm(struct sk_buff *skb,
> +			   struct flow_dissector_key_cfm *key,
> +			   struct flow_dissector_key_cfm *mask)
> +{
> +	struct nlattr *opts;
> +	int err;
> +	u8 mdl;
> +
> +	if (!memchr_inv(mask, 0, sizeof(mask)))

Perhaps this should be sizeof(*mask)

With that fixed feel free to add,

Reviewed-by: Simon Horman <simon.horman@corigine.com>


> +		return 0;
> +
> +	opts = nla_nest_start(skb, TCA_FLOWER_KEY_CFM);
> +	if (!opts)
> +		return -EMSGSIZE;
> +
> +	if (FIELD_GET(FLOW_DIS_CFM_MDL_MASK, mask->mdl_ver)) {
> +		mdl = FIELD_GET(FLOW_DIS_CFM_MDL_MASK, key->mdl_ver);
> +		err = nla_put_u8(skb, TCA_FLOWER_KEY_CFM_MD_LEVEL, mdl);
> +		if (err)
> +			goto err_cfm_opts;
> +	}
> +
> +	if (mask->opcode) {
> +		err = nla_put_u8(skb, TCA_FLOWER_KEY_CFM_OPCODE, key->opcode);
> +		if (err)
> +			goto err_cfm_opts;
> +	}
> +
> +	nla_nest_end(skb, opts);
> +
> +	return 0;
> +
> +err_cfm_opts:
> +	nla_nest_cancel(skb, opts);
> +	return err;
> +}

...
