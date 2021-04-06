Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7B4355FAB
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 01:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245187AbhDFXo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 19:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbhDFXo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 19:44:57 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5F7C06174A;
        Tue,  6 Apr 2021 16:44:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 41B2B4D2493AB;
        Tue,  6 Apr 2021 16:44:47 -0700 (PDT)
Date:   Tue, 06 Apr 2021 16:44:46 -0700 (PDT)
Message-Id: <20210406.164446.1369320471860255483.davem@davemloft.net>
To:     gatis@mikrotik.com
Cc:     chris.snook@gmail.com, kuba@kernel.org, hkallweit1@gmail.com,
        jesse.brandeburg@intel.com, dchickles@marvell.com,
        tully@mikrotik.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4] atl1c: move tx cleanup processing out of
 interrupt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c8327d4bb516dd4741878c64fa6485cd@mikrotik.com>
References: <c8327d4bb516dd4741878c64fa6485cd@mikrotik.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 06 Apr 2021 16:44:47 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gatis Peisenieks <gatis@mikrotik.com>
Date: Tue, 06 Apr 2021 17:49:32 +0300

> Tx queue cleanup happens in interrupt handler on same core as rx queue
> processing. Both can take considerable amount of processing in high
> packet-per-second scenarios.
> 
> Sending big amounts of packets can stall the rx processing which is
> unfair
> and also can lead to out-of-memory condition since __dev_kfree_skb_irq
> queues the skbs for later kfree in softirq which is not allowed to
> happen
> with heavy load in interrupt handler.
> 
> This puts tx cleanup in its own napi and enables threaded napi to
> allow
> the rx/tx queue processing to happen on different cores. Also as the
> first
> in-driver user of dev_set_threaded API, need to add EXPORT_SYMBOL for
> it.
> 
> The ability to sustain equal amounts of tx/rx traffic increased:
> from 280Kpps to 1130Kpps on Threadripper 3960X with upcoming
> Mikrotik 10/25G NIC,
> from 520Kpps to 850Kpps on Intel i3-3320 with Mikrotik RB44Ge adapter.
> 
> Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
> ---
> changes since v3:
> 	- made scripts/checkpatch.pl happy (commit message line wrap +
> 	  missing comment on spinlock)
> 	- moved the new intr_mask_lock to be besides the intr_mask it
> 	  protects so they are more likely to be on same cacheline
> changes since v2:
> 	- addressed comments from Eric Dumazet
> 	- added EXPORT_SYMBOL for dev_set_threaded
> 
> Sorry for reposting, noticed that scripts/checkpatch.pl was not happy.

This does not apply to 'net',  did you mean 'net-next'?  If so, please indicate this clearly in
the Subject line as per convention.

Thank you.
