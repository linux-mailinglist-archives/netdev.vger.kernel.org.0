Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6C53C1CD2
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 02:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhGIAj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 20:39:28 -0400
Received: from mga14.intel.com ([192.55.52.115]:39326 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhGIAj2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 20:39:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10039"; a="209440428"
X-IronPort-AV: E=Sophos;i="5.84,225,1620716400"; 
   d="scan'208";a="209440428"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 17:36:45 -0700
X-IronPort-AV: E=Sophos;i="5.84,225,1620716400"; 
   d="scan'208";a="458088595"
Received: from akleen-mobl1.amr.corp.intel.com (HELO [10.212.178.170]) ([10.212.178.170])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 17:36:44 -0700
Subject: Re: [PATCH v2 5/6] platform/x86: intel_tdx_attest: Add TDX Guest
 attestation interface driver
To:     Dan Williams <dan.j.williams@intel.com>,
        "Kuppuswamy, Sathyanarayanan" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
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
 <24d8fd58-36c1-0e89-4142-28f29e2c434b@linux.intel.com>
 <CAPcyv4heA8gps2K_ckUV1gGJdjGeB+5dOSntS=TREEX5-0rtwQ@mail.gmail.com>
From:   Andi Kleen <ak@linux.intel.com>
Message-ID: <4972fc1a-1ffb-2b6d-e764-471210df96a3@linux.intel.com>
Date:   Thu, 8 Jul 2021 17:36:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAPcyv4heA8gps2K_ckUV1gGJdjGeB+5dOSntS=TREEX5-0rtwQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/8/2021 5:20 PM, Dan Williams wrote:
>
> If you have a lock would TDX KVM even notice that its parallel
> requests are being handled serially? I.e. even if they said "yes,
> multiple requests may happen in parallel", until it becomes an actual
> latency problem in practice it's not clear that this generous use of
> resources is justified.
The worst case usage is 2 pages * file descriptor. There are lots of 
other ways to use that much and more memory for each file descriptor.

>
> Scratch that... this driver already has the attestation_lock! So, it's
> already the case that only one thread can be attesting at a time. The
> per-file buffer is unecessary.

But then you couldn't free the buffer. So it would be leaked forever for 
likely only one attestation.

Not sure what problem you're trying to solve here.


>
> keyutils supports generating and passing blobs into and out of the
> kernel with a handle associated to those blobs. This driver adds a TDX
> way to pass blobs into and out of the kernel. If Linux grows other
> TDX-like attestation requirements in the future (e.g. PCI SPDM) should
> each of those invent their own user ABI for passing blobs around?

The TDX blobs are different than any blobs that keyutils supports today. 
The TDX operations are different too.

TDREPORT doesn't even involve any keys, it's just attestation reports.

keyutils today nothing related to attestation.

I just don't see any commonality. If there was commonality it would be 
more with the TPM interface, but TDX attestation is different enough 
that it also isn't feasible to directly convert it into TPM operation 
(apart from standard TPM being a beast that you better avoid as much as 
possible anyways)

-Andi



