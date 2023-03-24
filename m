Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E716C8043
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 15:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjCXOs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 10:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbjCXOsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 10:48:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBF7170C;
        Fri, 24 Mar 2023 07:48:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1C6262B4E;
        Fri, 24 Mar 2023 14:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C33C433A1;
        Fri, 24 Mar 2023 14:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679669304;
        bh=uIDuJfqse5TrCvE+0X2CUu9fuJ7qZ+uiMca4t+ghwyk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NdkKTv/fUNBuums3xr8SjuRRw+Xn4h1rDo6/OUZr0RcNgIUSWjhSrP7NdYUhgaMgJ
         CvjVy4C2T5DTtD7ZeG7ktMhxsHRTRLGH6ENIuSowuc0aTL4DZbSamGRCJxdCDMZsFo
         W+sP2ef0yOQVzAOaDxZCOaQe1rPPfDjIzronhDE76/PbbTEU1PB7fWgr4S4xq5KOb1
         a2BQhs5dqOUGQE8cCsmlSYmwH964Jrmf8U5jtD2qXIoAtG7W+bsbcGucrNRGEiglCw
         4giFx/IQlGBPc2K8cWEulZ6bPgZdSCKSP3N/z2cVMejOlExF2LU67esn/tZIp2UT4F
         ldXnMsEvMYSJA==
Date:   Fri, 24 Mar 2023 15:48:09 +0100
From:   Lorenzo Pieralisi <lpieralisi@kernel.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh@kernel.org, kw@linux.com,
        bhelgaas@google.com, arnd@arndb.de, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
Subject: Re: [PATCH v6 12/13] PCI: hv: Add hypercalls to read/write MMIO space
Message-ID: <ZB24Kdu6WMGYH1L7@lpieralisi>
References: <1678329614-3482-1-git-send-email-mikelley@microsoft.com>
 <1678329614-3482-13-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1678329614-3482-13-git-send-email-mikelley@microsoft.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 06:40:13PM -0800, Michael Kelley wrote:
> To support PCI pass-thru devices in Confidential VMs, Hyper-V
> has added hypercalls to read and write MMIO space. Add the
> appropriate definitions to hyperv-tlfs.h and implement
> functions to make the hypercalls.
> 
> Co-developed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h  |  3 ++
>  drivers/pci/controller/pci-hyperv.c | 64 +++++++++++++++++++++++++++++++++++++
>  include/asm-generic/hyperv-tlfs.h   | 22 +++++++++++++
>  3 files changed, 89 insertions(+)

Nit: I'd squash this in with the patch where the calls are used,
don't think this patch is bisectable as it stands (maybe you
split them for review purposes, apologies if so).

Lorenzo

> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> index 0b73a80..b4fb75b 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -122,6 +122,9 @@
>  /* Recommend using enlightened VMCS */
>  #define HV_X64_ENLIGHTENED_VMCS_RECOMMENDED		BIT(14)
>  
> +/* Use hypercalls for MMIO config space access */
> +#define HV_X64_USE_MMIO_HYPERCALLS			BIT(21)
> +
>  /*
>   * CPU management features identification.
>   * These are HYPERV_CPUID_CPU_MANAGEMENT_FEATURES.EAX bits.
> diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
> index f33370b..d78a419 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -1041,6 +1041,70 @@ static int wslot_to_devfn(u32 wslot)
>  	return PCI_DEVFN(slot_no.bits.dev, slot_no.bits.func);
>  }
>  
> +static void hv_pci_read_mmio(struct device *dev, phys_addr_t gpa, int size, u32 *val)
> +{
> +	struct hv_mmio_read_input *in;
> +	struct hv_mmio_read_output *out;
> +	u64 ret;
> +
> +	/*
> +	 * Must be called with interrupts disabled so it is safe
> +	 * to use the per-cpu input argument page.  Use it for
> +	 * both input and output.
> +	 */
> +	in = *this_cpu_ptr(hyperv_pcpu_input_arg);
> +	out = *this_cpu_ptr(hyperv_pcpu_input_arg) + sizeof(*in);
> +	in->gpa = gpa;
> +	in->size = size;
> +
> +	ret = hv_do_hypercall(HVCALL_MMIO_READ, in, out);
> +	if (hv_result_success(ret)) {
> +		switch (size) {
> +		case 1:
> +			*val = *(u8 *)(out->data);
> +			break;
> +		case 2:
> +			*val = *(u16 *)(out->data);
> +			break;
> +		default:
> +			*val = *(u32 *)(out->data);
> +			break;
> +		}
> +	} else
> +		dev_err(dev, "MMIO read hypercall error %llx addr %llx size %d\n",
> +				ret, gpa, size);
> +}
> +
> +static void hv_pci_write_mmio(struct device *dev, phys_addr_t gpa, int size, u32 val)
> +{
> +	struct hv_mmio_write_input *in;
> +	u64 ret;
> +
> +	/*
> +	 * Must be called with interrupts disabled so it is safe
> +	 * to use the per-cpu input argument memory.
> +	 */
> +	in = *this_cpu_ptr(hyperv_pcpu_input_arg);
> +	in->gpa = gpa;
> +	in->size = size;
> +	switch (size) {
> +	case 1:
> +		*(u8 *)(in->data) = val;
> +		break;
> +	case 2:
> +		*(u16 *)(in->data) = val;
> +		break;
> +	default:
> +		*(u32 *)(in->data) = val;
> +		break;
> +	}
> +
> +	ret = hv_do_hypercall(HVCALL_MMIO_WRITE, in, NULL);
> +	if (!hv_result_success(ret))
> +		dev_err(dev, "MMIO write hypercall error %llx addr %llx size %d\n",
> +				ret, gpa, size);
> +}
> +
>  /*
>   * PCI Configuration Space for these root PCI buses is implemented as a pair
>   * of pages in memory-mapped I/O space.  Writing to the first page chooses
> diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
> index b870983..ea406e9 100644
> --- a/include/asm-generic/hyperv-tlfs.h
> +++ b/include/asm-generic/hyperv-tlfs.h
> @@ -168,6 +168,8 @@ struct ms_hyperv_tsc_page {
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE 0x00af
>  #define HVCALL_FLUSH_GUEST_PHYSICAL_ADDRESS_LIST 0x00b0
>  #define HVCALL_MODIFY_SPARSE_GPA_PAGE_HOST_VISIBILITY 0x00db
> +#define HVCALL_MMIO_READ			0x0106
> +#define HVCALL_MMIO_WRITE			0x0107
>  
>  /* Extended hypercalls */
>  #define HV_EXT_CALL_QUERY_CAPABILITIES		0x8001
> @@ -796,4 +798,24 @@ struct hv_memory_hint {
>  	union hv_gpa_page_range ranges[];
>  } __packed;
>  
> +/* Data structures for HVCALL_MMIO_READ and HVCALL_MMIO_WRITE */
> +#define HV_HYPERCALL_MMIO_MAX_DATA_LENGTH 64
> +
> +struct hv_mmio_read_input {
> +	u64 gpa;
> +	u32 size;
> +	u32 reserved;
> +} __packed;
> +
> +struct hv_mmio_read_output {
> +	u8 data[HV_HYPERCALL_MMIO_MAX_DATA_LENGTH];
> +} __packed;
> +
> +struct hv_mmio_write_input {
> +	u64 gpa;
> +	u32 size;
> +	u32 reserved;
> +	u8 data[HV_HYPERCALL_MMIO_MAX_DATA_LENGTH];
> +} __packed;
> +
>  #endif
> -- 
> 1.8.3.1
> 
