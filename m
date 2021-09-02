Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CC93FF4DE
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 22:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346200AbhIBU0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 16:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345944AbhIBU0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 16:26:30 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC51AC061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 13:25:31 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id mf2so7233583ejb.9
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 13:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BkqipOImaulc8pT1rr5wO19GmLw8mGgUxtubHurjJNM=;
        b=HOzdZRxfrMMa8MIt9t8UNJ2S+h5KpSGPHpsafgoOiJhqV5q6Xg+D5qjiaSgewWirwF
         3I4GYhptaqHLjHuvnA85aDESaRZPghmoRdgA71NBzirEZZ0RlS61LgMufN/5eOxFP5S2
         569ehr5dGlSuF9BY+bDQEerYdlBGC96HcPkRbC2zBHRGv+YJPpLVzbF9vIZqDBZFrRxo
         DGsJJ9vTqSEpn3LvfePPauSKygQVJqpyB7Q+S5uX/msXjOHXv4Viijfuh+8Q76T54ZZW
         xLuhmAZGHddA387jJasxUpfb/LttgsyK5kfRmlij8xO/073tJEpCxH5WTEw8WGoWWdbg
         KVBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BkqipOImaulc8pT1rr5wO19GmLw8mGgUxtubHurjJNM=;
        b=ljl1YONp175eG3NVjltgQulsCL3qEJ3JBg2j1lNmvYMso1LmktgcUkQvSsTuczgLR9
         tuaUvMD/qqZoKZBArDfPEho+VsvA+f52PEX7PKwgrtORoj2x4+tka1olZmDfasE3ik9r
         1sI8Bbcxgm9esxSSpVLQNTru+oluo1ykWK+EmofW62v0Qnje5CER02BB+qnOycVCccuf
         KlqwOh1IGbYasZtAoYBqwcmHvYQfy99+ck9KFSdsf2ngDKorLi44Uvv3ZObbVFRGM+AA
         Vgzl4yzNZ+GNWN9OvfXTWmTpDosUkJuys01BTUdIjl4fZcd8xDnInRGj26QQqH8NpYsm
         UP1w==
X-Gm-Message-State: AOAM530i+99ZDWK/BXnmPtWyFoUGUA71ocPW3MFNRoUWs7QOZAqjeBID
        oOGyRwRsAWQhye45yB5fHNjpik1Of5LQ6Xr6BgA=
X-Google-Smtp-Source: ABdhPJyDDA5Y9NprQfvjsRx8ZsqebsO2N7MqdlZ3WX4zITFJMHDL+jUXXSH8uhcI4jidAOdx4ckKQNOyAEezHSoCmS4=
X-Received: by 2002:a17:907:1dcf:: with SMTP id og15mr7798ejc.470.1630614329473;
 Thu, 02 Sep 2021 13:25:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210902193447.94039-1-willemdebruijn.kernel@gmail.com> <20210902193447.94039-2-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20210902193447.94039-2-willemdebruijn.kernel@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 2 Sep 2021 13:25:18 -0700
Message-ID: <CAKgT0UdhaUp0jcNZSzMu=_OezwqKNHP47u0n_XUkpO_SbSV8hA@mail.gmail.com>
Subject: Re: [PATCH net] ip_gre: validate csum_start only if CHECKSUM_PARTIAL
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        chouhan.shreyansh630@gmail.com,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 12:38 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> Only test integrity of csum_start if checksum offload is configured.
>
> With checksum offload and GRE tunnel checksum, gre_build_header will
> cheaply build the GRE checksum using local checksum offload. This
> depends on inner packet csum offload, and thus that csum_start points
> behind GRE. But validate this condition only with checksum offload.
>
> Link: https://lore.kernel.org/netdev/YS+h%2FtqCJJiQei+W@shredder/
> Fixes: 1d011c4803c7 ("ip_gre: add validation for csum_start")
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  net/ipv4/ip_gre.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> index 177d26d8fb9c..09311992a617 100644
> --- a/net/ipv4/ip_gre.c
> +++ b/net/ipv4/ip_gre.c
> @@ -473,8 +473,11 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
>
>  static int gre_handle_offloads(struct sk_buff *skb, bool csum)
>  {
> -       if (csum && skb_checksum_start(skb) < skb->data)
> +       /* Local checksum offload requires csum offload of the inner packet */
> +       if (csum && skb->ip_summed == CHECKSUM_PARTIAL &&
> +           skb_checksum_start(skb) < skb->data)
>                 return -EINVAL;
> +
>         return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
>  }

So a few minor nits.

First I think we need this for both v4 and v6 since it looks like this
code is reproduced for net/ipv6/ip6_gre.c.

Second I don't know if we even need to bother including the "csum"
portion of the lookup since that technically is just telling us if the
GRE tunnel is requesting a checksum or not and I am not sure that
applies to the fact that the inner L4 header is going to be what is
requesting the checksum offload most likely.

Also maybe this should be triggering a WARN_ON_ONCE if we hit this as
the path triggering this should be fixed rather than us silently
dropping frames. We should be figuring out what cases are resulting in
us getting CHECKSUM_PARTIAL without skb_checksum_start being set.
