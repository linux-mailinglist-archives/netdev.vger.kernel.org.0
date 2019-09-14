Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2959B2BC4
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 17:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfINPMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 11:12:40 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38590 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfINPMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 11:12:40 -0400
Received: by mail-qt1-f193.google.com with SMTP id j31so10858772qta.5
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 08:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nDOQfrTTotF9biq9e5oOIDsuvHOAkucjJV3eqe8Xn6I=;
        b=FkFzafmOREpEanh7ZtXFqQH8lB6anl+NvwJiu4wMyaPQyvOcGE8QcTqaHwXyVDWfDq
         9Eel5f8a4HgKf77fz3bspm4t+q7w34PmSM1MDYE66tzfZtb7im+jo+rL6qe2kReJe6XV
         wKlQ6RYlTpEjyw13jfg/PdgOX1Qlqbdd373H2EXZZb6hPGUDFDXuYVpiaH3lALxqmOi8
         a5TG6sUj4a6u/mqpBhG70DXCYdwiNJ5urr/W0gUP4m0T2gVsJ+gKNLcd/bbaSQ8Qppkx
         9elfMjeRMSuTUwlHgmH7PgVNoPcCclINvm1pua2DFgf0Z32F663OPQoYE4NU91tlhatZ
         so+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nDOQfrTTotF9biq9e5oOIDsuvHOAkucjJV3eqe8Xn6I=;
        b=jnb/ldflBG6hEd9DOS1RUOXOHWhRFQAtkG4ViIUffKkrHVdLfQhxzMVVqhNfkw+vdk
         9T1zlyBCzl6jXz5Mk17+Dm0u+HIHfCQdsc8wvMrCkXOtCbhjQmBOHxReBvK1h/AZkL8j
         2JO4ong4ar/mvwLK8pVFPmQpxLFtIHVII5C1qXA5CR2bzS5KKI9XkT71kqasRdQkYMnI
         HZDLAHRprL5Mod191Rlp0YeDox/jw0owiwtJTt1oVH0Re5ANLk4eTo7UJBaao+/8N02c
         b02JtVWPa6YU1Kmo970MhbNcXG9uwVOCWff5Q5+yLIaBUkQYwGbmfAtlbVsGDIBrvxXG
         LaFA==
X-Gm-Message-State: APjAAAVsCnGgy41wsKkSbejVZ3+412JpL4iqYoGRNgKrIg6aIFA5GbJa
        /HyQUmAvoQhCt072eewZhflMzuoK5I+LmK3k+YlnYUdj
X-Google-Smtp-Source: APXvYqzvnLbSnLhs0nk8a6/rsuZ9Gstikx7osWNdJ55EXBYuenGAqgKlD81IvGFavwGQAcvNl2YjqisdMpWH2LFYr7w=
X-Received: by 2002:ac8:7494:: with SMTP id v20mr8619780qtq.309.1568473959533;
 Sat, 14 Sep 2019 08:12:39 -0700 (PDT)
MIME-Version: 1.0
References: <1bfbf329c5b3649a6c6362350a0d609ff184deba.1568367947.git.lucien.xin@gmail.com>
In-Reply-To: <1bfbf329c5b3649a6c6362350a0d609ff184deba.1568367947.git.lucien.xin@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Sat, 14 Sep 2019 08:12:02 -0700
Message-ID: <CALDO+Sb9ypvY1rsngHGMbFBDt8-rKcuVKrk8T1+ohSYXHhFMnQ@mail.gmail.com>
Subject: Re: [PATCH net] ip6_gre: fix a dst leak in ip6erspan_tunnel_xmit
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 2:45 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> In ip6erspan_tunnel_xmit(), if the skb will not be sent out, it has to
> be freed on the tx_err path. Otherwise when deleting a netns, it would
> cause dst/dev to leak, and dmesg shows:
>
>   unregister_netdevice: waiting for lo to become free. Usage count = 1
>
> Fixes: ef7baf5e083c ("ip6_gre: add ip6 erspan collect_md mode")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

LGTM, thanks for the fix!
Acked-by: William Tu <u9012063@gmail.com>

>  net/ipv6/ip6_gre.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
> index dd2d0b96..d5779d6 100644
> --- a/net/ipv6/ip6_gre.c
> +++ b/net/ipv6/ip6_gre.c
> @@ -968,7 +968,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
>                 if (unlikely(!tun_info ||
>                              !(tun_info->mode & IP_TUNNEL_INFO_TX) ||
>                              ip_tunnel_info_af(tun_info) != AF_INET6))
> -                       return -EINVAL;
> +                       goto tx_err;
>
>                 key = &tun_info->key;
>                 memset(&fl6, 0, sizeof(fl6));
> --
> 2.1.0
>
