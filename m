Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6844E6D33C5
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 22:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjDAUPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 16:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjDAUPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 16:15:13 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2086.outbound.protection.outlook.com [40.107.101.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82162659E
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 13:15:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZZ/xW5tOJrdStrPmpkPmMz8pbrZYuPfhG4DGFTJ/c9atgEB7QF4t/Z2uvuGFK7JGAkZqJXG6cUQq0OXwrRzPGfRTxS65KD8nsPeuPrNW5vTSGYblaVz1NwouCJVLLhj/vKDsvG1vZY2L9m+1/I1qrpf3b6Ucj/fd+yPrn74ZJ7lAtL5mrNQmvClp70QHOHWCXgOXVqnkdKlVbpmtx+xco5D2uDSK/+VBUP8IfxXei65vFf8t5MkYi6gcu//qEwRB792YswHXG/okJGG3FNwaUKVE5jzAKsrSdlbfJeK860tu8Q5HeAnyBIQ+gOASm3HXhMKe1rnMw4xPc+Z3GVlVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=70fTRgTjx/o0cwdkDZgx0uxYI6qiZWK42oqZ+ZwPs9k=;
 b=h1be5+mqxpYNhqmB1QU/Oy0D8LFwPeWVLKywVOZYBbpK537elA5xECafTPe5ZK6fCiT11RAonOk3oXu1VnlXnr2xUSPgoUb8qOKsjurjoKs0Wojml+sHqKoedgPFO1WCWogUJeEHcCVEgKuk0HJAmAeAzBNjkYKOsvyzdvSv6bxPlWzi18r3RWMJnGI3yFrUJQKssUEPYPH/BiYATgvB64iHG41vmafQqd7r68GbrmTzJbVNOR/ngQMCbT/MitVNL+2SrhBKPLDBGDopB+NMMg7yNupt+/Xidu3puYdWGDZnD6jWSVoNdKPz5SAkO3GHK6IHQ6HiLRiZDjTev4s9CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70fTRgTjx/o0cwdkDZgx0uxYI6qiZWK42oqZ+ZwPs9k=;
 b=U94GmGvg7uM9zM5qdL6eJrpUph1UbT52Auk7cWHrnjnAyquDEe+t+/N5QptVjPCasZH3b1+YvX0a80JGxJaB6phGx93dxIE3wrJ4YoqT1OgRhRUJCHbFot+4KQ3HWgEMhJoE10X8UF3KD/i0SQtko8SytgarpRtVH+2uSC5mdEM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DS7PR12MB6022.namprd12.prod.outlook.com (2603:10b6:8:86::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.28; Sat, 1 Apr 2023 20:15:07 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%5]) with mapi id 15.20.6254.022; Sat, 1 Apr 2023
 20:15:07 +0000
Message-ID: <fc39973a-3f57-87d0-ff46-15a09e9b5f58@amd.com>
Date:   Sat, 1 Apr 2023 13:15:03 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v8 net-next 10/14] pds_core: add auxiliary_bus devices
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
References: <20230330234628.14627-1-shannon.nelson@amd.com>
 <20230330234628.14627-11-shannon.nelson@amd.com>
 <20230401182701.GA831478@unreal>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230401182701.GA831478@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0068.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::13) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DS7PR12MB6022:EE_
X-MS-Office365-Filtering-Correlation-Id: a94ed3b0-195a-4c85-135a-08db32edc92d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6aeykPx6KPnd2x5Uj1F5J27KxhkPX9t+TzTBG2nV4cMHtlYA0v5xbSVEbtIwoHCoSNfE3FqGOK+fqjmBinSzLbsmcBL/862MJ4mtflEYiTS9sxF7MhW+7FzDsfORqNazV7NB2/YUviSKyT5fbYOeRbvd467auMH6gXbAsog29BvkEZA0fDZ41oA5/LzRh1sBmboFSpJpDzN4Shm+mkrZumwbN3m9wm/QVFKvRsqnQFyTHrB9OPHe9w7+q9wk1+ZKQZF++zVPZTqnCxXGuRYOHKKl/cz4sW62iku5xz/NkFkRHT3DbsfzaK43dqbmqUILtGtxe3gOPAE7thAUofgUT9AoaWTEMz1qUB4c4WJoWvF6aEZMRwfaTY6ji155iOg1/NunoFUErHx0MqgxxlFnBwZJqKSASs6RYNxS2jows2D2EEgpUNJgDZJTPVhbHWSJSZHGKrRYOQT03NNIEl3ipvNxQC/KWuJSt31+8iswO/g4Oi0HSgsreZanuGuNWbYdL2AHSOHfcUhvaoNXHXAYYBCIfVRFZ72O3PFsC7JuoOV6pd2JW0jqloXPwB3op/QetoA3keR7iraGBIvBOvIzIyRktU86hjfgkZbSzBRN81tdIQFvojc0OqsqanNhBc5TPb7FRilrCwYIc+gOKXp7QuPbzOwCYATypoqi5L7Gdso=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(346002)(39860400002)(366004)(451199021)(6512007)(6506007)(6666004)(53546011)(26005)(83380400001)(66476007)(66556008)(66946007)(38100700002)(41300700001)(2616005)(31686004)(6486002)(186003)(478600001)(66899021)(2906002)(44832011)(86362001)(31696002)(8676002)(6916009)(4326008)(5660300002)(316002)(36756003)(8936002)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T29SQVZmQjNrTGVFbnZETko5RVhIMVg5V2FKN0pZUGdQbEJlYXB1Y0szWTh2?=
 =?utf-8?B?SkhmSFNENUN3RTlrbnZzVFI3aU15MmdjcHVnL1VDZ1FITWFQQlE0b1FiVUVs?=
 =?utf-8?B?M1ZOeHBtMVZpcldPaFlGa2NEb0EyVVE5Wmx1MHZlNmoyV3RIWlhrY1ozUHBz?=
 =?utf-8?B?Y2dUcDg3TnBaTXVTNnRIT3Ruc0JOTG9IYURhYTdmODFVSFZiR2dhaW1mSXk2?=
 =?utf-8?B?VGZKMXlNZzZIQ1J1Y3NoOW5HUGNlMUttVW16VUErNmVnVXBYbzVOdEpYRDZy?=
 =?utf-8?B?WGlkQ1dGQzUycFhSNE9TdjEza2h4RnhOYXVPbFptZWM2RHh3Nm0vNzdWbmxx?=
 =?utf-8?B?d0FhL2NDRWZwcVAwdlJ4ZWNMOWgzZFMreWhoMGJVaUZzbDVQWTBDU0R1UjJy?=
 =?utf-8?B?Ly92aWVTN2gxUjZhdWZlSUR1bFRDZ0VRVlRqVzdMd3dnSDVqQ3ZhTnh3NHVH?=
 =?utf-8?B?UGlLVHU4RUdKbG1jaEdMamNrazluRTRabmY3cC9wNGUxd01TbWFra3ptTEpy?=
 =?utf-8?B?ZjFsa0pRY3VtcDh6QnB0TThRSG85V0ZoSFE1bitnaHVuSWFNTVBvd0M5RGgz?=
 =?utf-8?B?Qkw5TjEyZXNZR05TRjFmRFNJdTFDbnFOdEIxNzRic1RURXVuMTBlaHBqMklM?=
 =?utf-8?B?ZGMrNGI1WHFDakVtL2JCVWRpSG9kT3R3SEdWMlRHZ0pTMlBKQm1nUyt5QVV6?=
 =?utf-8?B?WE5JNGJUdFh1UWxLNXFDY2hnd3NUTUFmZ083MDQ0TFplUkVLZ3BtV2JibUlO?=
 =?utf-8?B?L1lBbG1xbmwwaDh1Z2FvbVZMQ2M5MlVwOU11NW0wM1BmNTlNYnBuLzkxZzI4?=
 =?utf-8?B?THNNQlFkMjBCSHFMKzJDbnV6dFlRQ0Y1dmtQWXZGWE1HTU4vdGh4NnNrSGUr?=
 =?utf-8?B?ZWl1cjIzZHVzUFJkb3JIYzVpNlBUWXJmblJSdERPNVZtdFFVZlBNblNnM1gr?=
 =?utf-8?B?VGltRTNvRHFGQjlJWHJ5bFhqYnVNWlVaL3Q3Vkk5Y3FPOWdMVGNBcm56ZjY0?=
 =?utf-8?B?UHVuM2lnRVM5STF5NFliZG9vUnpWNFNzTmlMQVh3TTc4Y0k1S085ZVI4eG5W?=
 =?utf-8?B?aFlPOGdlV092NWthMWtyQ2IzOEpwQUwwYzczR215Rmk1QzRZZ0JmYUZrNnNK?=
 =?utf-8?B?VVNBUVEwVmMxZ3J2NzRzNjhJMXVGUFFma1F4NlJVd043VU8xN1NUbm9WOFhl?=
 =?utf-8?B?alBYbXgxMzY3c1dSRVpsN21rRzlqVGJxdzFabHFPditGMVpVYWVVQ2xBdi8w?=
 =?utf-8?B?cFdEM2U0ZkRmU2haRG9ZS0VKc1FEZ1UvdGtkSU9BUWJDOWgyZmVkWVFtU0ps?=
 =?utf-8?B?Ykt6S1RzdmphREsvQ3d5TXh0UTJjdHk0cTczazE0ZEtzZGF5K1V2UnRaaFpl?=
 =?utf-8?B?ajJqc1hpODd1RUlQMkU4d1Q2bURGMGkwaCsyd2RVKzVSUWQ3VE5CK2FlcmtQ?=
 =?utf-8?B?VG9EcngwRkp5RjVSSUVUYXVUT0NqUGRjM0VtcmtGcGZ2c2FiYTk3Z3BqZEhZ?=
 =?utf-8?B?SHRHa2RvbVdyT3JML0pDQVV4dVZDa2xnU0JDUjJ3OU5TUVdXQnRrbXdqNDRD?=
 =?utf-8?B?dmhjRnpaaFpCa2hxR3dyVzFGNHE5K2FiMXY1UjdvYWQzM2xXOFI2NzhiV01P?=
 =?utf-8?B?R0FtT2Y4UTA3TGJJVlJrZE1xR3FsaDYxbHBacU9vUTRKcXV6bUIwdXdEM21R?=
 =?utf-8?B?VG4rUnVaZDl2K0l5SU5aVG5JVURzUTJQdTE3Y0VUdjVmODB3R3RjTTcrZmdP?=
 =?utf-8?B?NGZ0K3JydE1hQ29DZEdZRGlpUU5jSkRwSTVCS3U2bXJpK2xIMUxmVDJqRVNP?=
 =?utf-8?B?UUZCaTFvbWxWOGRmTmwxQ2VlYXNBbDN3alg4Qlh2U2tZUEJMN3M0S0tzNDdU?=
 =?utf-8?B?TllrK1ZoZ2EyM2tVejMyd0hBMkV1UGlXa0IvV2xwVW9DVWRQNXVlb0w1OVVJ?=
 =?utf-8?B?NnZyZGhnYWFlTW95SDBGZm5EM1hoeUlsSU53QmJqM00zZnJpTHBWY3BzM3k4?=
 =?utf-8?B?RFBqYkxSOFBsK1hsRmdhUmp0WDFFU3FvMitpeThYMUpqOStUemErM25uU1Fk?=
 =?utf-8?B?QjBOOHpHL29LdEFGUEhKUHFDMDFRaXJQMkdwK2N6ZlZ5MFN6V3ZJbVV2VEVW?=
 =?utf-8?Q?01cT3SUVm5mn3HA1vDZ39YB1o?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a94ed3b0-195a-4c85-135a-08db32edc92d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 20:15:06.8519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R33BL7RD6EtAFS6242Yt4fCOBCVwiaMLyhArm+KjUbWoss0e3hswULhY8mkXM8rgaKp2yFtD9uPqHUarRu3w5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6022
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/1/23 11:27 AM, Leon Romanovsky wrote:
> 
> On Thu, Mar 30, 2023 at 04:46:24PM -0700, Shannon Nelson wrote:
>> An auxiliary_bus device is created for each vDPA type VF at VF probe
>> and destroyed at VF remove.  The VFs are always removed on PF remove, so
>> there should be no issues with VFs trying to access missing PF structures.
>>
>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>> ---
>>   drivers/net/ethernet/amd/pds_core/Makefile |   1 +
>>   drivers/net/ethernet/amd/pds_core/auxbus.c | 142 +++++++++++++++++++++
>>   drivers/net/ethernet/amd/pds_core/core.h   |   6 +
>>   drivers/net/ethernet/amd/pds_core/main.c   |  36 +++++-
>>   include/linux/pds/pds_auxbus.h             |  16 +++
>>   include/linux/pds/pds_common.h             |   1 +
>>   6 files changed, 200 insertions(+), 2 deletions(-)
>>   create mode 100644 drivers/net/ethernet/amd/pds_core/auxbus.c
>>   create mode 100644 include/linux/pds/pds_auxbus.h
> 
> I feel that this auxbus usage is still not correct.
> 
> The idea of auxiliary devices is to partition physical device (for
> example PCI device) to different sub-devices, where every sub-device
> belongs to different sub-system. It is not intended to create per-VF
> devices.
> 
> In your case, you should create XXX vDPA auxiliary devices which are
> connected in one-to-one scheme to their PCI VF counterpart.

I don't understand - first I read
     "It is not intended to create per-VF devices"
and then
     "you should create XXX vDPA auxiliary devices which are
     connected in one-to-one scheme to their PCI VF counterpart."
These seem at first to be directly contradictory statements, so maybe 
I'm missing some nuance.

We have a PF device that has an adminq, VF devices that don't have an 
adminq, and the adminq is needed for some basic setup before the rest of 
the vDPA driver can use the VF.  To access the PF's adminq we set up an 
auxiliary device per feature in each VF - but currently only offer one 
feature (vDPA) and no sub-devices yet.  We're trying to plan for the future.

Is it that we only have one feature per VF so far is what is causing the 
discomfort?

sln

