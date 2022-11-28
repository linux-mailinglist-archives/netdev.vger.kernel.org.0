Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDEE63B619
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiK1XoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiK1XoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:44:03 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38FB2DA8F
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 15:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669679042; x=1701215042;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bT+pvM9OzV08Kv6BYh0upPf6tHb2LivM1dgO7zxBxlI=;
  b=cisogiG9D02zcsDg6gIMnI8uLNgANdviDwxOkEQGZkn7UXXrAhNoffxj
   +NGSmvl06gVc7EIBhIkde3woyzWJZHnyXWYRnBZIskcetZWuCqdBqYX2a
   yPGcHS+355EMDwA4khdNHKyCybWF5XazNEBYblge/Xs81TVapEjVgu1HX
   iNkwrdG52wEg/23uQugx97qdhqhdML/WRWuaBA9XlItgyNfjQyCb1XZ47
   /nBiPsZZ0x+SXGnJDlRskXYN/PfhPALZUgh9m709GJBZN0cPKJHTRYqFF
   1sxsqIq9igabNTMwLC2oe723utCOzqgjh2/xw7R9axgDpQyA037ELvezq
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="377122090"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="377122090"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 15:44:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="785826749"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="785826749"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 28 Nov 2022 15:44:01 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:44:00 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 15:44:00 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 15:44:00 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 15:43:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SAlNKaFAGZxYoD8WDjflVXDlaFNc70N1G2IS4w41fFZ3dFvVTC3Ry4qOBCm4EgZlkD/f/HdG6PKDK079UCG7A+k/mLITIJC3WjXAXLnVcCAlvE49ib8Ea0cBkCRkhBf9b1sDQSg6GP73JNe1IfYZYlstEjGkEiBDAo4UxK4TKkcxNOYbA6axjanlJcYpo78G1BCHVzWJ0ZMVYnJnfJymx2+Kp9aIHJZeh8stlrp14pc5fZm+B4b3QiM+QpIt1VYVUlzZrNY1pRcIOKl34Q9bSuH/TacVA4SybZ7qifLhsuYVdQSfC5AgjB0mQs94G/btKRKUBwvpX2IuGFDysqIOCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lfh2etgslWVLqnRrakp/9OIByIYFMITSHJLThMJ9wF8=;
 b=LZGP3kZJirmFZWLPhpeaq8K6cKxafOSs2zqPdhjG15vMcOKaUQuTsJFwl6u+g/qiTxXQr2MranXKPkLtOT5FPde1pCRnsuJPvvfdRHTCiONVJvxvTvaH2dlBvDEwv4361E9xFnLDLEqn7Jvvb5iy379QHYVzQ3bBkKm2UrAGY+JROIcHSzgefHp5no3ihls5Au9VL178tcp52IddFr8zv09KVbOb4dEFYZpSnb/wtYO2IXTR1uGEXHVbeyIMqjdmFD2gjcwvFU81E+8y+YxeikrZEeFpg4GP37PIotxmhhVih0Rhu4GYR4w4Y41DEttjJ+4bWcRt5ClDjwdcLWZ+yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MN0PR11MB6136.namprd11.prod.outlook.com (2603:10b6:208:3c8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 23:43:53 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 23:43:53 +0000
Message-ID: <46fd0be4-cbed-0e0f-b133-89d064126d01@intel.com>
Date:   Mon, 28 Nov 2022 15:43:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [net 15/15] net/mlx5e: MACsec, block offload requests with
 encrypt off
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>, Raed Salem <raeds@nvidia.com>
References: <20221124081040.171790-1-saeed@kernel.org>
 <20221124081040.171790-16-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221124081040.171790-16-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0039.namprd07.prod.outlook.com
 (2603:10b6:a03:60::16) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MN0PR11MB6136:EE_
X-MS-Office365-Filtering-Correlation-Id: f2eacf1f-129d-45ac-6d7d-08dad19a6860
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WCuJ66TFC7lkNtBHDTl/5/a0KGEkv8+TktFjToMACU/W1ooRceUUT1CdQAPkreQ8gUfLGLiKJqZVmqUSGM4umnt3lUql8GSEdr6IDHMQ6NpBlnB+EGcOJifPCY9qgXU35nk6fBqWCLkDtcqZ3ZUueARm5Pzd+5GKAGJxVZ5xGPGvHa7rgd5QSpftlZkVJ8+Ks8JJ0h4kQXHMdYL3+/vo785FskS9LdU+bT6FIGKtSFe2Mn9yBiZCVgN8El/466c5VcGu7R+QJkADZKnHcbXU1kYx1SiwMuhabvwlkLoBgXGyyQY2yEgCoQVmMUGI06v0IY0jKAAdSi+V4F0u1wnCmC9Lp1JuhT135fSrkWTTHYuNSLh1PfwjRlxqNAkqW+NBKZM/SEuCMDcGaFtelGOZdTuyaFr8B+zG0Gei9f/WosDlvsqeiXch09JJvjcbmAfG/xIF/HdNASLE7z1xl3BUA8N20YruVJwPkGwGCvt6T1FbvvSC/BYGBLzCmBiLOgPaZKyFB6wv6qCruOTPCrNLIUAq6+p1vG59VDdUzMagcLUgBBiNxlI1SKTLXzSHZVQFlWvn1A/MmNMt3l9ep2+dyoQN+cC7Ej8kV5XmMSmzEr9xqEgXSB3BccYxTUcbZKQLJnGZayyuNIQ4FzscCcHp1LxBCUT88mFYAYZSAZYp19+ahfAe56sq3IMn1x82jN516CN225beZ78Y6chKo2QxW5FcVNMOrJJ+Erj3mmRWsuY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199015)(86362001)(66946007)(66556008)(41300700001)(7416002)(8936002)(36756003)(5660300002)(83380400001)(8676002)(66476007)(4326008)(316002)(54906003)(110136005)(6486002)(82960400001)(478600001)(2616005)(186003)(31696002)(38100700002)(26005)(6512007)(6506007)(53546011)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUtmOGthY1VqZ1Z1Y2RvTlBuQzE1MVovZmlRYXRrblVtbFJzZmp1dVNUWDVD?=
 =?utf-8?B?bmVncFNBSUVQakIzTkpWa1NHdEVjWTZWeVRNS1g3QjNrWkJjRy80aitiZDlt?=
 =?utf-8?B?YjBYYXpRY1VZaVZCUFFvNldzMzJrNngxMkd0QmNIOW5DanExWFZ5eWJBcDhq?=
 =?utf-8?B?N0oreEMxaHVlVW9UdVpSRDB5OWVmNmdmTU5YSStmMGpuUHJFTHZIQUkweUVX?=
 =?utf-8?B?aTBIKysreWJPcy92dVNEbWlBTXBLT2NOSEJnbDY3UTl4SUJZbWtxZVFGaWp5?=
 =?utf-8?B?YVQybHoraHZqZS9meXlmUnFIR2Nkd2JOandvTE9QTE1IMDBjT0gxWmwrVFNx?=
 =?utf-8?B?ZlpwS1lwalpOLzNVcmV3SzQrazdOcjlsV01tb2xaaS9WcEF3QTd1QWZXQm5S?=
 =?utf-8?B?bzFBRXNybWt0UEtFUXV0K0l5WDllMVZGWVkydGRjajA5NC9ZMGNlZUlTME96?=
 =?utf-8?B?M0E5VktGbVFUOGk0Nm1FOHlhN2lRdVFuZENJWkJ3Y1gwUExDZm5DdlVFcFEx?=
 =?utf-8?B?ZStKdllEYjY5NlJ1UjNRdVN3anJhSVZNK3RZODMrTFZGWU5ITVVnQ3Y3ZFJM?=
 =?utf-8?B?dGxPL0N6N0xqbUpheHg4WngwTkppU1JWQVV1L3JpVGlzRVdQNWdwV3RUc3Y0?=
 =?utf-8?B?ZjJxY2FSNERxNnFyZllBVkpqRnlnK1YxVVc5VjNPc0EvVVRpY0NPOVdvdHUv?=
 =?utf-8?B?MldSTFZub0NBSnpRL1pXZ0Q0aXNZZjljTFBjL2ErdXJyUmoyUVE1SDZnakZB?=
 =?utf-8?B?UDQxZk1Nc2NlR2Ywd3V2bENQem0xWmxaZ1RYalZHRHdoT3ZaVjRxZEZjbzR3?=
 =?utf-8?B?bGlFY2tuRVhjRW5ITnVXVmZEaVd0UkJWbWtLMEFDM3BHVDFaT0IrVkNqakdO?=
 =?utf-8?B?M2lJbjF0c2wyZG95WHBlbnpnMU52c3lwa083MmFpemovODRjZmtlR0JrdFMr?=
 =?utf-8?B?Zzc4UTgyckpoN0ZzZkJPeno2cHZINmQyakxsZXR0S2lzKzYvbEtkd2F6aGxP?=
 =?utf-8?B?ajBTczJYR2ZDcEo1eEVBNzZoRnhySjQyRU9mODBKcE5mTzZUbElNcDFpRWE2?=
 =?utf-8?B?WllERTNLeGpDTGdBak82WFdBeGdOaFpoVE1lRkwxSTRtSlR5T01sTUZDTDIv?=
 =?utf-8?B?U0p0TnU0TlhFK0VkaGdUVmNmeWd4Y2pIclBuUEpqeFFmM01STWJzc0pibHdY?=
 =?utf-8?B?ZkFsSWtZOG92eVcrTjdZOGRWNllpL3QxcjM1K0d5NWowSVdsMkZYZURZZTFI?=
 =?utf-8?B?WGU1TWFWN0tLdFN0QlpWSnphcnBPa1NaMzJjS1FjT2FSM2FqaXZzcXltRWpq?=
 =?utf-8?B?UnRMdkx5UXI3R3FnUzJGbllDSVdmelFYK1E5YmNoT0JEL1JKWHpxeFdlZDFj?=
 =?utf-8?B?cXJFTnZjSHBjWGlkSG5Ma29oQ3kwTUpqMENaZkVkZzhNYlFFL0VUNDVYSnVG?=
 =?utf-8?B?OHVyc0x5enZ0aEVSaEh3S21JVzZacnBWa1FNdjkrL3ZiRUw5MHNUT1VkYjlm?=
 =?utf-8?B?eG00Si9xcGdWZGladkhhMXZEWWxTT0VrbjJacXRBdzBkWGJGdjFTWDVDaEUv?=
 =?utf-8?B?L1QrY1pQR1QvZ2I4WU9wKzNMQkI5OXh4OGc3YzBNeDltejY5VVN2U3IvMk5G?=
 =?utf-8?B?UndYSWVqV0w3clNIVmlsWk42cWZDcXhnMzdSQlZENWFLK0oxaGhzM1lFL0M5?=
 =?utf-8?B?OVUvUldoWjNVNHVOVktXbmp6ZEJad2dMUWJ4b2tqRGlzdEJibmVkR29ROEp0?=
 =?utf-8?B?bVB6Rk96cG9OWWVhVnV2Q0dlWFd6LzVzQlpIcEVrSEhkOCtIKzJwdnYxZlNZ?=
 =?utf-8?B?QnJrSjU1YUlaNFdMREkvRnMxOUh4Q1NhWDNJckp5UHBZRmxrZ3ZDa2RMUnEy?=
 =?utf-8?B?dDMvTGNud01ISEcrSkZQeVVEdS9pK3FtQjFQR2txRVk0Q2F5aFdZdFd4SlJm?=
 =?utf-8?B?VHNHcC9MaXJ6YmJUdFVDdU93ZndzTCtmOWZkYjlqblloczY2RXFKLzBmT0ZV?=
 =?utf-8?B?ZllNdWJlZldiZEJzejBaQ3RzSXYvdkNJV0IvQWhnTkppb2tWcE9uT0dlYS94?=
 =?utf-8?B?amI3ajZ4ZXhwTmY0TmJMbXduQ09BZGhadGtqaXBhV0JNR2JCNVBPUXdYTzZC?=
 =?utf-8?B?b2JqQ3ZBSXBnd3gyQlF1M0dCLytIWVo2SUVWWm5WVlZGNGM5UWRXTHhEdHlL?=
 =?utf-8?B?cGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f2eacf1f-129d-45ac-6d7d-08dad19a6860
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:43:53.3914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TradLbl1fIKwvYy1qkTkUDB8AKghPmD7ur9EOtQxGgfTTj2kkYdypNBdMdvygAeomuRydQsRhVTCfct+3LXdR4yAjEBbAr1CGpHqlsVgUyg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6136
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/24/2022 12:10 AM, Saeed Mahameed wrote:
> From: Emeel Hakim <ehakim@nvidia.com>
> 
> Currently offloading MACsec with authentication only (encrypt
> property set to off) is not supported, block such requests
> when adding/updating a macsec device.
> 

Makes sense.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Fixes: 8ff0ac5be144 ("net/mlx5: Add MACsec offload Tx command support")
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> index 137b34347de1..0d6dc394a12a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
> @@ -458,6 +458,11 @@ static bool mlx5e_macsec_secy_features_validate(struct macsec_context *ctx)
>   		return false;
>   	}
>   
> +	if (!ctx->secy->tx_sc.encrypt) {
> +		netdev_err(netdev, "MACsec offload: encrypt off isn't supported\n");
> +		return false;
> +	}
> +
>   	return true;
>   }
>   
