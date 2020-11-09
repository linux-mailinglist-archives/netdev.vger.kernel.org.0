Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F452AB5B5
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 12:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbgKILCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 06:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbgKILCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 06:02:39 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06AEC0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 03:02:39 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id k21so9318699ioa.9
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 03:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=46EkZmI/ZGOaVTRH8d812wliPaOk2GZewbl0v0F4Eyo=;
        b=YIOg4E4PN687iFY1IuJPotp2yw76l3Skp0u+NRw5/BGL3JjF2TllHuh++huJdAg3SC
         Nk7CwqYtWrD9EoGoMWh55KwVe/Rsb+4wPyd8MhWNllaSujmAcQsVAqID4C0NSJENKKss
         jqLxHoV7Q3K++ma7xC68GMjwd5CyvmORJ+ZN7r3SN66Bl8pmA9ibxSsncXIY0Y5Hmqb9
         Rd8aocrZMsrd87MhpaaqZVeuFnIOlWJft+6bcxwJvWAWTZJ88tCpgQ9KArRUkHgyj1om
         apufD9WlyaqPCSz6fYjQNvsAs7TdVg5ZhrW4HGOeljICcf17FCYRL43I4TrgVskhG23X
         vNVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=46EkZmI/ZGOaVTRH8d812wliPaOk2GZewbl0v0F4Eyo=;
        b=IdnSWdt3ktjO71J03qi5mHSvbNs/3Z9Yv2jNndXNF5wiBRcqr3OSPy6hMhY7d5//UV
         8vJf/vN/68wAllHUkzGmpKEgEORAMrcIEzMQIQeD/QLXTHNZYb5TU2c1y007prklVzCt
         zJ2vN0MitZsdmzlmCbuqH520mo3DDRwSyALduy6lOUnWQxqKd00jmt9WdjRNYG5KIyWU
         K5HsjZgxpi65skl7WrIz+o0Dv+9QkOllLnkW4zPEEuKyWMJGt60L9hzanxCt4zSAYcaD
         eklWD2N4PgDfHsSwwNdKAV/CI2ZHT1qC36EADHaK4qCQsnQu+l3dCMbmB82xuN6o4hR+
         5Hwg==
X-Gm-Message-State: AOAM532ZrZzPzcDaZf1CBHts1eDLfwcy5CTgMk1AjYBrSGWiWKrpFE4A
        LrAXsmC1mZBWY8/3tVl69ujXEY0vjB8tW7GLmVbW3uy065A=
X-Google-Smtp-Source: ABdhPJyMos/XpSZtJdbJIlOcmZUaM9i+lTLg3k8Opi85W33ruqy5oO29rySH4YpioWiudkEZjTL3zvfSQtW3PUHsJuE=
X-Received: by 2002:a5e:980e:: with SMTP id s14mr9648251ioj.195.1604919758865;
 Mon, 09 Nov 2020 03:02:38 -0800 (PST)
MIME-Version: 1.0
References: <1604913614-19432-1-git-send-email-wenan.mao@linux.alibaba.com>
 <1604914417-24578-1-git-send-email-wenan.mao@linux.alibaba.com>
 <CANn89iKiNdtxaL_yMF6=_8=m001vXVaxvECMGbAiXTYZjfj3oQ@mail.gmail.com> <3b92167c-201c-e85d-822d-06f0c9ac508c@linux.alibaba.com>
In-Reply-To: <3b92167c-201c-e85d-822d-06f0c9ac508c@linux.alibaba.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 Nov 2020 12:02:27 +0100
Message-ID: <CANn89i+oS75TVKBDOBrr7Ff55Uctq4_HUcM_05Ed8kUL1HkHLw@mail.gmail.com>
Subject: Re: [PATCH net v2] net: Update window_clamp if SOCK_RCVBUF is set
To:     Mao Wenan <wenan.mao@linux.alibaba.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 11:12 AM Mao Wenan <wenan.mao@linux.alibaba.com> wro=
te:
>
>
>
> =E5=9C=A8 2020/11/9 =E4=B8=8B=E5=8D=885:56, Eric Dumazet =E5=86=99=E9=81=
=93:
> > On Mon, Nov 9, 2020 at 10:33 AM Mao Wenan <wenan.mao@linux.alibaba.com>=
 wrote:
> >>
> >> When net.ipv4.tcp_syncookies=3D1 and syn flood is happened,
> >> cookie_v4_check or cookie_v6_check tries to redo what
> >> tcp_v4_send_synack or tcp_v6_send_synack did,
> >> rsk_window_clamp will be changed if SOCK_RCVBUF is set,
> >> which will make rcv_wscale is different, the client
> >> still operates with initial window scale and can overshot
> >> granted window, the client use the initial scale but local
> >> server use new scale to advertise window value, and session
> >> work abnormally.
> >
> > What is not working exactly ?
> >
> > Sending a 'big wscale' should not really matter, unless perhaps there
> > is a buggy stack at the remote end ?
> 1)in tcp_v4_send_synack, if SO_RCVBUF is set and
> tcp_full_space(sk)=3D65535, pass req->rsk_window_clamp=3D65535 to
> tcp_select_initial_window, rcv_wscale will be zero, and send to client,
> the client consider wscale is 0;
> 2)when ack is back from client, if there is no this patch,
> req->rsk_window_clamp is 0, and pass to tcp_select_initial_window,
> wscale will be 7, this new rcv_wscale is no way to advertise to client.
> 3)if server send rcv_wind to client with window=3D63, it consider the rea=
l
> window is 63*2^7=3D8064, but client consider the server window is only
> 63*2^0=3D63, it can't send big packet to server, and the send-q of client
> is full.
>

I see, please change your patches so that tcp_full_space() is used _once_

listener sk_rcvbuf can change under us.

I really have no idea how window can be set to 63, so please send us
the packetdrill test once you have it.
