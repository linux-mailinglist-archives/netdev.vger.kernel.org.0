Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4D94D4D3D
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343805AbiCJPGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243371AbiCJPFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:05:52 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6716D19BE5B;
        Thu, 10 Mar 2022 06:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646924164; x=1678460164;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=0TS23dhrQeIBAD23EIlffHbWzGGAv54mP/TJa52IM+E=;
  b=NrpwuanDy3me6fV3ImP44WkG9xzYtqwJrgUW8WRT0TkPgOQq+6DelaVF
   3jT4cWGThsWfK7oQPl4KM6AvJln+gw2Xqea6mgxTBuvu32RwaSdUJ+a7F
   ZN7waDyoqIm3Gr7tumAHr69ykz4fvBmJW/w3TK+uDkuCJaCFRep8+h3GQ
   0x2AVyEYCIeXHzfwSVzz2mOn08lvQ52noG4S+n6v8u78ChNuoe2dpY5x6
   lOCdW9At8gUSUO57aLn4kw8kxHIZ3JLg0vkhXhdoZvf8cVtHMHv8Fcmoj
   C1L+lXzqCb/tWt5OYttYcGjJu1qF3ZJBvAqlchNygy0M3vrQcow1pzL1B
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="237436351"
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="237436351"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 06:55:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,171,1643702400"; 
   d="scan'208";a="644467377"
Received: from aubrey-app.sh.intel.com (HELO [10.239.53.25]) ([10.239.53.25])
  by orsmga004.jf.intel.com with ESMTP; 10 Mar 2022 06:55:33 -0800
Subject: Re: [PATCH v1 4/6] platform/x86: intel_tdx_attest: Add TDX Guest
 attestation interface driver
To:     Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     "H . Peter Anvin" <hpa@zytor.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20220222231735.268919-1-sathyanarayanan.kuppuswamy@linux.intel.com>
 <20220222231735.268919-5-sathyanarayanan.kuppuswamy@linux.intel.com>
From:   Aubrey Li <aubrey.li@linux.intel.com>
Message-ID: <369eb270-92c5-1788-127e-bb31f2a51680@linux.intel.com>
Date:   Thu, 10 Mar 2022 22:55:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220222231735.268919-5-sathyanarayanan.kuppuswamy@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/2/23 上午7:17, Kuppuswamy Sathyanarayanan wrote:
> TDX guest supports encrypted disk as root or secondary drives.
> Decryption keys required to access such drives are usually maintained
> by 3rd party key servers. Attestation is required by 3rd party key
> servers to get the key for an encrypted disk volume, or possibly other
> encrypted services. Attestation is used to prove to the key server that
> the TD guest is running in a valid TD and the kernel and virtual BIOS
> and other environment are secure.
> 
> During the boot process various components before the kernel accumulate
> hashes in the TDX module, which can then combined into a report. This
> would typically include a hash of the bios, bios configuration, boot
> loader, command line, kernel, initrd.  After checking the hashes the
> key server will securely release the keys.
> 
> The actual details of the attestation protocol depend on the particular
> key server configuration, but some parts are common and need to
> communicate with the TDX module.
> 
> This communication is implemented in the attestation driver.
> 
> The supported steps are:
> 
>   1. TD guest generates the TDREPORT that contains version information
>      about the Intel TDX module, measurement of the TD, along with a
>      TD-specified nonce.
>   2. TD guest shares the TDREPORT with TD host via GetQuote hypercall
>      which is used by the host to generate a quote via quoting
>      enclave (QE).
>   3. Quote generation completion notification is sent to TD OS via
>      callback interrupt vector configured by TD using
>      SetupEventNotifyInterrupt hypercall.
>   4. After receiving the generated TDQUOTE, a remote verifier can be
>      used to verify the quote and confirm the trustworthiness of the
>      TD.
> 
> Attestation agent uses IOCTLs implemented by the attestation driver to
> complete the various steps of the attestation process.
> 
> Also note that, explicit access permissions are not enforced in this
> driver because the quote and measurements are not a secret. However
> the access permissions of the device node can be used to set any
> desired access policy. The udev default is usually root access
> only.
> 
> TDX_CMD_GEN_QUOTE IOCTL can be used to create an computation on the
> host, but TDX assumes that the host is able to deal with malicious
> guest flooding it anyways.
> 
> The interaction with the TDX module is like a RPM protocol here. There
> are several operations (get tdreport, get quote) that need to input a
> blob, and then output another blob. It was considered to use a sysfs
> interface for this, but it doesn't fit well into the standard sysfs
> model for configuring values. It would be possible to do read/write on
> files, but it would need multiple file descriptors, which would be
> somewhat messy. ioctls seems to be the best fitting and simplest model
> here. There is one ioctl per operation, that takes the input blob and
> returns the output blob, and as well as auxiliary ioctls to return the
> blob lengths. The ioctls are documented in the header file. 
> 
> [Chenyi Qiang: Proposed struct tdx_gen_quote for passing user buffer]
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> Acked-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> ---
>  drivers/platform/x86/intel/Kconfig            |   1 +
>  drivers/platform/x86/intel/Makefile           |   1 +
>  drivers/platform/x86/intel/tdx/Kconfig        |  13 +
>  drivers/platform/x86/intel/tdx/Makefile       |   3 +
>  .../platform/x86/intel/tdx/intel_tdx_attest.c | 241 ++++++++++++++++++
>  include/uapi/misc/tdx.h                       |  37 +++
>  6 files changed, 296 insertions(+)
>  create mode 100644 drivers/platform/x86/intel/tdx/Kconfig
>  create mode 100644 drivers/platform/x86/intel/tdx/Makefile
>  create mode 100644 drivers/platform/x86/intel/tdx/intel_tdx_attest.c
>  create mode 100644 include/uapi/misc/tdx.h
> 
> diff --git a/drivers/platform/x86/intel/Kconfig b/drivers/platform/x86/intel/Kconfig
> index 8e65086bb6c8..a2ed17d67052 100644
> --- a/drivers/platform/x86/intel/Kconfig
> +++ b/drivers/platform/x86/intel/Kconfig
> @@ -12,6 +12,7 @@ source "drivers/platform/x86/intel/pmt/Kconfig"
>  source "drivers/platform/x86/intel/speed_select_if/Kconfig"
>  source "drivers/platform/x86/intel/telemetry/Kconfig"
>  source "drivers/platform/x86/intel/wmi/Kconfig"
> +source "drivers/platform/x86/intel/tdx/Kconfig"
>  
>  config INTEL_HID_EVENT
>  	tristate "Intel HID Event"
> diff --git a/drivers/platform/x86/intel/Makefile b/drivers/platform/x86/intel/Makefile
> index 35f2066578b2..27a6c6c5a83f 100644
> --- a/drivers/platform/x86/intel/Makefile
> +++ b/drivers/platform/x86/intel/Makefile
> @@ -11,6 +11,7 @@ obj-$(CONFIG_INTEL_SKL_INT3472)		+= int3472/
>  obj-$(CONFIG_INTEL_PMC_CORE)		+= pmc/
>  obj-$(CONFIG_INTEL_PMT_CLASS)		+= pmt/
>  obj-$(CONFIG_INTEL_SPEED_SELECT_INTERFACE) += speed_select_if/
> +obj-$(CONFIG_INTEL_TDX_GUEST)		+= tdx/
>  obj-$(CONFIG_INTEL_TELEMETRY)		+= telemetry/
>  obj-$(CONFIG_INTEL_WMI)			+= wmi/
>  
> diff --git a/drivers/platform/x86/intel/tdx/Kconfig b/drivers/platform/x86/intel/tdx/Kconfig
> new file mode 100644
> index 000000000000..853e3a34c889
> --- /dev/null
> +++ b/drivers/platform/x86/intel/tdx/Kconfig
> @@ -0,0 +1,13 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +#
> +# X86 TDX Platform Specific Drivers
> +#
> +
> +config INTEL_TDX_ATTESTATION
> +	tristate "Intel TDX attestation driver"
> +	depends on INTEL_TDX_GUEST
> +	help
> +	  The TDX attestation driver provides IOCTL interfaces to the user to
> +	  request TDREPORT from the TDX module or request quote from the VMM
> +	  or to get quote buffer size. It is mainly used to get secure disk
> +	  decryption keys from the key server.
> diff --git a/drivers/platform/x86/intel/tdx/Makefile b/drivers/platform/x86/intel/tdx/Makefile
> new file mode 100644
> index 000000000000..124d6b7b20a0
> --- /dev/null
> +++ b/drivers/platform/x86/intel/tdx/Makefile
> @@ -0,0 +1,3 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +
> +obj-$(CONFIG_INTEL_TDX_ATTESTATION)	+= intel_tdx_attest.o
> diff --git a/drivers/platform/x86/intel/tdx/intel_tdx_attest.c b/drivers/platform/x86/intel/tdx/intel_tdx_attest.c
> new file mode 100644
> index 000000000000..1db6c4f22692
> --- /dev/null
> +++ b/drivers/platform/x86/intel/tdx/intel_tdx_attest.c
> @@ -0,0 +1,241 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * intel_tdx_attest.c - TDX guest attestation interface driver.
> + *
> + * Implements user interface to trigger attestation process and
> + * read the TD Quote result.
> + *
> + * Copyright (C) 2021-2022 Intel Corporation
> + *
> + * Author:
> + *     Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> + */
> +
> +#define pr_fmt(fmt) "x86/tdx: attest: " fmt
> +
> +#include <linux/module.h>
> +#include <linux/miscdevice.h>
> +#include <linux/uaccess.h>
> +#include <linux/fs.h>
> +#include <linux/mm.h>
> +#include <linux/slab.h>
> +#include <linux/set_memory.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/jiffies.h>
> +#include <linux/io.h>
> +#include <asm/apic.h>
> +#include <asm/tdx.h>
> +#include <asm/irq_vectors.h>
> +#include <uapi/misc/tdx.h>
> +
> +/* Used in Quote memory allocation */
> +#define QUOTE_SIZE			(2 * PAGE_SIZE)
> +/* Used in Get Quote request memory allocation */
> +#define GET_QUOTE_MAX_SIZE		(4 * PAGE_SIZE)
> +/* Get Quote timeout in msec */
> +#define GET_QUOTE_TIMEOUT		(5000)
> +
> +/* Mutex to synchronize attestation requests */
> +static DEFINE_MUTEX(attestation_lock);
> +/* Completion object to track attestation status */
> +static DECLARE_COMPLETION(attestation_done);
> +/* Buffer used to copy report data in attestation handler */
> +static u8 report_data[TDX_REPORT_DATA_LEN] __aligned(64);
> +/* Data pointer used to get TD Quote data in attestation handler */
> +static void *tdquote_data;
> +/* Data pointer used to get TDREPORT data in attestation handler */
> +static void *tdreport_data;
> +/* DMA handle used to allocate and free tdquote DMA buffer */
> +dma_addr_t tdquote_dma_handle;
> +
> +struct tdx_gen_quote {
> +	void *buf __user;
> +	size_t len;
> +};
> +
> +static void attestation_callback_handler(void)
> +{
> +	complete(&attestation_done);
> +}
> +
> +static long tdx_attest_ioctl(struct file *file, unsigned int cmd,
> +			     unsigned long arg)
> +{
> +	void __user *argp = (void __user *)arg;
> +	struct tdx_gen_quote tdquote_req;
> +	long ret = 0;
> +
> +	mutex_lock(&attestation_lock);
> +
> +	switch (cmd) {
> +	case TDX_CMD_GET_TDREPORT:
> +		if (copy_from_user(report_data, argp, TDX_REPORT_DATA_LEN)) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		/* Generate TDREPORT_STRUCT */
> +		if (tdx_mcall_tdreport(tdreport_data, report_data)) {
> +			ret = -EIO;
> +			break;
> +		}
> +
> +		if (copy_to_user(argp, tdreport_data, TDX_TDREPORT_LEN))
> +			ret = -EFAULT;
> +		break;
> +	case TDX_CMD_GEN_QUOTE:
> +		reinit_completion(&attestation_done);
> +
> +		/* Copy TDREPORT data from user buffer */
> +		if (copy_from_user(&tdquote_req, argp, sizeof(struct tdx_gen_quote))) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		if (tdquote_req.len <= 0 || tdquote_req.len > GET_QUOTE_MAX_SIZE) {
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		if (copy_from_user(tdquote_data, tdquote_req.buf, tdquote_req.len)) {
> +			ret = -EFAULT;
> +			break;
> +		}

There seems to be a mismatch with
https://github.com/intel/qemu-tdx/blob/tdx/target/i386/kvm/tdx.c#L1262

It looks like qemu expects a tdx_get_quote_header before the raw TDREPORT data?

Thanks,
-Aubrey
