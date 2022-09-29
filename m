Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9125EEE0D
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 08:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbiI2GuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 02:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbiI2GuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 02:50:16 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FDC65655
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 23:50:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BwinLluHAtD0LlhynmOOPkelHxeJJNlIotKNwXu68lBUgRyDe2LcGnaRBbLYGEp4TBefC/5AER8AkyFmVpm37/rGUiD4vdf7cvLvVb6+PiY79qY1SjkQk5P+77NeIWpfWUq15+TA2vdaopW3kVg9ebBdufywUE9yEHWjpja96pvxgh7V+oblC3IRUdUlGLiQCiXcSORwkaIgJcZOuxd1cu0cx3eWuh8aVIeWUZdVDHswwS0epiVkdMDnsH3/LflnI98zwwfxSx2Cz8Nr5p4V5WNB621ZfW+0wpBS0job50dqSQer5nw8VujmqRZPPdi8Y53DNwA33Xu8iQNnb+UACQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N7ety/0mz61deOVfHmtUUcBFDHFMJ1SORkNqjoGOP6Q=;
 b=Khb/v4V2XwvwhM7swDiWttRjV3kPHp5XveNGh8cyAhuwU+VbW7XH1D+aPAQ80dFTU5tKO2f4kbzxl6fNPspH89V4wvTL2Q1fJyLeukNnUxSOUS219aaxgmwjL8w1MEFEL5NYB+sAuC9seNgjbhqRS9PM+B3hrLJ78i8k8vO6IVGfW4v+3S24VO1dHIbFt2IIoBuJBGNvQr0ss88y3Ywa2gfZPLEi5am+w5uv38ljgDOQ/4ZIZQyx85dLVoKrxI5yx+lHJzD90I1zPVDPURFb/jhDgz6AyfiPBvzUH0tGV/70spsvSIHKUWRjehKrgSjbCH27zh9YIAYaERuFMM6s1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N7ety/0mz61deOVfHmtUUcBFDHFMJ1SORkNqjoGOP6Q=;
 b=DYIEXq3hIXCgBDVt4J8vEDSc/16JVnzxU5v8tJCYwaQhi47NnHYWbV9nz5UGd5RJtFsLm2L/tfbYJF/Sn9EgAqe4vN9OcCusxuy0jOWUr4hz31cbIkHs6ji3wBMeWVaF+wupau3IeVo5Uin4BW0txFGnFeDAznzRAkUmA0evs2ZSzKXZ47wgxqBn/3BO8yo9UnSRJ64054VZI+UHRRbyvvK8sDMJ70T85RN6L9gYDXU7kUiVE1Enms2OU7S3E2QPwe/mNHroKwhovwK7JS8W9sD22nZG/zp2+EV9omKai2FKAT1YjbJFU/9xjvqiVy2owpw6ue6ha6XmWfY4pLJwwg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by BY5PR12MB4274.namprd12.prod.outlook.com (2603:10b6:a03:206::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15; Thu, 29 Sep
 2022 06:50:12 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::7111:f585:6374:74f1]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::7111:f585:6374:74f1%6]) with mapi id 15.20.5676.017; Thu, 29 Sep 2022
 06:50:11 +0000
Message-ID: <68934c1a-6c75-f410-2c29-1a7edc97aeb9@nvidia.com>
Date:   Thu, 29 Sep 2022 14:50:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [virtio-dev] [PATCH v6 0/2] Improve virtio performance for 9k mtu
Content-Language: en-US
From:   Gavin Li <gavinl@nvidia.com>
To:     mst@redhat.com, stephen@networkplumber.org, davem@davemloft.net,
        jesse.brandeburg@intel.com, kuba@kernel.org,
        sridhar.samudrala@intel.com, jasowang@redhat.com,
        loseweigh@gmail.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org
References: <20220914144911.56422-1-gavinl@nvidia.com>
In-Reply-To: <20220914144911.56422-1-gavinl@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0045.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::14)
 To DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3835:EE_|BY5PR12MB4274:EE_
X-MS-Office365-Filtering-Correlation-Id: a1b9ece8-ac9b-4c12-64b8-08daa1e6daad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Hwr7AdgCh9KFK5Bihur3/B1mFAG+4MEH5PdwxvgOz62GQIMDNPa+7CQkL6kuT9b01wZII7qebELzV/ZHmmaYrX0b63DaudTT4q9VX9E35cOdwY/1uY8KjIcW2WoAe+HMG7OHdXAHKlDOHBiUuhYUnO7MPwXemZINjbLdCTXJC5ZdzvTHRKmt7Q5cyqaPzt7ujENEu8W+RWA0/20Gb8pn4ykoUI7yio5oZvMwGMCihVLN2gicm8d4HHAKtd6S68gFs345xzTKdBOU3PVrAOQX5R9Tb3PjKf09ptNONwrLqoMaCefBfgB4tngQ7SMnGLkG9EavqeXspdMBIu0ezdxvoq/McwzQM19FuqN1jAqPURvVLm96nxqVLaFF5mEah9v81eX/VcAC30A/t58kiOV/jdC5hQk0tq1Mg33jfi7f54ZSFKTu8DHmFCggTTk/vFQ0RH4U8xMeBcA2/kxcTIIPLbKFkiKcVZEdhMvsfd3OG+tf6ygSroCfr9Inowy2nLzKiMU7SUkirJVbWAzJGg0kuc80nt9Bdkbtl0K6tp7XdJVVcuBSfGXkAFvXKVdx1YTgmM75SHsBgxBu/zic48yD3pAnDLgojUdCCVstluyyRE25+a0myNvd4tSizjGNuRJhwangJbSF5ZwEI4+0bmePvsqa1Oh22+o7mtUN3DJmHreFJb7gS4OMD6clP3R2D95u7fgaNVjsK5wjFG3wrZ7xGKrMJIlhZJpbDEGccsN5r8Uvbpgzw4wfP9viu/P5Tpmf+IKw1P0BCrxdDjcOzJKf7UUCsSkenncPrG2FguXDouUtd102pOGNEV2DvV/aVZS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199015)(86362001)(83380400001)(186003)(66476007)(7416002)(66946007)(8676002)(6666004)(316002)(31696002)(8936002)(921005)(26005)(6512007)(66556008)(38100700002)(5660300002)(36756003)(2616005)(6506007)(53546011)(2906002)(31686004)(6486002)(478600001)(41300700001)(66899015)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KzRqb1lhaFV6eW9sN3gvUVZYZFJIaXVYVlhOVU0xZVUxZXVlNmVwQmVDNWdt?=
 =?utf-8?B?bk5vVzNqMnl6NnQ4M2xnaUdXWjB3cFZtZW5YOXdvVW9ZYUhpS2F0enlsVmkr?=
 =?utf-8?B?dnd4dWdqL29wTHFXbDFHeSs0UE96Z1EzM2N0OWRoaFdUL3RzclB0V0g1cjd5?=
 =?utf-8?B?VG9kTHZjZGhIancydlVMYzNWN3NxRFhMZjFBWlc0YWlFajdEbWZBVzFkTmgr?=
 =?utf-8?B?cGwyclNCdnR5dG9Od2JGVjY4WE9SRDNkVmlKK2lzSk53M3hKTEhXSndBM2Nu?=
 =?utf-8?B?ZmQxRzBGTU5Oa3Z6UG4rTU5wMTNBWkN1YUkwUlMyWE9WVDhNRmF3TEZlTTNK?=
 =?utf-8?B?Q09QMGZMSis1QXlxUGU3cURRejRGeVRvZjdxV2tiY3VqSTkyVXIyUG1haUoz?=
 =?utf-8?B?MFJmQ1l5WDh4SnB6WUsyOGc3NDhkbktvbWVUTEpxbzAwZHN1emhVay9JSDZF?=
 =?utf-8?B?YXR2RERoSjh4SGRTd2V1NTVDL0M1WHZ4NWJ2VjcrSEc3eFN2QVdScE1UTFc0?=
 =?utf-8?B?ckRCckhMbzRwQkNRNmR5a2tWdnR4QzJvOHpMdHYrSVUvTDVlRmtWOFkzU1Z2?=
 =?utf-8?B?Mmc0bGxHQ01EZ0hYWEdLYmFwc3JPTXpwcjNQeU9FMSs2NlBMcktDRUtTWEpC?=
 =?utf-8?B?NXpIbHR5U29zMlp3eVQvcUxkMnR3UFJDc2NTVnNvQS9PVTlqR3JydytPdTNE?=
 =?utf-8?B?SlIwZFJIcG1DWW95cUlDUzRVQTE2WFM3cndiSThDZlhabjNXcHJVV3Q3UEE2?=
 =?utf-8?B?UUtEQ0Jyb3dJS1AvNDdxMnNSelQzcU5xdk5ZWmR2OStZRVd3SWpjT0dVMElG?=
 =?utf-8?B?cVZoc2hSWDZ3WXYzU2tZc1RnMlZrc2tnUjBhS0puOElvcDJLZ2hBZldoS1hP?=
 =?utf-8?B?aHlVOU9yYkdOSDJ5MTlGeTdpZTFicnZ0V0oxdzdJY0VzSVFIa0UyZW9ENFNy?=
 =?utf-8?B?UEl2d2IwM0VidldtRUlqanpWbkxlOEo5OHoxeGdBSnJaNnhnVWhuWFFUVUNl?=
 =?utf-8?B?aTN2Q1ZNSDkvL0lNcHljc0IzU2FweGFDZDFaRDZ2eGExbGszYURvTHBMUENa?=
 =?utf-8?B?TjRuU3BMNkRWeDVUaFhDOXhvczQrSndZUU1lemVWWElsdUI0Vjl2T3lsZEZL?=
 =?utf-8?B?amhNRzR3enVjRzVGUWViZnIwb1RxeWY3TkVCdDA5Zlh6cnZYZElLR3MwdjFD?=
 =?utf-8?B?ZThvRm1EWG5YSHdYTll3VmlMKzRqOUhtV04yV2F3NzBCL3FFQ2cvRVIzc0JK?=
 =?utf-8?B?YmVZQ096bVBBU0puMzdUTGs2Wm9nRTFNTkptKzEwS1I0WUI4cWQwL3JTV1c3?=
 =?utf-8?B?ci9vTGsxMzZvT0pXeEl1YitoaU5XUm9vZm9oOXhGT1dVQ3JOUlN6SlZTVDkr?=
 =?utf-8?B?K2E1YUtrVEdtS0I5TTUwZ2VNWVVtZ3pGV1htVDkrd2o1UFZpclJQMVVyVk9q?=
 =?utf-8?B?bjBpR2t5UzZVeUVhSmxPSnlFbURVMVhCLzhJU1R4SkttSnhQbnVpRFltWGNZ?=
 =?utf-8?B?VjJISmFOOHRKdlE0TFRJY0RacG5ROVFSa3dRNzBQN0RjMVZoK0JPRHB3bGl2?=
 =?utf-8?B?TTNTeGVoRHFSY2hienRQbFhzZVQ2QlcvUDJBdWRGdkVBREZGSi9IZEVQN20y?=
 =?utf-8?B?TkZjbDJ4eWs5NVZoL3E5Nnd5ZnkzZzFLS1c1STBzMkJ5MkdGMWhkNnFJTStv?=
 =?utf-8?B?UzAwaTBEWTFKMWo2d3daMHQxL3l5TjhnM2JKMlk3dTFHakYvOVBwYk9BU0RH?=
 =?utf-8?B?NFVLSmlham95UEtISlo0WTlsZ1BNQ2d0eHM0R1lNMXNxa3JVSzRhK0xwZERI?=
 =?utf-8?B?bHNIaXI3OWRmcFlkWFdQaFltV3VldUNUSmU2SVF1eGJkUWlBVlVObjFPZXdw?=
 =?utf-8?B?RG9Fc0xlUTQrNW9iS29nclpKUlZPLzRKU1ZPWmlnSStNeHJhNlZrUnRtNVYr?=
 =?utf-8?B?US9FTFpCRU04UGFqQlNncnNEWUlwRTRLcC9pdUtVN2lzODdpWXVxMG9JQStM?=
 =?utf-8?B?TGkwS2FDTDdzeHNMV09jY1QvRlFFbmNiZ0owbmwva1RoU21uUE5QRnFRVHFv?=
 =?utf-8?B?ZG9TUEdJclpJRFZzeDhpRml3dWE1VldOdi9ndG80RDdab1BEYnJVNVI1VUpm?=
 =?utf-8?Q?cKeH5vqH6wak1MCytVZeQwFeB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1b9ece8-ac9b-4c12-64b8-08daa1e6daad
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 06:50:11.3599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iUPKCgg5GPTR1gsjgLkgwemd/etDRSuTb1YGR0TGMYIcMAUFgH0WvRyGkMRPP4P2VjOhrKS1BH+A4vOEHsHunA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4274
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/14/2022 10:49 PM, Gavin Li wrote:
> External email: Use caution opening links or attachments
>
>
> This small series contains two patches that improves virtio netdevice
> performance for 9K mtu when GRO/ guest TSO is disabled.
>
> Gavin Li (2):
>    virtio-net: introduce and use helper function for guest gso support
>      checks
> ---
> changelog:
> v4->v5
> - Addressed comments from Michael S. Tsirkin
> - Remove unnecessary () in return clause
> v1->v2
> - Add new patch
> ---
>    virtio-net: use mtu size as buffer length for big packets
> ---
> changelog:
> v5->v6
> - Addressed comments from Jason and Michael S. Tsirkin
> - Remove wrong commit log description
> - Rename virtnet_set_big_packets_fields with virtnet_set_big_packets
> - Add more test results for different feature combinations
> v4->v5
> - Addressed comments from Michael S. Tsirkin
> - Improve commit message
> v3->v4
> - Addressed comments from Si-Wei
> - Rename big_packets_sg_num with big_packets_num_skbfrags
> v2->v3
> - Addressed comments from Si-Wei
> - Simplify the condition check to enable the optimization
> v1->v2
> - Addressed comments from Jason, Michael, Si-Wei.
> - Remove the flag of guest GSO support, set sg_num for big packets and
>    use it directly
> - Recalculate sg_num for big packets in virtnet_set_guest_offloads
> - Replace the round up algorithm with DIV_ROUND_UP
> ---
>
>   drivers/net/virtio_net.c | 48 ++++++++++++++++++++++++++--------------
>   1 file changed, 32 insertions(+), 16 deletions(-)
>
> --
> 2.31.1
>
>
> ---------------------------------------------------------------------
> To unsubscribe, e-mail: virtio-dev-unsubscribe@lists.oasis-open.org
> For additional commands, e-mail: virtio-dev-help@lists.oasis-open.org
Did you get a chance to pull these short series?
