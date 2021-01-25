Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C01F302CA0
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 21:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732344AbhAYUgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 15:36:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732332AbhAYUft (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 15:35:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F961216FD;
        Mon, 25 Jan 2021 20:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611606908;
        bh=iV3uLGxFkrvL3ZncMW4qFtypyq/8vryd+AIozBSxuQA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BUVjQM1rXOSeIKjr/PypLU6gGw+xJoY8OueSE35XkHn5YLex6tl5+S+SwaahHCHdF
         Ij/eJsF/kVFBsa2ZlAn+KEZ8hgLqh4zg8FQ2UVvk307TZQxWgpxomtUncplvmSz2kd
         tAotv4dRHxp1XJb2BTStFhSWtp4UiHWEggJ0ioRS3Y9yPg/0uNnYJxuymT/LhxYNAQ
         R9CxlqP4cDC6u6vVrWshx40mez+je6UhOd8b6YyCYfEGw5/X0pjKDhWVol4TXa8eGK
         +GQkWbzFPniNRVRC109SL2BCd5reNpuBdpHBFT7VqwWaGyMRahcjywpujAriFQgQ3f
         6SMGNHijuhPYQ==
Date:   Mon, 25 Jan 2021 12:35:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net 2/3] ibmvnic: remove unnecessary rmb() inside
 ibmvnic_poll
Message-ID: <20210125123507.7cdb061a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAOhMmr4r0OvSvbr68B8483mwJKtm=8BjiYUQa3gtin8ajZQ-5w@mail.gmail.com>
References: <20210121061710.53217-1-ljp@linux.ibm.com>
        <20210121061710.53217-3-ljp@linux.ibm.com>
        <20210123210928.30d79969@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAOhMmr4r0OvSvbr68B8483mwJKtm=8BjiYUQa3gtin8ajZQ-5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Jan 2021 22:38:02 -0600 Lijun Pan wrote:
> On Sat, Jan 23, 2021 at 11:11 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 21 Jan 2021 00:17:09 -0600 Lijun Pan wrote:  
> > > rmb() was introduced to load rx_scrq->msgs after calling
> > > pending_scrq(). Now since pending_scrq() itself already
> > > has dma_rmb() at the end of the function, rmb() is
> > > duplicated and can be removed.
> > >
> > > Fixes: ec20f36bb41a ("ibmvnic: Correctly re-enable interrupts in NAPI polling routine")
> > > Signed-off-by: Lijun Pan <ljp@linux.ibm.com>  
> >
> > rmb() is a stronger barrier than dma_rmb()  
> 
> Yes. I think the weaker dma_rmb() here is enough.
> And I let it reuse the dma_rmb() in the pending_scrq().
> 
> >
> > also again, I don't see how this fixes any bugs  
> 
> I will send to net-next if you are ok with it.

If there is consensus at IBM that the first 2 changes are an
improvement you can drop the Fixes tags and resubmit to net-next.

In patch 3 it looks like the dma_rmb() may indeed be missing so that
one could go to net, but I don't think the dma_wmb() is needed,
especially not where you put it. I think dma_wmb() is only needed
before the device is notified that new buffer was posted, not on
completion.
