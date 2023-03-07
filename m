Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6956ADA83
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjCGJjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjCGJjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:39:01 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1E938E89;
        Tue,  7 Mar 2023 01:38:59 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7CC6840004;
        Tue,  7 Mar 2023 09:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678181938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NDq6dn5XEZ71hXN61bU2yKt3eeIpO4KyeL1VjmE9bE8=;
        b=A6nvvRdSS5kpgFpOPvgMexh7eJZlPxmw6Z0aTE3+5g3Ep+dHs0rWa0Rf+weD8TcTlug+IH
        qX0PYpRYU7XWS9P75itYVa10bfR70eF/WEsqH09SQf7r61xWwj2ueIceEBKW4UAVSt5av3
        lf62gTpalVFwOMpBktqJHw2O9EOOrsmvVvWcA/QumZPcXEkZxu83zMuftWycJqTRFO5r84
        6k722+eRbN76rK5G5ERfrLgeGNbNC98rZ9OeiL9Wjh5D728jGwBObq5NQjtDIdeallmLCi
        6Z7RIq1wFyk0QPlEZm9naIchhqUtt1UTeBJdUul/8aO8L0f5EVIbyRMjgUvJhA==
Date:   Tue, 7 Mar 2023 10:38:54 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Dongliang Mu <dzm91@hust.edu.cn>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot+bd85b31816913a32e473@syzkaller.appspotmail.com,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ieee802154: fix a null pointer in
 nl802154_trigger_scan
Message-ID: <20230307103854.6536ad12@xps-13>
In-Reply-To: <20230307090546.994258-1-dzm91@hust.edu.cn>
References: <20230307090546.994258-1-dzm91@hust.edu.cn>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dongliang,

dzm91@hust.edu.cn wrote on Tue,  7 Mar 2023 17:05:46 +0800:

> There is a null pointer dereference if NL802154_ATTR_SCAN_TYPE is
> not set by the user.
>=20
> Fix this by adding a null pointer check.
>=20
> Reported-and-tested-by: syzbot+bd85b31816913a32e473@syzkaller.appspotmail=
.com

Still wrong :)

> Fixes: a0b6106672b5 ("ieee802154: Convert scan error messages to extack")
> Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
> ---
> v1->v2: add fixes tag
>  net/ieee802154/nl802154.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> index 2215f576ee37..1cf00cffd63f 100644
> --- a/net/ieee802154/nl802154.c
> +++ b/net/ieee802154/nl802154.c
> @@ -1412,7 +1412,8 @@ static int nl802154_trigger_scan(struct sk_buff *sk=
b, struct genl_info *info)
>  		return -EOPNOTSUPP;
>  	}
> =20
> -	if (!nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE])) {
> +	if (!info->attrs[NL802154_ATTR_SCAN_TYPE] ||

Already handled :)

> +	    !nla_get_u8(info->attrs[NL802154_ATTR_SCAN_TYPE])) {

Also handled!

>  		NL_SET_ERR_MSG(info->extack, "Malformed request, missing scan type");
>  		return -EINVAL;
>  	}


Thanks,
Miqu=C3=A8l
