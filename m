Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13511EFD47
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 18:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgFEQLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 12:11:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgFEQLW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 12:11:22 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C59C206DB;
        Fri,  5 Jun 2020 16:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591373482;
        bh=NZnV11U8sQBzLsjL+Ih82Hj1FQcrfTDZO6BsJVQT/T4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JX4sH+Kl1LUL+oFflby7emnQQW7r38BOfqmaJL7kOaC2ZYQl9dDsN8hWxk8nK44QZ
         7wTlwJ94E/+HCpHCKV6XJmX9tF1RM/d2fbeZF3S/WSY3Blo69Gn9hJXf3YNBCOSG+P
         hafDk7AEz42wn331P0PxE0rD0m3c4FyqQBkVEa0o=
Date:   Fri, 5 Jun 2020 09:11:21 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     syzbot <syzbot+3eec59e770685e3dc879@syzkaller.appspotmail.com>,
        bjorn.andersson@linaro.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, manivannan.sadhasivam@linaro.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: BUG: using smp_processor_id() in preemptible code in
 radix_tree_node_alloc
Message-ID: <20200605161121.GC1373@sol.localdomain>
References: <000000000000a363b205a74ca6a2@google.com>
 <20200605035555.GA2667@sol.localdomain>
 <20200605112922.GB19604@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605112922.GB19604@bombadil.infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 05, 2020 at 04:29:22AM -0700, Matthew Wilcox wrote:
> On Thu, Jun 04, 2020 at 08:55:55PM -0700, Eric Biggers wrote:
> > Possibly a bug in lib/radix-tree.c?  this_cpu_ptr() in radix_tree_node_alloc()
> > can be reached without a prior preempt_disable().  Or is the caller of
> > idr_alloc() doing something wrong?
> 
> Yes, the idr_alloc() call is plainly wrong:
> 
>         mutex_lock(&qrtr_port_lock);
>         if (!*port) {
>                 rc = idr_alloc(&qrtr_ports, ipc,
>                                QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET + 1,
>                                GFP_ATOMIC);
> 
> If we can take a mutex lock, there's no excuse to be using GFP_ATOMIC.
> That (and the call slightly lower in the function) should be GFP_KERNEL
> as the minimal fix (below).  I'll send a followup patch which converts
> this IDR to the XArray instead.

I did see that the GFP_ATOMIC was unnecessary, but it wasn't obvious to me that
it was actually *wrong*.

Shouldn't this requirement be documented for the @gfp argument to idr_alloc()?

- Eric
