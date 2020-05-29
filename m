Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A971E78A6
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 10:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgE2Iqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 04:46:38 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:46648 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725839AbgE2Iqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 04:46:36 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 365C060066;
        Fri, 29 May 2020 08:46:35 +0000 (UTC)
Received: from us4-mdac16-39.ut7.mdlocal (unknown [10.7.66.158])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 35B5F2009B;
        Fri, 29 May 2020 08:46:35 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.30])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id B5CF822004D;
        Fri, 29 May 2020 08:46:34 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 13AB210006E;
        Fri, 29 May 2020 08:46:34 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 29 May
 2020 09:46:27 +0100
Subject: Re: Self-XORing BPF registers is undefined behavior
To:     Dmitry Vyukov <dvyukov@google.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Alexei Starovoitov <ast@kernel.org>,
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
 <CACT4Y+bZjRL7LoDhXUrcGWNBYzEWQEq0Mbpzqj6+cP_0nDGWGg@mail.gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <69a77196-60c6-6cc4-abb9-6190b7c016dc@solarflare.com>
Date:   Fri, 29 May 2020 09:46:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CACT4Y+bZjRL7LoDhXUrcGWNBYzEWQEq0Mbpzqj6+cP_0nDGWGg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25448.003
X-TM-AS-Result: No-0.659900-8.000000-10
X-TMASE-MatchedRID: QW5G6BKkLTqi6/VcDv9f0PZvT2zYoYOwC/ExpXrHizzS/WJ8Di9LYFjI
        snt2Li6f2ChWr4JjwTuJCSKVhMe8ngzlYmrmgdLZaPXXRVSBBouL/MoUdwG/+16ZbCgJcOP1JUK
        ZO8NXb6dWCrmeAG4vkP1fmehio0kXwSswT6PeobmUa50su1E7W7WTdtEh1dU059+u3D1NguFaxf
        pRZItmqOanbitNdkj+aaU3u4BvRjvJA/luV7jbJiXTnAZkhKfly3fMd7pCml6UvAdK8y+U5Eg9o
        IEl5+XgdpLKeOzuT+m6Q4MH+Gn+Kb9ZdlL8eonaC24oEZ6SpSmb4wHqRpnaDgcAO+hRKc9u9G/k
        NEVjYQeUY2Ocg6T/O8dbG2/FWNCnF8GH8icLnpNGVSenKsFFYBgjtXbOsKxvJlYrwDNsKdKzwRj
        gb1g4XIfMZMegLDIeGU0pKnas+RbnCJftFZkZizYJYNFU00e7N+XOQZygrvY=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.659900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25448.003
X-MDID: 1590741995-Tm0rVFScejBL
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/05/2020 07:14, Dmitry Vyukov wrote:
>> (In C99 it gets subtler because an 'indeterminate value' is
>>  defined to be 'either a valid value or a trap representation',
>>  so arguably the compiler can only do this stuff if it _has_
>>  trap representations for the type in question.)
> Interesting. Are you sure that's the meaning of 'indeterminate value'?
> My latest copy of the standard says:
>
> 3.19.2
> 1 indeterminate value
> either an unspecified value or a trap representation
Yes, but (from N1256):
| 3.17.3
| unspecified value
| valid value of the relevant type where this International Standard
| imposes no requirements on which value is chosen in any instance
| NOTE An unspecified value cannot be a trap representation

> My reading of this would be that this only prevents things from
> exploding in all possible random ways (like formatting drive). The
> effects are only reduced to either getting a random value, or a trap
> on access to the value. Both of these do not seem to be acceptable for
> a bpf program.
A random value, XORed with itself, produces 0, which is what we want.
(XORing a trap representation with itself, of course, produces a trap.)

So it'd be fine *unless* the 'in any instance' language can be read as
 allowing the uninitialised object to have *different* random values on
 separate accesses.

-ed
