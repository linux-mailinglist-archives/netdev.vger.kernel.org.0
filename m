Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD971E70D3
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437838AbgE1Xwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437692AbgE1Xwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 19:52:40 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D9AC08C5D1
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 16:34:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5AB0A1296D81A;
        Thu, 28 May 2020 16:34:30 -0700 (PDT)
Date:   Thu, 28 May 2020 16:34:29 -0700 (PDT)
Message-Id: <20200528.163429.484731339357929160.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, willemb@google.com
Subject: Re: [PATCH net] net: be more gentle about silly gso requests
 coming from user
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528215747.45306-1-edumazet@google.com>
References: <20200528215747.45306-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 May 2020 16:34:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 28 May 2020 14:57:47 -0700

> Recent change in virtio_net_hdr_to_skb() broke some packetdrill tests.
> 
> When --mss=XXX option is set, packetdrill always provide gso_type & gso_size
> for its inbound packets, regardless of packet size.
> 
> 	if (packet->tcp && packet->mss) {
> 		if (packet->ipv4)
> 			gso.gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
> 		else
> 			gso.gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
> 		gso.gso_size = packet->mss;
> 	}
> 
> Since many other programs could do the same, relax virtio_net_hdr_to_skb()
> to no longer return an error, but instead ignore gso settings.
> 
> This keeps Willem intent to make sure no malicious packet could
> reach gso stack.
> 
> Note that TCP stack has a special logic in tcp_set_skb_tso_segs()
> to clear gso_size for small packets.
> 
> Fixes: 6dd912f82680 ("net: check untrusted gso_size at kernel entry")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable, thanks Eric.
