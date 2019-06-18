Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4415049D6E
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 11:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbfFRJel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 05:34:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729220AbfFRJel (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 05:34:41 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 30CC6223864;
        Tue, 18 Jun 2019 09:34:36 +0000 (UTC)
Received: from localhost (unknown [10.43.2.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9674D605CE;
        Tue, 18 Jun 2019 09:34:33 +0000 (UTC)
Date:   Tue, 18 Jun 2019 11:34:31 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Soeren Moch <smoch@web.de>
Cc:     Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] rt2x00: fix rx queue hang
Message-ID: <20190618093431.GA2577@redhat.com>
References: <20190617094656.3952-1-smoch@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617094656.3952-1-smoch@web.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 18 Jun 2019 09:34:41 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On Mon, Jun 17, 2019 at 11:46:56AM +0200, Soeren Moch wrote:
> Since commit ed194d136769 ("usb: core: remove local_irq_save() around
>  ->complete() handler") the handlers rt2x00usb_interrupt_rxdone() and
> rt2x00usb_interrupt_txdone() are not running with interrupts disabled
> anymore. So these handlers are not guaranteed to run completely before
> workqueue processing starts. So only mark entries ready for workqueue
> processing after proper accounting in the dma done queue.

It was always the case on SMP machines that rt2x00usb_interrupt_{tx/rx}done
can run concurrently with rt2x00_work_{rx,tx}done, so I do not
understand how removing local_irq_save() around complete handler broke
things.

Have you reverted commit ed194d136769 and the revert does solve the problem ?

Between 4.19 and 4.20 we have some quite big changes in rt2x00 driver:

0240564430c0 rt2800: flush and txstatus rework for rt2800mmio
adf26a356f13 rt2x00: use different txstatus timeouts when flushing
5022efb50f62 rt2x00: do not check for txstatus timeout every time on tasklet
0b0d556e0ebb rt2800mmio: use txdone/txstatus routines from lib
5c656c71b1bf rt2800: move usb specific txdone/txstatus routines to rt2800lib

so I'm a bit afraid that one of those changes is real cause of
the issue not ed194d136769 .

> Note that rt2x00usb_work_rxdone() processes all available entries, not
> only such for which queue_work() was called.
> 
> This fixes a regression on a RT5370 based wifi stick in AP mode, which
> suddenly stopped data transmission after some period of heavy load. Also
> stopping the hanging hostapd resulted in the error message "ieee80211
> phy0: rt2x00queue_flush_queue: Warning - Queue 14 failed to flush".
> Other operation modes are probably affected as well, this just was
> the used testcase.

Do you know what actually make the traffic stop,
TX queue hung or RX queue hung?

> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> index 1b08b01db27b..9c102a501ee6 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
> @@ -263,9 +263,9 @@ EXPORT_SYMBOL_GPL(rt2x00lib_dmastart);
> 
>  void rt2x00lib_dmadone(struct queue_entry *entry)
>  {
> -	set_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags);
>  	clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags);
>  	rt2x00queue_index_inc(entry, Q_INDEX_DMA_DONE);
> +	set_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags);

Unfortunately I do not understand how this suppose to fix the problem,
could you elaborate more about this change?

Stanislaw
