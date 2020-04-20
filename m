Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEA71B11A7
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgDTQfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:35:17 -0400
Received: from smtprelay0171.hostedemail.com ([216.40.44.171]:38196 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725287AbgDTQfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 12:35:17 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id C26278384364;
        Mon, 20 Apr 2020 16:35:15 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:491:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1543:1593:1594:1605:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2691:2828:2892:2907:3138:3139:3140:3141:3142:3622:3743:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:5007:6119:6120:6248:6691:6742:7903:7904:9040:10004:10400:10848:11232:11658:11914:12043:12109:12219:12296:12297:12555:12740:12760:12895:13138:13153:13161:13228:13229:13231:13439:14096:14097:14181:14659:14721:21063:21080:21433:21627:21796:21939:30036:30045:30046:30054:30056:30074:30075:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: lock50_4abfde65a5055
X-Filterd-Recvd-Size: 4328
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf02.hostedemail.com (Postfix) with ESMTPA;
        Mon, 20 Apr 2020 16:35:13 +0000 (UTC)
Message-ID: <7d6019da19d52c851d884731b1f16328fdbe2e3d.camel@perches.com>
Subject: Re: [RFC PATCH bpf-next 0/6] bpf, printk: add BTF-based type
 printing
From:   Joe Perches <joe@perches.com>
To:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, kafai@fb.com,
        songliubraving@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Mon, 20 Apr 2020 09:32:57 -0700
In-Reply-To: <alpine.LRH.2.21.2004201623390.12711@localhost>
References: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
         <20200418160536.4mrvqh2lasqbyk77@ast-mbp>
         <alpine.LRH.2.21.2004201623390.12711@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-04-20 at 16:29 +0100, Alan Maguire wrote:
> On Sat, 18 Apr 2020, Alexei Starovoitov wrote:
> 
> > On Fri, Apr 17, 2020 at 11:42:34AM +0100, Alan Maguire wrote:
> > > The printk family of functions support printing specific pointer types
> > > using %p format specifiers (MAC addresses, IP addresses, etc).  For
> > > full details see Documentation/core-api/printk-formats.rst.
> > > 
> > > This RFC patchset proposes introducing a "print typed pointer" format
> > > specifier "%pT<type>"; the type specified is then looked up in the BPF
> > > Type Format (BTF) information provided for vmlinux to support display.
> > 
> > This is great idea! Love it.
> > 
> 
> Thanks for taking a look!
>  
> > > The above potential use cases hint at a potential reply to
> > > a reasonable objection that such typed display should be
> > > solved by tracing programs, where the in kernel tracing records
> > > data and the userspace program prints it out.  While this
> > > is certainly the recommended approach for most cases, I
> > > believe having an in-kernel mechanism would be valuable
> > > also.
> > 
> > yep. This is useful for general purpose printk.
> > The only piece that must be highlighted in the printk documentation
> > that unlike the rest of BPF there are zero safety guarantees here.
> > The programmer can pass wrong pointer to printk() and the kernel _will_ crash.
> > 
> 
> Good point; I'll highlight the fact that we aren't
> executing in BPF context, no verifier etc.
> 
> > >   struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
> > > 
> > >   pr_info("%pTN<struct sk_buff>", skb);
> > 
> > why follow "TN" convention?
> > I think "%p<struct sk_buff>" is much more obvious, unambiguous, and
> > equally easy to parse.
> > 
> 
> That was my first choice, but the first character
> after the 'p' in the '%p' specifier signifies the
> pointer format specifier. If we use '<', and have
> '%p<', where do we put the modifiers? '%p<xYz struct foo>'
> seems clunky to me.

While I don't really like the %p<struct type> block,
it's at least obvious what's being attempted.

Modifiers could easily go after the <struct type> block.

It appears a %p<struct type> output might be a lot of
total characters so another potential issue might be
the maximum length of each individual printk.

> > I like the choice of C style output, but please format it similar to drgn. Like:
> > *(struct task_struct *)0xffff889ff8a08000 = {
> > 	.thread_info = (struct thread_info){
> > 		.flags = (unsigned long)0,
> > 		.status = (u32)0,
> > 	},
> > 	.state = (volatile long)1,
> > 	.stack = (void *)0xffffc9000c4dc000,
> > 	.usage = (refcount_t){
> > 		.refs = (atomic_t){
> > 			.counter = (int)2,
> > 		},
> > 	},
> > 	.flags = (unsigned int)4194560,
> > 	.ptrace = (unsigned int)0,

And here, the issue might be duplicating the log level
for each line of output and/or prefixing each line with
whatever struct type is being dumped as interleaving
with other concurrent logging is possible.

Here as well the individual field types don't contain
enough information to determine if a field should be
output as %x or %u.


