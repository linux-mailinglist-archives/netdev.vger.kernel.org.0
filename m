Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334856C467C
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 10:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjCVJc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 05:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjCVJcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 05:32:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B067B5DC8A
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 02:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679477482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aohx52gtHc9Wxq6HhhXRHJoVXIsR13K6Dp12lzqTmRU=;
        b=FnPQQjLVzekxXMpIXAp8CbDepJ0kRX1Oj533ZgN2S/ad3b3CpqHoXn8M0TiOyfxQjTwzVc
        Ir4IZs00SIzlJT14OgA/H0pix9DUgw94EqAd+bY8qBfLMEHC1V+Jip3XhiJZ9HD4Fxgp4c
        Eu4vRptJ1IZQdRLX2VP/UxWJG59zGaI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-CYV0KPmzNFS6-eNGY9Vnyg-1; Wed, 22 Mar 2023 05:31:20 -0400
X-MC-Unique: CYV0KPmzNFS6-eNGY9Vnyg-1
Received: by mail-qk1-f197.google.com with SMTP id 66-20020a370345000000b00746886b1593so3964784qkd.14
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 02:31:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679477479; x=1682069479;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aohx52gtHc9Wxq6HhhXRHJoVXIsR13K6Dp12lzqTmRU=;
        b=uivR98Sdqu42h0T6gbDnq4RipSHrJDyabf3tYpQefEg204EJRnAwFFDdC9FbLhg4+U
         44D+PlXsnPxaMnIck4swfKH0yKKJ8ae7hJfzL++Wlxot4ok1LTqDx8swEbPr6uV5DPFH
         8hGPpNM7Iy/N5LFAbCE9dwIx7f6fZieri9Ih/D7BA+HYBuol+6Zrc61RTwV2bMikQdk/
         XPcwci1Yylrn0eSty9uOGOUIcMe+J+UJJIn9Ppm5Jn94Vn21VNYmB5f2Ejjrbq4spSmV
         PEijd6CTtK1jpKIL32sEmUjuJicTzDcd6HEeIz7CfkJCmGdnNEFPww9210oSagttsUK2
         ZbeQ==
X-Gm-Message-State: AO0yUKWOf06BPVF53HGjROT9fBILv7g1IUzcgDvIPySk9282l3SksUsi
        fimimVZxT3FbvhJHOjCM8h0tZdkb2WEPs2SlnzUuzcfM8Ir7Uqy+8zqCjOqP5U5/TBBBzri/JTO
        X6D0d+YkOFRT294YG
X-Received: by 2002:ac8:4e56:0:b0:3b8:6c6e:4949 with SMTP id e22-20020ac84e56000000b003b86c6e4949mr7704639qtw.4.1679477479477;
        Wed, 22 Mar 2023 02:31:19 -0700 (PDT)
X-Google-Smtp-Source: AK7set8GI0JKVRL5NtDWIehKK8nmW/AF2yucaIea2h4VDDMjDAnxYNQTTOlZTd5leefYWwZBe/b7kg==
X-Received: by 2002:ac8:4e56:0:b0:3b8:6c6e:4949 with SMTP id e22-20020ac84e56000000b003b86c6e4949mr7704613qtw.4.1679477479226;
        Wed, 22 Mar 2023 02:31:19 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-168.dyn.eolo.it. [146.241.244.168])
        by smtp.gmail.com with ESMTPSA id w9-20020ac843c9000000b003d8f78b82besm2311012qtn.70.2023.03.22.02.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 02:31:18 -0700 (PDT)
Message-ID: <ed1b26c32307ecfc39da3eaba474645280809dec.camel@redhat.com>
Subject: Re: [PATCH v6 net-next 1/7] netlink: Add a macro to set policy
 message with format string
From:   Paolo Abeni <pabeni@redhat.com>
To:     Shay Agroskin <shayagr@amazon.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jie Wang <wangjie125@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Florian Westphal <fw@strlen.de>
Date:   Wed, 22 Mar 2023 10:31:13 +0100
In-Reply-To: <20230320132523.3203254-2-shayagr@amazon.com>
References: <20230320132523.3203254-1-shayagr@amazon.com>
         <20230320132523.3203254-2-shayagr@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-03-20 at 15:25 +0200, Shay Agroskin wrote:
> Similar to NL_SET_ERR_MSG_FMT, add a macro which sets netlink policy
> error message with a format string.
>=20
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
> ---
>  include/linux/netlink.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>=20
> diff --git a/include/linux/netlink.h b/include/linux/netlink.h
> index 3e8743252167..2ca76ec1fc33 100644
> --- a/include/linux/netlink.h
> +++ b/include/linux/netlink.h
> @@ -161,9 +161,22 @@ struct netlink_ext_ack {
>  	}							\
>  } while (0)
> =20
> +#define NL_SET_ERR_MSG_ATTR_POL_FMT(extack, attr, pol, fmt, args...) do =
{	\
> +	struct netlink_ext_ack *__extack =3D (extack);				\
> +										\
> +	if (__extack) {								\
> +		NL_SET_ERR_MSG_FMT(extack, fmt, ##args);			\

You should use '__extack' even above, to avoid multiple evaluation of
the 'extack' expression.

Side note: you dropped the acked-by/revied-by tags collected on
previous iterations, you could and should have retained them for the
unmodified patches.

Thanks,

Paolo

