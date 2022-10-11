Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27725FB0C6
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 12:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiJKKvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 06:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiJKKu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 06:50:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BE532EE1
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 03:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665485456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gA1xTwBH5RqPycM5mLkFtITn/VHkui9LBIiES9K73V0=;
        b=eAmBl+R6/SoI6jl7D4E7idIZnoFyBJ09AOMEufL6PR0nmDj75FRqvbBvwBv9FZSKjw3NX4
        0fju5Ylfmos1UEF0lHHZkHPlqlm/6q8pAcEt7ZIolnwhynUIg/EnsBQvYaYtqLRKxsATJV
        zhhaq6U3/2+t+GmUISMquC201dP3vvw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-310-ImMEUrxmNvCiCmRn_VwQFA-1; Tue, 11 Oct 2022 06:50:55 -0400
X-MC-Unique: ImMEUrxmNvCiCmRn_VwQFA-1
Received: by mail-wr1-f69.google.com with SMTP id k30-20020adfb35e000000b0022e04708c18so3725473wrd.22
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 03:50:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gA1xTwBH5RqPycM5mLkFtITn/VHkui9LBIiES9K73V0=;
        b=3WMuxESRQlVwBE9fWYS+sDDxBUvfAJ+xaqmv7YX8D2schHQSC7qPAR1H+ky0dNoYef
         qIiEU8GgSL1CedpOZLqKGubFSJHJuGKciBRkRhAJBAGsg15GhDQ6TKqG+TWGLEUD6kEO
         fD+Rpg2I++12m970jsRT2Oqu9hh8xUaLPJBd5z+Zt/ilY2yYb2EkecCuXkpuODXWUMIG
         N6572aPbnhbyjg6SpiRBoF2fvoJOLzxA/hzGfx/gIUm1Zo0sQkO0+bJzj0trEORF3xQu
         Xw0q7tGist1kxLqTx4gJLPZbO6SVRdiWF3HoALiTB3ulHXWq0lSPg5Cx0iQsbC+8gXJP
         Mx3Q==
X-Gm-Message-State: ACrzQf1Ob9ODNP/NzyfvYWrm0wG5Ib8IPHcKHFQI73e2eu/OqUcC4WFx
        9/pshc+rIwjB0uaJD9USa1eRDVlCg4qIh7CQ6mCzl5tuwduetCsoB4YwESM5zRAYz4NvCEoPGGh
        FwgrM4jT9e/QZE998
X-Received: by 2002:a05:600c:4e8b:b0:3b4:c8ce:be87 with SMTP id f11-20020a05600c4e8b00b003b4c8cebe87mr24324324wmq.157.1665485454155;
        Tue, 11 Oct 2022 03:50:54 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5A2aCSLEQ7n2luiRil7L1Xyh3BGEAwhpc9iGVeInfgi5+eo2/99Yn9JDz3Jz41LLe0v+8AMQ==
X-Received: by 2002:a05:600c:4e8b:b0:3b4:c8ce:be87 with SMTP id f11-20020a05600c4e8b00b003b4c8cebe87mr24324305wmq.157.1665485453907;
        Tue, 11 Oct 2022 03:50:53 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id r3-20020a5d4983000000b002301c026acasm5949767wrq.85.2022.10.11.03.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 03:50:53 -0700 (PDT)
Message-ID: <468f01fc1dde6cf44fab51653eeb626fc8521db2.camel@redhat.com>
Subject: Re: [PATCH v1 net 1/3] udp: Update reuse->has_conns under
 reuseport_lock.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>
Cc:     Craig Gallek <kraig@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 11 Oct 2022 12:50:52 +0200
In-Reply-To: <20221010174351.11024-2-kuniyu@amazon.com>
References: <20221010174351.11024-1-kuniyu@amazon.com>
         <20221010174351.11024-2-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-10-10 at 10:43 -0700, Kuniyuki Iwashima wrote:
> When we call connect() for a UDP socket in a reuseport group, we have
> to update sk->sk_reuseport_cb->has_conns to 1.  Otherwise, the kernel
> could select a unconnected socket wrongly for packets sent to the
> connected socket.
> 
> However, the current way to set has_conns is illegal and possible to
> trigger that problem.  reuseport_has_conns() changes has_conns under
> rcu_read_lock(), which upgrades the RCU reader to the updater.  Then,
> it must do the update under the updater's lock, reuseport_lock, but
> it doesn't for now.
> 
> For this reason, there is a race below where we fail to set has_conns
> resulting in the wrong socket selection.  To avoid the race, let's split
> the reader and updater with proper locking.
> 
>  cpu1                               cpu2
> +----+                             +----+
> 
> __ip[46]_datagram_connect()        reuseport_grow()
> .                                  .
> > - reuseport_has_conns(sk, true)   |- more_reuse = __reuseport_alloc(more_socks_size)
> >  .                               |
> >  |- rcu_read_lock()
> >  |- reuse = rcu_dereference(sk->sk_reuseport_cb)
> >  |
> >  |                               |  /* reuse->has_conns == 0 here */
> >  |                               |- more_reuse->has_conns = reuse->has_conns
> >  |- reuse->has_conns = 1         |  /* more_reuse->has_conns SHOULD BE 1 HERE */
> >  |                               |
> >  |                               |- rcu_assign_pointer(reuse->socks[i]->sk_reuseport_cb,
> >  |                               |                     more_reuse)
> >  `- rcu_read_unlock()            `- kfree_rcu(reuse, rcu)
> > 
> > - sk->sk_state = TCP_ESTABLISHED
> 
> Fixes: acdcecc61285 ("udp: correct reuseport selection with connected sockets")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  include/net/sock_reuseport.h | 23 +++++++++++++++++------
>  net/ipv4/datagram.c          |  2 +-
>  net/ipv4/udp.c               |  2 +-
>  net/ipv6/datagram.c          |  2 +-
>  net/ipv6/udp.c               |  2 +-
>  5 files changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/include/net/sock_reuseport.h b/include/net/sock_reuseport.h
> index 473b0b0fa4ab..fe9779e6d90f 100644
> --- a/include/net/sock_reuseport.h
> +++ b/include/net/sock_reuseport.h
> @@ -43,21 +43,32 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
>  extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
>  extern int reuseport_detach_prog(struct sock *sk);
>  
> -static inline bool reuseport_has_conns(struct sock *sk, bool set)
> +static inline bool reuseport_has_conns(struct sock *sk)
>  {
>  	struct sock_reuseport *reuse;
>  	bool ret = false;
>  
>  	rcu_read_lock();
>  	reuse = rcu_dereference(sk->sk_reuseport_cb);
> -	if (reuse) {
> -		if (set)
> -			reuse->has_conns = 1;
> -		ret = reuse->has_conns;
> -	}
> +	if (reuse && reuse->has_conns)
> +		ret = true;
>  	rcu_read_unlock();
>  
>  	return ret;
>  }
>  
> +static inline void reuseport_has_conns_set(struct sock *sk)
> +{
> +	struct sock_reuseport *reuse;
> +
> +	if (!rcu_access_pointer(sk->sk_reuseport_cb))
> +		return;
> +
> +	spin_lock(&reuseport_lock);
> +	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
> +					  lockdep_is_held(&reuseport_lock));
> +	reuse->has_conns = 1;
> +	spin_unlock(&reuseport_lock);
> +}

Since the above is not super critical, it's probably better move it
into  sock_reuseport.c file and export it (to fix the build issue)

Cheers,

Paolo

