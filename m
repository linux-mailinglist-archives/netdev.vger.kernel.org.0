Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41C25EC8B9
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 17:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbiI0Pzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 11:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbiI0PzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 11:55:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA65422E9;
        Tue, 27 Sep 2022 08:54:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 561AEB81C4A;
        Tue, 27 Sep 2022 15:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F19C433D7;
        Tue, 27 Sep 2022 15:54:49 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Kr3veXtE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664294087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wXMcknmy52+bmB46p09vHJPvomoJDbcpYQo26BsrWTs=;
        b=Kr3veXtEIYJhucAcuSAvEshBizlDQXyGGIXGapoKnEC2LiwD88o/LL20ffruaZuN3aDT2Z
        MQ69gEkiOp64PvBXWN95uRnQMKTsez6G+ECQ15PirKNEyTc+74hFm1mqWJDIs+7m3K2B6K
        RJ70WqkD4YocCQv9eXTM3l8R4GKmQO8=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 60cf2a05 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 27 Sep 2022 15:54:47 +0000 (UTC)
Date:   Tue, 27 Sep 2022 17:54:43 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, kvalo@kernel.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org
Subject: Re: [PATCH net-next] net: drop the weight argument from
 netif_napi_add
Message-ID: <YzMcw8S7fuSS9UPw@zx2c4.com>
References: <20220927132753.750069-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220927132753.750069-1-kuba@kernel.org>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 06:27:53AM -0700, Jakub Kicinski wrote:
> We tell driver developers to always pass NAPI_POLL_WEIGHT
> as the weight to netif_napi_add(). This may be confusing
> to newcomers, drop the weight argument, those who really
> need to tweak the weight can use netif_napi_add_weight().
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/wireguard/peer.c                  |  3 +--
>
> diff --git a/drivers/net/wireguard/peer.c b/drivers/net/wireguard/peer.c
> index 1acd00ab2fbc..1cb502a932e0 100644
> --- a/drivers/net/wireguard/peer.c
> +++ b/drivers/net/wireguard/peer.c
> @@ -54,8 +54,7 @@ struct wg_peer *wg_peer_create(struct wg_device *wg,
>  	skb_queue_head_init(&peer->staged_packet_queue);
>  	wg_noise_reset_last_sent_handshake(&peer->last_sent_handshake);
>  	set_bit(NAPI_STATE_NO_BUSY_POLL, &peer->napi.state);
> -	netif_napi_add(wg->dev, &peer->napi, wg_packet_rx_poll,
> -		       NAPI_POLL_WEIGHT);
> +	netif_napi_add(wg->dev, &peer->napi, wg_packet_rx_poll);
>  	napi_enable(&peer->napi);
>  	list_add_tail(&peer->peer_list, &wg->peer_list);
>  	INIT_LIST_HEAD(&peer->allowedips_list);

For the wireguard part,

   Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
