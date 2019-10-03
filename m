Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB28AC9A41
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 10:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbfJCIxq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Oct 2019 04:53:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47938 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727357AbfJCIxq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 04:53:46 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7320E3090FD7;
        Thu,  3 Oct 2019 08:53:45 +0000 (UTC)
Received: from carbon (ovpn-200-24.brq.redhat.com [10.40.200.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D4C85D6A9;
        Thu,  3 Oct 2019 08:53:36 +0000 (UTC)
Date:   Thu, 3 Oct 2019 10:53:35 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>, brouer@redhat.com
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
Message-ID: <20191003105335.3cc65226@carbon>
In-Reply-To: <87r23vq79z.fsf@toke.dk>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
        <E7319D69-6450-4BC3-97B1-134B420298FF@fb.com>
        <A754440E-07BF-4CF4-8F15-C41179DCECEF@fb.com>
        <87r23vq79z.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Thu, 03 Oct 2019 08:53:45 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 02 Oct 2019 21:25:28 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> Song Liu <songliubraving@fb.com> writes:
> 
> >> On Oct 2, 2019, at 11:38 AM, Song Liu <songliubraving@fb.com> wrote:
> >>   
> >>> On Oct 2, 2019, at 6:30 AM, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >>> 
> >>> This series adds support for executing multiple XDP programs on a single
> >>> interface in sequence, through the use of chain calls, as discussed at the Linux
> >>> Plumbers Conference last month:
> >>>

[1] https://linuxplumbersconf.org/event/4/contributions/460/
- [2] Slides: http://people.netfilter.org/hawk/presentations/LinuxPlumbers2019/xdp-distro-view.pdf
- [3] Source: https://github.com/xdp-project/xdp-project/tree/master/conference/LinuxPlumbers2019
 
[...]
> >
> > Also, could you please share a real word example? I saw the example
> > from LPC slides, but I am more curious about what does each program do
> > in real use cases.  
> 
> The only concrete program that I have that needs this is xdpcap:
> https://github.com/cloudflare/xdpcap
> 
> Right now that needs to be integrated into the calling program to work;
> I want to write a tool like it, but that can insert itself before or
> after arbitrary XDP programs.

The other real world use-case it Facebooks katran, you should be aware:
 https://github.com/facebookincubator/katran

It might be important to understand that the patchset/intent is a hybrid
that satisfy both xdpcap ([2] slide-26) and katran ([2] slide-27), see
later slides how this is done. Notice there a requirement is that users
don't (need to) modify the BPF ELF file, to make it cooperate with this
system.

The katran use-case is to chain several eBPF programs.

The xdpcap use-case is to trap any XDP return action code (and tcpdump
via perf event ring_buffer).  For system administrators the xdpcap
use-case is something we hear about all the time, so one of the missing
features for XDP.  As Toke also wrote, we want to extend this to ALSO
be-able to see/dump the packet BEFORE a given XDP program.


> Lorenz, can you say more about your use case? :)

AFAIK Cloudflare also have a chaining eBPF program use-case for XDP.  I
could not find the blog post.
 
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
