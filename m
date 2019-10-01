Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869FFC2B41
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 02:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731781AbfJAAWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 20:22:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40538 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727850AbfJAAWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 20:22:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7D289154F6393;
        Mon, 30 Sep 2019 17:22:01 -0700 (PDT)
Date:   Mon, 30 Sep 2019 17:22:01 -0700 (PDT)
Message-Id: <20190930.172201.1744857425959169580.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: sja1105: Ensure PTP time for rxtstamp
 reconstruction is not in the past
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190928220817.24002-1-olteanv@gmail.com>
References: <20190928220817.24002-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Sep 2019 17:22:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 29 Sep 2019 01:08:17 +0300

> Sometimes the PTP synchronization on the switch 'jumps':
 ...
> Background: the switch only offers partial RX timestamps (24 bits) and
> it is up to the driver to read the PTP clock to fill those timestamps up
> to 64 bits. But the PTP clock readout needs to happen quickly enough (in
> 0.135 seconds, in fact), otherwise the PTP clock will wrap around 24
> bits, condition which cannot be detected.
> 
> Looking at the 'max 134217731' value on output line 3, one can see that
> in hex it is 0x8000003. Because the PTP clock resolution is 8 ns,
> that means 0x1000000 in ticks, which is exactly 2^24. So indeed this is
> a PTP clock wraparound, but the reason might be surprising.
> 
> What is going on is that sja1105_tstamp_reconstruct(priv, now, ts)
> expects a "now" time that is later than the "ts" was snapshotted at.
> This, of course, is obvious: we read the PTP time _after_ the partial RX
> timestamp was received. However, the workqueue is processing frames from
> a skb queue and reuses the same PTP time, read once at the beginning.
> Normally the skb queue only contains one frame and all goes well. But
> when the skb queue contains two frames, the second frame that gets
> dequeued might have been partially timestamped by the RX MAC _after_ we
> had read our PTP time initially.
> 
> The code was originally like that due to concerns that SPI access for
> PTP time readout is a slow process, and we are time-constrained anyway
> (aka: premature optimization). But some timing analysis reveals that the
> time spent until the RX timestamp is completely reconstructed is 1 order
> of magnitude lower than the 0.135 s deadline even under worst-case
> conditions. So we can afford to read the PTP time for each frame in the
> RX timestamping queue, which of course ensures that the full PTP time is
> in the partial timestamp's future.
> 
> Fixes: f3097be21bf1 ("net: dsa: sja1105: Add a state machine for RX timestamping")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied and queued up for -stable, thanks.
