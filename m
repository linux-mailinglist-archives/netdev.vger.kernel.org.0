Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2004D3317D1
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 20:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhCHTxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 14:53:55 -0500
Received: from mga07.intel.com ([134.134.136.100]:40738 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231426AbhCHTxu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 14:53:50 -0500
IronPort-SDR: Kia6pkWHF9QlsnS0tYJ8kdg/bgUKzJ4pxQ5WPlluw4ydezsggV9AWDdKxIQVLY/HKtHfzL2mmp
 hA9aGHU2FMHg==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="252125059"
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="252125059"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 11:53:48 -0800
IronPort-SDR: eLeUWQTJcOuGwgGEq35nw1nryzXoWu/YGiF/SwMBYV3CTVBfrE3ZNYSIYGJ+w/js/TAsgFoj/i
 VfJwHYDZhnag==
X-IronPort-AV: E=Sophos;i="5.81,233,1610438400"; 
   d="scan'208";a="588168498"
Received: from tpotnis-mobl1.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.209.20.19])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 11:53:49 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net 2/2] net: enetc: allow hardware timestamping on TX
 queues with tc-etf enabled
In-Reply-To: <20210307132339.2320009-2-olteanv@gmail.com>
References: <20210307132339.2320009-1-olteanv@gmail.com>
 <20210307132339.2320009-2-olteanv@gmail.com>
Date:   Mon, 08 Mar 2021 11:53:47 -0800
Message-ID: <87tuplmng4.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> The txtime is passed to the driver in skb->skb_mstamp_ns, which is
> actually in a union with skb->tstamp (the place where software
> timestamps are kept).
>
> Since commit b50a5c70ffa4 ("net: allow simultaneous SW and HW transmit
> timestamping"), __sock_recv_timestamp has some logic for making sure
> that the two calls to skb_tstamp_tx:
>
> skb_tx_timestamp(skb) # Software timestamp in the driver
> -> skb_tstamp_tx(skb, NULL)
>
> and
>
> skb_tstamp_tx(skb, &shhwtstamps) # Hardware timestamp in the driver
>
> will both do the right thing and in a race-free manner, meaning that
> skb_tx_timestamp will deliver a cmsg with the software timestamp only,
> and skb_tstamp_tx with a non-NULL hwtstamps argument will deliver a cmsg
> with the hardware timestamp only.
>
> Why are races even possible? Well, because although the software timestamp
> skb->tstamp is private per skb, the hardware timestamp skb_hwtstamps(skb)
> lives in skb_shinfo(skb), an area which is shared between skbs and their
> clones. And skb_tstamp_tx works by cloning the packets when timestamping
> them, therefore attempting to perform hardware timestamping on an skb's
> clone will also change the hardware timestamp of the original skb. And
> the original skb might have been yet again cloned for software
> timestamping, at an earlier stage.
>
> So the logic in __sock_recv_timestamp can't be as simple as saying
> "does this skb have a hardware timestamp? if yes I'll send the hardware
> timestamp to the socket, otherwise I'll send the software timestamp",
> precisely because the hardware timestamp is shared.
> Instead, it's quite the other way around: __sock_recv_timestamp says
> "does this skb have a software timestamp? if yes, I'll send the software
> timestamp, otherwise the hardware one". This works because the software
> timestamp is not shared with clones.
>
> But that means we have a problem when we attempt hardware timestamping
> with skbs that don't have the skb->tstamp == 0. __sock_recv_timestamp
> will say "oh, yeah, this must be some sort of odd clone" and will not
> deliver the hardware timestamp to the socket. And this is exactly what
> is happening when we have txtime enabled on the socket: as mentioned,
> that is put in a union with skb->tstamp, so it is quite easy to mistake
> it.

Great write up :-)

I know first person the time/effort that went on debugging this.

What do you think of introducing a helper, something like:

skb_txtime_consumed()

to make it even clearer what's going on.

>
> Do what other drivers do (intel igb/igc) and write zero to skb->tstamp
> before taking the hardware timestamp. It's of no use to us now (we're
> already on the TX confirmation path).
>
> Fixes: 0d08c9ec7d6e ("enetc: add support time specific departure base on the qos etf")
> Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Anyway,

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


Cheers,
-- 
Vinicius
