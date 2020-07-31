Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51E0234A29
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 19:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733236AbgGaRTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 13:19:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732817AbgGaRTi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 13:19:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6645C2074B;
        Fri, 31 Jul 2020 17:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596215978;
        bh=yxLFBtERe8UngePE6Ae91aGE2Ev7MNPNAO2x8RUFAKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FJM6T0vbEgq2PNNmTnnc65DNz/A50UbgHexnPy4ZP95gE8ClTSvPshL0drR9tvoqC
         Luj0SVJLc7CMxudDRUS2o57mBQ75nNh6SFidxxegIkiPaZrRJZtpzWaTW8Rc+03Jfz
         XCdf00Knp7UBGQTGQpqSCFA9Dz+RfqVPF4vs9i0M=
Date:   Fri, 31 Jul 2020 19:19:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
Message-ID: <20200731171924.GA2014207@kroah.com>
References: <20200730192026.110246-1-yepeilin.cs@gmail.com>
 <20200731045301.GI75549@unreal>
 <20200731053306.GA466103@kroah.com>
 <20200731053333.GB466103@kroah.com>
 <20200731140452.GE24045@ziepe.ca>
 <20200731142148.GA1718799@kroah.com>
 <20200731143604.GF24045@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731143604.GF24045@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 11:36:04AM -0300, Jason Gunthorpe wrote:
> On Fri, Jul 31, 2020 at 04:21:48PM +0200, Greg Kroah-Hartman wrote:
> 
> > > The spec was updated in C11 to require zero'ing padding when doing
> > > partial initialization of aggregates (eg = {})
> > > 
> > > """if it is an aggregate, every member is initialized (recursively)
> > > according to these rules, and any padding is initialized to zero
> > > bits;"""
> > 
> > But then why does the compilers not do this?
> 
> Do you have an example?

At the moment, no, but we have had them in the past due to security
issues we have had to fix for this.

> > > Considering we have thousands of aggregate initializers it
> > > seems likely to me Linux also requires a compiler with this C11
> > > behavior to operate correctly.
> > 
> > Note that this is not an "operate correctly" thing, it is a "zero out
> > stale data in structure paddings so that data will not leak to
> > userspace" thing.
> 
> Yes, not being insecure is "operate correctly", IMHO :)
>  
> > > Does this patch actually fix anything? My compiler generates identical
> > > assembly code in either case.
> > 
> > What compiler version?
> 
> I tried clang 10 and gcc 9.3 for x86-64.
> 
> #include <string.h>
> 
> void test(void *out)
> {
> 	struct rds_rdma_notify {
> 		unsigned long user_token;
> 		unsigned int status;
> 	} foo = {};
> 	memcpy(out, &foo, sizeof(foo));
> }
> 
> $ gcc -mno-sse2 -O2 -Wall -std=c99 t.c -S
> 
> test:
> 	endbr64
> 	movq	$0, (%rdi)
> 	movq	$0, 8(%rdi)
> 	ret
> 
> Just did this same test with gcc 4.4 and it also gave the same output..
> 
> Made it more complex with this:
> 
> 	struct rds_rdma_notify {
> 		unsigned long user_token;
> 		unsigned char status;
> 		unsigned long user_token1;
> 		unsigned char status1;
> 		unsigned long user_token2;
> 		unsigned char status2;
> 		unsigned long user_token3;
> 		unsigned char status3;
> 		unsigned long user_token4;
> 		unsigned char status4;
> 	} foo;
> 
> And still got the same assembly vs memset on gcc 4.4.
> 
> I tried for a bit and didn't find a way to get even old gcc 4.4 to not
> initialize the holes.

Odd, so it is just the "= {0};" that does not zero out the holes?

thanks,

greg k-h
