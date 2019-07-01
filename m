Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61F85BA49
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 13:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbfGALFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 07:05:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34190 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727162AbfGALFA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 07:05:00 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1FBA53091740;
        Mon,  1 Jul 2019 11:04:55 +0000 (UTC)
Received: from localhost (ovpn-204-140.brq.redhat.com [10.40.204.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9357E6F924;
        Mon,  1 Jul 2019 11:04:52 +0000 (UTC)
Date:   Mon, 1 Jul 2019 13:04:51 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Soeren Moch <smoch@web.de>
Cc:     Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] rt2x00: fix rx queue hang
Message-ID: <20190701110451.GA16985@redhat.com>
References: <20190617094656.3952-1-smoch@web.de>
 <20190618093431.GA2577@redhat.com>
 <b6899d78-447c-3cb3-4bec-e4050660ccaa@web.de>
 <20190625095734.GA2886@redhat.com>
 <8d7da251-8218-ff4b-2cf3-8ed69c97275e@web.de>
 <20190629085041.GA2854@redhat.com>
 <06c55c1d-6da6-76b2-f6e7-c8eeccd5aa35@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06c55c1d-6da6-76b2-f6e7-c8eeccd5aa35@web.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 01 Jul 2019 11:05:00 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 12:49:50PM +0200, Soeren Moch wrote:
> Hello!
> 
> On 29.06.19 10:50, Stanislaw Gruszka wrote:
> > Hello
> >
> > On Wed, Jun 26, 2019 at 03:28:00PM +0200, Soeren Moch wrote:
> >> Hi Stanislaw,
> >>
> >> the good news is: your patch below also solves the issue for me. But
> >> removing the ENTRY_DATA_STATUS_PENDING check in
> >> rt2x00usb_kick_rx_entry() alone does not help, while removing this check
> >> in rt2x00usb_work_rxdone() alone does the trick.
> >>
> >> So the real race seems to be that the flags set in the completion
> >> handler are not yet visible on the cpu core running the workqueue. And
> >> because the worker is not rescheduled when aborted, the entry can just
> >> wait forever.
> >> Do you think this could make sense?
> > Yes.
> >
> >>> I'm somewhat reluctant to change the order, because TX processing
> >>> might relay on it (we first mark we wait for TX status and
> >>> then mark entry is no longer owned by hardware).
> >> OK, maybe it's just good luck that changing the order solves the rx
> >> problem. Or can memory barriers associated with the spinlock in
> >> rt2x00lib_dmadone() be responsible for that?
> >> (I'm testing on a armv7 system, Cortex-A9 quadcore.)
> > I'm not sure, rt2x00queue_index_inc() also disable/enable interrupts,
> > so maybe that make race not reproducible. 
> I tested some more, the race is between setting ENTRY_DATA_IO_FAILED (if
> needed) and enabling workqueue processing. This enabling was done via
> ENTRY_DATA_STATUS_PENDING in my patch. So setting
> ENTRY_DATA_STATUS_PENDING behind the spinlock in
> rt2x00lib_dmadone()/rt2x00queue_index_inc() moved this very close to
> setting of ENTRY_DATA_IO_FAILED (if needed). While still in the wrong
> order, this made it very unlikely for the race to show up.
> >
> >> While looking at it, why we double-clear ENTRY_OWNER_DEVICE_DATA in
> >> rt2x00usb_interrupt_rxdone() directly and in rt2x00lib_dmadone() again,
> > rt2x00lib_dmadone() is called also on other palaces (error paths)
> > when we have to clear flags.
> Yes, but also clearing ENTRY_OWNER_DEVICE_DATA in
> rt2x00usb_interrupt_rxdone() directly is not necessary and can lead to
> the wrong processing order.
> >>  while not doing the same for tx? 
> > If I remember correctly we have some races on rx (not happened on tx)
> > that was solved by using test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA).
> I searched in the history, it actually was the other way around. You
> changed test_and_clear_bit() to test_bit() in the TX path. I think this
> is also the right way to go in RX.
> >> Would it make more sense to possibly
> >> set ENTRY_DATA_IO_FAILED before clearing ENTRY_OWNER_DEVICE_DATA in
> >> rt2x00usb_interrupt_rxdone() as for tx?
> > I don't think so, ENTRY_DATA_IO_FAILED should be only set on error
> > case.
> 
> Yes of course. But if the error occurs, it should be signalled before
> enabling the workqueue processing, see the race described above.
> 
> After some more testing I'm convinced that this would be the right fix
> for this problem. I will send a v2 of this patch accordingly.

Great, now I understand the problem. Thank you very much!

Stanislaw
