Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA812E2C8A
	for <lists+netdev@lfdr.de>; Sat, 26 Dec 2020 00:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727379AbgLYXBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 18:01:38 -0500
Received: from smtprelay0240.hostedemail.com ([216.40.44.240]:49070 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725953AbgLYXBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 18:01:38 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id D7F36100E7B43;
        Fri, 25 Dec 2020 23:00:56 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2689:2828:2915:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6742:7652:7902:10004:10400:10848:11232:11658:11914:12297:12740:12760:12895:13069:13076:13161:13229:13311:13357:13439:13548:14096:14097:14659:14721:14819:21080:21627:21740:30012:30054:30069:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: juice07_1a0bb6b2747d
X-Filterd-Recvd-Size: 2936
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Fri, 25 Dec 2020 23:00:54 +0000 (UTC)
Message-ID: <8401b60d35698e68bcf84e977b1b735c131d0b1e.camel@perches.com>
Subject: Re: [PATCH] nfp: remove h from printk format specifier
From:   Joe Perches <joe@perches.com>
To:     Tom Rix <trix@redhat.com>,
        Simon Horman <simon.horman@netronome.com>
Cc:     kuba@kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, gustavoars@kernel.org,
        louis.peens@netronome.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, oss-drivers@netronome.com,
        linux-kernel@vger.kernel.org
Date:   Fri, 25 Dec 2020 15:00:52 -0800
In-Reply-To: <65755252-96c3-a808-3e01-e377dd395ee7@redhat.com>
References: <20201223202053.131157-1-trix@redhat.com>
         <20201224202152.GA3380@netronome.com>
         <bac92bab-243b-ca48-647c-dad5688fa060@redhat.com>
         <18c81854639aa21e76c8b26cc3e7999b0428cc4e.camel@perches.com>
         <7b5517e6-41a9-cc7f-f42f-8ef449f3898e@redhat.com>
         <327d6cad23720c8fe984aa75a046ff69499568c8.camel@perches.com>
         <65755252-96c3-a808-3e01-e377dd395ee7@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-12-25 at 14:13 -0800, Tom Rix wrote:
> On 12/25/20 9:06 AM, Joe Perches wrote:
> > On Fri, 2020-12-25 at 06:56 -0800, Tom Rix wrote:
> > > On 12/24/20 2:39 PM, Joe Perches wrote:
> > []
> > > > Kernel code doesn't use a signed char or short with %hx or %hu very often
> > > > but in case you didn't already know, any signed char/short emitted with
> > > > anything like %hx or %hu needs to be left alone as sign extension occurs so:
> > > Yes, this would also effect checkpatch.
> > Of course but checkpatch is stupid and doesn't know types
> > so it just assumes that the type argument is not signed.
> > 
> > In general, that's a reasonable but imperfect assumption.
> > 
> > coccinelle could probably do this properly as it's a much
> > better parser.  clang-tidy should be able to as well.
> > 
> Ok.
> 
> But types not matching the format string is a larger problem.
> 
> Has there been an effort to clean these up ?

Not really no.  __printf already does a reasonable job for that.

The biggest issue for format type mismatches is the %p<foo> extensions.

__printf can only verify that the argument is a pointer, not
necessarily the 'right' type of pointed to object.

There are overflow possibilities like '"%*ph", len, pointer'
where pointer may not have len bytes available and, for instance,
mismatched uses of %pI4 and %pI6 where %pI4 expects a pointer to
4 bytes and %pI6 expects a pointer to 16 bytes.

Anyway it's not that easy a problem to analyze.

