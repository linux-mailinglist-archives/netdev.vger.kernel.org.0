Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 197F4C9BC9
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 12:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbfJCKJf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Oct 2019 06:09:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53440 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728624AbfJCKJe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 06:09:34 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1EAF618CB905;
        Thu,  3 Oct 2019 10:09:34 +0000 (UTC)
Received: from carbon (ovpn-200-24.brq.redhat.com [10.40.200.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A06C5C22C;
        Thu,  3 Oct 2019 10:09:24 +0000 (UTC)
Date:   Thu, 3 Oct 2019 12:09:23 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
Message-ID: <20191003120923.2a8ec190@carbon>
In-Reply-To: <87ftkaqng9.fsf@toke.dk>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
        <alpine.LRH.2.20.1910021540270.24629@dhcp-10-175-191-98.vpn.oracle.com>
        <87bluzrwks.fsf@toke.dk>
        <5d94d188e4cca_22502b00ea21a5b425@john-XPS-13-9370.notmuch>
        <8736gbro8x.fsf@toke.dk>
        <5d9509de4acb6_32c02ab4bb3b05c052@john-XPS-13-9370.notmuch>
        <87ftkaqng9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Thu, 03 Oct 2019 10:09:34 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 03 Oct 2019 09:48:22 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> John Fastabend <john.fastabend@gmail.com> writes:
> 
> > Toke Høiland-Jørgensen wrote:  
> >> John Fastabend <john.fastabend@gmail.com> writes:
> >>   
> >> > Toke Høiland-Jørgensen wrote:  
> >> >> Alan Maguire <alan.maguire@oracle.com> writes:
> >> >>   
> >> >> > On Wed, 2 Oct 2019, Toke Høiland-Jørgensen wrote:
> >> >> >  
> >> >> >> This series adds support for executing multiple XDP programs on a single
> >> >> >> interface in sequence, through the use of chain calls, as discussed at the Linux
> >> >> >> Plumbers Conference last month:
> >> >> >> 
> >> >> >> https://linuxplumbersconf.org/event/4/contributions/460/
> >> >> >> 
> >> >> >> # HIGH-LEVEL IDEA
> >> >> >> 
> >> >> >> The basic idea is to express the chain call sequence through a special map type,
> >> >> >> which contains a mapping from a (program, return code) tuple to another program
> >> >> >> to run in next in the sequence. Userspace can populate this map to express
> >> >> >> arbitrary call sequences, and update the sequence by updating or replacing the
> >> >> >> map.
> >> >> >> 
> >> >> >> The actual execution of the program sequence is done in bpf_prog_run_xdp(),
> >> >> >> which will lookup the chain sequence map, and if found, will loop through calls
> >> >> >> to BPF_PROG_RUN, looking up the next XDP program in the sequence based on the
> >> >> >> previous program ID and return code.
> >> >> >> 
> >> >> >> An XDP chain call map can be installed on an interface by means of a new netlink
> >> >> >> attribute containing an fd pointing to a chain call map. This can be supplied
> >> >> >> along with the XDP prog fd, so that a chain map is always installed together
> >> >> >> with an XDP program.
> >> >> >>   
> >> >> >
> >> >> > This is great stuff Toke!  
> >> >> 
> >> >> Thanks! :)
> >> >>   
> >> >> > One thing that wasn't immediately clear to me - and this may be just
> >> >> > me - is the relationship between program behaviour for the XDP_DROP
> >> >> > case and chain call execution. My initial thought was that a program
> >> >> > in the chain XDP_DROP'ping the packet would terminate the call chain,
> >> >> > but on looking at patch #4 it seems that the only way the call chain
> >> >> > execution is terminated is if
> >> >> >
> >> >> > - XDP_ABORTED is returned from a program in the call chain; or  
> >> >> 
> >> >> Yes. Not actually sure about this one...
> >> >>   
> >> >> > - the map entry for the next program (determined by the return value
> >> >> >   of the current program) is empty; or  
> >> >> 
> >> >> This will be the common exit condition, I expect
> >> >>   
> >> >> > - we run out of entries in the map  
> >> >> 
> >> >> You mean if we run the iteration counter to zero, right?
> >> >>   
> >> >> > The return value of the last-executed program in the chain seems to be
> >> >> > what determines packet processing behaviour after executing the chain
> >> >> > (_DROP, _TX, _PASS, etc). So there's no way to both XDP_PASS and
> >> >> > XDP_TX a packet from the same chain, right? Just want to make sure
> >> >> > I've got the semantics correct. Thanks!  
> >> >> 
> >> >> Yeah, you've got all this right. The chain call mechanism itself doesn't
> >> >> change any of the underlying fundamentals of XDP. I.e., each packet gets
> >> >> exactly one verdict.
> >> >> 
> >> >> For chaining actual XDP programs that do different things to the packet,
> >> >> I expect that the most common use case will be to only run the next
> >> >> program if the previous one returns XDP_PASS. That will make the most
> >> >> semantic sense I think.
> >> >> 
> >> >> But there are also use cases where one would want to match on the other
> >> >> return codes; such as packet capture, for instance, where one might
> >> >> install a capture program that would carry forward the previous return
> >> >> code, but do something to the packet (throw it out to userspace) first.
> >> >> 
> >> >> For the latter use case, the question is if we need to expose the
> >> >> previous return code to the program when it runs. You can do things
> >> >> without it (by just using a different program per return code), but it
> >> >> may simplify things if we just expose the return code. However, since
> >> >> this will also change the semantics for running programs, I decided to
> >> >> leave that off for now.
> >> >> 
> >> >> -Toke  
> >> >
> >> > In other cases where programs (e.g. cgroups) are run in an array the
> >> > return codes are 'AND'ed together so that we get
> >> >
> >> >    result1 & result2 & ... & resultN  

But the XDP return codes are not bit values, so AND operation doesn't
make sense to me.

> >> 
> >> How would that work with multiple programs, though? PASS -> DROP seems
> >> obvious, but what if the first program returns TX? Also, programs may
> >> want to be able to actually override return codes (e.g., say you want to
> >> turn DROPs into REDIRECTs, to get all your dropped packets mirrored to
> >> your IDS or something).  
> >
> > In general I think either you hard code a precedence that will have to
> > be overly conservative because if one program (your firewall) tells
> > XDP to drop the packet and some other program redirects it, passes,
> > etc. that seems incorrect to me. Or you get creative with the
> > precedence rules and they become complex and difficult to manage,
> > where a drop will drop a packet unless a previous/preceding program
> > redirects it, etc. I think any hard coded precedence you come up with
> > will make some one happy and some other user annoyed. Defeating the
> > programability of BPF.  
> 
> Yeah, exactly. That's basically why I punted on that completely.
> Besides, technically you can get this by just installing different
> programs in each slot if you really need it.

I would really like to avoid hard coding precedence.  I know it is
"challenging" that we want to allow overruling any XDP return code, but
I think it makes sense and it is the most flexible solution.


> > Better if its programmable. I would prefer to pass the context into
> > the next program then programs can build their own semantics. Then
> > leave the & of return codes so any program can if needed really drop a
> > packet. The context could be pushed into a shared memory region and
> > then it doesn't even need to be part of the program signature.  
> 
> Since it seems I'll be going down the rabbit hole of baking this into
> the BPF execution environment itself, I guess I'll keep this in mind as
> well. Either by stuffing the previous program return code into the
> context object(s), or by adding a new helper to retrieve it.

I would like to see the ability to retrieve previous program return
code, and a new helper would be the simplest approach.  As this could
potentially simplify and compact the data-structure.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
