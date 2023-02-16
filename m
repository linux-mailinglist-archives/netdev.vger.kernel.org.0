Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD18E699B97
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 18:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjBPRwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 12:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjBPRwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 12:52:43 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F284CC86;
        Thu, 16 Feb 2023 09:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676569962; x=1708105962;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9nDuyR/Ife/8lkn+z+28ibCC5cU3xSAkIi/OlOKBzIQ=;
  b=XsMIqupS8Ig8y5HY79wE4NW5rHtPOajmQFXwUgkDa0uBJLC+A8sEiRYZ
   Jic7eaxNA4sOjwOdL8OSwE/waTyYeQp1hSirN3FbyS5iyoSi8v8ylgb+e
   0BmJ72x9uBLMrkuA1IVyRIg9AuaLrIF6yivgBsW2DSYGB6ljr8nVUbpR8
   yLQDmb4rfDdNM29KU+DQw5r/qFPTnVpkT8qz6o06ot65EvhNqmPwbGDe4
   r03iSky+xg33YU/k0wZndJpt4D4P4/tmlXYrxV/0eoPpGHeAFrXAv6fEp
   ldQ500vr7ubYlFoZ4RiHXJNzKWRZHuMlU9klVjcw34YzKVaiOkx7EWbmz
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="418006718"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="418006718"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 09:52:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="738931143"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="738931143"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 16 Feb 2023 09:52:41 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 09:52:41 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 09:52:40 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 09:52:40 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 09:52:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hpq9YqczP/DyXmQI4LE0dOOpPxRI68e4XEnqwAJwMaGG75zh2no4nl9ReM+wnWKNpdq3LlSon7p5UuTVRU0vb+AAEfX1I+2OnBKpiiZIWmuy//Fk67WVVMw+qM3FG3xuOtVf5p0dt1oM16mQMBkoPj0L2F2sBS0newQPvuTcTPc4XNWhUQ8qXtN7CBdwH3Q4xCzDflG7wFjV7RULhjhqMOoFV1DocI5Njh82yKB/eZr0BlPtzk4D3IAzbkxYcBzppPCthCBpPzqz+g1LViRX8RSBpeNTLTHiNzPOcVJ9TXr8AkpBzSHEm/tq67LrDJHuL/QLaokeiuF1Kw0zNmQCLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQo5B/biRi8ir14f9IcYamKWPcxq/n6/S8SkO8sg9w0=;
 b=kCEkyC+8YNV8QygAUWdoWcur/LVlk1PhepBfm1bwTc5kpRW8mk1Xr+XGEsrZQT2v23CGe81uZun2xd+zfF/e+RrESkDtPuiHWLkV9UmvJ57+xs90SoV0EgvgnC/xAlkB5ESEDh39TDqnBMYckYQH7Q2vgvEO+cdfCdsiHt27jnMXZ329eem2wSrFyvabr/Oyuqa/fMl3PFomEM38irtF8upvRcCuDs3k3lB9QV21HHMAoHa+wF7arXX/0jTVo3WD5ATyWTJiNGJwaCaN4qAL8VtSbfsLwdKLZvxHSFCLkwAnsNvj9AEXiPIVSWUpPtiIALjJXuR+AzYv8R6ve3RmRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH0PR11MB4901.namprd11.prod.outlook.com (2603:10b6:510:3a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Thu, 16 Feb
 2023 17:52:39 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 17:52:38 +0000
Message-ID: <b0b2ae77-3311-34c8-d1a2-c6f30eca3f1e@intel.com>
Date:   Thu, 16 Feb 2023 18:51:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 2/6] net: ipa: kill gsi->virt_raw
Content-Language: en-US
To:     Alex Elder <elder@linaro.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <caleb.connolly@linaro.org>,
        <mka@chromium.org>, <evgreen@chromium.org>, <andersson@kernel.org>,
        <quic_cpratapa@quicinc.com>, <quic_avuyyuru@quicinc.com>,
        <quic_jponduru@quicinc.com>, <quic_subashab@quicinc.com>,
        <elder@kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230215195352.755744-1-elder@linaro.org>
 <20230215195352.755744-3-elder@linaro.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230215195352.755744-3-elder@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0093.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::7) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH0PR11MB4901:EE_
X-MS-Office365-Filtering-Correlation-Id: 18accf48-a269-4e84-7566-08db104697d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5P1xx+wIzudnxbjRAeusqCw9rk7/v/NLvu0Xb9WZQL69GjD1ieuFEdlaVwspewVMd5UNcONjCHCP19QxaLezBQmuB7JrBrEtQ0JclNha3HshLHCTpsX+f7xJV46Lq/Y4z43Ua/xilbeMx3RNKawGggtSD70qAFIYuah/p8nXj8sCMhC+7+iRUwhH2CVGW8JJaRsyWNjq17eSIgSKepw840w12VZBaEHk+OrPyWEkDJS7gW0k/X/ete9DDKITqoHzqyw6obdjLgaotBAQ04ryhAhmLuWMjTfqaSFaNVd+nBa4RQE2n5TdX1jDMw+hKdeinHAACdkimmZSh2cNopdYvAveTwii+3vojXIbxSYglnwzsV1eseJSeUk7sxSvXqffxbFmZFvLIm5yNpDvPKNVvgOgm5HQ7O04i/OiWFjXZOYL2zAR8yA9XP/bAnIszm84fpmvT07Hi/ExK+1RJ+AhJb+ZKcRjQAStVihaE7+V/PAazr5C3LiumobtoPULb9hlpMZskOTNBK4rgQeTSIhPtVS/ubrTIMuEqIP48GDvKWifzcehHgmfwxcx8towtYCtMVDZm9U0lYxBMmXQg8zxUt2set2AbRws6lBxt9I0vV3u+OrnjPC4IgEtVWPO/IYqSR8hXt1lr6wwGzD+wmBVUUlSfTDhI1VNoXDTFCxlP7vfMh8y+b54FZoce7Dml9jB+Kd/zsM7G+JxGhj3cgRZutOjLg9Q76JY57dZ0weWIic=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(396003)(346002)(376002)(366004)(451199018)(38100700002)(83380400001)(82960400001)(36756003)(86362001)(31696002)(8936002)(2906002)(7416002)(5660300002)(478600001)(41300700001)(6506007)(26005)(6512007)(186003)(6666004)(2616005)(316002)(6916009)(66476007)(8676002)(66946007)(66556008)(4326008)(6486002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDl5dFhZM1dyM2ZLN2xBeEVHTWVLVFc3eXdCWXNEMGpGRE4zcytMYVFsdFJt?=
 =?utf-8?B?d2hWdTRmY1dSRFB2N1ZaZFJzaG56QXRxVjY1a01wckxwWFFMR1NCUnVwMUNk?=
 =?utf-8?B?R1BxSnZHR2pNRE9mdE5tTWNYa2MyK2UzRWF1c1RsYnR2aXYxSEZualFoWGE4?=
 =?utf-8?B?Z0ppNDBSQXVpTFl4bkRhSDE4Sm1ONUZnemZmWmVFc2swZE1XYkkrSWttSnM5?=
 =?utf-8?B?cGs1aXIvY09MbXZRMFhvUXo3QWJQcWN5blJqR3RDTnIySFFkNk1mUTdPK0p0?=
 =?utf-8?B?bWVMOUFubENSN3VIS1lqS3BXSmI1QVQ3d2ZuNFVGaGZVWmU0aGhWaEJLRmpD?=
 =?utf-8?B?aXhHOHo5SGc1Smw0UEVRZkxXL0ZmZmFWWXlldlRZRWIwcDlXazE2Q3BoV0Q5?=
 =?utf-8?B?akVqMUMzNG9sTnlKNy9HQTV4VXQ4REY5RXBMRXhsNzlzSFdxL0ovN2s1MU1o?=
 =?utf-8?B?TDZSMXpuOW0zd3lyR01XNDlJbFlyQXYva3J4aU43OXRNL3M0QnZKbnRURkJy?=
 =?utf-8?B?N0diL0xxN2I0ZTZaQ0pRcjdDOGJxTXBlVWsxVENlRWErcUplMW83YzJjSkxh?=
 =?utf-8?B?VVZDTGFqQmd5MUZaZ0FGaDB6dW5rdE9ITGVjNTdMSFlJeDB1cXdwMzR4akZ3?=
 =?utf-8?B?c0NxZDErbCs4aWlWaDh1d2s4T0ZoVnkrQ1JQaDg2cUo3QmFQa0FiMHlTUTVt?=
 =?utf-8?B?eTZxZklabUZQa1oyWUt6dzUzbTRJbkVTeWowZmdtdE1OVHFzdWdFdG00OFg2?=
 =?utf-8?B?RnNITW1ybUcwN3IxZjVTK2pmc016WVBGOGhDQXB5UEQwT2FIMTM1enBhbDNv?=
 =?utf-8?B?alg4V1VicFFTNlAyd3BCZks3amJLVVIwbTJJb1Q4OFRWQno4N0JJWnU0Q3Zu?=
 =?utf-8?B?RWd3V2VJRnc2eXlGZE1QeGZqVGhpdG54Zzg2WWtDcmsrOUw2bm1nMzV4bHJ1?=
 =?utf-8?B?MjFVTmNmbWZXeHRXdEFPZGZaM1VhVTF4VENWMk91N0dzZFpPMnRSNVZIZVUr?=
 =?utf-8?B?SExYZURySUFveHNPVTduWHlLOGFiQWJpVi9zYXFWaS96MGRoM0hBMFBIbUho?=
 =?utf-8?B?a0FKN2IvaGNxVkdKOGliZ3RMMHpxYWtWeElBYzVYN01QQUNiUEZYeVhRdE4z?=
 =?utf-8?B?NjlLdXVRVVdQRi9UUGJIWi9jWFNobDZMbnNRSy85Z2Jtc1B6MkxlcDJGaDRI?=
 =?utf-8?B?WHA4R0dBQmtWS1NQY1VBMXJRTmJ5MG1BU09pd0RyME1TNHJRbzZMZWFUNE95?=
 =?utf-8?B?YUhaWVExY01JZ1k3VWlUeWcrOUpSV2NUNGdGeHZQb2NaNGxDanlaOExuQ1RM?=
 =?utf-8?B?YTF0ZGVnZjU1SXhTcWVBNENMVkwyZXZ5by9sWEYyYy8wQ2VYNWhCV29ISW56?=
 =?utf-8?B?VGh5T1NvQnA2RWxHYVNtOW9FL3kwbVRZWllnRlpnWkZqT2IvTEQvU0tqeXVv?=
 =?utf-8?B?M2psVEJCNHBJSGRBUWd6b3k4VzU0aUo1RVNUUGFjbkR3SkN5czBEOWZZdVE1?=
 =?utf-8?B?TWgxNlNEdS9meWt2YTE1bm51SCtGdHRIdzRUVVQrNCtqSVFrcU5tL0dLT0g0?=
 =?utf-8?B?M0p3eWNoTTBMTGNpYkpGQWFrd0RPdktOUTlJUGFFU0JwM05PZ2EwVnlud0hK?=
 =?utf-8?B?Q1lUOEN0L3k4K2gwTmsrR0JIZTM5eE1XUFlpMGFCK29NMlVycmtJNnhlZTVu?=
 =?utf-8?B?U1BiTFFpeFhuMHZBeEU5R1pNTEtJNUVSRU0zT3pEc0NaM3ViZjYvVThIY1hX?=
 =?utf-8?B?U3Z3cVk4Z0l2M3hrWGJGSFlseXYyOVpURjAyNGhxOERQQ0FubG42M1lvWHg0?=
 =?utf-8?B?NWc5em1iOWhscW5EY3RvQUIzc2lLeWYxSkRWVVQrbzFhK2tqR2E5anhwWFZR?=
 =?utf-8?B?ZnZLVkw5OU9UTXJ3bndrTVNqZ0JCdjlQck5yWGs5MHlJVVc5Zld1SHJYY3Rq?=
 =?utf-8?B?Mnc2b1FpejkrQnlSb0NLMDJWR2M1THF4WXFKWDluM1RyQ2U4VTgyOEFRZnBY?=
 =?utf-8?B?YkxCNFZ4MkxyT3NETFR4TzE1UUFqeThEYjVmbFRBR2xzbjhZS3NDVkJCZmVI?=
 =?utf-8?B?cGU3ZnBpUWdrSXFyYUhjNzRNbXlmMjlsVlBwYVl3dVBBbkR0WTFyWWE0d2cy?=
 =?utf-8?B?UWlIcEcwL1gyQ29HQ1VRTTM5STNERjZlSUxocGJvNjQ3Z0ltRSt1NFdZQ3NT?=
 =?utf-8?Q?wzqArLW2i7y4foYwKLQj8hI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 18accf48-a269-4e84-7566-08db104697d5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 17:52:38.6817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QFlpS9j428cfcA7dsoZLiS403UsCjzDuTRUQLUX/blr8YFQ/vnG5F6z8pSYahhYcpo7ZFiFdvONviDxXsd21abEHc51WjuN6Ml6TlXJqCwM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4901
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>
Date: Wed, 15 Feb 2023 13:53:48 -0600

> Starting at IPA v4.5, almost all GSI registers had their offsets
> changed by a fixed amount (shifted downward by 0xd000).  Rather than
> defining offsets for all those registers dependent on version, an
> adjustment was applied for most register accesses.  This was
> implemented in commit cdeee49f3ef7f ("net: ipa: adjust GSI register
> addresses").  It was later modified to be a bit more obvious about
> the adjusment, in commit 571b1e7e58ad3 ("net: ipa: use a separate
> pointer for adjusted GSI memory").

[...]

> @@ -142,27 +127,17 @@ int gsi_reg_init(struct gsi *gsi, struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> -	/* Make sure we can make our pointer adjustment if necessary */
> -	adjust = gsi->version < IPA_VERSION_4_5 ? 0 : GSI_EE_REG_ADJUST;
> -	if (res->start < adjust) {
> -		dev_err(dev, "DT memory resource \"gsi\" too low (< %u)\n",
> -			adjust);
> -		return -EINVAL;
> -	}
> -
>  	gsi->regs = gsi_regs(gsi);
>  	if (!gsi->regs) {
>  		dev_err(dev, "unsupported IPA version %u (?)\n", gsi->version);
>  		return -EINVAL;
>  	}
>  
> -	gsi->virt_raw = ioremap(res->start, size);
> -	if (!gsi->virt_raw) {
> +	gsi->virt = ioremap(res->start, size);

Now that at least one check above went away and the second one might be
or be not correct (I thought ioremap core takes care of this), can't
just devm_platform_ioremap_resource_byname() be used here for simplicity?

> +	if (!gsi->virt) {
>  		dev_err(dev, "unable to remap \"gsi\" memory\n");
>  		return -ENOMEM;
>  	}
> -	/* Most registers are accessed using an adjusted register range */
> -	gsi->virt = gsi->virt_raw - adjust;
>  
>  	return 0;
>  }
> @@ -170,7 +145,7 @@ int gsi_reg_init(struct gsi *gsi, struct platform_device *pdev)
>  /* Inverse of gsi_reg_init() */
>  void gsi_reg_exit(struct gsi *gsi)
>  {
> +	iounmap(gsi->virt);

(don't forget to remove this unmap if you decide to switch to devm_)

>  	gsi->virt = NULL;
> -	iounmap(gsi->virt_raw);
> -	gsi->virt_raw = NULL;
> +	gsi->regs = NULL;
>  }

[...]

> diff --git a/drivers/net/ipa/reg/gsi_reg-v3.1.c b/drivers/net/ipa/reg/gsi_reg-v3.1.c
> index 651c8a7ed6116..8451d3f8e421e 100644
> --- a/drivers/net/ipa/reg/gsi_reg-v3.1.c
> +++ b/drivers/net/ipa/reg/gsi_reg-v3.1.c
> @@ -8,16 +8,12 @@
>  #include "../reg.h"
>  #include "../gsi_reg.h"
>  
> -/* The inter-EE IRQ registers are relative to gsi->virt_raw (IPA v3.5+) */
> -
>  REG(INTER_EE_SRC_CH_IRQ_MSK, inter_ee_src_ch_irq_msk,
>      0x0000c020 + 0x1000 * GSI_EE_AP);
>  
>  REG(INTER_EE_SRC_EV_CH_IRQ_MSK, inter_ee_src_ev_ch_irq_msk,
>      0x0000c024 + 0x1000 * GSI_EE_AP);
>  
> -/* All other register offsets are relative to gsi->virt */
> -
>  static const u32 reg_ch_c_cntxt_0_fmask[] = {
>  	[CHTYPE_PROTOCOL]				= GENMASK(2, 0),
>  	[CHTYPE_DIR]					= BIT(3),
> @@ -66,10 +62,6 @@ static const u32 reg_error_log_fmask[] = {
>  	[ERR_EE]					= GENMASK(31, 28),
>  };
>  
> -REG_FIELDS(ERROR_LOG, error_log, 0x0001f200 + 0x4000 * GSI_EE_AP);
> -
> -REG(ERROR_LOG_CLR, error_log_clr, 0x0001f210 + 0x4000 * GSI_EE_AP);
> -
>  REG_STRIDE(CH_C_SCRATCH_0, ch_c_scratch_0,
>  	   0x0001c060 + 0x4000 * GSI_EE_AP, 0x80);
>  
> @@ -152,6 +144,7 @@ REG_FIELDS(GSI_STATUS, gsi_status, 0x0001f000 + 0x4000 * GSI_EE_AP);
>  
>  static const u32 reg_ch_cmd_fmask[] = {
>  	[CH_CHID]					= GENMASK(7, 0),
> +						/* Bits 8-23 reserved */
>  	[CH_OPCODE]					= GENMASK(31, 24),
>  };
>  
> @@ -159,6 +152,7 @@ REG_FIELDS(CH_CMD, ch_cmd, 0x0001f008 + 0x4000 * GSI_EE_AP);
>  
>  static const u32 reg_ev_ch_cmd_fmask[] = {
>  	[EV_CHID]					= GENMASK(7, 0),
> +						/* Bits 8-23 reserved */
>  	[EV_OPCODE]					= GENMASK(31, 24),
>  };
>  

[...]

(offtopic)

I hope all those gsi_reg-v*.c are autogenerated? They look pretty scary
to be written and edited manually each time :D

Thanks,
Olek
