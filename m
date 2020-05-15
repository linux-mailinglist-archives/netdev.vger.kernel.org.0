Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B191D4205
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgEOAVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:21:34 -0400
Received: from smtprelay0068.hostedemail.com ([216.40.44.68]:42922 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726287AbgEOAVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:21:34 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 4B7DC182CF665;
        Fri, 15 May 2020 00:21:33 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3872:4321:5007:6742:7903:10004:10400:10848:11026:11232:11473:11658:11914:12109:12296:12297:12555:12740:12760:12895:12986:13069:13255:13311:13357:13439:14659:14721:21080:21451:21627:30034:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: jail96_d319c96b8102
X-Filterd-Recvd-Size: 2463
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Fri, 15 May 2020 00:21:30 +0000 (UTC)
Message-ID: <0e9b255313e07b24504a5bcebf56ab5a7839eb1f.camel@perches.com>
Subject: Re: [PATCH v2 bpf-next 4/7] printk: add type-printing %pT format
 specifier which uses BTF
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
Date:   Thu, 14 May 2020 17:21:29 -0700
In-Reply-To: <20200515000920.2el4jyrwqqbd6jw3@ast-mbp.dhcp.thefacebook.com>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
         <1589263005-7887-5-git-send-email-alan.maguire@oracle.com>
         <1b63a6b193073674b6e0f9f95c62ce2af1b977cc.camel@perches.com>
         <CAADnVQK8osy9W8-u-K=ucqe5q-+Uik41fBw6d-SfG-m6rgVwDQ@mail.gmail.com>
         <397fb29abb20d11003a18919ee0c44918fc1a165.camel@perches.com>
         <28145b05ee792b89ab9cb560f4f9989fd3d5d93b.camel@perches.com>
         <20200515000920.2el4jyrwqqbd6jw3@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-05-14 at 17:09 -0700, Alexei Starovoitov wrote:
> On Thu, May 14, 2020 at 04:43:24PM -0700, Joe Perches wrote:
> >  The ``BTF_INT_BITS()`` specifies the number of actual bits held by this int
> >  type. For example, a 4-bit bitfield encodes ``BTF_INT_BITS()`` equals to 4.
> > diff --git a/include/uapi/linux/btf.h b/include/uapi/linux/btf.h
> > index 5a667107ad2c..36f309209786 100644
> > --- a/include/uapi/linux/btf.h
> > +++ b/include/uapi/linux/btf.h
> > @@ -90,6 +90,7 @@ struct btf_type {
> >  #define BTF_INT_SIGNED	(1 << 0)
> >  #define BTF_INT_CHAR	(1 << 1)
> >  #define BTF_INT_BOOL	(1 << 2)
> > +#define BTF_INT_HEX	(1 << 3)
> 
> Nack.
> Hex is not a type.

It is a pretty print output format.

