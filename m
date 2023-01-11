Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9B66663C8
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 20:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjAKTcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 14:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231831AbjAKTcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 14:32:03 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2102B6E
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 11:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673465522; x=1705001522;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=erKV6hmTrBkWszEG5KeBfe+j3laFz2xaYyBo8NxpoXE=;
  b=fU8Dj02GzXRbNJ3nbP/kD3AioFvMldekGOylEQW+u7nHck/atmfD46lz
   2Nu5v+JDUKcOtG3NI++ePC2dFOCyj2Z9/2lKf6B4oipSVYIDCCdyP9aU5
   hUhE7J5uEbCNubObYrlqkNoI906c9F6yE2f81LlKk2GPCrgAD+JUFQAbp
   PGDO8Oo9FwIzTO6FfN5lCeWqlFyzkH5+iPbVhOVKCfybqn5k/eLjP4VU6
   oyuWKqvNeXbHVWy9VJs2yrEBNFHAGHvSUOdryJijmdI/+G75r3yZ0zot/
   J6Ft7StnhGcgoTgIJuqlKCSWKIKMa0QaySDPgiH//ra6vNS4rmCdIc7fh
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="303888088"
X-IronPort-AV: E=Sophos;i="5.96,317,1665471600"; 
   d="scan'208";a="303888088"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 11:32:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="659501340"
X-IronPort-AV: E=Sophos;i="5.96,317,1665471600"; 
   d="scan'208";a="659501340"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 11 Jan 2023 11:32:02 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 11:32:01 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 11:32:00 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 11 Jan 2023 11:32:00 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 11 Jan 2023 11:32:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXR098U4zmT1e3mQWh3RDKxaw4VGA+vInNm+1kfmSzMRdHyZ81iND4vTQmQeOATuqRpyuqc4hgT8Lz2dpeIgUjrcgsnNBYAeIH1AXcSdhMQOOhsqf3Mdwmv/+6w7B6Mz+dEA5nAKZPeqe3o8vFUI1dJz9AJSXKZuCUZ3/VBT7GLDApSbJ4GaqFm/poHQDZoigrCr5dnx1gpqo9Zq+2s7Z67HCJcG7MJvcMV8Hdi279gYMrDGnH6azlGSh6AAwTWUwCjed9YrDMg/HafjVr6PHAqPESjCqkhn2yYkjk6qfQ9sIbNoeugnbXlmW7Vp702S98ulFsDqP71tc8799FCX8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=64dK0h68GyxP/CEC+/deWbutlX2O3nyQmg6aeCczal4=;
 b=DTS7LQRvi20bIVfb64Gf5pJP+bzOviNf0LjZS6fY+hjkYzUl9V0YVyYbTopsW8VP0Xe3OYxsidyVVuQODNS3KM06TifTl+SsqZIMLAx7KXqUE/PWkMg3dn/hl4lmKvwAG4Y2zIuDwqHvRCY891suz2P/fuHkY8nBSaAs9PieC34NyXxykhWFbz7nFjvmxbMCgsABKhvsR+v+PfpHY/6q87qFPqa+htcg/VC7cvRWmaiOl31NiEsf28OzdspBDe8Ls5bXXOgHoD87574N0w2OoRqcs7JoU4UxQwxVeRMglqX76tn40B2tJEwxdQZWtLQzmrlmnYoXAQsjGaPm+aer0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN7PR11MB7467.namprd11.prod.outlook.com (2603:10b6:806:34f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 19:31:58 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5%5]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 19:31:58 +0000
Message-ID: <46ee9dd9-4895-80a2-a846-6444a72a15c2@intel.com>
Date:   Wed, 11 Jan 2023 11:31:55 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net 2/2] ice: Add check for kzalloc
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Gurucharan G <gurucharanx.g@intel.com>
References: <20230109225358.3478060-1-anthony.l.nguyen@intel.com>
 <20230109225358.3478060-3-anthony.l.nguyen@intel.com>
 <20230110182607.3a41ab85@kernel.org>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230110182607.3a41ab85@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0192.namprd05.prod.outlook.com
 (2603:10b6:a03:330::17) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|SN7PR11MB7467:EE_
X-MS-Office365-Filtering-Correlation-Id: 97f11b4d-cf56-4439-1db2-08daf40a8137
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dfqteyjh97TMpgeb6I4ZgeeDyWZHygBFCbDUnC0ta7OEIPzcWmVUqmyuis3jqXVQzXz+N1v5GrTn+ft+HGcVJ4V5TlZUWT1N2W5lTHo2NghyBMJaZ98rkKugzF6+4vQj/gpbtspb/uXP9gLEKwaqZIbj1zFFTElX1dw4yTZODhUV1UPgu222i0WN82tKOP0amVX/qQwCD6qUG5GxXF/4fydVFL/ebABSdKSkoUfJLToRhmdNoo+4tqOiGRvfLcNZQmDt1F2egH6R9YrfQVrAg6ytSYM6bW3P+cNs4NdFlL7rJ1ZAKZCT5NShnslY/uQUZlolvdIj5ZdTRoWl2goNKK2Cgfyt6/sTQVN027PyFceRm3NoyJgMkSlmc9kfVKuZrWo3yMDmRMc5wKW8dUsgDSoFBFaQ2pvGiL8+m+TQFpo1lBI4VzjnIOJcnRxCbuHnC1Y/C3UQ+T4+lLpyzvVoDU0BrN3UnAbEqJ0wjplJmJZbDtOoUPlf6NCWZLHI4nrmeknc4qZO6r7pxSl3ilX1Jz41N8XR7EBa/ZjaPxQdAwJB0I+YqRVnAADg2MaZiOkInf8Ggw3yNCzaQx9SS8qqxWgEVCu8SZcnIwVBSAEHnJjrjR+GnVjBnXnLZMbDVcuDohgIJbMnbDznQmJ7FGApg1MowyyH7NaKw1ZY0lA8hUgnwxw/bdWc2DZrIAQOKc0jZ7sCvRTFkDO4QyHgqd0wQqJqKbWjpV1wGsMjDfCZls1d/CG6d5kZx8PUY+Ia48TA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(136003)(39860400002)(346002)(451199015)(478600001)(8676002)(36756003)(86362001)(66946007)(4326008)(38100700002)(5660300002)(66556008)(66476007)(31696002)(41300700001)(8936002)(316002)(966005)(53546011)(6486002)(2906002)(31686004)(6916009)(82960400001)(26005)(54906003)(6506007)(186003)(6512007)(107886003)(6666004)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3VuaFloL1VhZ3locmE0TmIxQlhQSmZLRXBDM1ZraTJxYk5KdlA3dDhkalFL?=
 =?utf-8?B?YW8zeU1zRWxXczM5SjZRc2lWb0U2WFFFZmpKb0VkTWZLWnFsbzA0THdsOTc4?=
 =?utf-8?B?NWVXaDArQTJTMlA3WFNIWllMNDRUZHI3RUJjdmZwMzdRWC9FYWhWRE5UcEF2?=
 =?utf-8?B?ajRmVjZMZzhyVjlyTUdEdnhGTGNmcVpRR1pBZHg0cDRkY0R2SHo2TkdzWmZG?=
 =?utf-8?B?K05Ba0VIM3M5cVpNd2NDQ0lua0JVVmU4TFNHSXNpd1FWV2Y0eXJHN29HQW80?=
 =?utf-8?B?bjlKL2lZNmJaMjdVaytJU2tSTFhJT29idVk2eEtRdGpjMjVZeTlzVmxBVVpF?=
 =?utf-8?B?VTNDYmJDWkd4SHZsbUt3ZDNJMWVpNW9LZ1JPZFRybzdCOE5rMHpSZ0Zib1Za?=
 =?utf-8?B?MENNb2FKeXR2d2NkRnVpaUg5MmMxZ3BTNWxVdTFrb2Z5YU9PRVlvRUFvdEdE?=
 =?utf-8?B?SC83NjZhMlNkL1lTK2JyZVlkam5XdUJMd09UdWxzQ0tIUWRHa1plRzVtY21I?=
 =?utf-8?B?UHFsQ1BIWmFLL0tjcFg1THpqSWUrTjN3TUk5SDExZUVqM041MlhJVGNmbWZk?=
 =?utf-8?B?RWgrZHFydzUwTFN1dVdPUGZYeE5URlVTWHlJVlA2NnIwSHFGd1EzSzkzNits?=
 =?utf-8?B?NTJqK2ZUTnR5SjFhN2puTWx4TVRhRzFWaWJlR0FsTnJneDZkUHNIVlFNYXdj?=
 =?utf-8?B?OHhReGkrMDIzazQzOWxiUWw5VGJMc3lWVHBuWEVMelNySk1aTUN3TyszMW9q?=
 =?utf-8?B?ZnU1R3V0RmEyb2hDZmpsMXVuNjNoVG5abWUwTnFxZ2VxaDY3dndkR1VnRFpp?=
 =?utf-8?B?U2tWUXR2bXhNd1lJV21vNXdJSmpkc1lSWUlObUcxdEdkaVdXSGpBa3NOaDBz?=
 =?utf-8?B?ckxyM296cXVLdnNrei9ZOWx6ODZoNmxJM3llc01Qbm9vV3R3L1NVRkFkb0Zl?=
 =?utf-8?B?UUU3S3I0QU9xNVgwVFUwdFkveDhiekp1VWYwUFhLMnZLNmk1MTFmWnF0V3ZT?=
 =?utf-8?B?Smh2VkpyOEtNbnViM0laNlY3V1hlbFJ0TmlEWXlmK3R3bEZJbzdTc2dPUUQ2?=
 =?utf-8?B?QWZJOUtCamJLbXVJMFIzTFg2WmlHV1daeUl2cmFPMEwxYlJxQThlN2xhVXlS?=
 =?utf-8?B?bmtDaUdJVzdNQ0pUbnlHcnFmMG5kaVphRjVDbm0yeURmODl1QUpOczhMYVVO?=
 =?utf-8?B?YW5la2RYVU9WWk12MnhUU04weUpFclU5eW9paWJVSlRtb0VuNm1QS2RqTGVQ?=
 =?utf-8?B?VEVlaXpMdHBxeHpTK2s0RGk0dnF2NWsydGt1RFMwSkZMYkdwVWQzRHozc3NM?=
 =?utf-8?B?YzU4Si9OZ2ZlYnJqbFFDemtnV1hDdnNyZmhmK2MrT1lVUUErMG9OUG9JNEtk?=
 =?utf-8?B?WDhhWkg0TFJ5b1lCWnN2c0xXT2oxMWZ0MVVlNytEbVh6TUdGY29iOUhVZGJ6?=
 =?utf-8?B?ZmROZzd4dzVLQnZWUEtvcU8ySExndnhmdlUyQUpyZ1dSVEkzRzFmTmVVUkJi?=
 =?utf-8?B?YUFONmxrdWFueHlSb28rd1V0aSt3eHZwT05tSTEzZ0dLQzd1dllqUGZVdGY0?=
 =?utf-8?B?M2J0NkhsajB5SHJpb2ttcmtnZlU2VTBReERENUNRNWM5bDMraUhRL2tQVzdq?=
 =?utf-8?B?eGxhK2VlaUh1bnYxaEp4b01VbzJFa2ZMYXI3aVJPRDBONW5XWk5HeHE0S2d0?=
 =?utf-8?B?ZWt6dHdrNG9BZUxUeTJJbXcxUXdLcTJNRms3MFRqc2FaSittRFlwWis4cHdu?=
 =?utf-8?B?ckNHVFhGNnB5QVJmOURDUjdCNzhHZWUxOW9nVHorbjRzbktpeXVPRmFCdzEv?=
 =?utf-8?B?WTJjaGQ0ZHZuR1N2RFc3bDZodThMZnExM1daMnRObnM0eitKc1RQNFpMZHF3?=
 =?utf-8?B?RWsya3BRNDdnS2Zzb0RMeU1reXlBZXJBdHRHK1JONlRsZ2U3ZUhCU29nSDJx?=
 =?utf-8?B?anhqTDVmd1lFYTY5NnpoUDMxeVVqRGtyMk56MDAvL2FQNDRGWmZzTlBjdi8r?=
 =?utf-8?B?Um1HbHVobGxJL3A0dFhzYnhwaXA3aVdjRkVmTzNBSlFuYTgrL1JpdlBKZ1ZR?=
 =?utf-8?B?Y2ZkVHFMbzd4YVRDQ0pNWFFYZHlzeGpRZTVqdmFJdDNaYVpjS0dVcnZKYW1Q?=
 =?utf-8?B?c3ZvU0hHbXBVbmJHcnk3ejZUQXVEeHg1SEdlOFBnSkcwQlU0VkZqelZod2VQ?=
 =?utf-8?B?bnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97f11b4d-cf56-4439-1db2-08daf40a8137
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 19:31:58.4975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NpivHWmZjQxEbCk+Xbf4efY/jxGVWyrqQp+Evau/Y3aSCLlsrlLLN6ZCuHX+HbTjx6NXhnwlHroyBYxBTi++7xwyE4w+DMB23il9WCpQC+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7467
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

On 1/10/2023 6:26 PM, Jakub Kicinski wrote:
> On Mon,  9 Jan 2023 14:53:58 -0800 Tony Nguyen wrote:
>> @@ -470,21 +473,23 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
>>   	err = tty_register_driver(tty_driver);
>>   	if (err) {
>>   		dev_err(dev, "Failed to register TTY driver err=%d\n", err);
>> -
>> -		for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++) {
>> -			tty_port_destroy(pf->gnss_tty_port[i]);
>> -			kfree(pf->gnss_tty_port[i]);
>> -		}
>> -		kfree(ttydrv_name);
>> -		tty_driver_kref_put(pf->ice_gnss_tty_driver);
>> -
>> -		return NULL;
>> +		goto err_out;
> 
> FTR I think that depending on i == ICE_GNSS_TTY_MINOR_DEVICES
> here is fragile. I can merge as is, since the code is technically
> correct

Hi Jakub,

Thanks for the suggestion/improvement. This won't be here much longer as 
we will be converting to use the kernel infrastructure [1] soon, but 
will keep this in mind for the future.

This was mainly to ensure the existing implementations got 
corrected/could be backported.

Thanks,
Tony

[1] 
https://lore.kernel.org/netdev/20221215231047.3595649-1-anthony.l.nguyen@intel.com/
