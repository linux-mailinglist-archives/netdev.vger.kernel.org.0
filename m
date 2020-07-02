Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCFF211748
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 02:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgGBAji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 20:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgGBAji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 20:39:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AD6C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 17:39:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C742F14E50EAA;
        Wed,  1 Jul 2020 17:39:37 -0700 (PDT)
Date:   Wed, 01 Jul 2020 17:39:37 -0700 (PDT)
Message-Id: <20200701.173937.1752547109483796808.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, kafai@fb.com, willemb@google.com
Subject: Re: [PATCH net] ip: Fix SO_MARK in RST, ACK and ICMP packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200701200006.2414835-1-willemdebruijn.kernel@gmail.com>
References: <20200701200006.2414835-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 17:39:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Wed,  1 Jul 2020 16:00:06 -0400

> From: Willem de Bruijn <willemb@google.com>
> 
> When no full socket is available, skbs are sent over a per-netns
> control socket. Its sk_mark is temporarily adjusted to match that
> of the real (request or timewait) socket or to reflect an incoming
> skb, so that the outgoing skb inherits this in __ip_make_skb.
> 
> Introduction of the socket cookie mark field broke this. Now the
> skb is set through the cookie and cork:
> 
> <caller>		# init sockc.mark from sk_mark or cmsg
> ip_append_data
>   ip_setup_cork		# convert sockc.mark to cork mark
> ip_push_pending_frames
>   ip_finish_skb
>     __ip_make_skb	# set skb->mark to cork mark
> 
> But I missed these special control sockets. Update all callers of
> __ip(6)_make_skb that were originally missed.
> 
> For IPv6, the same two icmp(v6) paths are affected. The third
> case is not, as commit 92e55f412cff ("tcp: don't annotate
> mark on control socket from tcp_v6_send_response()") replaced
> the ctl_sk->sk_mark with passing the mark field directly as a
> function argument. That commit predates the commit that
> introduced the bug.
> 
> Fixes: c6af0c227a22 ("ip: support SO_MARK cmsg")
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> Reported-by: Martin KaFai Lau <kafai@fb.com>

Applied and queued up for -stable, thanks.
