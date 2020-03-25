Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3178192792
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 12:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbgCYLwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 07:52:19 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:57871 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726313AbgCYLwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 07:52:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585137139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PBZkzrTe8hsWABY61jl0I0I4VYbXO2XzznSQcF07yms=;
        b=gwd7ijpmY4ZCPr7hD6hTqYVRh+k/HwfN6y94zV99Fcz3XlAdi0veUCF0zJoWh97Fq0O33t
        q+l5akE6VqWWY4c7Hgtsn4h8BPgwY4GSFOhdjRkKHruiOPHeU5WkXFvesoqw2FLrbzvmfT
        VhgqphauvbYjZXWYfv3apqIRArN2scM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-r-Wh4TwsP6CoCr9lTjP60g-1; Wed, 25 Mar 2020 07:52:15 -0400
X-MC-Unique: r-Wh4TwsP6CoCr9lTjP60g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 613978017CE;
        Wed, 25 Mar 2020 11:52:14 +0000 (UTC)
Received: from ovpn-114-87.ams2.redhat.com (ovpn-114-87.ams2.redhat.com [10.36.114.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E296C5DA7C;
        Wed, 25 Mar 2020 11:52:12 +0000 (UTC)
Message-ID: <ace8e72488fbf2473efaed9fc0680886897939ab.camel@redhat.com>
Subject: Re: [PATCH net-next] net: use indirect call wrappers for
 skb_copy_datagram_iter()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Date:   Wed, 25 Mar 2020 12:52:11 +0100
In-Reply-To: <20200325022321.21944-1-edumazet@google.com>
References: <20200325022321.21944-1-edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-03-24 at 19:23 -0700, Eric Dumazet wrote:
> TCP recvmsg() calls skb_copy_datagram_iter(), which
> calls an indirect function (cb pointing to simple_copy_to_iter())
> for every MSS (fragment) present in the skb.
> 
> CONFIG_RETPOLINE=y forces a very expensive operation
> that we can avoid thanks to indirect call wrappers.
> 
> This patch gives a 13% increase of performance on
> a single flow, if the bottleneck is the thread reading
> the TCP socket.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/core/datagram.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/datagram.c b/net/core/datagram.c
> index 4213081c6ed3d4fda69501641a8c76e041f26b42..639745d4f3b94a248da9a685f45158410a85bec7 100644
> --- a/net/core/datagram.c
> +++ b/net/core/datagram.c
> @@ -51,6 +51,7 @@
>  #include <linux/slab.h>
>  #include <linux/pagemap.h>
>  #include <linux/uio.h>
> +#include <linux/indirect_call_wrapper.h>
>  
>  #include <net/protocol.h>
>  #include <linux/skbuff.h>
> @@ -403,6 +404,11 @@ int skb_kill_datagram(struct sock *sk, struct sk_buff *skb, unsigned int flags)
>  }
>  EXPORT_SYMBOL(skb_kill_datagram);
>  
> +INDIRECT_CALLABLE_DECLARE(static size_t simple_copy_to_iter(const void *addr,
> +						size_t bytes,
> +						void *data __always_unused,
> +						struct iov_iter *i));
> +
>  static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
>  			       struct iov_iter *to, int len, bool fault_short,
>  			       size_t (*cb)(const void *, size_t, void *,
> @@ -416,7 +422,8 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
>  	if (copy > 0) {
>  		if (copy > len)
>  			copy = len;
> -		n = cb(skb->data + offset, copy, data, to);
> +		n = INDIRECT_CALL_1(cb, simple_copy_to_iter,
> +				    skb->data + offset, copy, data, to);
>  		offset += n;
>  		if (n != copy)
>  			goto short_copy;
> @@ -438,8 +445,9 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
>  
>  			if (copy > len)
>  				copy = len;
> -			n = cb(vaddr + skb_frag_off(frag) + offset - start,
> -			       copy, data, to);
> +			n = INDIRECT_CALL_1(cb, simple_copy_to_iter,
> +					vaddr + skb_frag_off(frag) + offset - start,
> +					copy, data, to);
>  			kunmap(page);
>  			offset += n;
>  			if (n != copy)

I wondered if we could add a second argument for
'csum_and_copy_to_iter', but I guess that is a slower path anyway and
more datapoint would be needed. The patch LGTM, thanks!

Acked-by: Paolo Abeni <pabeni@redhat.com>

