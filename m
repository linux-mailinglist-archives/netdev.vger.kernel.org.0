Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B656995C6
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 14:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjBPN2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 08:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjBPN2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 08:28:49 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B871564A8;
        Thu, 16 Feb 2023 05:28:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuqpEdAPCj5cXMbati7UUqOzVhTCuI5UK3qo2McS4RJ9zTi3d+RittYpAKgwVbMzMxqVkM7KkxLh2EtJkFR3tXkOvdRJNrADd4Tu9syoBWZeCuHqauUTZqiHUAR8afKzzf1VPOIsIL0GwtHmcaFxa4WhTmtfTdQRfJCgWWhVoVuUp4F6IuaDdjxPG8Ny7gISOeIj3u1IohiAQpfvGi2RQCoItZPcupOO/15bOVbP9Y1MLyhLxHcvAeKbi+UodRFAYhw1FTGKmb/B4GERZAjb1osEiP2tUWFZs5PeTAgoHQDBokWSa79CDdlBz/Duej7NHYuFpEtIL8KRzGRTfK3kpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KhSizKHqhaBcFxK/LYNuxgwNmCCQBzXchHzJXn07Puw=;
 b=NZIqyiMGGHDwFBb8qzO0kN5fmc9EWvsdT8bz6A/cIwJimgj6sibshs8ey27NdbDN1Sbu1firAltL/Oe/epcXJOd2EOwC6ak3Snoake5mMtcE0e+pbnGi1nrpDUxRSXTQW0Nawan8bzqgwdUXy7udPnc5D1FnVHqrW5UGql5Y0TlLay0IkEB2uTkn2ZVvMZmQGP/xeGNgQ09gwznOVjTzdF97+YIHWNkLj8lhUE4Ac+uFdWRLselhNJ7uPKQF9NspHVgakHlQ0dHmkP7TFmm8DuK60c6ZPB5Iv+xzelbOGCACFD2Iw5YCQDc620k8Fxw7mrOKJrh3FsGt2Gjl+TNZmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhSizKHqhaBcFxK/LYNuxgwNmCCQBzXchHzJXn07Puw=;
 b=nFO4tQQLD8SWi6t90sCApoJDne5Loo/2zZqLZ0kZMFIT3PU2XCN2RcDBNnXoQ3wQuGnqWlhwL4a8Mr6cw1TM0boVuGNkpOeZI/uymhVlMkQllRbTAz43088hYQhFT18OBQokaAiS/gQUqwVOJaeKPdmslVnRycr3YGzdalzx5hb4E0hB2Cd4Z9XhoDwTtLg7waFTh/rigKHgkP9hpaVYYr4Xft5JZbyjrO0NvyAuQAyvLQdBZ+TmOy/zb55b4UdInPdbiPz6hoXX3n5Pt68IGMoKwcEg5o0qD7xQm5NkFm/gaCcPMu7auQ9abWWUdwGQkWYls699lvhKBTFJ1NCbhA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3835.namprd12.prod.outlook.com (2603:10b6:5:1c7::12)
 by CY8PR12MB7414.namprd12.prod.outlook.com (2603:10b6:930:5e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 13:28:46 +0000
Received: from DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b]) by DM6PR12MB3835.namprd12.prod.outlook.com
 ([fe80::4963:ee4e:40e9:8a0b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 13:28:45 +0000
Message-ID: <47ca27c8-b1c4-1566-c6e2-e3323babb2b1@nvidia.com>
Date:   Thu, 16 Feb 2023 21:28:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net-next v2 1/3] vxlan: Expose helper vxlan_build_gbp_hdr
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavi Teitz <gavi@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20230215094102.36844-1-gavinl@nvidia.com>
 <20230215094102.36844-2-gavinl@nvidia.com>
 <3f874bb8638258d131fcb764714b12b5a4c9eb39.camel@redhat.com>
From:   Gavin Li <gavinl@nvidia.com>
In-Reply-To: <3f874bb8638258d131fcb764714b12b5a4c9eb39.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0036.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::22) To DM6PR12MB3835.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3835:EE_|CY8PR12MB7414:EE_
X-MS-Office365-Filtering-Correlation-Id: e770d58f-46a2-454a-236b-08db1021ba96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vDdorwB2GUSb1RBseRN6uO/5p8AXiBGF3JCr9BEKjq3ar6s97lWrVTL0i2ywHdRS5xBlpUUXvOnTtd0hBiL8P8C8c5QQUnRtbvgAA89S5yCeONUHrKccDu1oEZ4X252PtMwsDTyD9Q39FuTch8RQF0SKqp4ld+smxS07fsciVyTSYIVi3GuqXJdr2EyIib1vd7WmIYZw1O+D1o0okKN6aF3n21I2or3i0y6TuE2bng9ZKh68J0cRkXIZIrNRYZITaq7sq8BgkyjdgSWf0Aj0GAOmiVg806recmoLjSSn0W/XVBvbfkkxMhW3KaQpbm/R61cChHlfHLvIQCi0fzDfQNRlFfsYsNF4+q3aaBLkNVMK+EAP08qwZf5pRnopVjQift8y6d8HnnAPITB3yW6xBwWO9DwrBBj7D+w8PLzKFtJNMRT1mJquxySgnQPHyBXsEuO7o2me11koZ1KAYxj7oEDbrmDuufs3GpIOg4Qu7tlUZwB2cdpL/v0IE0woBmLCmfHrZo/je4S4i0GLvc2lRmnu+yr3YhdjHx/eP2t8f6Gu14NeQ90DzsnUgLQj/INh0Ld+b+F7+0JjFmlkjGipRZ3XKyqFglUxl82Y/ko56Ih+IY29RaMv73Jmp/k0yQwk8m2ibOz0fOQy1VtOE76qTuyI0U6EIZZkVZR35k3SQwual9K4H42E6x+LmbTBFMMYCMpS513uEiVG3yImJ1pqM7ywpyMP8Chcg9MMf+9ZpsQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3835.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(451199018)(31686004)(31696002)(2616005)(83380400001)(2906002)(36756003)(186003)(26005)(478600001)(6506007)(6666004)(53546011)(6486002)(41300700001)(4326008)(107886003)(6512007)(316002)(8936002)(8676002)(38100700002)(5660300002)(86362001)(66946007)(66556008)(66476007)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NytoQURVeTFJWCsyak95dGNpMnVHSCs2RU1RT1RUSVNFU3h0Q1pqT3ViMVBM?=
 =?utf-8?B?aGZzVWw3NmxCb1RMUGczUVVLbDUvVFZLeGZSSU5aVDVYZEJydEdySUxEVDFm?=
 =?utf-8?B?UGNTdzVHQWlFdTNwUk9DR040aWVwbGI3LzNVVkhvV3QyRjlpdUVSQVBIN2lI?=
 =?utf-8?B?enZFT3VXb1BUM3lsSTJtUjY0K0RiWG8xU1JjVzUyVVZ5NlJOSW81bU5SYXZD?=
 =?utf-8?B?aStVMEhiZDl3OGVHMUlPREJwZVBDWmUzOGNaR1lmaU5pRkhBRFFJckdZVFBK?=
 =?utf-8?B?OUt1QjJKSTZTZ3hDL00vakJta0JlMXArakRTeVpuYnVvYWtSUjF5ZnZXM3Uv?=
 =?utf-8?B?T1RuMm0vREtkRlBlYkZVVk4wM3hKUHBmdVZvRXVYQjNpNjAySU96NWFFNzhQ?=
 =?utf-8?B?c2ZtdVkyWXhzenJXTDJvLzA4dU96Uk5zZDlBcGtUc3NUSWZya01kWGpYOHFi?=
 =?utf-8?B?d1RuNkQyVmh6cS9aNXJDUVB6aHIzSGptZnhQK3F0OU1zclhHdzBrOUEveDdh?=
 =?utf-8?B?NTJQV25VS3NBMWNXT2hvTzVZVnZENE9RQ0YzNS9sQU5wSk54RWlxeWRzUjIx?=
 =?utf-8?B?d204VzhuczBiVVZ1amdXTUJoWEVmaDB3ZThmTVo2OFJUYmMwUG1pTnNlQUhE?=
 =?utf-8?B?cWoxa1hPekdOT2FZMnI3clZDeDYxWjlsV2t6N01TN3VockdQV05QTFV2Yk9L?=
 =?utf-8?B?VmhhU2N4ZmFSQjNWOFozSEUrYXJjRTRIcUxuY1ovQmlnOUJMNmJDUTJPV3di?=
 =?utf-8?B?WVg2VnNLbkJKNzV0cHp2WjQxRmx1WGtKQ1pXcFNPM2o0ZjRiZjNuVHk1ZFNi?=
 =?utf-8?B?bXlOL3RhL0cwa0xBQklWc2RwVzgvN2VFU29ScmhseFNySlBRVW4ycXZTd3p5?=
 =?utf-8?B?NDhnQmszMllzQXowNUcyNTB6bkFKM0hlRnlnU3gzNjQ1YWlQaVQzMUVSZWpy?=
 =?utf-8?B?OEJnRVBWQmZXckI1OVgyMVlFME9LMWQ4Tm15ckwza09MK0xST2dmZm9aSmRh?=
 =?utf-8?B?K05HS20yL0hxUzUvdHJDRkRwYkMycXVkQ1JiK2JxSjVPTXpGWEo3RDRLbDJH?=
 =?utf-8?B?TmNmamU5cUxZQ1dRcWJaM2RTNUVBVk1BL1VLT2xjWjZ5NmtPc0FzaFVpLzNV?=
 =?utf-8?B?eVpFQk5CYVFoMFVEUG5qQnN6cVdCcHBXS3Z3WWptWUNPcVlWQ1VNbEk1ZC8y?=
 =?utf-8?B?SEpjczBTKzIzSWQ2eWpVTXExY3ZCek5USkxaclBqQU5wanMvT0oxb2plNVQr?=
 =?utf-8?B?YUMwTDhlVU5VdDRGSXM2aHkzcjByS2dnY1NIZVpMQzJwWExKZ1pXVkl3MHBH?=
 =?utf-8?B?WTZmV0M1cVBzK0YyeG1QYW9yd21Jc3lDaEtxRUlzQ2tKbG5FSTM5bi9HQ2FM?=
 =?utf-8?B?ZDRvUkdVQTN3TzlyOHhlRlFCR1RDL3B2UU96QUtOQ0RGdEhvVUIwTUtFUzN4?=
 =?utf-8?B?R1hXblZFNHlYYXIzSGZzM21aS1BZMGNpdUphMGdYUDBQSkZPRkVDTlYvSlMx?=
 =?utf-8?B?NzRBNm0rVXVVRUZMNjhnRnJINWk0cWNVMXhVdUlKdytuLytRQ0xqWHYrbmVN?=
 =?utf-8?B?bWxyUEhLL1VsYmhDS3RKV1lISWRRc1pKemdad25VZ1Rtd3MvWi9nQ2JFUEdU?=
 =?utf-8?B?NURIU2JuVkhCa2x4L2pOSit0WTM3YXRQTXRMT0ZyVGNpUTRoTktFakxiZUxz?=
 =?utf-8?B?bjJUdjJNdzd2L2g3RGRDVzZRMUgxZ0M2N3BBQUtzMU4rYVBBTnYrVjE0RjZv?=
 =?utf-8?B?QnI0REtyVkoxV3o1R3I4SlVSTlpPSUQzbUVZYm00Sk9DT2tGc2x3a2lIWGhp?=
 =?utf-8?B?YXlTVFUrTGdKejhMSnV2TDh1S09lL0FRTVZEU1RUbitwakNhMERkOWtISmlw?=
 =?utf-8?B?Njg4QmpGLzNwQ01iTW5mYm4rSVNUQzF5SEhqZDVHUWlWcUpGbFlDbDdMM0dl?=
 =?utf-8?B?MHpIYWNRWHhzdU9XRWxyck1KejJBd1doYnNReUhwbElrekFValV4UDJVemNO?=
 =?utf-8?B?N1BxOWpFOFJxNU1VSVp1Z3ZyeEtqMzNFUG5QT1JiNkR3Z2xtTGxBV2tqRTJj?=
 =?utf-8?B?OWJUYk1hbDExS1drS1lpZGpLejZRTHlVUEhXdGt1WVhsejV2bUl0OUF1ZVBs?=
 =?utf-8?Q?kXovRv1BwhjhfbDnZoOnVLSNs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e770d58f-46a2-454a-236b-08db1021ba96
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3835.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 13:28:45.6861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rcKu9Xjl9vWo2xYlIZABruu8IsNIvIfICf0q5Q8IIJqYX6xy4tvxoMpAC5o3v+MOvhy97KqjlMzJ64mjTUwtuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7414
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/16/2023 7:57 PM, Paolo Abeni wrote:
> External email: Use caution opening links or attachments
>
>
> On Wed, 2023-02-15 at 11:41 +0200, Gavin Li wrote:
>> vxlan_build_gbp_hdr will be used by other modules to build gbp option in
>> vxlan header according to gbp flags.
>>
>> Signed-off-by: Gavin Li <gavinl@nvidia.com>
>> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
>> Reviewed-by: Roi Dayan <roid@nvidia.com>
>> Reviewed-by: Maor Dickman <maord@nvidia.com>
>> Acked-by: Saeed Mahameed <saeedm@nvidia.com>
>> ---
>>   drivers/net/vxlan/vxlan_core.c | 20 --------------------
>>   include/net/vxlan.h            | 20 ++++++++++++++++++++
>>   2 files changed, 20 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
>> index b1b179effe2a..bd44467a5a39 100644
>> --- a/drivers/net/vxlan/vxlan_core.c
>> +++ b/drivers/net/vxlan/vxlan_core.c
>> @@ -2140,26 +2140,6 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
>>        return false;
>>   }
>>
>> -static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, u32 vxflags,
>> -                             struct vxlan_metadata *md)
>> -{
>> -     struct vxlanhdr_gbp *gbp;
>> -
>> -     if (!md->gbp)
>> -             return;
>> -
>> -     gbp = (struct vxlanhdr_gbp *)vxh;
>> -     vxh->vx_flags |= VXLAN_HF_GBP;
>> -
>> -     if (md->gbp & VXLAN_GBP_DONT_LEARN)
>> -             gbp->dont_learn = 1;
>> -
>> -     if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
>> -             gbp->policy_applied = 1;
>> -
>> -     gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
>> -}
>> -
>>   static int vxlan_build_gpe_hdr(struct vxlanhdr *vxh, u32 vxflags,
>>                               __be16 protocol)
>>   {
>> diff --git a/include/net/vxlan.h b/include/net/vxlan.h
>> index bca5b01af247..02b01a6034a2 100644
>> --- a/include/net/vxlan.h
>> +++ b/include/net/vxlan.h
>> @@ -566,4 +566,24 @@ static inline bool vxlan_fdb_nh_path_select(struct nexthop *nh,
>>        return true;
>>   }
>>
>> +static inline void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, u32 vxflags,
>> +                                    const struct vxlan_metadata *md)
> Calling this helper causes a warning on patch 3 due to different types
> for the 2nd argument. The warning could be addressed there with an
> explicit cast but it looks like 'vxflags' is not used at all here.
>
> I suggest to add a preparation patch dropping such argument (and the
> same for vxlan_build_gpe_hdr(), still in the same patch), should be
> cleaner.
ACK
>
> Thanks,
>
> Paolo
>
