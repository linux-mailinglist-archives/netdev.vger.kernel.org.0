Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57BA3C1C26
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 01:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhGHXhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 19:37:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:35602 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhGHXhL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 19:37:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10039"; a="209434449"
X-IronPort-AV: E=Sophos;i="5.84,225,1620716400"; 
   d="scan'208";a="209434449"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 16:34:26 -0700
X-IronPort-AV: E=Sophos;i="5.84,225,1620716400"; 
   d="scan'208";a="564719401"
Received: from npujari-mobl.amr.corp.intel.com (HELO skuppusw-mobl5.amr.corp.intel.com) ([10.213.167.42])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 16:34:24 -0700
Subject: Re: [PATCH v2 5/6] platform/x86: intel_tdx_attest: Add TDX Guest
 attestation interface driver
To:     Andy Lutomirski <luto@kernel.org>,
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
 <06c85c19-e16c-3121-ed47-075cfa779b67@kernel.org>
From:   "Kuppuswamy, Sathyanarayanan" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Message-ID: <02b82025-fcb9-d5bc-fb10-52cec17e8588@linux.intel.com>
Date:   Thu, 8 Jul 2021 16:34:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <06c85c19-e16c-3121-ed47-075cfa779b67@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 7/8/21 3:21 PM, Andy Lutomirski wrote:
> On 7/7/21 1:42 PM, Kuppuswamy Sathyanarayanan wrote:
> 
>> The interaction with the TDX module is like a RPM protocol here. There
>> are several operations (get tdreport, get quote) that need to input a
>> blob, and then output another blob. It was considered to use a sysfs
>> interface for this, but it doesn't fit well into the standard sysfs
>> model for configuring values. It would be possible to do read/write on
>> files, but it would need multiple file descriptors, which would be
>> somewhat messy. ioctls seems to be the best fitting and simplest model
>> here. There is one ioctl per operation, that takes the input blob and
>> returns the output blob, and as well as auxiliary ioctls to return the
>> blob lengths. The ioctls are documented in the header file.
>>
>> Reviewed-by: Tony Luck <tony.luck@intel.com>
>> Reviewed-by: Andi Kleen <ak@linux.intel.com>
>> Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
>> ---


>> +config INTEL_TDX_ATTESTATION
>> +	tristate "Intel TDX attestation driver"
>> +	depends on INTEL_TDX_GUEST
>> +	help
>> +	  The TDX attestation driver provides IOCTL or MMAP interfaces to
>> +	  the user to request TDREPORT from the TDX module or request quote
>> +	  from VMM. It is mainly used to get secure disk decryption keys from
>> +	  the key server.
> 
> What's the MMAP interface

Initially this driver supported MMAP to allow user directly get the quote data
without internal copies. But it was later removed based on internal review
comments to simplify the driver interfaces. During the cleanup I somehow missed its
reference in Kconfig file. Sorry, I will fix it in next version.


>> +static long tdg_attest_ioctl(struct file *file, unsigned int cmd,
>> +			     unsigned long arg)
>> +{
>> +	u64 data = virt_to_phys(file->private_data);
> 
> 
>> +	void __user *argp = (void __user *)arg;
>> +	u8 *reportdata;
>> +	long ret = 0;
>> +
>> +	mutex_lock(&attestation_lock);
>> +
>> +	reportdata = kzalloc(TDX_TDREPORT_LEN, GFP_KERNEL);
>> +	if (!reportdata) {
>> +		mutex_unlock(&attestation_lock);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	switch (cmd) {
>> +	case TDX_CMD_GET_TDREPORT:
>> +		if (copy_from_user(reportdata, argp, TDX_REPORT_DATA_LEN)) {
>> +			ret = -EFAULT;
>> +			break;
>> +		}
> 
> This copies from user memory to reportdata.
> 
>> +
>> +		/* Generate TDREPORT_STRUCT */
>> +		if (tdx_mcall_tdreport(data, virt_to_phys(reportdata))) {
>> +			ret = -EIO;
>> +			break;
>> +		}
> 
> This does the hypercall.
> 
>> +
>> +		if (copy_to_user(argp, file->private_data, TDX_TDREPORT_LEN))
>> +			ret = -EFAULT;
> 
> This copies from private_data to user memory.  How did the report get to
> private_data?

Report data is copied by previous TDX module call. The pointer we pass to it is the
physical address of file->private_data.


> 
>> +		break;
>> +	case TDX_CMD_GEN_QUOTE:
>> +		if (copy_from_user(reportdata, argp, TDX_REPORT_DATA_LEN)) {
>> +			ret = -EFAULT;
>> +			break;
>> +		}
>> +
>> +		/* Generate TDREPORT_STRUCT */
>> +		if (tdx_mcall_tdreport(data, virt_to_phys(reportdata))) {
>> +			ret = -EIO;
>> +			break;
>> +		}
>> +
>> +		ret = set_memory_decrypted((unsigned long)file->private_data,
>> +					   1UL << get_order(QUOTE_SIZE));
>> +		if (ret)
>> +			break;
> 
> Now private_data is decrypted.  (And this operation is *expensive*.  Why
> is it done at ioctl time?)

We are trying to use the same buffer in both tdx_mcall_*() and tdx_hcall_*()
functions to avoid unnecessary data copies. Since we cannot pass decrypted page
address to TDX module call, we have decrypted it in IOCTL after doing the
TDX module call.

We can move this decrypted/encrypted mapping code to open()/close() functions.
But in that case, after the TDX module call, we need to separately copy the report
data to the quote buffer before making the GetQuote hypercall.

> 
>> +
>> +		/* Submit GetQuote Request */
>> +		if (tdx_hcall_get_quote(data)) {
>> +			ret = -EIO;
>> +			goto done;
>> +		}
>> +
>> +		/* Wait for attestation completion */
>> +		wait_for_completion_interruptible(&attestation_done);
>> +
>> +		if (copy_to_user(argp, file->private_data, QUOTE_SIZE))
>> +			ret = -EFAULT;
>> +done:
>> +		ret = set_memory_encrypted((unsigned long)file->private_data,
>> +					   1UL << get_order(QUOTE_SIZE));
> 
> And this is, again, quite expensive.

Same as above.

> 
>> +
>> +		break;
>> +	case TDX_CMD_GET_QUOTE_SIZE:
>> +		if (put_user(QUOTE_SIZE, (u64 __user *)argp))
>> +			ret = -EFAULT;
>> +
>> +		break;
>> +	default:
>> +		pr_err("cmd %d not supported\n", cmd);
>> +		break;
>> +	}
>> +
>> +	mutex_unlock(&attestation_lock);
>> +
>> +	kfree(reportdata);
>> +
>> +	return ret;
>> +}
>> +
>> +static int tdg_attest_open(struct inode *inode, struct file *file)
>> +{
>> +	/*
>> +	 * Currently tdg_event_notify_handler is only used in attestation
>> +	 * driver. But, WRITE_ONCE is used as benign data race notice.
>> +	 */
>> +	WRITE_ONCE(tdg_event_notify_handler, attestation_callback_handler);
>> +
>> +	file->private_data = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
>> +						      get_order(QUOTE_SIZE));
> 
> This allocation has negligible cost compared to changing memory to
> decrypted.
> 
> Shouldn't you allocate a buffer once at driver load time or even at boot
> and just keep reusing it as needed?  You could have a few pages of
> shared memory for the specific purposes of hypercalls, and you could
> check them out and release them when you need some.

If you are fine with additional data copy cost, I can move the decrypted/
encrypted mapping code to open/close() functions.

> 

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
