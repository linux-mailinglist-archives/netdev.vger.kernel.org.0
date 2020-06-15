Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281BF1FA1EC
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 22:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731590AbgFOUqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 16:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731403AbgFOUqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 16:46:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F96CC061A0E;
        Mon, 15 Jun 2020 13:46:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A96951210A401;
        Mon, 15 Jun 2020 13:46:41 -0700 (PDT)
Date:   Mon, 15 Jun 2020 13:46:40 -0700 (PDT)
Message-Id: <20200615.134640.514632878913727284.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com, vinicius.gomes@intel.com
Subject: Re: [PATCH net] net: dsa: sja1105: fix PTP timestamping with large
 tc-taprio cycles
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200614205409.1580736-1-olteanv@gmail.com>
References: <20200614205409.1580736-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 13:46:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 14 Jun 2020 23:54:09 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> It isn't actually described clearly at all in UM10944.pdf, but on TX of
> a management frame (such as PTP), this needs to happen:
> 
> - The destination MAC address (i.e. 01-80-c2-00-00-0e), along with the
>   desired destination port, need to be installed in one of the 4
>   management slots of the switch, over SPI.
> - The host can poll over SPI for that management slot's ENFPORT field.
>   That gets unset when the switch has matched the slot to the frame.
> 
> And therein lies the problem. ENFPORT does not mean that the packet has
> been transmitted. Just that it has been received over the CPU port, and
> that the mgmt slot is yet again available.
> 
> This is relevant because of what we are doing in sja1105_ptp_txtstamp_skb,
> which is called right after sja1105_mgmt_xmit. We are in a hard
> real-time deadline, since the hardware only gives us 24 bits of TX
> timestamp, so we need to read the full PTP clock to reconstruct it.
> Because we're in a hurry (in an attempt to make sure that we have a full
> 64-bit PTP time which is as close as possible to the actual transmission
> time of the frame, to avoid 24-bit wraparounds), first we read the PTP
> clock, then we poll for the TX timestamp to become available.
> 
> But of course, we don't know for sure that the frame has been
> transmitted when we read the full PTP clock. We had assumed that ENFPORT
> means it has, but the assumption is incorrect. And while in most
> real-life scenarios this has never been caught due to software delays,
> nowhere is this fact more obvious than with a tc-taprio offload, where
> PTP traffic gets a small timeslot very rarely (example: 1 packet per 10
> ms). In that case, we will be reading the PTP clock for timestamp
> reconstruction too early (before the packet has been transmitted), and
> this renders the reconstruction procedure incorrect (see the assumptions
> described in the comments found on function sja1105_tstamp_reconstruct).
> So the PTP TX timestamps will be off by 1<<24 clock ticks, or 135 ms
> (1 tick is 8 ns).
> 
> So fix this case of premature optimization by simply reordering the
> sja1105_ptpegr_ts_poll and the sja1105_ptpclkval_read function calls. It
> turns out that in practice, the 135 ms hard deadline for PTP timestamp
> wraparound is not so hard, since even the most bandwidth-intensive PTP
> profiles, such as 802.1AS-2011, have a sync frame interval of 125 ms.
> So if we couldn't deliver a timestamp in 135 ms (which we can), we're
> toast and have much bigger problems anyway.
> 
> Fixes: 47ed985e97f5 ("net: dsa: sja1105: Add logic for TX timestamping")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied and queued up for -stable, thank you.
