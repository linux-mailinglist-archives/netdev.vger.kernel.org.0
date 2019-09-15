Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0699DB3166
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 20:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfIOShH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 14:37:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39946 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfIOShH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 14:37:07 -0400
Received: from localhost (93-63-141-166.ip28.fastwebnet.it [93.63.141.166])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EC76A153E7601;
        Sun, 15 Sep 2019 11:37:05 -0700 (PDT)
Date:   Sun, 15 Sep 2019 19:37:04 +0100 (WEST)
Message-Id: <20190915.193704.1404390645611004194.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, dcaratti@redhat.com, shuali@redhat.com
Subject: Re: [PATCH net] net/sched: fix race between deactivation and
 dequeue for NOLOCK qdisc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <80e0c9577218090cada29e4adc9ec116f591cb6f.1568113414.git.pabeni@redhat.com>
References: <80e0c9577218090cada29e4adc9ec116f591cb6f.1568113414.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Sep 2019 11:37:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Thu, 12 Sep 2019 12:02:42 +0200

> The test implemented by some_qdisc_is_busy() is somewhat loosy for
> NOLOCK qdisc, as we may hit the following scenario:
> 
> CPU1						CPU2
> // in net_tx_action()
> clear_bit(__QDISC_STATE_SCHED...);
> 						// in some_qdisc_is_busy()
> 						val = (qdisc_is_running(q) ||
> 						       test_bit(__QDISC_STATE_SCHED,
> 								&q->state));
> 						// here val is 0 but...
> qdisc_run(q)
> // ... CPU1 is going to run the qdisc next
> 
> As a conseguence qdisc_run() in net_tx_action() can race with qdisc_reset()
> in dev_qdisc_reset(). Such race is not possible for !NOLOCK qdisc as
> both the above bit operations are under the root qdisc lock().
> 
> After commit 021a17ed796b ("pfifo_fast: drop unneeded additional lock on dequeue") 
> the race can cause use after free and/or null ptr dereference, but the root 
> cause is likely older.
> 
> This patch addresses the issue explicitly checking for deactivation under
> the seqlock for NOLOCK qdisc, so that the qdisc_run() in the critical
> scenario becomes a no-op.
> 
> Note that the enqueue() op can still execute concurrently with dev_qdisc_reset(),
> but that is safe due to the skb_array() locking, and we can't avoid that
> for NOLOCK qdiscs.
> 
> Fixes: 021a17ed796b ("pfifo_fast: drop unneeded additional lock on dequeue")
> Reported-by: Li Shuang <shuali@redhat.com>
> Reported-and-tested-by: Davide Caratti <dcaratti@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied and queued up for -stable, thanks.
