Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99DC75BA53
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 13:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbfGALHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 07:07:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50878 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727645AbfGALHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 07:07:35 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8162D308FBAF;
        Mon,  1 Jul 2019 11:07:35 +0000 (UTC)
Received: from localhost (ovpn-204-140.brq.redhat.com [10.40.204.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 227826F92F;
        Mon,  1 Jul 2019 11:07:34 +0000 (UTC)
Date:   Mon, 1 Jul 2019 13:07:34 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Soeren Moch <smoch@web.de>
Cc:     stable@vger.kernel.org, Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] rt2x00usb: fix rx queue hang
Message-ID: <20190701110733.GA13992@redhat.com>
References: <20190701105314.9707-1-smoch@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701105314.9707-1-smoch@web.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 01 Jul 2019 11:07:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 12:53:13PM +0200, Soeren Moch wrote:
> Since commit ed194d136769 ("usb: core: remove local_irq_save() around
>  ->complete() handler") the handler rt2x00usb_interrupt_rxdone() is
> not running with interrupts disabled anymore. So this completion handler
> is not guaranteed to run completely before workqueue processing starts
> for the same queue entry.
> Be sure to set all other flags in the entry correctly before marking
> this entry ready for workqueue processing. This way we cannot miss error
> conditions that need to be signalled from the completion handler to the
> worker thread.
> Note that rt2x00usb_work_rxdone() processes all available entries, not
> only such for which queue_work() was called.
> 
> This patch is similar to what commit df71c9cfceea ("rt2x00: fix order
> of entry flags modification") did for TX processing.
> 
> This fixes a regression on a RT5370 based wifi stick in AP mode, which
> suddenly stopped data transmission after some period of heavy load. Also
> stopping the hanging hostapd resulted in the error message "ieee80211
> phy0: rt2x00queue_flush_queue: Warning - Queue 14 failed to flush".
> Other operation modes are probably affected as well, this just was
> the used testcase.
> 
> Fixes: ed194d136769 ("usb: core: remove local_irq_save() around ->complete() handler")
> Cc: stable@vger.kernel.org # 4.20+
> Signed-off-by: Soeren Moch <smoch@web.de>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>


