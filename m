Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A91026987F
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 00:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgINWCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 18:02:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:34602 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgINWCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 18:02:17 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kHwY0-0008F6-Ov; Tue, 15 Sep 2020 00:02:04 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kHwY0-0009dt-G3; Tue, 15 Sep 2020 00:02:04 +0200
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     =?UTF-8?Q?Laura_Garc=c3=ada_Li=c3=a9bana?= <nevola@gmail.com>
Cc:     Lukas Wunner <lukas@wunner.de>,
        John Fastabend <john.fastabend@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
References: <20200904162154.GA24295@wunner.de>
 <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
 <20200905052403.GA10306@wunner.de>
 <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
 <CAF90-Whc3HL9x-7TJ7m3tZp10RNmQxFD=wdQUJLCaUajL2RqXg@mail.gmail.com>
 <8e991436-cb1c-1306-51ac-bb582bfaa8a7@iogearbox.net>
 <CAF90-Wh=wzjNtFWRv9bzn=-Dkg-Qc9G_cnyoq0jSypxQQgg3uA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <29b888f5-5e8e-73fe-18db-6c5dd57c6b4f@iogearbox.net>
Date:   Tue, 15 Sep 2020 00:02:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAF90-Wh=wzjNtFWRv9bzn=-Dkg-Qc9G_cnyoq0jSypxQQgg3uA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25929/Sun Sep 13 15:53:46 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/14/20 1:29 PM, Laura García Liébana wrote:
> On Fri, Sep 11, 2020 at 6:28 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 9/11/20 9:42 AM, Laura García Liébana wrote:
>>> On Tue, Sep 8, 2020 at 2:55 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>> On 9/5/20 7:24 AM, Lukas Wunner wrote:
>>>>> On Fri, Sep 04, 2020 at 11:14:37PM +0200, Daniel Borkmann wrote:
>>>>>> On 9/4/20 6:21 PM, Lukas Wunner wrote:
>>>> [...]
>>>>>> The tc queueing layer which is below is not the tc egress hook; the
>>>>>> latter is for filtering/mangling/forwarding or helping the lower tc
>>>>>> queueing layer to classify.
>>>>>
>>>>> People want to apply netfilter rules on egress, so either we need an
>>>>> egress hook in the xmit path or we'd have to teach tc to filter and
>>>>> mangle based on netfilter rules.  The former seemed more straight-forward
>>>>> to me but I'm happy to pursue other directions.
>>>>
>>>> I would strongly prefer something where nf integrates into existing tc hook,
>>>> not only due to the hook reuse which would be better, but also to allow for a
>>>> more flexible interaction between tc/BPF use cases and nf, to name one
>>>
>>> That sounds good but I'm afraid that it would take too much back and
>>> forth discussions. We'll really appreciate it if this small patch can
>>> be unblocked and then rethink the refactoring of ingress/egress hooks
>>> that you commented in another thread.
>>
>> I'm not sure whether your comment was serious or not, but nope, this needs
>> to be addressed as mentioned as otherwise this use case would regress. It
> 
> This patch doesn't break anything. The tc redirect use case that you
> just commented on is the expected behavior and the same will happen
> with ingress. To be consistent, in the case that someone requires both
> hooks, another tc redirect would be needed in the egress path. If you
> mean to bypass the nf egress if tc redirect in ingress is used, that
> would lead in a huge security concern.

I'm not sure I parse what you're saying above ... today it is possible and
perfectly fine to e.g. redirect to a host-facing veth from tc ingress which
then goes into container. Only traffic that goes up the host stack is seen
by nf ingress hook in that case. Likewise, reply traffic can be redirected
from host-facing veth to phys dev for xmit w/o any netfilter interference.
This means netfilter in host ns really only sees traffic to/from host as
intended. This is fine today, however, if 3rd party entities (e.g. distro
side) start pushing down rules on the two nf hooks, then these use cases will
break on the egress one due to this asymmetric layering violation. Hence my
ask that this needs to be configurable from a control plane perspective so
that both use cases can live next to each other w/o breakage. Most trivial
one I can think of is (aside from the fact to refactor the hooks and improve
their performance) a flag e.g. for skb that can be set from tc/BPF layer to
bypass the nf hooks. Basically a flexible opt-in so that existing use-cases
can be retained w/o breakage. This is one option with what I meant in my
earlier mail.

>> is one thing for you wanting to remove tc / BPF from your application stack
>> as you call it, but not at the cost of breaking others.
> 
> I'm not intended to remove tc / BPF from my application stack as I'm
> not using it and, as I explained in past emails, it can't be used for
> my use cases.
> 
> In addition, let's review your NACK reasons:
> 
>     This reverts the following commits:
> 
>       8537f78647c0 ("netfilter: Introduce egress hook")
>       5418d3881e1f ("netfilter: Generalize ingress hook")
>       b030f194aed2 ("netfilter: Rename ingress hook include file")
> 
>     From the discussion in [0], the author's main motivation to add a hook
>     in fast path is for an out of tree kernel module, which is a red flag
>     to begin with. Other mentioned potential use cases like NAT{64,46}
>     is on future extensions w/o concrete code in the tree yet. Revert as
>     suggested [1] given the weak justification to add more hooks to critical
>     fast-path.
> 
>       [0] https://lore.kernel.org/netdev/cover.1583927267.git.lukas@wunner.de/
>       [1] https://lore.kernel.org/netdev/20200318.011152.72770718915606186.davem@davemloft.net/
> 
> It has been explained already that there are more use cases that
> require this hook in nf, not only for future developments or out of
> tree modules.

Sure, aside from the two mentioned cases above, we scratched DHCP a little
bit on the surface but it was found that i) you need a af_packet specific
hook to get there instead, and ii) dhcp clients implement their own filtering
internally to check for bogus messages. What is confusing to me is whether
this is just brought up as an example or whether you actually care to solve
it (.. but then why would you do that in fast-path to penalize every other
traffic as well just for this type of slow-path filtering instead of doing
in af_packet only). Similarly, why not add this along with /actual/ nat64
code with /concrete/ explanation of why it cannot be performed in post-routing?
Either way, whatever your actual/real use-case, the above must be addressed
one way or another.

Thanks,
Daniel
