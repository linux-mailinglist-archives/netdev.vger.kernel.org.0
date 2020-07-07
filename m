Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C55217AF6
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 00:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729232AbgGGWZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 18:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbgGGWZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 18:25:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E75C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 15:25:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 80F3B120F19F2;
        Tue,  7 Jul 2020 15:25:22 -0700 (PDT)
Date:   Tue, 07 Jul 2020 15:25:21 -0700 (PDT)
Message-Id: <20200707.152521.895333419544070081.davem@davemloft.net>
To:     tobias@waldekranz.com
Cc:     netdev@vger.kernel.org, fugang.duan@nxp.com
Subject: Re: [PATCH v3 net] net: ethernet: fec: prevent tx starvation under
 high rx load
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200703141058.11320-1-tobias@waldekranz.com>
References: <20200703141058.11320-1-tobias@waldekranz.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 15:25:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>
Date: Fri,  3 Jul 2020 16:10:58 +0200

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
> Rework the NAPI poll to keep trying to consome the entire budget as
> long as new events are coming in, making sure to service all rx/tx
> queues, in priority order, on each pass.
> 
> Fixes: 4d494cdc92b3 ("net: fec: change data structure to support multiqueue")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Applied and queued up for -stable, thank you.

