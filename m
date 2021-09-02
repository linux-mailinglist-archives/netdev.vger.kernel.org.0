Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDF53FF4E5
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 22:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346355AbhIBU2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 16:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346230AbhIBU2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 16:28:44 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC293C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 13:27:45 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id u19so4773753edb.3
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 13:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xYZaL+wrh+6dGZhTR+5h+iylhbNi5kNWyCVCYtIid9A=;
        b=FuvN7bCphMyoJN/bSkJWbwESuaupi7+tPsaZ9F7TDIqOCYVgqfXsJQ5ilXOYbhJkO+
         STWiXBlmAwlpOfK9AV1lRXbPNGczsqgWiC4nY124GCs3ycbEmeEHOtI9dHR2gqgXFZy2
         OVQtWLuj1uHBR96cgOO0cdCjn3A07ISUOCiezzEZdc4ZQPtJflLHQzvN+y4N5qpwhV7D
         etFqlEVDxbrYRn9yDKvioyXeY+q1XVyY5OVMatJKMefbPu08umMwFdUGskehI1oZa5cv
         TlKwy2PbAemxy4qMtO042l5MsMW+xD1XNmBSWXZToeY78PLJd2OiUKojjCzNcMLbdWXm
         30og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xYZaL+wrh+6dGZhTR+5h+iylhbNi5kNWyCVCYtIid9A=;
        b=Y5/ZT6zJNdi1pOYiAvvHL3C0RmTACyalaIV76HxD7vpbI3WUm4VlMhBs/hhTbI0bmb
         0XB37PQazSf7p37tRNlzeIXs2lG7JAhIdLckSrPZ+TZNYw++S/ORS9DOc+s6BB5EecNc
         EQezXUcuSIx1NvcABLqrLnx9WCWMEoaJz+EMIwYktX0e3Ma3WQuZNL/FKk6cFizzs9U8
         1mEqB1jlq3N4MX6gM8P76jnZ6iK8tMSFGVnPSOr0dchAS33bbORr/zUgyupYY6tK2E6y
         /qlmXRW0Bimg5OGUsyUtX3yNG3xV6/+EU4nk5pMcjUwC4+4fTulMF2TZzObq69gxaj5o
         /kmw==
X-Gm-Message-State: AOAM532lRr8ovGb0pKk2QuycIsFPdy9jWsuBpnkPzMLCdCWFWth5OI4f
        +pfgEtb+N3xcX1x3dYTXsRu0UVrYu3gGHRgT1cs=
X-Google-Smtp-Source: ABdhPJx62NCPrdbEYhkpxkYE8BGOUZ/7UjNHlPU6h69shfFT5icpz+5nb38rMUCtBzBxIcJs2zN+Peu88etkJQl/y5o=
X-Received: by 2002:aa7:d40b:: with SMTP id z11mr186189edq.224.1630614464301;
 Thu, 02 Sep 2021 13:27:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210902193447.94039-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20210902193447.94039-1-willemdebruijn.kernel@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 2 Sep 2021 13:27:33 -0700
Message-ID: <CAKgT0Uc43z1qZr+wsB-UaxKV-3_RMjA3aw_LeeX-HswTvxitng@mail.gmail.com>
Subject: Re: [PATCH net] ip6_gre: validate csum_start only if CHECKSUM_PARTIAL
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

On Thu, Sep 2, 2021 at 12:36 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> Only test integrity of csum_start if field is defined.
>
> With checksum offload and GRE tunnel checksum, gre_build_header will
> cheaply build the GRE checksum using local checksum offload. This
> depends on inner packet csum offload, and thus that csum_start points
> behind GRE. But validate this condition only with checksum offload.
>
> Link: https://lore.kernel.org/netdev/YS+h%2FtqCJJiQei+W@shredder/
> Fixes: 9cf448c200ba ("ip6_gre: add validation for csum_start")
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  net/ipv6/ip6_gre.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
> index 7baf41d160f5..c456bc7f7cdc 100644
> --- a/net/ipv6/ip6_gre.c
> +++ b/net/ipv6/ip6_gre.c
> @@ -629,8 +629,11 @@ static int gre_rcv(struct sk_buff *skb)
>
>  static int gre_handle_offloads(struct sk_buff *skb, bool csum)
>  {
> -       if (csum && skb_checksum_start(skb) < skb->data)
> +       /* Local checksum offload requires csum offload of the inner packet */
> +       if (csum && skb->ip_summed == CHECKSUM_PARTIAL &&
> +           skb_checksum_start(skb) < skb->data)
>                 return -EINVAL;
> +
>         return iptunnel_handle_offloads(skb,
>                                         csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
>  }

Didn't see this come through until I had replied to the other patch.
Same comments apply here. The "csum" value probably doesn't need to be
checked when checking skb_checksum_start, and maybe this should
trigger a WARN_ON_ONCE since it should be rare and we should be fixing
any path that is requesting CHECKSUM_PARTIAL without setting
skb_checksum_start.
