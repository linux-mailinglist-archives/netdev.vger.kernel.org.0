Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FCB2D4F3E
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 01:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgLJAOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 19:14:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728504AbgLJAOp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 19:14:45 -0500
Date:   Wed, 9 Dec 2020 16:14:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607559245;
        bh=JPstNk/oe7WzMO6f5p2J9fVuUcSsF9hnd+qabOBwt0k=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=pFwUrNXFzttOR9G0G6jSRRb1uWsLqHzW9kBxSnxx0002QZgGbwnGT6vWjoj29tI1I
         mynblERU4hqNUu8Ad9AkGTG1/RQkRJzGbvIj3Mjn9R+fJ3Kzn2E2h2WH2rTMZ+TRPC
         hmjEe3AqgdR58EBB7biIF0CFvMk40NuEZ+PL4Opc7Lm3EpXzQy4aVF/u3eXPm6nhZK
         vT5Yd1Li7K9uwZYcoQdASDoQGl5n9X6h4hwo5Mtu5p+x+Fg4i4q21caE6VaaMM6hvR
         aEXxfqlwhMxn3f7pbZwMXTJ8Fvew6A9voxqLejqA0m9u4F0TAPizXFo7+v06ryNknQ
         DPnQgQvtsrTng==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Neal Cardwell <ncardwell.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>,
        Ingemar Johansson <ingemar.s.johansson@ericsson.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] tcp: fix cwnd-limited bug for TSO deferral where we
 send nothing
Message-ID: <20201209161403.47177093@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201209035759.1225145-1-ncardwell.kernel@gmail.com>
References: <20201209035759.1225145-1-ncardwell.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Dec 2020 22:57:59 -0500 Neal Cardwell wrote:
> From: Neal Cardwell <ncardwell@google.com>
> 
> When cwnd is not a multiple of the TSO skb size of N*MSS, we can get
> into persistent scenarios where we have the following sequence:
> 
> (1) ACK for full-sized skb of N*MSS arrives
>   -> tcp_write_xmit() transmit full-sized skb with N*MSS
>   -> move pacing release time forward
>   -> exit tcp_write_xmit() because pacing time is in the future  
> 
> (2) TSQ callback or TCP internal pacing timer fires
>   -> try to transmit next skb, but TSO deferral finds remainder of  
>      available cwnd is not big enough to trigger an immediate send
>      now, so we defer sending until the next ACK.
> 
> (3) repeat...
> 
> So we can get into a case where we never mark ourselves as
> cwnd-limited for many seconds at a time, even with
> bulk/infinite-backlog senders, because:
> 
> o In case (1) above, every time in tcp_write_xmit() we have enough
> cwnd to send a full-sized skb, we are not fully using the cwnd
> (because cwnd is not a multiple of the TSO skb size). So every time we
> send data, we are not cwnd limited, and so in the cwnd-limited
> tracking code in tcp_cwnd_validate() we mark ourselves as not
> cwnd-limited.
> 
> o In case (2) above, every time in tcp_write_xmit() that we try to
> transmit the "remainder" of the cwnd but defer, we set the local
> variable is_cwnd_limited to true, but we do not send any packets, so
> sent_pkts is zero, so we don't call the cwnd-limited logic to update
> tp->is_cwnd_limited.
> 
> Fixes: ca8a22634381 ("tcp: make cwnd-limited checks measurement-based, and gentler")
> Reported-by: Ingemar Johansson <ingemar.s.johansson@ericsson.com>
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Yuchung Cheng <ycheng@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thank you!
