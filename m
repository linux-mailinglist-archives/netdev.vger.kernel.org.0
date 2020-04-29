Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166861BE784
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgD2TjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726775AbgD2Ti7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:38:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB65C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 12:38:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 31D061210A3E3;
        Wed, 29 Apr 2020 12:38:59 -0700 (PDT)
Date:   Wed, 29 Apr 2020 12:38:58 -0700 (PDT)
Message-Id: <20200429.123858.1029931066495916083.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] ionic: add LIF_READY state to close probe-open
 race
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429183739.56540-2-snelson@pensando.io>
References: <20200429183739.56540-1-snelson@pensando.io>
        <20200429183739.56540-2-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Apr 2020 12:38:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Wed, 29 Apr 2020 11:37:38 -0700

> Add a bit of state to the lif to signify when the queues are
> ready to be used.  This closes an ionic_probe()/ionic_open()
> race condition where the driver has registered the netdev
> and signaled Link Up while running under ionic_probe(),
> which NetworkManager or other user processes can see and then
> try to bring up the device before the initial pass through
> ionic_link_status_check() has finished.  NetworkManager's
> thread can get into __dev_open() and set __LINK_STATE_START
> in dev->state before the ionic_probe() thread makes it to the
> netif_running() check, which results in the ionic_probe() thread
> trying to start the queues before the queues have completed
> their initialization.
> 
> Adding a LIF_QREADY flag allows us to prevent this condition by
> signaling whether the Tx/Rx queues are initialized and ready.
> 
> Fixes: c672412f6172 ("ionic: remove lifs on fw reset")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

I would rather you fix this by adjusting the visibility.

You should only call register_netdevice() when all of the device
setup and software state initialization is complete.

This improper ordering is the true cause of this bug and adding
this new boolean state is simply papering over the core issue.

Thanks.
