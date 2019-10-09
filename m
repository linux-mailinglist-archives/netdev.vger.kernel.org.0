Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13ADAD0CB0
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 12:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730881AbfJIKUN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Oct 2019 06:20:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58430 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730824AbfJIKUM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 06:20:12 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EE103C0546FE;
        Wed,  9 Oct 2019 10:20:11 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B31D1001B30;
        Wed,  9 Oct 2019 10:19:57 +0000 (UTC)
Date:   Wed, 9 Oct 2019 12:19:55 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH bpf-next v3 1/5] bpf: Support chain calling multiple BPF
 programs after each other
Message-ID: <20191009121955.29cad5bb@carbon>
In-Reply-To: <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
        <157046883614.2092443.9861796174814370924.stgit@alrua-x1>
        <20191007204234.p2bh6sul2uakpmnp@ast-mbp.dhcp.thefacebook.com>
        <87sgo3lkx9.fsf@toke.dk>
        <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 09 Oct 2019 10:20:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Oct 2019 18:51:19 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Tue, Oct 08, 2019 at 10:07:46AM +0200, Toke Høiland-Jørgensen wrote:
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >   
> > > On Mon, Oct 07, 2019 at 07:20:36PM +0200, Toke Høiland-Jørgensen wrote:  
> > >> From: Toke Høiland-Jørgensen <toke@redhat.com>
> > >> 
> > >> This adds support for wrapping eBPF program dispatch in chain calling
> > >> logic. The code injection is controlled by a flag at program load time; if
> > >> the flag is set, the BPF program will carry a flag bit that changes the
> > >> program dispatch logic to wrap it in a chain call loop.
[...]
> > >> diff --git a/include/linux/filter.h b/include/linux/filter.h
> > >> index 2ce57645f3cd..3d1e4991e61d 100644
> > >> --- a/include/linux/filter.h
> > >> +++ b/include/linux/filter.h
[...]
> > >>  #define BPF_PROG_RUN(prog, ctx)	({				\
> > >> @@ -559,14 +585,18 @@ DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
> > >>  	if (static_branch_unlikely(&bpf_stats_enabled_key)) {	\
> > >>  		struct bpf_prog_stats *stats;			\
> > >>  		u64 start = sched_clock();			\
> > >> -		ret = (*(prog)->bpf_func)(ctx, (prog)->insnsi);	\
> > >> +		ret = prog->chain_calls ?			\
> > >> +			do_chain_calls(prog, ctx) :			\
> > >> +			 (*(prog)->bpf_func)(ctx, (prog)->insnsi);	\  
> > >
> > > I thought you agreed on 'no performance regressions' rule?  
> > 
> > As I wrote in the cover letter I could not measurable a performance
> > impact from this, even with the simplest possible XDP program (where
> > program setup time has the largest impact).
> > 
> > This was the performance before/after patch (also in the cover letter):
> > 
> > Before patch (XDP DROP program):  31.5 Mpps
> > After patch (XDP DROP program):   32.0 Mpps
> > 
> > So actually this *increases* performance ;)
> > (Or rather, the difference is within the measurement uncertainty on my
> > system).  
> 
> I have hard time believing such numbers.

Don't look at this as +/- 500Kpps.  Instead you have to realize that the
performance difference in ns (nano-seconds) is only 0.5 ns (0.496 ns).

 (1/31.5*1000)-(1/32.0*1000) = 0.4960 ns

This "half-a-nanosec" is below the measurement uncertainty of any
system. My system have approx 2-3 ns measurement variance, which I'm
proud of.  At these speeds (32Mpps) this e.g. 3 ns variance would
result in -2.8 Mpps (29.2Mpps).


The change Toke did in BPF_PROG_RUN does not introduce any measurable
performance change, as least on high-end Intel CPUs.  This DOES satisfy
'no performance regressions' rule.  You can dislike the solution for
other reasons ;-)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
