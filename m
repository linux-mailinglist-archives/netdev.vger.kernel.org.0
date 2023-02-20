Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CBD69D758
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 00:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232584AbjBTXyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 18:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbjBTXyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 18:54:32 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2079.outbound.protection.outlook.com [40.107.102.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010931EBE3
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 15:54:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDNq8GER2Ghd4yxSk4PnLMSnxizoDjR154gG8cJXvmCXqmDkLBQNn4rTqF/TDjz5AXHukOyLsLSB1PiNsDTwl+c32OnySR7KMZOJGkzndmqj1zigCtWKeTq9G1r2lgpouW8kGuu9rvz13Gc/JU5Gz5wlibfhjDlR//szJIeTj60aoJS/yUDlkQOLov2IaCF1KLWWRD4w+7dl3BFE6QHKlgv6h2gdRTMYSx1P36uOkims/1E4cJi1c3kjEPYGHh2R1wRHy2O6psD6LBoQ8I02PAx+Vdluy+Jd7Z0SOzOXJ2s4UgFKRTXZrlYpmiRffZ/Nd/SAvXGYf+NGUe4ukqLxVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kt0dH8M+nFok6PnGR3GIGwpb3DG6M6e9PO3UECJrm/Q=;
 b=ez0J2ZuEHwOX8O/oH7o/fyPqBJ6hEkHJ9mpWuVK06QqvE2SXmhWPF6cCvi5LaO0n24EdV1SjdZouquYwNvhckW1LD6Eq6zjSaNMea+OERC+XfhSJaaUoeKajTYSGSKubdOv7wBm3b9W5lM+ArHAdITHNqWSZz9lZSfN440nb9A1oeE5+H4TjqqlkvdAU5FqbkRD7iycMBRT3mA/af5Y5qkLQV2JYmwaOHOke/Bsm2tobFCjkJ25PG4MD8JZ10917zz5MwzoGg0ubsIjqs7vEaZLNkpN/+yNGd+UChr7g1N9vIa78clFAY6JbD2IjqNXR5iF5z1DwttbeJrQBEL60IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kt0dH8M+nFok6PnGR3GIGwpb3DG6M6e9PO3UECJrm/Q=;
 b=wuAG7uaKPC7+JcnEn7mM/MxfkbBXovx5p+v8G3WvPsw7m8RihQ8D5QyNvYXEQGF5c/cxKSbOX0kiTA34yncCBzWCFuM4AyqTfb3JBdt9nv9WXaROmR1MlmrfSsZJ23TnXdvBlr6mqVSllp6lnsUGh/TQY3xTzgD+YufiNPCllck=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DS7PR12MB8249.namprd12.prod.outlook.com (2603:10b6:8:ea::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.19; Mon, 20 Feb 2023 23:54:28 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%7]) with mapi id 15.20.6111.018; Mon, 20 Feb 2023
 23:54:27 +0000
Message-ID: <98cd205b-fabe-a2ee-e9c0-51e269b78976@amd.com>
Date:   Mon, 20 Feb 2023 15:54:25 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v3 net-next 01/14] devlink: add enable_migration parameter
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, brett.creeley@amd.com
References: <20230217225558.19837-1-shannon.nelson@amd.com>
 <20230217225558.19837-2-shannon.nelson@amd.com> <Y/Mtr6hmSOy9xDGg@nanopsycho>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <Y/Mtr6hmSOy9xDGg@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0098.namprd03.prod.outlook.com
 (2603:10b6:a03:333::13) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DS7PR12MB8249:EE_
X-MS-Office365-Filtering-Correlation-Id: bfc61a86-70d1-4721-6e30-08db139dcd35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R8NhEw1iCVicmUeZNoykCIn/yKUWBV9ffpQ1ANohL5xVPw6JFNCo4AlihQ0fKGLM2+2VR8jsruHRPYHxAdKpRfNPyw7i2MOZWThlSSHXesA7yZPB7p9+FAxHbTC3Q34pOm5uSsS0RzEf74Jz5ZFyh2fm7AJTxiAGBEOlAohSJz53p0MVE5TrSSQ9wLLcjL5jE20mdSWDe9fh7K0tmPg/hF6rcW5NwA33ZOZUf9q+ICrCl8Vi5Rv8WBy3I2Ykw0Wo9sLuRELRPp/4nCo32YK5Qvolpm+d8DJ/d61Ec37b+d+u/VObhMDViilWP1j1r5KH4MFLrzIeuiKDRlyuMc7OEZFwYc55fXqsGGtzkKMi+lfa/MOoKHFc14N4tZBCtgsJgcmIc2zGuvmLww7EwuqESYQg2IvZ9NzDKg/rXFhT+2U83Zqu/URGPjoY1gbPCIBtkCycLubiomeXGPS/W5NImUZ6+9RjSx3DXDFWGiwO0Xmy1WxdTBpRIqfuMKdc5mxxl5u9JufW4ojE7cE/KC+pnyY5+jefCh3kxBtwd6Ngj1OBAEv+GW4n0dAh0+zcyS3UeqLnNjGBIQnQvBNXv32Rpt/wyb4ZrO8RKW1jdmYAn2lNzTN4ro5CWhr/7MDuvNkLn3sOoOPcsfZhGnzWnqPTAQXWozbg3zSWRU2Odfi5LCgDGCiJo97UR1CSbBdCkCFbYaO8bNOUmRtoIfIZ60Rt8R40Fe92zi5XYkkO0a7K1eo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199018)(2616005)(8676002)(66556008)(4326008)(83380400001)(6916009)(66476007)(5660300002)(36756003)(8936002)(6506007)(6486002)(66946007)(53546011)(6512007)(186003)(26005)(31686004)(478600001)(41300700001)(316002)(38100700002)(44832011)(86362001)(31696002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWlQTEVSY1lLclFqLzIyOHFENGN4d3JHWlNZZFZycGFXVnhIT0hPcDJFMTdF?=
 =?utf-8?B?WlN2aDVpY2Vzb1pGYnRQbGFxNVNuakJuSVNVbmlDUU9Ub3RsL0Z5SjROT3Jm?=
 =?utf-8?B?bzFBRTRNQW1FSWRRMnJGM2IyaUltSDBLMlUzNGltZXFDMGFOejVXZFdFY2xP?=
 =?utf-8?B?Mkg1NUJZMGZtZWpTcWx4eHprQUdDYnBXWXRyL0l2VVlsNmVaSVVxcm5id0g4?=
 =?utf-8?B?dXJoc2g4UFdsaDgwZkxtUmhaNUFCRUJNZzR6Y2N2ZjJZWnVlRnMwMTh6MVdG?=
 =?utf-8?B?Mkp5NWlWYXZiRDNWZzBnQkFFNHROUjZsWlBMbCt1T3RoTzFTT0hHZkxUNlN0?=
 =?utf-8?B?YzVLS3ZuZTV5cVlJcTNjNHU0bXVFN3Y2Q2xOdkRyd1NzUm9HNHFtMW5VK2t6?=
 =?utf-8?B?R25hRHJHWXVoZmlHcXkzYXhRcUJURC9oOGcvek5ZbXdXY0tGTTQrM3hyd0hY?=
 =?utf-8?B?dlBOSmxUUzNScEo2cUwxUlp3cXZyRXBtRFFJaDV2YkMxVkFTdUwwTTVZdnJ1?=
 =?utf-8?B?UlY1d0REMUZlL0dPTUNQdGpDcmlzaTZ5VDZiZXdiYW5QTnVINlp1UjdncldB?=
 =?utf-8?B?YjhqRUJpNXVwSS9XZHF6YUZPRlFvOGNmc2pxdFpZbVgzWGxrMU5sR25vc3Ru?=
 =?utf-8?B?eHdJb2VVQm81cjFURGJTKy9wcGx5MDhzUmVxMXJ0L2ozTUdOT2Q2Rkh1TmlF?=
 =?utf-8?B?NDRpQVlpMmYzaW1BQnNJSVk1Q2ZJa2cyNndhVVJKZGZoV1RLQzFYUDV0MVFP?=
 =?utf-8?B?bmo5eWpvV21Ta2FUWmp5dnVWaFFnRnQvYTV2OUx0ekFPQWMxdlk4bWo3N0Q2?=
 =?utf-8?B?cElUQWJoQzlGaUgzRStyNS9yNnZwZFh6TmZUSkZiaWUyWUs3L002cHZaRENz?=
 =?utf-8?B?c1lsNU1tY3IxRzBQd2ZVK0xwTDhibllOZmJoTFJ6NXlIcjQybWE1Ukp6bXBD?=
 =?utf-8?B?emFpVGlNdmFnL2x5YmZET0c4Z1BqUUV0djVTKzRnd3EwSlRoNjVqbzZqVUUw?=
 =?utf-8?B?bTY4aUN4SUplQmVnbkpheFZucVpmTVlqVis1MUJBaHRURmgvODRCWHZXZ00w?=
 =?utf-8?B?MmFqNFBTUzNpaVo5NDh0cEdzN1ZRWENZUjI5TWJWZVNNanZlNzVEMkJ0eC9x?=
 =?utf-8?B?NENkV2RaaVdQS3B0MmJHRFRRdXhaRWt2eVBRd2l4cWNGSXVLcWt4MlNrVzNp?=
 =?utf-8?B?b2k4enlVTDFGeDBqUnNnUmx0ZXc5UjdNa1JTSlRMd0c5SjVjb1ZVT0g4Q3Mw?=
 =?utf-8?B?U1lodE9iUkhUanY1WkF1bWV5WEl0dEJzYklnaFIvTEVhMU4zK09sMUJjRGRD?=
 =?utf-8?B?UmwrS0N5anV0MFEwcWp4TDUwcGpWWnVQeTNGa05DNDRBZ1hWUDVCRUNhUTZn?=
 =?utf-8?B?MmZSQ3pGNDFJQ083a1BJTzBDd29TS1FCN0JzaGxEdEhsTEhCcE94VjBkMUMy?=
 =?utf-8?B?b2tXdFNvWGplQUVHTG82bVVzRm5kc0R6UEdRdWF0MlJsWnNMdjc4Qk9OMXRF?=
 =?utf-8?B?ZCs4ckk1NUJ0MHJtMkVuZkNRMHNlWWI2ZGhEdG01aDNOS2YyaVBTSFNwUGlk?=
 =?utf-8?B?MnFsWlJWV21uTVJUcTFXSDVxRXpmVm0vM1lFYTQyTDdZZzh1cXhzamZMZ0o0?=
 =?utf-8?B?ZCttRmhZNlgzdnhwNkU3WUVZRTlBQXZPK01mMjlSc1FRY05HR21TdENNcDRv?=
 =?utf-8?B?UEFFZys0bWFyZ1VVNm9kaXRmaldCSzJrUjA5aEt2Tkx0eVE0YWdRV3Z4U1dt?=
 =?utf-8?B?dFVFUHcvSGZRdXRSWVJDVUJLMzg0eU51TVZMWnNpOUN4QjYrOW4ydU0vVlow?=
 =?utf-8?B?NDFiMk9MM3pkUzNOM1czTlBiNFEwNUwxRWNJU0o2V3E4VVlDZnhnUXd6Uk9k?=
 =?utf-8?B?cTNCZkx3Nys2MUlCOWY0cjYyZUxoOXJuWXBWTkNweGNqRThoRTliYnBta2tZ?=
 =?utf-8?B?MEJ5VHhFcUhBN0FDQUt0bzM0dHdYQm1vR09acXI5SEttK1U1dElIZmhYWVBR?=
 =?utf-8?B?S2NRZUJERXZ6TEM5VTZ4L0pxaDNid2EvNENqRVlXSG9YbVkweEZqV2tydjBr?=
 =?utf-8?B?dDh5UkVvQnVzV0w1dnZhK3NPNVRVZEJxdkdrY2w2SURvQURwaFBkYlgxR2Ez?=
 =?utf-8?Q?sqBk92AUlQ93Z2eJXuBDRmesr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfc61a86-70d1-4721-6e30-08db139dcd35
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 23:54:27.8556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IJ1b8/axgDpyWYJ7QzF88zYiu+DqH+AWX8TqLaEFg1PLIjg+z5P3YKfKM/Lb17EkklMwCvxiCjgjImCJCniMGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8249
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/20/23 12:22 AM, Jiri Pirko wrote:
> Fri, Feb 17, 2023 at 11:55:45PM CET, shannon.nelson@amd.com wrote:
>> Add a new device generic parameter to enable/disable support
>> for live migration in the devlink device.  This is intended
>> primarily for a core device that supports other ports/VFs/SFs.
>> Those dependent ports may need their own migratable parameter
>> for individual enable/disable control.
>>
>> Examples:
>>   $ devlink dev param set pci/0000:07:00.0 name enable_migration value true cmode runtime
>>   $ devlink dev param show pci/0000:07:00.0 name enable_migration
>>   pci/0000:07:00.0:
>>     name enable_migration type generic
>>       values:
>>         cmode runtime value true
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> 
> Could you please elaborate why exactly is this needed?
> 
>  From my perspective, the migration capability is something that
> is related to the actual function (VF/SF).
> 
> When instantiating/configuring SF/VF, the admin ask for the particular
> function to support live migration. We have port function caps now,
> which is exactly where this makes sense.
> 
> See DEVLINK_PORT_FN_CAP_MIGRATABLE.

Hi Jiri,

Thanks for your questions.  My apologies for not getting your name into 
the To: list – a late Friday afternoon miss.

This enable_migration flag is intended to be similar to the enable_vnet, 
enable_rdma, and similar existing parameters that are used by other core 
devices.

Our pds_core device can be used to support several features (currently 
VFio and vDPA), and this gives the user a way to control how many of the 
features are made available in any particular configuration.  This is to 
be enabled to turn on support for our pds_vfio client devices as a 
whole, not individually port-by-port.  I understand FN_CAP_MIGRATABLE to 
be applied to an individual devlink port, which could be used in 
conjunction with this once the general feature is enable in pds_core.

Thanks,
sln
