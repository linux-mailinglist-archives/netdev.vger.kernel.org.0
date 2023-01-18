Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEA4670EFC
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 01:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjARAsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 19:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjARArY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 19:47:24 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D146522034;
        Tue, 17 Jan 2023 16:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674002067; x=1705538067;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ObL0QU3qiM+qEwA5buD5Q1zEWFsSXIoYh5tP7/e1XIU=;
  b=O1sgk5uDIWOnVt+uVXsuHFsSw6+BMd0vgSdovImlcuUhsWmu1Z1emCWa
   7vgZ8U3vFFEiaHE6RPqjdU4s3j7zumCdWJBXSZpsYlcgTQToGE2BAWbaM
   9wvd29VKzaZtWCJPgFuqVEZRc96aCKTk/qAG2CxAfwkjNIj9XprkybzO+
   FxZhdb0Wi6lbqUp44v45WvDcJK5FJ5V2H2ihNyYoZsn61I5MoXbigJNR0
   npcj8eJX2gh5LJFsHIR+uUqaRSg8lbNjnE5hm9YUGS20xnDXjhF1jhahR
   46AmANBb6FlfeJivrgNvWn/lnsK5494ceBTlg6w9+tXdS7FKF4T/WwB84
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="326935972"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="326935972"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 16:34:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="801956722"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="801956722"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga001.fm.intel.com with ESMTP; 17 Jan 2023 16:34:25 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 16:34:25 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 16:34:24 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 16:34:24 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 16:34:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCsIU+BVCLvjwSLgCMSErVcySZTnn8SuQLCCSmfc67ffHOr04Rg9YXRhosEaO4V/uRVmWhh6AMBrsBSft/OiOoWTS4NwoGTECd9I6ZryJWUTc9RbwXhAX/6p88go+pWVZI5QBtKENFVY6+VBKMG4wZfl+snC+Rfv3cSe6+p5z3ZuA8TpueRpEp6FaYTILFNXpxkeWqeeuFJmSYNK/m+qylGqi7L30+uN7f1GQndq0LqqRG4/msQ9OOWTMGaM3YLAvAJO+fan+e5TfhrSGPK2C0kMn0GW4GaDrl+oNlqriyWhW02p4MjN1C1JPw3w0noNsc5d2oVys90BbzNZUZDzxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FkOInFUneZfjS8rcbfe719gPwRZFmVqN9xY5slJwTOM=;
 b=HYFJB4nv0anOYGQs8+vVWgh9UOllRxwjE62y60lhFpHGKKp/bXLyy9QQcIFENIxI+5dyEnFwaYwz2zfRqW/It1cz/UV+ONYtwARtHYIa1CUuW8RuiMFCpshhRDFyrfpdfynNAtCUlD8onK14GyC42BzUSXkPRew7YlyyZpVgx4Qtz/gGClsTiI/FxVxEDcSO8HondzF+0QRv/agWr75h0aakexIiMQ7WwsJqctlMl8L+3PbYtxYb0c35aSzfA5YyJq7wBJGSwj+4NGBl7wxsZB7a11k4CRUBa/QF0XLCUpy8+4AYZjyY5jdxwm1GemmOLtmW0VfJ1NiGjBHuqkZjBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ0PR11MB5101.namprd11.prod.outlook.com (2603:10b6:a03:2dc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 00:34:15 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 00:34:15 +0000
Message-ID: <f847b419-e847-38d5-3880-2c8f781a93e8@intel.com>
Date:   Tue, 17 Jan 2023 16:34:12 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] [v2] mlx5: reduce stack usage in mlx5_setup_tc
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "Leon Romanovsky" <leon@kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, "Tariq Toukan" <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        "Gal Pressman" <gal@nvidia.com>, Lama Kayal <lkayal@nvidia.com>,
        Moshe Tal <moshet@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <llvm@lists.linux.dev>
References: <20230117210324.1371169-1-arnd@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230117210324.1371169-1-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0029.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::39) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SJ0PR11MB5101:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c3bf887-cc39-4b33-23c4-08daf8ebb9ed
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DlmkkktZUswej4xmf5pov9bi8yrkeMZZbx+46fzjgDBpKbg9B4vOc5rgP6UlYIFT5IX3tDIZrAa+u4iEpRw+XLlP0Q0td5MWQXOAy01VbkNx4mbZtY/e2/cjnQPLoM8k6JGdOBrHk5ej+MbfOBVb03AocHCJmC8ri3UFvNPRLqke6IIl5jrYULhwfC9wUkWmqevNSMATDXqVXZ1KN1lNLPVq7NLD+e6uL97KpgVAoL1KvqpZkCgvkjhgirSJ2Q7q0TjboTZctu4h/LrqdY65gTVoo0SFjHdDMQr0p0d5sN5UfMKGWGfl9jxM/EENKq3VA8o9zJE1f1NNOe54UF862w+VEoCFPFb2U7TQtiq3WreBM6T22HvbYzRst71yGgyYa73eq79ZkXwr4UkdNLgKVUMh+aRvQLvS3IGT6KYwGQ1EojewjCrJCRUofsnTn9N0QdtUQx5g5qmwVJSIurDRNFG1EuuGyNaWj9puUmlpBKrYqANK1rfqGgO0cGYYSPdBxG+DxZLf6mZtltFEFUKci6tj1ir+gcaEXO1zzE9pIVsafxHQjidI3x8T6aOYLfw5wrLsrRr569trmXZ1hyRmjGusc1iRB11+wM2d5W46wCyunb/qRW18T5BzTekiRutv9XLE5sQX3+mbLck6T8IKH16QOxKtkQBWiI8dAnQ0N6fZh76a2MHv6XGskg3SczgcwdR3u5XmCRIyOl2eTrtI53Sqf/LbFP62B118ZW3zhHY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199015)(83380400001)(82960400001)(38100700002)(5660300002)(86362001)(2906002)(66946007)(4326008)(7416002)(31696002)(66556008)(8676002)(8936002)(66476007)(478600001)(2616005)(6506007)(53546011)(186003)(26005)(6512007)(316002)(6486002)(54906003)(110136005)(6666004)(41300700001)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3cvcXZrZ3E2M1hRNjdkOXptZG5yUzlCUGQrN2xCVHBmaE4rUUtYSUlDVDl4?=
 =?utf-8?B?S1N4QmlCOTlWeHkxanUyUjZUUXN4WkRLYllQMXZlUW9JN3hlUElpODJRQzdJ?=
 =?utf-8?B?MTNiWDcxMjJ2R2UyM2tzVTd3QnY4c1FXWTUyWnZHVVNRZ2c3c05aVkovTG1p?=
 =?utf-8?B?S0NGVC9pODZrMno5Rzhad3RlSWZPYnRXYXk4OENuT2ZQNEVqdWtaMmJUVFNm?=
 =?utf-8?B?aElNNnZDMTI0SVp1Vkc5akw1eXJuNVA0MkNJNWFlMVN2MFJhT29SekVwYmQy?=
 =?utf-8?B?SzhlQ1puS05ZOThJc1RObUwzb1dXVDZLTTRTK1VuL1dlQW9wdjdvZHYxMmh1?=
 =?utf-8?B?NGx1U0lyNWJ1SklIcTlPWjIzWU40Sy9zaStXcEdvdWpndnppTlpiWEtMWE5T?=
 =?utf-8?B?ZDF6cDZ0RjlHY3dXbmZVYnIzaktVME1FUVYyQlhjbGpCdU1WYlhDTjdxN1l3?=
 =?utf-8?B?V0xMZ2xWY2Y3czg5eXArRG9KSGpLTUExSExHT0s5UUpWMGl5QlhMdXJHamFP?=
 =?utf-8?B?akw4blZrd1c1VFMwa0U2MnM1VWJQeHRFNml3eWtJMlQvbjVBc08xaTlQU2pH?=
 =?utf-8?B?anpldklYbnIvZVQ4dkZZWUhteUhVMG9iUjRKU3NzMTEveTNlbHpaRnV6ajVr?=
 =?utf-8?B?cEhFNWJSK3UzTE85QnJRUnRKMEdBQVkvTUFPSy9mVzlHdnpuUFc1VC90NEZs?=
 =?utf-8?B?QUxGZzNEUGRmY1NQc01TTEtCRlplbFNxUzN3ajhsV2RjUDlvMUpiRzY5bmFv?=
 =?utf-8?B?dEZFNU4xV2o5bmErd3g1c050Q2RndXFRN2JZVzlaWWhXUWlRVGQyczZVMHF4?=
 =?utf-8?B?WXdkY1hSeHgzOGJ6N1JnbW0xOEFacHdnY290b2c3MWlEY0JuemsvOGUwYXh1?=
 =?utf-8?B?TUJLVTg5eDlaYS9iRDRPcytqd0hna2pmM3dtbkNkUDJsODltMkJCMWdzWVBa?=
 =?utf-8?B?cm1DcHoxRGRPajlQMG8yVXhyQVpaSGhnb2JUck5pOTJyMDFxOWdaNnVIZHZo?=
 =?utf-8?B?QWFSWS92dld2U3oyRXIwdFNicDhqQVgzd0g4RGFiY3B1M01hTEFYTHhOZUlX?=
 =?utf-8?B?dWNCSVIybVBORSswTmp6ZmtGQm9EYU9LelJMS3lVYW1XQ25KbFpDUUxCdEp4?=
 =?utf-8?B?K1lmUzBucG5TR1NVaTg0U2QrdlZzNHFFSU5iUFV0SkE5VksvUmJHVDNSbG1s?=
 =?utf-8?B?cVREY3dSajYvckh0ZkpFdU53eXlRYTdlb3dURXBhMUpNMW5BWFMvc0owYllT?=
 =?utf-8?B?eGpKb21mUGpWVlRNZGFBZVNPZll6akpHMEZETEpIUDFxOWd2eVNBUDl3SmZv?=
 =?utf-8?B?amxBTkFpcFVqZmpNSEpkM2JBRUgxRHY2aU4yVnlZSmJiTWJabFBwT01iU0VO?=
 =?utf-8?B?TjUvR3dKYmM5VDlrY3J6eXZySWZXV2xNQkpqYWhwSTFvV2NGYUtYeUE2bk4x?=
 =?utf-8?B?dk9Jd2xRcFlPWXZTK1dxaFFCaEdhemxGeUl5Wmp0UzVEb004eklFZzJhbEhX?=
 =?utf-8?B?bEk0L2ViZ1V2OGIzdmQwaE11SkV5d3pNTWcvMmtoREx1WkJEeE5rNGNrMkJw?=
 =?utf-8?B?YjdIK3o1MExWMDVQUkdTd2RyTzVoM05GWTV1WlpCM3ZPK080SkV2amlJNjBh?=
 =?utf-8?B?Y2ZWa2dLUlpTblc2Z0JEYmpKdlVBRnBNZ2ZvYjZmdjVBajE3VjlFLzFHZ1JR?=
 =?utf-8?B?Qkx3bzlUZDlsYVVWVU16ZmlNa2lBVk83aUdidDZsbCtLME8wOUszaUZ5dVVN?=
 =?utf-8?B?UjRiL3VoaHVIeEI3a3dsMTBMN2t2RGpoWW1XajBXV2RaL09kUTlyZzEyUUF3?=
 =?utf-8?B?eHZsV0Rzb3A1cVU2WlFVYmI5Kys4TVVydDk3dlREaEpUTWxnMDhYOGdTR1Z6?=
 =?utf-8?B?WWVCU1pnQW55MjhpM1dueVVCODJxY200MTlSVUkvZ3RSV0M0dFBtMjZLb1Uy?=
 =?utf-8?B?OWgxZk4xS3c2OElFWk5LRFYzVjBNZEpWalg0MzNYU3FSdHlJUGJhU09vb1JL?=
 =?utf-8?B?bmdVN3N6ZUR3dUxnb0grY25mUlpLSU0xb3VOY1VOc214T1hwTXB5YmY0Rjh4?=
 =?utf-8?B?R25pSWNpeStieFpmQk4yRkJOZVdZd1JkZkxUY2ZLdk9PSmlUQmMweEs5eU1t?=
 =?utf-8?B?LzBobHhPMC8wckU2WGJZS2w5cmMyMG1NcVNOK1pnMjNsUWpCV0xnZVlJakc3?=
 =?utf-8?B?VEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c3bf887-cc39-4b33-23c4-08daf8ebb9ed
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 00:34:15.2612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dlent5KwpSWGSbe1IheTwmFbQnbEyQOf0mCco5CNQrHp9EicWEM9DVcweztIGej6Yr2Ku1pAoLAMkJQfww5jKK9uWR09tAo5oALVNIFrSgg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5101
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/17/2023 1:01 PM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Clang warns about excessive stack usage on 32-bit targets:
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c:3597:12: error: stack frame size (1184) exceeds limit (1024) in 'mlx5e_setup_tc' [-Werror,-Wframe-larger-than]
> static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
> 
> It turns out that both the mlx5e_setup_tc_mqprio_dcb() function and
> the mlx5e_safe_switch_params() function it calls have a copy of
> 'struct mlx5e_params' on the stack, and this structure is fairly
> large.
> 
> Use dynamic allocation for the inner one.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: simplify the patch
> ---

This simpler version that focuses on fixing the stack frame issue looks
good to me.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Thanks,
Jake

>  .../net/ethernet/mellanox/mlx5/core/en_main.c   | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 6bb0fdaa5efa..b0b872728653 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -2998,32 +2998,37 @@ int mlx5e_safe_switch_params(struct mlx5e_priv *priv,
>  			     mlx5e_fp_preactivate preactivate,
>  			     void *context, bool reset)
>  {
> -	struct mlx5e_channels new_chs = {};
> +	struct mlx5e_channels *new_chs;
>  	int err;
>  
>  	reset &= test_bit(MLX5E_STATE_OPENED, &priv->state);
>  	if (!reset)
>  		return mlx5e_switch_priv_params(priv, params, preactivate, context);
>  
> -	new_chs.params = *params;
> +	new_chs = kzalloc(sizeof(*new_chs), GFP_KERNEL);
> +	if (!new_chs)
> +		return -ENOMEM;
> +	new_chs->params = *params;
>  
> -	mlx5e_selq_prepare_params(&priv->selq, &new_chs.params);
> +	mlx5e_selq_prepare_params(&priv->selq, &new_chs->params);
>  
> -	err = mlx5e_open_channels(priv, &new_chs);
> +	err = mlx5e_open_channels(priv, new_chs);
>  	if (err)
>  		goto err_cancel_selq;
>  
> -	err = mlx5e_switch_priv_channels(priv, &new_chs, preactivate, context);
> +	err = mlx5e_switch_priv_channels(priv, new_chs, preactivate, context);
>  	if (err)
>  		goto err_close;
>  
> +	kfree(new_chs);
>  	return 0;
>  
>  err_close:
> -	mlx5e_close_channels(&new_chs);
> +	mlx5e_close_channels(new_chs);
>  
>  err_cancel_selq:
>  	mlx5e_selq_cancel(&priv->selq);
> +	kfree(new_chs);
>  	return err;
>  }
>  
