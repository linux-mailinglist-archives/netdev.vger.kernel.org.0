Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261A767C7B5
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 10:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbjAZJqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 04:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjAZJqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 04:46:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D10BCC10
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 01:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674726358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2SYkSovMaW2XoSXHsrHI+434w+NAs7lDBuGn6R/cFfA=;
        b=DJGTPurvJVPDkKEbXMqCNeKjRGwXPWJ+ElC9P/Hism4aOhO4H6vRa9Qwx19WUj0MB5hYZ2
        A5HJE+F20iTT6Vtr3xTfbUEfZAsJj1GPyrbUA4RCnV2HqRuf3wWODKE8QWx645TaaRGlwS
        4vThQuC+S4DzB+eJcsESJorGtNAIOzE=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-158-XOMGNOUDMWCuQm4WOVpqzg-1; Thu, 26 Jan 2023 04:45:56 -0500
X-MC-Unique: XOMGNOUDMWCuQm4WOVpqzg-1
Received: by mail-qv1-f71.google.com with SMTP id ng1-20020a0562143bc100b004bb706b3a27so784866qvb.20
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 01:45:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2SYkSovMaW2XoSXHsrHI+434w+NAs7lDBuGn6R/cFfA=;
        b=Tjqs0JBGdBLFdRxXnaJ14XES/6VN9cOhcbs0J25Z8yrPD/mcwhTATSR76NOlloOuYo
         Q5tfuoKv2AyO+s+dm7i7800S6SYjtnPMDoo8vcRo7Jem4AWWsQ+bILkUJwn6GGLuEPSf
         oHmJmcy6831RAFMsMecaiJNvh2EMTCrKW/13+RcBwYykPrtf97+jGq6W8uWVncFsGq+o
         BbyFnBuUGT329oygrnOzKLuT7t7lIo2u6Sfa6Q+0A/Df9U3xCl5wHecsKUIwD+I7LpAB
         GXoT42JwybV3ssSFiEihVfy+ZGfigGa7bg6C4fjt1dPkP1XD/u0Chq/ng4vHnIgTAxfB
         +pEw==
X-Gm-Message-State: AFqh2kogx+D0IBI5Rjn+jP56AB9IFlD69A/RAhgw54ckYZHGbpj3UFIQ
        D80QrSGb9Z9Zu7iWoJA9erc6Vl4Blejm9j1ejt47CA+n4GiZ2APBVe6ppqWIJKlXSsOlnxP9KzZ
        ei/mpFuKterm4TEvS
X-Received: by 2002:ac8:138c:0:b0:3b6:2be5:a2f7 with SMTP id h12-20020ac8138c000000b003b62be5a2f7mr50021944qtj.54.1674726356172;
        Thu, 26 Jan 2023 01:45:56 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtuGY6SKfeImfr/sz3V+kwZi70EAHbkkSoDj6gfrheVzh+xfVtlWKWYkwuXC5dTnUz5Rj/MrA==
X-Received: by 2002:ac8:138c:0:b0:3b6:2be5:a2f7 with SMTP id h12-20020ac8138c000000b003b62be5a2f7mr50021922qtj.54.1674726355827;
        Thu, 26 Jan 2023 01:45:55 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id 2-20020ac82082000000b003ad373d04b6sm441378qtd.59.2023.01.26.01.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 01:45:55 -0800 (PST)
Message-ID: <75f6e5d0e42a8b9895c1b2330c373da9ed7f41db.camel@redhat.com>
Subject: Re: [PATCH net-next v1 01/10] xfrm: extend add policy callback to
 set failure reason
From:   Paolo Abeni <pabeni@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        intel-wired-lan@lists.osuosl.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Raju Rangoju <rajur@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Veaceslav Falico <vfalico@gmail.com>
Date:   Thu, 26 Jan 2023 10:45:50 +0100
In-Reply-To: <Y9Irgrgf3uxOjwUm@unreal>
References: <cover.1674560845.git.leon@kernel.org>
         <c182cae29914fa19ce970859e74234d3de506853.1674560845.git.leon@kernel.org>
         <20230125110226.66dc7eeb@kernel.org> <Y9Irgrgf3uxOjwUm@unreal>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-01-26 at 09:28 +0200, Leon Romanovsky wrote:
> On Wed, Jan 25, 2023 at 11:02:26AM -0800, Jakub Kicinski wrote:
> > On Tue, 24 Jan 2023 13:54:57 +0200 Leon Romanovsky wrote:
> > > -	err =3D dev->xfrmdev_ops->xdo_dev_policy_add(xp);
> > > +	err =3D dev->xfrmdev_ops->xdo_dev_policy_add(xp, extack);
> > >  	if (err) {
> > >  		xdo->dev =3D NULL;
> > >  		xdo->real_dev =3D NULL;
> > >  		xdo->type =3D XFRM_DEV_OFFLOAD_UNSPECIFIED;
> > >  		xdo->dir =3D 0;
> > >  		netdev_put(dev, &xdo->dev_tracker);
> > > -		NL_SET_ERR_MSG(extack, "Device failed to offload this policy");
> >=20
> > In a handful of places we do:
> >=20
> > if (!extack->msg)
> > 	NL_SET_ERR_MSG(extack, "Device failed to offload this policy");
> >=20
> > in case the device did not provide the extack.
> > Dunno if it's worth doing here.
>=20
> Honestly, I followed devlink.c which didn't do that, but looked again
> and found that devlink can potentially overwrite messages :)
>=20
> For example in this case:
>     997         err =3D ops->port_fn_state_get(port, &state, &opstate, ex=
tack);
>     998         if (err) {
>     999                 if (err =3D=3D -EOPNOTSUPP)
>    1000                         return 0;
>    1001                 return err;
>    1002         }
>    1003         if (!devlink_port_fn_state_valid(state)) {
>    1004                 WARN_ON_ONCE(1);
>    1005                 NL_SET_ERR_MSG_MOD(extack, "Invalid state read fr=
om driver");
>    1006                 return -EINVAL;
>    1007         }
>=20
>=20
> So what do you think about the following change, so we can leave
> NL_SET_ERR_MSG_MOD() in devlink and xfrm intact?=20
>=20
> diff --git a/include/linux/netlink.h b/include/linux/netlink.h
> index 38f6334f408c..d6f3a958e30b 100644
> --- a/include/linux/netlink.h
> +++ b/include/linux/netlink.h
> @@ -101,7 +101,7 @@ struct netlink_ext_ack {
>                                                         \
>         do_trace_netlink_extack(__msg);                 \
>                                                         \
> -       if (__extack)                                   \
> +       if (__extack && !__extack->msg)                 \
>                 __extack->_msg =3D __msg;                 \
>  } while (0)
>=20
> @@ -111,7 +111,7 @@ struct netlink_ext_ack {
>  #define NL_SET_ERR_MSG_FMT(extack, fmt, args...) do {                   =
      \
>         struct netlink_ext_ack *__extack =3D (extack);                   =
        \
>                                                                          =
      \
> -       if (!__extack)                                                   =
      \
> +       if (!__extack || __extack->msg)                                  =
      \
>                 break;                                                   =
      \
>         if (snprintf(__extack->_msg_buf, NETLINK_MAX_FMTMSG_LEN,         =
      \
>                      "%s" fmt "%s", "", ##args, "") >=3D                 =
        \
>=20

I think it makes sense. With the above patch 3/10 should be updated to
preserve the 'catch-all' error message, I guess.

Let's see what Jakub thinks ;)

Cheers,

Paolo

