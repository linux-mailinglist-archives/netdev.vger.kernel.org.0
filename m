Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DC245EEF5
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 14:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238604AbhKZNVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 08:21:09 -0500
Received: from mail-ed1-f41.google.com ([209.85.208.41]:40713 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbhKZNTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 08:19:08 -0500
Received: by mail-ed1-f41.google.com with SMTP id r25so38753659edq.7;
        Fri, 26 Nov 2021 05:15:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MSLOtqJUk3e5+K7Xn/2TWpotUyuNH26quLn+OZucHDA=;
        b=QWACUXqyNcl/hQabo5X/1NxQzyvSOCQwyIlxL6FQvGCueCs73XBV1YYHsSHKJmwVFg
         MAlFtHXp3DG5eUHTEqG22nSXVaJ4lJAQD4D2gaBifwkydFKvVF/BsRT7YWRtKmnvx/uh
         vuiz1pNAMjd2MLZ1/PK3dlbhLvAqbBcDZ7aEP70FXDWOkHpsnrso5zdTXugY7C2+TVWQ
         RSndjo7jzlXDUwRgU5KV44FMTgh625LD3rgITQ3Oun4FnL6997TLsTo4O8GMEPuuqNgv
         6HN2NLcXpM+0tapOxkurldTvUMuFEFA53BI05BK0M5kMcdLny6/w741qrjCggNMUkCj5
         VKwQ==
X-Gm-Message-State: AOAM533bnhlkOar3f3goCMzKpP0P3iKofVcAYkX0aL1jzdCK91CpcR8u
        24zcIWRx7WmPlESPfX392Gl+mIxsPDaUb13r
X-Google-Smtp-Source: ABdhPJxBrMVZhLeOf64PciKXJSkgnAm+svv7M5pKOaNT+wPu+jIaS3WQC8LzQCYxZRW/YVN2nfvW3g==
X-Received: by 2002:a05:6402:1e92:: with SMTP id f18mr46641840edf.153.1637932553552;
        Fri, 26 Nov 2021 05:15:53 -0800 (PST)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id r3sm3064381ejr.79.2021.11.26.05.15.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 05:15:53 -0800 (PST)
Received: by mail-wr1-f41.google.com with SMTP id a9so18593427wrr.8;
        Fri, 26 Nov 2021 05:15:53 -0800 (PST)
X-Received: by 2002:a5d:6da5:: with SMTP id u5mr14331412wrs.374.1637932553071;
 Fri, 26 Nov 2021 05:15:53 -0800 (PST)
MIME-Version: 1.0
References: <163776465314.1844202.9057900281265187616.stgit@warthog.procyon.org.uk>
 <163776466062.1844202.16759821367213247018.stgit@warthog.procyon.org.uk>
In-Reply-To: <163776466062.1844202.16759821367213247018.stgit@warthog.procyon.org.uk>
From:   Marc Dionne <marc.dionne@auristor.com>
Date:   Fri, 26 Nov 2021 09:15:41 -0400
X-Gmail-Original-Message-ID: <CAB9dFdsexEFkhcB-A6oDyhzOEmzsDj59KV0MtLwtkhy9kFD65A@mail.gmail.com>
Message-ID: <CAB9dFdsexEFkhcB-A6oDyhzOEmzsDj59KV0MtLwtkhy9kFD65A@mail.gmail.com>
Subject: Re: [PATCH 2/2] rxrpc: Fix rxrpc_local leak in rxrpc_lookup_peer()
To:     David Howells <dhowells@redhat.com>
Cc:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        linux-afs@lists.infradead.org, Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 10:38 AM David Howells <dhowells@redhat.com> wrote:
>
> From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
>
> Need to call rxrpc_put_local() for peer candidate before kfree() as it
> holds a ref to rxrpc_local.
>
> [DH: v2: Changed to abstract the peer freeing code out into a function]
>
> Fixes: 9ebeddef58c4 ("rxrpc: rxrpc_peer needs to hold a ref on the rxrpc_local record")
> Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Marc Dionne <marc.dionne@auristor.com>
> cc: linux-afs@lists.infradead.org
> Link: https://lore.kernel.org/all/20211121041608.133740-2-eiichi.tsukata@nutanix.com/ # v1
> ---
>
>  net/rxrpc/peer_object.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
> index 68396d052052..0298fe2ad6d3 100644
> --- a/net/rxrpc/peer_object.c
> +++ b/net/rxrpc/peer_object.c
> @@ -299,6 +299,12 @@ static struct rxrpc_peer *rxrpc_create_peer(struct rxrpc_sock *rx,
>         return peer;
>  }
>
> +static void rxrpc_free_peer(struct rxrpc_peer *peer)
> +{
> +       rxrpc_put_local(peer->local);
> +       kfree_rcu(peer, rcu);
> +}
> +
>  /*
>   * Set up a new incoming peer.  There shouldn't be any other matching peers
>   * since we've already done a search in the list from the non-reentrant context
> @@ -365,7 +371,7 @@ struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *rx,
>                 spin_unlock_bh(&rxnet->peer_hash_lock);
>
>                 if (peer)
> -                       kfree(candidate);
> +                       rxrpc_free_peer(candidate);
>                 else
>                         peer = candidate;
>         }
> @@ -420,8 +426,7 @@ static void __rxrpc_put_peer(struct rxrpc_peer *peer)
>         list_del_init(&peer->keepalive_link);
>         spin_unlock_bh(&rxnet->peer_hash_lock);
>
> -       rxrpc_put_local(peer->local);
> -       kfree_rcu(peer, rcu);
> +       rxrpc_free_peer(peer);
>  }
>
>  /*
> @@ -457,8 +462,7 @@ void rxrpc_put_peer_locked(struct rxrpc_peer *peer)
>         if (n == 0) {
>                 hash_del_rcu(&peer->hash_link);
>                 list_del_init(&peer->keepalive_link);
> -               rxrpc_put_local(peer->local);
> -               kfree_rcu(peer, rcu);
> +               rxrpc_free_peer(peer);
>         }
>  }

Reviewed-by: Marc Dionne <marc.dionne@auristor.com>

Marc
