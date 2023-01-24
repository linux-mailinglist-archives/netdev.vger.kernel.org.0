Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E726796D7
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 12:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbjAXLmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 06:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbjAXLmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 06:42:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B906166F4
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 03:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674560500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8xbiDTH0yLUcaN5U7iMZHZODRoFZHG894uKBBfOvvgo=;
        b=iPJIKGsEp+rI7FJOvUN5EfknPu9IdrLguzoYCNfSprZbcSq0SZrqWHwilOTLZW9jRUh+Gg
        ZdTLSt3Pkpws/cJN7DvKrBr+PsEZqTYHgKe3jjnU705Ec5Rbs2h9b82EoTgl9Xh72cIKCD
        vWRYp7TcRTrHb2F3DpbXU4IzoEhI1uA=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-653-nlP6pgmmOxuoGTAHCXGaZA-1; Tue, 24 Jan 2023 06:41:39 -0500
X-MC-Unique: nlP6pgmmOxuoGTAHCXGaZA-1
Received: by mail-qk1-f198.google.com with SMTP id v7-20020a05620a0f0700b006faffce43b2so10719929qkl.9
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 03:41:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8xbiDTH0yLUcaN5U7iMZHZODRoFZHG894uKBBfOvvgo=;
        b=1ymrGAMCnlj2YE59n8Gfiqjpn3MdTDpbdpaCj61P4n0kst6aIYrb+9QrchC8Jm5fiT
         luaaQoFGcWnzwfFiKZrNmY/2dABR1s8ABUA6zyfn2QIQNT8LrnDY3m8hmXO7Agzwypj6
         WXq44RJe8vJE1wUYLpvqMpsdZa/AV2EjPDTi5DeZWEpJVOFpbCQyosZEBqc0Ut+dh9+E
         zX4FOSJ8+aabYva504WAYy69LgPSC9h+O9ABfSiypDu/fkoplD9WGqiZOJMAFMUAUL8T
         H67f73Ic7/3WnTkaC8gXDPs8LyX2/a4WgGQl1VzgiJENoPRZAQMBq7HRyHYabuYEIt9x
         btGg==
X-Gm-Message-State: AFqh2koUgB/q/Hj+7ahjrsLqvd7EgtwfrqQMylR0UrjFrSm71YSXs05e
        RlhnaLVqa3wOvQ9x6qSwvtcB1BnL48twyYS59SCG2HHqmiMw2saIHe/nnrb+427jOXiO7unEhTP
        WvOH95eMDDRyiA/9V
X-Received: by 2002:a05:6214:3492:b0:534:2b55:6320 with SMTP id mr18-20020a056214349200b005342b556320mr41451889qvb.9.1674560498645;
        Tue, 24 Jan 2023 03:41:38 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsvn59If1obOFKsw8DvUi7XD9qvb3zm6271ZcBda7d3gvdCM++4RdTwOICWwrZqcLf4gV1mSA==
X-Received: by 2002:a05:6214:3492:b0:534:2b55:6320 with SMTP id mr18-20020a056214349200b005342b556320mr41451870qvb.9.1674560498423;
        Tue, 24 Jan 2023 03:41:38 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id x5-20020ae9f805000000b0070d10ecb4besm1294701qkh.1.2023.01.24.03.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 03:41:37 -0800 (PST)
Message-ID: <fe14f2c636718b5237cd31531260e4145bbd8a75.camel@redhat.com>
Subject: Re: [PATCH net-next 2/2] ethtool: netlink: convert commands to
 common SET
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        piergiorgio.beruto@gmail.com, gal@nvidia.com, tariqt@nvidia.com,
        dnlplm@gmail.com, sean.anderson@seco.com, linux@rempel-privat.de,
        lkp@intel.com, bagasdotme@gmail.com, wangjie125@huawei.com,
        huangguangbin2@huawei.com
Date:   Tue, 24 Jan 2023 12:41:34 +0100
In-Reply-To: <20230121054430.642280-2-kuba@kernel.org>
References: <20230121054430.642280-1-kuba@kernel.org>
         <20230121054430.642280-2-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 2023-01-20 at 21:44 -0800, Jakub Kicinski wrote:
> @@ -241,49 +229,41 @@ const struct nla_policy ethnl_coalesce_set_policy[]=
 =3D {
>  	[ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS] =3D { .type =3D NLA_U32 },
>  };
> =20
> -int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
> +static int
> +ethnl_set_coalesce_validate(struct ethnl_req_info *req_info,
> +			    struct genl_info *info)
>  {
> -	struct kernel_ethtool_coalesce kernel_coalesce =3D {};
> -	struct ethtool_coalesce coalesce =3D {};
> -	struct ethnl_req_info req_info =3D {};
> +	const struct ethtool_ops *ops =3D req_info->dev->ethtool_ops;
>  	struct nlattr **tb =3D info->attrs;
> -	const struct ethtool_ops *ops;
> -	struct net_device *dev;
>  	u32 supported_params;
> -	bool mod =3D false;
> -	int ret;
>  	u16 a;
> =20
> -	ret =3D ethnl_parse_header_dev_get(&req_info,
> -					 tb[ETHTOOL_A_COALESCE_HEADER],
> -					 genl_info_net(info), info->extack,
> -					 true);
> -	if (ret < 0)
> -		return ret;
> -	dev =3D req_info.dev;
> -	ops =3D dev->ethtool_ops;
> -	ret =3D -EOPNOTSUPP;
> -	if (!ops->get_coalesce || !ops->set_coalesce)
> -		goto out_dev;
> -
>  	/* make sure that only supported parameters are present */
>  	supported_params =3D ops->supported_coalesce_params;
>  	for (a =3D ETHTOOL_A_COALESCE_RX_USECS; a < __ETHTOOL_A_COALESCE_CNT; a=
++)
>  		if (tb[a] && !(supported_params & attr_to_mask(a))) {
> -			ret =3D -EINVAL;
>  			NL_SET_ERR_MSG_ATTR(info->extack, tb[a],
>  					    "cannot modify an unsupported parameter");
> -			goto out_dev;
> +			return -EINVAL;
>  		}
> =20
> -	rtnl_lock();
> -	ret =3D ethnl_ops_begin(dev);
> -	if (ret < 0)
> -		goto out_rtnl;
> -	ret =3D ops->get_coalesce(dev, &coalesce, &kernel_coalesce,
> -				info->extack);
> +	return ops->get_coalesce && ops->set_coalesce ? 1 : -EOPNOTSUPP;

The above changes the error code in case a coalesce op is missing (and
likely supported_coalesce_params is zero) from EOPNOTSUPP to EINVAL.

I guess it's not a big deal but perhaps we can preserve the same error
code as prior to this patch?=C2=A0

Not a big deal, I see other commands check the oops last.

Thanks,

Paolo


