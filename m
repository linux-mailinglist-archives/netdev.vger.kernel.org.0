Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA37C57892F
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 20:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbiGRSFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 14:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbiGRSE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 14:04:58 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4E52CE2C;
        Mon, 18 Jul 2022 11:04:57 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z22so3437074edd.6;
        Mon, 18 Jul 2022 11:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DZc2nBDB1diw7QcFhj4RHe3OuM0eATNMLdDmVz3JMQU=;
        b=GYi+nKFkW0uMBeR8Yv6Fajs/o7zIw8AeferKqAuSdBYt1k1BDfj4espJIjyvFiJVXx
         voN1YwlyYADMW5oukQPFvj7B/0BbaMAtKFBhRc3fX/81Nvt1Ym3fDtnmD819W1PqW5vF
         RDMzd5y04O6NemU3YdDfv8e0GYYDgfxTnGEBRZY3jgnYQBWLI5NDQsQSPO869WI32Cre
         DfuoEHpjrlbNhW4UVTgH9U60uM17IiqMEBdmNKokuISSb7Wro3BaZUVTsduWaE7PISMI
         ZQV3EcWsXY1wYvHgoqbSiXMzg0sJWnnaDIQW/SxHHBSXobjgn2g756lY0MGg5UYfMbQ1
         IIUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DZc2nBDB1diw7QcFhj4RHe3OuM0eATNMLdDmVz3JMQU=;
        b=dSN42bXxVsWTvd47p6j0QbdZKkLY7S2Uf+p7ulR18+N8PHRkiPOFrzPT2bFapUEw1V
         k9SQh83CwsNc+axwbXSYSHpW3S5BFIROJSmXjJqlvtc3vPud4S4m3OrVuV/M49g9yFhg
         MpYr3FGfg0xxDmp6mzsEsvIpjD5giwlTlANftbuyzCIYl/EQXvI02hG5Cv0TelgaWaFM
         rB/upFDJHjmkNt3AeKOwTHZgLIaXafG5MFU+sdneAJPgAT2legUSwDM5SNYBKKHJ7QXU
         A0Xs5fjvHEe4/DW7I0GweN3KegRwNEfO6tHply92B4uxPOlZDq+oj1VhGT7Up2Dp8xIj
         BE+w==
X-Gm-Message-State: AJIora8O+D+4TsWPCk7j3PYI0Xo5ljKmjdVbVCoPBVhusJlmcatDAg+q
        qUALONf36J1L7tJMvxCB1e8=
X-Google-Smtp-Source: AGRyM1t/BDQCQ+jkc6/c7r6J1EJXN0X+9IzBS/xxOZQKSlHWavbP2vKNr/DSQMZaI7jZbc3/4Y5Avw==
X-Received: by 2002:aa7:d142:0:b0:43a:2738:d648 with SMTP id r2-20020aa7d142000000b0043a2738d648mr39359760edo.138.1658167495690;
        Mon, 18 Jul 2022 11:04:55 -0700 (PDT)
Received: from skbuf ([188.25.231.190])
        by smtp.gmail.com with ESMTPSA id zk8-20020a17090733c800b00705cd37fd5asm5711194ejb.72.2022.07.18.11.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 11:04:54 -0700 (PDT)
Date:   Mon, 18 Jul 2022 21:04:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 1/4] net: dsa: qca8k: drop
 qca8k_read/write/rmw for regmap variant
Message-ID: <20220718180452.ysqaxzguqc3urgov@skbuf>
References: <20220716174958.22542-1-ansuelsmth@gmail.com>
 <20220716174958.22542-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220716174958.22542-2-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 07:49:55PM +0200, Christian Marangi wrote:
> In preparation for code split, drop the remaining qca8k_read/write/rmw
> and use regmap helper directly.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca/qca8k.c | 206 +++++++++++++++++-------------------
>  1 file changed, 95 insertions(+), 111 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k.c
> index 1cbb05b0323f..2d34e15c2e6f 100644
> --- a/drivers/net/dsa/qca/qca8k.c
> +++ b/drivers/net/dsa/qca/qca8k.c
> @@ -184,24 +184,6 @@ qca8k_set_page(struct qca8k_priv *priv, u16 page)
>  	return 0;
>  }
>  
> -static int
> -qca8k_read(struct qca8k_priv *priv, u32 reg, u32 *val)
> -{
> -	return regmap_read(priv->regmap, reg, val);
> -}
> -
> -static int
> -qca8k_write(struct qca8k_priv *priv, u32 reg, u32 val)
> -{
> -	return regmap_write(priv->regmap, reg, val);
> -}
> -
> -static int
> -qca8k_rmw(struct qca8k_priv *priv, u32 reg, u32 mask, u32 write_val)
> -{
> -	return regmap_update_bits(priv->regmap, reg, mask, write_val);
> -}
> -

Could you please explain slowly to me why this change is needed? I don't get it.
Can't qca8k_read(), qca8k_write() and qca8k_rmw() be part of qca8k-common.c?
