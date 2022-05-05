Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D134151C0A9
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379457AbiEENbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377471AbiEENbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:31:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C343856F82;
        Thu,  5 May 2022 06:28:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79D65B82D55;
        Thu,  5 May 2022 13:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B996AC385B0;
        Thu,  5 May 2022 13:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651757288;
        bh=LgiSSpGi9/Izwl+t6cGvmeuD0laNo4VcoH7MXWIY+cA=;
        h=In-Reply-To:References:Subject:To:Cc:From:Date:From;
        b=c5ep4bMKMm5WTVUQG9oPbSPBhr7yk4Gm+wM3dMTXytySi9kit9GM2X2/ahS6qcJpT
         ILksp8TLJbjtGswmNAO03FfME1Xz1N1HZe9rARY5mFt31Fj6s0o2fjc7f5mALFj2Nw
         uvlrNSs2cFUjReqcMSPsil/0UqUd+17qQTxfInB7uOfygEp7EKwEFTO3yeJn9b42UV
         0T11vaUVIoUNsmK/lQrySDnpOhpaFa14KcgMsuQT6k483iCslvdt1nJmFajmvJccuI
         +I3IBZGWW7sCo6XUe83+7ry+B9UeutQEpP2pSUYP7JjDfzZiVnSrD2fqwB2wsFPBQ/
         r3k/XtmbbHQKg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220505123803.17553-1-carlos.fernandez@technica-engineering.de>
References: <[PATCH] net/macsec copy salt to MACSec ctx for XPN> <20220505123803.17553-1-carlos.fernandez@technica-engineering.de>
Subject: Re: [PATCH] net: macsec: XPN Salt copied before passing offload context
To:     Carlos Fernandez <carlos.escuin@gmail.com>,
        carlos.fernandez@technica-enineering.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
Cc:     Carlos Fernandez <carlos.fernandez@technica-engineering.de>
From:   Antoine Tenart <atenart@kernel.org>
Message-ID: <165175728541.217313.17093503108252590709@kwain>
Date:   Thu, 05 May 2022 15:28:05 +0200
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

(Note: please use "[PATCH net]" for fixes and "[PATCH net-next]" for
improvements in the subject when submitting patches to the networking
subsystem).

Quoting Carlos Fernandez (2022-05-05 14:38:03)
> When macsec offloading is used with XPN, before mdo_add_rxsa
> and mdo_add_txsa functions are called, the key salt is not
> copied to the macsec context struct.
>=20
> Fix by copying salt to context struct before calling the
> offloading functions.

The commit message and title are referring to the XPN salt only, but
there is another XPN specific entry being moved by this commit. I would
suggest to update the commit title to:
"net: macsec: retrieve the XPN attributes before offloading"

> Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites")
> Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
> ---
>  drivers/net/macsec.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index 832f09ac075e..4f2bd3d722c3 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -1804,6 +1804,14 @@ static int macsec_add_rxsa(struct sk_buff *skb, st=
ruct genl_info *info)
> =20
>         rx_sa->sc =3D rx_sc;
> =20
> +       if (secy->xpn) {
> +               rx_sa->ssci =3D nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
> +               nla_memcpy(rx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SA=
LT],
> +                          MACSEC_SALT_LEN);
> +       }
> +
> +       nla_memcpy(rx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEY=
ID_LEN);

Is the key id part related to the XPN offloading not working?

Otherwise, it makes sense to copy all attributes before offloading the
operation but this should probably be in its own patch targeted at
net-next. (Same for the txsa part).

>         /* If h/w offloading is available, propagate to the device */
>         if (macsec_is_offloaded(netdev_priv(dev))) {
>                 const struct macsec_ops *ops;
> @@ -1826,13 +1834,6 @@ static int macsec_add_rxsa(struct sk_buff *skb, st=
ruct genl_info *info)
>                         goto cleanup;
>         }
> =20
> -       if (secy->xpn) {
> -               rx_sa->ssci =3D nla_get_ssci(tb_sa[MACSEC_SA_ATTR_SSCI]);
> -               nla_memcpy(rx_sa->key.salt.bytes, tb_sa[MACSEC_SA_ATTR_SA=
LT],
> -                          MACSEC_SALT_LEN);
> -       }
> -
> -       nla_memcpy(rx_sa->key.id, tb_sa[MACSEC_SA_ATTR_KEYID], MACSEC_KEY=
ID_LEN);
>         rcu_assign_pointer(rx_sc->sa[assoc_num], rx_sa);
> =20
>         rtnl_unlock();

Thanks!
Antoine
