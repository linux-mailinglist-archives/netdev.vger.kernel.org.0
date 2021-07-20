Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3E43D00F8
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 19:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhGTRMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 13:12:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:11538 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231757AbhGTRLp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 13:11:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="275121349"
X-IronPort-AV: E=Sophos;i="5.84,255,1620716400"; 
   d="scan'208";a="275121349"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 10:52:05 -0700
X-IronPort-AV: E=Sophos;i="5.84,255,1620716400"; 
   d="scan'208";a="657629833"
Received: from devenlop-mobl.amr.corp.intel.com (HELO skuppusw-mobl5.amr.corp.intel.com) ([10.209.156.160])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 10:52:04 -0700
Subject: Re: [PATCH v3 5/6] platform/x86: intel_tdx_attest: Add TDX Guest
 attestation interface driver
To:     Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Peter H Anvin <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210720045552.2124688-1-sathyanarayanan.kuppuswamy@linux.intel.com>
 <20210720045552.2124688-6-sathyanarayanan.kuppuswamy@linux.intel.com>
 <eddc318e-e9c9-546d-6cff-b3c40062aecd@intel.com>
From:   "Kuppuswamy, Sathyanarayanan" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Message-ID: <4c43dfe4-e44b-9d6d-b012-63790bb47b19@linux.intel.com>
Date:   Tue, 20 Jul 2021 10:52:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <eddc318e-e9c9-546d-6cff-b3c40062aecd@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/20/21 9:53 AM, Dave Hansen wrote:
>> +/* Used in Quote memory allocation */
>> +#define QUOTE_SIZE			(2 * PAGE_SIZE)
>> +/* Get Quote timeout in msec */
>> +#define GET_QUOTE_TIMEOUT		(5000)
> 
> The comment is good, but even better would be to call this:
> 
> 	GET_QUOTE_TIMEOUT_MS

I can change it to GET_QUOTE_TIMEOUT_MS.

> 
>> +/* Mutex to synchronize attestation requests */
>> +static DEFINE_MUTEX(attestation_lock);
>> +/* Completion object to track attestation status */
>> +static DECLARE_COMPLETION(attestation_done);
>> +/* Buffer used to copy report data in attestation handler */
>> +static u8 report_data[TDX_REPORT_DATA_LEN];
>> +/* Data pointer used to get TD Quote data in attestation handler */
>> +static void *tdquote_data;
>> +/* Data pointer used to get TDREPORT data in attestation handler */
>> +static void *tdreport_data;
> 
> Are these *really* totally unknown, opaque blobs?  Why not give them an

 From this driver perspective, they are opaque blobs. We don't have any
need to access it. Once this data is passed back to user-agent,
it can decode it appropriately. The data format of this blob is defined
by TDX Module spec.

> actual data type?

If void * is not good, may be we can use u8*. But we really don't access it.

> 
>> +/* DMA handle used to allocate and free tdquote DMA buffer */
>> +dma_addr_t tdquote_dma_handle;
> 
> That's an unreadable jumble.  Please add some line breaks and try to
> logically group those.

Ok.

> 
>> +static void attestation_callback_handler(void)
>> +{
>> +	complete(&attestation_done);
>> +}
>> +
>> +static long tdg_attest_ioctl(struct file *file, unsigned int cmd,
>> +			     unsigned long arg)
>> +{
>> +	void __user *argp = (void __user *)arg;
>> +	long ret = 0;
>> +
>> +	mutex_lock(&attestation_lock);
>> +
>> +	switch (cmd) {
>> +	case TDX_CMD_GET_TDREPORT:
>> +		if (copy_from_user(report_data, argp, TDX_REPORT_DATA_LEN)) {
>> +			ret = -EFAULT;
>> +			break;
>> +		}
>> +
>> +		/* Generate TDREPORT_STRUCT */
>> +		if (tdx_mcall_tdreport(virt_to_phys(tdreport_data),
>> +				       virt_to_phys(report_data))) {
> 
> Having that take a physical address seems like a mistake.  Why not just
> do the virt_to_phys() inside the helper?

Both are same. But, if this makes it easier to understand, I can move the
virt_to_phys() inside the tdx_mcall_tdreport() helper function.

> 
> Also, this isn't very clear that there is an input and an output.  Can
> you rename these to make that more clear?

Ok. I can rename them as tdreport_data -> tdreport_output and report_data ->
report_input.

> 
>> +			ret = -EIO;
>> +			break;
>> +		}
>> +
>> +		if (copy_to_user(argp, tdreport_data, TDX_TDREPORT_LEN))
>> +			ret = -EFAULT;
>> +		break;
>> +	case TDX_CMD_GEN_QUOTE:
>> +		/* Copy TDREPORT data from user buffer */
>> +		if (copy_from_user(tdquote_data, argp, TDX_TDREPORT_LEN)) {
>> +			ret = -EFAULT;
>> +			break;
>> +		}
>> +
>> +		/* Submit GetQuote Request */
>> +		if (tdx_hcall_get_quote(virt_to_phys(tdquote_data))) {
>> +			ret = -EIO;
>> +			break;
>> +		}
>> +
>> +		/* Wait for attestation completion */
>> +		ret = wait_for_completion_interruptible_timeout(
>> +				&attestation_done,
>> +				msecs_to_jiffies(GET_QUOTE_TIMEOUT));
>> +		if (ret <= 0) {
>> +			ret = -EIO;
>> +			break;
>> +		}
>> +
>> +		if (copy_to_user(argp, tdquote_data, QUOTE_SIZE))
>> +			ret = -EFAULT;
>> +
>> +		break;
>> +	case TDX_CMD_GET_QUOTE_SIZE:
>> +		ret = put_user(QUOTE_SIZE, (u64 __user *)argp);
>> +		break;
>> +	default:
>> +		pr_err("cmd %d not supported\n", cmd);
>> +		break;
> 
> First of all, drivers shouldn't pollute the kernel log on bad input.
> Second, won't this inherit the ret=0 value and return success?

Good catch. I need to set ret=-EIO here. I will also remove the pr_err.

> 
>> +	}
>> +
>> +	mutex_unlock(&attestation_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static const struct file_operations tdg_attest_fops = {
>> +	.owner		= THIS_MODULE,
>> +	.unlocked_ioctl	= tdg_attest_ioctl,
>> +	.llseek		= no_llseek,
>> +};
>> +
>> +static struct miscdevice tdg_attest_device = {
>> +	.minor          = MISC_DYNAMIC_MINOR,
>> +	.name           = "tdx-attest",
>> +	.fops           = &tdg_attest_fops,
>> +};
>> +
>> +static int __init tdg_attest_init(void)
>> +{
>> +	dma_addr_t handle;
>> +	long ret = 0;
> 
> The function returns 'int', yet 'ret' is a long.  Why?

It doesn't need to be long. I will change it to int.

> 
>> +	ret = misc_register(&tdg_attest_device);
>> +	if (ret) {
>> +		pr_err("misc device registration failed\n");
>> +		return ret;
>> +	}
>> +
>> +	tdreport_data = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 0);
>> +	if (!tdreport_data) {
>> +		ret = -ENOMEM;
>> +		goto failed;
>> +	}
> 
> Why does this need to use the page allocator directly?  Why does it need
> to zero the memory?  Why does it need to get a whole page?  If it really

I have zeroed out the memory to make it easier to test whether
TDX_CMD_GET_TDREPORT module call works or not. Not a TDX module requirement.

I will remove _GFP_ZERO flag in next version.

> only needs a single page, why not use __get_free_page()?

Yes, I only need one page. I will use __get_free_page().

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
