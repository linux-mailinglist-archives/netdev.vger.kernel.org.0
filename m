Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C5B6E7A21
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbjDSMyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233303AbjDSMx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:53:59 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2112.outbound.protection.outlook.com [40.107.102.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E1AAD30
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 05:53:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdXdr8DrPEio0u5QY9SuOxucG3bxXJgs9RcMU+4o9ppx7/8YpPCDPyzABJbljDZWvu1kORspVSi4rw/krNcRDOPPdQX3xQ1QVTDIARsfGrxnFbVP7/xeBYRjOr4hhCZgnmo0ioOIvTI8ul4C/Nl5D1ATSoSXhvI3Jwugwu+a+5Q/qgnsHI8ddgUMcvRl9gRGTvkIuEx8nxppLgI0kYIwtk9RwynFvRj9qVItXbBV7nREitW4bqaXpHhsR0+0fWIJniD7KAp8YqLeu0+OrIGjUgwdTEmnPhtXYOkGGMWzDSOR/R3w1rAH0nMFFj+4Qsnf4neu5LL0K+EGeRXmJHBI2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=otp5DzxKRIa/v0Fjv6d/S01/h35omErZumRKyhOEr+0=;
 b=GSWrXdgzIAPcyZRcwqpA275CE14S0v0Ya6/DAiguJ+x7AWB2EDHyGiuEgmVcQyl3i6jPwpieQjiNmzurQVIpMuTUFrrkijmYnh8PZWzaxXv98L/CmYBCOnRET33NpEFH1pOZ+kB50Bd4PEacNLY0VMKKlFB5AJewHbwSjaCpBNo9gHZwmitSlFgQmCri6L3pSODKmGgUHo3uNxfziP+wKdpxqvknW1JtdgXxAO33ezDA/U42KGHywuny9SFs0WwzPsjRTHSVk8nUusklekshbVWavhJ1f/JfdMTeVqD/Y0MfcbwI/pvlYhPxNVX+K8oXCcRY87mm4gq0tS+9flRPuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=otp5DzxKRIa/v0Fjv6d/S01/h35omErZumRKyhOEr+0=;
 b=fc42t0IJ6iT1pS38deIyV0diTQ8n2M36NJYJhexS5WyDvCZumb7tkAZMvMxMLBukZdOqM3S240u64V6mphjkO0bpwVzF4WzIcXU4Dmy9AxgfeqXuvy8I4fafN7ZEin6aBQEGke1N5psnLNCHQJxbt0pNA3LlT0QoZtdJySkAboo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5375.namprd13.prod.outlook.com (2603:10b6:806:20e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Wed, 19 Apr
 2023 12:53:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 12:53:55 +0000
Date:   Wed, 19 Apr 2023 14:53:50 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v2 3/4] net/sched: sch_qfq: refactor parsing of
 netlink parameters
Message-ID: <ZD/kXkvqB9ovOFqk@corigine.com>
References: <20230417171218.333567-1-pctammela@mojatatu.com>
 <20230417171218.333567-4-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417171218.333567-4-pctammela@mojatatu.com>
X-ClientProxiedBy: AS4P250CA0017.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5375:EE_
X-MS-Office365-Filtering-Correlation-Id: 0644b744-51d8-4f79-df28-08db40d52289
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5sNPtWuofuKJE5NdHKYzg0WVfR4KRX0tOJz5eNqgzT355aEyuR1JsWO89Nu7dsVsnRYAhnxInyfeokBSqy8F6FZjQEjBRRS6A/gSnHQULqar72bBic/EqqlGnQMWZGtWgQiaE2MCHq1/+3hwJUDVG8NNVRp+JZdyj4/nOEqGVxuB0C+DKLvI/3ahkPVhXSTu9z2QekCXmDks0r7a6Yey36beCiUU/iz0r9njAwqaa0yWzWx2bSygs2WTG7S+G19aXUCyUvDW3vPGFoVLs6iVb1QREKT0bJ+IhPDZEBGPFHmwOBXBN+eS9aBauKvBuwyxJ8S6noLTQk9GUKoG3fW9qcPCsoPkOdpadyabW62aIcPojfjRubp6G7RuLBHoQjoTLwtXH22END32+9TNAltqefgse0K98xOqkizAoNf3+1ZdppCo5r8LaOz7KlFgtt71Fs5Fi1Z7GRpW9cbnKYzkvzBvGt5P2nGdUBsakAq2/pUgzrXCRIDMQjl7Tlrl0XsNEox3Lqi4dZrLooZbG7JVOxTawJsdqHieGJ8A/oF0mZDQ07UWG++vR5MIhdkihh3y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39840400004)(136003)(346002)(396003)(366004)(451199021)(6506007)(6512007)(478600001)(186003)(6666004)(86362001)(83380400001)(2616005)(6486002)(66476007)(66556008)(8676002)(66946007)(6916009)(41300700001)(2906002)(44832011)(316002)(8936002)(38100700002)(4326008)(36756003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r7UKbSQbsESngNlegbRUZ0wPk6Scqyz4Q+XYlRUezCLCaA2ma/vowelt/eRH?=
 =?us-ascii?Q?qyacvwWs1KMGjreRycglzvNt2b6Jz/Ojk2CMOmDKEUtNcZ31p1vWNi4j1qrX?=
 =?us-ascii?Q?3ddNQTiJRcikB9WlofT9sjF41DbSHgnySsyvzU2yOL/qzvo+7/1xIdwQi0qh?=
 =?us-ascii?Q?Wrf1/n1p9GNkr1BJxW2tn2ZYW/dC6LtK19fLTMeCLHU66IRPCgwwAyrZCF1O?=
 =?us-ascii?Q?Uj52VutAyhoQy8AF/km27xbAdec4RPdzWvZjb1DDQHaxTvcEZqzr55vZ4SfU?=
 =?us-ascii?Q?An/3OmpQk9UWFexGyEIfJGHQvGuxkWp0R8lUnpA7v0/fJeRebc+OVF/uwFOe?=
 =?us-ascii?Q?Kb7tgojkjJ6JBbehU09HoT12jN2hanSs9hI8Mcdh1+JD01bbnnRGUcdKthHQ?=
 =?us-ascii?Q?v1BMmn57UsSBPcSTlpdxMAgM7IeQcDNWr0QmpHCfURTffFCbl4a/+sT/wNOa?=
 =?us-ascii?Q?5DaKIP331mC2Cp9V732ufIFjOmkh5hM0NeZ0ruQHZrsKUsvAPyso1AsQeZtn?=
 =?us-ascii?Q?Ct9ptgOzc3wEwh4Br/bm6dJrsRC6bM3ztz4fzKUBr1H8s9piNxLiX3pAVLWW?=
 =?us-ascii?Q?pjTkJexO4CUqWGSKarZezo5M2yoJ/hllDmNhKCZM51cYlF/CJSLcsiI8l7g1?=
 =?us-ascii?Q?HXcadyiAMpDpv1UVdusplya80QyCDQQNH6bGQ1wWUTEhbxz6kQuCf2REGXVm?=
 =?us-ascii?Q?xQsxbHSXXR9NnkJQXFftBdQ1haBEOZ0Cyng2dcrJjqhVPMwoTRKHeSVpWFtt?=
 =?us-ascii?Q?PKd5Zk1TixuBPuY+qwqMRq04kZYL+kvs/NT00W2KLOJEC/d4qaond50e+tF5?=
 =?us-ascii?Q?Nwwm9BL3gex28Vp8H7qtb57WoGn3ilJ74dMnLoxxKrFiLKo6K6ecysK5CUc5?=
 =?us-ascii?Q?VWjfWrXbiQNyf/u6czxTYIpwj+YqSjO4VxxFlYtbC15/AZwXNoN90Ecpj7vO?=
 =?us-ascii?Q?lXObDIPx5ChnZ2ksEYrlgqAPx4VL1KtgPUMT/dfwP/wVZYEvarXNOsJB/09e?=
 =?us-ascii?Q?SBx+iE2V/AnPY+tg1ragh8n1GV1wdU393b9PwqgLMZmRtm3vGt1y0AB6vB6F?=
 =?us-ascii?Q?csia0hF8LAfi4ueg61cyiUr4D0ZEq8YhBW3nJq/ObbBoP8aR6iV8P7gvISEg?=
 =?us-ascii?Q?a65IISJXUHc93LmxJlD7LfW05KQBnjJG8qFUSpAEV0WbnY1zvJI0tyTZLp8X?=
 =?us-ascii?Q?oycxlPjhUPgEoU6sDEwuRMrJk3EHCOQRWLCcg7cvElUVlU4zqYdglbUxeNo5?=
 =?us-ascii?Q?dk8ugXVXRi8wh8bY97jRQWysoWplczTrXxwcTi4yiHzLlueja4R1fBsRAA8x?=
 =?us-ascii?Q?jZcUEgwqzdcptbg5idMXT67c7WJFGoK6YC+U3GIBkIsmFtqTNU+zlW5D6Mdp?=
 =?us-ascii?Q?QSqXU+4/12poaP2QZiKiCVvvMZ+tTTJh/HOkIuzSL+zk1m3A5Fzphx5iwPha?=
 =?us-ascii?Q?g95yxm0N5jBIRBwyIgLjSY8/F3aZ89QxWkSTc8WJV2d5zyC/ituwgsY3ElvK?=
 =?us-ascii?Q?LLh768aF+T9MqxOQOn/HI55KZrco/CSqkgme9z+M4DM/ioIkSVZ/a85hHtgz?=
 =?us-ascii?Q?MF3BocWxtfFDMRhjPIgkS0krR2W3Z76ZtxkRoh2ahywSH2YKO8HihrIrNzAH?=
 =?us-ascii?Q?Sz4YmvuTo9aPGhad5ImZAkQHZ6A/K3UcWRvvPnJFiWsM+HIspWfX6l+6aJsf?=
 =?us-ascii?Q?JjDeDA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0644b744-51d8-4f79-df28-08db40d52289
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 12:53:55.6619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3vUvFQ5BJ1aIoPPG/wyXlQ3WCtRiUq7pGYAWssXGGlTdZEm+mZk2170ZLti2JXcKBHRg4WbNfY52s1rLM+IKkZm/GDvsHdmH2e9MUshmi+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5375
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 02:12:17PM -0300, Pedro Tammela wrote:
> Two parameters can be transformed into netlink policies and
> validated while parsing the netlink message.
> 
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  net/sched/sch_qfq.c | 28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
> index 323609cfbc67..151102ac8cce 100644
> --- a/net/sched/sch_qfq.c
> +++ b/net/sched/sch_qfq.c
> @@ -214,9 +214,15 @@ static struct qfq_class *qfq_find_class(struct Qdisc *sch, u32 classid)
>  	return container_of(clc, struct qfq_class, common);
>  }
>  
> +static struct netlink_range_validation lmax_range = {
> +	.min = QFQ_MIN_LMAX,
> +	.max = (1UL << QFQ_MTU_SHIFT),
> +};
> +
>  static const struct nla_policy qfq_policy[TCA_QFQ_MAX + 1] = {
> -	[TCA_QFQ_WEIGHT] = { .type = NLA_U32 },
> -	[TCA_QFQ_LMAX] = { .type = NLA_U32 },
> +	[TCA_QFQ_WEIGHT] =
> +		NLA_POLICY_RANGE(NLA_U32, 1, (1UL << QFQ_MAX_WSHIFT)),
> +	[TCA_QFQ_LMAX] = NLA_POLICY_FULL_RANGE(NLA_U32, &lmax_range),
>  };

Maybe someday we can teach this file about the BIT macro.

...
