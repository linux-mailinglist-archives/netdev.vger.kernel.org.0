Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CBF2E290D
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 23:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbgLXWkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 17:40:02 -0500
Received: from smtprelay0037.hostedemail.com ([216.40.44.37]:41052 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728851AbgLXWkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 17:40:02 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id A7570100E7B44;
        Thu, 24 Dec 2020 22:39:20 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1434:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2376:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3873:3874:4321:5007:6117:6119:6235:6742:7557:7576:7652:7902:7903:7904:8603:10004:10400:10848:11026:11232:11473:11658:11914:12043:12294:12297:12555:12663:12740:12760:12895:12986:13439:13870:14180:14181:14659:14721:21060:21080:21324:21451:21627:21939:21990:30012:30054:30070:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: rose20_22010c527474
X-Filterd-Recvd-Size: 3246
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Thu, 24 Dec 2020 22:39:17 +0000 (UTC)
Message-ID: <18c81854639aa21e76c8b26cc3e7999b0428cc4e.camel@perches.com>
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
Date:   Thu, 24 Dec 2020 14:39:16 -0800
In-Reply-To: <bac92bab-243b-ca48-647c-dad5688fa060@redhat.com>
References: <20201223202053.131157-1-trix@redhat.com>
         <20201224202152.GA3380@netronome.com>
         <bac92bab-243b-ca48-647c-dad5688fa060@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-12-24 at 14:14 -0800, Tom Rix wrote:
> On 12/24/20 12:21 PM, Simon Horman wrote:
> > On Wed, Dec 23, 2020 at 12:20:53PM -0800, trix@redhat.com wrote:
> > > From: Tom Rix <trix@redhat.com>
> > > 
> > > This change fixes the checkpatch warning described in this commit
> > > commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of unnecessary %h[xudi] and %hh[xudi]")
> > > 
> > > Standard integer promotion is already done and %hx and %hhx is useless
> > > so do not encourage the use of %hh[xudi] or %h[xudi].
> > > 
> > > Signed-off-by: Tom Rix <trix@redhat.com>
> > Hi Tom,
> > 
> > This patch looks appropriate for net-next, which is currently closed.
> > 
> > The changes look fine, but I'm curious to know if its intentionally that
> > the following was left alone in ethernet/netronome/nfp/nfp_net_ethtool.c:nfp_net_get_nspinfo()
> > 
> > 	snprintf(version, ETHTOOL_FWVERS_LEN, "%hu.%hu"
> 
> I am limiting changes to logging functions, what is roughly in checkpatch.
> 
> I can add this snprintf in if you want.

I'm a bit confused here Tom.

I thought your clang-tidy script was looking for anything marked with
__printf() that is using %h[idux] or %hh[idux].

Wouldn't snprintf qualify for this already?

include/linux/kernel.h-extern __printf(3, 4)
include/linux/kernel.h:int snprintf(char *buf, size_t size, const char *fmt, ...);

Kernel code doesn't use a signed char or short with %hx or %hu very often
but in case you didn't already know, any signed char/short emitted with
anything like %hx or %hu needs to be left alone as sign extension occurs so:

	signed char foo = -1;
	printk("%hx", foo);

emits ffff but

	printk("%x", foo);

emits ffffffff

An example:

$ gcc -x c -
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	signed short i = -1;
	printf("hx: %hx\n", i);
	printf("x:  %x\n", i);
	printf("hu: %hu\n", i);
	printf("u:  %u\n", i);
	return 0;
}

$ ./a.out
hx: ffff
x:  ffffffff
hu: 65535
u:  4294967295

$


