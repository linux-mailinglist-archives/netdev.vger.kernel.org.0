Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64FAC351A25
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbhDAR60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:58:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37937 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236607AbhDARyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:54:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GhP9mKAC835udYamk6sLlCgw3JJRwFbPZGXQbpeFSwU=;
        b=U04udFiDiAWsvg2mMU4C/X9Ad6o9OafLFy1WJkymhwUWf3yVAuy9SQdP1/DUyVp7YiR45e
        DB8wH+WOlFY0IuSMN9GnG+dwSDccokrGsOEqjC9zMpgB5o3V8hHGboc7ysw/tGmwasK/3j
        dptk7h4cHmrJz6+cftgLjRnd8GwT9Zg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-dz0J8KJfP2CVKb8yctgc0Q-1; Thu, 01 Apr 2021 08:54:23 -0400
X-MC-Unique: dz0J8KJfP2CVKb8yctgc0Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6E55801814;
        Thu,  1 Apr 2021 12:54:20 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-112-58.rdu2.redhat.com [10.10.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21230614FC;
        Thu,  1 Apr 2021 12:54:18 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20210401093545.4055-1-lyl2019@mail.ustc.edu.cn>
References: <20210401093545.4055-1-lyl2019@mail.ustc.edu.cn>
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc:     dhowells@redhat.com, davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/rxrpc: Fix a use after free in rxrpc_input_packet
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3723091.1617281658.1@warthog.procyon.org.uk>
Date:   Thu, 01 Apr 2021 13:54:18 +0100
Message-ID: <3723092.1617281658@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lv Yunlong <lyl2019@mail.ustc.edu.cn> wrote:

> In the case RXRPC_PACKET_TYPE_DATA of rxrpc_input_packet, if
> skb_unshare(skb,..) failed, it will free the skb and return NULL.
> But if skb_unshare() return NULL, the freed skb will be used by
> rxrpc_eaten_skb(skb,..).

That's not precisely the case:

	void rxrpc_eaten_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
	{
		const void *here = __builtin_return_address(0);
		int n = atomic_inc_return(&rxrpc_n_rx_skbs);
		trace_rxrpc_skb(skb, op, 0, n, 0, here);
	}

The only thing that happens to skb here is that it's passed to
trace_rxrpc_skb(), but that doesn't dereference it either.  The *address* is
used for display purposes, but that's all.

> I see that rxrpc_eaten_skb() is used to drop a ref of skb.

It isn't.

> As the skb is already freed in skb_unshare() on error, my patch removes the
> rxrpc_eaten_skb() to avoid the uaf.

But you remove the accounting, which might lead to an assertion failure in
af_rxrpc_exit().

That said, rxrpc_eaten_skb() should probably decrement rxrpc_n_rx_skbs, not
increment it...

David

