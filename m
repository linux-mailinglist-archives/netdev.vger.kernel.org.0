Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2921997D1
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 15:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731000AbgCaNtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 09:49:10 -0400
Received: from www62.your-server.de ([213.133.104.62]:39328 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730755AbgCaNtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 09:49:10 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jJHGC-0003aX-Gy; Tue, 31 Mar 2020 15:48:56 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jJHGC-000Lvi-00; Tue, 31 Mar 2020 15:48:56 +0200
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        dsahern@gmail.com
References: <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk> <20200326195859.u6inotgrm3ubw5bx@ast-mbp>
 <87imiqm27d.fsf@toke.dk> <20200327230047.ois5esl35s63qorj@ast-mbp>
 <87lfnll0eh.fsf@toke.dk> <20200328022609.zfupojim7see5cqx@ast-mbp>
 <87eetcl1e3.fsf@toke.dk>
 <CAEf4Bzb+GSf8cE_rutiaeZOtAuUick1+RnkCBU=Z+oY_36ArSA@mail.gmail.com>
 <87y2rihruq.fsf@toke.dk>
 <CAEf4Bza4vKbjkj8kBkrVmayFr2j_nvrORF_YkCoVKibB=SmSYQ@mail.gmail.com>
 <87pncsj0hv.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <86f95d7a-1659-a092-91a2-abe5d58ceda8@iogearbox.net>
Date:   Tue, 31 Mar 2020 15:48:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87pncsj0hv.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25768/Tue Mar 31 15:08:38 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/20 12:13 PM, Toke Høiland-Jørgensen wrote:
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> 
>>>> So you install your libxdp-based firewalls and are happy. Then you
>>>> decide to install this awesome packet analyzer, which doesn't know
>>>> about libxdp yet. Suddenly, you get all packets analyzer, but no more
>>>> firewall, until users somehow notices that it's gone. Or firewall
>>>> periodically checks that it's still runinng. Both not great, IMO, but
>>>> might be acceptable for some users, I guess. But imagine all the
>>>> confusion for user, especially if he doesn't give a damn about XDP and
>>>> other buzzwords, but only needs a reliable firewall :)
>>>
>>> Yes, whereas if the firewall is using bpf_link, then the packet analyser
>>> will be locked out and can't do its thing. Either way you end up with a
>>> broken application; it's just moving the breakage. In the case of
>>
>> Hm... In one case firewall installation reported success and stopped
>> working afterwards with no notification and user having no clue. In
>> another, packet analyzer refused to start and reported error to user.
>> Let's agree to disagree that those are not at all equivalent. To me
>> silent failure is so much worse, than application failing to start in
>> the first place.

I sort of agree with both of you that either case is not great. The silent
override we currently have is not great since it can be evicted at any time
but also bpf_link to lock-out other programs at XDP layer is not great either
since there is also huge potential to break existing programs. It's probably
best to discuss on an actual proposal to see the concrete semantics, but my
concerns, assuming I didn't misunderstand or got confused on something along
the way (if so, please let me know), currently are:

  - System service XYZ starts to use XDP with bpf_link one day. Somehow this
    application gets shipped by default on mainstream distros and starts up
    during init, then effectively locking out everyone else that used to use
    the hook today "just fine" given they owned / orchestrated the underlying
    networking on the host namespace for the nodes they manage (and for that
    it worked before). Now such latter app somehow needs to work around this
    breakage by undoing the damage that XYZ did in order to be able to operate
    again. There was mentioned 'human override'. I presume whatever it will be,
    it will also be done by applications when they don't have another choice.
    Otherwise we need to go and tell users that XDP is now only _entirely_
    reserved for system service XYZ if you run distro ABC, but not for everyone
    else anymore; what answer is there to this? From a PoV where one owns the
    entire distro and ecosystem, this is fine, but where this is not the case
    as in the rest of the world having to rely on mainstream distros, what is
    the answer to users (and especially "those that don't give a damn about XDP,
    but just want to get stuff to work" that used to work before, even if we
    think silent override is broken)? If the answer is to just 'shrug' and tell
    'sorry that's the new way it is right now', then apps will try to use whatever
    'human override' there is, and we're back to square one. To provide a
    concrete example: if Cilium was configured to load some of its programs on
    XDP hook, it currently replaces whatever it was there before. The assumption
    is, that in the scenario we're in, we can orchestrate the hostns networking
    just fine on K8s nodes since there is just one CNI plugin taking care of that
    (and that generally also holds true for the other hooks we're using today).
    Now, while we could switch to bpf_link as well and implement it in iproute2
    for this specific case, what if someone else starting up earlier and locks
    our stuff out? How would we work around it?

  - Assuming we have XDP with bpf_link in place with the above, now applications
    are forced to start using bpf_link in order to not be locked out by others
    using bpf_link as otherwise their application would break. So they need to
    support the "old" way of attaching programs as we have today for older
    kernels and need to support the bpf_link attachment for newer kernels since
    they cannot rely on the old / existing API anymore. There is also a world
    outside of C/C++ and thus libbpf / lib{xdp,dispatcher} or whatever, so the
    whole rest of the ecosystem is forced to implement it as well due to breakage
    concerns, understandable, but quite a burden.

  - Equally, in case of Toke's implementation for the cmpxchg-like mechanism in
    XDP itself, what happens if an application uses this API and assuming the
    library would return the error to the application using it if the expected
    program is not attached? Then the application would go for a forceful override
    with the existing API today or would it voluntarily bail out and refusing to
    work if some other non-cooperating application was loaded in the meantime?
    What is the cmpxchg-like mechanism then solving realistically? (And again,
    please keep all in mind we cannot force the entire world to use one single
    library to rule 'em all, there are plenty of other language runtimes out in
    the wild that cannot just import C/C++.)

Thoughts?

Thanks,
Daniel
