Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C56645A4E6
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 15:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237998AbhKWOPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 09:15:11 -0500
Received: from mail-ed1-f48.google.com ([209.85.208.48]:39555 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237918AbhKWOPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 09:15:04 -0500
Received: by mail-ed1-f48.google.com with SMTP id w1so92857410edc.6;
        Tue, 23 Nov 2021 06:11:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xpp16H4wKf9uNJaS9kz8KmzVw130zVtB87beqfzXyvE=;
        b=FdDkEQRgtWZp5TcES61YBJQtV8GsPLApq/+d3dl9ZSNDXcNUFEtABJOFa08QQIlWUW
         uaCO3UhvH9wjYHwPglOTeZBA0YqN+UClmAMFUQIBnAL4NKbp/MHZNaa9r49jBEdHfuFz
         cafaxn2Ee2OLNIhOHm/HJXA3sSxZXqugWJrw0x2UTb9vPAqH2bOa6A41fCN3ZMkSrRWj
         ncalEjsbzQBZvH+ilLSd70UiWG/bEeVNfj0z7NbXR5IZkLKcw+uJi1M3NAGuATbz3lV9
         y3NeZCnBtF+pu/MMvTX+A+RvTIg97jIHcEKbTI41NkzpspDh6CGRpJeQ987jCDCFn2Uz
         F4UA==
X-Gm-Message-State: AOAM532OaJlpdDYRy16m3RJZxHVZwZEJw1cyAhSmc2ijwbwD1BqXAcYV
        R6HANX9y8zEpaEyT9GL+hc+EO1WvdkDShw==
X-Google-Smtp-Source: ABdhPJyjtOi7RtDWppgo96OPL0aoHv/pXJdDKe1jsKOINaSWj7nHYNsOPusmD96NzWfAyI6IOgP4/Q==
X-Received: by 2002:a17:906:7954:: with SMTP id l20mr7768361ejo.143.1637676715580;
        Tue, 23 Nov 2021 06:11:55 -0800 (PST)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id n1sm5816942edf.45.2021.11.23.06.11.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 06:11:54 -0800 (PST)
Received: by mail-wm1-f50.google.com with SMTP id 137so15329059wma.1;
        Tue, 23 Nov 2021 06:11:53 -0800 (PST)
X-Received: by 2002:a05:600c:1ca0:: with SMTP id k32mr3567561wms.74.1637676713452;
 Tue, 23 Nov 2021 06:11:53 -0800 (PST)
MIME-Version: 1.0
References: <20211121041608.133740-1-eiichi.tsukata@nutanix.com> <20211121041608.133740-2-eiichi.tsukata@nutanix.com>
In-Reply-To: <20211121041608.133740-2-eiichi.tsukata@nutanix.com>
From:   Marc Dionne <marc.dionne@auristor.com>
Date:   Tue, 23 Nov 2021 10:11:41 -0400
X-Gmail-Original-Message-ID: <CAB9dFdsfEV9UFC-4vJ6QXdLV03FYK7N-QJAu84etqouOV8YMkw@mail.gmail.com>
Message-ID: <CAB9dFdsfEV9UFC-4vJ6QXdLV03FYK7N-QJAu84etqouOV8YMkw@mail.gmail.com>
Subject: Re: [PATCH net 2/2] rxrpc: Fix rxrpc_local leak in rxrpc_lookup_peer()
To:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Cc:     David Howells <dhowells@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-afs@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 21, 2021 at 12:17 AM Eiichi Tsukata
<eiichi.tsukata@nutanix.com> wrote:
>
> Need to call rxrpc_put_local() for peer candidate before kfree() as it
> holds a ref to rxrpc_local.
>
> Fixes: 9ebeddef58c4 ("rxrpc: rxrpc_peer needs to hold a ref on the rxrpc_local record")
> Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
> ---
>  net/rxrpc/peer_object.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
> index 68396d052052..431b62bc1da2 100644
> --- a/net/rxrpc/peer_object.c
> +++ b/net/rxrpc/peer_object.c
> @@ -364,10 +364,12 @@ struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *rx,
>
>                 spin_unlock_bh(&rxnet->peer_hash_lock);
>
> -               if (peer)
> +               if (peer) {
> +                       rxrpc_put_local(candidate->local);
>                         kfree(candidate);
> -               else
> +               } else {
>                         peer = candidate;
> +               }
>         }
>
>         _net("PEER %d {%pISp}", peer->debug_id, &peer->srx.transport);
> --
> 2.33.1

Reviewed-by: Marc Dionne <marc.dionne@auristor.com>

Marc
