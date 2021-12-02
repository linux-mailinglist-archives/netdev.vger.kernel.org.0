Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B394946658D
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 15:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358681AbhLBOqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 09:46:15 -0500
Received: from mail-mw2nam12on2074.outbound.protection.outlook.com ([40.107.244.74]:59041
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234655AbhLBOqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 09:46:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rbm5Tla++bGXbxll262BN/XAd22z/RmfqGgGZfvaQTgYRZe26CtVQFuQZA28U1X4fafNPSSW4MvLlBTN2yCBgvLcPzwQe8IpRHrKUMadGdmvzft12zy4FdXF5wEV/QcgM2JvPruIjUK6GQ+xlzGTjmNQAZkLe0GlfxkxK+PjLfs7lTcaNsZtn4NqFqGJMUwEa0m0LuDxue7UwkjJ1aY4LeIH+1ObkGzsvrzueKFTOoeEEeTpcdDHcO3v0JYhPhk709Xq81yafhFFEDDaSib/9qjqddnDniMb7ZocjYZHFqMQY4z28jlpmAiKS4Tzhgw1qGtZ5+3PhLkhkRxduSsrvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3X5kwCUFYFBft7dEmRdcY8+rUQnT155lmn/gv9noPls=;
 b=OCe2SZiwIn+3d/AGOTqHXJQzWinwQIiZ5c1Fv3dKKyxps5ZmW7v4J168Oj/xWe27qT+GAyn+UfrFAuAoQTsBCp7DYBiGNN9zQ1uQ8lrc1FXyw2r1Gf5STYnza9S88yu48Gy5ZvGhGwqeeFbLR3HGLOeh3XxACsQEDV7IgKtgubdToLlT70VDNMx5y/bXo8v79ngTXqDClZtfkaMcnyT7wDHVkfFxmTRIoucE54rHr3EGjpPz1hT0fEBqLsjoJdpMZtDkWd8r/gzTvzCFqqEisjs1KQE9Zc3aT96AcffHRZvA9PkeZXerLZacnE7AY1RL6qoTHHI7PYXWorYGsI27MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3X5kwCUFYFBft7dEmRdcY8+rUQnT155lmn/gv9noPls=;
 b=m6uo3w4KiLfGmj85LYSvUoiVH+8pO2aXJyflfqbwvSmgF3vcAlF1Y3nGG9EiFDHKnsFbylZdmGqq31oI67e3zosNYNU3COqCuSvXYnjd5fmKiZNeKAZAALpbQkyE6i2jkh8AsuYmoIbN3g0gtoDJVSSKLJkGh/Tbxft6Q1pxcdU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM8PR12MB5414.namprd12.prod.outlook.com (2603:10b6:8:3e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.21; Thu, 2 Dec
 2021 14:42:50 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.020; Thu, 2 Dec 2021
 14:42:50 +0000
Subject: Re: [PATCH V3 1/5] Swiotlb: Add Swiotlb bounce buffer remap function
 for HV IVM
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
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <41bb0a87-9fdb-4c67-a903-9e87d092993a@amd.com>
Date:   Thu, 2 Dec 2021 08:42:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211201160257.1003912-2-ltykernel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:208:91::28) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by BL0PR05CA0018.namprd05.prod.outlook.com (2603:10b6:208:91::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.9 via Frontend Transport; Thu, 2 Dec 2021 14:42:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 406c7820-3a6d-471b-64c7-08d9b5a20358
X-MS-TrafficTypeDiagnostic: DM8PR12MB5414:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5414492EA765B93F4A92E1E5EC699@DM8PR12MB5414.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: anJcp1NohdjpXt2U8fABO+x73isA3f0plr5211ilOJZ4nO/ad6E7N+M3BlMWcZtwrxgBtwfT7LFubkMSE3Igvs7eR3jk7LoTmj5N8NWAyd8rOYTnBBof/HJwz7PSRkTDAG5PnmDPH4gvJoHXK3h8X+HGYssaj2U+FQhgGEjD1Q22ZHBb8ieIL3xXyc2hKdPT2I2LVabj/+a/6mppAAiWmOje9WvDNyMbryC2uRyyK7W6BkIS0RyyUntEHQvkzig6aQm+QsJMlKDVbFoGheoE1wwPtvpYKlhrIeiuCY9c9ss2wEBxsduolV8ylRwaWSOFulzraTR50JAmazaTjPP5XkDvwzvG4BqzHyL0Er0AmHcBKOr6vKgl1sThdIQpQJY2fMV63illxJCQ35xRxoDMgwHaTiur0x2+SphUoYNi1s7yOFtNaJdIrlF+7/Dhb/2KW2n/jsdYqujxq0cMX/zk/0OCvopuqjZjq4pJJ7bkPNWsKwNF5xdahcEnz1XTl07LrcIiMzXuRNE1Cd4Hz6TOTbtjQCFSAejP6Y5hMl270qAgczM6sUiszlHfirBohwv9iuCvNjL0JWAHDxUpgfKWTKyQbLS6hdkAREQBO2yFB5cemrNllvyaEEBU88ssfG31Uuffk6OLLgowKoe8cE6vux/kX9JFabh0AfFmB3VQ2NwIPoeZN4HjfwbEDmALB1VetcqMN4EHZaKieir1n7bESbkWMOECpL4wuIsLLHnJOLikuMcCFWdoZGUnquQVxiIo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(83380400001)(956004)(36756003)(8676002)(5660300002)(4326008)(53546011)(6486002)(66946007)(508600001)(86362001)(45080400002)(26005)(31696002)(316002)(7406005)(921005)(66476007)(38100700002)(2616005)(2906002)(16576012)(186003)(66556008)(8936002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFVoOVNXb1VHQnl1VXdTR2VQbW5jVXpNSTY2WkNBMlJ3VWNJcWNXNFRaUTNK?=
 =?utf-8?B?S0hteXVaRDFGd01haExObWZKeEZucmo4UFVZeWMvbHNqQmZCVysyanludXQ2?=
 =?utf-8?B?eFBWa1pyNXQ0QzVFWGlmdGM4blhucld3MW0ydThXSjNVYmVhR1BrZ1ppczVK?=
 =?utf-8?B?R2VyNWxKL1hKSkx5UUtpNHdET29heTdlVmxQQndxRm01ZFQ3RmphQXhVRmhU?=
 =?utf-8?B?MmFqSGd0b0FIT0hlNG15TWVzSTFZTlpaZHJjelpPYXNHM0JpRm1oZGZTcEs3?=
 =?utf-8?B?NWlQSXNONGFUbkRYVTRqd2JXTXZGL3FUeDFVWUNzMisrVzgzenlRNm9sR0dh?=
 =?utf-8?B?ODV5dk5OekFDOUl6ZENGcnRPeWlORE92TjhCS09sbWgvdVNVRENmQ2JPYmJs?=
 =?utf-8?B?Q21oaWw2RENmaXZHVzh4d0xMTGV6MURNY3JwZ1I3NXY1T09yN1NXOXlxMm1V?=
 =?utf-8?B?SHI4N3BvYUhwUk9FTS9pS2VwWjQ5d3pzVlVsZlkyM0FwcVdVQ0lNTUJFazly?=
 =?utf-8?B?MUE2MnRHS21YeEVycnNJb0lFVVMxWnUyNVh3ODFuZFpIb1prZ0RFaVlZR3RC?=
 =?utf-8?B?RDJRSUpYMm0vT3lhSS9aeHBTOEJZOVkxOUdHcE5ZMFAxazlhZFNuZXh3bjZt?=
 =?utf-8?B?WVNaeTFTdlpkSVJjWmZQUUo0dU90eUUwbVZBT0V5Z0tXaXRET0dMRlZZL2x5?=
 =?utf-8?B?cU5uc1Q2SWMzZ2MvNUdKTXJINjVLTjA2ckdlNDdkNWNHQVIzOVZKdTVGOUZP?=
 =?utf-8?B?V0lPMDdNL2MzWklPWmdIQkFiU0ltblkxaE1yOUNWU09MY3Z2K2s4bVA4NUw3?=
 =?utf-8?B?MmVpRmdiQ3l3SnRuRXo1bUp4dEx0TGlUUkJXWjEzVlJsWkFaL3p4cmtBL1o2?=
 =?utf-8?B?bjlBVVB3bEJyNUJBcnVQRU13QUJIc2kxTU94NWF3U04zcm9KOWEvTnFLWS9w?=
 =?utf-8?B?VkhSWS9TQ3E4QXdjVVNlaXpxbGQ1bCt4SGNRNXhvbm1PcHJ2L3h5YkNoM0py?=
 =?utf-8?B?MFdEYXExS3hmZ2VZQVRhVU9PYlFVVzBWNnc1MWlNVDB4cXl0amRkVSs2dGFZ?=
 =?utf-8?B?blVJSDVSTS9WNDdZQnYvMjRYcGpsYytqSXVJSXBpc3JPaHBpTnlVR2JSaEVp?=
 =?utf-8?B?YXlwVzZzS1QrVkluamZDY2w1TnJYME5IK1JQT1YybkN3cTNQZWFDSWZ0MGVh?=
 =?utf-8?B?aDREeE1yMlg4UzNDZlBwdVdlbmNNTCt1MHFSZ2ZqMmhLTUUvdktYSVBoR1dW?=
 =?utf-8?B?cVRaVHhTa29pWnRrTGpxY3A5d2NTNWcvWXFxM2pUMXZkejJRbVZDVWRJRUdw?=
 =?utf-8?B?UlR0bXIweWFZTEpNbDVpbEJoUGtZSkZDWnN5REpzMzFORDZLc0ZwOHJlT2tz?=
 =?utf-8?B?bEdFdmpGbnRaY21EQ0lZZW9JQkx0MTBYNkNuVDlwOVpRdWJyemNDTm9wM3Zn?=
 =?utf-8?B?ZDBhNmN4OVhOVzZRc1M4dGZvWUZ2UENBZ3B4NGdnWmx1T0k5Ty9YcERHZlBj?=
 =?utf-8?B?ZEF2bWxML01CRkVCNFFuUVIvNzFIT29jNE44MzhhdEFBRWlvMWw2cWMrMmFG?=
 =?utf-8?B?RnBuZnhNK3Y1anJhU0dWOTF0ZFlkcFk5cWo4eGh5aVlVTU9TRzNUWmwxeE0r?=
 =?utf-8?B?VEdEUTlLT0NORlVkcmRnKytJOFlYQW9INUREenZXT01Oa0pBVHp6SncwaHJi?=
 =?utf-8?B?Mkw3NTdSQzYyWmJWNFBYWHpCYXNnUXBnWGRtWERFQTY2b2VYWmFYamxlbmU2?=
 =?utf-8?B?R2RXaHJYT00veXBpOHVGaVFrWWJKelRxZHgyVXNtdWE5QlE4M2ZCd0xKV090?=
 =?utf-8?B?NG5naTV0UEdXam9PR2hUUVpVOXZKZy9oQkZobWVCbWlUN09wOU1tUWYzamd0?=
 =?utf-8?B?dXczUzE1L2dhaC9qOVYreFdBZlRPN3JTVTJ5VUxpNFhYTHBPNmM5OUQ1dWVl?=
 =?utf-8?B?bFFRbDYrL3VaN2VOODNwTjMvZ3orU0E5WkU0M0JFbWRTUHYrRFFwY09iUFZz?=
 =?utf-8?B?eW9pbHkxWjE2UWJKU3lhTmVHWnY4Uy8wZmx1aURtbW04TW12MDFiY0J2NFdW?=
 =?utf-8?B?dUwvQVdJakdQSC9nT2xrVkhITHdjcHNjME96VlEwYkZBbGVsSDRNdGhaNGxr?=
 =?utf-8?B?eHFRdzR0Smx4TktwT05CczcvM213QnJXWHJwMDBsTmZpL2RqNUIxeVhrdVcv?=
 =?utf-8?Q?QrTbpkvt1Cy8jg+uAEVBT9c=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 406c7820-3a6d-471b-64c7-08d9b5a20358
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 14:42:49.8395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ddpU5OU8lbhY56Jgh/i3+IHYuvJ5Q5N5FNrH4xEfKnLY4LkrpYTCig0kYJWel2Gdvp2EV2NZUmHf1yOw2w7hhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5414
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 10:02 AM, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> In Isolation VM with AMD SEV, bounce buffer needs to be accessed via
> extra address space which is above shared_gpa_boundary (E.G 39 bit
> address line) reported by Hyper-V CPUID ISOLATION_CONFIG. The access
> physical address will be original physical address + shared_gpa_boundary.
> The shared_gpa_boundary in the AMD SEV SNP spec is called virtual top of
> memory(vTOM). Memory addresses below vTOM are automatically treated as
> private while memory above vTOM is treated as shared.
> 
> Expose swiotlb_unencrypted_base for platforms to set unencrypted
> memory base offset and platform calls swiotlb_update_mem_attributes()
> to remap swiotlb mem to unencrypted address space. memremap() can
> not be called in the early stage and so put remapping code into
> swiotlb_update_mem_attributes(). Store remap address and use it to copy
> data from/to swiotlb bounce buffer.
> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>

This patch results in the following stack trace during a bare-metal boot
on my EPYC system with SME active (e.g. mem_encrypt=on):

[    0.123932] BUG: Bad page state in process swapper  pfn:108001
[    0.123942] page:(____ptrval____) refcount:0 mapcount:-128 mapping:0000000000000000 index:0x0 pfn:0x108001
[    0.123946] flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
[    0.123952] raw: 0017ffffc0000000 ffff88904f2d5e80 ffff88904f2d5e80 0000000000000000
[    0.123954] raw: 0000000000000000 0000000000000000 00000000ffffff7f 0000000000000000
[    0.123955] page dumped because: nonzero mapcount
[    0.123957] Modules linked in:
[    0.123961] CPU: 0 PID: 0 Comm: swapper Not tainted 5.16.0-rc3-sos-custom #2
[    0.123964] Hardware name: AMD Corporation
[    0.123967] Call Trace:
[    0.123971]  <TASK>
[    0.123975]  dump_stack_lvl+0x48/0x5e
[    0.123985]  bad_page.cold+0x65/0x96
[    0.123990]  __free_pages_ok+0x3a8/0x410
[    0.123996]  memblock_free_all+0x171/0x1dc
[    0.124005]  mem_init+0x1f/0x14b
[    0.124011]  start_kernel+0x3b5/0x6a1
[    0.124016]  secondary_startup_64_no_verify+0xb0/0xbb
[    0.124022]  </TASK>

I see ~40 of these traces, each for different pfns.

Thanks,
Tom

> ---
> Change since v2:
> 	* Leave mem->vaddr with phys_to_virt(mem->start) when fail
> 	  to remap swiotlb memory.
> 
> Change since v1:
> 	* Rework comment in the swiotlb_init_io_tlb_mem()
> 	* Make swiotlb_init_io_tlb_mem() back to return void.
> ---
>   include/linux/swiotlb.h |  6 ++++++
>   kernel/dma/swiotlb.c    | 47 ++++++++++++++++++++++++++++++++++++-----
>   2 files changed, 48 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> index 569272871375..f6c3638255d5 100644
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -73,6 +73,9 @@ extern enum swiotlb_force swiotlb_force;
>    * @end:	The end address of the swiotlb memory pool. Used to do a quick
>    *		range check to see if the memory was in fact allocated by this
>    *		API.
> + * @vaddr:	The vaddr of the swiotlb memory pool. The swiotlb memory pool
> + *		may be remapped in the memory encrypted case and store virtual
> + *		address for bounce buffer operation.
>    * @nslabs:	The number of IO TLB blocks (in groups of 64) between @start and
>    *		@end. For default swiotlb, this is command line adjustable via
>    *		setup_io_tlb_npages.
> @@ -92,6 +95,7 @@ extern enum swiotlb_force swiotlb_force;
>   struct io_tlb_mem {
>   	phys_addr_t start;
>   	phys_addr_t end;
> +	void *vaddr;
>   	unsigned long nslabs;
>   	unsigned long used;
>   	unsigned int index;
> @@ -186,4 +190,6 @@ static inline bool is_swiotlb_for_alloc(struct device *dev)
>   }
>   #endif /* CONFIG_DMA_RESTRICTED_POOL */
>   
> +extern phys_addr_t swiotlb_unencrypted_base;
> +
>   #endif /* __LINUX_SWIOTLB_H */
> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
> index 8e840fbbed7c..adb9d06af5c8 100644
> --- a/kernel/dma/swiotlb.c
> +++ b/kernel/dma/swiotlb.c
> @@ -50,6 +50,7 @@
>   #include <asm/io.h>
>   #include <asm/dma.h>
>   
> +#include <linux/io.h>
>   #include <linux/init.h>
>   #include <linux/memblock.h>
>   #include <linux/iommu-helper.h>
> @@ -72,6 +73,8 @@ enum swiotlb_force swiotlb_force;
>   
>   struct io_tlb_mem io_tlb_default_mem;
>   
> +phys_addr_t swiotlb_unencrypted_base;
> +
>   /*
>    * Max segment that we can provide which (if pages are contingous) will
>    * not be bounced (unless SWIOTLB_FORCE is set).
> @@ -155,6 +158,27 @@ static inline unsigned long nr_slots(u64 val)
>   	return DIV_ROUND_UP(val, IO_TLB_SIZE);
>   }
>   
> +/*
> + * Remap swioltb memory in the unencrypted physical address space
> + * when swiotlb_unencrypted_base is set. (e.g. for Hyper-V AMD SEV-SNP
> + * Isolation VMs).
> + */
> +void *swiotlb_mem_remap(struct io_tlb_mem *mem, unsigned long bytes)
> +{
> +	void *vaddr = NULL;
> +
> +	if (swiotlb_unencrypted_base) {
> +		phys_addr_t paddr = mem->start + swiotlb_unencrypted_base;
> +
> +		vaddr = memremap(paddr, bytes, MEMREMAP_WB);
> +		if (!vaddr)
> +			pr_err("Failed to map the unencrypted memory %llx size %lx.\n",
> +			       paddr, bytes);
> +	}
> +
> +	return vaddr;
> +}
> +
>   /*
>    * Early SWIOTLB allocation may be too early to allow an architecture to
>    * perform the desired operations.  This function allows the architecture to
> @@ -172,7 +196,12 @@ void __init swiotlb_update_mem_attributes(void)
>   	vaddr = phys_to_virt(mem->start);
>   	bytes = PAGE_ALIGN(mem->nslabs << IO_TLB_SHIFT);
>   	set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);
> -	memset(vaddr, 0, bytes);
> +
> +	mem->vaddr = swiotlb_mem_remap(mem, bytes);
> +	if (!mem->vaddr)
> +		mem->vaddr = vaddr;
> +
> +	memset(mem->vaddr, 0, bytes);
>   }
>   
>   static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
> @@ -196,7 +225,18 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t start,
>   		mem->slots[i].orig_addr = INVALID_PHYS_ADDR;
>   		mem->slots[i].alloc_size = 0;
>   	}
> +
> +	/*
> +	 * If swiotlb_unencrypted_base is set, the bounce buffer memory will
> +	 * be remapped and cleared in swiotlb_update_mem_attributes.
> +	 */
> +	if (swiotlb_unencrypted_base)
> +		return;
> +
> +	set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);
>   	memset(vaddr, 0, bytes);
> +	mem->vaddr = vaddr;
> +	return;
>   }
>   
>   int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose)
> @@ -318,7 +358,6 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
>   	if (!mem->slots)
>   		return -ENOMEM;
>   
> -	set_memory_decrypted((unsigned long)tlb, bytes >> PAGE_SHIFT);
>   	swiotlb_init_io_tlb_mem(mem, virt_to_phys(tlb), nslabs, true);
>   
>   	swiotlb_print_info();
> @@ -371,7 +410,7 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
>   	phys_addr_t orig_addr = mem->slots[index].orig_addr;
>   	size_t alloc_size = mem->slots[index].alloc_size;
>   	unsigned long pfn = PFN_DOWN(orig_addr);
> -	unsigned char *vaddr = phys_to_virt(tlb_addr);
> +	unsigned char *vaddr = mem->vaddr + tlb_addr - mem->start;
>   	unsigned int tlb_offset, orig_addr_offset;
>   
>   	if (orig_addr == INVALID_PHYS_ADDR)
> @@ -806,8 +845,6 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
>   			return -ENOMEM;
>   		}
>   
> -		set_memory_decrypted((unsigned long)phys_to_virt(rmem->base),
> -				     rmem->size >> PAGE_SHIFT);
>   		swiotlb_init_io_tlb_mem(mem, rmem->base, nslabs, false);
>   		mem->force_bounce = true;
>   		mem->for_alloc = true;
> 
