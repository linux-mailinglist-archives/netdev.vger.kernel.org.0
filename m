Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E23690EDA
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 18:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjBIRHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 12:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjBIRHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 12:07:47 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1775757772;
        Thu,  9 Feb 2023 09:07:45 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id e10-20020a17090a630a00b0022bedd66e6dso6944711pjj.1;
        Thu, 09 Feb 2023 09:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xUosuIF6sT5guNvUVmM1J2U0v0EW8fMgv/3In3ljd+Q=;
        b=UQnllC1ZZ4jQ17yePRdiNfhz3zNiiVIDcQMgpV9o6hCkmYQZ7hMu4BMI/bRlw2hJBG
         naBcn8KX0IP2FEdzrGDktnanCLjjseYna0D5yipRJ8eVLjUR+BSbtHX/PE900AP74QSB
         UIMle0AZ/WH4FRjynkvks0qEAl2yyl+ILBP7M4/AUDx6ZS4WQQi5st3iIGWVN0tFA6OG
         +D3IP3sIiunuLeO3dktp18VGclAh0ORX4BmBA7V5IZuAJvU7f4ZWkQGhx+NIRHs+PDVW
         1SFInSe9TGL49be7SV8T1H6NOnWzABljM8CNdp/KoS24WB5q99ES7if2R/OlOiW0Y+3f
         p93g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xUosuIF6sT5guNvUVmM1J2U0v0EW8fMgv/3In3ljd+Q=;
        b=DPaCM3Kqj59TNMxeXnlYDYMQITm79oHyM3/I6jk980dsi4dz2smRTkym8HqX5lJnP/
         Jlnz/Gu3As0hU12VLV38vb2zbEczMrZI/9aLJVTE1oShSTaJuwJaYO9sQ0g+9XSOZHJ9
         BYg6w2ohEP9nLaQC12Db3GOJY3+sydzw9RwyFbCfTtixEnXdG7yFRNORXNZCSMplPQq1
         9i2/SiHFEF5thzsNMrohPcjNRF/GeX+8/Weg8woz2k/N5+u80Nu1nRQL9Mq15FWhg7yX
         DMxCxmyHi6pY/l4/dBewIQhc2+3/va2pjMD575YQDQl+r7jldtvTEYlGZ0iHxMomIrzT
         b2rQ==
X-Gm-Message-State: AO0yUKWxV7egHxjwtrMBe498lEAxE0EFXYsmTmzb+f5X0Im5LLwytYK1
        CcIYQ3XaCT/LMEAjRlOfqHc=
X-Google-Smtp-Source: AK7set/hs6ehC54fBLh5SB3HwfgV3uku3FUfIyro6MSNNzqA8SU2MLhqOTbKnngRHVpx/vntKyuRqg==
X-Received: by 2002:a17:90b:4a4e:b0:230:8f39:d92e with SMTP id lb14-20020a17090b4a4e00b002308f39d92emr14346783pjb.20.1675962464488;
        Thu, 09 Feb 2023 09:07:44 -0800 (PST)
Received: from [192.168.0.128] ([98.97.119.54])
        by smtp.googlemail.com with ESMTPSA id i1-20020a17090acf8100b0023347886e80sm565202pju.16.2023.02.09.09.07.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 09:07:43 -0800 (PST)
Message-ID: <c3fc2a72a567e26613824001324bcac6fc8c3640.camel@gmail.com>
Subject: Re: [PATCH net] ice: xsk: Fix cleaning of XDP_TX frames
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Larysa Zaremba <larysa.zaremba@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Date:   Thu, 09 Feb 2023 09:07:42 -0800
In-Reply-To: <20230209160130.1779890-1-larysa.zaremba@intel.com>
References: <20230209160130.1779890-1-larysa.zaremba@intel.com>
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

On Thu, 2023-02-09 at 17:01 +0100, Larysa Zaremba wrote:
> Incrementation of xsk_frames inside the for-loop produces
> infinite loop, if we have both normal AF_XDP-TX and XDP_TXed
> buffers to complete.
>=20
> Split xsk_frames into 2 variables (xsk_frames and completed_frames)
> to eliminate this bug.
>=20
> Fixes: 29322791bc8b ("ice: xsk: change batched Tx descriptor cleaning")
> Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> ---
> To Tony: this is urgent and should go directly via net. It's tested and a=
cked.
> ---
>  drivers/net/ethernet/intel/ice/ice_xsk.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ether=
net/intel/ice/ice_xsk.c
> index 7105de6fb344..374b7f10b549 100644
> --- a/drivers/net/ethernet/intel/ice/ice_xsk.c
> +++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
> @@ -800,6 +800,7 @@ static void ice_clean_xdp_irq_zc(struct ice_tx_ring *=
xdp_ring)
>  	struct ice_tx_desc *tx_desc;
>  	u16 cnt =3D xdp_ring->count;
>  	struct ice_tx_buf *tx_buf;
> +	u16 completed_frames =3D 0;
>  	u16 xsk_frames =3D 0;
>  	u16 last_rs;
>  	int i;
> @@ -809,19 +810,21 @@ static void ice_clean_xdp_irq_zc(struct ice_tx_ring=
 *xdp_ring)
>  	if ((tx_desc->cmd_type_offset_bsz &
>  	    cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE))) {
>  		if (last_rs >=3D ntc)
> -			xsk_frames =3D last_rs - ntc + 1;
> +			completed_frames =3D last_rs - ntc + 1;
>  		else
> -			xsk_frames =3D last_rs + cnt - ntc + 1;
> +			completed_frames =3D last_rs + cnt - ntc + 1;
>  	}
> =20
> -	if (!xsk_frames)
> +	if (!completed_frames)
>  		return;
> =20
> -	if (likely(!xdp_ring->xdp_tx_active))
> +	if (likely(!xdp_ring->xdp_tx_active)) {
> +		xsk_frames =3D completed_frames;
>  		goto skip;
> +	}
> =20
>  	ntc =3D xdp_ring->next_to_clean;
> -	for (i =3D 0; i < xsk_frames; i++) {
> +	for (i =3D 0; i < completed_frames; i++) {
>  		tx_buf =3D &xdp_ring->tx_buf[ntc];
> =20
>  		if (tx_buf->raw_buf) {
> @@ -837,7 +840,7 @@ static void ice_clean_xdp_irq_zc(struct ice_tx_ring *=
xdp_ring)
>  	}
>  skip:
>  	tx_desc->cmd_type_offset_bsz =3D 0;
> -	xdp_ring->next_to_clean +=3D xsk_frames;
> +	xdp_ring->next_to_clean +=3D completed_frames;
>  	if (xdp_ring->next_to_clean >=3D cnt)
>  		xdp_ring->next_to_clean -=3D cnt;
>  	if (xsk_frames)

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>


