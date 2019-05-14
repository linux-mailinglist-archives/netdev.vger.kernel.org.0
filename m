Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 687CF1C442
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 09:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfENH7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 03:59:08 -0400
Received: from www62.your-server.de ([213.133.104.62]:53778 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfENH7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 03:59:08 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hQSL1-0002k6-Hz; Tue, 14 May 2019 09:59:03 +0200
Received: from [178.199.41.31] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hQSL1-000Xav-C8; Tue, 14 May 2019 09:59:03 +0200
Subject: Re: [PATCH bpf 1/3] bpf: add map_lookup_elem_sys_only for lookups
 from syscall side
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        bpf@vger.kernel.org, Networking <netdev@vger.kernel.org>
References: <cover.1557789256.git.daniel@iogearbox.net>
 <505e5dfeea6ab7dd3719bb9863fc50e7595e06ed.1557789256.git.daniel@iogearbox.net>
 <CAEf4BzZc_8FfHKA0rEvgx8T0xRWQp-2scm1N+nwroXi5enDh_g@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <76dde419-7204-0aa0-3251-f52c2c15be85@iogearbox.net>
Date:   Tue, 14 May 2019 09:59:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZc_8FfHKA0rEvgx8T0xRWQp-2scm1N+nwroXi5enDh_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25448/Mon May 13 09:57:34 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/14/2019 07:04 AM, Andrii Nakryiko wrote:
> On Mon, May 13, 2019 at 4:20 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> Add a callback map_lookup_elem_sys_only() that map implementations
>> could use over map_lookup_elem() from system call side in case the
>> map implementation needs to handle the latter differently than from
>> the BPF data path. If map_lookup_elem_sys_only() is set, this will
>> be preferred pick for map lookups out of user space. This hook is
> 
> This is kind of surprising behavior  w/ preferred vs default lookup
> code path. Why the desired behavior can't be achieved with an extra
> flag, similar to BPF_F_LOCK? It seems like it will be more explicit,
> more extensible and more generic approach, avoiding duplication of
> lookup semantics.

For lookup from syscall side, this is possible of course. Given the
current situation breaks heuristic with any walks of the LRU map, I
presume you are saying something like an opt-in flag such as
BPF_F_MARK_USED would be more useful? I was thinking about something
like this initially, but then I couldn't come up with a concrete use
case where it's needed/useful today for user space. Given that, my
preference was to only add such flag wait until there is an actual
need for it, and in any case, it is trivial to add it later on. Do
you have a concrete need for it today that would justify such flag?

> E.g., for LRU map, with flag on lookup, one can decide whether lookup
> from inside BPF program (not just from syscall side!) should modify
> LRU ordering or not, simply by specifying extra flag. Am I missing
> some complication that prevents us from doing it that way?

For programs it's a bit tricky. The BPF call interface is ...

  BPF_CALL_2(bpf_map_lookup_elem, struct bpf_map *, map, void *, key)

... meaning verifier does not care what argument 3 and beyond contains.
From BPF context/pov, it could also be uninitialized register. This would
mean, we'd need to add a BPF_CALL_3(bpf_map_lookup_elem2, ...) interface
which programs would use instead (and to not break existing ones), or
some other new helper call that gets a map value argument to unmark the
element from LRU side. While all doable one way or another although bit
hacky, we should probably clarify and understand the use case for it
first, thus brings me back to the last question from above paragraph.

Thanks,
Daniel
