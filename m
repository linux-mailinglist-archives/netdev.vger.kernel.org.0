Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628BE69D757
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 00:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbjBTXy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 18:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbjBTXy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 18:54:26 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2040.outbound.protection.outlook.com [40.107.102.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7B51E1EA
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 15:53:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8Qn1icfO/8j2L0DgbPGfqCqRdaMpZc3waSbP5Uxfa+F8AIP16yj40vQmbgek6e+S1eBgpYt36M+rYGeXKSaEmvxW+DxUNNr7f9lFpDHdq0ZbxpQkKvIydX1mvZtxgcc6UbalpFVBDQTUjcNxa/x6SpDa3sPHH3ln8soxFsrHJRkmS67Gq/rEb/KwwtnjkB+U39FDfyH+nnUuHDb+6+ED3rOjRycmP0y+e3Yk6YfPmJNBMNMnjbSQBuHWsR88TWtkATSHH6V9J1OnWEog0VFJXxxXkjPXJj2AkyK+lZ2qBlkWOb/v5MSFFxuDwwaPLH3jT9zet0mkKpMa+tndAWrMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYHMA2pBiTGD5Rki5QijckOlddGJyAvLoLzJ8N4shr0=;
 b=iEsSymtj7iukXy7/CtSpVPWVtD6LIC65t9erWntkkODbWlCk3TBs3Ldv1F9Ugrq8RC526BoZ3aLnv49UwHrLxTXGDgSpjC7qIekTqp4n+FC7rtWiWAbu/3JegBe2xKyk+q5lRo7AJgiLRDmZFd82aD223eAMEUgPnMsEcphglxZgZUrQSUaZ6crj55GfPrbD7ZMs3L+zz8dcY2qRCKjpKDhNog8dI7IsIpTeXZY79jWFjh1JVBBCIvEEQWF5n70P4+X6BDTfsC4ZRoRCZcs+qHJwBSdlDHIdIQ4FJkn68we0IH9kCGBYqbEVa3v3MjYx9pSl8zSLhuEMCpCJwk+BXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYHMA2pBiTGD5Rki5QijckOlddGJyAvLoLzJ8N4shr0=;
 b=iYRCwmUnWd1fQKssnu21xphYMq0lMkRmKAGRngPZY/JqyEKYqhqHKvskdS9dHYgk79XSy8pKt8k4G/QNh3mSr7BMmrFBof8Ydw5pmn2Py1bm39xwU3SwQyNGuL8xAqw5hrg1dJ2esC9WA+O97IxCr1XYQh61qm66UQUQi9nUufY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 DS7PR12MB8249.namprd12.prod.outlook.com (2603:10b6:8:ea::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.19; Mon, 20 Feb 2023 23:53:05 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%7]) with mapi id 15.20.6111.018; Mon, 20 Feb 2023
 23:53:05 +0000
Message-ID: <bea899bd-c7c1-80cd-8804-e6a3167ea9eb@amd.com>
Date:   Mon, 20 Feb 2023 15:53:02 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v3 net-next 00/14] pds_core driver
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, brett.creeley@amd.com
References: <20230217225558.19837-1-shannon.nelson@amd.com>
 <Y/H14ByDBPTA+yqg@unreal>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <Y/H14ByDBPTA+yqg@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0110.namprd03.prod.outlook.com
 (2603:10b6:a03:333::25) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|DS7PR12MB8249:EE_
X-MS-Office365-Filtering-Correlation-Id: 24ef4b7a-c7fa-4eb7-fb0e-08db139d9c24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: boJAHQq67fRBt4KbOS9+6eun8JZ/RosoKyMnFW/40YMfwvP2upmbinhs05f26IGuFW3FUezsOE4Dd6vjYchsdvNpt8VUDtEtS9kb6oEbzDyugkzPDg/Z+NPuDBI65EOINDPbcBlE7GRPVa8/M5ceaNS8KqI7KDemEaEgiV+vzwstZ0i7TAxdm4j7o0hK9qqQregnq3Rr7VkSGzJyYlmq0uiC1XMbEjf7FeOQsvbPYxh1E8U4nu5HSK5/IQ5aeBRs+DB8PBmH2jtx8tFtdcOQ50xIVEV7riGa9QQbl+WiGGhzLhzNiau47njiq/y3LWaIRaFx/DIkOLp/lsHtjukVH/iPXonbmwZk9VODmaARaL7cTfj0QsEAya4T0RrlZDRKGozKL1KP8yV8SA2DfB+MtXXvxBGlpAfHCTWM7TnkYx2Fwdpv4Yqwhmakj8F+3VdGe2LhsZcsqBRe7yYLLYLfgnpDg8TI0CneimusQvEUfjvbN0UC8f2UNfpHdpakUzXs1vjxpf8KFF5Uex7TPxs/Ck8yV8qRRz1/zCIb650ZaHuQMT/2qEwKFfWTIEzDOHEU1in/6MmLQPwtjPldnx60nMTGKD9hQbE5iKlvwY5nMF0mBY6W8YGe0Njsa7Pw5mJ6yoiKmXabvmOT3J06isjjEN24t7nxcFBatQPVrSag4pmwyavUTZU6y6HMARXG75SRKOyGk0z0xXXa7RJ73/veTIGfZbNs70VgOYZ8d0eALpQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199018)(2616005)(8676002)(66556008)(4326008)(83380400001)(6916009)(66476007)(5660300002)(36756003)(8936002)(6506007)(6486002)(66946007)(53546011)(6512007)(186003)(26005)(6666004)(31686004)(478600001)(41300700001)(316002)(38100700002)(44832011)(86362001)(31696002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cVB5VWt2M3ZucUt0MGxSZVNhVDZyeitkWThsd2lSblRMTGk2SW9kK2JQYjVn?=
 =?utf-8?B?eXIrSDQ4ZjJGeFVjU1V4cndqRkhDQlUrakRwMUc3Ujkva0JmQkJyTnZ3SkFa?=
 =?utf-8?B?VHRFbGJJT3ZMM3JqNTQ4UDIrTUNMcWNnZnZmb3dFTXJKd1NvZjBGVUdndS90?=
 =?utf-8?B?QzBuZTR2NWFzTVI5L0JpMjhyUlptdG9ZTEh2NkJQNEE3b21nb2FyUVU3WWV0?=
 =?utf-8?B?Y2UzaFFGMmhrZmJhUHhyWmU0NDRTY1cvV01NZ0Q2b1hlSTZ0MGJOYmxkZS9o?=
 =?utf-8?B?NHRwQ0pxSCtyZEMxUWpYd1lGSElxL2NIS3F1emN2NVlabDNQS0dJK1dxOS81?=
 =?utf-8?B?UnFBWXdDQ3F5ajZhTXB2OCtIYm10Z21XV3BqWW5pcjBEVE5nVEJWV2lTMEp5?=
 =?utf-8?B?cldIMDRNeGZDODhicFRwMUllck5HTkVoYzZIajZHdFV2U2tjRVQ1MHNIT1Fi?=
 =?utf-8?B?RUY1Q0NWNjlJOHRML2l2YXc5dDU0bGtJU3JRQXZRU2FKWU4yTWxGQ0RpZStL?=
 =?utf-8?B?QlNyOVFjV2liRDJrVEs3b0hxczdPejdDU2IvN0ZxM1VSSDhFd2RBaEFYa3pw?=
 =?utf-8?B?TTVXZ2J0NlhDZG44RUhrQjFpK0JncmlTTHRyK1l1d1ptWUZva1U1a1A4S0Uy?=
 =?utf-8?B?bVZ2ZHVubnVXMHdUTm41ek5NdjZERFhoZW1rVGRvWjYzZGpNWnpjbWRoZFlZ?=
 =?utf-8?B?MzcxSS9NMjlaemFvR1VpclZjRXBCbmVHakFyK2k5eStFT3VhOElYSUFtWm5G?=
 =?utf-8?B?dnh2T0FVY21IL1ZXdTJyYlA3Z3QzWUFieW1wOGxrdEI0M3Yvd0hobW1nUFBR?=
 =?utf-8?B?YmxCVGcybjVoTGluVlF3VUFCSEozTy9jSURwc1hFbnZ2L0p5Zkk2MmFhN3RQ?=
 =?utf-8?B?bmZQcWRoQnpkS2xmRGY4WmZTRm11VnFkWWNSWDlWTzV3b3VWRFAvUVVLOGhu?=
 =?utf-8?B?SUVwME1acjFzWVlTd2ZreHVNckdPQ1REalpZYzB4dzRVR3ZUY2NBaUZjSjEr?=
 =?utf-8?B?bFhoUGtRZEYvR05iVEU1b3lhWDZsMzFjTnd2WC9ma1czSWkrQ0FBaVFIU2tz?=
 =?utf-8?B?WnpadzVvTDk3cUFxZG9DM1B0enFHZndFNHZlaWd6VlUzS1VyUXVja2R3aXNy?=
 =?utf-8?B?ZGR6bnBkajNucmRUTE5TM2MvK2lYeVJnZWNneTJLV08raVhSYzI1Y2tBWm1M?=
 =?utf-8?B?amYzbXptZ25SSnBwaVZZV01vK2VheDVrWHZaZDIvQmowQkxHOEhKNzhLaUxU?=
 =?utf-8?B?Q1BjNm12RSt6eWZWRmhENFozTDlvUysxb3kzMmlnRjJDMlJrYzIxNVdHcTNU?=
 =?utf-8?B?ZjhmclhWcHY4Ym1UaVY5bVVlYW1jYjlhV0NSdlNMWjB0elZqcnhwblpDbVZD?=
 =?utf-8?B?WWNCMlVZdXdSNFBRWWdLajhtbFE5RDFQYmJHM2xrMExOV3ZKOEtrZnNuemNB?=
 =?utf-8?B?dWkvRmU5a0ZnNm1hb0tLaGJtNTNQZ0FZU29ldjd3c0pyajlvYWordlRkRkFX?=
 =?utf-8?B?MFVGS0g5NXF6WjlwQ1QzUUZkRlIzNXJyZzExZGp2NmowQXFqRlIwT25ieVZq?=
 =?utf-8?B?YjVEMmcrRTI1WFdxMVo5cEkrWnRlMXZlZVlHOGw3cDNWOWl3ekkzR2J4WU5j?=
 =?utf-8?B?N1c5b2p3QnZEb1pQODA5RWk0eWRPK1MvaVlyeHNPUmYrY3dIM2UySmdDejYz?=
 =?utf-8?B?OFU5ajlQYnQvczB1dW9ibUFKV3RuVmhNdlZaK0JCN0hMRThBaVNmV0VsQmhS?=
 =?utf-8?B?dmxPR3ZOd09Cb0s5aVFOYzBHclYyem5pYnNleTVlMnBpSmZyQzZ4YWNCcXdT?=
 =?utf-8?B?NjlwNGE0VGV2K05EbFNjbG8zeHJoRFlGVHcvZm5xQkJkZ3VuNVdIVDZDeEpQ?=
 =?utf-8?B?QVkrSTNTL2JkTjBMRlVKR0R2UDQvVnVGcS9sTGozd3dHTEx2YURzcFhuUy9h?=
 =?utf-8?B?aFJDeEhCVUhaZVo2RWlrOGdtbHM1K2dWZWdJdllKamFkMkxnQmhpYTArbzB2?=
 =?utf-8?B?ZG5SUGE4SHFzUlNqdHFzK0FaNTlnSjYxWHJVYW13a0dna0NBc004a3AyRkpN?=
 =?utf-8?B?ZlRkVTFNbDhtTzVaQnhERk5NSFNUanZ4cEtFTVpOM1V3Z01TWmtVZm5KcDMv?=
 =?utf-8?Q?lsA3vy5Q6gaBUjoJ+eXuEd6la?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24ef4b7a-c7fa-4eb7-fb0e-08db139d9c24
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 23:53:05.5081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0CZ1ZCMmuu82KVnmIgfdCyXgrF2lXHnEfMLvHL1Lz4/cwKqJcZ4O3RUuWzHAHpAn8Ebt6i5lk42To3rqeO2fmA==
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

On 2/19/23 2:11 AM, Leon Romanovsky wrote:
> On Fri, Feb 17, 2023 at 02:55:44PM -0800, Shannon Nelson wrote:
>> Summary:
>> --------
>> This patchset implements new driver for use with the AMD/Pensando
>> Distributed Services Card (DSC), intended to provide core configuration
>> services through the auxiliary_bus for VFio and vDPA feature specific
>> drivers.
> 
> Hi,
> 
> I didn't look very deeply to this series, but three things caught my
> attention and IMHO they need to be changed/redesinged before someone
> can consider to merge it.
> 
> 1. Use of bus_register_notifier to communicate between auxiliary devices.
> This whole concept makes aux logic in this driver looks horrid. The idea
> of auxiliary bus is separate existing device to sub-devices, while every
> such sub-device is controlled through relevant subsystem. Current
> implementation challenges this assumption by inventing own logic.
> 2. devm_* interfaces. It is bad. Please don't use them in such a complex
> driver.
> 3. Listen to PCI BOUND_DRIVER event can't be correct either.
> 
> Thanks

Hi Leon,

Thanks for your comments.  I’ll respond to 1 and 3 together.

 > 1. Use of bus_register_notifier to communicate between auxiliary devices.
 > 3. Listen to PCI BOUND_DRIVER event can't be correct either

We’re only using the notifier for the core driver to know when to create 
and destroy auxiliary devices, not for communicate between auxiliary 
devices or drivers – I agree, that would be ugly.

We want to create the auxiliary device after a VF PCI device is bound to 
a driver (BUS_NOTIFY_BOUND_DRIVER), and remove that auxiliary device 
just before a VF is unbound from its PCI driver 
(BUS_NOTIFY_UNBIND_DRIVER); bus_notify_register gives us access to these 
messages.  I believe this is not too far off from other examples that 
can be seen in vfio/pci/vfio_pci_core, net/ethernet/ibm/emac, and net/mctp.

Early on we were creating and deleting the auxiliary devices at the same 
time as calling sriov_enable() and sriov_disable() but found that when 
the user was doing unbind/bind operations we could end up with 
in-operative clients and occasional kernel panics because the devices 
and drivers were out-of-sync.  Listening for the bind/unbind events 
allows the pds_core driver to make sure the auxiliary devices serving 
each of the VF drivers are kept in sync with the state of the VF PCI 
drivers.


 > 2. devm_* interfaces

Can you elaborate a bit on why you see using the devm interfaces as bad? 
  I don’t see the code complexity being any different than using the 
non-devm interfaces, and these give the added protection of making sure 
to not leak resources on driver removals, whether clean or on error.  We 
are using these allocations for longer term driver structures, not for 
ephemeral short-term use buffers or fast-path operations, so the 
overhead should remain minimal.  It seems to me this is the advertised 
use as described in the devres notes under Documentation.

Thanks,
sln


