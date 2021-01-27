Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC1E30541B
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbhA0HMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317508AbhA0Aov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 19:44:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BA4C061573;
        Tue, 26 Jan 2021 16:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TEW2JYzn+vqvCtp0wfRNcEJNG8YlfIBkSfIXrU7EIyI=; b=RUqjEncrRoERE8rbq+OKuNfu1R
        kyqA6pQUBIWFphnHhodhd9ds/DPt4HvE8aKVtFV9/wPkE7zn894nykm9jQPCBXMYKEibeytNJYLeq
        w3Nsmi9R8b+afWrgXFw6V5yMS1S/StpMOUm+wAuWkkqNA5Si9gBJAmDemonDm3halNX7nNu+CzSyu
        aycFgfm8MwMoDQarKZAKEcrBxM3dhDt8z1BbipvnXFjDmS1xl0dtZTMVuZk/qv27DW2KRwfackNeT
        lLN6L6arAZlIG+0WXrLlvgPqzpJINe5mSg8t1zfauFs3kXWTR38HIrn7npnmZKFgkDusFXc/8hZpc
        JdS+1yyw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l4Ytg-006RUT-Vz; Wed, 27 Jan 2021 00:42:16 +0000
Date:   Wed, 27 Jan 2021 00:41:24 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Courtney Cavin <courtney.cavin@sonymobile.com>
Subject: Re: Preemptible idr_alloc() in QRTR code
Message-ID: <20210127004124.GP308988@casper.infradead.org>
References: <20210126104734.GB80448@C02TD0UTHF1T.local>
 <20210126145833.GM308988@casper.infradead.org>
 <20210126162154.GD80448@C02TD0UTHF1T.local>
 <YBBKla3I2TxMFIvZ@builder.lan>
 <20210126183534.GA90035@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126183534.GA90035@C02TD0UTHF1T.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 06:36:02PM +0000, Mark Rutland wrote:
> On Tue, Jan 26, 2021 at 11:00:05AM -0600, Bjorn Andersson wrote:
> > On Tue 26 Jan 10:21 CST 2021, Mark Rutland wrote:
> > 
> > > On Tue, Jan 26, 2021 at 02:58:33PM +0000, Matthew Wilcox wrote:
> > > > On Tue, Jan 26, 2021 at 10:47:34AM +0000, Mark Rutland wrote:
> > > > > Hi,
> > > > > 
> > > > > When fuzzing arm64 with Syzkaller, I'm seeing some splats where
> > > > > this_cpu_ptr() is used in the bowels of idr_alloc(), by way of
> > > > > radix_tree_node_alloc(), in a preemptible context:
> > > > 
> > > > I sent a patch to fix this last June.  The maintainer seems to be
> > > > under the impression that I care an awful lot more about their
> > > > code than I do.
> > > > 
> > > > https://lore.kernel.org/netdev/20200605120037.17427-1-willy@infradead.org/
> > > 
> > > Ah; I hadn't spotted the (glaringly obvious) GFP_ATOMIC abuse, thanks
> > > for the pointer, and sorry for the noise.
> > > 
> > 
> > I'm afraid this isn't as obvious to me as it is to you. Are you saying
> > that one must not use GFP_ATOMIC in non-atomic contexts?
> > 
> > That said, glancing at the code I'm puzzled to why it would use
> > GFP_ATOMIC.
> 
> I'm also not entirely sure about the legitimacy of GFP_ATOMIC outside of
> atomic contexts -- I couldn't spot any documentation saying that wasn't
> legitimate, but Matthew's commit message implies so, and it sticks out
> as odd.

It's actually an assumption in the radix tree code.  If you say you
can't be preempted by saying GFP_ATOMIC, it takes you at your word and
does some things which cannot be done in preemptable context.
