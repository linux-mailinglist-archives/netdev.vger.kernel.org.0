Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C389B6C553D
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjCVT4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjCVT4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:56:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC5F5F210;
        Wed, 22 Mar 2023 12:56:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F67CB81DC8;
        Wed, 22 Mar 2023 19:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD89C433EF;
        Wed, 22 Mar 2023 19:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679514981;
        bh=qhgRNOt8Yok2ZXUiPTNUwcAQwbu3UguOEej6KNc66iI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WtCkrXrgQRPaTqEJML0D/SZhatuSNV6YVDfoaqni2eYlJDCzsxDjzf78uLzBG7Kcf
         JMdYhHGBKgOPuok23rO46aeYhUr7CGgV7NWy3uzMF37FblyWsujxKt6IlHYxu2JR5e
         DYVw7HHIMRPhgG/WP3KbvZyzSZNc5Uboy1p5GpYKyKDgUg9cvZMQ0zXdm4ZbyXopCX
         nkKSgnoFnTMbf+ZddsjPr2Qn8BnGHC612Prr0vXmq1Pj5TxdPNyg3yJVQA04IroHHY
         xy92xXKQXZuyMe+wXU745Em8KlSBSa5EmN8/dX8HdmecUMU9ceTAnFPNoE/YMTyzZe
         MI8VSc38cdJuQ==
Date:   Wed, 22 Mar 2023 12:56:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <lnimi@hotmail.com>
Cc:     richardcochran@gmail.com, lee@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: Re: [PATCH mfd 1/1] mfd/ptp: clockmatrix: support 32-bit address
 space
Message-ID: <20230322125619.731912cf@kernel.org>
In-Reply-To: <MW5PR03MB69323E281F1360A4F6C92838A0819@MW5PR03MB6932.namprd03.prod.outlook.com>
References: <MW5PR03MB69323E281F1360A4F6C92838A0819@MW5PR03MB6932.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Mar 2023 15:10:06 -0400 Min Li wrote:
> -		buf[0] = (u8)(page & 0xff);
> -		buf[1] = (u8)((page >> 8) & 0xff);
> +		buf[0] = (u8)(page & 0xFF);
> +		buf[1] = (u8)((page >> 8) & 0xFF);

why did you decide to change from 0xff to 0xFF as part of this big
change? It's unnecessary churn.

> +		buf[2] = (u8)((page >> 16) & 0xFF);
> +		buf[3] = (u8)((page >> 24) & 0xFF);
> +		bytes = 4;
>  		break;

>  static inline int idtcm_read(struct idtcm *idtcm,
> -			     u16 module,
> +			     u32 module,
>  			     u16 regaddr,
>  			     u8 *buf,
>  			     u16 count)
> @@ -50,7 +50,7 @@ static inline int idtcm_read(struct idtcm *idtcm,
>  }
>  
>  static inline int idtcm_write(struct idtcm *idtcm,
> -			      u16 module,
> +			      u32 module,
>  			      u16 regaddr,
>  			      u8 *buf,
>  			      u16 count)

>  	/* PLL5 can have OUT8 as second additional output. */
>  	if (pll == 5 && qn_plus_1 != 0) {
> -		err = idtcm_read(idtcm, 0, HW_Q8_CTRL_SPARE,
> +		err = idtcm_read(idtcm, HW_Q8_CTRL_SPARE, 0,
>  				 &temp, sizeof(temp));
>  		if (err)
>  			return err;
>  
>  		temp &= ~(Q9_TO_Q8_SYNC_TRIG);
>  
> -		err = idtcm_write(idtcm, 0, HW_Q8_CTRL_SPARE,
> +		err = idtcm_write(idtcm, HW_Q8_CTRL_SPARE, 0,
>  				  &temp, sizeof(temp));
>  		if (err)
>  			return err;
>  
>  		temp |= Q9_TO_Q8_SYNC_TRIG;
>  
> -		err = idtcm_write(idtcm, 0, HW_Q8_CTRL_SPARE,
> +		err = idtcm_write(idtcm, HW_Q8_CTRL_SPARE, 0,
>  				  &temp, sizeof(temp));
>  		if (err)
>  			return err;

Why are you flipping all these arguments?
Isn't HW_Q8_CTRL_SPARE regaddr?

Could you to split your patches into multiple steps to make them easier
to reivew?
