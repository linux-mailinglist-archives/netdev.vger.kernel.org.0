Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22539696190
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbjBNK7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBNK7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:59:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2FA2D43
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 02:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676372304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h7yLkTYkDWv9LnZsEkY1Wi6Wwalkhmc1wzFJOYiijwM=;
        b=bw77tvMrb3fzZLKAl97hYpzz0Pcz6V+LFzCmuh76gNtmyW4gqlgRqqTqD+ECtrvz8zBUW7
        4vruG9LSYdSzqsVC9F5GOXSHiQpQHJjLoY0wTx73RO9LHqb3SThbypzdCivyQ3eSDDStjI
        UH13WZpLgtKzMMfTQ0n/dhZUWlLa7/0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-134-rnxDwFjaOCa-vD7SuVglOA-1; Tue, 14 Feb 2023 05:58:21 -0500
X-MC-Unique: rnxDwFjaOCa-vD7SuVglOA-1
Received: by mail-ej1-f69.google.com with SMTP id wu9-20020a170906eec900b0088e1bbefaeeso9804747ejb.12
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 02:58:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676372300;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h7yLkTYkDWv9LnZsEkY1Wi6Wwalkhmc1wzFJOYiijwM=;
        b=liEgoI3SUYxNwepM+iJsbX+fRMsEeipxK2GMKNYNnOEGFe3PoLwIcAVfKWbsYTVcqQ
         /Uy3GxnwtoW/JecsYElW+5WScQESCVQG+PJ1WI6gto/+ZAZHUc6+WSO23W/XtpYvDTHA
         UyFT9Rtl1ul+X3EPRhcv3E4cypXolLfELbrdqD3k5fbu2Busr/H7lUzvCSt0iJCUAIGi
         ml69CbNjRAEQCbvGmgdUBWDsWgEA+ytsPx+1mpk1C7q+L3YObrIjig/XXTEUVHfSKcN0
         tQqGcbDvFm3WE0e6NGK92ApxY/DmdjR9SS2hCOV3D3XNUkpLT+IplRiil45Jts/2O3lV
         gY1Q==
X-Gm-Message-State: AO0yUKWta9us6tDG1cfEfdNZbeWeUuIkwBr3LlMY3sPuCEJCC1lFMlR1
        7bkmZROj6wYFq8fAH+hjut2MBQbRDjAlUUovNDzDwxnQfwhrxDCuHej4dGo20uV5DGFyZUMWfYQ
        dX2qlj1wPSsccW1MQ
X-Received: by 2002:a05:6402:520b:b0:4ac:373e:9d04 with SMTP id s11-20020a056402520b00b004ac373e9d04mr2732255edd.2.1676372300057;
        Tue, 14 Feb 2023 02:58:20 -0800 (PST)
X-Google-Smtp-Source: AK7set/DowfUjBMHxlFFxbPtLH/FSskf5qVkfhKSNcU0oY7giAwkHBcarRwMoVaH7vppKMVqAQD2Mg==
X-Received: by 2002:a05:6402:520b:b0:4ac:373e:9d04 with SMTP id s11-20020a056402520b00b004ac373e9d04mr2732240edd.2.1676372299818;
        Tue, 14 Feb 2023 02:58:19 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id m17-20020a50c191000000b004a22ed9030csm7875891edf.56.2023.02.14.02.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 02:58:19 -0800 (PST)
Message-ID: <d9cca450f83f03e257e3bacc6946356c691d2412.camel@redhat.com>
Subject: Re: [PATCH net v5 2/2] net/ps3_gelic_net: Use dma_mapping_error
From:   Paolo Abeni <pabeni@redhat.com>
To:     Geoff Levand <geoff@infradead.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander H Duyck <alexander.duyck@gmail.com>
Date:   Tue, 14 Feb 2023 11:58:17 +0100
In-Reply-To: <ea17b44b48e4dad6c97e3f1e61266fcf9f0ad2d5.1676221818.git.geoff@infradead.org>
References: <cover.1676221818.git.geoff@infradead.org>
         <ea17b44b48e4dad6c97e3f1e61266fcf9f0ad2d5.1676221818.git.geoff@infradead.org>
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

+Alex
On Sun, 2023-02-12 at 18:00 +0000, Geoff Levand wrote:
> The current Gelic Etherenet driver was checking the return value of its
> dma_map_single call, and not using the dma_mapping_error() routine.
>=20
> Fixes runtime problems like these:
>=20
>   DMA-API: ps3_gelic_driver sb_05: device driver failed to check map erro=
r
>   WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:1027 .check_unmap+0x888/0x=
8dc
>=20
> Fixes: 02c1889166b4 (ps3: gigabit ethernet driver for PS3, take3)

Please use the correct format for the above tag.

> Signed-off-by: Geoff Levand <geoff@infradead.org>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 41 ++++++++++----------
>  1 file changed, 20 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/e=
thernet/toshiba/ps3_gelic_net.c
> index 2bb68e60d0d5..0e52bb99e344 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -309,22 +309,30 @@ static int gelic_card_init_chain(struct gelic_card =
*card,
>  				 struct gelic_descr_chain *chain,
>  				 struct gelic_descr *start_descr, int no)
>  {
> -	int i;
> +	struct device *dev =3D ctodev(card);
>  	struct gelic_descr *descr;
> +	int i;
> =20
> -	descr =3D start_descr;
> -	memset(descr, 0, sizeof(*descr) * no);
> +	memset(start_descr, 0, no * sizeof(*start_descr));
> =20
>  	/* set up the hardware pointers in each descriptor */
> -	for (i =3D 0; i < no; i++, descr++) {
> +	for (i =3D 0, descr =3D start_descr; i < no; i++, descr++) {
>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
>  		descr->bus_addr =3D
>  			dma_map_single(ctodev(card), descr,
>  				       GELIC_DESCR_SIZE,
>  				       DMA_BIDIRECTIONAL);
> =20
> -		if (!descr->bus_addr)
> -			goto iommu_error;
> +		if (unlikely(dma_mapping_error(dev, descr->bus_addr))) {

Not a big issue, but I think the existing goto is preferable to the
following indentation

> +			dev_err(dev, "%s:%d: dma_mapping_error\n", __func__,
> +				__LINE__);
> +
> +			for (i--, descr--; i >=3D 0; i--, descr--) {

Again not a big deal, but I think the construct suggested by Alex in
the previous patch is more clear.


> +				dma_unmap_single(ctodev(card), descr->bus_addr,
> +					GELIC_DESCR_SIZE, DMA_BIDIRECTIONAL);
> +			}
> +			return -ENOMEM;
> +		}
> =20
>  		descr->next =3D descr + 1;
>  		descr->prev =3D descr - 1;
> @@ -346,14 +354,6 @@ static int gelic_card_init_chain(struct gelic_card *=
card,
>  	(descr - 1)->next_descr_addr =3D 0;
> =20
>  	return 0;
> -
> -iommu_error:
> -	for (i--, descr--; 0 <=3D i; i--, descr--)
> -		if (descr->bus_addr)
> -			dma_unmap_single(ctodev(card), descr->bus_addr,
> -					 GELIC_DESCR_SIZE,
> -					 DMA_BIDIRECTIONAL);
> -	return -ENOMEM;
>  }
> =20
>  /**
> @@ -408,13 +408,12 @@ static int gelic_descr_prepare_rx(struct gelic_card=
 *card,
>  	descr->buf_addr =3D dma_map_single(dev, descr->skb->data, descr->buf_si=
ze,
>  		DMA_FROM_DEVICE);
> =20
> -	if (!descr->buf_addr) {
> +	if (unlikely(dma_mapping_error(dev, descr->buf_addr))) {
> +		dev_err(dev, "%s:%d: dma_mapping_error\n", __func__, __LINE__);
>  		dev_kfree_skb_any(descr->skb);
>  		descr->buf_addr =3D 0;
>  		descr->buf_size =3D 0;
>  		descr->skb =3D NULL;
> -		dev_info(dev,
> -			 "%s:Could not iommu-map rx buffer\n", __func__);

You touched the above line in the previous patch. Since it does lot
look functional-related to the fix here you can as well drop the
message in the previous patch.


Cheers,

Paolo

