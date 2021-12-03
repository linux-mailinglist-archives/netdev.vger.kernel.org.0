Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95F4467DDB
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 20:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382754AbhLCTOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 14:14:50 -0500
Received: from mail-mw2nam12on2043.outbound.protection.outlook.com ([40.107.244.43]:26793
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1359410AbhLCTOt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 14:14:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBPW+Q9ypdbz/mPEtjQqV8xRsr+rBlc+UuDyn8iElIVZEKm0iL29QPKr1IYVaKDOoePYI3L73wfxT1ViwE2CdOJfAtFY0BCIi1AdKcYo5+GaA6wWxjbv9esQkhnev3hspQSZxe4qOC2V0aOxVPEsv4dCK2Wn37rZ1gTlhBS+VuEsk1rwixf6SF0tP7q7i9lbVI8NloHqDLm1eE4Cq1tTCH6Pijz8e3kg5jbw8lQYiRdNGm+mflkl1u2KhXBxEj+i3IS0h8YPtoyK8RxAIvsUrVJ7DYUzNu1IMp1Q4N+/WhCalDYRQ6TBuCflSqveTasA5QRWIKP4e/KFi7f8qFzlqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sfmy+MHGUEfiCYS0Rl5GVzq7hAgUj6XvKDuFFGuA6Tg=;
 b=XVmTgNFiepKh0BcJr/A2eXWup80JU1zFl3qTh76kKkN73zclF3but2kRmU+LKEVHLmVAZS2ZHPr11Nqarwc3H4js8bGc1CjVSDpQjKsLgFqQzfS92fzV9Vtd0loJxSF26+NIPMhRfYmULBEtdiRmgZ3WBUsr0FQ/5o6HSZ8koNUwrRETGnjWP1QOctN3Hfgn6VZ9YLGNFmbsYCqTIk6CMpW8GGXyXtmDsBtepNQR9IvZRaCjSUBRsNAgtRjTWPD8b4wKbp9uAWRDBbXyVrtHhgEGLRhrWuFN7hovbjEvXwkRRIAAj7Ng33Q8jjDlPIT4HZykQWxZfkw9jirSJDvH0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sfmy+MHGUEfiCYS0Rl5GVzq7hAgUj6XvKDuFFGuA6Tg=;
 b=IDBkJzq8eV3mhPaBRRf2WQ6oS69/Pkfbpp4hU+7/DrQPoHcQtj5M0hAphz/pCKC4r1NRSQJK4wr9axnTg9uosscX2qw+Z8rRF6SuDNrdZU1SewbBIN3TUdnO7DJU/IOGsA/4uQNtIHlsacR36otf9bpSQMapX116d/CMPEa5UQY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM8PR12MB5399.namprd12.prod.outlook.com (2603:10b6:8:34::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.23; Fri, 3 Dec 2021 19:11:22 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Fri, 3 Dec 2021
 19:11:22 +0000
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
 <41bb0a87-9fdb-4c67-a903-9e87d092993a@amd.com>
 <e78ba239-2dad-d48f-671e-f76a943052f1@gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <06faf04c-dc4a-69fd-0be9-04f57f779ffe@amd.com>
Date:   Fri, 3 Dec 2021 13:11:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <e78ba239-2dad-d48f-671e-f76a943052f1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0002.namprd08.prod.outlook.com
 (2603:10b6:803:29::12) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN4PR0801CA0002.namprd08.prod.outlook.com (2603:10b6:803:29::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Fri, 3 Dec 2021 19:11:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92accadf-6adc-4fe8-1ff3-08d9b690b164
X-MS-TrafficTypeDiagnostic: DM8PR12MB5399:
X-Microsoft-Antispam-PRVS: <DM8PR12MB53997ADC847CF6B2F8048AE5EC6A9@DM8PR12MB5399.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FxnKwLtS83nvAhaLzvqADUsfPgwgpLbXVkI3W0oTcJv0WXep7++my1H/dbW32fZPsg7BLO2GJfbotOsdLim8SuPBvAeDGRWk2nE7xJ9hEcM+fSLtEJtVxMTzStQMY/fqXJfZSfHftOm/kXbk4XdMooRXFf/AGVdHekcnK3FLT45g7js9rUQBoW5zJWZPfpS4ermJ3QMh7L9nbQMjaLdpMjfFltGFE27O6ue1XLbLDIvf9qdkM/53ZqdrDTC+SyDzshVHcqFh1SkttAHcblE0bI1irKKmP2xt/Net53FwzZZzb+ex6Lm1T66egw9MZEULbuCu5yC98OfN2bV09OGLARZDo+8AlW5n+CU/NqVAgXgMQUbF9mcS2wPekYhZqDlX17UOYWzuNOKrrlrrpfod6EiW3m5n+acLU/4nUJKpkD/y0fFUvFRHuGv0UO42T7Sww4aKkfym93/d6sLPbhdNTEyI1kz/1czyqGeGnSQNRZRzsua7MB0yfYBCucWsvvpD0CH/yeGY6V85lnWopgPsGY7bH5kpFrRQMpF2fwacCFYnQq1FLnRuNXSGPR8qycLtBE9ElhPyKqrPJM1UmStqLDUulN+g5Krtkf/ACxd599X5v5EH1D/rGABTqVJKWDj6zEaCS/R8MNEFrzEGYUjLrsLWukJ6zvwzoYuMEUeSj+1l/n17IWje5UDakyFy0LU5OFPC9mlpXLYh5ifmAoMfmfNoElUSuEsuMpgMqqQgOCkKeIZQnFu6epOS8x0EDgyHAtIaxEIm3w3BEhqcVLzUfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(6512007)(2616005)(36756003)(31696002)(6506007)(8936002)(26005)(31686004)(7406005)(8676002)(7416002)(38100700002)(66556008)(5660300002)(66476007)(316002)(956004)(86362001)(508600001)(921005)(66946007)(2906002)(186003)(6486002)(45080400002)(4326008)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzdDZjRRbmRZOVVxYWw1K0hPNGRCMzlQSzNBVTdnMHE3SWZLUE9YWUVrdXYx?=
 =?utf-8?B?UEZyQVVLQkNxaHZqL3FsRzhXdTl3NWk1YjFYOGZDbDZWTDN6WE10cnYwMkVR?=
 =?utf-8?B?aFlkMHg0Qkg4VGZtMXNUMmQyWHV3NTRWWjZ3TWdDY3Ywb0FuN1Yraml1clJY?=
 =?utf-8?B?ZjFiU3dGMFUrdUIxUFFZcTNmZFgycXRyK1MwNzBtZ0prdHNtVGJpMDlZZ0Nz?=
 =?utf-8?B?eFBjK2tQTnZvUXdtL0VOV2hwWXJHSkVlMXdNVDA1eHZyaUZZWUdISWViUSt1?=
 =?utf-8?B?ZUZlQlZ1d2FkOW1OdnpKWkVXSmNieXE1TWMxZWtNNkZOMWJnUEpYWktkd1c3?=
 =?utf-8?B?RkxpYVFHQzV3aTBxVkpRK2lEbW1BaTNrWUZUYThRdEhxQTlHcTdtOXNhanoz?=
 =?utf-8?B?ZzN0M2hrQi90UDZ6T2ZYUVdMSVNvcHAxNVdYbU5Mb2Q5c0hPM0RJN3VvTTQz?=
 =?utf-8?B?V0tLQzl0bXB2SWVMNkcwQ1BwcXpYSjJNaEJoeUNyYVpsM3h1VTBnQmZZN0px?=
 =?utf-8?B?bTJwQkNiQmZsNVFjSHpMSXFENzIyLy9iQTJjb0J4alphZzRXUjYxelRPQUdk?=
 =?utf-8?B?VWh4VE5uT3JadFNwYStxUTZKS2tVSk9SbTV3YVZUZWtUa0p1ZkptYk5qcFNF?=
 =?utf-8?B?VjN3d01TNzNwNERrdWtRSUZCV2lNaEIzZDNHZnRIRXJoSXp4UytTMHNpTG1T?=
 =?utf-8?B?K0wzT29KYVBhK2E2ZnFjV2o1S0lmTTMwZDNkUG9Sc1pSblNNWjU1QmFxTDVz?=
 =?utf-8?B?NW5GbGI2UGRIOEQ3NHdLRVNMNm9aQTlPK2Q4SmRWRm9CeGxKeE5qcTJtVVhH?=
 =?utf-8?B?UndXcVZVOFE1ek9FbU94a1piV2J5NnM4YUY3N2JsVjZJQ1JCbFhTMzFVbjFo?=
 =?utf-8?B?MlRBY2tLdG9IZTd0NFBHUGFUMVpTMXNzUUNrSjJmQ1ZYQTA1c2hMN2lDQVZh?=
 =?utf-8?B?NFhnZ1VqV1JGdE1nTy9Gc1FtbVZ0SUpNNXB6U2gvQWxoQXN4UTFCNklUQ2hQ?=
 =?utf-8?B?VWliKzlGRzM4RkxpZUc0SXFkSlpaczdWOHprV1ExMFpKUW13Mm1aQ0tSVlFQ?=
 =?utf-8?B?RXBwVTg1SWFXNmJ5WmlWNFBCQ1YzZzl4WUtzSWl5QzB5OU5abDNETlVGM2FM?=
 =?utf-8?B?endvLy9WR0lUNzAxelJScC83Vll6MDhnRzhVcHZmSXlxRWpyRDhrMG1SSndm?=
 =?utf-8?B?d2tCb3JoR2JoY0Y0Z3VSS1Q4c3VhdDZKTlJQaStocDNJUmRxblhURTA4NmNj?=
 =?utf-8?B?NitzMnlabVdHQW1mekZoRWNzUGdrUEQ1TFNNdmt4TmMyVGptOXlFdHJQK1pi?=
 =?utf-8?B?dHh2NjlmVWFHbWRDVTFSTllNZUorN2kwWDdrak50UlFRY1NEUFBMUktTaTAw?=
 =?utf-8?B?WVhoT1ZxTkhQb1pRMTk0YnBrQWVUSklXdXIwbGE5eWlESDRtMnNqVFUvUlYr?=
 =?utf-8?B?SzJUT2VsUFlBMWI2YnB2dVQ2VzFHRmpnWm1qYnlMNGgwak8xbDRjR1RDanVI?=
 =?utf-8?B?TkJacGxiY09Hak5IVzZpMG8wS0lPZDZVMFJYSG9mVUpXODkyOUQ3MG5kc0ZZ?=
 =?utf-8?B?TkpCaE1xR2pYaEJqUlpRMmxDNEhDNDNaOEtMd2UyUjEyc29URVBZQWZlVFNl?=
 =?utf-8?B?b1R1dW4zQTI2VDZhaUVOd0owNzlaUytKMnFVYnM5UlRBWTlsWUYyNEtGQS9L?=
 =?utf-8?B?RGVBaDAweUxBYnBKeGRHYW8zSzUwUUVhMTd2b1ZoaXM5NWZubk1QY2FZd1pa?=
 =?utf-8?B?dm43KzlJSUlMTkpYdnVrUlpiRlJJcERGeXJxWW90eTFYM01tWXlLSUdadzU4?=
 =?utf-8?B?aHNkdlprZG9IR3RaZE9MekhoM3Z5NHdXWDJ6bU5PRUR5andlaFllZmdpcyto?=
 =?utf-8?B?SGx2cU5YRENaUkllQzJ6NXlJL1hlQkZpZUhrU2lBdm84Um81TGJvQ3VtSzYx?=
 =?utf-8?B?S2tUUmtLdFJIb3VsZkMrVmxXeERiMHA5ZDZ1TGpTMS9iSkJtUUdzU1ZYUWpW?=
 =?utf-8?B?U3p2dk05d25XS3RKTk1PRkNpY1Z0QzY1ZmwvZ0s0M1VPcG9sbWNMSFlsMFZy?=
 =?utf-8?B?TWlvVjk3NHplbW9oY0xzcU9hbXlxeFNXUDJ0bGNnNGl5dmMvdHpoMkRGaTV4?=
 =?utf-8?B?RS8yYTFOZ3IrUXk1Q3BqVW9IUTYrVzRSbGdxMHJSanh4KzNXclphcEtSbnJN?=
 =?utf-8?Q?VgqsU58cgRcU2iV8tTEgFs8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92accadf-6adc-4fe8-1ff3-08d9b690b164
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 19:11:22.0576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z/wjtckrxKQppp3WLCFKpwtEtvRoebkt7iogo0Vxo4Ee8u//UJxSgedThS8vkFUtBS6/kaDwRBtG+Uu4/S5w4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5399
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/3/21 5:20 AM, Tianyu Lan wrote:
> On 12/2/2021 10:42 PM, Tom Lendacky wrote:
>> On 12/1/21 10:02 AM, Tianyu Lan wrote:
>>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>>
>>> In Isolation VM with AMD SEV, bounce buffer needs to be accessed via
>>> extra address space which is above shared_gpa_boundary (E.G 39 bit
>>> address line) reported by Hyper-V CPUID ISOLATION_CONFIG. The access
>>> physical address will be original physical address + shared_gpa_boundary.
>>> The shared_gpa_boundary in the AMD SEV SNP spec is called virtual top of
>>> memory(vTOM). Memory addresses below vTOM are automatically treated as
>>> private while memory above vTOM is treated as shared.
>>>
>>> Expose swiotlb_unencrypted_base for platforms to set unencrypted
>>> memory base offset and platform calls swiotlb_update_mem_attributes()
>>> to remap swiotlb mem to unencrypted address space. memremap() can
>>> not be called in the early stage and so put remapping code into
>>> swiotlb_update_mem_attributes(). Store remap address and use it to copy
>>> data from/to swiotlb bounce buffer.
>>>
>>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>
>> This patch results in the following stack trace during a bare-metal boot
>> on my EPYC system with SME active (e.g. mem_encrypt=on):
>>
>> [    0.123932] BUG: Bad page state in process swapper  pfn:108001
>> [    0.123942] page:(____ptrval____) refcount:0 mapcount:-128 
>> mapping:0000000000000000 index:0x0 pfn:0x108001
>> [    0.123946] flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
>> [    0.123952] raw: 0017ffffc0000000 ffff88904f2d5e80 ffff88904f2d5e80 
>> 0000000000000000
>> [    0.123954] raw: 0000000000000000 0000000000000000 00000000ffffff7f 
>> 0000000000000000
>> [    0.123955] page dumped because: nonzero mapcount
>> [    0.123957] Modules linked in:
>> [    0.123961] CPU: 0 PID: 0 Comm: swapper Not tainted 
>> 5.16.0-rc3-sos-custom #2
>> [    0.123964] Hardware name: AMD Corporation
>> [    0.123967] Call Trace:
>> [    0.123971]  <TASK>
>> [    0.123975]  dump_stack_lvl+0x48/0x5e
>> [    0.123985]  bad_page.cold+0x65/0x96
>> [    0.123990]  __free_pages_ok+0x3a8/0x410
>> [    0.123996]  memblock_free_all+0x171/0x1dc
>> [    0.124005]  mem_init+0x1f/0x14b
>> [    0.124011]  start_kernel+0x3b5/0x6a1
>> [    0.124016]  secondary_startup_64_no_verify+0xb0/0xbb
>> [    0.124022]  </TASK>
>>
>> I see ~40 of these traces, each for different pfns.
>>
>> Thanks,
>> Tom
> 
> Hi Tom:
>        Thanks for your test. Could you help to test the following patch 
> and check whether it can fix the issue.

The patch is mangled. Is the only difference where set_memory_decrypted() 
is called?

Thanks,
Tom

> 
> 
> diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
> index 569272871375..f6c3638255d5 100644
> --- a/include/linux/swiotlb.h
> +++ b/include/linux/swiotlb.h
> @@ -73,6 +73,9 @@ extern enum swiotlb_force swiotlb_force;
>    * @end:       The end address of the swiotlb memory pool. Used to do a 
> quick
>    *             range check to see if the memory was in fact allocated by 
> this
>    *             API.
> + * @vaddr:     The vaddr of the swiotlb memory pool. The swiotlb memory pool
> + *             may be remapped in the memory encrypted case and store 
> virtual
> + *             address for bounce buffer operation.
>    * @nslabs:    The number of IO TLB blocks (in groups of 64) between 
> @start and
>    *             @end. For default swiotlb, this is command line 
> adjustable via
>    *             setup_io_tlb_npages.
> @@ -92,6 +95,7 @@ extern enum swiotlb_force swiotlb_force;
>   struct io_tlb_mem {
>          phys_addr_t start;
>          phys_addr_t end;
> +       void *vaddr;
>          unsigned long nslabs;
>          unsigned long used;
>          unsigned int index;
> @@ -186,4 +190,6 @@ static inline bool is_swiotlb_for_alloc(struct device 
> *dev)
>   }
>   #endif /* CONFIG_DMA_RESTRICTED_POOL */
> 
> +extern phys_addr_t swiotlb_unencrypted_base;
> +
>   #endif /* __LINUX_SWIOTLB_H */
> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
> index 8e840fbbed7c..34e6ade4f73c 100644
> --- a/kernel/dma/swiotlb.c
> +++ b/kernel/dma/swiotlb.c
> @@ -50,6 +50,7 @@
>   #include <asm/io.h>
>   #include <asm/dma.h>
> 
> +#include <linux/io.h>
>   #include <linux/init.h>
>   #include <linux/memblock.h>
>   #include <linux/iommu-helper.h>
> @@ -72,6 +73,8 @@ enum swiotlb_force swiotlb_force;
> 
>   struct io_tlb_mem io_tlb_default_mem;
> 
> +phys_addr_t swiotlb_unencrypted_base;
> +
>   /*
>    * Max segment that we can provide which (if pages are contingous) will
>    * not be bounced (unless SWIOTLB_FORCE is set).
> @@ -155,6 +158,27 @@ static inline unsigned long nr_slots(u64 val)
>          return DIV_ROUND_UP(val, IO_TLB_SIZE);
>   }
> 
> +/*
> + * Remap swioltb memory in the unencrypted physical address space
> + * when swiotlb_unencrypted_base is set. (e.g. for Hyper-V AMD SEV-SNP
> + * Isolation VMs).
> + */
> +void *swiotlb_mem_remap(struct io_tlb_mem *mem, unsigned long bytes)
> +{
> +       void *vaddr = NULL;
> +
> +       if (swiotlb_unencrypted_base) {
> +               phys_addr_t paddr = mem->start + swiotlb_unencrypted_base;
> +
> +               vaddr = memremap(paddr, bytes, MEMREMAP_WB);
> +               if (!vaddr)
> +                       pr_err("Failed to map the unencrypted memory %llx 
> size %lx.\n",
> +                              paddr, bytes);
> +       }
> +
> +       return vaddr;
> +}
> +
>   /*
>    * Early SWIOTLB allocation may be too early to allow an architecture to
>    * perform the desired operations.  This function allows the 
> architecture to
> @@ -172,7 +196,12 @@ void __init swiotlb_update_mem_attributes(void)
>          vaddr = phys_to_virt(mem->start);
>          bytes = PAGE_ALIGN(mem->nslabs << IO_TLB_SHIFT);
>          set_memory_decrypted((unsigned long)vaddr, bytes >> PAGE_SHIFT);
> -       memset(vaddr, 0, bytes);
> +
> +       mem->vaddr = swiotlb_mem_remap(mem, bytes);
> +       if (!mem->vaddr)
> +               mem->vaddr = vaddr;
> +
> +       memset(mem->vaddr, 0, bytes);
>   }
> 
>   static void swiotlb_init_io_tlb_mem(struct io_tlb_mem *mem, phys_addr_t 
> start,
> @@ -196,7 +225,17 @@ static void swiotlb_init_io_tlb_mem(struct io_tlb_mem 
> *mem, phys_addr_t start,
>                  mem->slots[i].orig_addr = INVALID_PHYS_ADDR;
>                  mem->slots[i].alloc_size = 0;
>          }
> +
> +       /*
> +        * If swiotlb_unencrypted_base is set, the bounce buffer memory will
> +        * be remapped and cleared in swiotlb_update_mem_attributes.
> +        */
> +       if (swiotlb_unencrypted_base)
> +               return;
> +
>          memset(vaddr, 0, bytes);
> +       mem->vaddr = vaddr;
> +       return;
>   }
> 
>   int __init swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int 
> verbose)
> @@ -371,7 +410,7 @@ static void swiotlb_bounce(struct device *dev, 
> phys_addr_t tlb_addr, size_t size
>          phys_addr_t orig_addr = mem->slots[index].orig_addr;
>          size_t alloc_size = mem->slots[index].alloc_size;
>          unsigned long pfn = PFN_DOWN(orig_addr);
> -       unsigned char *vaddr = phys_to_virt(tlb_addr);
> +       unsigned char *vaddr = mem->vaddr + tlb_addr - mem->start;
>          unsigned int tlb_offset, orig_addr_offset;
> 
>          if (orig_addr == INVALID_PHYS_ADDR)
> 
> 
> Thanks.
> 
