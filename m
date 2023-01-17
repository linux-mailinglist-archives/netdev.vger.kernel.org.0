Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBBFE66E831
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 22:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjAQVLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 16:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjAQVJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 16:09:24 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA501F487;
        Tue, 17 Jan 2023 11:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673984114; x=1705520114;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AXcJSZehasHV7V5RMT3wteWiPBkSmKd8ANsFlDQZYxU=;
  b=jkvjQuesAa+u9nyWHtL0gBm32W3SBxm62WofD4BLSo5scRB6Du10qMCj
   OmmbU3H6ty6H0pCwflIH9DuKjAnQNpyRaFCHTZQOTnv+NNudCOwELshf8
   YsCpGdOFB5gWRquQRP7+/Iv49OwQm/BxY0gZGV510WivsNx1liC1d+88Y
   xgmPxcM2osvNkQbYi/aBgnR/I7isu+TkBzDSJNk7lFVxDVgp6FBBeqOM3
   9z2L1g2x21mEEtoR6lnmeAG6vXECd0Okh+PcMijrHQ8FV4qGXW9wtD7HQ
   Zh1QmU0YyqDUQSJ2iuvv3H4cvIQz53Y46hEWnmW+/1cdCBZrU8OuNoCG0
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="326870783"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="326870783"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 11:34:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="727892201"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="727892201"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 17 Jan 2023 11:34:55 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 11:34:55 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 11:34:54 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 11:34:54 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 11:34:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kg48naTDkV8iDINqWwCJCIKcZZIwwExxnTnk2tdoK1RbJKXbrvrtv3GaVeUtj6rIH7UiuYnbRsAEfhYgqGtkU2p/4c4Ktl7LMKlcPqYOPJTKBVqTmRMqkaQ/edJl2MEqtfnHtwyqrd+g8zJfqIpmWXS8z4TWy0wbMUdSOPPwUrf0FfvRaxwMIN39SH4ev7+x/RWXdp2BivdPv1S7sownPBdU5U+b9USLq62akG3wAwcpce5zAJ0dV1xotBCUk/jJK96+bP35GpK+sbRrHb+aWnnq79+CZnIYf4fN4Xp4dqGkwEwsGPo8fXReUTwsGyBbIKEV/lAdjIWYNmO1liXVcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2W1FDYuvss1aVNatPuW7gkvf/ipluQC2DBLDHb+NqVU=;
 b=gyYFB3zstsuraM5/53GkCFq6szWCVndxKkm9xDvBcHhiY4phSa9f8QfPZV9cBVjg0yJpaYj/gq1jpLpJHhQPdTg/euWqkiR/NxqT7JPMDWIh3vuKNPZ0hqd71syXYfaLITNZdtdHfy/cM7fmDy6xKCF8hUvmObkWDxCHvAklA40aRj+PDqawpbYWg7yrIt3DVq8FDNzr8aVuc2vElLoH6MKTE68jQWsXix57Bwq6mFNSvLO5Ar6+OWs+X24oUNhMlPz2/LRqisJeSRHWFk1jo+iH5rG+JUgZX4sb+pu5WYZH5in7qB/yHHxhRncdhERg4xE2ugQLBiPijJ2YdkuX8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB6127.namprd11.prod.outlook.com (2603:10b6:8:9d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 17 Jan
 2023 19:34:51 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 19:34:51 +0000
Message-ID: <9f29ff29-62bb-c92b-6d69-ccc86938929e@intel.com>
Date:   Tue, 17 Jan 2023 11:34:48 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] e1000e: Add ADP_I219_LM17 to ME S0ix blacklist
Content-Language: en-US
To:     Jiajia Liu <liujia6264@gmail.com>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20230117102645.24920-1-liujia6264@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230117102645.24920-1-liujia6264@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0021.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::34) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB6127:EE_
X-MS-Office365-Filtering-Correlation-Id: c15e16fd-5933-4685-5688-08daf8c1e706
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P/oYMccYc3NWRC7uYvLq7UYbabJjNM7aRLFbRE8daSFBA8TNLkPja6NFHMII49pWgi2S4VNJpToZFT2nraBpwNscNjdSmIkiCGGHeHFO/JHY/XMTe+BkAgXpFAOUiRofBxeut1R9+KcPtna1iBfAxGo4q7sI19H7ZXzHr0Zv1noiyoNz7XQu7cbM48vX9uTBF1fMtIu95Q+IuIqWQAOedo6yYolpKj+MwM8WzbbHqWKaQ9Y8/9KREh2ottlXjho015ZBfc+gQQEyNDjbN+IeGvtt12igp0gvTYhaLqVMXbQodGuh3ES5R0qBUaHsxjfJaSYGVSGxcE5+DtrIIYsH+bjr8WBNope/NHJij/nJQYDpuEdfn0r/5KVM3NgH1xZfGrOdpl02d6kcv15rvjGaVC1boroX7BhWqbUrjYd37ICsUpsPg2KJCl+v7zBSsangI4Po+Fwd+tM3UHpkdULpvG3dh741b3nl2NjQic/e3yv0xbZ93Q5MC2kGfRpXlQ4rN0FEeR70hV4gUyEMeXa34sjIUYIYz/mXKE/7Y7vAC0hnf/2w7xJDlHx3z5h7s6jaM1JJZ9u6QMVcKzUgqg403xP/pjO6SfSv4Q/BbN42GHRgb9aKEpM113SY1PerTdwntVbhvKG134dlLaMmPCrXiVXuJhnbweLkC8O1FptZtNFoLSf1m6zz1M58wIKDAdg+QKK/DcwcxxGf2WVgD52l3VXy3NbZvIwpw7/9MtjnmR0P6OOJW0iep0DcKtvMQkx6L40TyNJpBuW7Qw5pafGmW5mkrrCACQ1xpbzMS64ez4I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(346002)(376002)(396003)(136003)(451199015)(36756003)(478600001)(82960400001)(31696002)(316002)(966005)(2906002)(6666004)(53546011)(6506007)(2616005)(83380400001)(6512007)(186003)(26005)(6486002)(86362001)(66946007)(4326008)(66476007)(8676002)(8936002)(66556008)(41300700001)(31686004)(38100700002)(5660300002)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aU81Q1dsenBoQWx5T25uMjdXZ2lnVGs0Z3FkZThQMWFqSzBHdlpiU294VGVl?=
 =?utf-8?B?L1JmbDlWK3pCclhFeWVkV1lqbUlNb3FvTmRlZlhKNGNrR2tpZjlPaTQrQ0RM?=
 =?utf-8?B?bUFZRE9VZXQvbDhjZHJJL0RSVjVwUnh2Y2l6TGlHbnJrbkpDZTNjWndnSlVW?=
 =?utf-8?B?djIxT0Z0ay9uM1drNXRSZWZ0ZFlXSXZ0OGFBMklZK0k3T1NJNUJHbXRtT2Fo?=
 =?utf-8?B?QnNwWE5XWGpIcS85bW93dWRiY0l2OHFKVFlqYS9BSVBTeDlIQU95WmxKTEhY?=
 =?utf-8?B?MC9rSG9zck9XdG9JTFAxRVIzRGtzSFRiNXo1Z0RoSUFDNnpMUUxQcXV5QUdY?=
 =?utf-8?B?c1M3VmdqbDFiZVpIUFdkeVE5UDJwTkxtdGlYY052Q2t5dHFHRTVJWmpRdTRp?=
 =?utf-8?B?TEJYREg5c2d4TzJJdnRXL1hHUEJpUG5VSGRMd1VxSkprSmJuUlFDNC8vVTVS?=
 =?utf-8?B?QW01OWxiQ3NJZFFUSmRvdFg4QjIwTS9tOWIxa1grbjJRSlNBZTZQYndRbkhM?=
 =?utf-8?B?bmRvZVo4VHlHWHY4MVR0OStvNFQ4QlVTNUUvZGNPODRQWllQT2RsaVc3VGxv?=
 =?utf-8?B?R1IrMGtMaHprZjlmWnN4NkZTT1NHZ3JSRHp6NWgydXcva2hnMUVFWTNrL29X?=
 =?utf-8?B?bW9iRlZWT2xyVW01bEdiM0pSZ3dMNUdUL3J1bDkxbzJ6RVI0VEgxQStOQXhu?=
 =?utf-8?B?b05OOUpiN3VxVFFhaXByeDF6OUt1aFFJWkdRMHk0NDBaeit4Mjc0TDJBbnNz?=
 =?utf-8?B?RklveWoyRVNsUitSN1RRMm5KaERsZjNQWUtiVGJ4bW9VVlpwdWZaWDRpZDJp?=
 =?utf-8?B?ZUtldUU0STNMMFVqV3Z3bHJGVHBQVDVUSFZCYTViWkQvL2tHVW93TlVJdjZ6?=
 =?utf-8?B?VVNqbHZOTnFoRFVIQm8yazBSa01CQS9LaW5uN081aE5nWjBjRjBWbGtSZks1?=
 =?utf-8?B?WGJWVWNDdXpIUVBQTGg2dTNQYmtGZFRvTEw5bUREZnNyMVREMjZvbXRHNDZW?=
 =?utf-8?B?Qk50SnYxVkNWZFFtbVg0ZWZpcHlKQnJncmZpTjF6Tm1Id3JFQ3F5N0RGaEdW?=
 =?utf-8?B?aGNlV0VtTzdqS3RsamY3YTA2S21IM0wxMXBBcDNUZW55dWJzelA5VE1DT0xy?=
 =?utf-8?B?V0NiVmNKR2tpY2lSeFpQK1VkMTR6cDJFME1YSmtlUVlodTk0MEgwOER1WDBJ?=
 =?utf-8?B?QUEwNnQ1VWNtc25GMGN6c3kwbUFnY1VYWnR5Skw4cjR6UTZ5NTNJWUlDVVFS?=
 =?utf-8?B?RDNyT0NyelRYckR0enNwNWh5b0xDeks5eHhjTFFwQVdGM2k1dkxLSlZqVnlu?=
 =?utf-8?B?bHVrWFIwUmxmN25nenhjMEVUVUF2WGlqNHVjMzlndE9nSi95dmlodFhjQm9t?=
 =?utf-8?B?QWpzRjlERlNtRWVRYmFYdUE5Nkg2cGtwSXkwZDNQSkczY0NZcE0rNmE1dm54?=
 =?utf-8?B?alZRdCtSak9jckpORno3TEJ5M0gyakYrVk5uYi9NUGNhVTBjL2ZjYVpEVFR0?=
 =?utf-8?B?cVJwc2JwakpPL3lhWUpid1JkamViYmVRZnlrendRa0R1a2tCZDE0OEp4WkZD?=
 =?utf-8?B?WlkrakhtZGFnMUgzZE1BaGVVM3JiRjlJWGdXSkJ1WGZKRTVSVVJPWW4vZEZh?=
 =?utf-8?B?eUppT1l3V29qNkVOVk5BY1FyVkhRMHdadXlOQlNYNVl3OXhVclRCeEs0Z1Fv?=
 =?utf-8?B?WU9LS09jRXYxcDcvcmhGekpaWWpWT0pkL2dTRFR4MTZGWUovTTEzRmQvWTBE?=
 =?utf-8?B?YjF4aFZrVDlZcUFhQUt5cy8vMWE5YXg3ZFFhRkowTlh5cWR5MnZiY3E3c1hk?=
 =?utf-8?B?cWUrbWs0UjBRRE1SdDBtbDNob0dqVDJLb3dvVFJVeDNJaE5meHpTT2R6K1RC?=
 =?utf-8?B?b2M3UnlrU1NrZkxjRU5PMlRGTmVub3dWakFBRXhrdkRnbCtpc09wbnFhYmU5?=
 =?utf-8?B?c1lJQXN4SW9PWTVwV0NGTENMazFIRCt1emVGSzh6VjlNa2IxUmZpUWpFY2Jp?=
 =?utf-8?B?MnZTNmF3MUxBV2JCSFNlVXRMNzQ4Y2hLL3RPL3oxQUpNK1ZaTmkzdXZRSjVN?=
 =?utf-8?B?NExXNnNYdnB0Zkk5T0NId3lmb0xoR0tJWHVCVFF0OEJielVEY1pIamZFWWNr?=
 =?utf-8?B?UHFQL2N0MFhsVE5leVNESi91WS9Jd0I4RU85VUtTeE1FWlFITnlKVnlMY1c0?=
 =?utf-8?B?c0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c15e16fd-5933-4685-5688-08daf8c1e706
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 19:34:51.6237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /++/hWwwtsG5h8AMuKf/oogFmKjtZ0hSte20FcBxghZHOKMHWH47QU9NTXPhKvm6+0teSQI8plnoU9+SSBqbSBn1gzKEoaeKAbEKg/XMM34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6127
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



On 1/17/2023 2:26 AM, Jiajia Liu wrote:
> I219 on HP EliteOne 840 All in One cannot work after s2idle resume
> when the link speed is Gigabit, Wake-on-LAN is enabled and then set
> the link down before suspend. No issue found when requesting driver
> to configure S0ix. Add workround to let ADP_I219_LM17 use the dirver
> configured S0ix.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216926
> Signed-off-by: Jiajia Liu <liujia6264@gmail.com>
> ---
> 
> It's regarding the bug above, it looks it's causued by the ME S0ix.
> And is there a method to make the ME S0ix path work?
> 

No idea. It does seem better to disable S0ix if it doesn't work properly
first though...

>  drivers/net/ethernet/intel/e1000e/netdev.c | 25 ++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 04acd1a992fa..7ee759dbd09d 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -6330,6 +6330,23 @@ static void e1000e_flush_lpic(struct pci_dev *pdev)
>  	pm_runtime_put_sync(netdev->dev.parent);
>  }
>  
> +static u16 me_s0ix_blacklist[] = {
> +	E1000_DEV_ID_PCH_ADP_I219_LM17,
> +	0
> +};
> +
> +static bool e1000e_check_me_s0ix_blacklist(const struct e1000_adapter *adapter)
> +{
> +	u16 *list;
> +
> +	for (list = me_s0ix_blacklist; *list; list++) {
> +		if (*list == adapter->pdev->device)
> +			return true;
> +	}
> +
> +	return false;
> +}

The name of this function seems odd..? "check_me"? It also seems like we
could just do a simple switch/case on the device ID or similar.

Maybe: "e1000e_device_supports_s0ix"?

> +
>  /* S0ix implementation */
>  static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
>  {
> @@ -6337,6 +6354,9 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
>  	u32 mac_data;
>  	u16 phy_data;
>  
> +	if (e1000e_check_me_s0ix_blacklist(adapter))
> +		goto req_driver;
> +
>  	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
>  	    hw->mac.type >= e1000_pch_adp) {
>  		/* Request ME configure the device for S0ix */


The related code also seems to already perform some set of mac checks
here...

> @@ -6346,6 +6366,7 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
>  		trace_e1000e_trace_mac_register(mac_data);
>  		ew32(H2ME, mac_data);
>  	} else {
> +req_driver:>  		/* Request driver configure the device to S0ix */
>  		/* Disable the periodic inband message,
>  		 * don't request PCIe clock in K1 page770_17[10:9] = 10b
> @@ -6488,6 +6509,9 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
>  	u16 phy_data;
>  	u32 i = 0;
>  
> +	if (e1000e_check_me_s0ix_blacklist(adapter))
> +		goto req_driver;
> +

Why not just combine this check into the statement below rather than
adding a goto?

>  	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
>  	    hw->mac.type >= e1000_pch_adp) {
>  		/* Keep the GPT clock enabled for CSME */
> @@ -6523,6 +6547,7 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
>  		else
>  			e_dbg("DPG_EXIT_DONE cleared after %d msec\n", i * 10);
>  	} else {
> +req_driver:
>  		/* Request driver unconfigure the device from S0ix */
>  
>  		/* Disable the Dynamic Power Gating in the MAC */
