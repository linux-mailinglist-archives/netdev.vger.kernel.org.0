Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1993A325BDA
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 04:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhBZDQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 22:16:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:58024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229460AbhBZDQe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 22:16:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB0D464EDB;
        Fri, 26 Feb 2021 03:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614309354;
        bh=IK0iYlOABB2uU2EsG6JO8k7sUPjNzI2hbvA5B/2cXc0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DC1Eo9+qnAbA/3CE1CmAzxi4o4PaKvWcrqMOOUI5iSicBbZfvsYV0ULn3QybVgggN
         7tdNjd+V2s2GXD8HyF3uBsWImLXvvM7A0PFYB+4448VOYUaHrkiwV//ZUk32D28YpZ
         RCHzyuWuowOUbiaDvg38dAmuGQA0q5m50UdFTVuLDjAJjYHVpwI7fFwttVvW6LXze/
         eWD6lduX179OhKs+OWBIpFRprZq3Qznn1hDNApq8eEf3Vcj/f4O5/auhhdy7ZXzNMm
         oA0sxp3wH2BE+LpY2pSFQCzKGUN0rX2UM0wMFx90P6eg9NMkvtGOYyTdaqe8yOxoSv
         BH6NlF/OELGXA==
Date:   Thu, 25 Feb 2021 19:15:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: Spurious TCP retransmissions on ack vs kfree_skb reordering
Message-ID: <20210225191552.19b36496@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210225152515.2072b5a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210225152515.2072b5a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Feb 2021 15:25:15 -0800 Jakub Kicinski wrote:
> Hi!
> 
> We see large (4-8x) increase of what looks like TCP RTOs after rising 
> the Tx coalescing above Rx coalescing timeout.
> 
> Quick tracing of the events seems to indicate that the data has already
> been acked when we enter tcp:tcp_retransmit_skb:

Seems like I'm pretty lost here and the tcp:tcp_retransmit_skb events
are less spurious than I thought. Looking at some tcpdump traces we see:

0.045277 IP6 A > B: Flags [SEW], seq 2248382925:2248383296, win 61920, options [mss 1440,sackOK,TS val 658870494 ecr 0,nop,wscale 11], length 371

0.045348 IP6 B > A: Flags [S.E], seq 961169456, ack 2248382926, win 65535, options [mss 1440,sackOK,TS val 883864022 ecr 658870494,nop,wscale 9], length 0

0.045369 IP6 A > B: Flags [P.], seq 1:372, ack 1, win 31, options [nop,nop,TS val 658870494 ecr 883864022], length 371


So looks potentially TFO related?

To try to count timeouts I run:

bpftrace --btf -e 'tracepoint:tcp:tcp_retransmit_skb { 
  $icsk = (struct inet_connection_sock *)args->skaddr; 
  if ($icsk->icsk_ca_state != 4) { return; } 
  if ($icsk->icsk_pending)       { return; }

  printf(...);
}'

At tx-usecs coalescing of 25us I see 0 of those events.
At 100us there is a few.
At 200us there is a lot.
