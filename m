Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8064E6DCC8B
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 23:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjDJVFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 17:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDJVFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 17:05:34 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5A310F6
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 14:05:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfYflQTKlfScYOkFAevfS7fkSWvDwMbOD5MYmG4iGxECFayoQADCfXKFIwH317YRm7lQq6+bxAoCxYxCm7K+JiEo+/pakJZ715ri2ZKizeBuMTVXlR9hhFgslgGAH0zcrDmUTfdr6n4M0hkL7abVPZ4UQoLWFi2bk+NjL7t+QXHkVVt21WHvokc7CursUr77XJJ0YuTM+hgyg0wZBBoTU942LvWi5xv3DKorJTxrAs/tS+GfIGRua71w8/PxmuafE0yli3Ru9lRIjHvBv6sPurlGzfeio6IzvwlWBcoWrQL7TyurMiXL7U5SWYBW/O0VEcacSwYo3XMQ4402KvT1EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dnSo/HSaP57EnbQd5ekyyMbvCX+y3PcN+g4RUnQjmcU=;
 b=bCuJiEZUFu7Wl8L3eg8fcU4JnmZD79o3g3eVecaHcbo4yBkRQVz0PIkLsRgSaC1Db9rQsRIUiP7J6ZCAEVdxT0wP1z/SP9R1b3+PrIUSkZDYxvI1JLJ9nApMhAlzfuWbkbrcKLsL0QKJQHLRLVMl3iHiQcZcRA4Vp1Jj44ts5l/N1hjvECAnrVXCnDJVNk6a6n0QzhEH5etsdqNA1+kO+F3hUrYbWiBLBg/XK1bwt8sVbFJlZ8nEwba2581tsHtjfaBJwWsJnLdQQLv4Upp6n5MjH8XuhAB6L5gkXzdUK4/29eoXIcaf7WqndODVIZtgdcuKczEk5n0jlLl8uTA7nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dnSo/HSaP57EnbQd5ekyyMbvCX+y3PcN+g4RUnQjmcU=;
 b=YPq0zfOYGRvHdpDH5DO5fAQwuUkD5TGFrn0Tj3Uo31uUQzBeo9x8vg3VtyKo7+dWWXqQZ/6QX9cgys1kRk2B0hTrMyUoU+gOujudPX0njaUkOShr2VnP15+bF0GTzbMzrJCA7xiRfhO4lePPf1w08RJLWaYNHtXpbxT8X2su8fU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SA1PR12MB8987.namprd12.prod.outlook.com (2603:10b6:806:386::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Mon, 10 Apr
 2023 21:05:30 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 21:05:30 +0000
Message-ID: <5da76cb5-8e83-12dd-2467-621dd33f1bb8@amd.com>
Date:   Mon, 10 Apr 2023 14:05:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v9 net-next 14/14] pds_core: Kconfig and pds_core.rst
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-15-shannon.nelson@amd.com>
 <20230409171720.GI182481@unreal>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230409171720.GI182481@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0119.namprd03.prod.outlook.com
 (2603:10b6:a03:333::34) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SA1PR12MB8987:EE_
X-MS-Office365-Filtering-Correlation-Id: f11e7677-88f1-4ea7-4d02-08db3a0750cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vVbw39JZrz7KbKHn1kO7Ml0aOkRin+NC72bwqxJxB+LV7Rash8GWhYYBNxyHB6ZJYXpJnaaf+jboITHv8BY5S8NCiCEhUkqetjpC2zU/wdpaiRK8SQAKrcQeE29Ix+PUDdfXzBoZ0qHUGOivuhAYz4mMNfXdMVuE9m/tB8SuO3zkLPlW9fvw6B1owRYziLt6yhqg+KUK3/9JLkzXmhmO8mwIB8/pKF9ShYLw/Opt5QyymNXAU6MofR3sDoJDN87Sa4IWfRVwgLNLDWgS6oB7AOTWo5qV3fDl9KI9nOd+9/hhcl+3VRwZj1G/RBqzz+vV9IKFBzA1LBD+1m75Hg3ZL2ONVSLpQI2qxd2TTs7qiEWEA6oJx4+eJ2y+n/JBFDwmYaNDL1G9dkZTG5hQq87rOEL6l210IuzT5eOtBfqeL8OdnTpnJYWcQswGhRt6Ug7IqYf/qJzCqSJDrhx52wJeX70sBdQK91sE97qLVzTtB1e/JMLf9ggpJF3g3tHAkBMBV6fc19Wy9PbJ3NOz365VvCMy1s+17KXv61vv4jNzLHBi8s9RKLCUke46tSK4GM/1j+rqR874+V842yDjbfdCtK8nDBqpM8fmoowFRP/UDEILbSGwNuitPwzS8oiDpJcUiuOY3PWCtJaBZOQ6BhAPmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(451199021)(478600001)(6506007)(316002)(53546011)(6512007)(26005)(186003)(44832011)(6666004)(6486002)(2906002)(66946007)(4326008)(66556008)(6916009)(8936002)(66476007)(8676002)(41300700001)(5660300002)(38100700002)(86362001)(31696002)(36756003)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVhCNlpsalAwV3NTTS9VREQzTENJdUN6ZVh4U00yMSthZzdmMTZRSnVOcW56?=
 =?utf-8?B?eS9VNXNybG50d1Q2emRlUFRyaEZCTTdjYUZOY1FOQUtCc21DeTFGcWpYVjcy?=
 =?utf-8?B?TGwzaEhXdXNWQWs2bmRPN0F1SFRhamxwRmJ0dEZSWStGU1hrYk1BUGp5aWZn?=
 =?utf-8?B?amN0UWdqS0p3TW5Celo5RXVuTzFQNlBFWEQ3aUg3S0x6aTVhUlowaW5qVXhR?=
 =?utf-8?B?UWZIbTNURk5nOVRFcVpCMjY1MGhMK09uNGFJWDNnNnZER3FrZlF5ZVdQNWp2?=
 =?utf-8?B?RXREcTU5QTZUOXU4aUZqS0Y1ZG96VnEyRU9BUkMveFZ3MUViUms1azBmb01n?=
 =?utf-8?B?ZzZiTFUrYVR1MGthR0dpWVN1aXNnSU81L0Vhd0c5MCt5UGo1UVUzTjRrQ0pV?=
 =?utf-8?B?Z09xajJXeThLOVFZT1JJb3BTbGRGYTFvLzBnOWgvMnVHelBQaFNFajJZWVM5?=
 =?utf-8?B?YW1JMTdwS1Ztdy9Oclk2Z3lkUm5ZcG9sdThickNCK1R5RjRwRksxZU9jeGJj?=
 =?utf-8?B?eTR5QzY2NEVWT1c4V3prTXh3elFDRTQrVjMvWkRtWXdxeFQ0eGRQUTlzZkl6?=
 =?utf-8?B?VkpaVEtzQ2Y0aEhLZmVDRVcwUEp4SmREM1Y0MEo1MVRoMFFicmNZUmY3UExr?=
 =?utf-8?B?dU8xMmFBZ05ZdjFKdkpJclJTYUJPdU5PSFE2R3FMSEJmVVVTK1ljMnl0L0lq?=
 =?utf-8?B?dEdZdFZORi8xZ0NvMVVsejRPN01GUUhkcVJzNzJJMWg0UlVibXZaYUNaQ1hV?=
 =?utf-8?B?TUlKV29McGpyN2RsZnd3ZHlQdUNNQnNqUWF1TkdqeTIyTEowV0FkTXVrYnNX?=
 =?utf-8?B?bXNHWHhCTjUvQ0phOG14MjMraUc3TlhUck1lY0EyY0pISWRqbFdKU3BYdlVx?=
 =?utf-8?B?VFFSSGZJVkRPeHdqVmdSS0QwNWNMZDRQWWk3eWtvT01MdWxUTVY1dkhPQ1NX?=
 =?utf-8?B?aXF0dmJvS1BDbEFnTWNXYVpYckdDeENyTDRFUEkxcXdZR01jQzd4eUtzN0w0?=
 =?utf-8?B?QjdneVpaQ0l3azhjblcwUWFwRnBXdFo2SWthbWtGYkpwUHJSSkRmMjRmOXRa?=
 =?utf-8?B?MnRJVGRQZVp5SWFKRUdxdHA1bXBwZFFheDliV2R1QWt2aEhSemEycWpFYTVW?=
 =?utf-8?B?NVhMMmRUVTkxVnlld0xsS2ppcFJUdVpFejFkMGJzczIxWUtsM0ZmZGxLYUU0?=
 =?utf-8?B?WnhUMkQ2dVliQy82RlBHUGF5MXlvWFRzbUtlZERSaDRoTktGQ1RiODU2Y1hJ?=
 =?utf-8?B?T25CRjhhMlNWTkMrVGZaVzgwYXN3Ym5WMm1zOEJTUTJ3blFpMkdyRSs4NGZJ?=
 =?utf-8?B?a09jVTRVSmRabENBcGZaVm1mSUFpdGtKRGtrait5UEFuN1BkNkRQd1MzbHdE?=
 =?utf-8?B?Szk5ZStRRzR6Z1RjbFZsME9OelJHdkJOYklmZGtTNnZJSWZWWFRNcFNYcHV6?=
 =?utf-8?B?WTQwblBMUjJ0V0puTWZvMkpXenYvZ2JyZHQxaXlhRVh3MXV4RW45U1VaWHda?=
 =?utf-8?B?Y2tNbXdEbThFUVRCK3h3YXMvblphK3ZHd3g1cW1xRjVDd2N3MUJobWFhMkJT?=
 =?utf-8?B?T1l4eUZjcVdlcWk4MW5qWlFXOXlleWhPaDBQb3lHaFN6cG9jSHQ4RERteWgr?=
 =?utf-8?B?ZXpsdXE4ZkVqWWRpSUIyeGpJZ25wVXNLeGxTaDVDVjlyS2RLMTB5VzFHS3JQ?=
 =?utf-8?B?ZjRsWlNvSWVXMVVpRVQ2TUNtMjhteG5ERmZoQzZGOVArcEp4U2hLUkNpblIx?=
 =?utf-8?B?SWRBZXFiamhFd3R4TENIcXpCL1V1b3k4Z3VKMWVlSDYrRGVhN3lMaDJwd0Zj?=
 =?utf-8?B?OXdUQko3dkZxR1lwbXlMR0xtNmMzck9wNTZhRXdHL3lWLy96bzRlMUk1VEtv?=
 =?utf-8?B?TUxzR2t2dlpkSVdXRDNsVFBiU2wxLzArb3FtMzdkN2tIWDdlcXN5bzd1SVFi?=
 =?utf-8?B?MWJLQzZ1YXliNEJwOEhYMTljZUdpUlVoaUdPOG04alpMSHRZVThyTkRNSXpx?=
 =?utf-8?B?blFtb044ZDdIMHNvaWZOSmwzOEtTRlhkT0RCQXZ6NityWkF0OFM4TWJrOHNh?=
 =?utf-8?B?MTVhR3pJTTQrVHB3ZkxMcXRCL2VhN0JsNFJ3RW5KRnpYYktpWHpjMTNqcVBs?=
 =?utf-8?Q?AmWVvsdYccdyl0QVYoVEP1vSV?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f11e7677-88f1-4ea7-4d02-08db3a0750cb
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 21:05:29.9630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UAq8s+VHMrfQRF/D2v+2SSZkakLIjN7Vn4RtXuOctI3yzG5E4GrjHpj9VxB7A9m6BkBtvZMcYntDJTTNuZmexg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8987
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/23 10:17 AM, Leon Romanovsky wrote:
> 
> On Thu, Apr 06, 2023 at 04:41:43PM -0700, Shannon Nelson wrote:
>> Documentation and Kconfig hook for building the driver.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   .../device_drivers/ethernet/amd/pds_core.rst     | 16 ++++++++++++++++
>>   MAINTAINERS                                      |  9 +++++++++
>>   drivers/net/ethernet/amd/Kconfig                 | 12 ++++++++++++
>>   drivers/net/ethernet/amd/Makefile                |  1 +
>>   4 files changed, 38 insertions(+)
>>
>> diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
>> index 9449451b538f..c5ef20f361da 100644
>> --- a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
>> +++ b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
>> @@ -114,6 +114,22 @@ The driver supports a devlink health reporter for FW status::
>>     # devlink health diagnose pci/0000:2b:00.0 reporter fw
>>      Status: healthy State: 1 Generation: 0 Recoveries: 0
>>
>> +Enabling the driver
>> +===================
>> +
>> +The driver is enabled via the standard kernel configuration system,
>> +using the make command::
>> +
>> +  make oldconfig/menuconfig/etc.
>> +
>> +The driver is located in the menu structure at:
>> +
>> +  -> Device Drivers
>> +    -> Network device support (NETDEVICES [=y])
>> +      -> Ethernet driver support
>> +        -> AMD devices
>> +          -> AMD/Pensando Ethernet PDS_CORE Support
>> +
>>   Support
>>   =======
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 30ca644d704f..95b5f25a2c06 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1041,6 +1041,15 @@ F:     drivers/gpu/drm/amd/include/vi_structs.h
>>   F:   include/uapi/linux/kfd_ioctl.h
>>   F:   include/uapi/linux/kfd_sysfs.h
>>
>> +AMD PDS CORE DRIVER
>> +M:   Shannon Nelson <shannon.nelson@amd.com>
>> +M:   Brett Creeley <brett.creeley@amd.com>
>> +M:   drivers@pensando.io
> 
> I don't know if we have any policy here, but prefer if we won't add
> private distribution lists to MAINTAINERS file. It is very annoying
> to send emails to these lists and get responses from random people.

will fix

> 
>> +L:   netdev@vger.kernel.org
>> +S:   Supported
>> +F:   Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
>> +F:   drivers/net/ethernet/amd/pds_core/
> 
> You forgot to add includes to this list.

will fix

> 
> Thanks
> 
>> +
>>   AMD SPI DRIVER
>>   M:   Sanjay R Mehta <sanju.mehta@amd.com>
>>   S:   Maintained
>> diff --git a/drivers/net/ethernet/amd/Kconfig b/drivers/net/ethernet/amd/Kconfig
>> index ab42f75b9413..235fcacef5c5 100644
>> --- a/drivers/net/ethernet/amd/Kconfig
>> +++ b/drivers/net/ethernet/amd/Kconfig
>> @@ -186,4 +186,16 @@ config AMD_XGBE_HAVE_ECC
>>        bool
>>        default n
>>
>> +config PDS_CORE
>> +     tristate "AMD/Pensando Data Systems Core Device Support"
>> +     depends on 64BIT && PCI
>> +     help
>> +       This enables the support for the AMD/Pensando Core device family of
>> +       adapters.  More specific information on this driver can be
>> +       found in
>> +       <file:Documentation/networking/device_drivers/ethernet/amd/pds_core.rst>.
>> +
>> +       To compile this driver as a module, choose M here. The module
>> +       will be called pds_core.
>> +
>>   endif # NET_VENDOR_AMD
>> diff --git a/drivers/net/ethernet/amd/Makefile b/drivers/net/ethernet/amd/Makefile
>> index 42742afe9115..2dcfb84731e1 100644
>> --- a/drivers/net/ethernet/amd/Makefile
>> +++ b/drivers/net/ethernet/amd/Makefile
>> @@ -17,3 +17,4 @@ obj-$(CONFIG_PCNET32) += pcnet32.o
>>   obj-$(CONFIG_SUN3LANCE) += sun3lance.o
>>   obj-$(CONFIG_SUNLANCE) += sunlance.o
>>   obj-$(CONFIG_AMD_XGBE) += xgbe/
>> +obj-$(CONFIG_PDS_CORE) += pds_core/
>> --
>> 2.17.1
>>
