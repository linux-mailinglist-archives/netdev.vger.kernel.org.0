Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC94886D77
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 00:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390022AbfHHWz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 18:55:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52810 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732796AbfHHWz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 18:55:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 549C915569111;
        Thu,  8 Aug 2019 15:55:28 -0700 (PDT)
Date:   Thu, 08 Aug 2019 15:55:27 -0700 (PDT)
Message-Id: <20190808.155527.1769176838480121461.davem@davemloft.net>
To:     gnault@redhat.com
Cc:     netdev@vger.kernel.org, fw@strlen.de, edumazet@google.com,
        posk@google.com, alex.aring@gmail.com
Subject: Re: [PATCH net] inet: frags: re-introduce skb coalescing for local
 delivery
From:   David Miller <davem@davemloft.net>
In-Reply-To: <22d8da10c97214edd0677e6478093ad9376180ef.1564758715.git.gnault@redhat.com>
References: <22d8da10c97214edd0677e6478093ad9376180ef.1564758715.git.gnault@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 15:55:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>
Date: Fri, 2 Aug 2019 17:15:03 +0200

> Before commit d4289fcc9b16 ("net: IP6 defrag: use rbtrees for IPv6
> defrag"), a netperf UDP_STREAM test[0] using big IPv6 datagrams (thus
> generating many fragments) and running over an IPsec tunnel, reported
> more than 6Gbps throughput. After that patch, the same test gets only
> 9Mbps when receiving on a be2net nic (driver can make a big difference
> here, for example, ixgbe doesn't seem to be affected).
> 
> By reusing the IPv4 defragmentation code, IPv6 lost fragment coalescing
> (IPv4 fragment coalescing was dropped by commit 14fe22e33462 ("Revert
> "ipv4: use skb coalescing in defragmentation"")).
> 
> Without fragment coalescing, be2net runs out of Rx ring entries and
> starts to drop frames (ethtool reports rx_drops_no_frags errors). Since
> the netperf traffic is only composed of UDP fragments, any lost packet
> prevents reassembly of the full datagram. Therefore, fragments which
> have no possibility to ever get reassembled pile up in the reassembly
> queue, until the memory accounting exeeds the threshold. At that point
> no fragment is accepted anymore, which effectively discards all
> netperf traffic.
> 
> When reassembly timeout expires, some stale fragments are removed from
> the reassembly queue, so a few packets can be received, reassembled
> and delivered to the netperf receiver. But the nic still drops frames
> and soon the reassembly queue gets filled again with stale fragments.
> These long time frames where no datagram can be received explain why
> the performance drop is so significant.
> 
> Re-introducing fragment coalescing is enough to get the initial
> performances again (6.6Gbps with be2net): driver doesn't drop frames
> anymore (no more rx_drops_no_frags errors) and the reassembly engine
> works at full speed.
> 
> This patch is quite conservative and only coalesces skbs for local
> IPv4 and IPv6 delivery (in order to avoid changing skb geometry when
> forwarding). Coalescing could be extended in the future if need be, as
> more scenarios would probably benefit from it.
 ...
> Signed-off-by: Guillaume Nault <gnault@redhat.com>

Applied, thanks.
