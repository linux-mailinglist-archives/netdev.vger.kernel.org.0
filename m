Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD04E1C5E43
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730244AbgEERCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:02:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728804AbgEERCh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 13:02:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAB0D206B9;
        Tue,  5 May 2020 17:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588698156;
        bh=cxzc4n0fji3iIZXUSpJT8FlBbG2oT5ou/HugO3IFL9w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fhTuRrhcO2Ldh4lczhpT1QtZVQEdgb33E18i5NNzuYuIscbaFJwpJUK3opT7LVKmr
         4yivgMGz4teB8Of4NtZMAdtvDcyN2GNKt/NPa/bCUTgOmBrN10N86BB02Gncoot3MY
         g7j+7Z1P0AKRyKCFF84JFSnbo8L6C6sZVDrEr5vM=
Date:   Tue, 5 May 2020 19:02:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        christophe.jaillet@wanadoo.fr, leon@kernel.org, tglx@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] net: chelsio: Possible buffer overflow caused by DMA
 failures/attacks
Message-ID: <20200505170233.GA1114580@kroah.com>
References: <95e19362-b9c9-faf9-3f9e-f6f4c65a6aff@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <95e19362-b9c9-faf9-3f9e-f6f4c65a6aff@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 11:50:28PM +0800, Jia-Ju Bai wrote:
> In alloc_rx_resources():
>     sge->respQ.entries =
>         pci_alloc_consistent(pdev, size, &sge->respQ.dma_addr);
> 
> Thus, "sge->respQ.entries" is a DMA value, and it is assigned to
> "e" in process_pure_responses():
>     struct sge *sge = adapter->sge;
>     struct respQ *q = &sge->respQ;
>     struct respQ_e *e = &q->entries[q->cidx];
> 
> When DMA failures or attacks occur, the data stored in "e" can be
> changed at any time. In this case, the value of "e->FreelistQid"
> can be a large number to cause buffer overflow when the
> following code is executed:
>     const struct freelQ *fl = &sge->freelQ[e->FreelistQid];
> 
> Similarly, "sge->respQ.entries" is also assigned to "e" in
> process_responses():
>     struct sge *sge = adapter->sge;
>     struct respQ *q = &sge->respQ;
>     struct respQ_e *e = &q->entries[q->cidx];
> 
> When DMA failures or attacks occur, the data stored in "e" can be
> changed at any time. In this case, the value of "e->FreelistQid"
> can be a large number to cause buffer overflow when the
> following code is executed:
>     struct freelQ *fl = &sge->freelQ[e->FreelistQid];
> 
> Considering that DMA can fail or be attacked, I think that it is dangerous
> to
> use a DMA value (or any value tainted by it) as an array index or a
> control-flow
> condition. However, I have found many such dangerous cases in Linux device
> drivers
> through my static-analysis tool and code review.
> I am not sure whether my opinion is correct, so I want to listen to your
> points of view.

Can you create a patch to show what you think needs to be fixed?  That's
the best way to get feedback, reports like this are usually very
infrequently replied to.

thanks,

greg k-h
