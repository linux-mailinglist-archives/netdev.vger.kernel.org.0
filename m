Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D731D22F3
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 01:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732582AbgEMXXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 19:23:47 -0400
Received: from smtprelay0224.hostedemail.com ([216.40.44.224]:44492 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732374AbgEMXXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 19:23:47 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 0DD0E182CF668;
        Wed, 13 May 2020 23:23:46 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3873:4321:5007:6119:6742:7903:7904:10004:10400:11026:11232:11473:11658:11914:12043:12109:12219:12296:12297:12555:12740:12760:12895:12986:13069:13161:13229:13311:13357:13439:14096:14097:14181:14659:14721:21080:21627:21990:30054:30070:30074:30080:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: wool25_209212bf08451
X-Filterd-Recvd-Size: 3051
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Wed, 13 May 2020 23:23:43 +0000 (UTC)
Message-ID: <e09c45fac7bb688e5e248449594625eda97a2791.camel@perches.com>
Subject: Re: [PATCH v2 bpf-next 0/7] bpf, printk: add BTF-based type printing
From:   Joe Perches <joe@perches.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Date:   Wed, 13 May 2020 16:23:42 -0700
In-Reply-To: <CAADnVQLPSvRCO-xxW+Rcz4bzLM-DXjSzm8AwhyogrNTufBdoNw@mail.gmail.com>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
         <20200513222424.4nfxgkequhdzn3u3@ast-mbp.dhcp.thefacebook.com>
         <dc6a17197c3406d877efd98de351e57d7bbe06a5.camel@perches.com>
         <CAADnVQLPSvRCO-xxW+Rcz4bzLM-DXjSzm8AwhyogrNTufBdoNw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-05-13 at 15:50 -0700, Alexei Starovoitov wrote:
> On Wed, May 13, 2020 at 3:48 PM Joe Perches <joe@perches.com> wrote:
> > On Wed, 2020-05-13 at 15:24 -0700, Alexei Starovoitov wrote:
> > > On Tue, May 12, 2020 at 06:56:38AM +0100, Alan Maguire wrote:
> > > > The printk family of functions support printing specific pointer types
> > > > using %p format specifiers (MAC addresses, IP addresses, etc).  For
> > > > full details see Documentation/core-api/printk-formats.rst.
> > > > 
> > > > This patchset proposes introducing a "print typed pointer" format
> > > > specifier "%pT"; the argument associated with the specifier is of
> > > > form "struct btf_ptr *" which consists of a .ptr value and a .type
> > > > value specifying a stringified type (e.g. "struct sk_buff") or
> > > > an .id value specifying a BPF Type Format (BTF) id identifying
> > > > the appropriate type it points to.
> > > > 
> > > >   pr_info("%pT", BTF_PTR_TYPE(skb, "struct sk_buff"));
> > > > 
> > > > ...gives us:
> > > > 
> > > > (struct sk_buff){
> > > >  .transport_header = (__u16)65535,
> > > >  .mac_header = (__u16)65535,
> > > >  .end = (sk_buff_data_t)192,
> > > >  .head = (unsigned char *)000000007524fd8b,
> > > >  .data = (unsigned char *)000000007524fd8b,
> > > 
> > > could you add "0x" prefix here to make it even more C like
> > > and unambiguous ?
> > 
> > linux pointers are not emitted with an 0x prefix
> 
> So? This is not at all comparable to %p

Then why is x used to obfuscate?


