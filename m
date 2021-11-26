Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301E945EEEF
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 14:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238207AbhKZNS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 08:18:26 -0500
Received: from mail-ed1-f48.google.com ([209.85.208.48]:33770 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344842AbhKZNQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 08:16:26 -0500
Received: by mail-ed1-f48.google.com with SMTP id t5so39063057edd.0;
        Fri, 26 Nov 2021 05:13:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rSYftKh/he6IShKGar5rHMeAkDYe1aat/h54qJZ5qEU=;
        b=uJMbUi+79kG0wSklgIJktq1qmJQdxqOhcjywRovzUQ1zoMhzDrnNMey2dbBTKFRabn
         kOBNBFea2xqNL9ZKB/Hy1stxXd26zHsIZs0OB7qNHfp2OQy9nwKPCRwZe7ppotEUDjL8
         zDntlmsNGiEaF9+kWRPMySSYqpc8hMV9XILJp4TqaavFlDco39rGXVQM1X1yY3rYxRhC
         nztGa5ts0W+U8vo2Euh4jZbw6j97TpIR6hmtraewJErnwRTJaHOKIBPqFyRBzdIJ9UPN
         nxipdtsXKGDWtBcK/TDU+lsSL4HOqG7CC9Qnw/Yp3OU5cpb3FRCCkQKZVjSMsssQI2k/
         jY2A==
X-Gm-Message-State: AOAM530fwhtDwaBBYNWiyRjOSP0xTR4mNRaEtQODLPSRFhnTeewPXdlw
        0NqFJ30SGFxUV8SbUlPhEshqbhhKSckffplZ
X-Google-Smtp-Source: ABdhPJxcpfQ/WPeJKrSrLhGk6AR9MX/jpVLx2nnj5hXvXEjEn1E2rcf1fo/aR8nxR242TJaccJAghQ==
X-Received: by 2002:a17:906:fb17:: with SMTP id lz23mr38031270ejb.149.1637932387335;
        Fri, 26 Nov 2021 05:13:07 -0800 (PST)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id j14sm4262735edw.96.2021.11.26.05.13.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 05:13:07 -0800 (PST)
Received: by mail-wr1-f54.google.com with SMTP id v11so18540874wrw.10;
        Fri, 26 Nov 2021 05:13:06 -0800 (PST)
X-Received: by 2002:a05:6000:15c8:: with SMTP id y8mr13806062wry.101.1637932386702;
 Fri, 26 Nov 2021 05:13:06 -0800 (PST)
MIME-Version: 1.0
References: <163776465314.1844202.9057900281265187616.stgit@warthog.procyon.org.uk>
In-Reply-To: <163776465314.1844202.9057900281265187616.stgit@warthog.procyon.org.uk>
From:   Marc Dionne <marc.dionne@auristor.com>
Date:   Fri, 26 Nov 2021 09:12:55 -0400
X-Gmail-Original-Message-ID: <CAB9dFdtVr0cOxMe-L4E0NQLi1__R8a=7j7zXapzYmwRyCnRgZg@mail.gmail.com>
Message-ID: <CAB9dFdtVr0cOxMe-L4E0NQLi1__R8a=7j7zXapzYmwRyCnRgZg@mail.gmail.com>
Subject: Re: [PATCH 1/2] rxrpc: Fix rxrpc_peer leak in rxrpc_look_up_bundle()
To:     David Howells <dhowells@redhat.com>
Cc:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>,
        linux-afs@lists.infradead.org, Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 10:37 AM David Howells <dhowells@redhat.com> wrote:
>
> From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
>
> Need to call rxrpc_put_peer() for bundle candidate before kfree() as it
> holds a ref to rxrpc_peer.
>
> [DH: v2: Changed to abstract out the bundle freeing code into a function]
>
> Fixes: 245500d853e9 ("rxrpc: Rewrite the client connection manager")
> Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Marc Dionne <marc.dionne@auristor.com>
> cc: linux-afs@lists.infradead.org
> Link: https://lore.kernel.org/r/20211121041608.133740-1-eiichi.tsukata@nutanix.com/ # v1
> ---
>
>  net/rxrpc/conn_client.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
> index dbea0bfee48e..8120138dac01 100644
> --- a/net/rxrpc/conn_client.c
> +++ b/net/rxrpc/conn_client.c
> @@ -135,16 +135,20 @@ struct rxrpc_bundle *rxrpc_get_bundle(struct rxrpc_bundle *bundle)
>         return bundle;
>  }
>
> +static void rxrpc_free_bundle(struct rxrpc_bundle *bundle)
> +{
> +       rxrpc_put_peer(bundle->params.peer);
> +       kfree(bundle);
> +}
> +
>  void rxrpc_put_bundle(struct rxrpc_bundle *bundle)
>  {
>         unsigned int d = bundle->debug_id;
>         unsigned int u = atomic_dec_return(&bundle->usage);
>
>         _debug("PUT B=%x %u", d, u);
> -       if (u == 0) {
> -               rxrpc_put_peer(bundle->params.peer);
> -               kfree(bundle);
> -       }
> +       if (u == 0)
> +               rxrpc_free_bundle(bundle);
>  }
>
>  /*
> @@ -328,7 +332,7 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_conn_parameters *c
>         return candidate;
>
>  found_bundle_free:
> -       kfree(candidate);
> +       rxrpc_free_bundle(candidate);
>  found_bundle:
>         rxrpc_get_bundle(bundle);
>         spin_unlock(&local->client_bundles_lock);

Reviewed-by: Marc Dionne <marc.dionne@auristor.com>

Marc
