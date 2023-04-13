Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63C16E14CD
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 21:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjDMTE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 15:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDMTE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 15:04:56 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560367ED6
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681412695; x=1712948695;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zF7QpMPfMFYO1pDd9ToiRpd4YEqNfT1iTb1QT8Z/Tao=;
  b=TNEXsCtZ+ArPh5w7K1g/PvNzNnUevhejXbv5rEhTB6WhetIF+yf6JWGO
   y/JZ3YkaWTQHHb2fFnzzmEDuU110OsrGWSDsgXIFZc6Qo67k3GMNFEFBT
   3FsfLGKuq2l6DysP+PlcDMIravdq8UhLXoFE2/V8NNsKGdrP23+CerZEC
   c7EBTEI5+fRI2DvFalDEQiTjaOBmMdbpMuU0g+k/pru4gi6ztqX5PcgZi
   lK7+frH+H4pw41vFgphzpHReqUOvtwf6FAzp065Gu/N+xtTeDh8Ytwqsu
   n7orNgnSstZKTaOFaxEKbQ6VH0lue5lwqSPZEOTcGQQ5qmwAdQTydpFhm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="346983303"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="346983303"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 12:04:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="863902879"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="863902879"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 13 Apr 2023 12:04:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 12:04:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 12:04:53 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 12:04:53 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 12:04:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwSmYcY2VwjIDFdmsy4890cRkT4u2HDATbjAVHefLThME/L/+MJsk5EnwGgQ5+F3FP2r1MbQfGxkUe2Y6NbhxgXjD2qkIAAabh6h9InzlNOfe8SeKkfDxJtk01/UCbEPiuLixZOaJtskABevzd5/wp/Z7+JdavNmP1NsIm4PYgDoWksCZtDpsI9CcNP0h+EcJEyoiQSf/yWZhWITGj0TAQZotx0774zQL2uRTPqqSKO6ID2zbi7jmZgQHF5cu8b/WnoRcs6aKB2KXt0sEeH5ssSzW3DmxWvjkA7VmC+gnAhv59bXXqT6aWzo+0xmH3IqyyGAf2heRLojyvUk2sTaCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K8XQ2IhETVY1d2eWYWxL933iMhBZNgOcSSIh/pvPgS8=;
 b=ikMYBCfkU995PRAWS0aNwn4HE4KyuIVBDinekyMO6poMIl9kxRtd8/D0dFWMs08Q9lAJh3GzTU/7NfVNo77eJmkPVspYLQLmD8+L6DCMkDy/jZ2+YH6WS5MBeO7Z/OlGKcQOenBCO3TZTJIPyBxHVkFZy7bLoi6XOOSOoCKtHz/o8zl4fvnzefEhqa8vxeBJALMcKhVExVXalBGg4BbUxgNY6tvai4U1LGIuMvLb5LxWZ+og6uqh/ErcKcbOweJgnoiH2gNS7Vfq3EjuFdw1f3GNESLln6fG8ONBFKDzTlcnbHoUwFTcWqlX3qMrh+5qYgJReqFdg2pNU3WALKQTNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4538.namprd11.prod.outlook.com (2603:10b6:303:57::12)
 by SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 19:04:51 +0000
Received: from MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::8733:7fd2:45d1:e0d6]) by MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::8733:7fd2:45d1:e0d6%6]) with mapi id 15.20.6277.038; Thu, 13 Apr 2023
 19:04:51 +0000
Message-ID: <ff27f4ba-9cdc-937a-2b1b-ad621adc26fa@intel.com>
Date:   Thu, 13 Apr 2023 12:04:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2 06/15] idpf: continue expanding init task
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <joshua.a.hay@intel.com>, <sridhar.samudrala@intel.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <willemb@google.com>, <decot@google.com>, <pabeni@redhat.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <davem@davemloft.net>,
        Alan Brady <alan.brady@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
References: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
 <20230411011354.2619359-7-pavan.kumar.linga@intel.com>
 <ZDUin+kC2Zrqk2wk@corigine.com>
From:   "Tantilov, Emil S" <emil.s.tantilov@intel.com>
In-Reply-To: <ZDUin+kC2Zrqk2wk@corigine.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0108.namprd05.prod.outlook.com
 (2603:10b6:a03:334::23) To MW3PR11MB4538.namprd11.prod.outlook.com
 (2603:10b6:303:57::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4538:EE_|SJ0PR11MB5214:EE_
X-MS-Office365-Filtering-Correlation-Id: 4947439b-7298-45c3-15e0-08db3c51f55c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4FjaSqTmYPDT2manWEWQ3NMZuGa68IE18sWvXnQGQOoRgiFXCst+RHN+00EvGyp4KEYuCY5VPFEKeglqDeR0PwwuyOJ4gnObjBxyh7+8BzABppdzmxD+aN85YmPn7zOSVHRaU9DSTYvZWRY+tfdxQMLaD39jZR/tPnTxjopD6X6SI1EBx7WDm4s14SGlOkjBmO1Ly/mubHhBgnh/lrc0uL2buV5KJOOnC1Yf+dxWutcXmM0rv/DKbIUhnea9OKXbUkUsalRiWX01xLvYT1Juoctx0ZEIyX3R7QDf4OIbafoB8GCEFtIHbgQ0LF51BUJs3reh6osyYiTlluKXfOXgz2oFVxoaaKMxfxqpGOxoTKWZDIycbqyRG1zz0JgNBTpc7qmSLV7we+qkWvZeiDYmjnUgyCVtuSJKEAujR1vMAcm3oViTdYCN7emGmDl4g/TMgppMM5ObhLIMDhl1ji4HoeCcBphtAzJc2OJraCS/5o4n8xPlAME3l4fSTiJtPpk3v+IcBy+ZXu9LUZI3ytW6ATdJICX2qJ7dS5zeE+OJoceIxXIgkpaVR1PVA1/U1XYXDXwhuIujvfP8UDBJF9xUHfpU0gHxgE9am8Qx+82WuTyDitfJPlazVVwE3uEoZCJvZy3RJtPar3TqmAp1B75mlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4538.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199021)(53546011)(26005)(31686004)(6512007)(6506007)(54906003)(6636002)(83380400001)(186003)(2616005)(107886003)(6486002)(6666004)(5660300002)(41300700001)(82960400001)(38100700002)(316002)(8676002)(8936002)(86362001)(31696002)(478600001)(66946007)(4326008)(36756003)(66556008)(66476007)(2906002)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bE85YUtUcXJVUVN0b2ZXbDZaQkFLQmE3LzV2L2ZSdi8vbnRPSUx3U2dIZjF2?=
 =?utf-8?B?cmVzaksrUG5RVGJ4cXlCdHNhZ0FsWTVKSDZsMENyY2Q2Rm13VkdyVCtLWE91?=
 =?utf-8?B?d2V5MzNEQ3VBZDFZYndZWVlDRnIvMlo1aWl0MU5kbnJrZ0ZmRG9lL3REd0hw?=
 =?utf-8?B?MXpqQWpTSFk4YXp2K3cvclJIOEhjbDlYNzJRWkdzVzliaGNCNnFWNVYzcFBx?=
 =?utf-8?B?SkVaYzM2d1l0enJjSEJHbmpxOWkxU1FsYU9Yb3hnMFVCNGR5NG85Nmp5MGFh?=
 =?utf-8?B?T05QblpXRmxGdGlZd1NZdFV6cm1qcFBaSU5OZ01aMU5KbmVQZzIxNjlCb3Fz?=
 =?utf-8?B?eWEzNXRKZFYzRlhWVlN1SEVtbjBWT3ZIQVVoemM2c1N6ZVZuVnBleGw1WFVs?=
 =?utf-8?B?UHlOeGhIeTFCTk42dGZIMmNsWGozck1laGVCbk5aQzRzaXkrVXN1d1JIYytS?=
 =?utf-8?B?dU5sTnNsOFo1VDlPQ2NPR2E5MW1OdEtLOGcxNHRJV3JNRzJ4TlQ1V2FjdlpS?=
 =?utf-8?B?VDZwRjVWdE9HbFJYdThENzBWVXk5aVFialZDekxUQXJSb0g0TFlUdlNMS3pq?=
 =?utf-8?B?YW5HQXN2aUsrUmVOS2hWNGdseHhzS1RBZlhyL0RMRTQ4anh5bTUxMGZhZ0hr?=
 =?utf-8?B?OVpoUWNFemtwR2hhZEtmT0FHNk5JbnNkRmVqaWgrWGhXWlJrdU5DbEJzcUhn?=
 =?utf-8?B?TkdCTjdtektXNHBPWVdIazNHNHRZUzV2VlJlcWFKaFdpejBNQ3lRc1VOSHIy?=
 =?utf-8?B?bUxMQ0tNeC9iUytFMmIzYk9xOVNrbkxwZzJqTldITVFtTzM4R2lqMi8wM0tr?=
 =?utf-8?B?dlhYODlHbUlOTDNzSlp4bE16YXh3Ukd6MmNPOG5PMXQweEJGdVU3NWhXajhK?=
 =?utf-8?B?NnVqWVZ2L2Rsa1NQS1lsRS9NSEdSU2R6UGE4T3Vidi9xNkZrSlc0M2pCSzRv?=
 =?utf-8?B?N2REUDcrc2x1YUQ1QVl0b1JFRy9RdUc4VDc2R3dWeUZBUGtxYTg5ZERmYit0?=
 =?utf-8?B?OTlZZ3NYSXFIVUZUMzFaTGcyby9xM3ZDS0ErWDlWeGljSytFUkpXS2J2Qnox?=
 =?utf-8?B?bXZHRHpicXVHd2wwN2dRa0g4UlhjaEtvbHlHZXoveTIzNkVzWEoyeFBnZEhL?=
 =?utf-8?B?dmRPaUFSWHlEK28xbFVmMTNrRUZkOHdJRGdVR01PZTVrSkJWSXBVaXYwbEhV?=
 =?utf-8?B?RVZZR0FISXdOT3ZUQUp6U3V3WXkwZHNpV01INFhsMDVpKzFDb3BpVDVuVmxu?=
 =?utf-8?B?Tllpd2haN1p6MFI4Q3dYdXB0TlNXTTJlSW8xZ0E2dGwxcDRHU2szc0FseER2?=
 =?utf-8?B?QmVyY0lBMGJFYjVkNDlUWDM5YTNndVdBUFhiQ015TkdzQlQ2Ukp3b3lxQWdN?=
 =?utf-8?B?Y1o3akloN2JkeEZ0NUU3Mis0alM1UU5TMEtPdlJxd2FoU3V1dDNTSEFucy9K?=
 =?utf-8?B?RGNjY1VybnJlVlVRaHVmalMwejNtTWxCandJQmh5c1ZPTDdPamtYTFk0K0pQ?=
 =?utf-8?B?M1lJaGVsZDAvd3dObWhUUEFRYU1XQkRhNENpcldrMmZNWlAzVnZmaENDMzcx?=
 =?utf-8?B?YW85eVhOdEFseWtISUdhRXpYYTUxb2duQ1BER1hnSFoyc2krNHlJaFpJdm81?=
 =?utf-8?B?cEE1NXRrclBXMS9HenhYSDJ4U0sySEFWZHRQbkhvaldpUnV4eXprTG1DZFIx?=
 =?utf-8?B?Rkp6bXh0UXIrNGZ4OVNTRXBCblloQVUrWFNjL2ZRYWpacjVHUEpSQUlsYThB?=
 =?utf-8?B?ME9SMkxidGZzMWlJZ1hWTStBSm9wY3lBUitMUkxaMmlFWENZUlRrQnpwTHpG?=
 =?utf-8?B?MC9KOUYrYUZyT0Q5aENRMDBnMGxaS0FBakZ2WUlFNGoxTktkMzcyemFESHdz?=
 =?utf-8?B?cVZUbHB0c1ZRTW5nVWNhMiszOTlwazM1RjAxdWlURXNPNk13bEErajBQSXU1?=
 =?utf-8?B?ZFgvb3JCemJrdTNnZUkwb2h2amM1TXpsemVsOWZwckdPV3QzbEsxY2E1bERB?=
 =?utf-8?B?TU56NnpLUE05MGMwT25hNjI3RTZuWStGVjB1QVloV2dmUDYzdGMxUVBwam85?=
 =?utf-8?B?QzN0MVp1YUxnTXFoWWF0YUswRFg2bGdwdXM1NFl6WWtodXZ1NWN5S1ZacDlT?=
 =?utf-8?B?QUl1azFEZGN6cnJjU0hWQ0JObmFUSWFCZFVRZTMvRGIrUTNvdU4yNjBJUk1w?=
 =?utf-8?B?T0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4947439b-7298-45c3-15e0-08db3c51f55c
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4538.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 19:04:51.1798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 47oz1LRgpO/JXmPPUQDVucIv0EBelhOUtyCyS9xBQCE0gUJkVjV+ZDjL5mWVFAfFiQNH98/Y4OWaq6avgh4fmB6iErgRIFJsxT1F+HHMrBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5214
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/11/2023 2:04 AM, Simon Horman wrote:
> On Mon, Apr 10, 2023 at 06:13:45PM -0700, Pavan Kumar Linga wrote:
> 
> ...
> 
>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
> 
> ...
> 
>> +/**
>> + * idpf_send_get_rx_ptype_msg - Send virtchnl for ptype info
>> + * @vport: virtual port data structure
>> + *
>> + * Returns 0 on success, negative on failure.
>> + */
>> +int idpf_send_get_rx_ptype_msg(struct idpf_vport *vport)
>> +{
> 
> ...
> 
>> +	while (ptypes_recvd < max_ptype) {
>> +		err = idpf_wait_for_event(adapter, NULL, IDPF_VC_GET_PTYPE_INFO,
>> +					  IDPF_VC_GET_PTYPE_INFO_ERR);
>> +		if (err)
>> +			goto get_ptype_rel;
>> +
>> +		len = IDPF_DFLT_MBX_BUF_SIZE;
>> +		ptype_info = kcalloc(1, len, GFP_KERNEL);
>> +		if (!ptype_info) {
>> +			err = -ENOMEM;
>> +			goto clear_vc_flag;
>> +		}
>> +
>> +		memcpy(ptype_info, adapter->vc_msg, len);
>> +
>> +		ptypes_recvd += le16_to_cpu(ptype_info->num_ptypes);
>> +		if (ptypes_recvd > max_ptype) {
>> +			err = -EINVAL;
>> +			goto ptype_rel;
>> +		}
>> +
>> +		ptype_offset = sizeof(struct virtchnl2_get_ptype_info);
>> +
>> +		for (i = 0; i < le16_to_cpu(ptype_info->num_ptypes); i++) {
>> +			struct idpf_ptype_state pstate = { };
>> +			struct virtchnl2_ptype *ptype;
>> +			u16 id;
>> +
>> +			ptype = (struct virtchnl2_ptype *)
>> +					((u8 *)ptype_info + ptype_offset);
>> +
>> +			ptype_offset += IDPF_GET_PTYPE_SIZE(ptype);
>> +			if (ptype_offset > len) {
>> +				err = -EINVAL;
>> +				goto ptype_rel;
>> +			}
>> +
>> +			if (le16_to_cpu(ptype->ptype_id_10) ==
>> +							IDPF_INVALID_PTYPE_ID)
>> +				goto ptype_rel;
> 
> Hi Pavan,
> 
> The ptype_rel label will return err.
> But err is 0 here. Perhaps it should be set to a negative error code?
> 
> Flagged by Smatch as:
> 
> drivers/net/ethernet/intel/idpf/idpf_virtchnl.c:1198 idpf_send_get_rx_ptype_msg() warn: missing error code 'err'

We'll address this in v3 along with the other smatch related hits.

Thanks,
Emil

> ...
> 
>> +	kfree(get_ptype_info);
>> +
>> +	return 0;
>> +
>> +ptype_rel:
>> +	kfree(ptype_info);
>> +clear_vc_flag:
>> +	clear_bit(__IDPF_VC_MSG_PENDING, adapter->flags);
>> +get_ptype_rel:
>> +	kfree(get_ptype_info);
>> +
>> +	return err;
>> +}
> 
> ...
