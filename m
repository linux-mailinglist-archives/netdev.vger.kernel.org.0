Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8A2528C7
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbfFYJ6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:58:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbfFYJ6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 05:58:00 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A59747E424;
        Tue, 25 Jun 2019 09:57:47 +0000 (UTC)
Received: from localhost (unknown [10.43.2.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C60F810013D9;
        Tue, 25 Jun 2019 09:57:43 +0000 (UTC)
Date:   Tue, 25 Jun 2019 11:57:37 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Soeren Moch <smoch@web.de>
Cc:     Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] rt2x00: fix rx queue hang
Message-ID: <20190625095734.GA2886@redhat.com>
References: <20190617094656.3952-1-smoch@web.de>
 <20190618093431.GA2577@redhat.com>
 <b6899d78-447c-3cb3-4bec-e4050660ccaa@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6899d78-447c-3cb3-4bec-e4050660ccaa@web.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 25 Jun 2019 09:57:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello

On Fri, Jun 21, 2019 at 01:30:01PM +0200, Soeren Moch wrote:
> On 18.06.19 11:34, Stanislaw Gruszka wrote:
> > Hi
> >
> > On Mon, Jun 17, 2019 at 11:46:56AM +0200, Soeren Moch wrote:
> >> Since commit ed194d136769 ("usb: core: remove local_irq_save() around
> >>  ->complete() handler") the handlers rt2x00usb_interrupt_rxdone() and
> >> rt2x00usb_interrupt_txdone() are not running with interrupts disabled
> >> anymore. So these handlers are not guaranteed to run completely before
> >> workqueue processing starts. So only mark entries ready for workqueue
> >> processing after proper accounting in the dma done queue.
> > It was always the case on SMP machines that rt2x00usb_interrupt_{tx/rx}done
> > can run concurrently with rt2x00_work_{rx,tx}done, so I do not
> > understand how removing local_irq_save() around complete handler broke
> > things.
> I think because completion handlers can be interrupted now and scheduled
> away
> in the middle of processing.
> > Have you reverted commit ed194d136769 and the revert does solve the problem ?
> Yes, I already sent a patch for this, see [1]. But this was not considered
> an acceptablesolution. Especially RT folks do not like code running with
> interrupts disabled,particularly when trying to acquire spinlocks then.
> 
> [1] https://lkml.org/lkml/2019/5/31/863
> > Between 4.19 and 4.20 we have some quite big changes in rt2x00 driver:
> >
> > 0240564430c0 rt2800: flush and txstatus rework for rt2800mmio
> > adf26a356f13 rt2x00: use different txstatus timeouts when flushing
> > 5022efb50f62 rt2x00: do not check for txstatus timeout every time on tasklet
> > 0b0d556e0ebb rt2800mmio: use txdone/txstatus routines from lib
> > 5c656c71b1bf rt2800: move usb specific txdone/txstatus routines to rt2800lib
> >
> > so I'm a bit afraid that one of those changes is real cause of
> > the issue not ed194d136769 .
> I tested 4.20 and 5.1 and see the exact same behavior. Reverting this
> usb core patchsolves the problem.
> 4.19.x (before this usb core patch) is running fine.
> >> Note that rt2x00usb_work_rxdone() processes all available entries, not
> >> only such for which queue_work() was called.
> >>
> >> This fixes a regression on a RT5370 based wifi stick in AP mode, which
> >> suddenly stopped data transmission after some period of heavy load. Also
> >> stopping the hanging hostapd resulted in the error message "ieee80211
> >> phy0: rt2x00queue_flush_queue: Warning - Queue 14 failed to flush".
> >> Other operation modes are probably affected as well, this just was
> >> the used testcase.
> > Do you know what actually make the traffic stop,
> > TX queue hung or RX queue hung?
> I think RX queue hang, as stated in the patch title. "Queue 14" means QID_RX
> (rt2x00queue.h, enum data_queue_qid).
> I also tried to re-add local_irq_save() in only one of the handlers. Adding
> this tort2x00usb_interrupt_rxdone() alone solved the issue, while doing so
> for tx alonedid not.
> 
> Note that this doesn't mean there is no problem for tx, that's maybe
> just more
> difficult to trigger.
> >> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> >> index 1b08b01db27b..9c102a501ee6 100644
> >> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> >> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> >> @@ -263,9 +263,9 @@ EXPORT_SYMBOL_GPL(rt2x00lib_dmastart);
> >>
> >>  void rt2x00lib_dmadone(struct queue_entry *entry)
> >>  {
> >> -	set_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags);
> >>  	clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
> >>  	rt2x00queue_index_inc(entry, Q_INDEX_DMA_DONE);
> >> +	set_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags);
> > Unfortunately I do not understand how this suppose to fix the problem,
> > could you elaborate more about this change?
> >
> Re-adding local_irq_save() around thisrt2x00lib_dmadone()solved
> the issue. So I also tried to reverse the order of these calls.
> It seems totally plausible to me, that the correct sequence is to
> first clear the device assignment, then to set the status to dma_done,
> then to trigger the workqueue processing for this entry. When the handler
> is scheduled away in the middle of this sequence, now there is no
> strange state where the entry can be processed by the workqueue while
> not declared dma_done for it.
> With this changed sequence there is no need anymore to disable interrupts
> for solving the hang issue.

Thanks very much for explanations. However I still do not fully
understand the issue. Q_INDEX_DMA_DONE index is only checked on TX
processing (on RX we use only Q_INDEX_DONE and Q_INDEX) and
ENTRY_OWNER_DEVICE_DATA is already cleared before rt2x00lib_dmadone()
in rt2x00usb_interrupt_rxdone() .

So I'm not sure how changing the order solve the problem. Looks
for me that the issue is triggered by some rt2x00lib_dmadone()
call done on error path (not in rt2x00usb_interrupt_rxdone())
and it race with this check:

        if (test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
            test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
                return false;

in rt2x00usb_kick_rx_entry() - we return instead of submit urb.

I'm somewhat reluctant to change the order, because TX processing
might relay on it (we first mark we wait for TX status and
then mark entry is no longer owned by hardware). However on RX
side ENTRY_DATA_STATUS_PENDING bit make no sense as we do not
wait for status. We should remove ENTRY_DATA_STATUS_PENDING on
RX side and perhaps this also will solve issue you observe.
Could you please check below patch, if it fixes the problem as well?

Stanislaw

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index b6c1344..731e633 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -360,8 +360,7 @@ static void rt2x00usb_work_rxdone(struct work_struct *work)
 	while (!rt2x00queue_empty(rt2x00dev->rx)) {
 		entry = rt2x00queue_get_entry(rt2x00dev->rx, Q_INDEX_DONE);
 
-		if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
-		    !test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
+		if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 			break;
 
 		/*
@@ -413,8 +412,7 @@ static bool rt2x00usb_kick_rx_entry(struct queue_entry *entry, void *data)
 	struct queue_entry_priv_usb *entry_priv = entry->priv_data;
 	int status;
 
-	if (test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
-	    test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
+	if (test_and_set_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 		return false;
 
 	rt2x00lib_dmastart(entry);
