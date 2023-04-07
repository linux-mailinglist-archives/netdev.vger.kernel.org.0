Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77FE06DA9AE
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 10:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbjDGIB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 04:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjDGIB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 04:01:58 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6392B72A6;
        Fri,  7 Apr 2023 01:01:56 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C05C1C000A;
        Fri,  7 Apr 2023 08:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680854513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n3uuqsOlvs3XNK3PzQWp2JSfYYjttHyKXHEcVE6mgVA=;
        b=M1BHxFNU49xqkzn3E8ObMtEZ/qHw5sHoEJUIBfL3Bo2WPl+LtzkCWCXqW//l5A/1Naimn1
        aj6v3DmVH1qzYMGY38pQzRg2uXxvOvD80LOAcrBzzoqOnCll9LGtrp/uUaeQxH8xm6uK+h
        EDoA+7t09Hs1I3TENSPJLc1SeO88z1S+Sjhk7Yw0Ka84whPrEFiWUgzUFJSErvkuCw5Cbu
        g7e5vWm49GaA2VpxfYDN1oF0LJtLRIpJ4wVsXlEocL5FfReAq8sFqssRSW0d61bOp5CYD3
        3d7hxJG3IiC56uDgrAe9hky1c42DhDi3FUO4UyV06RvMyUHiXMaFtbOikNW/ww==
Date:   Fri, 7 Apr 2023 10:01:48 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Chen Aotian <chenaotian2@163.com>
Cc:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ieee802154: hwsim: Fix possible memory leaks
Message-ID: <20230407100148.16a0531e@xps-13>
In-Reply-To: <20230407012626.45500-1-chenaotian2@163.com>
References: <20230407012626.45500-1-chenaotian2@163.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chen,

chenaotian2@163.com wrote on Fri,  7 Apr 2023 09:26:26 +0800:

> After replacing e->info, it is necessary to free the old einfo.
>=20
> Signed-off-by: Chen Aotian <chenaotian2@163.com>
> ---
>  drivers/net/ieee802154/mac802154_hwsim.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee8=
02154/mac802154_hwsim.c
> index 8445c2189..6e7e10b17 100644
> --- a/drivers/net/ieee802154/mac802154_hwsim.c
> +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> @@ -685,7 +685,7 @@ static int hwsim_del_edge_nl(struct sk_buff *msg, str=
uct genl_info *info)
>  static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *inf=
o)
>  {
>  	struct nlattr *edge_attrs[MAC802154_HWSIM_EDGE_ATTR_MAX + 1];
> -	struct hwsim_edge_info *einfo;
> +	struct hwsim_edge_info *einfo, *einfo_old;
>  	struct hwsim_phy *phy_v0;
>  	struct hwsim_edge *e;
>  	u32 v0, v1;
> @@ -723,8 +723,10 @@ static int hwsim_set_edge_lqi(struct sk_buff *msg, s=
truct genl_info *info)
>  	list_for_each_entry_rcu(e, &phy_v0->edges, list) {
>  		if (e->endpoint->idx =3D=3D v1) {
>  			einfo->lqi =3D lqi;
> +			einfo_old =3D rcu_dereference(e->info);
>  			rcu_assign_pointer(e->info, einfo);
>  			rcu_read_unlock();
> +			kfree_rcu(einfo_old, rcu);
>  			mutex_unlock(&hwsim_phys_lock);
>  			return 0;
>  		}

I'm not an RCU expert but the fix LGTM.

Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>

What about adding:

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Cc: stable@vger.kernelorg

Thanks,
Miqu=C3=A8l
