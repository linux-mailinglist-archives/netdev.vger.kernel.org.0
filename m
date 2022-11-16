Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30DDC62CECE
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 00:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbiKPXfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 18:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234502AbiKPXfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 18:35:15 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524EC69DE3
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 15:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668641686; x=1700177686;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/niAwE4qRlaX81ziSDyhHSCx27dLh2RWagP4t6IfcT0=;
  b=GbTwXINIbfap7ctxV+LmsVeguWinRoP2ugnhzUSiAj5fWGKRcYdq29bo
   iTHlOH58oqP1e/nh1WEGxCDDnenNDGlU+PdAJDdWWeJUdokde9gBW3V4B
   qYTbUXVOgw8DNSkO1CHf8fHnbjWA9eN601oaMYUZn7TNeREQ5dnFaEvLW
   4oj+O6feU8GYDAnZSo+7+Sy/2hW79ZvUK2vlibrO+9owX0sbwn8+qXIW5
   8NgKCye1dMflZGAcQjGHO44At+fgwyUH4Xe1IJO2x9e3HMKmuA/Vj3Is8
   ntNMcwidW0/9F3XXyX04mdC7L+hhYxWgUGIXW7Y8v3mckgtWovR7zO8GK
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="398985368"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="398985368"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 15:34:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="708370100"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="708370100"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 16 Nov 2022 15:34:45 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 15:34:41 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 15:34:40 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 16 Nov 2022 15:34:40 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 16 Nov 2022 15:34:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMwYYIdn9WQwtv88KUZid8I7uSjm+6awsY/SVncFZ4/JV4n9erUbSSfL9RwPOBopr6Jb5jPTeyb5EzAw8FNIqJzclKQwyTrRukkAWbwRVGysWKuPcJMY75ux3jhULnsx7w6teUmKhlC79ZRaGAZcjNedZvKSIr/ANXUILtXHgNDWpG0KtLYsY86P9J/FE0oxTgTjvO1tSEUQWmrXF0N0kxDE/+UdPZNlCk+JDV3Nmx0r/QsggpCvv730b3BS6TkIh+PwPoclgvepZ+MXvwHwgJGEJ1guvzOwGrfHypL8XfkHfuH8T8wi8WzGDp7plynO8gVR/TPtD18OUdXmySBYIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yTj58kv2tIVeFDv3dtEl+3qGmRFann+TYB6O94R3VaA=;
 b=CWW5zCDXGWJjeGYAp2MGoETKR4tIoYyffbhwKZOrrjLEPelRMb8BrAjhYESaiMlCnLrnKbh0uACt+Y5Y1a2b25PsqJlBTFDE1v+HA3cbNSw0rJMBXu3Ijy5Hkdy3kItLIPYfNuj0M9e1oatHz6W3ul1LnVo+5I2Tw+EM9237HJiL1J+KyyIBKHD7Nz8rBX5HXobBXE2rAmbyVHYG0TA51ZGdINMdQM7OvX6UJqXMwnaN0pH6vh+luMVT+WvjDRS597wWjx12tJLHAGWztG9EbLxMfbQybWXc+jbGwLWoiqI931ZIhGPHkrjpC8KeFP4qPTnxoBWSgqEWs3jY+5Flvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4852.namprd11.prod.outlook.com (2603:10b6:303:9f::10)
 by DS7PR11MB6127.namprd11.prod.outlook.com (2603:10b6:8:9d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 23:34:17 +0000
Received: from CO1PR11MB4852.namprd11.prod.outlook.com
 ([fe80::9c6e:32f0:ef8c:999a]) by CO1PR11MB4852.namprd11.prod.outlook.com
 ([fe80::9c6e:32f0:ef8c:999a%4]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 23:34:17 +0000
Message-ID: <8d792d9e-3f58-51c4-0501-325b0f07e716@intel.com>
Date:   Wed, 16 Nov 2022 15:34:15 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 5/7] ice: Accumulate ring statistics over reset
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, Gurucharan G <gurucharanx.g@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
References: <20221114234250.3039889-1-anthony.l.nguyen@intel.com>
 <20221114234250.3039889-6-anthony.l.nguyen@intel.com>
 <20221115210239.3a1c05ba@kernel.org>
Content-Language: en-US
From:   Benjamin Mikailenko <benjamin.mikailenko@intel.com>
In-Reply-To: <20221115210239.3a1c05ba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0046.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::23) To CO1PR11MB4852.namprd11.prod.outlook.com
 (2603:10b6:303:9f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4852:EE_|DS7PR11MB6127:EE_
X-MS-Office365-Filtering-Correlation-Id: c86b0bc9-5425-4130-1639-08dac82b1443
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s0wLW/MSFV+77NhvdEqIBfIE1PW6+yt+3/8sE0hFt5NMHTJdpO+FBYoPaWVBRFI5RnN2mNbt/ie2Zlr/qfk3pv8xNY3h2kbSjk2+cHb2IbKcj7N53kvSgRbz4ty7n4VexRO+WlxAeoZT9gsswBQikAyQFB9QWBtwGsPVMfghNCif0YbiYyz0W8erKlNgFam573ZLLgq+JgdxI9c4kaoDLj5epgD3891RN4AxddSKFQ5szMOvh7brRSg+ku2FXu+QhuxxLxVOApOTU3Db9kuTYxbDbHwY/c5suJndtTb2k6pc4pV1LQoite3Hy16aYBTj4cDv2K0iolMJECbojeh7i5x58dltl1oIhz6Og1OoOH0gh1IjSIwIKghO8RY2EmUYn2oRNyBSkmd6Zfr0OikrSD4vXkO18a5ilfIwAKfHAZwe3e6xL3j3902ZePnTUbZYjCu+RBe7AHZpL5i909PGL+WqpjDFPuJI3jFASGkKo6XW+pkPUMVqV0FY6N0AhPIEezI4qoqTHHRaYZNI966O8JscVdtc9ESCp/3pMMHppNLs0Ezk17iWCNEh3vxiHSR9iINKC2tQrBDL6EIgMF3BbPcWuNM925AsmjNg0daWaQN960UNmXDEJtCaAKBomQZf66EjS9H7wJAXSsel0E629U1RpmKnFqlBtS3MtZ4G2yYY9EeYFHW/e1ZcNijJnc0QedRWqeVl+lmYKuCDgLUgByLdzbAJ3oYdutwxqe9VC2OCtmAQnXm7xHfHBxoNV4J0YieljGFuy7njr7wUaWc32hhfyZbhvP+xuCWviRGVqXs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4852.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(39860400002)(366004)(346002)(451199015)(31696002)(36756003)(86362001)(38100700002)(82960400001)(6916009)(54906003)(316002)(6506007)(31686004)(53546011)(6486002)(478600001)(107886003)(2616005)(5660300002)(186003)(8936002)(4326008)(66946007)(8676002)(83380400001)(66476007)(66556008)(6512007)(26005)(44832011)(41300700001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnhBOTNnWCthdHR2cVJscUxpMUhXeXd5ODVwVlRvZVRQSHR0ZC9ERzNLaHZK?=
 =?utf-8?B?K2pWdEVRUVZvdEg3SUFnVG80RjkwN3FLejhzLzlJYWxVbC9UTXJtQWVoamxL?=
 =?utf-8?B?Rkl3NHljVXBnK0ZJeERoeTVzRmdoMmtJc2VJdEZSQmJ4NUxBc3dERjZoUTM4?=
 =?utf-8?B?WGdJaVJnVUZmd3Njc1ZVcU1VOGhqRkRIUzhLQU5xNndteUpsRWVuZ1VybFJY?=
 =?utf-8?B?N1BrTmJGOGlCVkgvMnVxeVIzc3E2U2Q1TS95ZDROdXB6aTNZZ3VreUdLSm5l?=
 =?utf-8?B?QUFiRy9pak8xN3g4c1RyNUJsaEVPSHo2QnR4RytKaGtGZUUvemR0Z28zTndX?=
 =?utf-8?B?bHdiV1o3aElBcTFNdUtENGR3ZHBLTHFMZmMrQkZ2RjUwUUpzT0dDWTFtamQ3?=
 =?utf-8?B?VE0yUStYblZZeS92N1I2ejQ1ODNtRXRGYzM4bTZadDBzczBPNDdaSTFPa0pE?=
 =?utf-8?B?WDNuaVJIU2NmMlBuYVA2RTJldEZCVk95T2dMU1NjelBlaFZ3a3JxSmphNk9x?=
 =?utf-8?B?bzlSWjhDVVFRNSt1WnJscE1nS21XSkdnN2kxL0wxR0Rac3hOVmFLZkR5SjZX?=
 =?utf-8?B?ZVNFUjJZY3ljdG9RQ3MyNXhacmZJY1o4djVkQ0ZpZ2tXWE45aytydCs3Ykhy?=
 =?utf-8?B?MWdiSUhVYzErYkM0cE9JNU5vME1vQjlSOXBSUnVqTVlPN0cvU3NFUGExbWt0?=
 =?utf-8?B?VFhBdTJWaEE4Rm9Ja1hVNWRoTHRrV3B1ZElmc1JyWGNkN0lEV1VDYnpITzFF?=
 =?utf-8?B?RWJFR1pyNHBwZjBaa0ozR2lPd1M2MEZ3TDdnWWhYOVVvZVNIOGhVZjgyNHZ0?=
 =?utf-8?B?KzU4d2RhTDFDaStQOGswVk5aaldZbElUMkNqc0t4aUZ5cUdNR0JtTFRVRjlJ?=
 =?utf-8?B?Q1VvbVlrQTByUjBlQ1BZaFVEeWlGVDhENWs3ckdyd0xjM1NVL2JPN1ovQ3FY?=
 =?utf-8?B?UTdUeGVOT0lpNDBHYnI0VDBaV21qdm1OcTFDdElYTEJ6L0xJVlhYVWhaQ003?=
 =?utf-8?B?QXMvY0JaYVVOSGVqZ3ZIZEpqeUZvclJFdzZXV3RsUHcvSlVxMWgvdisrVnZn?=
 =?utf-8?B?RVpCVVBTQVNHaTM3TGNMSHFOYnNOUXpnT2Y2NlRlYmVtV09ScjAyWHVJTHcy?=
 =?utf-8?B?eWVna1RWNG14Z2Y4WldMNEJuNU5yUWFkZCtUUWxaOGErTFVoR3pLUHY0QWRZ?=
 =?utf-8?B?cE44Ti9IT3pkTXhwK3dsRlh4Yjg1RWVNZndILy9HRENnUVVzV1drKzRMUzhv?=
 =?utf-8?B?R3lqV3RKWUlRdUo3aXREK1grM05wZ1JuMXhjWTBDQXZ5UTlQQWlUYktLVjNx?=
 =?utf-8?B?MWpmQ1NlWFg4L2d4dWdiSlh2WjI1RElMM3FZSmJxd3ZNS3V5WTR2TnVPTWRF?=
 =?utf-8?B?L3Q2RU9CRGo0MHBVYjJtd09BdzhWT0l2eDZQM2JER3UyS25kM2pCRjdJcEN5?=
 =?utf-8?B?SjdzRXVpZWh4OWdCZStNNWdBWmV6UmpWd1Q1L1NIOEtyL0RjSWloaXd6UHhF?=
 =?utf-8?B?RzM3UU9UWEZ1d1I5KzlXS1hQVUFhSlJER3R5a3Y4SG00MFhMenI5R3VUTzcv?=
 =?utf-8?B?emorU2JKdGhZMGJFSHhaYmZOODdpZGlwcDIvMHQrZzFYblZKZjNlQjhyMjRa?=
 =?utf-8?B?ZFl6L05HTStaOXBvWVJzb3krS01nbzZiOXBjeDJ3YkFzVThrWkthS0J6ZCsx?=
 =?utf-8?B?N2UxZ3RpeVM3VTZnY2gwd1RVeTNhYnA4czJLSFlZTklqenlScm02alZ6UTdG?=
 =?utf-8?B?czJSQkZjTUtudmlwZTlnNFRJVnhHb0kzRDFiTEdKYjIvYXNoZCtTYkt3OUdM?=
 =?utf-8?B?QUdWMk9VRnpDUlNnd0dXNUpJMldDQlNweDUxV3ZKVVNzMHQ1TSs1bzU0cm1a?=
 =?utf-8?B?YXhnMWNiQk1sUVE3MS8vdHo4SXBWdlpnMVZWRlQvOFZhS25aVFQxdXJ5cGZX?=
 =?utf-8?B?d1l4SXF3STBjenY1RjNjVDlzNlE0dDlGUm5ZVlpjdkdNUEZFZE95OXVlc09o?=
 =?utf-8?B?S1gvZ0JPUkM3WG5uR1p3Z0IwMExLN2cyZDhCWWxMdTJHZXpOd3pZbFZQN2RN?=
 =?utf-8?B?VHRKSGptTFRpdUlQWkhUeTNURFVKcnZjVnlpNmgrK0ovN0FRMUVpVGpnNFpK?=
 =?utf-8?B?ZmdoTko3V1pZL2tuM3hQN3Era2tjK1l3TVhSVzJZOWxoT2ZkY2FSL21QRzdH?=
 =?utf-8?B?eUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c86b0bc9-5425-4130-1639-08dac82b1443
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4852.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 23:34:17.6998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gcggxywOjfAsb8cKaYLPNqxtp5bYI8tLBbAYobd+4o8Vd3MzrhW7QDKoIaAk/6QmnGVgTeHJ+NxdzV1fm3ai08Q9WvwV9d2ijefMtsowIC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6127
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/15/2022 9:02 PM, Jakub Kicinski wrote:
> On Mon, 14 Nov 2022 15:42:48 -0800 Tony Nguyen wrote:
>> +static int ice_vsi_alloc_stat_arrays(struct ice_vsi *vsi)
>> +{
>> +	struct ice_vsi_stats *vsi_stat;
>> +	struct ice_pf *pf = vsi->back;
>> +	struct device *dev;
>> +
>> +	dev = ice_pf_to_dev(pf);
>> +
>> +	if (vsi->type == ICE_VSI_CHNL)
>> +		return 0;
>> +	if (!pf->vsi_stats)
>> +		return -ENOENT;
>> +
>> +	vsi_stat = devm_kzalloc(dev, sizeof(*vsi_stat), GFP_KERNEL);
> 
> Don't use managed allocations if the structure's lifetime does not
> match that of the driver instance. It's not generic garbage collection.
> 
>> +	if (!vsi_stat)
>> +		return -ENOMEM;
>> +
>> +	vsi_stat->tx_ring_stats =
>> +		devm_kcalloc(dev, vsi->alloc_txq,
>> +			     sizeof(*vsi_stat->tx_ring_stats), GFP_KERNEL);
>> +
>> +	vsi_stat->rx_ring_stats =
>> +		devm_kcalloc(dev, vsi->alloc_rxq,
>> +			     sizeof(*vsi_stat->rx_ring_stats), GFP_KERNEL);
>> +
>> +	if (!vsi_stat->tx_ring_stats || !vsi_stat->rx_ring_stats)
>> +		goto err_alloc;
>> +
>> +	pf->vsi_stats[vsi->idx] = vsi_stat;
>> +
>> +	return 0;
>> +
>> +err_alloc:
> 
> Don't do combined error checking, add appropriate labels for each case.
> 
>> +	devm_kfree(dev, vsi_stat->tx_ring_stats);
>> +	vsi_stat->tx_ring_stats = NULL;
> 
> No need to clear the pointers, vsi_stats is freed few lines down.
> 
>> +	devm_kfree(dev, vsi_stat->rx_ring_stats);
>> +	vsi_stat->rx_ring_stats = NULL;
>> +	devm_kfree(dev, vsi_stat);
>> +	pf->vsi_stats[vsi->idx] = NULL;
>> +	return -ENOMEM;
>> +}
>> +
>>  /**
>>   * ice_vsi_alloc - Allocates the next available struct VSI in the PF
>>   * @pf: board private structure
>> @@ -560,6 +606,11 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type vsi_type,
>>  
>>  	if (vsi->type == ICE_VSI_CTRL && vf)
>>  		vf->ctrl_vsi_idx = vsi->idx;
>> +
>> +	/* allocate memory for Tx/Rx ring stat pointers */
>> +	if (ice_vsi_alloc_stat_arrays(vsi))
>> +		goto err_rings;
>> +
>>  	goto unlock_pf;
>>  
>>  err_rings:
>> @@ -1535,6 +1586,122 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
>>  	return -ENOMEM;
>>  }
>>  
>> +/**
>> + * ice_vsi_free_stats - Free the ring statistics structures
>> + * @vsi: VSI pointer
>> + */
>> +static void ice_vsi_free_stats(struct ice_vsi *vsi)
>> +{
>> +	struct ice_vsi_stats *vsi_stat;
>> +	struct ice_pf *pf = vsi->back;
>> +	struct device *dev;
>> +	int i;
>> +
>> +	dev = ice_pf_to_dev(pf);
>> +
>> +	if (vsi->type == ICE_VSI_CHNL)
>> +		return;
>> +	if (!pf->vsi_stats)
>> +		return;
>> +
>> +	vsi_stat = pf->vsi_stats[vsi->idx];
>> +	if (!vsi_stat)
>> +		return;
>> +
>> +	ice_for_each_alloc_txq(vsi, i) {
>> +		if (vsi_stat->tx_ring_stats[i]) {
>> +			kfree_rcu(vsi_stat->tx_ring_stats[i], rcu);
>> +			WRITE_ONCE(vsi_stat->tx_ring_stats[i], NULL);
>> +		}
>> +	}
>> +
>> +	ice_for_each_alloc_rxq(vsi, i) {
>> +		if (vsi_stat->rx_ring_stats[i]) {
>> +			kfree_rcu(vsi_stat->rx_ring_stats[i], rcu);
>> +			WRITE_ONCE(vsi_stat->rx_ring_stats[i], NULL);
>> +		}
>> +	}
>> +
>> +	devm_kfree(dev, vsi_stat->tx_ring_stats);
>> +	vsi_stat->tx_ring_stats = NULL;
>> +	devm_kfree(dev, vsi_stat->rx_ring_stats);
>> +	vsi_stat->rx_ring_stats = NULL;
>> +	devm_kfree(dev, vsi_stat);
>> +	pf->vsi_stats[vsi->idx] = NULL;
>> +}
>> +
>> +/**
>> + * ice_vsi_alloc_ring_stats - Allocates Tx and Rx ring stats for the VSI
>> + * @vsi: VSI which is having stats allocated
>> + */
>> +static int ice_vsi_alloc_ring_stats(struct ice_vsi *vsi)
>> +{
>> +	struct ice_ring_stats **tx_ring_stats;
>> +	struct ice_ring_stats **rx_ring_stats;
>> +	struct ice_vsi_stats *vsi_stats;
>> +	struct ice_pf *pf = vsi->back;
>> +	u16 i;
>> +
>> +	if (!pf->vsi_stats)
>> +		return -ENOENT;
>> +
>> +	vsi_stats = pf->vsi_stats[vsi->idx];
>> +	if (!vsi_stats)
>> +		return -ENOENT;
>> +
>> +	tx_ring_stats = vsi_stats->tx_ring_stats;
>> +	if (!tx_ring_stats)
>> +		return -ENOENT;
>> +
>> +	rx_ring_stats = vsi_stats->rx_ring_stats;
>> +	if (!rx_ring_stats)
>> +		return -ENOENT;
>> +
> 
> Why all this NULL-checking? The init should have failed if any of these
> are NULL. Please avoid defensive programming.

Hi Jakub!

Thanks for the review.
I fixed the unnecessary managed allocations and null checks.

Sending v6.

Thank you,
Ben Mikailenko
