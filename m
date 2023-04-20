Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C036E8EAE
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 11:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbjDTJyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 05:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234286AbjDTJyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 05:54:35 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDF41739;
        Thu, 20 Apr 2023 02:54:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1kmBRLjfJeqA8t3qwxes6799V2TlhrAbVtSILiaFu0+CV08kkhfM8wsb6PaBBi0a+QVwS21aWq+cuanJv7AFlE2P3vCf5sIPQfpfbaQMOoAcS72sksHAQJD4FtJ6bSyW3QcCZC4A+kSuah05q7kycLmxYM2oGhCO6icgXE5qkEPMsK+OE7rVgHe8A+yX+iVUYxReMvQhBkub8XhyF/RqjXDjJdZnwgFtjydgbnqAlrDczUD4thQEipXKgRUbSYkh6LgRMoKKQ77qn0NXUw33D4XNAbX4ks3y6mGuwyDJOkhqsbPaFeF+cgZXZ9paotEeTt+6YelSSNvPzBKtUP2qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vTQxIG4klKpw+SXGgDzqVr1TF1h8BCyaSbGNO1KPlAQ=;
 b=gGHcE9XzoUjwzfwHvkYU3x9ERvDAUVHH8vdG+yIQ7SiAk6kA4bjEXmazKyubi7GjYutpOJ0OR7aa3I06hArx2qW5vBBMyc0O/dQj5z9H5YWz+0xXmyMeTDUkwmZLupP7F4h5+yE92VtoB3XWVDkgb4BLmCk2/7MX2V/Ovtw7HBWt/XUiKY5eDT95SRVxj5jO/OyLz3leNC3ZNwyHctPCo1040hYMqUSW7Nmo6EbuSZ2DiNwtFjPMRAIkjNvE9KKR2FaeBtu3Uijgie9jW9fK0jTGJlPJnRcwlN5czIKbaS7SErTFocGnhOZPpxiHHGktWGGjrYnjh+m0CSoCNDAfyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTQxIG4klKpw+SXGgDzqVr1TF1h8BCyaSbGNO1KPlAQ=;
 b=tNWdh13drwIXzvQm84SGw2jQKo3gXVCVVp4lFt7nVQp7zvZ01EtLxsuwcMPEAF0FjaHqWP5Mq9bYWu8m5YWog2vaRcyV0ri2P0Ia6ZMt8YucXpKI68Ms0Jy++GHu/kX18dubPX/iZfE3RHHnhZbMzVWqS6r4U2jqbUsv4bgXzu8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4922.namprd13.prod.outlook.com (2603:10b6:510:92::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 09:54:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 09:54:28 +0000
Date:   Thu, 20 Apr 2023 11:54:22 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, dxu@dxuuu.xyz, qde@naccy.de
Subject: Re: [PATCH bpf-next v3 3/6] netfilter: nfnetlink hook: dump bpf prog
 id
Message-ID: <ZEELzpNCnYJuZyod@corigine.com>
References: <20230418131038.18054-1-fw@strlen.de>
 <20230418131038.18054-4-fw@strlen.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418131038.18054-4-fw@strlen.de>
X-ClientProxiedBy: AS4P251CA0029.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4922:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c7fce5a-d145-4a54-d1e2-08db41853b23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qD5SC5GtJpxriQic95DEesEux6pzLniJqRCfKog7jYYR1Co9+2ba8YKdb645BxK9YXWy9xYXT6waHar/sYIF2qsGud1XdpLebFIqOjpaATVL5hW1GEMuZJcbnBsXdb/7+PzqVvTH1o/Q12LoJtcYk1MHBzD5WgHClEN3ZRFAi964n8y+s4sdQwmv2afoVFMGHJKMz8iPE39MJoKrG/8Y1cv20KsXZ9DBnsfflWI6/0DmenMipKb5wWMHKIjsYHYIuZAgVPA+XJ58GmMvl/xSVjWrzIDkY1Mx1twOsW4ohvB5M8gSYw5IzvbUim4esU13zBprXjoN+we/UQCcAWB2DQAeXG6ZWLhl8/7Kr97y60B1xm3rODdCHFdnuD7AjkkEgAWEkw3BfLhSXsgnJcs7c23sy1AM2LtngMM4YfvIPamQuXpbe48THS2uxfj2Klv1i2V6yWqf+Wb4TBNV4uIvkOYoxzNOZuKkkg5KsxegBOAlQjgRurQv8rpa3MAGoNu/fKtb/KKjS3NmzI5ITLlJZL+XJA9t0lUS+ihoY4wBUU/+9E+dtFY8Z18z8fW8jHV6QlV12ydJ4c3hCPvygH55XW336SjhU0tnpM+e3HuyHJk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(396003)(346002)(136003)(39840400004)(451199021)(66476007)(38100700002)(2906002)(8936002)(8676002)(86362001)(44832011)(5660300002)(36756003)(41300700001)(6486002)(6666004)(6512007)(6506007)(478600001)(2616005)(83380400001)(186003)(316002)(66946007)(66556008)(6916009)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2XtHG5u+a0FI7YX6usHw2da+g00YACCJThw8rBEXKr7RwEAXywq2y71s4kCH?=
 =?us-ascii?Q?yJtXGKrnGKX4oX6o2v+tZq1MVJKP4SZzPoJ2BldwYgCqc0Q4/jZsd1RQ6ZD3?=
 =?us-ascii?Q?YQAJF3fa9oOCmFcv7pqCZoXiE/SMYK8b/tlVgsjFIy25cNXiVxKk/F3wxhCU?=
 =?us-ascii?Q?2vGMDORwbVB8sMs2fNAVfhBu3z3Dyknga+y0Ed7Iz9hDeq9v6OPsnvDhjVQe?=
 =?us-ascii?Q?3/VCVVIZ+WXwx8Yx/XvZoML56NrAnHF/ASQjaekDSjSG5Rps7h/tYhMy7kgc?=
 =?us-ascii?Q?MnpYYEThbqxrAguKBt3Ci/TD1iT2wtCmgDYK5OX6jbNbqp4DoYy8ZJH+yV45?=
 =?us-ascii?Q?WZ5r5BhH1UD4laaH1YmoQ/JQyij/VD5ktbCqSiYSJ0wZxcoxtIWuqGE4kKGu?=
 =?us-ascii?Q?M8Nav5bHkWhUtDbIgccFhLwKDXL693NgzXjyxi5VQDtpzSYBnLYLjPSkNaQS?=
 =?us-ascii?Q?8FcMUNtW6vFtqknZmyQ+XxkmuQqEAzm3pOWS0HBiiSQvyph7UC2MD7LTHUKP?=
 =?us-ascii?Q?on/FQF0KPEvTeesZ1XNfVfJ+2TMleilEvTxb6n5PZYryovHTFYuYfwWO9Nr8?=
 =?us-ascii?Q?5gj8zbP4ZOAjZVFmzpA1bx4qDvBFPRc0yJCAitjvDNagaiNQUaPLjy2OkiV5?=
 =?us-ascii?Q?iA+6KlAN2ZFZ5lNosmI7SIaWaVZxnSzBROt/bJi5uMqvmuU1nFqteyhomA7e?=
 =?us-ascii?Q?1Z2R4Uavtjs4Nl0QL7HyfB5t1hGys1nmbZQx2WPGJBdpe5ZvhDd4Vkkkm4E4?=
 =?us-ascii?Q?rXzsFE3k+bpaVtILDXNY8VYedFbofuv2NgAUIKj1UjdFtFzdoK594XrlseL0?=
 =?us-ascii?Q?suiJFf5ykM5PLvn2NikAKi/TFeNZsaK8HNzRbXcmPV78grB+0BXDZlJvjdz6?=
 =?us-ascii?Q?DANRv63sFxcIacXS2YVURnQcUXTqtr7fr7v1RT85NFKqtj0sMocMBCuJ3BZ5?=
 =?us-ascii?Q?U9sdg8GeHqtkWT4bl6eG9XySCwr9VKcGxAxtQCkdJfH1KOVyBGMYkB9hDaP1?=
 =?us-ascii?Q?ZDr8F7SO1pCyG1BjDTZWG3iVQNJrWv6B45sqvoMlicIAlR5Fm3G282cisun8?=
 =?us-ascii?Q?IhE6TY9IhbvSUmWWrMSkdaBw9qXG+OWUFt91v7zZhFy3HG1vWmkZznxhfPyC?=
 =?us-ascii?Q?jESOWGy4dC9JPKRCIqEJq/b9NASYbnv+1WCKZhKD2/YLBIQr81G6fTSAdS/k?=
 =?us-ascii?Q?K/77qyIIYMUvnkOHtO4E5J04WHlt7fNqbq1YhdAW8OpRdpkGj/SQV9su23a2?=
 =?us-ascii?Q?pOP3XvFikVAhjou3oE7iYDajKOHYo8G/mK2W0+zFWRT1PIqhD5k5WV6mtY2Q?=
 =?us-ascii?Q?OBh5IoRxyW7KpDLtC7heEvLuHdNkX3or5nX3a4XYqrIXPQMFdNPW3Nb242xb?=
 =?us-ascii?Q?BbTeDvx2MxILiZNVskGJv7CsfCjG/G4l3D/Xz7yA2dsDu+iW0tCK2ENLCEAk?=
 =?us-ascii?Q?Fkejzkr8UAX9/qhw3LoPL73ikXrF4C5InCzdozSc6FbMLrsG2X81oOsII8pf?=
 =?us-ascii?Q?gMHvWoTqQ7JZaS3Akb7HJ/OCqQfIYqlf8JCJ+CUH2sm3/nJlbfadeWwuXjP6?=
 =?us-ascii?Q?GKJ7dswOwN0S++7qV0kT1bOMTQdf6UVz3Oz1d/Hs4W9ZNKcDNXC8Vw7/nQdt?=
 =?us-ascii?Q?5huVRqBTvdwZsZLC9FexTkLkgIqmh78b0pa/s1A1fC6b0RxZgRY640M5rsZ2?=
 =?us-ascii?Q?gzKaag=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c7fce5a-d145-4a54-d1e2-08db41853b23
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 09:54:28.4436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +kU+d8HA+TEhgpkXmg5FyBzGPnTkBwOPaDEYT1Icuga8pVT+spO0erZ9tTkl1ViEhUf14VnPQQPTKOCeCd/VN9TVoTl/jImwqhGwYMiqpx4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4922
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 03:10:35PM +0200, Florian Westphal wrote:
> This allows userspace ("nft list hooks") to show which bpf program
> is attached to which hook.
> 
> Without this, user only knows bpf prog is attached at prio
> x, y, z at INPUT and FORWARD, but can't tell which program is where.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Hi Florian,

as it seems there will be a v4, some kdoc nits from my side.

> ---
>  include/uapi/linux/netfilter/nfnetlink_hook.h | 20 ++++-
>  net/netfilter/nfnetlink_hook.c                | 81 ++++++++++++++++---
>  2 files changed, 87 insertions(+), 14 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nfnetlink_hook.h b/include/uapi/linux/netfilter/nfnetlink_hook.h
> index bbcd285b22e1..63b7dbddf0b1 100644
> --- a/include/uapi/linux/netfilter/nfnetlink_hook.h
> +++ b/include/uapi/linux/netfilter/nfnetlink_hook.h
> @@ -32,8 +32,12 @@ enum nfnl_hook_attributes {
>  /**
>   * enum nfnl_hook_chain_info_attributes - chain description
>   *
> - * NFNLA_HOOK_INFO_DESC: nft chain and table name (enum nft_table_attributes) (NLA_NESTED)
> + * NFNLA_HOOK_INFO_DESC: nft chain and table name (NLA_NESTED)
>   * NFNLA_HOOK_INFO_TYPE: chain type (enum nfnl_hook_chaintype) (NLA_U32)

nit: -,.s/NFLA/@NFLA/

> + *
> + * NFNLA_HOOK_INFO_DESC depends on NFNLA_HOOK_INFO_TYPE value:
> + *   NFNL_HOOK_TYPE_NFTABLES: enum nft_table_attributes
> + *   NFNL_HOOK_TYPE_BPF: enum nfnl_hook_bpf_info_attributes
>   */
>  enum nfnl_hook_chain_info_attributes {
>  	NFNLA_HOOK_INFO_UNSPEC,
> @@ -56,9 +60,23 @@ enum nfnl_hook_chain_desc_attributes {
>   * enum nfnl_hook_chaintype - chain type
>   *
>   * @NFNL_HOOK_TYPE_NFTABLES nf_tables base chain
> + * @NFNL_HOOK_TYPE_BPF bpf program

nit: s/@NFNL_HOOK_TYPE_NFTABLES/@NFNL_HOOK_TYPE_NFTABLES:/
     s/@NFNL_HOOK_TYPE_BPF/@NFNL_HOOK_TYPE_BPF:/

>   */
>  enum nfnl_hook_chaintype {
>  	NFNL_HOOK_TYPE_NFTABLES = 0x1,
> +	NFNL_HOOK_TYPE_BPF,
> +};
> +
> +/**
> + * enum nfnl_hook_bpf_info_attributes - bpf prog description

nit: s/nfnl_hook_bpf_info_attributes/nfnl_hook_bpf_attributes/

> + *
> + * NFNLA_BPF_INFO_ID: bpf program id (NLA_U32)

nit: s/NFNLA_BPF_INFO_ID:/NFNLA_HOOK_BPF_ID:/

> + */
> +enum nfnl_hook_bpf_attributes {
> +	NFNLA_HOOK_BPF_UNSPEC,
> +	NFNLA_HOOK_BPF_ID,
> +	__NFNLA_HOOK_BPF_MAX,
>  };
> +#define NFNLA_HOOK_BPF_MAX (__NFNLA_HOOK_BPF_MAX - 1)

...
