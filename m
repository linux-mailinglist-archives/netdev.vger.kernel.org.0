Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2787268BFDE
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjBFOSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjBFOSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:18:08 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2117.outbound.protection.outlook.com [40.107.223.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4D45FF1
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 06:18:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJoyKtlETe3Vu1N51I1U3PFxmH2Ok5+2YNeXChy5ZSa2CPiwSTJCPSGudurk8HYMC9ddJrECnZ1PG4kvrw0A9WsQyNZe69g1Oi3ema3XmwwTF4Fvl6Trx/ewsdoYGdY5Vm9JkA3RQ0d56tTFlzyFNWYYR5T/oyolJOj7SMC840a59Y1aTqM/nwySq1whuJHOCOBQZ74Pn+dlvtxP/kFAEKVtj/CgMLWgUS0eUeev/RXAR3CjsIUhg592yTE+jlu06uQY20I1AyhNPz3ZiD6aWrSwMw0ytaBL5Yl7WCyj9eyuiGafKp9r/7VJrqgQm7x/Y2rqWKB1sSjhr89iIizqjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NE4H6mSVYCNMlgMRqVszF3GTdzURGzVIdvhLIofElUI=;
 b=dXvP6nV2Fkt7udSnKxIkdoeF6VHCqYVMZOjn/D+vPwpDLkqYc84IzBFGIdFobcSjAjxj+FB5LEKc4Mde74Zmz02HN50aNeReLXbknwCQZwaguS8JOwCklpBb6I1e2kzMxM9+33n89Wh3M6gD6AWIaVSHhmiYc9t2aQCvrlo4o/Q00bNJaQguOHgCSRlDO3j48kjo4iTtNM6KkxiNvroKOKT8KGSn2tdmlLwwJN1N9TUkzOkujHWegL8T97kCtOqZ0KT+uwxwtHkoRDXpjra49mSFZV8aWaiVEvn3gBNwVa0jWKuE7QqhqM2PwKJQKBHHYBoYmD2MP6R8lOY0AS0SzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NE4H6mSVYCNMlgMRqVszF3GTdzURGzVIdvhLIofElUI=;
 b=gdNyn/6AT/GBLkdIlg08yufsO5y7MBS/CRnL9+PjSHmrlXkN7ZU/waMp1AoBtL+LtwbaDGZC4f7sp2OgIRh3YfCiWmoHhGWOcU0fI/KXpcpGQaPdzyZFVU0u4ljoU2ZAwAYErvs3xaZijsn08m9RmBgwlC3FmoV4JnH1cKE6qQs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4753.namprd13.prod.outlook.com (2603:10b6:208:333::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Mon, 6 Feb
 2023 14:18:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 14:18:03 +0000
Date:   Mon, 6 Feb 2023 15:17:57 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH  net-next v3 2/9] net/sched: act_pedit, setup offload
 action for action stats query
Message-ID: <Y+EMFS/q/OK8szFC@corigine.com>
References: <20230206135442.15671-1-ozsh@nvidia.com>
 <20230206135442.15671-3-ozsh@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206135442.15671-3-ozsh@nvidia.com>
X-ClientProxiedBy: AS4P195CA0021.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4753:EE_
X-MS-Office365-Filtering-Correlation-Id: 85d707fe-94c6-4044-319b-08db084cf55b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lRe4aRJFUKK8u9wx/5xaDUXwyVuNzUs3PcPZop00DZCPsH4yDl40TtXkXUh9MGw9jMMHQx+7VZUSd4C1yK0fA2B2MzzRSQyfxCAUS+3b6nsdQeVMTcCb/7CMr65v8bbV9QquCYIh1JKv2vZQhCkDf2RXFB08U9z9wwSpYkG3nDX8d9EtlO6lubU7nOwuRnsshpl9r0y+/HuT7AMpSDILwjKJBFKV/6emS0wpzTCUlEo/MV3pcpuiyWjIwBDXgda5A7VpR5wYqgVAVQ533IGZNB99PtivX+JClj0KOaXAxLk5SO94TyfuUUxKaIMpQQS6aU5vNMhYCBbyF0xc4Ua6geAXkGCr9jnOOyidcQIGvq4xYQpvRiZ+vdFzYUDNnaa8gBJnuY+scQuMGSJZW6LyoQPqvWnGF6sqUYo8YbKRz86UIS9J6lKjb8UVOPCuEja8Nt9lrZJKltLXDo8Ys07hPNYM1ui3o/dIwoSxZW+asQK9/M+g7k3ITGpJBFXnFHTLSe7bhEk6wqq7cV+snHRh+7a+ju5EgW5QlIR3xqUOJfasGg3D2L+PsRFrMZxU6gb/zkupK2xep1GSEOhihQOsIihFsvZqiADaTOzVAaJZafSm5Q0dkwT2Sjdw6CvSlHz+5I/Xpu3+SSnvMQiLAp00zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(396003)(346002)(39840400004)(376002)(451199018)(6512007)(5660300002)(41300700001)(86362001)(316002)(38100700002)(36756003)(8936002)(2616005)(54906003)(83380400001)(6486002)(478600001)(66946007)(66476007)(2906002)(66556008)(4326008)(6916009)(8676002)(6666004)(44832011)(6506007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dFMBX9Xkpd9WFDNQZ2rgh8RNYeqsK0z/J6Zym6ycci5njPyJV6brfttObQ2h?=
 =?us-ascii?Q?1lSF380m1Zg7gq4I4BRKtaODQzTKgcoAPeLe8bAue1IiHiw/zuwy7WxbpITa?=
 =?us-ascii?Q?70fAgUZJuy6H4eG5ipHgCbwzzoIQ4gAUtaV5L9jEgcWR6k+7grotK25WEEqA?=
 =?us-ascii?Q?+qza8vgP1u4UTBuW4nTgNxyQTXaLl60+cu2TfaPh4X+/15hk9eV7m3ehGtvq?=
 =?us-ascii?Q?YZhJ6USAL1Ggtx8lX2uTx6FfcSZ4JAnLDBfRjyzpuXdZCDI1R1+Gt4egXxND?=
 =?us-ascii?Q?B9Gpc9fboEI/ODWoU1MThOGN96xkTNt133Hc815WHqfTHAHjy15zEUIU7msT?=
 =?us-ascii?Q?RILoOQYBDpWhnIJ61QLyZZkWDIY6UQwoDhIWxFnnt95obKf6K81iH5SHborW?=
 =?us-ascii?Q?ct6Kw8CSvWxWPQL9HE49K0H9kL4nYlX605Iu3T9xA6RuJXGr8BypKAZdbl02?=
 =?us-ascii?Q?5+3teod+4mhpjDtZfQ+7IfLyH6aiz7wfb2xoUs4G/++UEf7BnAkHAnaJ8Hdw?=
 =?us-ascii?Q?LGzvnkvJhJhF9oGEUxD8k2Uj5yHhLLgpMBHVG74pFJNsBVbudkayMbI7vOz/?=
 =?us-ascii?Q?Gvv8GJ0xtNyeFbBO8796QvE1tUEaI9xOvwC5DluCFoR0B2zknZ4ssDI6velH?=
 =?us-ascii?Q?e3byHSyAGLV3xXs5LrNlM5oyTV2SzKMxo3yINTE9munBkHV7iGo7n9yYURwV?=
 =?us-ascii?Q?lsnFxIL/FXkVaMHcWHCmzChnW6Kv6/08HRQILxvQBBrQd3e59d88/98T2qsA?=
 =?us-ascii?Q?aIQE54x4L9U/BKXdjHmD9nX5STjmxlnulhWobiu5Uw1o5N78ScuEGx38kUTl?=
 =?us-ascii?Q?X4xJTVwYF1Jq/2z7Kk3txNkroc0zXP/H9zMSBgZ2v5EFxDMkkrfDgvN+35wv?=
 =?us-ascii?Q?fL/p39gGmDlze+uaw/9V27KwC4QhM6bl3RoqL9x58r7b4aF/Iktr3HfTQO5W?=
 =?us-ascii?Q?s0q/Mn6gjBl8DjJ9bGYZua0BaD9ERFSKtonBA9fX98QNcwjp7FHtvKat5tEi?=
 =?us-ascii?Q?FRHkA8bve1pIwDlpdKpDGxOlWEEDhTiGT+fLYfIpftlXqhHGpqq408xWHCTJ?=
 =?us-ascii?Q?fZgMXx3FanaDI2a6+o7zblne3SP3AZ9Myp8TvTtOeDeBftxDsnTTvndREYWu?=
 =?us-ascii?Q?h8tY9HYT0Syv6iuGPUpwNZ1/lhYKukOlc6EiQSZnnjPkEElNPGGImseWrG0E?=
 =?us-ascii?Q?CF8jZIo7VzW7j5jBZAUi8NF/1kr5FhKBZZGGezq2J630YU326vrG4W9eYh6y?=
 =?us-ascii?Q?3M/KZkBz4weTt5u6kHDqFKbHtoh5fPa49kLDbLCTjVaKle6ouSfYfLhXrFZM?=
 =?us-ascii?Q?QZbI6ocpXKtXHOM9O65rEaI9v+Msd4PMXyLYVgJ+v4XRccltofn8kgZ+f6ea?=
 =?us-ascii?Q?wxGAqebDqjCQNkQYiUTAr5O6fQN2rpzOXuFHTiomuX9YEs3qsdAxADh0o6OS?=
 =?us-ascii?Q?3/jEjVZvlIrumvq/SJw9JjMnFlUv9TEknfr12p///PtkboxOlNvRxjXgrJPA?=
 =?us-ascii?Q?1N7B/LZHyanzK4ZaJWPOY/ZJeHkDsNJl+V9bpdE53EDOSm3aOnDAYy/GH7vt?=
 =?us-ascii?Q?3XOEtczo0VJRrbjrhlgglknHUo0pfEc++s2bESlHDo3ffCWiYG38OTalzd9W?=
 =?us-ascii?Q?mxQY2NiJQWKVawzHMp9k1fwfRbJJnhWmvUn6d78IY7EOoC97aaWfcaez9nd5?=
 =?us-ascii?Q?PLsWCQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85d707fe-94c6-4044-319b-08db084cf55b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 14:18:03.1550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 24sy2AAa0wZ/WLIQmCACZwfopDOyfQ8ho735Vps5pI4mazDKLyxMSrmVdqwJKUMoXhxIBBjQ4Gvc29vHCLqpcTwSlpFfC8wTXXqLpsagLvM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4753
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 03:54:35PM +0200, Oz Shlomo wrote:
> A single tc pedit action may be translated to multiple flow_offload
> actions.
> Offload only actions that translate to a single pedit command value.
> 
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
> Change log:
> 
> V1 -> V2:
>     - Add extack message on error
>     - Assign the flow action id outside the for loop.
>       Ensure the rest of the pedit actions follow the assigned id.
> 
> V2 -> V3:
>     - Fix last_cmd initialization
> ---
>  net/sched/act_pedit.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
> index c42fcc47dd6d..924beb76f5b7 100644
> --- a/net/sched/act_pedit.c
> +++ b/net/sched/act_pedit.c
> @@ -545,7 +545,32 @@ static int tcf_pedit_offload_act_setup(struct tc_action *act, void *entry_data,
>  		}
>  		*index_inc = k;
>  	} else {
> -		return -EOPNOTSUPP;
> +		struct flow_offload_action *fl_action = entry_data;
> +		u32 cmd = tcf_pedit_cmd(act, 0);
> +		u32 last_cmd;
> +		int k;
> +
> +		switch (cmd) {
> +		case TCA_PEDIT_KEY_EX_CMD_SET:
> +			fl_action->id = FLOW_ACTION_MANGLE;
> +			break;
> +		case TCA_PEDIT_KEY_EX_CMD_ADD:
> +			fl_action->id = FLOW_ACTION_ADD;
> +			break;
> +		default:
> +			NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
> +			return -EOPNOTSUPP;
> +		}
> +
> +		for (k = 1; k < tcf_pedit_nkeys(act); k++) {
> +			last_cmd = cmd;

nit: The declaration of last_cmd could now be in this scope.
     No need to respin for this, IMHO.

> +			cmd = tcf_pedit_cmd(act, k);
> +
> +			if (cmd != last_cmd) {
> +				NL_SET_ERR_MSG_MOD(extack, "Unsupported pedit command offload");
> +				return -EOPNOTSUPP;
> +			}
> +		}
>  	}
>  
>  	return 0;
> -- 
> 1.8.3.1
> 
