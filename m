Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EE345A4EC
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 15:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236073AbhKWOPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 09:15:34 -0500
Received: from mail-ed1-f45.google.com ([209.85.208.45]:34449 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbhKWOPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 09:15:33 -0500
Received: by mail-ed1-f45.google.com with SMTP id x15so92302223edv.1;
        Tue, 23 Nov 2021 06:12:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sxe82sLH8pSrm2X9O6Gx3UTUYDZ1j1yBNNWR4/Njt4I=;
        b=s/vqFzn0GT2r1OOm7HNB2stbDtr3lItv5GTdMbatH6OWfd9JRh2AXocSrX5mB6IyBj
         0QY47WgfONzq0lggi5z7F6A4igOYwil0BUB0sFnWxuZwnN4+GnS8XhXaUUyeMp5t4V71
         NWG0tf1T2WBh7IiEIzmmKMRedHGSJVbbJkMDKS93AkIEco1dkKSWg/H9ntsy1OOeYwCA
         9TDVYvnuueU7MVgpyo0zjyujv8ZBMcFOad9RZjyzGCnyDTeP2qGaIg4i0P/p1jl/DRto
         V7gVJ/PMir0TxsadIYsdPRTpav1bgHkeQmw/ZK+qz0wVSDMw0QY7uuCavephSHZz4t73
         9TIw==
X-Gm-Message-State: AOAM5315LKoOtnEhcwxYb0NCaPs5lbx6K7D2X/7prlR1qczib+PWl46C
        VgCCQQM7VyOu/Ze5WUbrw8MYejsYW9H3nA==
X-Google-Smtp-Source: ABdhPJyu3yeTcHJPPhbwcEgRdR9zE/RxKw8nhcUyJn5LVHpq6z6fxpU0A+rVanMAPKI9G7BFHoXZZQ==
X-Received: by 2002:a05:6402:3596:: with SMTP id y22mr9625539edc.297.1637676744104;
        Tue, 23 Nov 2021 06:12:24 -0800 (PST)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com. [209.85.221.44])
        by smtp.gmail.com with ESMTPSA id jg32sm5718620ejc.43.2021.11.23.06.12.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 06:12:23 -0800 (PST)
Received: by mail-wr1-f44.google.com with SMTP id a18so2647418wrn.6;
        Tue, 23 Nov 2021 06:12:23 -0800 (PST)
X-Received: by 2002:a05:6000:4b:: with SMTP id k11mr7434817wrx.86.1637676743347;
 Tue, 23 Nov 2021 06:12:23 -0800 (PST)
MIME-Version: 1.0
References: <20211121041608.133740-1-eiichi.tsukata@nutanix.com>
In-Reply-To: <20211121041608.133740-1-eiichi.tsukata@nutanix.com>
From:   Marc Dionne <marc.dionne@auristor.com>
Date:   Tue, 23 Nov 2021 10:12:12 -0400
X-Gmail-Original-Message-ID: <CAB9dFdtG9N_N=PKXaYwkpT5pvgSK1rTjNOGd4i6+hPcjr9hSHw@mail.gmail.com>
Message-ID: <CAB9dFdtG9N_N=PKXaYwkpT5pvgSK1rTjNOGd4i6+hPcjr9hSHw@mail.gmail.com>
Subject: Re: [PATCH net 1/2] rxrpc: Fix rxrpc_peer leak in rxrpc_look_up_bundle()
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
> Need to call rxrpc_put_peer() for bundle candidate before kfree() as it
> holds a ref to rxrpc_peer.
>
> Fixes: 245500d853e9 ("rxrpc: Rewrite the client connection manager")
> Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
> ---
>  net/rxrpc/conn_client.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/rxrpc/conn_client.c b/net/rxrpc/conn_client.c
> index dbea0bfee48e..46dcb33888ff 100644
> --- a/net/rxrpc/conn_client.c
> +++ b/net/rxrpc/conn_client.c
> @@ -328,6 +328,7 @@ static struct rxrpc_bundle *rxrpc_look_up_bundle(struct rxrpc_conn_parameters *c
>         return candidate;
>
>  found_bundle_free:
> +       rxrpc_put_peer(candidate->params.peer);
>         kfree(candidate);
>  found_bundle:
>         rxrpc_get_bundle(bundle);
> --
> 2.33.1

Reviewed-by: Marc Dionne <marc.dionne@auristor.com>

Marc
