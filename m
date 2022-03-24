Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203B34E61B1
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 11:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349490AbiCXK0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 06:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349483AbiCXK0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 06:26:53 -0400
Received: from vulcan.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B765C483A3;
        Thu, 24 Mar 2022 03:25:21 -0700 (PDT)
Received: from spock.localnet (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 46336E4A5DD;
        Thu, 24 Mar 2022 11:25:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1648117508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0kZDRe244Ho+56p1lKIcy0+GT4xOH+L25rK8rNrmj5M=;
        b=xTLCXRCNMwAKN6C6abDkvpf8K2mg/Sm4GaWSCsryLwp5Fq4HqX8lUoEohqBSWrzOqMIaix
        kRFT7EmZ97tKbHZfyY4//hxr65jVGb/7gVgp7+S6tP4fJ8p1HUuP7h1jt5+OqhjIlCJgG2
        yc1FDX9OJ6CAbtcVZklteEyyfX7d5Cw=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Toke =?ISO-8859-1?Q?H=F8iland=2DJ=F8rgensen?= <toke@toke.dk>,
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
Date:   Thu, 24 Mar 2022 11:25:06 +0100
Message-ID: <4386660.LvFx2qVVIh@natalenko.name>
In-Reply-To: <20220324055732.GB12078@lst.de>
References: <1812355.tdWV9SEqCh@natalenko.name> <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com> <20220324055732.GB12078@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On =C4=8Dtvrtek 24. b=C5=99ezna 2022 6:57:32 CET Christoph Hellwig wrote:
> On Wed, Mar 23, 2022 at 08:54:08PM +0000, Robin Murphy wrote:
> > I'll admit I still never quite grasped the reason for also adding the=20
> > override to swiotlb_sync_single_for_device() in aa6f8dcbab47, but I thi=
nk=20
> > by that point we were increasingly tired and confused and starting to=20
> > second-guess ourselves (well, I was, at least). I don't think it's wron=
g=20
> > per se, but as I said I do think it can bite anyone who's been doing=20
> > dma_sync_*() wrong but getting away with it until now. If ddbd89deb7d3=
=20
> > alone turns out to work OK then I'd be inclined to try a partial revert=
 of=20
> > just that one hunk.
>=20
> Agreed.  Let's try that first.
>=20
> Oleksandr, can you try the patch below:
>=20
>=20
> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
> index 6db1c475ec827..6c350555e5a1c 100644
> --- a/kernel/dma/swiotlb.c
> +++ b/kernel/dma/swiotlb.c
> @@ -701,13 +701,10 @@ void swiotlb_tbl_unmap_single(struct device *dev, p=
hys_addr_t tlb_addr,
>  void swiotlb_sync_single_for_device(struct device *dev, phys_addr_t tlb_=
addr,
>  		size_t size, enum dma_data_direction dir)
>  {
> -	/*
> -	 * Unconditional bounce is necessary to avoid corruption on
> -	 * sync_*_for_cpu or dma_ummap_* when the device didn't overwrite
> -	 * the whole lengt of the bounce buffer.
> -	 */
> -	swiotlb_bounce(dev, tlb_addr, size, DMA_TO_DEVICE);
> -	BUG_ON(!valid_dma_direction(dir));
> +	if (dir =3D=3D DMA_TO_DEVICE || dir =3D=3D DMA_BIDIRECTIONAL)
> +		swiotlb_bounce(dev, tlb_addr, size, DMA_TO_DEVICE);
> +	else
> +		BUG_ON(dir !=3D DMA_FROM_DEVICE);
>  }
> =20
>  void swiotlb_sync_single_for_cpu(struct device *dev, phys_addr_t tlb_add=
r,
>=20

With this patch the AP works for me.

Thanks.

=2D-=20
Oleksandr Natalenko (post-factum)


