Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E08BE66454C
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 16:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238392AbjAJPvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 10:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238508AbjAJPu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 10:50:56 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00CA2650
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 07:50:55 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id bj3so9611607pjb.0
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 07:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G5ojdLPljgpkh5jM7i2jrDZVx83WKIt7jXUGlypl5rY=;
        b=N5vQsSqrH3I4wRl/TgA4fTekU0uQRGFzjRju5Wwap7XEJE0coB4fYfxUjij9iRwyGo
         SIeU2vnLvl4bzW4FOsNwzpVUM95Hl5rBrTe59czsJzdM7N/TCGmMoHUUljNPq6hYy7cW
         vKlMIZZfDS0ceDkr4Thrs2kMx4D/0V0SjdD/+4pIKTfn23u1Hjh3WqmZXN7qgd4wMk+t
         +INisopbE88y2knE74H3mXRXwyztNsvYIu4KNc64tycER6Cy/zqS5mayCiPdwULZAzlK
         cgXNzko/heV7DkFUrpsEEyVOW3dQblmSUo7HCGY8qZu2gpc8QpSfRBJGCdjG+5mz2hs+
         MIog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G5ojdLPljgpkh5jM7i2jrDZVx83WKIt7jXUGlypl5rY=;
        b=GvyHAJdXfpzGn5lWkKxWximZlxK3XDtMcZ0Lr23jD61SGn4b74FHNwXGHAOophAKZM
         7Nt8touN55+KtubNDyh9jZlW8Ir6cQ/8sq8cUVLm8Wtj4RASza56XBty9jc+dwCTovyS
         F6i4BrM9dK4s1SiASuzpO/7O1+3skL+2YErJvwq/1ETCHMCNmeHerl00YMFJZ0854a4t
         nIxcEr/oi42+rOhOsyTzck0V21P/GUIftUEOSOZ0MqpF2r3FuAYVYIuRuwWTo+5/nGt8
         z//D/pQkVm3XBieLAwkrdfwGqNRizO3m4UKoKSlJ+iuReSJrlb6cNk9wov37h9DZdRTs
         jahg==
X-Gm-Message-State: AFqh2krzhzj2cUO7IUp7ny7zHYFmhq8d0YtGNNA8vFmr5Rofzih2cQq5
        npYYDg8MgtFKukKoy0jujcw=
X-Google-Smtp-Source: AMrXdXt8ZUw+TZ/fYPN8YLRIcsr5tIP94vwJgDMhxtLaWOVDAWj3g8wZx25uoIoTxglsyPDJdnpKyg==
X-Received: by 2002:a17:903:22c7:b0:192:ee6c:e28d with SMTP id y7-20020a17090322c700b00192ee6ce28dmr31151128plg.38.1673365855074;
        Tue, 10 Jan 2023 07:50:55 -0800 (PST)
Received: from [192.168.0.128] ([98.97.37.136])
        by smtp.googlemail.com with ESMTPSA id q6-20020a17090311c600b00186985198a4sm8293017plh.169.2023.01.10.07.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 07:50:54 -0800 (PST)
Message-ID: <afcd8835dc2239084f873c74fcaf997047ab319f.camel@gmail.com>
Subject: Re: [PATCH net-next v4 02/10] tsnep: Forward NAPI budget to
 napi_consume_skb()
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
Date:   Tue, 10 Jan 2023 07:50:53 -0800
In-Reply-To: <20230109191523.12070-3-gerhard@engleder-embedded.com>
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
         <20230109191523.12070-3-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
> NAPI budget must be forwarded to napi_consume_skb(). It is used to
> detect non-NAPI context.
>=20
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/tsnep_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/eth=
ernet/engleder/tsnep_main.c
> index 7cc5e2407809..d148ba422b8c 100644
> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> @@ -550,7 +550,7 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int na=
pi_budget)
>  			skb_tstamp_tx(entry->skb, &hwtstamps);
>  		}
> =20
> -		napi_consume_skb(entry->skb, budget);
> +		napi_consume_skb(entry->skb, napi_budget);
>  		entry->skb =3D NULL;
> =20
>  		tx->read =3D (tx->read + count) % TSNEP_RING_SIZE;

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
