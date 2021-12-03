Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD07467E9D
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 21:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382997AbhLCUKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 15:10:30 -0500
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:53472
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1382982AbhLCUK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 15:10:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWdLt9Du38kEfy+ZifqRZ0BbExQJ0JqFhGZGtflLSZpRvaGEiVj3E6ui81fZtSU5NV8RJOqhD7oHWbPzNZ40QqjSJ3LRqcLz4CTSUZsgIPRk8319c8Tyu5w6p6MJEE9lytkmbym8LeNaJcU0O51Gk52cmzB1pPj+Cd8zsSrZyGDWSOGf/XK24DW6sKSTI1PAWrrYV58L6hbTA8VtzVcjBn7xC0eHJw2s/2xzOOJo2DZOOscAfrB5i2U/rCQeceb9pLC2C+O4R0C8h4NOM7R+gYfcjqtJUXNFn+79bqYl+EDYUC3jabySlcXPhG7Hvpi1iBJ4JE7mhZYTvwDitZWSRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qU7G+ZiaWrsg+p7MM9oMcVNwq3c0SZRE6z6LspM1vKA=;
 b=fhS71m0B1eSNcWNeVIym6bYyLZhYCd07WLuvrBOtFhFnsXoq6res7GochKz9dmCTXTg3M2Fi5EAt/9MxIcDeaIB0KVbtfLilmtq6PDml5v6sklTj2qwqHUaDVs1DRcvicYqRbbFa+UuwPBmDo1yJjNR5WYqHPinj+wPQxsNY7Qy1UZdU1uJl3rQg2I2kLurzDptnveN2yIIq7d/ZMT7otskoD05AXHoxVvwVujTWjGSW8mMVBZg7haBc53UsmYpzNGYopWFjMR7lDfC/fOVukiVE7JXKE2YRHu2VLKVGJilAHYm4u2GZ20+BrqQxTzC3HXLR9E2UBZ4NcEe1+8SWZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qU7G+ZiaWrsg+p7MM9oMcVNwq3c0SZRE6z6LspM1vKA=;
 b=D8lmOURMOLEy5n1O1VpgG7PBLINbz5CbTx9hrG1dABsPmaqaCjF7b0oDXHR6TolLODpB4miIleymZVg/bACcvPDHKvlWPBeXasuGZkOd5X2Piyh6n/TYdhF5kH13+zfDvnzsr16ZN3Q5zbJEbINHQZRQzVYp3cPjlmwAAxYq7M0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.28; Fri, 3 Dec
 2021 20:07:02 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Fri, 3 Dec 2021
 20:07:02 +0000
Subject: Re: [PATCH V3 1/5] Swiotlb: Add Swiotlb bounce buffer remap function
 for HV IVM
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Tianyu Lan <ltykernel@gmail.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, sstabellini@kernel.org,
        boris.ostrovsky@oracle.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, arnd@arndb.de, hch@infradead.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        Tianyu.Lan@microsoft.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, parri.andrea@gmail.com, dave.hansen@intel.com
References: <20211201160257.1003912-1-ltykernel@gmail.com>
 <20211201160257.1003912-2-ltykernel@gmail.com>
 <41bb0a87-9fdb-4c67-a903-9e87d092993a@amd.com>
 <e78ba239-2dad-d48f-671e-f76a943052f1@gmail.com>
 <06faf04c-dc4a-69fd-0be9-04f57f779ffe@amd.com>
Message-ID: <1b7b8e20-a861-ab26-26a1-dad1eb80a461@amd.com>
Date:   Fri, 3 Dec 2021 14:06:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <06faf04c-dc4a-69fd-0be9-04f57f779ffe@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR16CA0051.namprd16.prod.outlook.com
 (2603:10b6:805:ca::28) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN6PR16CA0051.namprd16.prod.outlook.com (2603:10b6:805:ca::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Fri, 3 Dec 2021 20:06:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4dd0dd4e-1914-4c16-3f9c-08d9b698784c
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5070F11FF25976AA7BF5A2A9EC6A9@DM4PR12MB5070.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o1WNw3gw4sfxpai0SCYeyLMCLThQbioDmSsgisuE3MtWeyEiUaoAAxqFmr/0PFnseMEaMaI8MxYD4Vh7wBVYBC8K72RXfAhwHunGXZpjvNF2dVRsfA+aBE9KbYqOvnDF1/UkF5qxik975l/HnWWxdxoxnQ7czlUdmdAGH8DwPb5Acf5CyHhiFSC0Plvx1mMkXA5CChp2++XnS1/ILz1zlEUqE1bsZz0uYvt3KIp63T2VtAbjmlQxNMK7J0FFVlRRWgsEJop205ZwxVjjx9jfQPuyVOF/Onv319UGWcDlk8jxcQnaMsynX7w+OnL+yV8GcJpGHd4QrHRLznSWbKux0BcDU64OF0tSKFCR0dGuhLv6I9VXTYyZwuwfr33owb+so4+o7osKduHkjgdI0vt7dLmXyx4rwYcFPxksnSGvWs+iSjj2Um73H6dl+49+f00NCOWiDcYluudYZ5bDmO/syt4LT2N2lWi1cZPdC1ctzgWTX8/ztpvBxQG0A5k0det4AMuCrOn41yR06f2QWThLvoXiaulYZobBByhb+VWfnAXYT1t3e0/unNchZ6VdS0KPR3H5IuV49cI6Pk+FhNQ64i4xaWhANAss0YNT6rGqLrTHlQLFyV+6GcK96vPmF15fGL7An5X5lfYVAEW7n9TZzmyu12WR+sHCgK7KbVBUrFVsTlWNzpdVV9mSgSllUr8O/Tvwc9S45RvSE8kZD/7pvxhcxQrASK2wDTIN/z9yFarWhHZOJ7XnJWZsJIt0JqI5WhTVtFx07mR1mvVNvg1oeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(4326008)(31696002)(921005)(38100700002)(6512007)(36756003)(86362001)(8676002)(186003)(2616005)(5660300002)(7406005)(7416002)(956004)(31686004)(66556008)(6506007)(53546011)(66476007)(66946007)(8936002)(2906002)(45080400002)(6486002)(26005)(508600001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anNOVERHVG5TTGR0emFJM203UWprTXVTM01zSVdUa00wWnJ4Um9UamEwSjZP?=
 =?utf-8?B?UHdwcWtJR0ZiMFVOTnp4TzhNWGxXNkU4YytSRVE0ZlR6Sml2Z0lBdVFQR1hx?=
 =?utf-8?B?SlRxV3NvdEl4SUttWmFnNGVGTGtnbVBiVTM5NlNWeFc3MnNXdzRCbHYwYXpB?=
 =?utf-8?B?UU1aZC8xNm1jYnJoOUtsa3FIeGJ5ZTNyclhnd01TbVlEQ2ROQU4wb1l2dERR?=
 =?utf-8?B?ZStVTnN5ejJxT2k3aGxVcjY2TXNNOEVjRzZHY3VveXpjZUVxQ0RPVTJrWTB6?=
 =?utf-8?B?TEVxS2pGWk5PK2R1a1VjditxT1NvMzVQazd4SXpUd092cVNIZ1MvaFJXYnNs?=
 =?utf-8?B?MnlVSnprT3VWSG52V0w1Z0w0R0ZOZG9nMmVFaDhnV2czSDljTWsyTkRXZm1z?=
 =?utf-8?B?dUFhSWRxSnhza2E1OTJZbW9OeHJxZ0gyUDhnWkIyZFpwbUR1VGdOdktBQ1RS?=
 =?utf-8?B?NGZiQlRnZ3hsdXdwY3NTeVRValZZd0ZZcjFYZ2RHNng4dUtHaU9saVlWY2NC?=
 =?utf-8?B?SWhUVjNENXJlYlNaWXcvaTVkSytFTGxDNnNnYzBmdUdaVGQxMFBRVmQ5VDY4?=
 =?utf-8?B?RmhDOWI5Q0F4RU5iUDc4bVRVN21UWFpYM2lBUmpQZzhLbmNIRmd4YzJnWk9M?=
 =?utf-8?B?Yk5UVXkzNCthVndJUkdzcWF1Lzh2S3J1MGN6ZFl2bEMwWXgrMkQ3dUd0VnB2?=
 =?utf-8?B?NFM0K2xyZjlkOWZhTWptczVjWDBMdjBBTVphSTVudDFrMDJqUS95MXI5SjBn?=
 =?utf-8?B?MS8vVkEzWVMxZ2FrdzdQSEpKNFRwQ1Q5TktOdG1GRUdkMCtwbUJKRHlUUmVW?=
 =?utf-8?B?MjJkLzlNWm9tRWZBZjVvSEZvZHdyNW9MUWo1VnpNU2llYlBGUk8zTTlHUWti?=
 =?utf-8?B?dUllYlk5WGpqQ0doK3FyYWFTdURMMTMrcUcvNUJqeEVDdGtpeFNVTU44SUdB?=
 =?utf-8?B?eVhONmNjd0wyNm1rR1hnUVNhUmVYZjQ1Uk1aRnF1aG5iZVU3WWUzQ0wzUjd0?=
 =?utf-8?B?ZExES2ZuUFk4ME9GT1lpa2p5OU1oWE50UklxSDBmenVGWW11eUhjcDNoZDdS?=
 =?utf-8?B?RzhCcVB6VENDSWRPeDQzZ2N2NnlKKzFzSTNkaW9sNGp6cEtQdnNjNWU4YnBU?=
 =?utf-8?B?UDhwbUxwNmFQb1pkTm0vaSs4R3pjZ0xyM25ZMXdtYTNsdFArQkJUazVjaGwx?=
 =?utf-8?B?WFNPc3ZEbFJIUzk5UDllZ0wyb0pEYUdHRmdFN2JLMGlwengxcmtMOEc5Z3Ja?=
 =?utf-8?B?K1E1RWtIK2JjTEE2ZEM4bjNvdDU2eU9KM3VHeUZ1U1lDL09BWHZEUFlQUEVm?=
 =?utf-8?B?UldzbmJEOGlrUFBFT2NFUWpFK1k3TFQwb1lhcnVWcWhDL0l5b1FEZ21TM2po?=
 =?utf-8?B?SnlTVk5nL2lPdVBDVm13YW1YZnJJZk5XOERadmJpM3M2YVMrY3NYK0IrdU9D?=
 =?utf-8?B?aTY3cDFMY2hLS1JWdkQ2S05CZzY0ak9XSmVtUDZURnh2Rm50d0VOS0FoYWVQ?=
 =?utf-8?B?MVUzbGg3Q0xnNjZKK0s4d2FCblNIaDhRS0t3YWt4QVZRN1BnMWYyWmEyUVFZ?=
 =?utf-8?B?eHU2cEpoUDRsTElnNkY4Ry9WY3lZc0kzWEJmNnRoMk1aUytxeStubG1DZlI3?=
 =?utf-8?B?VHAxeC9yZWdKZDVNc3Y4ZzV0UTVCUWhPMlgwcjlCclZxUlB2T0hLTVRWTWp6?=
 =?utf-8?B?UkQ3RkVnNnR5UXRIeHBBMktaczJNRjBZZkNrRmVBa3lDMGdqY25sNWg3MEFB?=
 =?utf-8?B?QXNtQ0s0b1FVbG8zSGNJNVJ0THNZUDZYT2xXTnZUY29lZUI0UWxGTHY0K3hS?=
 =?utf-8?B?T0tqUmEwTDBDV3N3RFR2azd1RHpzTks4SFBnOEx3cldPa0hPZTNCZ0NmbnJR?=
 =?utf-8?B?Z09mM0FMb3dkL2dXbE5VZDRGTTRoR3hwL2pWV1BCTmpDRjVWdFlaUmpJOGN1?=
 =?utf-8?B?bW0wSGVIc2JJc1lHYXdDM2pLUTgvdlZEbzh6ZWkwUG9zeW95UHhqSkY3aDk0?=
 =?utf-8?B?dm83ODl0YWYrcjF6SUJTWTJxUnBjMXZySkZmWGJVbXhleWl4dnJCT2ZPSDJN?=
 =?utf-8?B?RklRUjZuVnlxNE5XQjFRUjZmL21BK040dWpwQmIrNXpxY3hBcFZweUdqOW1F?=
 =?utf-8?B?aEltay92RzV4dUNhd2lMZDA2QlVHNG5QRnZVQ3U4dmZaM1JXbWhIL3Z3eEpQ?=
 =?utf-8?Q?iAy2VZ1220VEuoGkCOuhywE=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dd0dd4e-1914-4c16-3f9c-08d9b698784c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 20:07:02.1054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FNFDqGR43QFLZPhB63ocWTL6UWhWK+2BmgzGd4pfDMYVnGmtlXQNiWgVo2GTMo0Lkzq5sI8C7GcF6s1/lkSayg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5070
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/3/21 1:11 PM, Tom Lendacky wrote:
> On 12/3/21 5:20 AM, Tianyu Lan wrote:
>> On 12/2/2021 10:42 PM, Tom Lendacky wrote:
>>> On 12/1/21 10:02 AM, Tianyu Lan wrote:
>>>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>>>
>>>> In Isolation VM with AMD SEV, bounce buffer needs to be accessed via
>>>> extra address space which is above shared_gpa_boundary (E.G 39 bit
>>>> address line) reported by Hyper-V CPUID ISOLATION_CONFIG. The access
>>>> physical address will be original physical address + shared_gpa_boundary.
>>>> The shared_gpa_boundary in the AMD SEV SNP spec is called virtual top of
>>>> memory(vTOM). Memory addresses below vTOM are automatically treated as
>>>> private while memory above vTOM is treated as shared.
>>>>
>>>> Expose swiotlb_unencrypted_base for platforms to set unencrypted
>>>> memory base offset and platform calls swiotlb_update_mem_attributes()
>>>> to remap swiotlb mem to unencrypted address space. memremap() can
>>>> not be called in the early stage and so put remapping code into
>>>> swiotlb_update_mem_attributes(). Store remap address and use it to copy
>>>> data from/to swiotlb bounce buffer.
>>>>
>>>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>>
>>> This patch results in the following stack trace during a bare-metal boot
>>> on my EPYC system with SME active (e.g. mem_encrypt=on):
>>>
>>> [    0.123932] BUG: Bad page state in process swapper  pfn:108001
>>> [    0.123942] page:(____ptrval____) refcount:0 mapcount:-128 
>>> mapping:0000000000000000 index:0x0 pfn:0x108001
>>> [    0.123946] flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
>>> [    0.123952] raw: 0017ffffc0000000 ffff88904f2d5e80 ffff88904f2d5e80 
>>> 0000000000000000
>>> [    0.123954] raw: 0000000000000000 0000000000000000 00000000ffffff7f 
>>> 0000000000000000
>>> [    0.123955] page dumped because: nonzero mapcount
>>> [    0.123957] Modules linked in:
>>> [    0.123961] CPU: 0 PID: 0 Comm: swapper Not tainted 
>>> 5.16.0-rc3-sos-custom #2
>>> [    0.123964] Hardware name: AMD Corporation
>>> [    0.123967] Call Trace:
>>> [    0.123971]  <TASK>
>>> [    0.123975]  dump_stack_lvl+0x48/0x5e
>>> [    0.123985]  bad_page.cold+0x65/0x96
>>> [    0.123990]  __free_pages_ok+0x3a8/0x410
>>> [    0.123996]  memblock_free_all+0x171/0x1dc
>>> [    0.124005]  mem_init+0x1f/0x14b
>>> [    0.124011]  start_kernel+0x3b5/0x6a1
>>> [    0.124016]  secondary_startup_64_no_verify+0xb0/0xbb
>>> [    0.124022]  </TASK>
>>>
>>> I see ~40 of these traces, each for different pfns.
>>>
>>> Thanks,
>>> Tom
>>
>> Hi Tom:
>>        Thanks for your test. Could you help to test the following patch 
>> and check whether it can fix the issue.
> 
> The patch is mangled. Is the only difference where set_memory_decrypted() 
> is called?

I de-mangled the patch. No more stack traces with SME active.

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>>
>>
>> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
>> index 569272871375..f6c3638255d5 100644
>> --- a/include/linux/swiotlb.h
>> +++ b/include/linux/swiotlb.h
>> @@ -73,6 +73,9 @@ extern enum swiotlb_force swiotlb_force;
>>    * @end:       The end address of the swiotlb memory pool. Used to do 
>> a quick
>>    *             range check to see if the memory was in fact allocated 
>> by this
>>    *             API.
>> + * @vaddr:     The vaddr of the swiotlb memory pool. The swiotlb memory 
>> pool
>> + *             may be remapped in the memory encrypted case and store 
>> virtual
>> + *             address for bounce buffer operation.
>>    * @nslabs:    The number of IO TLB blocks (in groups of 64) between 
>> @start and
>>    *             @end. For default swiotlb, this is command line 
>> adjustable via
>>    *             setup_io_tlb_npages.
>> @@ -92,6 +95,7 @@ extern enum swiotlb_force swiotlb_force;
>>   struct io_tlb_mem {
>>          phys_addr_t start;
>>          phys_addr_t end;
>> +       void *vaddr;
>>          unsigned long nslabs;
>>          unsigned long used;
>>          unsigned int index;
>> @@ -186,4 +190,6 @@ static inline bool is_swiotlb_for_alloc(struct 
>> device *dev)
>>   }
>>   #endif /* CONFIG_DMA_RESTRICTED_POOL */
>>
>> +extern phys_addr_t swiotlb_unencrypted_base;
>> +
>>   #endif /* __LINUX_SWIOTLB_H */
>> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
>> index 8e840fbbed7c..34e6ade4f73c 100644
>> --- a/kernel/dma/swiotlb.c
>> +++ b/kernel/dma/swiotlb.c
>> @@ -50,6 +50,7 @@
>>   #include <asm/io.h>
>>   #include <asm/dma.h>
>>
>> +#include <linux/io.h>
>>   #include <linux/init.h>
>>   #include <linux/memblock.h>
>>   #include <linux/iommu-helper.h>
>> @@ -72,6 +73,8 @@ enum swiotlb_force swiotlb_force;
>>
>>   struct io_tlb_mem io_tlb_default_mem;
>>
>> +phys_addr_t swiotlb_unencrypted_base;
>> +
>>   /*
>>    * Max segment that we can provide which (if pages are contingous) will
>>    * not be bounced (unless SWIOTLB_FORCE is set).
>> @@ -155,6 +158,27 @@ static inline unsigned long nr_slots(u64 val)
>>          return DIV_ROUND_UP(val, IO_TLB_SIZE);
>>   }
>>
>> +/*
>> + * Remap swioltb memory in the unencrypted physical address space
>> + * when swiotlb_unencrypted_base is set. (e.g. for Hyper-V AMD SEV-SNP
>> + * Isolation VMs).
>> + */
>> +void *swiotlb_mem_remap(struct io_tlb_mem *mem, unsigned long bytes)
>> +{
>> +       void *vaddr = NULL;
>> +
>> +       if (swiotlb_unencrypted_base) {
>> +               phys_addr_t paddr = mem->start + swiotlb_unencrypted_base;
>> +
>> +               vaddr = memremap(paddr, bytes, MEMREMAP_WB);
>> +               if (!vaddr)
>> +                       pr_err("Failed to map the unencrypted memory 
>> %llx size %lx.\n",
>> +                              paddr, bytes);
>> +       }
>> +
>> +       return vaddr;
>> +}
>> +
>>   /*
>>    * Early SWIOTLB allocation may be too early to allow an architecture to
>>    * perform the desired operations.  This function allows the 
>> architecture to
>> @@ -172,7 +196,12 @@ void __init swiotlb_update_mem_attributes(void)
>>          vaddr = phys_to_virt(mem->start);
>>          bytes = PAGE_ALIGN(mem->nslabs << IO_TLB_SHIFT);
>>          set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);
>> -       memset(vaddr, 0, bytes);
>> +
>> +       mem->vaddr = swiotlb_mem_remap(mem, bytes);
>> +       if (!mem->vaddr)
>> +               mem->vaddr = vaddr;
>> +
>> +       memset(mem->vaddr, 0, bytes);
>>   }
>>
>>   static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, 
>> phys_addr_t start,
>> @@ -196,7 +225,17 @@ static void swiotlb_init_io_tlb_mem(struct 
>> io_tlb_mem *mem, phys_addr_t start,
>>                  mem->slots[i].orig_addr = INVALID_PHYS_ADDR;
>>                  mem->slots[i].alloc_size = 0;
>>          }
>> +
>> +       /*
>> +        * If swiotlb_unencrypted_base is set, the bounce buffer memory 
>> will
>> +        * be remapped and cleared in swiotlb_update_mem_attributes.
>> +        */
>> +       if (swiotlb_unencrypted_base)
>> +               return;
>> +
>>          memset(vaddr, 0, bytes);
>> +       mem->vaddr = vaddr;
>> +       return;
>>   }
>>
>>   int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int 
>> verbose)
>> @@ -371,7 +410,7 @@ static void swiotlb_bounce(struct device *dev, 
>> phys_addr_t tlb_addr, size_t size
>>          phys_addr_t orig_addr = mem->slots[index].orig_addr;
>>          size_t alloc_size = mem->slots[index].alloc_size;
>>          unsigned long pfn = PFN_DOWN(orig_addr);
>> -       unsigned char *vaddr = phys_to_virt(tlb_addr);
>> +       unsigned char *vaddr = mem->vaddr + tlb_addr - mem->start;
>>          unsigned int tlb_offset, orig_addr_offset;
>>
>>          if (orig_addr == INVALID_PHYS_ADDR)
>>
>>
>> Thanks.
>>
