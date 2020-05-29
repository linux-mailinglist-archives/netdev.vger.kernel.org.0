Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5726E1E7130
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437986AbgE2ARW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:17:22 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:36658 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437963AbgE2ART (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 20:17:19 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3C4A960092;
        Fri, 29 May 2020 00:17:17 +0000 (UTC)
Received: from us4-mdac16-21.ut7.mdlocal (unknown [10.7.65.245])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 399D72009A;
        Fri, 29 May 2020 00:17:17 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.38])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9A8C21C0054;
        Fri, 29 May 2020 00:17:16 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 006C7800059;
        Fri, 29 May 2020 00:17:15 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 29 May
 2020 01:17:06 +0100
Subject: Re: Self-XORing BPF registers is undefined behavior
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexander Potapenko <glider@google.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Alexei Starovoitov <ast@kernel.org>,
        Dmitriy Vyukov <dvyukov@google.com>,
        Networking <netdev@vger.kernel.org>
References: <CAG_fn=W55uuPbpvjzCphgiMbmhnFmmWY=KcOGvmUv14_JOGc5g@mail.gmail.com>
 <20181213115936.GG21324@unicorn.suse.cz>
 <20181213122004.GH21324@unicorn.suse.cz>
 <CAG_fn=VSEw2NvrE=GE4f4H6CAD-6BjUQvz3W06nLmF8tg7CfBA@mail.gmail.com>
 <def5d586-3a8c-01b7-c6dd-bc284336b76e@iogearbox.net>
 <7bf9e46f-93a1-b6ff-7e75-53ace009c77c@iogearbox.net>
 <CAG_fn=WrWLC7v8btiZfRSSj1Oj6WymLmwWq4x1Ss3rQ4P0cOOA@mail.gmail.com>
 <CAG_fn=W_BCW5OvP2tayQLcrTuiXCXDBYDYSJ7U6xHftDFyLu3A@mail.gmail.com>
 <CAADnVQ+GFuDkx+xW42wL60=W4bz5C8Q-pNNP+f2txy_hY-TeUA@mail.gmail.com>
 <CAG_fn=WfQ4KG5FCwYQPbHX6PJ1f8wvJYq+Q9fBugyCbMBdiB6Q@mail.gmail.com>
 <CAADnVQLxnjrnxFhXEKDaXBgVZeRauAr8F4N+ZwuKdTnONUkt7A@mail.gmail.com>
 <CAG_fn=Uvp2HmqHUZqEHtAWj8dG4j5ifqbGFQ2A3Jzv10bf-b9Q@mail.gmail.com>
 <CAADnVQ+2eLKh-s34ciNue-Jt5yL1MrS=LL8Zjfo0gkUkk8dDug@mail.gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <984adc13-568e-8195-da1a-05135dbf954f@solarflare.com>
Date:   Fri, 29 May 2020 01:17:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+2eLKh-s34ciNue-Jt5yL1MrS=LL8Zjfo0gkUkk8dDug@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25448.003
X-TM-AS-Result: No-8.353700-8.000000-10
X-TMASE-MatchedRID: 0+daXaNUWRWi6/VcDv9f0PZvT2zYoYOwC/ExpXrHizxudVAdMeGPApGP
        Ti55UqEjSnuSB1sxZWzdpTkdfBwtt+/wE1BfYSjC5y1fRAwHJ4elAfiiC1VA/Xrjo3X9e+DHdvc
        uwUbHanknn0lSSZsa6JNlqmLdV1OFHYnnQdbx7N6jGOtqnkAZC6a83Mq89i9duM5RdaZDc5ZKBk
        HjBCgWt+fG7MmyoVqeU6WsjEEjHBHsAvc290pcYFSzRMNv1fRD9vodwxeGN6b/MiRbve4ADj2j/
        N8mMgrkNZ3UG53E2nhtrQLvnvZ+IABLiso5jLwzzfqlpbtmcWg4eGohd7gjNnc925yOJXmFsGNm
        tgd0rQLLMu+rJ+RXuno0/mi7Koa4v+jlkdqQeLaAO0kpgKezRCjjDAcGqVG+e8KwkFl1M+rhzOD
        Wjt9CFUS2i19a/fP2Pm6U9f6G6shkihO6QdpZxRSZHx/gc9XO+ahnrHhmAJQiQEhKTzbeclbTtJ
        pG9MBBJVehNbRd6yejkUEa+7Udavy/UcUhKtWiGUlF/M3Dxp9wJ5RNZmULo2PjNemES45Q0Nwi7
        z6Ud807OmRl4GvoS6v/WS1F162CjD7sSxTYb+MJuplsyNNdxxfbPFE2GHrV+S5C/08hWc10LF/2
        Oo5TiZwDOBhOnctrLb6XLHjqIvS+G6+qk5Nchp4CIKY/Hg3AtOt1ofVlaoLWRN8STJpl3PoLR4+
        zsDTthUfR2rvBju5pqcPCgG9H+q3Sa2eNXdbV4Rl82vBfK3NFAUqhkvwcz082HPyFp/WzwL6SxP
        pr1/I=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.353700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25448.003
X-MDID: 1590711437-FMo2h5rUNqC7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/05/2020 17:00, Alexei Starovoitov wrote:
> xoring of two identical values is undefined in standard?
I believe it is in this case, yes; even without the complication
 of array references that happen to alias, Alexander's foo1() is
 undefined behaviour under C89 (and also C99 which handles the
 case differently).

From the definitions section (1.6) of the C89 draft [1]:
> * Undefined behavior --- behavior, upon use of a nonportable or
> erroneous program construct, of erroneous data, or of
> indeterminately-valued objects, for which the Standard imposes
> no requirements.
And from 3.5.7 'Initialization':
> If an object that has automatic storage duration is not
> initialized explicitly, its value is indeterminate.
Since the standard doesn't say anything about self-XORing that
 could make it 'special' in this regard, the compiler isn't
 required to notice that it's a self-XOR, and (in the tradition
 of compiler-writers the world over) is entitled to optimise the
 program based on the assumption that the programmer has not
 committed UB, so in the foo1() example would be strictly within
 its rights to generate a binary that contained no XOR
 instruction at all.  UB, as you surely know, isn't guaranteed to
 do something 'sensible'.
And in the BPF example, if the compiler at some point manages to
 statically figure out that regs[insn->dst_reg] is uninitialised,
 it might say "hey, I can just grab any old free register and
 declare that that's now regs[insn->dst_reg] without filling it.
 And then it can do the same for regs[insn->src_reg], or heck,
 even choose to fill that one (this is now legal even though the
 pointers alias, because you already committed UB), and do a xor
 with different regs and produce garbage results.

(In C99 it gets subtler because an 'indeterminate value' is
 defined to be 'either a valid value or a trap representation',
 so arguably the compiler can only do this stuff if it _has_
 trap representations for the type in question.)

> If that's really true such standard worth nothing.
You may be right, but plenty of compiler writers will take that
 as a reason to ignore you, and if (say) a gcc upgrade breaks
 filter.c, they will merrily close any bugs you file as NOTABUG
 or INVALID or GOAWAYWEDONTCARE.
Is this annoying?  Extremely; the XOR-clearing _would_ be fine
 if the standard had chosen to define things differently (e.g.
 it's fine under a hypothetical 'C99 but uninitialised auto
 variables have unspecified rather than indeterminate values').
I can't see a way to work around it that doesn't have a possible
 performance cost (alternatives to Alexander's MOV_IMM 0 include
 initialising regs[BPF_REG_A] and regs[BPF_REG_X] in PROG_NAME
 and PROG_NAME_ARGS), although there is the question of whether
 anyone who cares about performance (or security) will be using
 BPF without the JIT anyway.
But I don't think "Alexandar has to do the data-flow analysis in
 KMSAN" is the right answer; KMSAN's diagnostic here is _correct_
 in that ___bpf_prog_run() invokes UB on this XOR.
Now, since it would be rather difficult and pointless for the
 compiler to statically prove that the reg is uninitialised (it
 would need to generate a special code-path just for this one
 case), maybe the best thing to do is to get GCC folks to bless
 this usage (perhaps defining uninitialised variables to have
 what C99 would call an unspecified value), at which point it
 becomes defined under the "gnu89" pseudo-standard which is what
 we compile the kernel with.  At which point KMSAN can be taught
 that this is OK, and can figure out "hey, you're self-XORing an
 unspecified value, the result is determinate" and clear the
 shadow bits appropriately.

-ed

[1]: https://port70.net/~nsz/c/c89/c89-draft.html
