Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AFD2ABD0B
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 14:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbgKINAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 08:00:13 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:44189 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730324AbgKINAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 08:00:10 -0500
Received: by mail-yb1-f195.google.com with SMTP id i186so8097562ybc.11;
        Mon, 09 Nov 2020 05:00:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ONH1likqkogb93d/r1uP1qpS++gqjRPAA5YiqR0gr4=;
        b=U+fvlvYTbIzXUIb+BkX8r4N0AGTzCc5Y8PYRVelwuyj4V2bcTk2tBQ/N2Wm1LiDe7p
         vyTtU3D4cvXq+EVEkLaJdWNPboskwY2JXHz9EYDHAZjDQ7wCDFfpfjjVZwj5Nr0z3+Sq
         rG7YAAhnbPLIOiYH10Z5IxZqgwjFs9rzD1TI4MPF2pCk42kx/lLb+QSWyut8daKw6qeg
         oTQD4bIaZQCqPBCA0HzNr51bg6/V6wdNi+Pg0V0Yi5nWnJNmag1EuAIbHTnCl/mJ8rLy
         HfonUXY8TdYAa+/6kKQ4sStcTKg2RzLd4vIn5w+DKhlw5aknIVTDf4gFipJZSsn92ykH
         1Klg==
X-Gm-Message-State: AOAM5311tIot3g/wyfCvYXlVY0xtWL3WiJryX+G+yeq3Fy2O2hfGGhG4
        aOHzqrFHWh24FV7Su3IRZ7gOFnMte7VCIzbQTe9x3bbLkb29AQ==
X-Google-Smtp-Source: ABdhPJxFnslEBpGEJWaYWxYyZTiHJg86Tg94aszG9Pjc9yeHqbZctxCojU69sD4XYW5F/WVc+U8jAxYZo1EU7p6sp/8=
X-Received: by 2002:a05:6902:513:: with SMTP id x19mr19383163ybs.239.1604926808747;
 Mon, 09 Nov 2020 05:00:08 -0800 (PST)
MIME-Version: 1.0
References: <20201109102618.2495-1-socketcan@hartkopp.net> <20201109102618.2495-5-socketcan@hartkopp.net>
In-Reply-To: <20201109102618.2495-5-socketcan@hartkopp.net>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 9 Nov 2020 21:59:57 +0900
Message-ID: <CAMZ6RqJz+G-R6LF=jU22kcYPBwTCOB7XmcY+GTNLmfm+-9rvUw@mail.gmail.com>
Subject: Re: [PATCH v4 4/7] can: replace can_dlc as variable/element for
 payload length
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 9 Nov 2020 at 19:26, Oliver Hartkopp wrote:
> diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
> index b2e8df8e4cb0..72671184a7a2 100644
> --- a/include/linux/can/dev.h
> +++ b/include/linux/can/dev.h
> @@ -183,12 +183,12 @@ static inline void can_set_static_ctrlmode(struct net_device *dev,
>         /* override MTU which was set by default in can_setup()? */
>         if (static_mode & CAN_CTRLMODE_FD)
>                 dev->mtu = CANFD_MTU;
>  }
>
> -/* get data length from can_dlc with sanitized can_dlc */
> -u8 can_dlc2len(u8 can_dlc);
> +/* get data length from raw data length code (DLC) */

/*
 * convert a given data length code (dlc) of an FD CAN frame into a
 * valid data length of max. 64 bytes.
 */

I missed this point during my previous review: the can_dlc2len() function
is only valid for CAN FD frames. Comments should reflect this fact.

> +u8 can_dlc2len(u8 dlc);

Concerning the name:
 * can_get_cc_len() converts a Classical CAN frame DLC into a data
   length.
 * can_dlc2len() converts an FD CAN frame DLC into a data length.

Just realized that both macro/function do similar things so we could
think of a similar naming as well.
 * Example 1: can_get_cc_len() and can_get_fd_len()
 * Example 2: can_cc_dlc2len() and can_fd_dlc2len()

Or we could simply leave things as they are, this is not a big issue
as long as the comments clearly state which one is for classical
frames and which one is for FD frames.

>
>  /* map the sanitized data length to an appropriate data length code */
>  u8 can_len2dlc(u8 len);

can_len2dlc() might be renamed (e.g. can_get_fd_dlc()) if Example 1
solution is chosen.

>  struct net_device *alloc_candev_mqs(int sizeof_priv, unsigned int echo_skb_max,

Yours sincerely,
Vincent Mailhol
