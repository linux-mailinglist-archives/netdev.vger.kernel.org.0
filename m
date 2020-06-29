Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDB720DB8D
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388900AbgF2UHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732034AbgF2UHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:07:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B20C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 13:07:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B0A161211B461;
        Mon, 29 Jun 2020 13:07:33 -0700 (PDT)
Date:   Mon, 29 Jun 2020 13:07:31 -0700 (PDT)
Message-Id: <20200629.130731.932623918439489841.davem@davemloft.net>
To:     tobias@waldekranz.com
Cc:     netdev@vger.kernel.org, fugang.duan@nxp.com
Subject: Re: [PATCH net] net: ethernet: fec: prevent tx starvation under
 high rx load
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200629191601.5169-1-tobias@waldekranz.com>
References: <20200629191601.5169-1-tobias@waldekranz.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jun 2020 13:07:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>
Date: Mon, 29 Jun 2020 21:16:01 +0200

> In the ISR, we poll the event register for the queues in need of
> service and then enter polled mode. After this point, the event
> register will never be read again until we exit polled mode.
> 
> In a scenario where a UDP flow is routed back out through the same
> interface, i.e. "router-on-a-stick" we'll typically only see an rx
> queue event initially. Once we start to process the incoming flow
> we'll be locked polled mode, but we'll never clean the tx rings since
> that event is never caught.
> 
> Eventually the netdev watchdog will trip, causing all buffers to be
> dropped and then the process starts over again.
> 
> By adding a poll of the active events at each NAPI call, we avoid the
> starvation.
> 
> Fixes: 4d494cdc92b3 ("net: fec: change data structure to support multiqueue")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

I don't see how this can happen since you process the TX queue
unconditionally every NAPI pass, regardless of what bits you see
set in the IEVENT register.

Or don't you?  Oh, I see, you don't:

	for_each_set_bit(queue_id, &fep->work_tx, FEC_ENET_MAX_TX_QS) {

That's the problem.  Just unconditionally process the TX work regardless
of what is in IEVENT.  That whole ->tx_work member and the code that
uses it can just be deleted.  fec_enet_collect_events() can just return
a boolean saying whether there is any RX or TX work at all.

Than you're performance and latency will be even better in this situation.
