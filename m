Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26FC76E5A4D
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 09:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjDRHTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 03:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjDRHTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 03:19:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676402107
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 00:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681802336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OFLrmPM4SY1LGfG6ef9nu/uLrU9eDtxg8RuZp9GHn+I=;
        b=hExuSfN0cMqA0/NkuzsxuI/to8kvPcNepckSEF8ya0CP1tuw2pfYo89FhIBjMGCgjkfu10
        J7o3udgLCYj6Xad/U2UlDF3vSE3SyiGn2l/6ToXMnNNPYdwSz8ZLDyBtNexfB8Q5CpAfTh
        aXIGphaOs4ql0/F8c4RfiT+1R4PGhBg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-AQYaxIhHNKa_BztsKPhvhw-1; Tue, 18 Apr 2023 03:15:45 -0400
X-MC-Unique: AQYaxIhHNKa_BztsKPhvhw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f0a16eb83bso5363455e9.0
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 00:15:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681802144; x=1684394144;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OFLrmPM4SY1LGfG6ef9nu/uLrU9eDtxg8RuZp9GHn+I=;
        b=VTwHBXJ2JesC/be3NXitUbqCiQZf1AMcnMTQxjKgcwI4seV61xIKOjigU3xk/zQXfb
         2tvbXQojG/U3w0TNWrMPm8mTsPm4cENLoK0lRQ1U0HnO/+H0D1lThXVcYlhuH6w2UO+h
         //dFwPxLweNVjUnRK98rWyG5/UzWAXQC0FQ1xO0x5W/bMMey15LOE8DB4Ks9YmttC7x9
         AGVZ20thOlBUJPaElhXIq9y3kwSji+QsMR70sFlJR+6uaMxhIG8dsX8N/+ghjhw6vK9e
         4z/1fOOXqpV51EAtCD5zzbc1/pdn4hp2nhJSd8SM58Q+uNXODhWnKGlsmjbn+n/RrRNw
         r/AQ==
X-Gm-Message-State: AAQBX9dAEVuyOghl/Xb85Esavnc9GZXWXJcKKQHYSNx7cHv5xI/U7ToR
        52nNydw49cDlkI5ieqNABKdBJu6o9MmL1S5Kz6KfKgqEQ2B47H3wu5Q3qx2papccVqIwEB7z2xn
        mCBk4aXow7hDoiU7SLlzIOJej
X-Received: by 2002:a05:600c:4588:b0:3f1:7579:3c66 with SMTP id r8-20020a05600c458800b003f175793c66mr3266376wmo.4.1681802144049;
        Tue, 18 Apr 2023 00:15:44 -0700 (PDT)
X-Google-Smtp-Source: AKy350bk8vtKBmPtxgaVJKyI9rBD8Abn8HTy6dEVyGUV89kSyowJkBnX4Q6NX+NLJE2i1bxpMGbepA==
X-Received: by 2002:a05:600c:4588:b0:3f1:7579:3c66 with SMTP id r8-20020a05600c458800b003f175793c66mr3266347wmo.4.1681802143688;
        Tue, 18 Apr 2023 00:15:43 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-229-200.dyn.eolo.it. [146.241.229.200])
        by smtp.gmail.com with ESMTPSA id 8-20020a05600c228800b003edef091b17sm13985291wmf.37.2023.04.18.00.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 00:15:43 -0700 (PDT)
Message-ID: <0b96894f4540d1d60761f92811a58c3844b6869d.camel@redhat.com>
Subject: Re: [PATCH v2 net-next] ax25: exit linked-list searches earlier
From:   Paolo Abeni <pabeni@redhat.com>
To:     Peter Lafreniere <peter@n8pjl.ca>, linux-hams@vger.kernel.org
Cc:     netdev@vger.kernel.org, error27@gmail.com
Date:   Tue, 18 Apr 2023 09:15:42 +0200
In-Reply-To: <20230414143357.5523-1-peter@n8pjl.ca>
References: <20230407142042.11901-1-peter@n8pjl.ca>
         <20230414143357.5523-1-peter@n8pjl.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-04-14 at 10:33 -0400, Peter Lafreniere wrote:
> There's no need to loop until the end of the list if we have a result.
>=20
> Device callsigns are unique, so there can only be one dev returned from
> ax25_addr_ax25dev(). If not, there would be inconsistencies based on
> order of insertion, and refcount leaks.
>=20
> We follow the same reasoning in ax25_get_route(), and additionally
> reorder conditions to skip calling ax25cmp() whenever possible.=20
>=20
> Signed-off-by: Peter Lafreniere <peter@n8pjl.ca>
> ---
> v1 -> v2
>  - Make ax25_get_route() return directly
>  - Reorder calls to ax25cmp() in ax25_get_route()
>  - Skip searching for default route once found in ax25_get_route()
>=20
>  net/ax25/ax25_dev.c   |  4 +++-
>  net/ax25/ax25_route.c | 25 +++++++++++++------------
>  2 files changed, 16 insertions(+), 13 deletions(-)
>=20
> diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
> index c5462486dbca..8186faea6b0d 100644
> --- a/net/ax25/ax25_dev.c
> +++ b/net/ax25/ax25_dev.c
> @@ -34,11 +34,13 @@ ax25_dev *ax25_addr_ax25dev(ax25_address *addr)
>  	ax25_dev *ax25_dev, *res =3D NULL;
> =20
>  	spin_lock_bh(&ax25_dev_lock);
> -	for (ax25_dev =3D ax25_dev_list; ax25_dev !=3D NULL; ax25_dev =3D ax25_=
dev->next)
> +	for (ax25_dev =3D ax25_dev_list; ax25_dev !=3D NULL; ax25_dev =3D ax25_=
dev->next) {
>  		if (ax25cmp(addr, (const ax25_address *)ax25_dev->dev->dev_addr) =3D=
=3D 0) {
>  			res =3D ax25_dev;
>  			ax25_dev_hold(ax25_dev);
> +			break;
>  		}
> +	}
>  	spin_unlock_bh(&ax25_dev_lock);
> =20
>  	return res;
> diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
> index b7c4d656a94b..ebef46c38e80 100644
> --- a/net/ax25/ax25_route.c
> +++ b/net/ax25/ax25_route.c
> @@ -344,7 +344,6 @@ const struct seq_operations ax25_rt_seqops =3D {
>   */
>  ax25_route *ax25_get_route(ax25_address *addr, struct net_device *dev)
>  {
> -	ax25_route *ax25_spe_rt =3D NULL;
>  	ax25_route *ax25_def_rt =3D NULL;
>  	ax25_route *ax25_rt;
> =20
> @@ -354,23 +353,25 @@ ax25_route *ax25_get_route(ax25_address *addr, stru=
ct net_device *dev)
>  	 */
>  	for (ax25_rt =3D ax25_route_list; ax25_rt !=3D NULL; ax25_rt =3D ax25_r=
t->next) {
>  		if (dev =3D=3D NULL) {
> -			if (ax25cmp(&ax25_rt->callsign, addr) =3D=3D 0 && ax25_rt->dev !=3D N=
ULL)
> -				ax25_spe_rt =3D ax25_rt;
> -			if (ax25cmp(&ax25_rt->callsign, &null_ax25_address) =3D=3D 0 && ax25_=
rt->dev !=3D NULL)
> +			if (ax25_rt->dev !=3D NULL && ax25cmp(&ax25_rt->callsign, addr) =3D=
=3D 0)
> +				return ax25_rt;
> +
> +			if (ax25_def_rt !=3D NULL &&
> +			    ax25_rt->dev !=3D NULL &&
> +			    ax25cmp(&ax25_rt->callsign, &null_ax25_address) =3D=3D 0)
>  				ax25_def_rt =3D ax25_rt;
>  		} else {
> -			if (ax25cmp(&ax25_rt->callsign, addr) =3D=3D 0 && ax25_rt->dev =3D=3D=
 dev)
> -				ax25_spe_rt =3D ax25_rt;
> -			if (ax25cmp(&ax25_rt->callsign, &null_ax25_address) =3D=3D 0 && ax25_=
rt->dev =3D=3D dev)
> +			if (ax25_rt->dev =3D=3D dev && ax25cmp(&ax25_rt->callsign, addr) =3D=
=3D 0)
> +				return ax25_rt;
> +
> +			if (ax25_def_rt !=3D NULL &&
> +			    ax25_rt->dev =3D=3D dev &&
> +			    ax25cmp(&ax25_rt->callsign, &null_ax25_address) =3D=3D 0)
>  				ax25_def_rt =3D ax25_rt;

If I read correctly, multiple routes can legitly match the null
callsign and the above chunk introduces a behavioral change: before the
kernel selected the last of such routes, now the first one.

What about dropping the new condition 'ax25_def_rt !=3D NULL' ?

If so, this patch could target the -net tree - with a suitable fixes
tag.

Thanks!

Paolo

