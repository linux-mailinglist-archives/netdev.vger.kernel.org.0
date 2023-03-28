Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691806CB66A
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 07:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjC1Fzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 01:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjC1Fzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 01:55:49 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6656F2120
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 22:55:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KHv0PLGSWMYN6qcON5RLgmCYkbpK5rI1fRfoMVc9QRHyl5chVxSUAkV6jBfROhKMDAiPHADNM1341oOOWZNUoWVSX9I0eI4pT1bWt4Irz4813W1ovzh/uKk1VHIbIE3scKxoz30ntq8Zi12OhmC5GoxDbsfbt48bDoKboM+xED339xcEHKJwLt9ZxjZ8sDoe1DVmfK5csvQhy+jDINhUZE9SEiQ1xS7peeQMb13TcegB5cfXItZk1C0C3RgeI7cKcQ6zBkzIRDKb5FavL5R273MGlThFlGtc+w1mfJsCBdisAA1Id521cttPJuqsak3bnyHCuABCx5hu0INWvOAevA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Z/T5FUPnP6KiCxV7w7V3bMu045Cjj1x/Gbj6OA5jDY=;
 b=UyGcDdOEfoxqJzG/XwxmiJwyLGCWFdCadUm6dirjJJhYKXGBeR47deMPPgBtnf977pxVsqFoiQRpV1Zxwg1wxYTBEQVusJU0HNHAlO3WlJ+JSZvtAwoy7TeXYouDNc73QCJh1KCRJ8IDL2OZb375f59LMdU9DYdHRsJ1viNiuv4OkHSFZjeaUx0Eu4CR3wMcke229fYeX7Obbuu2fSA+1YfjNFf6yCW80H1nxd15af+T2ezRi3TwSFFDoUlIg62WoqMrk/vcHEKDeIZWbHJIi3rVcSMvAzzQvz2yKT6CSEYLMxeSSZPpRXBbI2X1oL4coVefk9C4ydWkGVhsSNPRrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Z/T5FUPnP6KiCxV7w7V3bMu045Cjj1x/Gbj6OA5jDY=;
 b=mxq4MZwERqKRXiD3wBUnPTLaj+DfXBao9BARtJfDDPyNi1/IhTzaFGeIqgatbmJGlyP2G1nizMezjhOjrpIJRxj1waAH8J4FEZjHpmcwonqC4a2KFQRi1c1vAA5YWDqJdu/fuapqpNaQ46WRK41aE5SutvXIY3rs8A5RHZqx2y0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 IA1PR12MB7615.namprd12.prod.outlook.com (2603:10b6:208:428::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Tue, 28 Mar
 2023 05:55:44 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::f6fc:b028:b0da:afab%7]) with mapi id 15.20.6222.029; Tue, 28 Mar 2023
 05:55:44 +0000
Message-ID: <8e87b73a-488b-5070-5043-9f92e9aa9d0e@amd.com>
Date:   Mon, 27 Mar 2023 22:55:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v3 virtio 6/8] pds_vdpa: add support for vdpa and vdpamgmt
 interfaces
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
References: <20230322191038.44037-1-shannon.nelson@amd.com>
 <20230322191038.44037-7-shannon.nelson@amd.com>
 <CACGkMEvacgachSZK8J4zpSXAYaCBkyJrqp8_rYV7-k1O7arC7Q@mail.gmail.com>
 <efa1bda9-6b12-54c1-8d98-7838469cee03@amd.com>
 <CACGkMEvOF7Qb-d61+GG5c5-QnrM2qsRe7Z-6Q+S-vNOdic3Law@mail.gmail.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <CACGkMEvOF7Qb-d61+GG5c5-QnrM2qsRe7Z-6Q+S-vNOdic3Law@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0052.namprd07.prod.outlook.com
 (2603:10b6:a03:60::29) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|IA1PR12MB7615:EE_
X-MS-Office365-Filtering-Correlation-Id: dfe63bb6-ef71-4b0d-7bc1-08db2f5111be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UtmMHs2GP7J8SYNWT6aXIMuIWD7fx2DvueJrBe66ST3w5YoonySBl7KCtQJcXyn+hMzUsCkL/LX2QkkYIE7/ATdtldpJ9Q/n78WJalmHMET4FHQzMcXn7exlsuAMVySqTGaebQdF7auFxMbdR3To8wuf5i7zOlv1mmGSF+PW8dnpQo+pK0WTTHPX8WL4gLF48gAnm3tt4PhBSPpjxI2KxwfMHxkl8QoGloXJ/hNudMoPXzIt+X0zjiYB7Y+YvdBSrMceUihlf9BvcqWCmC288JBYmgfM7yyuKqzlNNDhWD8SkI+8CAWxlxIWK4nnBR7rGBEEm4A1PW/feCf4LXgaz+rLB6HnS1bknz2Ik6i4xNBf1Hezthr2h0jtXWWa9YtkfFj0GdpWzLtP8JiO/Q5+SjUyNe0F5WDkIvADZC+SqbQTXNxdDgKm7YFPJhM5Z0169ZOJeDZN2WNIfvx5PCMHYoyGYfYGyxQzOfY6PLE96c3UQnoV0DFjQySg9rvFm8NPmRLemyIKC8QTpvX8zkUvjMoLGxK0uXKm9kKXL3I6h+u5tWUr8qexVmJdzQMCknClVfagoo4urcX3Ht37HdN3zuJkMEcc6KprD5c7FeSDin6e5UuCrgGX8EVpm9G2YQFV+ErKpdcuQvh9gDZ5Rh/xbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(451199021)(36756003)(31686004)(31696002)(86362001)(6506007)(26005)(53546011)(186003)(2616005)(83380400001)(44832011)(6512007)(8936002)(5660300002)(6666004)(6486002)(41300700001)(966005)(6916009)(66899021)(4326008)(2906002)(38100700002)(66946007)(316002)(66556008)(8676002)(66476007)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWs1VnhiYWExOGF3cjM4OXpHdXhOeG1WajJFUFRta3p1R3NBYmlSM0twRVRU?=
 =?utf-8?B?bEtPMmFUZTZjWEhwYkt1ZnM3Y1VMUG1jZi85cENMU0p5TW9LdGQ1Tzg5c2d0?=
 =?utf-8?B?WXlkZVJKTjZxVVhLbGRLUmZOYzFuckpVTVZBRXZhUDQwV2lla2VDNHV5d2xV?=
 =?utf-8?B?eUU4TElQQVYvSCtIaE9FZmRBS3Z4T1BhOE1JQ0ZuTGpZaS95Vk13TytvZHVy?=
 =?utf-8?B?bHZJZ09SaE8vUEZiR3R3dEs5dzB5UHFVd1p0MXNneTdGT2UvbDM2bERpUFpi?=
 =?utf-8?B?cVNSSFBzUVlheVEwS0pOQzdQSzNpMmdOZkdrZHpYQm02THFXN1BuQVRGR1Nz?=
 =?utf-8?B?MXRGMzVFWUxINHdqVHFzTUw3cmFNa0N0MC9jdGxtMXc2WGRod25QMFpxY1FG?=
 =?utf-8?B?eFlaa05oTS8zSGs1by95c2FEUHR1d0c2UVdrRjNUZFo5anZNM0pMRnJxTXNs?=
 =?utf-8?B?ZlVzb2I3MkE0QUdDZFoxYWxGMnh6WHY1Sm9zNEFkRkhRN3RUbnRnakM2ZFBH?=
 =?utf-8?B?WFF5bklteEl1Ly9yVVR3eWNGWm9ISk5OcGtYbWp1SGpadlBjTlIxZkt2blo4?=
 =?utf-8?B?akFobHVzbWdwNHRuWjR4aWUzSC8rdHg0SVllV2VSZ0NDVnZMQlhWVVJ6ZzZQ?=
 =?utf-8?B?WlFnQ3NzZTBlRDRvWGtUSVNVbFBiWHJmdDB4WUN6bG9VOHRiR3BEdE5tY3E0?=
 =?utf-8?B?MlF5SkRveXI5WGVCU1BSZS9OTWhHbEZDa245K0ErUXQrcmc2bWlvWXlRaHo2?=
 =?utf-8?B?YXR0WU5GWm0xOVZTdloxdk1kZXpGWFJKUEJFaGlTRDY1Zk1vZW1RRnFEWGY5?=
 =?utf-8?B?bmN1V094RVNUZTBDamg4bWFXQ0MwRTJ1bkVuS1Y2NXRYckl2Rmt1RDlDQUNW?=
 =?utf-8?B?aEdNY09wcVZ1MUZ3dDVib0hEUEZhcTBtVUh3K1NWOEhLcm5pYjFmYnN1SmIx?=
 =?utf-8?B?VzRMcWs1TTl1S0RKUUYvZ2QzRGF6R252em9ZQnBmd3c4cCt0Y0luN1hXaDBt?=
 =?utf-8?B?bnJ2Yks1VlVXTm1lYUdydTZ5ckRZU0lXWUNPZC82L0h6TDQreWNSSUwvK211?=
 =?utf-8?B?Zm5NWWxJWklmVkdHWk5BMHNWa0Y0ZUFJY0Z0YWgwalkwTWpPZVdrWFpSdHV1?=
 =?utf-8?B?ZzV2MjJqYStZbmRLSC9QZEJLdVRnWU04RUlsOFpSZ3ZMRHJvajhQRU9wWC9n?=
 =?utf-8?B?ZDhmQjZzcldadzhER2gxUTk2V3BlSTA3bFZnVExkVzM5cjlTclJsRHlhcEN0?=
 =?utf-8?B?ckhCei9KSGs0U3A3YzRPbWdlOHFiUUd1UWNQVDMzTEQ1SHYvMnF1NlUwR1lu?=
 =?utf-8?B?b3h4WEI4RUdVZjNGa2luMWYyb1oxbkJPZ2lwamVhSHZvenovak5FUHpJRlRs?=
 =?utf-8?B?SnZ5UlN4eGRHVnJYZlJ6eUhLZTFIbkY4dnBsRllOSkRTZENZY3Q0VGxjZURR?=
 =?utf-8?B?QVp3Zm5EWFBnTTZYRGJvNkVvcFltYjhadk1Rc3FTN2pSdlprSjB5ZDVEb2JI?=
 =?utf-8?B?TzhUeVAwRnBoMnRUTUFSbGUxaUc3b1owTlpaVGpHSksrNFBiSnNndHFVeUts?=
 =?utf-8?B?ZzNKV2gyWUphVThBNE4ySXFQdS9lZjBLSmRpZHMrUGUrMDdpcGVFZjI0MmlO?=
 =?utf-8?B?WFNHbjUzWmd0amdEM0tRa2lkOVVuTmpCVXBXWU8rcVMwSVFKVnJVRW9FM0p3?=
 =?utf-8?B?elZ2MjUxWG9LSDAwMVliWE5MakNXZjVvUjJyVExZRlZ6T1E3aGkwY3M0eVVr?=
 =?utf-8?B?NHR0eWxiaWtzNEZMbklhS1RxYW81ajd3bDJBNllDMVR5SUxRSGdYNUxXcTBt?=
 =?utf-8?B?R3pISXptWCtmUnM0NlZ5eFBLaVZqL094MU1pUGdpbnJUQTE4YmJXbHlYRmJt?=
 =?utf-8?B?NVptdTZSNDAzQzdYaUFwMEVmWmJ5alI0UUN6ZCtYY1FjRnVYOXpXcW1NZWNK?=
 =?utf-8?B?a1EyajBRZ1JnM0NWMHpubWJWNVdTQXpwSXZ0SjVpOTd3SUI0eE9uSUQ5dDRq?=
 =?utf-8?B?a093R0ZqNDZLL2R1cEdjNmU1WDBiRy8rYXVweXkyTExZVkdHREwrbE9QelBL?=
 =?utf-8?B?OHI1d3E1UFhrQnh6VUVDY2U4VS8yM3FkUC9OOXhDQ3FhWXUybVVybDRPdlMz?=
 =?utf-8?Q?DlvTgViTOA2rbOqKd9aMGmEg4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfe63bb6-ef71-4b0d-7bc1-08db2f5111be
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 05:55:44.1313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SzfxmBAk1iPLlHIFNS5FqkvCzF4FtYE8vGP31rd8ZeZfuJzn98Rwq/7twMdfn4xr0oZHrMorReN/qpYjbvo8eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7615
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/27/23 8:53 PM, Jason Wang wrote:
> On Sat, Mar 25, 2023 at 8:27 AM Shannon Nelson <shannon.nelson@amd.com> wrote:
>>
>> On 3/22/23 10:18 PM, Jason Wang wrote:
>>> On Thu, Mar 23, 2023 at 3:11 AM Shannon Nelson <shannon.nelson@amd.com> wrote:
>>>>
>>>> This is the vDPA device support, where we advertise that we can
>>>> support the virtio queues and deal with the configuration work
>>>> through the pds_core's adminq.
>>>>
>>>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>>>> ---
>>>>    drivers/vdpa/pds/aux_drv.c  |  15 +
>>>>    drivers/vdpa/pds/aux_drv.h  |   1 +
>>>>    drivers/vdpa/pds/debugfs.c  | 260 +++++++++++++++++
>>>>    drivers/vdpa/pds/debugfs.h  |  10 +
>>>>    drivers/vdpa/pds/vdpa_dev.c | 560 +++++++++++++++++++++++++++++++++++-
>>>>    5 files changed, 845 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
>>>> index 8f3ae3326885..e54f0371c60e 100644
>>>> --- a/drivers/vdpa/pds/aux_drv.c
>>>> +++ b/drivers/vdpa/pds/aux_drv.c
>>>
>>> [...]
>>>
>>>> +
>>>> +static struct vdpa_notification_area
>>>> +pds_vdpa_get_vq_notification(struct vdpa_device *vdpa_dev, u16 qid)
>>>> +{
>>>> +       struct pds_vdpa_device *pdsv = vdpa_to_pdsv(vdpa_dev);
>>>> +       struct virtio_pci_modern_device *vd_mdev;
>>>> +       struct vdpa_notification_area area;
>>>> +
>>>> +       area.addr = pdsv->vqs[qid].notify_pa;
>>>> +
>>>> +       vd_mdev = &pdsv->vdpa_aux->vd_mdev;
>>>> +       if (!vd_mdev->notify_offset_multiplier)
>>>> +               area.size = PDS_PAGE_SIZE;
>>>
>>> This hasn't been defined so far? Others look good.
>>
>> Sorry, I don't understand your question.
>> sln
> 
> I mean I don't see the definition of PDS_PAGE_SIZE so far.
> 
> Thanks

Oh, right.  That's because it is defined in 
include/linux/pds/pds_common.h which comes from the pds_core patchset.

https://lore.kernel.org/netdev/20230324190243.27722-2-shannon.nelson@amd.com/

sln

