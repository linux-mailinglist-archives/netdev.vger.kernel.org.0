Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE2E2CF09E
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 16:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbgLDPWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 10:22:04 -0500
Received: from www62.your-server.de ([213.133.104.62]:39266 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728708AbgLDPWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 10:22:04 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1klCtR-0006nT-Tm; Fri, 04 Dec 2020 16:21:10 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1klCtR-000Orp-JL; Fri, 04 Dec 2020 16:21:09 +0100
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com> <878sad933c.fsf@toke.dk>
 <20201204124618.GA23696@ranger.igk.intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
Date:   Fri, 4 Dec 2020 16:21:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201204124618.GA23696@ranger.igk.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26007/Thu Dec  3 14:13:31 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/20 1:46 PM, Maciej Fijalkowski wrote:
> On Fri, Dec 04, 2020 at 01:18:31PM +0100, Toke Høiland-Jørgensen wrote:
>> alardam@gmail.com writes:
>>> From: Marek Majtyka <marekx.majtyka@intel.com>
>>>
>>> Implement support for checking what kind of xdp functionality a netdev
>>> supports. Previously, there was no way to do this other than to try
>>> to create an AF_XDP socket on the interface or load an XDP program and see
>>> if it worked. This commit changes this by adding a new variable which
>>> describes all xdp supported functions on pretty detailed level:
>>
>> I like the direction this is going! :)
>>
>>>   - aborted
>>>   - drop
>>>   - pass
>>>   - tx

I strongly think we should _not_ merge any native XDP driver patchset that does
not support/implement the above return codes. Could we instead group them together
and call this something like XDP_BASE functionality to not give a wrong impression?
If this is properly documented that these are basic must-have _requirements_, then
users and driver developers both know what the expectations are.

>>>   - redirect
>>
>> Drivers can in principle implement support for the XDP_REDIRECT return
>> code (and calling xdp_do_redirect()) without implementing ndo_xdp_xmit()
>> for being the *target* of a redirect. While my quick grepping doesn't
>> turn up any drivers that do only one of these right now, I think we've
>> had examples of it in the past, so it would probably be better to split
>> the redirect feature flag in two.
>>
>> This would also make it trivial to replace the check in __xdp_enqueue()
>> (in devmap.c) from looking at whether the ndo is defined, and just
>> checking the flag. It would be great if you could do this as part of
>> this series.
>>
>> Maybe we could even make the 'redirect target' flag be set automatically
>> if a driver implements ndo_xdp_xmit?
> 
> +1
> 
>>>   - zero copy
>>>   - hardware offload.

One other thing that is quite annoying to figure out sometimes and not always
obvious from reading the driver code (and it may even differ depending on how
the driver was built :/) is how much XDP headroom a driver really provides.

We tried to standardize on a minimum guaranteed amount, but unfortunately not
everyone seems to implement it, but I think it would be very useful to query
this from application side, for example, consider that an app inserts a BPF
prog at XDP doing custom encap shortly before XDP_TX so it would be useful to
know which of the different encaps it implements are realistically possible on
the underlying XDP supported dev.

Thanks,
Daniel
