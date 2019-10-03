Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D4AC9928
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 09:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbfJCHs2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Oct 2019 03:48:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51568 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbfJCHs1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 03:48:27 -0400
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com [209.85.208.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D046B88309
        for <netdev@vger.kernel.org>; Thu,  3 Oct 2019 07:48:26 +0000 (UTC)
Received: by mail-lj1-f197.google.com with SMTP id y28so570228ljn.2
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 00:48:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=6PnWrQYlOfNUBU+0gyRB97YJLfhbOToGAsduT3RsUT8=;
        b=oRchB8HJj6h4t6ef9evOE+EZ/ZItrdkPkRMJeFCVS9i1LbKPXZue3TJTQnfEaWfDbK
         d2/hs5Aun1EvmKeXfOJjSSScHOXypvMyE0m8+kviTBwt/XWyvVNKVrskXlvCRdpEYtpv
         DzG2G/gPgrO4IJ6oJeI5D9n7OaGKuv5+7B5WoA+a3x2fJZgm7Z0o/AoV5rU+ED7CcBiL
         n5aRTBsRZL4J39Cbf5RtrU2eilpZl27CVRED18dlp/2osU0Upse5miRpXmOFweWxqYFZ
         mFOL1fcWZnZQMvHDTJwILskY9fzwua+8ABR1aXZTOQc4AHCdA5TnjfpMyM0us4WkMWcx
         Erow==
X-Gm-Message-State: APjAAAWfCxEaJejyo8sWp0x1DBBOd9Ly10yXv7s4Bm+zUbAl/YZ/jkOa
        qgHnGaX3k6n9ggMRyY5v2bGlCKtKnsMjH/iE9RyskLAfJmZBYdSWyZlcncbfwrePeMsLEHnTmKE
        M5SHff11XiXW8C1eI
X-Received: by 2002:ac2:50c5:: with SMTP id h5mr4922020lfm.105.1570088905268;
        Thu, 03 Oct 2019 00:48:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx5WH3Yg+DVyr/OkOYxjqzRekSDaPkJqYT7a0NrWYEsO0p4JdKlfEb6qW0oH1RmRvd4WCJ0gg==
X-Received: by 2002:ac2:50c5:: with SMTP id h5mr4922000lfm.105.1570088904963;
        Thu, 03 Oct 2019 00:48:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id r75sm278319lff.7.2019.10.03.00.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 00:48:23 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C6F7718063D; Thu,  3 Oct 2019 09:48:22 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single interface through chain calls
In-Reply-To: <5d9509de4acb6_32c02ab4bb3b05c052@john-XPS-13-9370.notmuch>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1> <alpine.LRH.2.20.1910021540270.24629@dhcp-10-175-191-98.vpn.oracle.com> <87bluzrwks.fsf@toke.dk> <5d94d188e4cca_22502b00ea21a5b425@john-XPS-13-9370.notmuch> <8736gbro8x.fsf@toke.dk> <5d9509de4acb6_32c02ab4bb3b05c052@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 03 Oct 2019 09:48:22 +0200
Message-ID: <87ftkaqng9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Toke Høiland-Jørgensen wrote:
>> John Fastabend <john.fastabend@gmail.com> writes:
>> 
>> > Toke Høiland-Jørgensen wrote:
>> >> Alan Maguire <alan.maguire@oracle.com> writes:
>> >> 
>> >> > On Wed, 2 Oct 2019, Toke Høiland-Jørgensen wrote:
>> >> >
>> >> >> This series adds support for executing multiple XDP programs on a single
>> >> >> interface in sequence, through the use of chain calls, as discussed at the Linux
>> >> >> Plumbers Conference last month:
>> >> >> 
>> >> >> https://linuxplumbersconf.org/event/4/contributions/460/
>> >> >> 
>> >> >> # HIGH-LEVEL IDEA
>> >> >> 
>> >> >> The basic idea is to express the chain call sequence through a special map type,
>> >> >> which contains a mapping from a (program, return code) tuple to another program
>> >> >> to run in next in the sequence. Userspace can populate this map to express
>> >> >> arbitrary call sequences, and update the sequence by updating or replacing the
>> >> >> map.
>> >> >> 
>> >> >> The actual execution of the program sequence is done in bpf_prog_run_xdp(),
>> >> >> which will lookup the chain sequence map, and if found, will loop through calls
>> >> >> to BPF_PROG_RUN, looking up the next XDP program in the sequence based on the
>> >> >> previous program ID and return code.
>> >> >> 
>> >> >> An XDP chain call map can be installed on an interface by means of a new netlink
>> >> >> attribute containing an fd pointing to a chain call map. This can be supplied
>> >> >> along with the XDP prog fd, so that a chain map is always installed together
>> >> >> with an XDP program.
>> >> >> 
>> >> >
>> >> > This is great stuff Toke!
>> >> 
>> >> Thanks! :)
>> >> 
>> >> > One thing that wasn't immediately clear to me - and this may be just
>> >> > me - is the relationship between program behaviour for the XDP_DROP
>> >> > case and chain call execution. My initial thought was that a program
>> >> > in the chain XDP_DROP'ping the packet would terminate the call chain,
>> >> > but on looking at patch #4 it seems that the only way the call chain
>> >> > execution is terminated is if
>> >> >
>> >> > - XDP_ABORTED is returned from a program in the call chain; or
>> >> 
>> >> Yes. Not actually sure about this one...
>> >> 
>> >> > - the map entry for the next program (determined by the return value
>> >> >   of the current program) is empty; or
>> >> 
>> >> This will be the common exit condition, I expect
>> >> 
>> >> > - we run out of entries in the map
>> >> 
>> >> You mean if we run the iteration counter to zero, right?
>> >> 
>> >> > The return value of the last-executed program in the chain seems to be
>> >> > what determines packet processing behaviour after executing the chain
>> >> > (_DROP, _TX, _PASS, etc). So there's no way to both XDP_PASS and
>> >> > XDP_TX a packet from the same chain, right? Just want to make sure
>> >> > I've got the semantics correct. Thanks!
>> >> 
>> >> Yeah, you've got all this right. The chain call mechanism itself doesn't
>> >> change any of the underlying fundamentals of XDP. I.e., each packet gets
>> >> exactly one verdict.
>> >> 
>> >> For chaining actual XDP programs that do different things to the packet,
>> >> I expect that the most common use case will be to only run the next
>> >> program if the previous one returns XDP_PASS. That will make the most
>> >> semantic sense I think.
>> >> 
>> >> But there are also use cases where one would want to match on the other
>> >> return codes; such as packet capture, for instance, where one might
>> >> install a capture program that would carry forward the previous return
>> >> code, but do something to the packet (throw it out to userspace) first.
>> >> 
>> >> For the latter use case, the question is if we need to expose the
>> >> previous return code to the program when it runs. You can do things
>> >> without it (by just using a different program per return code), but it
>> >> may simplify things if we just expose the return code. However, since
>> >> this will also change the semantics for running programs, I decided to
>> >> leave that off for now.
>> >> 
>> >> -Toke
>> >
>> > In other cases where programs (e.g. cgroups) are run in an array the
>> > return codes are 'AND'ed together so that we get
>> >
>> >    result1 & result2 & ... & resultN
>> 
>> How would that work with multiple programs, though? PASS -> DROP seems
>> obvious, but what if the first program returns TX? Also, programs may
>> want to be able to actually override return codes (e.g., say you want to
>> turn DROPs into REDIRECTs, to get all your dropped packets mirrored to
>> your IDS or something).
>
> In general I think either you hard code a precedence that will have to
> be overly conservative because if one program (your firewall) tells
> XDP to drop the packet and some other program redirects it, passes,
> etc. that seems incorrect to me. Or you get creative with the
> precedence rules and they become complex and difficult to manage,
> where a drop will drop a packet unless a previous/preceding program
> redirects it, etc. I think any hard coded precedence you come up with
> will make some one happy and some other user annoyed. Defeating the
> programability of BPF.

Yeah, exactly. That's basically why I punted on that completely.
Besides, technically you can get this by just installing different
programs in each slot if you really need it.

> Better if its programmable. I would prefer to pass the context into
> the next program then programs can build their own semantics. Then
> leave the & of return codes so any program can if needed really drop a
> packet. The context could be pushed into a shared memory region and
> then it doesn't even need to be part of the program signature.

Since it seems I'll be going down the rabbit hole of baking this into
the BPF execution environment itself, I guess I'll keep this in mind as
well. Either by stuffing the previous program return code into the
context object(s), or by adding a new helper to retrieve it.

-Toke
