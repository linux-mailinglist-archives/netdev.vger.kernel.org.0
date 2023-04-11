Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECDEC6DDC0D
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 15:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjDKN1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 09:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDKN1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 09:27:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DB149D8
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 06:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681219613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=89onHQRburmEGbJaADjmbx60CHjVAnEuuQVlVS5Ox9E=;
        b=b3imKKIzqCKULvTWeHKCjNOu3pTvhUDrrtndp5VjSdaqdlDnQ58MAjMwgusQIc4B4Xjo6t
        lRX3x9NQSQA6JkNASyjz+F52qPCyFD5cz/AJBMBuMTWh7c8GNUCmDC2gQTVDz1Ie4lrucl
        Jv6PK18fFIAVjYwZE71cQAyLQRHm6Ys=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-Z3MGat8XM5mdk4hWPB5X1A-1; Tue, 11 Apr 2023 09:26:51 -0400
X-MC-Unique: Z3MGat8XM5mdk4hWPB5X1A-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-5df44ccedcaso12962716d6.1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 06:26:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681219611; x=1683811611;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=89onHQRburmEGbJaADjmbx60CHjVAnEuuQVlVS5Ox9E=;
        b=3owwtveV7exN9MQW7jR9JcnV6CTMSzB2pfin8vhMTyqA3jvaq74PInJFGBxnHhN409
         xzIFsQIcsIQRJBz9d+pAHylgSZ7gz7M3tiEtoDicWw9qdf62r0OqkJZhqaTqK7T8zVQU
         +9phPN1WADlQs+Qn8a4nzhnt3snc0owkZ7Az5EhpX85GnenLBNUCbgECK/oF3chjO7uv
         YwKcz6b78OsJ5bkn4VbOktBiPyuigrvJr1xSYx7v7IVPKY9GhdohXfjY/Is6W+4sePwF
         FCIvVqZaoCefrOR6ItftRFA9KPRsD2W+UX6rlPEpOSGwDb0S+7oM7NRZ0JWqlZWsIbnG
         236g==
X-Gm-Message-State: AAQBX9dXzlaESKLdwn3yXkrFrIf1+mmoWm3btM6pugKvZRXc96KVWNUv
        WCbhu5B7+b9No1X5SyqYQa9/WmqihidfIy/luGBo5Po2rABOGhOXGHyFyI54FCPzEOxgBU1FKH5
        eBX5acXDcOoEbc5r7
X-Received: by 2002:a05:6214:4110:b0:5ad:cd4b:3765 with SMTP id kc16-20020a056214411000b005adcd4b3765mr18339604qvb.1.1681219611312;
        Tue, 11 Apr 2023 06:26:51 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZM7vGCOFRWXZoPtgLmuUlHu/2VsPHoLIFm8fZwkbyb81wa0kBwqypmSxCR4GZI/MdiTxHkKQ==
X-Received: by 2002:a05:6214:4110:b0:5ad:cd4b:3765 with SMTP id kc16-20020a056214411000b005adcd4b3765mr18339583qvb.1.1681219611030;
        Tue, 11 Apr 2023 06:26:51 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-239-96.dyn.eolo.it. [146.241.239.96])
        by smtp.gmail.com with ESMTPSA id fb12-20020ad44f0c000000b005dd8b9345dcsm819793qvb.116.2023.04.11.06.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 06:26:50 -0700 (PDT)
Message-ID: <5ca60e3606aa710ef3b98b759572fdd7bfd20c74.camel@redhat.com>
Subject: Re: [PATCH net-next] net: davicom: Make davicom drivers not depends
 on DM9000
From:   Paolo Abeni <pabeni@redhat.com>
To:     Wei Yongjun <weiyongjun@huaweicloud.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Joseph CHAMG <josright123@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Shay Agroskin <shayagr@amazon.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Nathan Huckleberry <nhuck@google.com>,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>,
        Wells Lu <wellslutw@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org
Date:   Tue, 11 Apr 2023 15:26:46 +0200
In-Reply-To: <20230407094930.2633137-1-weiyongjun@huaweicloud.com>
References: <20230407094930.2633137-1-weiyongjun@huaweicloud.com>
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

On Fri, 2023-04-07 at 09:49 +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
>=20
> All davicom drivers build need CONFIG_DM9000 is set, but this dependence
> is not correctly since dm9051 can be build as module without dm9000, swit=
ch
> to using CONFIG_NET_VENDOR_DAVICOM instead.
>=20
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/net/ethernet/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefil=
e
> index 0d872d4efcd1..ee640885964e 100644
> --- a/drivers/net/ethernet/Makefile
> +++ b/drivers/net/ethernet/Makefile
> @@ -32,7 +32,7 @@ obj-$(CONFIG_NET_VENDOR_CIRRUS) +=3D cirrus/
>  obj-$(CONFIG_NET_VENDOR_CISCO) +=3D cisco/
>  obj-$(CONFIG_NET_VENDOR_CORTINA) +=3D cortina/
>  obj-$(CONFIG_CX_ECAT) +=3D ec_bhf.o
> -obj-$(CONFIG_DM9000) +=3D davicom/
> +obj-$(CONFIG_NET_VENDOR_DAVICOM) +=3D davicom/
>  obj-$(CONFIG_DNET) +=3D dnet.o
>  obj-$(CONFIG_NET_VENDOR_DEC) +=3D dec/
>  obj-$(CONFIG_NET_VENDOR_DLINK) +=3D dlink/

Can you repost this for -net, including a suitable Fixes tag, as
suggested by Simon?

Thanks!

Paolo

