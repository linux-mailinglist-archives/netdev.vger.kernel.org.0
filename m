Return-Path: <netdev+bounces-11364-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AA31732CB2
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:03:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8005C1C20F8A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A4ED1773C;
	Fri, 16 Jun 2023 10:03:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD6816409
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:03:22 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747512137;
	Fri, 16 Jun 2023 03:03:20 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-9741caaf9d4so69527666b.0;
        Fri, 16 Jun 2023 03:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686909799; x=1689501799;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lGc6cCn5ldb0f04cDIkyWElzF87ruXWX4HidWgznLg4=;
        b=rJoVgHkfAir/SjJT3wdJYIhF8WxsoNEsrTNCv/xcRwIbZQFxH/yEV4O3D9+R65KqyM
         GtpnSCIqc79/W8wTP+fcWgukEciWNlGS19ef8ZkvO4IVWoM0VRwTvu7/WxYd2eLnVpeg
         NQaoa1rFJtSn4uz2CrqAOgaKyaHvKK1Tq+cOb651QtMG/TsjjfKsZaC/i6R2gLtny5MY
         szjWuaoC0JuO65/LxQ7yXEyLk122NDDqifUas2M/BvEZTSd7cO6VhDSm4zn/KIE0KYrf
         Et1nhGZBqll9NnREpW6u4iuFLxSJevFGi6kRz0wqw10ughlKafRCGX0Ytn2K+HO7ROOo
         4f+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686909799; x=1689501799;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lGc6cCn5ldb0f04cDIkyWElzF87ruXWX4HidWgznLg4=;
        b=XWnEafxLwzUEfvOQvDgmMrQqNIzFqwVJqLz9Cc2RbWeVd8t1/w/VMJDfp20ld596+i
         719qn1QL6/d6O4ZTFC9vqPuwaXXO8O7McA5PH1aFR6SdeiI+CGqvoPKzQUnSCUUVS2UN
         im1rlaieLjmghFLiT0Eif8tbhav4hIxxNqmNOFbUT17PeStc6ernTCXaX+uCFExqtqVd
         tu3gaWSI2+plWmGHSblp73uKPIwec1DwgbJyg4Zp7jO9y0mspL+OEV2LxLPCIRKWQsoN
         LAO98gukj1/kCpdsNXFy/VItdtD3HkeM9zT10Ol7zKOp2xtPxSMngL3hI2iA+xT7RNay
         Ho3A==
X-Gm-Message-State: AC+VfDxfGSmuM8o0e2fbm+0hDj6y/nduxuFwL3sipclbzEZFpSEVg1C1
	I7mi67aw2iWpHRM05dUAhH0=
X-Google-Smtp-Source: ACHHUZ7SdZeVeeh6Ng8ykfH3X/im6EacjNnbYaRPIiZp2o/g6Edg4Qi/Rf3tJBYLJDxEeYMIbMb2Bg==
X-Received: by 2002:a17:907:9615:b0:977:fff0:31a with SMTP id gb21-20020a170907961500b00977fff0031amr1670482ejc.74.1686909798531;
        Fri, 16 Jun 2023 03:03:18 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id d23-20020a17090648d700b00982c84e5dadsm1348006ejt.170.2023.06.16.03.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 03:03:17 -0700 (PDT)
Date: Fri, 16 Jun 2023 13:03:14 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: arinc9.unal@gmail.com
Cc: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v5 2/6] net: dsa: mt7530: fix trapping frames on
 non-MT7621 SoC MT7530 switch
Message-ID: <20230616100314.x2qak6t7uxo2qnja@skbuf>
References: <20230616025327.12652-1-arinc.unal@arinc9.com>
 <20230616025327.12652-3-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230616025327.12652-3-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 05:53:23AM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> The check for setting the CPU_PORT bits must include the non-MT7621 SoC
> MT7530 switch variants to trap frames. Expand the check to include them.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---

why do you say non-MT7621 when the change specifically includes MT7621?
What is the affected SoC then?

>  drivers/net/dsa/mt7530.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 0a5237793209..e9fbe7ae6c2c 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1007,7 +1007,7 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
>  		   UNU_FFP(BIT(port)));
>  
>  	/* Set CPU port number */
> -	if (priv->id == ID_MT7621)
> +	if (priv->id == ID_MT7530 || priv->id == ID_MT7621)
>  		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
>  
>  	/* Add the CPU port to the CPU port bitmap for MT7531 and the switch on
> -- 
> 2.39.2
> 

