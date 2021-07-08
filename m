Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692593C1C53
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 01:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhGIAAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 20:00:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:6504 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229600AbhGIAAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 20:00:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10039"; a="209582193"
X-IronPort-AV: E=Sophos;i="5.84,225,1620716400"; 
   d="scan'208";a="209582193"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 16:57:27 -0700
X-IronPort-AV: E=Sophos;i="5.84,225,1620716400"; 
   d="scan'208";a="564724399"
Received: from npujari-mobl.amr.corp.intel.com (HELO skuppusw-mobl5.amr.corp.intel.com) ([10.213.167.42])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 16:57:26 -0700
Subject: Re: [PATCH v2 5/6] platform/x86: intel_tdx_attest: Add TDX Guest
 attestation interface driver
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Peter H Anvin <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        X86 ML <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org, bpf@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>
References: <20210707204249.3046665-1-sathyanarayanan.kuppuswamy@linux.intel.com>
 <20210707204249.3046665-6-sathyanarayanan.kuppuswamy@linux.intel.com>
 <CAPcyv4h8SaVL_QGLv1DT0JuoyKmSBvxJQw0aamMuzarexaU7VA@mail.gmail.com>
From:   "Kuppuswamy, Sathyanarayanan" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Message-ID: <24d8fd58-36c1-0e89-4142-28f29e2c434b@linux.intel.com>
Date:   Thu, 8 Jul 2021 16:57:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAPcyv4h8SaVL_QGLv1DT0JuoyKmSBvxJQw0aamMuzarexaU7VA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/21 4:36 PM, Dan Williams wrote:
>> +static int tdg_attest_open(struct inode *inode, struct file *file)
>> +{
>> +       /*
>> +        * Currently tdg_event_notify_handler is only used in attestation
>> +        * driver. But, WRITE_ONCE is used as benign data race notice.
>> +        */
>> +       WRITE_ONCE(tdg_event_notify_handler, attestation_callback_handler);
> Why is this ioctl not part of the driver that registered the interrupt

We cannot club them because they are not functionally related. Even notification
is a separate common feature supported by TDX and configured using
SetupEventNotifyInterrupt hypercall. It is not related to TDX attestation.
Attestation just uses event notification interface to get the quote
completion event.

> handler for this callback in the first instance? I've never seen this
> style of cross-driver communication before.

This is similar to x86_platform_ipi_callback() acrn_setup_intr_handler()
use cases.

> 
>> +
>> +       file->private_data = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
>> +                                                     get_order(QUOTE_SIZE));
> Why does this driver abandon all semblance of type-safety and use
> ->private_data directly? This also seems an easy way to consume
> memory, just keep opening this device over and over again.
> 
> AFAICS this buffer is only used ephemerally. I see no reason it needs
> to be allocated once per open file. Unless you need several threads to
> be running the attestation process in parallel just allocate a single
> buffer at module init (statically defined or on the heap) and use a
> lock to enforce only one user of this buffer at a time. That would
> also solve your direct-map fracturing problem.

Theoretically attestation requests can be sent in parallel. I have
allocated the memory in open() call mainly for this reason. But current
TDX ABI specification does not clearly specify this possibility and I am
not sure whether TDX KVM supports it. Let me confirm about it again with
TDX KVM owner. If such model is not currently supported, then I will move
the memory allocation to init code.

> 
> All that said, this new user ABI for passing blobs in and out of the
> kernel is something that the keyutils API already does. Did you
> consider add_key() / request_key() for this case? That would also be
> the natural path for the end step of requesting the drive decrypt key.
> I.e. a chain of key payloads starting with establishing the
> attestation blob.

I am not sure whether we can use keyutil interface for attestation. AFAIK,
there are other use cases for attestation other than  getting keys for
encrypted drives.

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
