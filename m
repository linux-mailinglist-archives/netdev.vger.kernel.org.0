Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C8568D59B
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 12:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbjBGLhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 06:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjBGLhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 06:37:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D0E1B1
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 03:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675769778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f10t9dK7ifwgpP0YM2Y3xjBmnDWSujGozfYVnVK63GU=;
        b=IJ1MG1V3WmTt/yTjNYuunBf5ahxfIEXUGhfSbDN1fX6MYsi2d9GddQIOhQHPMaYK4CcEp2
        3eFoiwg9xwnQ67OtV0RA7cMg8ZfVtuqgszxAmsBLOXuaJpIATAo73EDcFBkKDTdYfv37gv
        g9i8bD2sSDJ35HBQKtebRmhSvA0YRiw=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-607-81g6MhwuMFCGU2tFyeFZlA-1; Tue, 07 Feb 2023 06:36:17 -0500
X-MC-Unique: 81g6MhwuMFCGU2tFyeFZlA-1
Received: by mail-qt1-f199.google.com with SMTP id i5-20020ac813c5000000b003b86b748aadso8395174qtj.14
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 03:36:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f10t9dK7ifwgpP0YM2Y3xjBmnDWSujGozfYVnVK63GU=;
        b=xsG6c5+XFDUbRMBGpMYGJ2Skxdg2sgSVAoaNIYY5fcoSBQFXdyl3oexdwcPpXa4nut
         t38DvofyYa0NjL5XtgGKbD2WHUh7AUvr5P+XaxrUuORxm58YgbDc99ddGoqz2clIH4jp
         3N+AORIKyscWpHAx55uWh1bqFm0DGcH+/79kF+cxchdiByreaIR/ggcUeY10T/fwRuGb
         KMxJESY24QDv/yF/zt1wDG2XEX/bGQYY9sUDQ8x116sawYKQS70WB2Ur6SsMTttr8Vh4
         aynJnKtyw+JNHSA4ip0Dhr0bO8YvuEy7Nv4uKYchofEf1tB3fEU62HNc7CgwnaK3HqJo
         yzYg==
X-Gm-Message-State: AO0yUKX1MD8jnmG52XxiDEZS4JfCaS0DXGsIE8Y5tB0PlkNAKdO5/Dj8
        0Q5tAUKQyVEniFmyUDIHdfbg6ghRQiRNOFAHdIwpYiu6xhBYqlIshpYVnvyGQ8IkgJz60SMndgX
        vcx78ZtDqkR1xRd8UYBtT0Q==
X-Received: by 2002:a05:622a:ce:b0:39c:da22:47b8 with SMTP id p14-20020a05622a00ce00b0039cda2247b8mr5905569qtw.1.1675769776457;
        Tue, 07 Feb 2023 03:36:16 -0800 (PST)
X-Google-Smtp-Source: AK7set/JWAeulvB7eXRw0UD+lz66hmrJqSLEyBKwkHda5nG4yDCSyYcjGhaW8JWftV6yQo9TBlp3EA==
X-Received: by 2002:a05:622a:ce:b0:39c:da22:47b8 with SMTP id p14-20020a05622a00ce00b0039cda2247b8mr5905538qtw.1.1675769776219;
        Tue, 07 Feb 2023 03:36:16 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id l12-20020a05622a050c00b003b960aad697sm9515985qtx.9.2023.02.07.03.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 03:36:15 -0800 (PST)
Message-ID: <135b671b1b76978fb147d5fee1e1b922e2c61f26.camel@redhat.com>
Subject: Re: [PATCH net v2 1/2] net: ll_temac: Fix DMA resources leak
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jonas Suhr Christensen <jsc@umbraculum.org>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        huangjunxian <huangjunxian6@hisilicon.com>,
        Wang Qing <wangqing@vivo.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Esben Haabendal <esben@geanix.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 07 Feb 2023 12:36:11 +0100
In-Reply-To: <5314e0ba3a728787299ca46a60b0a2da5e8ab23a.camel@redhat.com>
References: <20230205201130.11303-1-jsc@umbraculum.org>
         <20230205201130.11303-2-jsc@umbraculum.org>
         <5314e0ba3a728787299ca46a60b0a2da5e8ab23a.camel@redhat.com>
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

On Tue, 2023-02-07 at 12:27 +0100, Paolo Abeni wrote:
> Hi,
>=20
> On Sun, 2023-02-05 at 21:11 +0100, Jonas Suhr Christensen wrote:
> > Add missing conversion of address when unmapping dma region causing
> > unmapping to silently fail. At some point resulting in buffer
> > overrun eg. when releasing device.
> >=20
> > Fixes: fdd7454ecb29 ("net: ll_temac: Fix support for little-endian plat=
forms")
> >=20
> > Signed-off-by: Jonas Suhr Christensen <jsc@umbraculum.org>
>=20
> I'm sorry for nit-picking, but you must avoid empty lines in the tag
> area. Please post a v2 avoiding the empty line between the Fixes and
> sob tags (both here and in the next patch).
>=20
> You can retain (include in the tag area) the already collected
> reviewed-by/acked-by tags.

I'm sorry,  I'm low on coffee. I forgot to mention a more relevant
thing:

> @@ -307,9 +308,14 @@  static void temac_dma_bd_release(struct net_device =
*ndev)
> 	for (i =3D 0; i < lp->rx_bd_num; i++) {
> 		if (!lp->rx_skb[i])
> 			break;
> -		dma_unmap_single(ndev->dev.parent, lp->rx_bd_v[i].phys,
> +
> +		bd =3D &lp->rx_bd_v[i];
> +		dma_unmap_single(ndev->dev.parent, be32_to_cpu(bd->phys),

The above be32_to_cpu() introduces a new build warning. as phys type is
u32. It looks like the existing code generates a lot of similar warns.

You can either try change to phys type to __be32 (likely not suitable
for -net and possibly can introduce even more warnings elsewhere) or
explicitly cast the argument.

Thanks,

Paolo

