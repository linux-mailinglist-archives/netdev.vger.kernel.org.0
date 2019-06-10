Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83ABC3BA0F
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfFJQyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:54:35 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38765 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbfFJQyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:54:35 -0400
Received: by mail-wr1-f68.google.com with SMTP id d18so9918848wrs.5;
        Mon, 10 Jun 2019 09:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1PVW2PEKEm9unFQvUCMzFXCBC/N1uW/T1zfRO79SIvk=;
        b=VjQ3yQIf66iosVl6DKmEmVKQK2nmDE56WNuX0uhsLIPwmu54B1WVwNSIcXvWkiJKsQ
         hs3AN1CTrIHOMc+qgJydR9/w4zJJ1dXdKUw/msiK515w8eQX+U6bNIAVs8VPdVW5sIS8
         m2hA1Yh2pI5D2M859fWpUbKAtmSmiWT014zaNbr59nM90DLkRNPavdMlxD7yYckCGz+a
         dtTcwB8hHXgFqYanv8fSzyu1Da53hnojb0fFLwgU8rQ72ZGV4CxoTuKe/RtWtdrKjdQN
         ET89xMq53wc1aIdxOrl3z3Dyq3ufrRHyTii4trTS0Q0CUvH5YsEDfED9tF/4yukwNoDI
         JoRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1PVW2PEKEm9unFQvUCMzFXCBC/N1uW/T1zfRO79SIvk=;
        b=VMpvBsXVqdXtouDRHHNk/zka5UbsZ/3jANID5NbpaiVAtZaPkIai1NY612DI/HAJNf
         fh6VlHNfhNDzKl7dTotH4u758Mj8OnI+SZqF94KesNP7F7b21I+ZIkEe4qdcXZjfElom
         iGFRZWgQBqhNm5iDglH7aah/e3E98o1t9c93cPOOJg8w2yisaDGICumdhOkK2k/V8yc2
         9OFV0vs/F5fEf59su1A0VkIanixlh2hNV2cmNQFPbE3A9r8Eu1VRZHDBaCTjQ3/AOUS9
         clu9tuS2DOMrJz0qCNvpQfNno9pay8/Gkf2ZygvvCs9MtDq+EZtT16nIYhCtCaQbqZi8
         w8Tg==
X-Gm-Message-State: APjAAAUMItVMITXAdy+gPa5RduK/rwPbflGBUyAyllSe1ino0zGlMKxb
        HL1PV6M+oNy1JeRrEg42VtsN7cjPnYXAxnbIIjY=
X-Google-Smtp-Source: APXvYqxQrYELSRTvUzCqyiSnUx5OBxE3g9qO+zPj3dkIzt8Ow4I7V8pWTonsYKcgoo9IiwXLksv8h+udhxs1TJ7R2Lg=
X-Received: by 2002:adf:bac5:: with SMTP id w5mr33094639wrg.124.1560185673579;
 Mon, 10 Jun 2019 09:54:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190610163456.7778-1-nhorman@tuxdriver.com>
In-Reply-To: <20190610163456.7778-1-nhorman@tuxdriver.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 11 Jun 2019 00:54:22 +0800
Message-ID: <CADvbK_czxOqGPDCZmvZgP6A7aSKC-W4U2WaAwL89uBpi4EEVog@mail.gmail.com>
Subject: Re: [PATCH] Free cookie before we memdup a new one
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     linux-sctp@vger.kernel.org, network dev <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 12:35 AM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> Based on comments from Xin, even after fixes for our recent syzbot
> report of cookie memory leaks, its possible to get a resend of an INIT
> chunk which would lead to us leaking cookie memory.
>
> To ensure that we don't leak cookie memory, free any previously
> allocated cookie first.
Hi, Neil,

I think we should also do the same thing to the other 2 kmemdups in
sctp_process_param():
asoc->peer.peer_random
asoc->peer.peer_hmacs


>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> CC: Xin Long <lucien.xin@gmail.com>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: netdev@vger.kernel.org
> ---
>  net/sctp/sm_make_chunk.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
> index f17908f5c4f3..21f7faf032e5 100644
> --- a/net/sctp/sm_make_chunk.c
> +++ b/net/sctp/sm_make_chunk.c
> @@ -2583,6 +2583,8 @@ static int sctp_process_param(struct sctp_association *asoc,
>         case SCTP_PARAM_STATE_COOKIE:
>                 asoc->peer.cookie_len =
>                         ntohs(param.p->length) - sizeof(struct sctp_paramhdr);
> +               if (asoc->peer.cookie)
> +                       kfree(asoc->peer.cookie);
>                 asoc->peer.cookie = kmemdup(param.cookie->body, asoc->peer.cookie_len, gfp);
>                 if (!asoc->peer.cookie)
>                         retval = 0;
> --
> 2.20.1
>
