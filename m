Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC5535A9B0
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 10:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfF2Iuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 04:50:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40544 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbfF2Iuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 04:50:52 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9483881F01;
        Sat, 29 Jun 2019 08:50:51 +0000 (UTC)
Received: from localhost (unknown [10.43.2.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F9A760600;
        Sat, 29 Jun 2019 08:50:50 +0000 (UTC)
Date:   Sat, 29 Jun 2019 10:50:42 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Soeren Moch <smoch@web.de>
Cc:     Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] rt2x00: fix rx queue hang
Message-ID: <20190629085041.GA2854@redhat.com>
References: <20190617094656.3952-1-smoch@web.de>
 <20190618093431.GA2577@redhat.com>
 <b6899d78-447c-3cb3-4bec-e4050660ccaa@web.de>
 <20190625095734.GA2886@redhat.com>
 <8d7da251-8218-ff4b-2cf3-8ed69c97275e@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d7da251-8218-ff4b-2cf3-8ed69c97275e@web.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Sat, 29 Jun 2019 08:50:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

On Wed, Jun 26, 2019 at 03:28:00PM +0200, Soeren Moch wrote:
> Hi Stanislaw,
> 
> the good news is: your patch below also solves the issue for me. But
> removing the ENTRY_DATA_STATUS_PENDING check in
> rt2x00usb_kick_rx_entry() alone does not help, while removing this check
> in rt2x00usb_work_rxdone() alone does the trick.
> 
> So the real race seems to be that the flags set in the completion
> handler are not yet visible on the cpu core running the workqueue. And
> because the worker is not rescheduled when aborted, the entry can just
> wait forever.
> Do you think this could make sense?

Yes.

> > I'm somewhat reluctant to change the order, because TX processing
> > might relay on it (we first mark we wait for TX status and
> > then mark entry is no longer owned by hardware).
> OK, maybe it's just good luck that changing the order solves the rx
> problem. Or can memory barriers associated with the spinlock in
> rt2x00lib_dmadone() be responsible for that?
> (I'm testing on a armv7 system, Cortex-A9 quadcore.)

I'm not sure, rt2x00queue_index_inc() also disable/enable interrupts,
so maybe that make race not reproducible. 

> While looking at it, why we double-clear ENTRY_OWNER_DEVICE_DATA in
> rt2x00usb_interrupt_rxdone() directly and in rt2x00lib_dmadone() again,

rt2x00lib_dmadone() is called also on other palaces (error paths)
when we have to clear flags.

> while not doing the same for tx? 

If I remember correctly we have some races on rx (not happened on tx)
that was solved by using test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA).

> Would it make more sense to possibly
> set ENTRY_DATA_IO_FAILED before clearing ENTRY_OWNER_DEVICE_DATA in
> rt2x00usb_interrupt_rxdone() as for tx?

I don't think so, ENTRY_DATA_IO_FAILED should be only set on error
case.

> >  However on RX
> > side ENTRY_DATA_STATUS_PENDING bit make no sense as we do not
> > wait for status. We should remove ENTRY_DATA_STATUS_PENDING on
> > RX side and perhaps this also will solve issue you observe.
> I agree that removing the unnecessary checks is a good idea in any case.
> > Could you please check below patch, if it fixes the problem as well?
> At least I could not trigger the problem within transferring 10GB of
> data. But maybe the probability for triggering this bug is just lower
> because ENTRY_OWNER_DEVICE_DATA is cleared some time before
> ENTRY_DATA_STATUS_PENDING is set?

Not sure. Anyway, could you post patch removing not needed checks
with proper description/changelog ?

Stanislaw
