Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F666D84BE
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 19:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjDERRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 13:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbjDERRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 13:17:13 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2089.outbound.protection.outlook.com [40.107.94.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D424ED0
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 10:17:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bpMh21HVPcHMmrffFEpWtnpdUzdlz94jK40n0qgXUf1jcz8kcdEBwGYkY1jr/FgxEREc7zORN3wHJIl/Inb1vmZbTePGcKUpDMRbXd2VOfDuNSjUqrzAplgoko2HZIEHAZseGVw8bBVTPPg9Elzl0xDO0pc0aoEZTfdarIUH3e0tkKABP3lacW3FOcV8gW/hTijcbdHc5PkdMUhENm6W6Fhndob5IAK7KkoqVff+O19RNkRRM5EjV2RY8Rj1cwKIMsgBQqFkVwjZViGDd4HzcjmU7cQxyozeNAjx9TBsk93BfLC1Du8yTP2O+OCouQ7uRURY8ifBsM+JVzGrTdb/Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OP0+H+0zjj6/0tnZOzQcps+cJ6nYKzS9Tgq0ycPLbVI=;
 b=gwAypfF08iKwKjyZzp4vpIFK3zwmiD0V4dn8aZpCnZ9B3EMn+dFtjA7O7Ok63o+3UNp6mT1opDXsQQZV7XuarzAGIjBsq2zQ5bssjH7IS85l5W4mj36E7C5uA+/ckdxm0iD8S+P/rZTu/WVpBvD6610XKa7lvg0zSUAkIk0dXTUZcZSkhmLiTdaZmD4zkxT473RJB36Uc5xsh91wunjIWUowxHHvSbVGmFyCkZniPzW+TqIQZ0nz/itRiRtQQC9l1+R2Zv4hgkWHSX+JoiYKK/VPGJ2FVb3tQim1vERM0OVYVRDdroTZ0C6l63HsIuRF1Jzay9xRrJr34OQJcw81rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OP0+H+0zjj6/0tnZOzQcps+cJ6nYKzS9Tgq0ycPLbVI=;
 b=b4PxuM54rxkYhFl4wrgD8bXxDypoYMPKUeMpkF7jKWz0R1wzjUXMT85470JrF3kRBbZUwMJj8OLlhtpb3FdNkPcMPHvZeqGD3uEiAkkgs8PsBchuWyTkJQgvn8ml5yDiorWfStvz6WdQs7nldN78RknR6/CGAq6Bo5QyDZNOMdE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 IA0PR12MB7508.namprd12.prod.outlook.com (2603:10b6:208:440::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.35; Wed, 5 Apr 2023 17:17:06 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 17:17:06 +0000
Message-ID: <b80b843b-f405-f0bf-cda0-809d3c26cac2@amd.com>
Date:   Wed, 5 Apr 2023 10:17:03 -0700
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
 <fc39973a-3f57-87d0-ff46-15a09e9b5f58@amd.com> <20230403061808.GA7387@unreal>
 <a44770b2-ff3e-a88e-03c4-e7818b33333d@amd.com> <20230405060747.GN4514@unreal>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <20230405060747.GN4514@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::7) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|IA0PR12MB7508:EE_
X-MS-Office365-Filtering-Correlation-Id: 534b3f81-779a-4585-2ee0-08db35f994ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fJ5J+2T9+rhhj6ZEVqU4mcUcClsxXdNbRAVN346YUYDID76hC6KmQXIYKpmlbNDhti0SIC2jeDvRUr7XEJ792CBA8YUyyatSRxphHI9/pN3N1d50eXKsR+dZKduEl83JlkvAscK5aupEokJSWjNqXX98h/kN9Scoc9rAdVTion3mGRnSHqxJP576CGl+uul4SfsuUjUE6udnZtwICuIdu7YoAujOstEpx0AN2KBZjy5LIpVPWntpy12b9tyCGyKfji8tx8tOoGTMIMmi8Ur5/J6B+/OnTzpqggt2RP0nYpB57wlQ4y4RzgKDpnXNzWyxdEG6R6VZnw4b+kU5zjqsG9aYjBsE0weLt6NYwbvE5XEXhu0/lUkOJKq9gBOVoH2PUCJGiT3jIfXDrSXxEqKn3JnYP/C7KbqupZ9NnE4Ua8hACWaglsGEem6ndBxVp4PJ3DxyrLW7DVXx4Y7fAmoc0IO9FPMHvoLCPX1gDRt4cZai2Glrf8+/xnJjppE5AN+vSqQKJhZYBtMTI/KhHEDjRK4zBmNPeIVo5CMTwn0y0mLSUekzks2TfENzL/0hZV/WTnwRbUja0bOK5D1VFEsdqHzOhNeUTssMXUB+W41JphnS77h9NKx92N3Q+/9bNDfDdT41mBB3dagMdmK5FxiglVaVwHGjksxqD3PKNNOsiPE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(366004)(346002)(136003)(451199021)(6486002)(6506007)(2616005)(53546011)(26005)(6512007)(186003)(83380400001)(8936002)(5660300002)(66476007)(2906002)(44832011)(36756003)(478600001)(41300700001)(8676002)(6916009)(4326008)(66556008)(66946007)(31696002)(86362001)(316002)(6666004)(38100700002)(31686004)(66899021)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cjNSNFlHNm1XTjRoVFNsa1pjVmdJbjh1d0F4VnVtYzRvODh1YXV2UHJWVjFL?=
 =?utf-8?B?aG1UbXZDRmVsdGE2b2dVcFB5VVY5VWFQWUhFNUVaMHR4NzA2czRlRE1xS3Vw?=
 =?utf-8?B?aXRsS1d6Q1Bib216Ymc1UFRNcmp1ekwwaDNrbHBFVGtLSWNObXNhSmxJYjJI?=
 =?utf-8?B?bU1kdzMxbTNKL2JMbWk2RThSVGtCVjZsR2w3VnpyU2ZlRFd5eE5weG1Ld3o0?=
 =?utf-8?B?QUt1TU1DTzRLbVlpT0Y3OUNUdFZtYWVhZzcvNTR0cUo4ZVhzd0tGQ3hHeVVB?=
 =?utf-8?B?c3JVLzRPejhlL29XemJiS0VzTHZZcU9NZmZSTzlUV2hwa0hFQVMzcVI0YVhq?=
 =?utf-8?B?cXA1bFFqSUlQRDFtN01nbWhoRjlVWDl5dVMvbFd6am84TDRvV2hzS1pEaHJ5?=
 =?utf-8?B?ZWJteU1uVUgxbW9uZnpXSVVuSWdabk5jUmNVRG5pVTcwZXVhTjJtVFBuTHVs?=
 =?utf-8?B?ZTA3MFMyelpDM25jcjQ1ei9KV2pjOXYrYWNuMWN1VkZMaEVYNzQ4Vy9YMUFj?=
 =?utf-8?B?bjNwU3pDd0dMRXVDek9DN3RhUXQzNkJpYnF1aFRIRk9xWlZnVjlVd0x4RTNt?=
 =?utf-8?B?aWlqT0IwejZ4NWh5eC9FcHlHWFFsMDlyRDZPR3h1L2UwMGZ0d1NDZk9QTS9E?=
 =?utf-8?B?allsemxzWENEbnNKaHBHOU56d2xyaFRseTE4c0l4MDlGS0RHQ1Z6d2JBamFK?=
 =?utf-8?B?NlI2ckxGMUhBWityOEFTUmFZbS9GcXoySU41ZlhiZllVRDJUZ3NvU1VqaWNn?=
 =?utf-8?B?N2x5d2ZwZE5hWExSR1czYnppSXAvY292ZlUrUHhISTlyNksxT0N4aTQwbUwx?=
 =?utf-8?B?UzNzSlo0RkptWmNJL1pzZGJrRFYwWXFCWkorT252amVOc09tY3kwZzFUT1Q5?=
 =?utf-8?B?VWdZSmRHWmpRZW9KMUxGUmwycVNUK2l0TTRJbTh2Qzk2MjZiQTNrQjJhcjJa?=
 =?utf-8?B?aXFCSUJCQ3JBVmVraDZldlBLdGNNS1JIZXNJMElsdU1iNVkyV1BqYjQwRC82?=
 =?utf-8?B?SXNRaWpLNjNlbk5YZlZHSmtEZ3d1WHRsSXNsalIvRUEvZ1RaSG5odHdtSVVU?=
 =?utf-8?B?T2I1anlBVnhIUWF4d1R0R1RYZWZrSjIzYTJSUzluSFl3ZERMK1JKVGR3MVBr?=
 =?utf-8?B?WEpKSDBVL3lnNFhSRktCRDlmQ1ROM3N6c0VjOExsL0I1WDRsWThCdHFMSm1j?=
 =?utf-8?B?YVRoK3F1NGhMQVVmbVVwU0lsV1lQS1VIL0ppTWhndlh5YzJ3ejVoZTdabUgv?=
 =?utf-8?B?RFo3clBTYnJrUC9JdXI5ZVBDU3EzOEgyRjZIa0NnQnk1RG9jQ1dTMi85SENW?=
 =?utf-8?B?VmNZQ0hWK1BCMCtmelQ2eUFyZUlrTUUwWjl6ejVnbjFKRlpwNnBKa2o3K0Fl?=
 =?utf-8?B?OUNIZWgrSXRmd1g0STNxQkxDaUlkNmpFQ05McGgxSXpZeWU4VWlnMmNjeVhD?=
 =?utf-8?B?NlNKeEMxWnJ4WWU4dXFzb3NWc0hIQWtBbURkRDhHWFhlUC9mNXk4Vk5peVM3?=
 =?utf-8?B?SzBOWFRDeTRiU0ZZdnJhZS9kcVJGR0xiVHFycDR2Y2xMM0tOU25sUGVlUmdC?=
 =?utf-8?B?N3BONnoyYTUvSXpxK0xXNXg5Ri9LMC9oUllhRjg2L3p4TkR0UmJESGVQcFFl?=
 =?utf-8?B?SHJUbUdERXd6NXd5MklLQmtEYXJrSjM2RDFnd0ZvSmtaUXF3YkovZ204R3Na?=
 =?utf-8?B?ZjFMdGZOMEVzTFdGNUpYdGsyWWxZNGdoVGRxWE9aUTVUV2RyUzhremFJNGl3?=
 =?utf-8?B?ZktnU3d5dlBsTWpVZUtscWJoN0ZNbnJzdnZpY1NhQU5QcHQrbmt3c3Q3aVBG?=
 =?utf-8?B?cEhYTmc1T29ZSWM0SW45cVVzSUF4Nm5CV01yUitZbmhwTjUzWEdWSVBCOGhC?=
 =?utf-8?B?ZHdPNHAyeXIxUVFYMzhQb1FTdjVTZVl5Q2IwRjk4WVFyNkcwU2x4YU9BSENZ?=
 =?utf-8?B?dzY3b05KRGtTNGY1M05tRVF0M2ViOHFNZTMzUytZTU82alE0Nld5dm0rYTh0?=
 =?utf-8?B?eVNibDBDQ3pNb25BVjFhb09EejVNdkFvRmtCOFJVSW02RVQycDRsekdPUWpu?=
 =?utf-8?B?NldSbU1TY0tWZGVwTTRTZmx0NmZBSjJoQWw4YW9MUWJ6S00xWitrZCsrTG1l?=
 =?utf-8?Q?wfbTNh1H0HYiITgB7NAJTCbXJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 534b3f81-779a-4585-2ee0-08db35f994ab
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 17:17:06.2582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yv1PV1b5dHiasLFiYCN7R43pHF83bPYbwzJFJGouTrMbQLh2g3zr5Yr4BFLRHcL2xu70srS34piaOnyCzmL8gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7508
X-Spam-Status: No, score=-0.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/4/23 11:07 PM, Leon Romanovsky wrote:
> 
> On Tue, Apr 04, 2023 at 02:44:34PM -0700, Shannon Nelson wrote:
>> On 4/2/23 11:18 PM, Leon Romanovsky wrote:
>>>
>>> On Sat, Apr 01, 2023 at 01:15:03PM -0700, Shannon Nelson wrote:
>>>> On 4/1/23 11:27 AM, Leon Romanovsky wrote:
>>>>>
>>>>> On Thu, Mar 30, 2023 at 04:46:24PM -0700, Shannon Nelson wrote:
>>>>>> An auxiliary_bus device is created for each vDPA type VF at VF probe
>>>>>> and destroyed at VF remove.  The VFs are always removed on PF remove, so
>>>>>> there should be no issues with VFs trying to access missing PF structures.
>>>>>>
>>>>>> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>>>>>> ---
>>>>>>     drivers/net/ethernet/amd/pds_core/Makefile |   1 +
>>>>>>     drivers/net/ethernet/amd/pds_core/auxbus.c | 142 +++++++++++++++++++++
>>>>>>     drivers/net/ethernet/amd/pds_core/core.h   |   6 +
>>>>>>     drivers/net/ethernet/amd/pds_core/main.c   |  36 +++++-
>>>>>>     include/linux/pds/pds_auxbus.h             |  16 +++
>>>>>>     include/linux/pds/pds_common.h             |   1 +
>>>>>>     6 files changed, 200 insertions(+), 2 deletions(-)
>>>>>>     create mode 100644 drivers/net/ethernet/amd/pds_core/auxbus.c
>>>>>>     create mode 100644 include/linux/pds/pds_auxbus.h
>>>>>
>>>>> I feel that this auxbus usage is still not correct.
>>>>>
>>>>> The idea of auxiliary devices is to partition physical device (for
>>>>> example PCI device) to different sub-devices, where every sub-device
>>>>> belongs to different sub-system. It is not intended to create per-VF
>>>>> devices.
>>>>>
>>>>> In your case, you should create XXX vDPA auxiliary devices which are
>>>>> connected in one-to-one scheme to their PCI VF counterpart.
>>>>
>>>> I don't understand - first I read
>>>>       "It is not intended to create per-VF devices"
>>>> and then
>>>>       "you should create XXX vDPA auxiliary devices which are
>>>>       connected in one-to-one scheme to their PCI VF counterpart."
>>>> These seem at first to be directly contradictory statements, so maybe I'm
>>>> missing some nuance.
>>>
>>> It is not, as I'm looking in the code and don't expect to see the code
>>> like this. It gives me a sense that auxdevice is not created properly
>>> as nothing shouldn't be happen from these checks.
>>>
>>> +       if (pf->state) {
>>> +               dev_warn(vf->dev, "%s: PF in a transition state (%lu)\n",
>>> +                        __func__, pf->state);
>>> +               err = -EBUSY;
>>> +       } else if (!pf->vfs) {
>>> +               dev_warn(vf->dev, "%s: PF vfs array not ready\n",
>>> +                        __func__);
>>> +               err = -ENOTTY;
>>> +       } else if (vf->vf_id >= pf->num_vfs) {
>>> +               dev_warn(vf->dev, "%s: vfid %d out of range\n",
>>> +                        __func__, vf->vf_id);
>>> +               err = -ERANGE;
>>> +       } else if (pf->vfs[vf->vf_id].padev) {
>>> +               dev_warn(vf->dev, "%s: vfid %d already running\n",
>>> +                        __func__, vf->vf_id);
>>> +               err = -ENODEV;
>>> +       }
>>>
>>>>
>>>> We have a PF device that has an adminq, VF devices that don't have an
>>>> adminq, and the adminq is needed for some basic setup before the rest of the
>>>> vDPA driver can use the VF.  To access the PF's adminq we set up an
>>>> auxiliary device per feature in each VF - but currently only offer one
>>>> feature (vDPA) and no sub-devices yet.  We're trying to plan for the future.
>>>
>>> It looks like premature effort to me.
>>>
>>>>
>>>> Is it that we only have one feature per VF so far is what is causing the
>>>> discomfort?
>>>
>>> This whole patch is not easy for me.
>>
>> Yes, those are extraneous checks left from testing the new driver
>> organization.  They are no longer needed, and can come out in the next
>> round.
>>
>> In addition to spreading out the pds_core.rst creation across the patchset
>> and adding more to the commit descriptions, I'll see if there are some other
>> nips and tucks I can do to possibly make the patchset more palatable.
> 
> You also need to rework your auxdevice id creation scheme to be more
> like other drivers.
> 
> This line assumes that you have only one PF device in the system.
> +       aux_dev->id = vf->id;
> 

Yes, that really should be an ida_alloc(), thanks.
sln


