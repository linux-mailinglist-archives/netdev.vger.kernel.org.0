Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7DE2FD3D5
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390973AbhATPUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 10:20:07 -0500
Received: from mga12.intel.com ([192.55.52.136]:52374 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390940AbhATPTn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 10:19:43 -0500
IronPort-SDR: w/daRnpDHBqQ+t1SSp7LSO5MeLjY0G63ZLNesQJl8YPiWYJZnflqIKiR6rybtEKmnW9Q1lUhXL
 OXXU9SwWjcbw==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="158300345"
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="158300345"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 07:18:59 -0800
IronPort-SDR: gYftjvkMTxhOs2wcD8dsFgStT5OQnZGd3cTeNmmLhv7I187CtiUdRBSfwOH0rumbd+lSr0avc8
 8iA3DtUwXTXQ==
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="384871880"
Received: from myegin-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.42.133])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 07:18:54 -0800
Subject: Re: [PATCH bpf-next v2 4/8] xsk: register XDP sockets at bind(), and
 add new AF_XDP BPF helper
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <20210119155013.154808-5-bjorn.topel@gmail.com> <878s8neprj.fsf@toke.dk>
 <46162f5f-5b3c-903b-8b8d-7c1afc74cb05@intel.com> <87k0s74q1a.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <3c6feb0d-6a64-2251-3cac-c79cff29d85c@intel.com>
Date:   Wed, 20 Jan 2021 16:18:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <87k0s74q1a.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-20 15:54, Toke Høiland-Jørgensen wrote:
> Björn Töpel <bjorn.topel@intel.com> writes:
> 
>> On 2021-01-20 13:50, Toke Høiland-Jørgensen wrote:
>>> Björn Töpel <bjorn.topel@gmail.com> writes:
>>>
>>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>>> index c001766adcbc..bbc7d9a57262 100644
>>>> --- a/include/uapi/linux/bpf.h
>>>> +++ b/include/uapi/linux/bpf.h
>>>> @@ -3836,6 +3836,12 @@ union bpf_attr {
>>>>     *	Return
>>>>     *		A pointer to a struct socket on success or NULL if the file is
>>>>     *		not a socket.
>>>> + *
>>>> + * long bpf_redirect_xsk(struct xdp_buff *xdp_md, u64 action)
>>>> + *	Description
>>>> + *		Redirect to the registered AF_XDP socket.
>>>> + *	Return
>>>> + *		**XDP_REDIRECT** on success, otherwise the action parameter is returned.
>>>>     */
>>>
>>> I think it would be better to make the second argument a 'flags'
>>> argument and make values > XDP_TX invalid (like we do in
>>> bpf_xdp_redirect_map() now). By allowing any value as return you lose
>>> the ability to turn it into a flags argument later...
>>>
>>
>> Yes, but that adds a run-time check. I prefer this non-checked version,
>> even though it is a bit less futureproof.
> 
> That...seems a bit short-sighted? :)
> Can you actually see a difference in your performance numbers?
>

I would rather add an additional helper *if* we see the need for flags,
instead of paying for that upfront. For me, BPF is about being able to
specialize, and not having one call with tons of checks.

(Related; Going forward, the growing switch() for redirect targets in
xdp_do_redirect() is a concern for me...)

And yes, even with all those fancy branch predictors, less instructions
is still less. :-) (It shows in my ubenchs.)


Björn

