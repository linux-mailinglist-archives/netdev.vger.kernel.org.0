Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 402D44B520
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 11:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731473AbfFSJlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 05:41:42 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34225 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbfFSJlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 05:41:42 -0400
Received: by mail-io1-f67.google.com with SMTP id k8so6522063iot.1
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 02:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jD1k725MF57/7I440RyisIARaCcQrPoi+qPVx/TtcQo=;
        b=E2c3g3aflqVHQTOkOdpcH6lfAlJHNfReRy8ib43f05yT6Il9xvxi0nFI/hHdHetMF0
         0v9wlweKCwxShGmYd7JEq+E0AwPbg80DAoor1XF97M6fEsYJh3R8jd2b/THZdBOBqV21
         zUIWers45rvogOTpfoxuRal8xF25J+eHWO50RFY4K+sIigzT8aO6gpw2zyq43J+uY6eF
         +whBLKHTCSxwUyaMbI0Z8dAC+4PUHTg3+q4fuut9YnhnFgf0r6flGJj5TocMuaTs9Nr2
         9u7GZoPZFI91v0j0A0jvKqoVmD3cOSzKzHzhdoTcTtou1LoJzWWIHuHjUbLiaxJisLu3
         o2XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jD1k725MF57/7I440RyisIARaCcQrPoi+qPVx/TtcQo=;
        b=DWWCakxgRP0VTj83K2G4jM1s77gT471KMjhrh0RIRthBDSUg+g6c55iZd5IP0FODT3
         kR0ICUthyVkyyp4kETaKmGHzQXPBefXM344XQV8DB1DeF/X7eCwlKw7JUlGN1np0EQ2a
         pgE6OPgGyIvXaRk2vaOowtvn+QpBZKTKsFjY+1suetOhWemlg0zPU/0IRwvZB9Qxj+jJ
         VhE1zCMm4rxXv3HJgCLO9MNBaaZjou28/JBkX+JvuAE2mOa7hOJH5FaPm/fztBgk3hnN
         areM2TbhLGDjsLk/lTnq8eFrLigQqhg1j74NBtg8CEg1t5bF+gWGfluElo9b/EJieU2n
         6Fbw==
X-Gm-Message-State: APjAAAXqZNSjJYiUjRjW8Krs+AZqizez0nkGvabS1zAVHTm6hF2/3ojr
        n255kusas9B8HQKOtPz8Wjzlh/JQ8zLy5r8BDnmHEQ==
X-Google-Smtp-Source: APXvYqwE5M9BGedf9JTtKcYQvX9VrikxA2fykSA6PPRAXS9eRnp6HZs1LNKFX14YCU8t0sa7qpbAuD8vfqSkfatLtkA=
X-Received: by 2002:a5e:d51a:: with SMTP id e26mr796481iom.71.1560937301609;
 Wed, 19 Jun 2019 02:41:41 -0700 (PDT)
MIME-Version: 1.0
References: <1560931034-6810-1-git-send-email-ilias.apalodimas@linaro.org> <1560931034-6810-2-git-send-email-ilias.apalodimas@linaro.org>
In-Reply-To: <1560931034-6810-2-git-send-email-ilias.apalodimas@linaro.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 19 Jun 2019 11:41:30 +0200
Message-ID: <CAKv+Gu9ZO4D7zJpJBGDZng9hCzt_=unj+dioo2EkHXQOhWm26g@mail.gmail.com>
Subject: Re: [net-next, PATCH 2/2] net: netsec: remove loops in napi Rx process
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Jaswinder Singh <jaswinder.singh@linaro.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jun 2019 at 09:57, Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> netsec_process_rx was running in a loop trying to process as many packets
> as possible before re-enabling interrupts. With the recent DMA changes
> this is not needed anymore as we manage to consume all the budget without
> looping over the function.
> Since it has no performance penalty let's remove that and simplify the Rx
> path a bit
>
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/net/ethernet/socionext/netsec.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index a10ef700f16d..48fd7448b513 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -820,19 +820,12 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
>  static int netsec_napi_poll(struct napi_struct *napi, int budget)
>  {
>         struct netsec_priv *priv;
> -       int rx, done, todo;
> +       int done;
>
>         priv = container_of(napi, struct netsec_priv, napi);
>
>         netsec_process_tx(priv);
> -
> -       todo = budget;
> -       do {
> -               rx = netsec_process_rx(priv, todo);
> -               todo -= rx;
> -       } while (rx);
> -
> -       done = budget - todo;
> +       done = netsec_process_rx(priv, budget);
>
>         if (done < budget && napi_complete_done(napi, done)) {
>                 unsigned long flags;
> --
> 2.20.1
>
