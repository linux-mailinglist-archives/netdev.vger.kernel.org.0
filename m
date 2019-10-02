Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A904EC9223
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 21:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbfJBTP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 15:15:27 -0400
Received: from www62.your-server.de ([213.133.104.62]:52982 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfJBTP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 15:15:27 -0400
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iFk5r-00087x-0e; Wed, 02 Oct 2019 21:15:23 +0200
Date:   Wed, 2 Oct 2019 21:15:22 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
Message-ID: <20191002191522.GA9196@pc-66.home>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
 <5d94d3c5a238f_22502b00ea21a5b4e9@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5d94d3c5a238f_22502b00ea21a5b4e9@john-XPS-13-9370.notmuch>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25590/Wed Oct  2 10:31:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 09:43:49AM -0700, John Fastabend wrote:
> Toke Høiland-Jørgensen wrote:
> > This series adds support for executing multiple XDP programs on a single
> > interface in sequence, through the use of chain calls, as discussed at the Linux
> > Plumbers Conference last month:
> > 
> > https://linuxplumbersconf.org/event/4/contributions/460/
> > 
> > # HIGH-LEVEL IDEA
> > 
> > The basic idea is to express the chain call sequence through a special map type,
> > which contains a mapping from a (program, return code) tuple to another program
> > to run in next in the sequence. Userspace can populate this map to express
> > arbitrary call sequences, and update the sequence by updating or replacing the
> > map.
> > 
> > The actual execution of the program sequence is done in bpf_prog_run_xdp(),
> > which will lookup the chain sequence map, and if found, will loop through calls
> > to BPF_PROG_RUN, looking up the next XDP program in the sequence based on the
> > previous program ID and return code.
> > 
> > An XDP chain call map can be installed on an interface by means of a new netlink
> > attribute containing an fd pointing to a chain call map. This can be supplied
> > along with the XDP prog fd, so that a chain map is always installed together
> > with an XDP program.
> > 
> > # PERFORMANCE
> > 
> > I performed a simple performance test to get an initial feel for the overhead of
> > the chain call mechanism. This test consists of running only two programs in
> > sequence: One that returns XDP_PASS and another that returns XDP_DROP. I then
> > measure the drop PPS performance and compare it to a baseline of just a single
> > program that only returns XDP_DROP.
> > 
> > For comparison, a test case that uses regular eBPF tail calls to sequence two
> > programs together is also included. Finally, because 'perf' showed that the
> > hashmap lookup was the largest single source of overhead, I also added a test
> > case where I removed the jhash() call from the hashmap code, and just use the
> > u32 key directly as an index into the hash bucket structure.
> > 
> > The performance for these different cases is as follows (with retpolines disabled):
> 
> retpolines enabled would also be interesting.
> 
> > 
> > | Test case                       | Perf      | Add. overhead | Total overhead |
> > |---------------------------------+-----------+---------------+----------------|
> > | Before patch (XDP DROP program) | 31.0 Mpps |               |                |
> > | After patch (XDP DROP program)  | 28.9 Mpps |        2.3 ns |         2.3 ns |
> 
> IMO even 1 Mpps overhead is too much for a feature that is primarily about
> ease of use. Sacrificing performance to make userland a bit easier is hard
> to justify for me when XDP _is_ singularly about performance. Also that is
> nearly 10% overhead which is fairly large. So I think going forward the
> performance gab needs to be removed.

Fully agree, for the case where this facility is not used, it must have
*zero* overhead. This is /one/ map flavor, in future there will be other
facilities with different use-cases, but we cannot place them all into
the critical fast-path. Given this is BPF, we have the flexibility that
this can be hidden behind the scenes by rewriting and therefore only add
overhead when used.

What I also see as a red flag with this proposal is the fact that it's
tied to XDP only because you need to go and hack bpf_prog_run_xdp() all
the way to fetch xdp->rxq->dev->xdp_chain_map even though the map/concept
itself is rather generic and could be used in various other program types
as well. I'm very sure that once there, people would request it. Therefore,
better to explore a way where this has no changes to BPF_PROG_RUN() similar
to the original tail call work.

Thanks,
Daniel
