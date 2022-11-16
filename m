Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E6462CB0C
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbiKPUfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiKPUfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:35:42 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B30126E3;
        Wed, 16 Nov 2022 12:35:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rusd9CL8UjXgsOrcXGp9noWpnkAPp/9Ywsd6BjqDwj42psxdDqYjFLBmcdj75jKIY6QoCa+KyQP7wJ2O+mK/lphDZMR6PFF9SwUDBSPRDy8DQHX3V/Wt14Wcc8cS4eAJAPbtTpszwW92Dmre+V7DiV857VwRvAqzTF7OzLJFAaVDzeli7s41KFkyhTLFl8ktd46FmWzhPZ1uvIMHBSTsbH53xWr/BOnupeYDWJ9NuLFtuJ27+tsvDlkjVSa269ztGB8NbAUT6eNHV+NxnLwkjY9RyfMI0jAr9a1aKvjynIQ8pk3qRJvqUnTV8HZ872G655yp/ej+QQPfrRlKuQFBWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UTfYZkwwayi1+OL5LpFuhJ11LzX8fvVYc9f4jETPTy8=;
 b=Nz5gpLW8ZxmdexOpmWc8TjF/Chv4eGcdDj/ViCJd1OzP5L1rXfQ87QD0CfkpTJ4zflrzYM8L7YiwuAZeuyshIVgK+9XScwZpBI/kix3keL4qTopzbLQndYLNGiDgJM+KPbj09AS6O67lKPmTy3ZhSfMFodmj7mQZssfmjcXg3cLnWnSDLCX3H0DuiyZ1hTLgt1FAWqrNFyMKyVNygNjnPeY1y4fb24mKOUDdCfr+4Av6tCimgulatI1QCxPkeZ0IEfU30OUdMWrENcvwVKeAEDL24Yp/1QPJEBhmyDrmbKAXL/aR5i83ju3CbEpu3TIYPIO7Fi70NBtFIappGklw1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UTfYZkwwayi1+OL5LpFuhJ11LzX8fvVYc9f4jETPTy8=;
 b=W5uK717GGywcdujRzJ6EOMN0bPSJc63f+6eWFDYxfMqCyOTY2z3hjKCs+j/0Jnu9Kn7L+X3dxhWU+Q3Iy25ZUuc5pd/A8P1eirK9bzDeJRfOWH9rvg/hxtsbnaOGYzyXWBqRrCU4Eqfd+6ajM+fkpU5926+UW0CL78XPxiDgD34=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SA0PR12MB4511.namprd12.prod.outlook.com (2603:10b6:806:95::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 20:35:39 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 20:35:39 +0000
Message-ID: <4d27540e-691e-bd86-0f70-1faff39f7187@amd.com>
Date:   Wed, 16 Nov 2022 14:35:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [Patch v3 05/14] x86/mm: Handle decryption/re-encryption of
 bss_decrypted consistently
Content-Language: en-US
To:     Michael Kelley <mikelley@microsoft.com>, hpa@zytor.com,
        kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lpieralisi@kernel.org, robh@kernel.org,
        kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        brijesh.singh@amd.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
References: <1668624097-14884-1-git-send-email-mikelley@microsoft.com>
 <1668624097-14884-6-git-send-email-mikelley@microsoft.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <1668624097-14884-6-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:610:20::24) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SA0PR12MB4511:EE_
X-MS-Office365-Filtering-Correlation-Id: 7231f684-2441-445a-625e-08dac8121f58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cb932wuHDh8FcsML9wILsrYqIo/hIkL/L6MtHQ8ovoFEhy8aQ0mzL6Y2uomh/E1jqn4pj4iumKB4v6II2hu2uuTVs5hbM9VSUG+weCOGrSGW1iolgUQ//qhZl0dB+SDYRkf0nl089h18u9nGNr8K4Amgo2fK3CEH4Ny5nnNBwyy4Rq+lpDAjv3PXp+n6WFMHLit4xkCZb1wAEU99qmNjvQ9CC9r2KQXTktoy7gA3TpqzBk2ECDQxrm3TNExv3eFB0ABE+NsVvWJ6JgSZoAmxuUcew+XtdCMujRqBrblvh6PAcvuReJ00yq5ED/CASGU01W3g9Y6lwAwLovwYxARZzskKr747r33WRs2KD64vruUHP5Ikf16WMHeeg0dC3FTWJRbaxdgm6X3AqgnaXv4Q7ivdZ7XmXfRCgttxzX3addblrp+PjbAAgbvG/S+I/BjlNK+wJPTEtOvPn1LYczvBI93ojMP7ta4eu8iKROnAOxBfbE257LF5FTMpLt61VQZpo29aOvBjHRaTlAsLJCwxAEY8K3yN+3OM5QM+CfYEkB94Bw67oPSo4yD3wHHCEBYkE6RfotvdgfIPIVlHmqc/kRdqli0sHZXRD3KfPwaTUEe0HpC5mBJHIdEGD78QvWOJZqpUXbEiJlNWKCIgwlmtu67P6hXGduPwsRKnkUeA/8PVzJC6/eGshYLcJcQsg0hTUBeuG2xyiChrHut2wHXkFeySnqpanumoEwW6gaNcOihLWEo9WlB6s/ZpioTWVoFNpU5pj9k+U2IiJtAbh/pvUSBDF0nhABvWvgpm2CYTQ8YEduFq6Xuv8JOT4L6im0gK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(451199015)(6512007)(26005)(66946007)(316002)(8676002)(8936002)(5660300002)(186003)(53546011)(2616005)(66476007)(66556008)(36756003)(41300700001)(6506007)(2906002)(86362001)(31696002)(38100700002)(7406005)(921005)(7416002)(83380400001)(6486002)(6666004)(478600001)(31686004)(45080400002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmtFenEwbkJoYzl5dzZpeXFocEVtTU15a1VHbWJ6QmpCZWVoVW8xcmRyL0Ni?=
 =?utf-8?B?TzFLeHJkdlNwK3NqYjg3eGJRbXBMQXZOZ01tWllpTTVUdmRLRS9DdkEvM2I2?=
 =?utf-8?B?cjF2dGRuZ29TNXZUSlRINksxWXZSOTJZU0JBN1Q0R2dwcWZyV0VIdy9lWFJ5?=
 =?utf-8?B?NGhjVEJ1YzhIaUlwd0tqZ2NORTJ4UWNKMWJTeEU0MDJXdG9TREQxT29EbldZ?=
 =?utf-8?B?aVRWVjhUVHRvK3J4Z1l2QTdxbkJXUXlLZUMrK013N3lFdWs4TlVucVhMcGF5?=
 =?utf-8?B?SXFRaUhFSnRIb215NUJ6bnl6WEVnZjFreXdQN0VNQ2FBcW1nSzFPSHpONDh0?=
 =?utf-8?B?eFgwV2JBNkQ0dlRGVEcrNlRhMGxkd0UwNnQ4dkZudmdWTFhOQm9ZRy9jQUcz?=
 =?utf-8?B?UnpoT0dzaDJpUmJLMUllRTN2OG5sRGQzMUFkbitzSkF3UlNHYlVYRm1uVGNQ?=
 =?utf-8?B?TWs0Z0VVU0lkcy9vb0U1MlloMUxzTGZCVlNVdUhKWkJ0T1RoOFpna01ocFFI?=
 =?utf-8?B?Y2JlWDBURjA1OUU4eVFzaDJCY1g2Y0RONXBiOHV5Ly9ETGprcldndGNtbkNa?=
 =?utf-8?B?V2FjZVFBMkVrVlV4SFdDSUNMZUVOQkRQVXM0VE9rRkNoNTdLNk9xV3o3R3Vu?=
 =?utf-8?B?MXp1NGkvNzFENXdURnYwMExHSzhQaXdnSjBSSkN2K01QUEZXejFXZzF4RExS?=
 =?utf-8?B?Vnh2ZjdQNDV2TFhveTk5L1NsaDBWRm9qTWREOHdqSWliVll4U05mVmNlWS82?=
 =?utf-8?B?WndQVVZJeElkM216NzN6TTBTT0xQK3QrNGI1NUlOUXQ4VDl6cmZVN1lIN0lI?=
 =?utf-8?B?c25nQnBlQlUyL3hlSWYzbUZZZXpzN21ocHlOYjVYRytLclRaZEFxR21rNnhx?=
 =?utf-8?B?MnYvNjVaaWt0UkluUXZxOEFiMGJsUzVUcERBbDlneEQ4bGh4Rk1kVmhaTWw0?=
 =?utf-8?B?b2Y1d2FEZUJPY1FkU1RLY2FRV3FFVXlwekNEWml4bHR5S1dDbk02Z2o1bkN3?=
 =?utf-8?B?SUZsalI3Q0RHSlo1T1QxYmNoYWErWmQxSmFidVM3cE5pUjRheVJqeUF5aVJC?=
 =?utf-8?B?dnBHNTFCemRqejFQR0E1UGR4Qno5b3I3R3pSdkNnTk1McVRMYTY4Um94NjY1?=
 =?utf-8?B?SU5lSmluL2ZrT1o1cytYQ3pSM1pPVEJHVE94RnhFSmN4d0NBcmIrMXZIcEpq?=
 =?utf-8?B?bHdtY2Q2eGFjcUJvY09DbndJa2ZMNjRLa2c2djVMczlRdUVPZGwyQ0NrWjA5?=
 =?utf-8?B?SFhsdS9UZjZuQktKYWlFeWJFVXNxTW9BMDRIa3B0cks3dTVmWS9jb2NMTDB0?=
 =?utf-8?B?clZxci82bExObHZ1SmlHYkNsTVdEQVQ3dS9UdWdTQVA3a1VvR3kvdVBsZ0x4?=
 =?utf-8?B?OHBySk05WCtXM0QwdjgrWGZNSTFWRlZtSmpkS0Zoek1jZ0JxeXRFT0lXQXRo?=
 =?utf-8?B?WWZnS2gyVEE3eUMwR2kyM002ZDFNbXNsanRKTTdEZnJiTlFDczdtVE5XUWxS?=
 =?utf-8?B?bTJ4dWJPTmZVbVpBY3hGbm9UcGRJZm9WbWJuUlBpbHZTTlVwS2sxNzBSYU95?=
 =?utf-8?B?b0ZqcHlvKzhxbSs4K1lacEw4Nk5nS1VIcVRrK3hGNm41TEQ2d3NMc3pidjlv?=
 =?utf-8?B?K1NIS3ZGK0crUSs5Qi92eTV3MTliR29YRW0veWZDOWROejRPR25pU0M0YnpU?=
 =?utf-8?B?Z3hERWI1dkpyVEtXWVhSblRIMllqVEVTWk1WcWQxK2pmN0ZoOHNpNFVvc0E2?=
 =?utf-8?B?SEROYkhMcW5aaVBKbk8vQ2dYNTBKN1VjMlZVY1FyK2p3M3J1Y1c0WEhkMjhS?=
 =?utf-8?B?NW1iVWxVVXovL0tEMjQwWkFkNnhENHh4R1J0V1NzdjFDWnRBa05UUllKTHVm?=
 =?utf-8?B?ZlRPNFNqWlQwN2VsSEJJd1k4MkV6NFpMMk8rOHd3ZXVrUHQ4YUxIQXpoTlE5?=
 =?utf-8?B?STdod3BnRUdmOGsySjRta0JVcWhEYzdPRkJLT0htQUdGK0xhL0x6aFl6R0dD?=
 =?utf-8?B?ejdmTHc5Vm1JTnBXVXJxYWUxbDRicmR5V3pmeEdmZ1F5RGpaTFJDNEMya3JR?=
 =?utf-8?B?MjU4NVNCcUlBUXlxb0ZDVlFXQkt1Y0c3QmZmaFNya1d1SkMzd0JUNG5FNllZ?=
 =?utf-8?Q?z04A+glIuNV7FfP4ZCckbIM3Z?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7231f684-2441-445a-625e-08dac8121f58
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 20:35:38.8917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6CxDAPkhQ5vfXkLzRoNvUwZaAwGShvbFFAkZwjdnX+x67C7glpVBmlpSNWEnf5LpgIhmvNy7PpxnjCgjWqXeQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4511
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/22 12:41, Michael Kelley wrote:
> Current code in sme_postprocess_startup() decrypts the bss_decrypted
> section when sme_me_mask is non-zero.  But code in
> mem_encrypt_free_decrytped_mem() re-encrypts the unused portion based
> on CC_ATTR_MEM_ENCRYPT.  In a Hyper-V guest VM using vTOM, these
> conditions are not equivalent as sme_me_mask is always zero when
> using vTOM.  Consequently, mem_encrypt_free_decrypted_mem() attempts
> to re-encrypt memory that was never decrypted.
> 
> Fix this in mem_encrypt_free_decrypted_mem() by conditioning the
> re-encryption on the same test for non-zero sme_me_mask.  Hyper-V
> guests using vTOM don't need the bss_decrypted section to be
> decrypted, so skipping the decryption/re-encryption doesn't cause
> a problem.
> 
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> ---
>   arch/x86/mm/mem_encrypt_amd.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
> index 9c4d8db..5a51343 100644
> --- a/arch/x86/mm/mem_encrypt_amd.c
> +++ b/arch/x86/mm/mem_encrypt_amd.c
> @@ -513,10 +513,14 @@ void __init mem_encrypt_free_decrypted_mem(void)
>   	npages = (vaddr_end - vaddr) >> PAGE_SHIFT;
>   
>   	/*
> -	 * The unused memory range was mapped decrypted, change the encryption
> -	 * attribute from decrypted to encrypted before freeing it.
> +	 * If the unused memory range was mapped decrypted, change the encryption
> +	 * attribute from decrypted to encrypted before freeing it. Base the
> +	 * re-encryption on the same condition used for the decryption in
> +	 * sme_postprocess_startup(). Higher level abstractions, such as
> +	 * CC_ATTR_MEM_ENCRYPT, aren't necessarily equivalent in a Hyper-V VM
> +	 * using vTOM, where sme_me_mask is always zero.
>   	 */
> -	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT)) {
> +	if (sme_get_me_mask()) {

To be consistent within this file, you should use sme_me_mask directly.

Thanks,
Tom

>   		r = set_memory_encrypted(vaddr, npages);
>   		if (r) {
>   			pr_warn("failed to free unused decrypted pages\n");
