Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E989B4E6E90
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 08:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354702AbiCYHOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 03:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238896AbiCYHOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 03:14:16 -0400
X-Greylist: delayed 74847 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 25 Mar 2022 00:12:42 PDT
Received: from vulcan.natalenko.name (vulcan.natalenko.name [104.207.131.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 381D9BD898;
        Fri, 25 Mar 2022 00:12:42 -0700 (PDT)
Received: from spock.localnet (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 0402BE4C661;
        Fri, 25 Mar 2022 08:12:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1648192359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gcXLBP3mIfbGljUpsP//FsQOHOTfI0szjq2ialy/sIU=;
        b=nTgcEEtgRJjs1kBrwhIgdlq/eHBdXP950twIufQRtgGI9t1yPmzXlHuARe5Mm4Ku1Wl+gj
        J1qtm2C0WtQDcQ1vPPoPlPSxgR6hQ7w2kxF8mGOtYKwbxIJ1skLC/zf5LPO3fyjV3xW742
        nilK7AS68nMA3cP9Tzef//M9aMfeDRo=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Maxime Bizon <mbizon@freebox.fr>,
        Toke =?ISO-8859-1?Q?H=F8iland=2DJ=F8rgensen?= <toke@toke.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        iommu <iommu@lists.linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break ath9k-based AP
Date:   Fri, 25 Mar 2022 08:12:37 +0100
Message-ID: <4699073.GXAFRqVoOG@natalenko.name>
In-Reply-To: <871qyr9t4e.fsf@toke.dk>
References: <1812355.tdWV9SEqCh@natalenko.name> <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com> <871qyr9t4e.fsf@toke.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On =C4=8Dtvrtek 24. b=C5=99ezna 2022 18:07:29 CET Toke H=C3=B8iland-J=C3=B8=
rgensen wrote:
> Right, but is that sync_for_device call really needed? AFAICT, that
> ath9k_hw_process_rxdesc_edma() invocation doesn't actually modify any of
> the data when it returns EINPROGRESS, so could we just skip it? Like
> the patch below? Or am I misunderstanding the semantics here?
>=20
> -Toke
>=20
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless=
/ath/ath9k/recv.c
> index 0c0624a3b40d..19244d4c0ada 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -647,12 +647,8 @@ static bool ath_edma_get_buffers(struct ath_softc *s=
c,
>                                 common->rx_bufsize, DMA_FROM_DEVICE);
> =20
>         ret =3D ath9k_hw_process_rxdesc_edma(ah, rs, skb->data);
> -       if (ret =3D=3D -EINPROGRESS) {
> -               /*let device gain the buffer again*/
> -               dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
> -                               common->rx_bufsize, DMA_FROM_DEVICE);
> +       if (ret =3D=3D -EINPROGRESS)
>                 return false;
> -       }
> =20
>         __skb_unlink(skb, &rx_edma->rx_fifo);
>         if (ret =3D=3D -EINVAL) {

With this patch and both ddbd89deb7d3+aa6f8dcbab47 in place the AP works fo=
r me.

Thanks.

=2D-=20
Oleksandr Natalenko (post-factum)


