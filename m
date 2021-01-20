Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5946E2FD409
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390778AbhATPck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:32:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:26765 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbhATP2E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 10:28:04 -0500
IronPort-SDR: tPIf5D7wcw9TLmLIRCN77PsGhKXy5ctmSGtnDrrPvLulPWoP20tK2H89TJoh2IO3SmFX1zE2F4
 1ki/5uxmQQlw==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="166215305"
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="166215305"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 07:27:21 -0800
IronPort-SDR: EfTUk0CyMQ9m/ZXiyJTwZsxlcSmwgFtLaY97XEmfMWQdRofHGr5cL7RrAjAtJGOC3E7Seq5ALJ
 dQYQ26sN9FaQ==
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="384875115"
Received: from myegin-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.42.133])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 07:27:16 -0800
Subject: Re: [PATCH bpf-next v2 5/8] libbpf, xsk: select AF_XDP BPF program
 based on kernel version
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com,
        Marek Majtyka <alardam@gmail.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-6-bjorn.topel@gmail.com> <875z3repng.fsf@toke.dk>
 <6c7da700-700d-c7f6-fe0a-c42e55e81c8a@intel.com>
 <6cda7383-663e-ed92-45dd-bbf87ca45eef@intel.com> <87eeif4p96.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <2751bcd9-b3af-0366-32ee-a52d5919246c@intel.com>
Date:   Wed, 20 Jan 2021 16:27:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <87eeif4p96.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-20 16:11, Toke Høiland-Jørgensen wrote:
> Björn Töpel <bjorn.topel@intel.com> writes:
> 
>> On 2021-01-20 14:25, Björn Töpel wrote:
>>> On 2021-01-20 13:52, Toke Høiland-Jørgensen wrote:
>>>> Björn Töpel <bjorn.topel@gmail.com> writes:
>>>>
>>>>> From: Björn Töpel <bjorn.topel@intel.com>
>>>>>
>>>>> Add detection for kernel version, and adapt the BPF program based on
>>>>> kernel support. This way, users will get the best possible performance
>>>>> from the BPF program.
>>>>
>>>> Please do explicit feature detection instead of relying on the kernel
>>>> version number; some distro kernels are known to have a creative notion
>>>> of their own version, which is not really related to the features they
>>>> actually support (I'm sure you know which one I'm referring to ;)).
>>>>
>>>
>>> Right. For a *new* helper, like bpf_redirect_xsk, we rely on rejection
>>> from the verifier to detect support. What about "bpf_redirect_map() now
>>> supports passing return value as flags"? Any ideas how to do that in a
>>> robust, non-version number-based scheme?
>>>
>>
>> Just so that I understand this correctly. Red^WSome distro vendors
>> backport the world, and call that franken kernel, say, 3.10. Is that
>> interpretation correct? My hope was that wasn't the case. :-(
> 
> Yup, indeed. All kernels shipped for the entire lifetime of RHEL8 think
> they are v4.18.0... :/
> 
> I don't think we're the only ones doing it (there are examples in the
> embedded world as well, for instance, and not sure about the other
> enterprise distros), but RHEL is probably the most extreme example.
> 
> We could patch the version check in the distro-supplied version of
> libbpf, of course, but that doesn't help anyone using upstream versions,
> and given the prevalence of vendoring libbpf, I fear that going with the
> version check will just result in a bad user experience...
>

Ok! Thanks for clearing that out!

>> Would it make sense with some kind of BPF-specific "supported
>> features" mechanism? Something else with a bigger scope (whole
>> kernel)?
> 
> Heh, in my opinion, yeah. Seems like we'll finally get it for XDP, but
> for BPF in general the approach has always been probing AFAICT.
> 
> For the particular case of arguments to helpers, I suppose the verifier
> could technically validate value ranges for flags arguments, say. That
> would be nice as an early reject anyway, but I'm not sure if it is
> possible to add after-the-fact without breaking existing programs
> because the verifier can't prove the argument is within the valid range.
> And of course it doesn't help you with compatibility with
> already-released kernels.
>

Hmm, think I have a way forward. I'll use BPF_PROG_TEST_RUN.

If the load fail for the new helper, fallback to bpf_redirect_map(). Use
BPF_PROG_TEST_RUN to make sure that "action via flags" passes.

That should work for you guys as well, right? I'll take a stab at it.


Björn
