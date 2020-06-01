Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D2B1EA15C
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 11:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgFAJzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 05:55:50 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:40576 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725788AbgFAJzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 05:55:50 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 07D3F2005D;
        Mon,  1 Jun 2020 09:55:49 +0000 (UTC)
Received: from us4-mdac16-42.at1.mdlocal (unknown [10.110.48.13])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 06CEE6009B;
        Mon,  1 Jun 2020 09:55:49 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.74])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A4FE522004D;
        Mon,  1 Jun 2020 09:55:48 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4CB7F80057;
        Mon,  1 Jun 2020 09:55:48 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 1 Jun 2020
 10:55:42 +0100
Subject: Re: Self-XORing BPF registers is undefined behavior
To:     Alexander Potapenko <glider@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
 <984adc13-568e-8195-da1a-05135dbf954f@solarflare.com>
 <CAG_fn=WaYz5LOyuteF5LAkgFbj8cpgNQyO1ReORTAiCbyGuNQg@mail.gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <38ff5e15-bf76-2d17-f524-3f943a5b8846@solarflare.com>
Date:   Mon, 1 Jun 2020 10:55:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAG_fn=WaYz5LOyuteF5LAkgFbj8cpgNQyO1ReORTAiCbyGuNQg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25454.003
X-TM-AS-Result: No-9.019900-8.000000-10
X-TMASE-MatchedRID: ZFzIhWOuIzui6/VcDv9f0PZvT2zYoYOwG6odZCRpLs5XPwnnY5XL5Bcg
        f92QaXEShRRldM2EkSIQDOMhqHdmS05csqHFIwUsvoQkZKo949PJbE9r9HBJTxERaA/AH4sB8f4
        StkBOa36INaJh9K9P9wlzvpzzhhC08SVv8xCiJrNwyzIdDi4qeW5yFOrknm709J5avMd3ezCF77
        Xmf2kukQLrJJO0aKiv6f0L2aPn51ZUHLGrNupy0LqImyaR0axZPMuGpPQp42IvZMKeu0TTLmIRk
        v1upbB1U9iK89cSKSZz3XpEzHpm6GRZzgS9bzWm2Hlwa3CYC+ROxMIe1e/Q+koMHl9co6FPIKRp
        iQCnYZtQ7UITb6y48KubcZavso080YRMm/X9bI7iHyvyXeXh5kGaUEX8gnR8UCgEErrUGFyuj0J
        y+ME+CMvPFrDK8ALPASCDW/oEDKsCGzGrFhfo/5qvoi7RQmPS9CFB7klVg4cPlzJSBZBv1ZbpQa
        HHtPdIywnaZU36rmahc6fyRk2v4AQo4A1h6rQazzXLbf/3GoK/yN2q8U674qRv/dgbfAdqo8WMk
        QWv6iUD0yuKrQIMCD3Al4zalJpFec3QM3secWYICqx+TdvBIrJayrxHR5FmVuo5nDYhNnsOr0zI
        1dMxAwmw6tYtHMFhlExlQIQeRG0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.019900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25454.003
X-MDID: 1591005349-SdWkc4O3ToFK
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/05/2020 13:28, Alexander Potapenko wrote:> If the performance is really critical here, perhaps a better
> alternative is to introduce a BPF instruction (which could be an alias
> of BPF_XOR REG, REG) for zeroing out a register? Then different
> architectures may choose more efficient implementations for it, and
> the interpreter will be just assigning zero to the register without
> violating the C standard.If it's an alias of BPF_XOR r,r, then the interpreter will surely still
 interpret it with the XOR code.  Unless you make the interpreter
 special-case this, in which case you've added an extra branch to every
 XOR the interpreter handles :(

> Given the increased popularity of Clang in the kernel these days, I
> don't think it's a good idea for a single compiler to further diverge
> from the standard.The standard in question isn't C89, but "--std=gnu89", which is
 whatever GCC says it is :grin:
So if GCC declares that some class of optimisations are not legal under
 --std=gnu89, then they're not legal and Clang has to adapt to that.

> I wouldn't call this particular use case "extremely annoying".
To be clear, what's "annoying" is the double-bind we're in as a result
 of trying to optimise the prologue for both JITs (whose semantics are
 whatever we define eBPF to be) and the interpreter (which has to be
 implemented with reasonable efficiency as C code).

> If I understand correctly, these two instructions are only executed
> once per program.
> Are they really expected to impact performance that much?
If you have a very short program that's bound to a very frequent event,
 then they might.  But I don't have, and haven't seen, any numbers...

> I don't have evidence that such a transformation is currently possible
> for the BPF code in question, but all the building blocks are there,
> so it's probably just a matter of time.
I'm not so sure.  Consider the following sequence of BPF instructions:
    xor r0, r0
    ld r0, 42
    xor r0, r0
    exit
I hope you'll agree that at entry to the second XOR, the value of r0 is
 not indeterminate.  So any optimisation the compiler does for the first
 XOR ("oh, we don't need to fill the existing regs[] values, we can just
 use whatever's already in whichever register we allocate") will need to
 be predicated on something that makes it only happen for the first XOR.
But the place it's doing this optimisation is in the interpreter, which
 is a big fetch-execute loop.  I don't think even Clang is smart enough
 to figure out "BPF programs always start with a prologue, I'll stick in
 something that knows which prologue the prog uses and branches to a
 statically compiled, optimised version thereof".
(If Clang *is* that smart, then it's too clever by half...)

-ed
