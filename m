Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D17B3C1B6C
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 00:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhGHWYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 18:24:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhGHWYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 18:24:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F700617ED;
        Thu,  8 Jul 2021 22:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625782885;
        bh=897f09UMwt0h/lwDJeDuOlz+iPLrpipRWFy/FQG4FkA=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=DpMVkpRy0/Q2BUH1Pg1OENWOvi+Q55403P1H3Ck+a+vSfgJg1a882wet1gD1EHVIW
         2wWaxJpmw6O6VEW4/P7x/oY23JVPDVo5XgqKB77RtPj52gMzQIY7TJ6/dyiRCX1w4L
         j9ZY+qPy+mB93pMeCh3tE3z97WRPIKATgTIYi/Egl+Z2pJXPjdB4spBdm6tNmCz+lQ
         SB6CvHnNpGNL0rmuNpE2Di2axbHDeZ1yaFJRcfQUj95R9jsNUEPJBvMfBZWcoBTejF
         jVOjY0xqJ7ucd6qAB04JTXdvirrEzxDU4ffkRwLiAhBeqkcTcu+1r+rT2wJYn1AZaO
         CHhRR3hGLvtfg==
Subject: Re: [PATCH v2 5/6] platform/x86: intel_tdx_attest: Add TDX Guest
 attestation interface driver
To:     Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Peter H Anvin <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210707204249.3046665-1-sathyanarayanan.kuppuswamy@linux.intel.com>
 <20210707204249.3046665-6-sathyanarayanan.kuppuswamy@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <06c85c19-e16c-3121-ed47-075cfa779b67@kernel.org>
Date:   Thu, 8 Jul 2021 15:21:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210707204249.3046665-6-sathyanarayanan.kuppuswamy@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/21 1:42 PM, Kuppuswamy Sathyanarayanan wrote:

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
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> ---
>  drivers/platform/x86/Kconfig            |   9 ++
>  drivers/platform/x86/Makefile           |   1 +
>  drivers/platform/x86/intel_tdx_attest.c | 171 ++++++++++++++++++++++++
>  include/uapi/misc/tdx.h                 |  37 +++++
>  4 files changed, 218 insertions(+)
>  create mode 100644 drivers/platform/x86/intel_tdx_attest.c
>  create mode 100644 include/uapi/misc/tdx.h
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 60592fb88e7a..7d01c473aef6 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -1301,6 +1301,15 @@ config INTEL_SCU_IPC_UTIL
>  	  low level access for debug work and updating the firmware. Say
>  	  N unless you will be doing this on an Intel MID platform.
>  
> +config INTEL_TDX_ATTESTATION
> +	tristate "Intel TDX attestation driver"
> +	depends on INTEL_TDX_GUEST
> +	help
> +	  The TDX attestation driver provides IOCTL or MMAP interfaces to
> +	  the user to request TDREPORT from the TDX module or request quote
> +	  from VMM. It is mainly used to get secure disk decryption keys from
> +	  the key server.

What's the MMAP interface

> +
>  config INTEL_TELEMETRY
>  	tristate "Intel SoC Telemetry Driver"
>  	depends on X86_64
> diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
> index dcc8cdb95b4d..83439990ae47 100644
> --- a/drivers/platform/x86/Makefile
> +++ b/drivers/platform/x86/Makefile
> @@ -138,6 +138,7 @@ obj-$(CONFIG_INTEL_SCU_PCI)		+= intel_scu_pcidrv.o
>  obj-$(CONFIG_INTEL_SCU_PLATFORM)	+= intel_scu_pltdrv.o
>  obj-$(CONFIG_INTEL_SCU_WDT)		+= intel_scu_wdt.o
>  obj-$(CONFIG_INTEL_SCU_IPC_UTIL)	+= intel_scu_ipcutil.o
> +obj-$(CONFIG_INTEL_TDX_ATTESTATION)	+= intel_tdx_attest.o
>  obj-$(CONFIG_INTEL_TELEMETRY)		+= intel_telemetry_core.o \
>  					   intel_telemetry_pltdrv.o \
>  					   intel_telemetry_debugfs.o
> diff --git a/drivers/platform/x86/intel_tdx_attest.c b/drivers/platform/x86/intel_tdx_attest.c
> new file mode 100644
> index 000000000000..a0225d053851
> --- /dev/null
> +++ b/drivers/platform/x86/intel_tdx_attest.c
> @@ -0,0 +1,171 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * intel_tdx_attest.c - TDX guest attestation interface driver.
> + *
> + * Implements user interface to trigger attestation process and
> + * read the TD Quote result.
> + *
> + * Copyright (C) 2020 Intel Corporation
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
> +#include <linux/io.h>
> +#include <asm/apic.h>
> +#include <asm/tdx.h>
> +#include <asm/irq_vectors.h>
> +#include <uapi/misc/tdx.h>
> +
> +#define VERSION				"1.0"
> +
> +/* Used in Quote memory allocation */
> +#define QUOTE_SIZE			(2 * PAGE_SIZE)
> +
> +/* Mutex to synchronize attestation requests */
> +static DEFINE_MUTEX(attestation_lock);
> +/* Completion object to track attestation status */
> +static DECLARE_COMPLETION(attestation_done);
> +
> +static void attestation_callback_handler(void)
> +{
> +	complete(&attestation_done);
> +}
> +
> +static long tdg_attest_ioctl(struct file *file, unsigned int cmd,
> +			     unsigned long arg)
> +{
> +	u64 data = virt_to_phys(file->private_data);


> +	void __user *argp = (void __user *)arg;
> +	u8 *reportdata;
> +	long ret = 0;
> +
> +	mutex_lock(&attestation_lock);
> +
> +	reportdata = kzalloc(TDX_TDREPORT_LEN, GFP_KERNEL);
> +	if (!reportdata) {
> +		mutex_unlock(&attestation_lock);
> +		return -ENOMEM;
> +	}
> +
> +	switch (cmd) {
> +	case TDX_CMD_GET_TDREPORT:
> +		if (copy_from_user(reportdata, argp, TDX_REPORT_DATA_LEN)) {
> +			ret = -EFAULT;
> +			break;
> +		}

This copies from user memory to reportdata.

> +
> +		/* Generate TDREPORT_STRUCT */
> +		if (tdx_mcall_tdreport(data, virt_to_phys(reportdata))) {
> +			ret = -EIO;
> +			break;
> +		}

This does the hypercall.

> +
> +		if (copy_to_user(argp, file->private_data, TDX_TDREPORT_LEN))
> +			ret = -EFAULT;

This copies from private_data to user memory.  How did the report get to
private_data?

> +		break;
> +	case TDX_CMD_GEN_QUOTE:
> +		if (copy_from_user(reportdata, argp, TDX_REPORT_DATA_LEN)) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		/* Generate TDREPORT_STRUCT */
> +		if (tdx_mcall_tdreport(data, virt_to_phys(reportdata))) {
> +			ret = -EIO;
> +			break;
> +		}
> +
> +		ret = set_memory_decrypted((unsigned long)file->private_data,
> +					   1UL << get_order(QUOTE_SIZE));
> +		if (ret)
> +			break;

Now private_data is decrypted.  (And this operation is *expensive*.  Why
is it done at ioctl time?)

> +
> +		/* Submit GetQuote Request */
> +		if (tdx_hcall_get_quote(data)) {
> +			ret = -EIO;
> +			goto done;
> +		}
> +
> +		/* Wait for attestation completion */
> +		wait_for_completion_interruptible(&attestation_done);
> +
> +		if (copy_to_user(argp, file->private_data, QUOTE_SIZE))
> +			ret = -EFAULT;
> +done:
> +		ret = set_memory_encrypted((unsigned long)file->private_data,
> +					   1UL << get_order(QUOTE_SIZE));

And this is, again, quite expensive.

> +
> +		break;
> +	case TDX_CMD_GET_QUOTE_SIZE:
> +		if (put_user(QUOTE_SIZE, (u64 __user *)argp))
> +			ret = -EFAULT;
> +
> +		break;
> +	default:
> +		pr_err("cmd %d not supported\n", cmd);
> +		break;
> +	}
> +
> +	mutex_unlock(&attestation_lock);
> +
> +	kfree(reportdata);
> +
> +	return ret;
> +}
> +
> +static int tdg_attest_open(struct inode *inode, struct file *file)
> +{
> +	/*
> +	 * Currently tdg_event_notify_handler is only used in attestation
> +	 * driver. But, WRITE_ONCE is used as benign data race notice.
> +	 */
> +	WRITE_ONCE(tdg_event_notify_handler, attestation_callback_handler);
> +
> +	file->private_data = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
> +						      get_order(QUOTE_SIZE));

This allocation has negligible cost compared to changing memory to
decrypted.

Shouldn't you allocate a buffer once at driver load time or even at boot
and just keep reusing it as needed?  You could have a few pages of
shared memory for the specific purposes of hypercalls, and you could
check them out and release them when you need some.
