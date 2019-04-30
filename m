Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02352EF28
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 05:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbfD3DVb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Apr 2019 23:21:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35282 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729931AbfD3DVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 23:21:31 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 379DA133FCD58;
        Mon, 29 Apr 2019 20:21:30 -0700 (PDT)
Date:   Mon, 29 Apr 2019 23:21:29 -0400 (EDT)
Message-Id: <20190429.232129.805928152726012679.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        richard.purdie@linuxfoundation.org, bonbons@sysophe.eu
Subject: Re: [PATCH net] tcp: add sanity tests in tcp_add_backlog()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190426171005.172805-1-edumazet@google.com>
References: <20190426171005.172805-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Apr 2019 20:21:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 26 Apr 2019 10:10:05 -0700

> Richard and Bruno both reported that my commit added a bug,
> and Bruno was able to determine the problem came when a segment
> wih a FIN packet was coalesced to a prior one in tcp backlog queue.
> 
> It turns out the header prediction in tcp_rcv_established()
> looks back to TCP headers in the packet, not in the metadata
> (aka TCP_SKB_CB(skb)->tcp_flags)
> 
> The fast path in tcp_rcv_established() is not supposed to
> handle a FIN flag (it does not call tcp_fin())
> 
> Therefore we need to make sure to propagate the FIN flag,
> so that the coalesced packet does not go through the fast path,
> the same than a GRO packet carrying a FIN flag.
> 
> While we are at it, make sure we do not coalesce packets with
> RST or SYN, or if they do not have ACK set.
> 
> Many thanks to Richard and Bruno for pinpointing the bad commit,
> and to Richard for providing a first version of the fix.
> 
> Fixes: 4f693b55c3d2 ("tcp: implement coalescing on backlog queue")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Richard Purdie <richard.purdie@linuxfoundation.org>
> Reported-by: Bruno Prémont <bonbons@sysophe.eu>

Applied and queued up for -stable.
