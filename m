Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDCFDC9131
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 20:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbfJBSyh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Oct 2019 14:54:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728905AbfJBSyh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 14:54:37 -0400
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 28CFDC058CB8
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 18:54:36 +0000 (UTC)
Received: by mail-lj1-f198.google.com with SMTP id 5so71246lje.12
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 11:54:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=tZ76WLJTc2djGr7zvzNnwDyy9+JtFDIfybMW/NsEPPI=;
        b=gtlMsK7W8Jzwyycp8EP13ctuB6BzDgGSLEKL0dTj+QGOoMqOVW947G7zqoAtLn7t5G
         P2kSuctQ45+1IBn5mVe8L4HHEMMtmtNkxru3MZSt8Lv8rOz3mG/x0dcu7ZKtfDAtMXHQ
         R6Mw/xSP8XqSo2vCaI5VBtqXoGimXVUz0yIFgFemnuUMm37TjDNaaCz5K+eQyQsSmqHY
         LDgQALtnnZ7kRRqADdolBXc33KJA1KY5X3xHE5J8scMKpZ7yGg7fb+QrgWBDc2/fWzOD
         QTBfgFf9/gTd5EV706XN/G20ftDGXZIkcc3AhdpaM2/4Xomk31rNUCUtetwo8I2J6FNR
         V38w==
X-Gm-Message-State: APjAAAV04XFkBbJ5lV95RR1PukrWIuFB2+fmTt1e3CZhhNZ8XONmdjHi
        mXWxAEPlF+A96zVo43QOh4l31xOOW8TLJqQfZg3X5IVmPJGYEECGF6b9K95M+43EfaEyDneoPEr
        oGcpuEG3SHIM6WeY3
X-Received: by 2002:ac2:418c:: with SMTP id z12mr3379835lfh.183.1570042474591;
        Wed, 02 Oct 2019 11:54:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxhLdL2yy2vl7flCph33FWSO3Bpo+wb+J33SiWtAxgIomr8wmqJDK023/wH22APnPqqxVa5bw==
X-Received: by 2002:ac2:418c:: with SMTP id z12mr3379822lfh.183.1570042474293;
        Wed, 02 Oct 2019 11:54:34 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id t24sm4744347lfq.13.2019.10.02.11.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 11:54:33 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D0FAB18063D; Wed,  2 Oct 2019 20:54:31 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single interface through chain calls
In-Reply-To: <CACAyw9860eDGU9meO0wQ82OgWNPv3LXAQqrJNf-mQFA0yu7rWQ@mail.gmail.com>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1> <CACAyw9860eDGU9meO0wQ82OgWNPv3LXAQqrJNf-mQFA0yu7rWQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 02 Oct 2019 20:54:31 +0200
Message-ID: <87zhijq8pk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenz Bauer <lmb@cloudflare.com> writes:

> On Wed, 2 Oct 2019 at 14:30, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> This series adds support for executing multiple XDP programs on a single
>> interface in sequence, through the use of chain calls, as discussed at the Linux
>> Plumbers Conference last month:
>
> Hi Toke,
>
> Thanks for posting the patch set! As I mentioned, this is a big pain
> point for us as well. Right now, all of our different XDP components
> are managed by a single daemon called (drumroll) xdpd. We'd like to
> separate this out into individual bits and pieces that operate
> separately from each other.

Yes, I'm counting on you guys to be one of the potential users and help
me iron out the API and semantics! ;)

> I've looked at the kernel side of your patch set, here are my thoughts:
>
>> # HIGH-LEVEL IDEA
>>
>> The basic idea is to express the chain call sequence through a special map type,
>> which contains a mapping from a (program, return code) tuple to another program
>> to run in next in the sequence. Userspace can populate this map to express
>> arbitrary call sequences, and update the sequence by updating or replacing the
>> map.
>
> How do you imagine this would work in practice? From what I can tell,
> the map is keyed by program id, which makes it difficult to reliably
> construct the control flow that I want.

The way I've been picturing this would work, is that programs would
cooperatively manage this by updating the data structures to insert and
remove themselves as needed. I haven't actually fleshed out this in code
yet (that's next on my agenda), but I imagine it would be something like
this:

> As an example, I'd like to split the daemon into two parts, A and B,
> which I want to be completely independent. So:
>
> - A runs before B, if both are active
> - If A is not active, B is called first
> - If B is not active, only A is called
>
> Both A and B may at any point in time replace their current XDP
> program with a new one. This means that there is no stable program ID
> I can use.

They would have to cooperate. Either by a central management daemon, or
by using the chain call map as a data structure to coordinate.

If A switches out its program, it would need to first load the new
version, then update the map to replace the old ID with the new one.

> Another problem are deletions: if I delete A (because that component
> is shut down) B will never be called, since the program ID that linked
> B into the control flow is gone. This means that B needs to know about
> A and vice versa.

Say both programs are running. If B shuts down, it just removes itself
from the map. If A shuts down, it also needs to remove itself from the
map, and move up all its "descendants" in the call sequence. So in this
case, A would look up itself in the chain call map, find the next
program in the sequence, and install that as the new program on the
interface.

The operations are kinda like linked list manipulations. I had some
examples in my slides at LPC:

- Simple updates: *linked-list like* operations (map stays the same)
# Insert after id 3
  --> id = load(prog.o);
  --> map_update(map, {3, PASS}, id) # atomic update
# Insert before id 2
  --> id = load(prog.o);
  --> map_update(map, {id, PASS}, 2); # no effect on chain sequence
  --> map_update(map, {1, PASS}, id); # atomic update

- More complex operations: /*replace the whole thing*/

# Replace ID 3 with new program
  --> id = load(prog.o); map = new_map();
  --> map_update(map, {1, PASS}, 2);
  --> map_update(map, {1, TX}, id);
  --> map_update(map, {2, PASS}, id);
  --> xdp_attach(eth0, 1, map, FORCE); # atomic replace


The tricky part is avoiding read-modify-update races. I was imagining
that we could provide "cmpxchg-like" semantics by adding an "expected
old value" to the netlink load and/or to map updates. The kernel could
then ensure that the update fails if the actual value being replaced has
changed since userspace read it, in which case userspace could retry the
whole operation.

>> The actual execution of the program sequence is done in
>> bpf_prog_run_xdp(), which will lookup the chain sequence map, and if
>> found, will loop through calls to BPF_PROG_RUN, looking up the next
>> XDP program in the sequence based on the previous program ID and
>> return code.
>
> I think that the tail call chain is useful for other eBPF programs as
> well. How hard is it to turn the logic in bpf_prog_run_xdp into a
> helper instead?

Heh. In principle, I guess we could move the logic *into* BPF_PROG_RUN
instead of wrapping around it. The tricky part would be figuring out
where to stash the map itself.

One way to do this, which your other question about why both prog fd and
map fd was needed made me think about, is to make programs and sequence
maps interchangeable *everywhere*. I.e., every time we attach an eBPF
program anywhere, we pass an fd to that program. So from a UAPI PoV, we
could just extend that so all attach points would accept *either* a
program fd *or* a chain call map fd, and then do the appropriate thing.
This is quite intrusive, though, so let's leave that aside from now and
maybe come back to it in the future if this turns out to be a huge
success :)

-Toke
