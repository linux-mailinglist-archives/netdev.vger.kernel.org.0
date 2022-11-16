Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8852D62C3F6
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbiKPQV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiKPQVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:21:23 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFD94387A;
        Wed, 16 Nov 2022 08:21:22 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id q71so17114933pgq.8;
        Wed, 16 Nov 2022 08:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=c559sc2jOhM0vrBcTp9Mpp0NMui8sZVfjdQCJ/lgLP8=;
        b=ELi91KjiC5QJN0McvzHtVelOHgF8KVqnx+G22rwjbtuLT2bJRZrBYdmEE4CRnniwKW
         RFRDbYP51foLBaMP2lNMVm2gt33fmhkfNvFxBQ4m04jH4djWBwh1dir079gK182+AQSS
         QUWE5eTXarA6po+3aZeBIE/LJYeZCzvr54o16gS+r3ZkIGRP0prfgh7LAcwprL4RIHTO
         bYzU1q8q59RH0+HwisesW/rJQq8UPiskCWVV1J+3b4VC5fjy/d46i1PjM2blQpduOouw
         3HbOyKxWGlRoAIpeyf0LPiK5prXE/Cp64pqT7sWqry/xZGeIjK6Ujykxh9er5vqhFMaP
         iddQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c559sc2jOhM0vrBcTp9Mpp0NMui8sZVfjdQCJ/lgLP8=;
        b=MJZ/jJ6aCl92j8QIaN1MQmIvtZlKulNI4gIFlA11v0tENI+O+e+A2goYWE0p2HJQ/b
         V600pK3NYMzSTbWEe9wiDf3PjTrGH/RbvWzsVt75oaUwcc1c9nEApu4eADAr6UdZKyS2
         a7/Uv4ljYYgJdO/sa4dGHr6FdUT54O4Kpe4IFzdtGytPe3mYOexSOxkH4n4B3BLDvoP0
         6vy7nhN7RCryGcqfNxmvhCt/67xZZk7PBeVgtqD/JjfxKn2+ZS7ZWdoBxLewbEOFAncW
         YsPnKDMSQmNdwpCDKfZX3Df0vg84ZCes2JN1IdV8NVl2ix/zW/mq3NK7rTtKLCf9RLGa
         sJ8w==
X-Gm-Message-State: ANoB5pmU2juHSGOZU3CAKef71wM6QtvfM5hwjRWfVjTDIUWCpyJ6QswP
        PuTXyrnOM38ly0avPTTe1Cw=
X-Google-Smtp-Source: AA0mqf6Ze6pBOTTvGO4TdaAkZUDd5JW5CUaETCWrQYTounopPw69P87KMjSZiFiun7zfH2CzuifGyw==
X-Received: by 2002:a62:3382:0:b0:572:6da6:de57 with SMTP id z124-20020a623382000000b005726da6de57mr8778589pfz.30.1668615681399;
        Wed, 16 Nov 2022 08:21:21 -0800 (PST)
Received: from [192.168.0.128] ([98.97.119.47])
        by smtp.googlemail.com with ESMTPSA id c5-20020a634e05000000b0046f7e1ca434sm9914272pgb.0.2022.11.16.08.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 08:21:20 -0800 (PST)
Message-ID: <bc3077669c1f3f9bd2aca486dcbea9b508dbf318.camel@gmail.com>
Subject: Re: [PATCH net] e100: Fix possible use after free in
 e100_xmit_prepare
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Wang Hai <wanghai38@huawei.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, baijiaju1990@163.com,
        jeffrey.t.kirsher@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Date:   Wed, 16 Nov 2022 08:21:19 -0800
In-Reply-To: <20221115172407.72863-1-wanghai38@huawei.com>
References: <20221115172407.72863-1-wanghai38@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-11-16 at 01:24 +0800, Wang Hai wrote:
> In e100_xmit_prepare(), if we can't map the skb, then return -ENOMEM, so
> e100_xmit_frame() will return NETDEV_TX_BUSY and the upper layer will
> resend the skb. But the skb is already freed, which will cause UAF bug
> when the upper layer resends the skb.
>=20
> Remove the harmful free.
>=20
> Fixes: 5e5d49422dfb ("e100: Release skb when DMA mapping is failed in e10=
0_xmit_prepare")
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  drivers/net/ethernet/intel/e100.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/int=
el/e100.c
> index 560d1d442232..d3fdc290937f 100644
> --- a/drivers/net/ethernet/intel/e100.c
> +++ b/drivers/net/ethernet/intel/e100.c
> @@ -1741,11 +1741,8 @@ static int e100_xmit_prepare(struct nic *nic, stru=
ct cb *cb,
>  	dma_addr =3D dma_map_single(&nic->pdev->dev, skb->data, skb->len,
>  				  DMA_TO_DEVICE);
>  	/* If we can't map the skb, have the upper layer try later */
> -	if (dma_mapping_error(&nic->pdev->dev, dma_addr)) {
> -		dev_kfree_skb_any(skb);
> -		skb =3D NULL;
> +	if (dma_mapping_error(&nic->pdev->dev, dma_addr))
>  		return -ENOMEM;
> -	}
> =20
>  	/*
>  	 * Use the last 4 bytes of the SKB payload packet as the CRC, used for

I'm surprised the original patch that this essentially reverts was even
accepted.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
