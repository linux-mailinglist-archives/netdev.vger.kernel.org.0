Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047872C2D2C
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390476AbgKXQma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 11:42:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40434 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389808AbgKXQma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 11:42:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606236149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UML18iK4FeVRxgH1z30ZZ5sJxCIQ6EOKqFAoGExwoeg=;
        b=UnWdGFeWpj1wogD3Oxg5wBX6tr8WW3I+D8L9s2Rx5TZLC+kB/tpm2ftmAd+w7CcdNDFaLO
        2bhQEGxV91CIHrkZUExYjTf8qo+ECnYH6JdsWtuffub9X6cbJ02sUoJukZD0hJ2nLMrVl1
        RfmKAeTezMpFUWIkLlh0pjSCNDI4Ap0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-wliC9L8tNA6GfPrwAahZgA-1; Tue, 24 Nov 2020 11:42:24 -0500
X-MC-Unique: wliC9L8tNA6GfPrwAahZgA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4B3818C43D2;
        Tue, 24 Nov 2020 16:42:23 +0000 (UTC)
Received: from ovpn-113-119.ams2.redhat.com (ovpn-113-119.ams2.redhat.com [10.36.113.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 552C660C43;
        Tue, 24 Nov 2020 16:42:22 +0000 (UTC)
Message-ID: <e44300a0567cdec8241c06d1c6b78083cdd4254a.camel@redhat.com>
Subject: Re: [PATCH net-next] mptcp: put reference in mptcp timeout timer
From:   Paolo Abeni <pabeni@redhat.com>
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, Davide Caratti <dcaratti@redhat.com>
Date:   Tue, 24 Nov 2020 17:42:21 +0100
In-Reply-To: <20201124162446.11448-1-fw@strlen.de>
References: <20201124162446.11448-1-fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-11-24 at 17:24 +0100, Florian Westphal wrote:
> On close this timer might be scheduled. mptcp uses sk_reset_timer for
> this, so the a reference on the mptcp socket is taken.
> 
> This causes a refcount leak which can for example be reproduced
> with 'mp_join_server_v4.pkt' from the mptcp-packetdrill repo.

Whoops, my fault!

> The leak has nothing to do with join requests, v1_mp_capable_bind_no_cs.pkt
> works too when replacing the last ack mpcapable to v1 instead of v0.
> 
> unreferenced object 0xffff888109bba040 (size 2744):
>   comm "packetdrill", [..]
>   backtrace:
>     [..] sk_prot_alloc.isra.0+0x2b/0xc0
>     [..] sk_clone_lock+0x2f/0x740
>     [..] mptcp_sk_clone+0x33/0x1a0
>     [..] subflow_syn_recv_sock+0x2b1/0x690 [..]
> 
> Fixes: e16163b6e2b7 ("mptcp: refactor shutdown and close")
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Davide Caratti <dcaratti@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/mptcp/protocol.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index 4b7794835fea..dc979571f561 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -1710,6 +1710,7 @@ static void mptcp_timeout_timer(struct timer_list *t)
>  	struct sock *sk = from_timer(sk, t, sk_timer);
>  
>  	mptcp_schedule_work(sk);
> +	sock_put(sk);
>  }
>  
>  /* Find an idle subflow.  Return NULL if there is unacked data at tcp

LGTM, thanks!
Acked-by: Paolo Abeni <pabeni@redhat.com>

