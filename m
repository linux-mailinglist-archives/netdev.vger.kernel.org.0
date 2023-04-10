Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD136DCB89
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 21:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjDJT1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 15:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjDJT1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 15:27:35 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDD319B3
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 12:27:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bAjKzFYBv1I0MsKINHHsNGLBDWdycAbFuJn23Ok470u3+MHhAvq0v2W+ErSWxU+WRWFK45Fp1IOABJ5WmvdPQM17I8Ass6I3hFU/fgwym/G3nJHbRwGFRNbw0UXHzBLEsA7pRCgURA7FHOHVwwYTtzHBm5BIE0s3wO62E9cLkko3jWBxyYFMDTFabOcJiem7ljK7F3/mLefY6ggrx/NvMt9HgEro/u0t8mbUbRk52FY4286MuHugGuUox5kuVbxHj4lgrw1QKjDmLIWLMkor/Y6VRnc4eZU4FVCd9Ct5Mo97zy6qhcnMBb3KlHGG48wwZvWCJT8xxUm+QMNPnj1gJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IRKiIQiOvZ5BDznzivM68YvwS3h4g5logiJra0VN3+Q=;
 b=O2luZHvuFzM0T61zknjlwp3CGyFl+0hkPtFCGmFONOTNnuvT67FrC98HDVHOARMal7ehPyEWXgwJLkUZ289Q2cvPUX1OTA9Zf9aTUMmHZ2icBCT+L7F2f5vFRP9j6r01+Te3f/Q28afBQ8bfykfSv7jpOVhK7q9hM8WcK+ikt5OvMh+JoRMXkJKFPHaEQwglfGrnXoQSHOxzOLvT1C17a/XdUX2yqy/giDMVlidxVVf3W+r1l9twzjg8moYtUYznizS/zGMkC+vicnhD69WyZeX4pbDazAGvFVvOGfJ9bhYumZU3GoMG78eCveZnSDhyAnTFuAGVNNE8c7Klz+Grww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRKiIQiOvZ5BDznzivM68YvwS3h4g5logiJra0VN3+Q=;
 b=BFN6GFhG8D5vUSXa97ESsDDF2KHZtpuNt94bUnQ2AMuS7ACqP/K1XYbT7Cr3ulgcU2Kv6pQzKE9SE8rmPJk8QEb3dFD2O0UrBF2JwVDm6HHRC9z0Wl7xWa/YXQCWj8JOaJbF7Fc2TZgBBkJfFFAdLlwsqlEi81qMuZ5bZtGbB8k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DM4PR12MB6111.namprd12.prod.outlook.com (2603:10b6:8:ac::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.36; Mon, 10 Apr 2023 19:27:31 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 19:27:31 +0000
Message-ID: <5635d3b3-0355-f22c-64c3-34036d743ec2@amd.com>
Date:   Mon, 10 Apr 2023 12:27:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v9 net-next 05/14] pds_core: set up device and adminq
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-6-shannon.nelson@amd.com>
 <20230409120320.GD182481@unreal>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230409120320.GD182481@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0058.prod.exchangelabs.com (2603:10b6:a03:94::35)
 To DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DM4PR12MB6111:EE_
X-MS-Office365-Filtering-Correlation-Id: 165cf8fd-b0db-4fde-50ea-08db39f9a09a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mhwS1b7Sml1rkqtowOlxCHUN6GpJjTUzKkdlCeAFlzrHEoVX9UF0cfeBf8AuTs6up1y8Yrx60eIEt1huWhCGuPXa2VjTPb43k3D+OqKLdKN7KFxYzAReLhhyoPCBFSI1Kdl5xCl1ZURhdb5XSb2prGvJ0hUqS43R6QPf2pxZBe1PeFduNkRZC1k8LcUaFAiVvfatl4m2XVbK5JB8nNazH/n2vqt4OhCDjVwSKR9ytgdfTcPKJAaV4pt+Nn8LX00EvjRDDaAwo/R02OGGyEAYxHSCd7ST4s58hucr7QPm+cNZCP4OYt0FFehnVFz983EBSaC8lb+WZobbenGjjDEXkooSAvVhKJJnR0VMSdtpOwdyrbsP9K47Juju0t8fGQ2JlhWR2VH8tJrhoWv2Z+2mh9KTB6PZZ2O8c+4qDoM+ZJ8jJUZmP0QVkphAIuSYCv5IF4yHc6B+e/S2s2pEzJEYpeuTUrzZOgUu9rNkFYLu60D9yuU7pd0npSD06/JNzFJYGMcTNs2rTGBv1/wCKgocYbFTFnBYwIFaHAfPs1l/eQvJ7uCSBXnDsNzkkJCLhe1InZsqz6droAxL4tOb3dbvKJYZK1q/9Ct9YWoKG/9OBnGhYZytS8a5PsA+chArkAGKk/4/Jx/992cmWlv/w2en7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(366004)(376002)(136003)(451199021)(2616005)(478600001)(6512007)(26005)(6506007)(83380400001)(6666004)(6486002)(41300700001)(316002)(66476007)(66556008)(4326008)(6916009)(53546011)(186003)(66946007)(31686004)(38100700002)(2906002)(5660300002)(44832011)(36756003)(31696002)(86362001)(8936002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFJSSWpCczF2MFNBaU0zMU1OQ05ZWUlBcG5MbHdqbWczaHd4Vk1yd1orWndi?=
 =?utf-8?B?aVJZRzFMZCthUkpyWDkwY1ZVNmI4WGFhTytqc1lhUFF0MWdadVRzbDdwRDl4?=
 =?utf-8?B?NWxCaDhVZnVBYjBwRkJVU3oyZG8yUXliSzRnVEhlRkFnWUVpOCs0d2pML1FV?=
 =?utf-8?B?M3h0amZHVE9UWUh6WmpjWXZNUXg0aWI1alVlM3YzVkZub1F0OFdna1kzd2VU?=
 =?utf-8?B?ejdmalBPN3dKc3FIaWkrdFZJdkJoRnh6bFV2MmpXeEJiZ0xaSzE2SFM4QThR?=
 =?utf-8?B?WlZWb050TWZWUDdwckJvL3VNdmRtRUdxWjR1a1hSaElHcVhUaXJnQWtienVV?=
 =?utf-8?B?RjV4ZENtUm0xT01ScHloWGZ1dURaSjkwRnRtc3hYaFJaNlBSbUF1UHo4ZWdx?=
 =?utf-8?B?c3BaVThJc3FZeFg4aU9GZmVCNTRmdFBkVTE0anBadkRhWUhJZ2IyT2VjTkZT?=
 =?utf-8?B?ZElEdjAwMjFMcmhTUTdvNUVEUndKWkdpVXFTWVNkMVNLRThlRTdiMlQ0VEJC?=
 =?utf-8?B?ZmlCcjFnT0FCMFc5YUJ5UlkwSEhwdUlVWnU2TGpibmdQSDJXNk41UjNvTlRp?=
 =?utf-8?B?NmwzbHhoNHRPS3h0UktrZi8yTmZGVW9ITjJSSS8zNEVERktpU2FkUFRFTVV1?=
 =?utf-8?B?dWdZTWc4cFZjVU9GRk9nbjZ3bDNBbk5ELzBJOUFoOWVnSVZPRVRVRVZDUUdD?=
 =?utf-8?B?Y3c2TEFKM3pTTDMzSmJjOExXaTlKbkN0YmI3VmRlZEg1c1dHWkZXbFVabnlR?=
 =?utf-8?B?OFVYT0c4SHpmQjhycm1ZZDZoYkVTb3FuVlpPTHFTakYwOW5vMkg3emM1RTVW?=
 =?utf-8?B?c3Vub0xaUWlLQUxBL1NWMDBMN2Y2VDBlNEM4MlVCajJoNFM3VXd3eTRydHp5?=
 =?utf-8?B?SC9mZXJtM2J1ZVk3dlBTRjI2MWZtWEsxbTJ0QWtZc1JqZnlzRnpveHlqYnZK?=
 =?utf-8?B?ZE5mOXVWdjdkc05vWnoveENRV2J6ODZJajBuelNkdTVDbXZaQi82QkVjaWYr?=
 =?utf-8?B?cXhFSEVQa1RaL0FsQ0RyaXYya2NkTEg4OTVVQ1VpYUUwd09OM3AyaUhoNWZ3?=
 =?utf-8?B?V1NJZGNMRVM2MEpTWFZtdk9pbW15WnF2SngxZFRTMFNPaHNTb2x1ZXZzZjV3?=
 =?utf-8?B?Q1ZsUVB1NGtMb3lLZ0l0RW9GYnR6dGNSV1VNY1pyakY3NjB4VnBRd2I0V1FF?=
 =?utf-8?B?TjRFT0E1Sm5JeTRmSC82eEhvSGdGR0lLcWNyNnVnSjE1UmhVbW41VDl6b1Vj?=
 =?utf-8?B?aW9pVE15NWRMVmdUb2lKTStNYVc5cTk3REJ4Tnk4TmxqbHFZcUFEM2RhcHJX?=
 =?utf-8?B?M3lzNjBwYU0wVXFIUmRMRHVwZEZKUkxLVVFpcnEzcGx4Q2YvUkZmUnFFbFho?=
 =?utf-8?B?czJFU1lnTGpyQzdxamovU2tsd1FQYlpGMkRIand0UDBwSmwwcnBrbUZXaFNj?=
 =?utf-8?B?cUIvRVh3UVNRc3haWkdwYVRyVEFzRUpqUVhDclVWamxzRTBjakR6bnlZWGlE?=
 =?utf-8?B?Z21wWS94MTMxcXM5MVBvZk9NYWNreG16emdyL0pWNGdQZEtxalNJdmpReGFh?=
 =?utf-8?B?K2dLWHBJMHhnK0hKQVhlRmY0ZmcrazUyRFcwRFQ3L2NLTlYzUU05T283dGsv?=
 =?utf-8?B?Y00wYXRKbnZzVjY1azBiZmN0dHVsazRPMGd5aVNqdDQyTGNyZkxxbndMQzlI?=
 =?utf-8?B?Qjh6N3duZWxoeDRoTk8wM1VZdHREQ0dBT0tPbXRQcWpwWXFhcVA4K1o1RGxq?=
 =?utf-8?B?OE1nNStVTWlrUjRaK1R2NzRPeG03Vlk0YkJWWlF6U0pJK1EvUExDci9FVkdD?=
 =?utf-8?B?aUxaeTdvNy9UblQxNzlUaFVOSWxramlvNXVoV3N3Q2hmUGtxZzB6eFdkb25I?=
 =?utf-8?B?VkpVdDU3WFExR2tyN05EMEEyYzFGcm9RTjVteFZWZ05rQit1NnF3aVZKZklX?=
 =?utf-8?B?TC9melV6VzVPUGRsUFYxNW1nRENGZFdKeEJuaVpFem9XaStGRDl2Q1krVDVj?=
 =?utf-8?B?bnRLQnRMb1pybWxoTWhBaEZtcElBQnF5eUF0aExpeWl6ZTJ0UE9BY24wVjk4?=
 =?utf-8?B?WS9wcGhPUXdGeGJIVEtiaFIvWnZIM1FMc2pjRmJwUjJvby8wSUpSSlZDZ2Zy?=
 =?utf-8?Q?vqX8YnoGVkeR8MjEweDLuvQWD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 165cf8fd-b0db-4fde-50ea-08db39f9a09a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 19:27:30.9124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cWBCzg8bu0I48ZLsivCEhCNV5jvtVlSZn83ZtEg3yny8Gq0I3toZpqBkcUXRG2pZeIEWmKUrlK6OFpcewXvZcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6111
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/23 5:03 AM, Leon Romanovsky wrote:
> 
> On Thu, Apr 06, 2023 at 04:41:34PM -0700, Shannon Nelson wrote:
>> Set up the basic adminq and notifyq queue structures.  These are
>> used mostly by the client drivers for feature configuration.
>> These are essentially the same adminq and notifyq as in the
>> ionic driver.
>>
>> Part of this includes querying for device identity and FW
>> information, so we can make that available to devlink dev info.
>>
>>    $ devlink dev info pci/0000:b5:00.0
>>    pci/0000:b5:00.0:
>>      driver pds_core
>>      serial_number FLM18420073
>>      versions:
>>          fixed:
>>            asic.id 0x0
>>            asic.rev 0x0
>>          running:
>>            fw 1.51.0-73
>>          stored:
>>            fw.goldfw 1.15.9-C-22
>>            fw.mainfwa 1.60.0-73
>>            fw.mainfwb 1.60.0-57
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   .../device_drivers/ethernet/amd/pds_core.rst  |  47 ++
>>   drivers/net/ethernet/amd/pds_core/core.c      | 450 ++++++++++++-
>>   drivers/net/ethernet/amd/pds_core/core.h      | 154 +++++
>>   drivers/net/ethernet/amd/pds_core/debugfs.c   |  76 +++
>>   drivers/net/ethernet/amd/pds_core/devlink.c   |  61 ++
>>   drivers/net/ethernet/amd/pds_core/main.c      |  17 +-
>>   include/linux/pds/pds_adminq.h                | 637 ++++++++++++++++++
>>   7 files changed, 1438 insertions(+), 4 deletions(-)
>>   create mode 100644 include/linux/pds/pds_adminq.h
> 
> <...>
> 
>> +void pdsc_stop(struct pdsc *pdsc)
>> +{
>> +     if (pdsc->wq)
>> +             flush_workqueue(pdsc->wq);
>> +
>> +     pdsc_mask_interrupts(pdsc);
>> +}
>> +
> 
> <...>
> 
>>   static const struct devlink_ops pdsc_dl_vf_ops = {
>> @@ -332,6 +346,7 @@ static void pdsc_remove(struct pci_dev *pdev)
>>                mutex_lock(&pdsc->config_lock);
>>                set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
>>
>> +             pdsc_stop(pdsc);
> 
> You are calling to flush this workqueue in a couple of line above.

I guess we really want it flushed...
I'll look at that to see if we really need the extra flushing.


> 
>>                pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
>>                mutex_unlock(&pdsc->config_lock);
>>                mutex_destroy(&pdsc->config_lock);
>> diff --git a/include/linux/pds/pds_adminq.h b/include/linux/pds/pds_adminq.h
>> new file mode 100644
>> index 000000000000..9cd58b7f5fb2
>> --- /dev/null
>> +++ b/include/linux/pds/pds_adminq.h
>> @@ -0,0 +1,637 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
>> +
> 
> <...>
> 
>> +/* The color bit is a 'done' bit for the completion descriptors
>> + * where the meaning alternates between '1' and '0' for alternating
>> + * passes through the completion descriptor ring.
>> + */
>> +static inline u8 pdsc_color_match(u8 color, u8 done_color)
> 
> static inline bool?

Sure.

> 
>> +{
>> +     return (!!(color & PDS_COMP_COLOR_MASK)) == done_color;
>> +}
>> +#endif /* _PDS_CORE_ADMINQ_H_ */
>> --
>> 2.17.1
>>
