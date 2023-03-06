Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3880A6AC8D3
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjCFQ5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:57:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjCFQ47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:56:59 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2124.outbound.protection.outlook.com [40.107.244.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D893608E;
        Mon,  6 Mar 2023 08:56:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbBqQX+70g/a1ZlmVFDSWbJH+AI+gpOCw1aelnTMYQf2V7evfTkg9q5B0bEfr9vmr9BaJJI4nMTmy2JvaRHuUeNPfZ5ilptObjahuibMNBFaqr5teaYSKjs3THVAQ1Q7mL8NpVQwOowl+4XTfsCEu0sjcKhEwK1CpQYI3DhkCb5/2sS4BRIxURaNmRBOyY+LIYwRQFvaddIMbcdqozEUI6g94iE9zVcCpldkNoa7spXb52FL0kSaNyem+zkzrJbrQsb0pcNyuwi1ZwAEIc270cwsZu32t6DbTEy3WlYONMyimjRfFiWRgcwSjJaa7+wMBnsmaB8LPpGjz4sflbW86w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8HQH72QWUOxs0/t5OPUH3UXGbBd2D2eSEYVVleW9Yws=;
 b=gMflrvQdnhDkRvTKUgfpLoocuO5tuKmLMFo0J+TF6x4/o90f3WFx2q4CnIv/wmgornabNkisSSjvKeBCE2lIKK0OYpupEgWo2ZSTUtDee4iXn29q6lJctXc9dEJbhSYOFmIZh6w6He8dyWHSDonEO4EHKQxjN2AZ8eLUf2+4X1WNYsz4e4jIjHClklzyLXhMa4an4ZLMqB3Zq1Phph009FJF7TFZpFtuvASMaxsLDYJfuR8+wCPEIVorajo/dI6ISKO+D9789MdIGFU7GpCfVLIqWsRq8guyGn0UB3e9zdg4aSgSihWYkVGlgwau8P0xNLZbdX/K6LqDTHqAtw7Rdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HQH72QWUOxs0/t5OPUH3UXGbBd2D2eSEYVVleW9Yws=;
 b=JJzvBxJ9HBU8nu+TgY0qZOOVkl7X0Nce8nI02p2LE2IBnk1p4i8+4HtO4FRg9rwxnYiIw70jeJh617/UOqiaqAF1oLlXmWku/8Fhtm0ZNr1/6GC6ihZPGtBeZ736CGTcNZtpJ7tjb1QGpoCm9YproxCWy9deD7WYlda16nRAurw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4768.namprd13.prod.outlook.com (2603:10b6:5:3a6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 16:55:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 16:55:26 +0000
Date:   Mon, 6 Mar 2023 17:54:58 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jaewan Kim <jaewan@google.com>
Cc:     gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@android.com, adelva@google.com
Subject: Re: [PATCH v8 1/5] mac80211_hwsim: add PMSR capability support
Message-ID: <ZAYa4oteaDVPGOLp@corigine.com>
References: <20230302160310.923349-1-jaewan@google.com>
 <20230302160310.923349-2-jaewan@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230302160310.923349-2-jaewan@google.com>
X-ClientProxiedBy: AM0PR10CA0025.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4768:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bfdcff2-c141-4660-e5ed-08db1e639554
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iu5bCQUQMu+s25xCVvQGb4jIxTSeJD2QxVxsNabiPfeASVlV1CJZmOwyWzOJ8OU0AfK/R+eymVk0pOHL7spyY4DtWJu3uLh5oWFUOL/Bn1mvBckp3mUXS+AuQM98oY7EzdqYS5mrBPJ4yb7mvhW3AnnUsdnWT1aebpnMnnPr5cbt6dk0VkoGlYh1JUxdBCI7UOOE9RtLb29C85vFnNLpHGfounl51aweGhgCYf5ORQfbhBFuV9CjFbPa+GnCNNxxTIlcHE/iZvRBtUU5W5Vtro9nD83tgxth5D2mUgd1Ihd5KoJXybZDKDiMAFdLD2vmVINe6zCmJfTCb7HEbP0051xZB9wjxu4ijpMuSxgB7taZPXcxikZ58RFd5DOzL/ztWENYZDSARinxS5tU3a0fqeqgABCtovMeJGfzEndbhrO3SVWfGooTD6YOsZyMQx+F0JDxU3c9oBcVTAVRz62dv9SDqrLKzIJF6tJ7g4YxJ+Ul7ApcmroncgdhmzDt26Y4bKZIinGW4UCCFNw5+mFQ4tk4XwObv3JECoqMI180x7alYSRcjoQRox43E3w/tnLydw5ChzNoyc8lZrlzOSmW4/0Rgf+Ey8W/fz4wlg8qtjDz5h8gMfQD4dbv2h+yEk+eBCcziYGfIBKAKl/dBi9uZTBgJk5kJGVMk5REDug/bcfpWnugivgUUyZGLoJ0c0at
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(346002)(39840400004)(396003)(136003)(451199018)(8936002)(5660300002)(44832011)(66556008)(66946007)(2906002)(66476007)(8676002)(6916009)(4326008)(316002)(478600001)(36756003)(6666004)(6506007)(6486002)(83380400001)(2616005)(41300700001)(86362001)(186003)(38100700002)(6512007)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OY+jcs99dlFAtOIgAFKXlW4tUsvNPqa+vMl/w6YOGu6WOJ/lrjmDs/ZCYrar?=
 =?us-ascii?Q?fQk6+Em6rLsLCwzu3XA/Fu5ZFAKZNRQWo3xPP1kdpxN7tUsQaO5URpeDZMUw?=
 =?us-ascii?Q?aog/NIRKPDrc7LASNbjFlE42Dr2juwmAl7vh+wozZ/0M7jjcIMaHYAMxHkkr?=
 =?us-ascii?Q?TiVBSh9NobKvb1WYkAI3RgQlvsl5duuW4VxCXDd3alW6WZ9bUgkEC1T1cmvB?=
 =?us-ascii?Q?baKTYctdZi40k3RsnRUcG5O/4W5d4Kq+4L2Mp1MMjbbDaigRUXMH7ge2BK8P?=
 =?us-ascii?Q?pADLURVFAmbaJYjEukRaB7Jp1b02QZS3XGYihtd4tLfdoDQB3waJluyFftUN?=
 =?us-ascii?Q?hKUYTd0EnrlyZHlMfAmFIk40EeT+GHdBORVN08M0zPWWs4m/d+TD9D4HV/2w?=
 =?us-ascii?Q?2OWlyyTetcQyNSCBOTUuP5x3X+MncQECv907ETRqNQO7fa29MBMPOr6eoPd3?=
 =?us-ascii?Q?ZIwDjbfNP9rZ63YCv2HB7+vINNOFEbiOOlqjtIvfmSbnp4nhBuGB90oWBVH2?=
 =?us-ascii?Q?UUFuX69pHotoAW86bvaVaF1ZSeSlmk7a2OU5T/8ACAzMxXoNck/CrKN3BIdJ?=
 =?us-ascii?Q?FBN7qOx5so4KVT2e6G3V+F9i+SmJftKzBT4ou/jGJCsBZVBqanFrZlYpb/cy?=
 =?us-ascii?Q?oLt+pY8cvy+y9dNLi8BubVdIhqqG41OYXDnhh+rnoPiZCi3vOfFPLB36MUh+?=
 =?us-ascii?Q?EyFgggLpK5zjNm9Zzb0CN3q7K+fkMhBZBhWMYzHhodR0Aj5fg+RJ12biqTfv?=
 =?us-ascii?Q?dY0RbCfdOZdvZQ/a7i8NrKdFrPn5S8AmTpkHbHYICkt21puiKRVL+wKDlCSq?=
 =?us-ascii?Q?uBsOQQKUo1Z+smV/ybJTHd1HaZ5s6Wu+F2dle+a9UKLFxf5MXmczGy/fgoIU?=
 =?us-ascii?Q?U6gSXFxjYGnddzslPdGXciC3S/y9rO0Zg85A5t1FTv6KKZhVakMmttWmqSD4?=
 =?us-ascii?Q?GlLrghYW8+jCwr1aS4DYUbClAeZGfFHA7P0VSUYayD0CiJq4UUS5zWerpAcI?=
 =?us-ascii?Q?jMpe6MtoJioGe6jA5cp5uZN+Cjk47O2PgO5cRjw/7fsICnCc1ub+FvM2o0Ga?=
 =?us-ascii?Q?qWbCUqCEVInn+ag8p2QJpbbdi0oYTfZcs9bwjhASzV/kSDXVOTiJUieSzAiq?=
 =?us-ascii?Q?e2CSjS2PcSL0s61Y3hopGIeup4fwPkW924hjKcFNqZybZeVr59HmWhuYsYBz?=
 =?us-ascii?Q?6VqogPn85zayM/JNMvNZ8Iym2QXU0lZFafduFgZHXHQeZDSit2Fh1c2IrxQk?=
 =?us-ascii?Q?WHumvUCSWSSFmYRo5euUhowemzLI9WxZD543sqXFM1xFwFYzRAv81ImNh+Ff?=
 =?us-ascii?Q?a35penn0MyqprYVqiDw+xBWQYUP/ptPM/lV0Cw0xNgdWyOqsNk6mrKcqD6eY?=
 =?us-ascii?Q?rI5Fspoq0nB9XggSBIr7eUHOl0g1CL16DBHSdfZW1dZVkL6Sz2wYt3PKooFE?=
 =?us-ascii?Q?EtuVIKSRClp9fPBbs9MWeVE4FHrfgyJzQplzl/3mZvXDC61wu+vM10I7y1n8?=
 =?us-ascii?Q?rNV2RlPtq8ZJn6vBh+LZzf18lgIYaB+3fuZfWkACVuXj9ahZd6RD9aih9Coe?=
 =?us-ascii?Q?ljeUJAy2M2fGkSvfizn6cLGLhGwd9hvklNwh+4ma7zfAXRYxJMmybpArbOKu?=
 =?us-ascii?Q?KdQ7l4dk+cShlb+DEIyVshKpzfdvjZkcMLiIoc5CMJ39IZPR7bfWPMQlLjBh?=
 =?us-ascii?Q?8leTyA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bfdcff2-c141-4660-e5ed-08db1e639554
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 16:55:26.2146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bJOmDGu56XIS9mdZY0J8dN5vndK+7IvlOFVuuvmJkaK2vqSRNtUDfRTxw6qZA06kJtLjwgebdRv7LrCu7yNCMmZjcA1fUvLz5zLeO1EtwCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4768
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 02, 2023 at 04:03:06PM +0000, Jaewan Kim wrote:
> PMSR (a.k.a. peer measurement) is generalized measurement between two
> Wi-Fi devices. And currently FTM (a.k.a. fine time measurement or flight
> time measurement) is the one and only measurement. FTM is measured by
> RTT (a.k.a. round trip time) of packets between two Wi-Fi devices.
> 
> Add necessary functionality to allow mac80211_hwsim to be configured with
> PMSR capability. The capability is mandatory to accept incoming PMSR
> request because nl80211_pmsr_start() ignores incoming the request without
> the PMSR capability.
> 
> In detail, add new mac80211_hwsim attribute HWSIM_ATTR_PMSR_SUPPORT.
> HWSIM_ATTR_PMSR_SUPPORT is used to set PMSR capability when creating a new
> radio. To send extra capability details, HWSIM_ATTR_PMSR_SUPPORT can have
> nested PMSR capability attributes defined in the nl80211.h. Data format is
> the same as cfg80211_pmsr_capabilities.
> 
> If HWSIM_ATTR_PMSR_SUPPORT is specified, mac80211_hwsim builds
> cfg80211_pmsr_capabilities and sets wiphy.pmsr_capa.
> 
> Signed-off-by: Jaewan Kim <jaewan@google.com>

Thanks for your patch, a few comments below.

> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 4cc4eaf80b14..79476d55c1ca 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c

...

> @@ -3186,6 +3218,7 @@ struct hwsim_new_radio_params {
>  	u32 *ciphers;
>  	u8 n_ciphers;
>  	bool mlo;
> +	const struct cfg80211_pmsr_capabilities *pmsr_capa;

nit: not related to this patch,
     but there are lots of holes in hwsim_new_radio_params.
     And, I think that all fields, other than the new pmsr_capa field,
     could fit into one cacheline on x86_64.

     I'm unsure if it is worth cleaning up or not.

>  };
>  
>  static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
> @@ -3260,7 +3293,7 @@ static int append_radio_msg(struct sk_buff *skb, int id,
>  			return ret;
>  	}
>  
> -	return 0;
> +	return ret;

This change seems unrelated to the rest of the patch.

>  }
>  
>  static void hwsim_mcast_new_radio(int id, struct genl_info *info,

...

> +static int parse_pmsr_capa(const struct nlattr *pmsr_capa, struct cfg80211_pmsr_capabilities *out,
> +			   struct genl_info *info)
> +{
> +	struct nlattr *tb[NL80211_PMSR_ATTR_MAX + 1];
> +	struct nlattr *nla;
> +	int size;
 +	int ret = nla_parse_nested(tb, NL80211_PMSR_ATTR_MAX, pmsr_capa,
> +				   hwsim_pmsr_capa_policy, NULL);
> +
> +	if (ret) {
> +		NL_SET_ERR_MSG_ATTR(info->extack, pmsr_capa, "malformed PMSR capability");
> +		return -EINVAL;
> +	}
> +
> +	if (tb[NL80211_PMSR_ATTR_MAX_PEERS])
> +		out->max_peers = nla_get_u32(tb[NL80211_PMSR_ATTR_MAX_PEERS]);
> +	out->report_ap_tsf = !!tb[NL80211_PMSR_ATTR_REPORT_AP_TSF];
> +	out->randomize_mac_addr = !!tb[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR];
> +
> +	if (!tb[NL80211_PMSR_ATTR_TYPE_CAPA]) {
> +		NL_SET_ERR_MSG_ATTR(info->extack, tb[NL80211_PMSR_ATTR_TYPE_CAPA],
> +				    "malformed PMSR type");
> +		return -EINVAL;
> +	}
> +
> +	nla_for_each_nested(nla, tb[NL80211_PMSR_ATTR_TYPE_CAPA], size) {
> +		switch (nla_type(nla)) {
> +		case NL80211_PMSR_TYPE_FTM:
> +			parse_ftm_capa(nla, out, info);
> +			break;
> +		default:
> +			WARN_ON(1);

WARN_ON doesn't seem right here. I suspect that the following is more fitting.

		NL_SET_ERR_MSG_ATTR(...);
		return -EINVAL;

> +		}
> +	}
> +	return 0;
> +}
> +

...
