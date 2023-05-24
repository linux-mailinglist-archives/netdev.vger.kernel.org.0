Return-Path: <netdev+bounces-5133-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5837170FC13
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 18:59:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 12E9A28137E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 16:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ED6219E70;
	Wed, 24 May 2023 16:59:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F1C19E56
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 16:59:38 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49959E9;
	Wed, 24 May 2023 09:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=vKojb+lmgQ6/iIULJ2na4xC8cdrCol3xSR+2MNG+xDg=; b=BEts6+pXn8xYxsw58Ey/5mU5TL
	Mum+cwYx+VnKSayyJmO/lKEgzySACtSkoBrGkv/Anh0gNKoi08qhWGyEyLwseWJOe4V99jDZ5d8E6
	ivrLMjeg9M9itNhXoYfXYtxxsc/ODmkT+F6zAYowRfyOhQqsIaHF/ODNgIFLQnd6BJes=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q1rpg-00Doak-OI; Wed, 24 May 2023 18:59:28 +0200
Date: Wed, 24 May 2023 18:59:28 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>, kernel@pengutronix.de,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com,
	"Russell King (Oracle)" <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v1 4/5] net: dsa: microchip: ksz8: Prepare
 ksz8863_smi for regmap register access validation
Message-ID: <584bb123-28c7-4d56-bad7-efcc2c343ecb@lunn.ch>
References: <20230524123220.2481565-1-o.rempel@pengutronix.de>
 <20230524123220.2481565-5-o.rempel@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524123220.2481565-5-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 02:32:19PM +0200, Oleksij Rempel wrote:
> This patch prepares the ksz8863_smi part of ksz8 driver to utilize the
> regmap register access validation feature.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/ksz8863_smi.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8863_smi.c b/drivers/net/dsa/microchip/ksz8863_smi.c
> index 2af807db0b45..303a4707c759 100644
> --- a/drivers/net/dsa/microchip/ksz8863_smi.c
> +++ b/drivers/net/dsa/microchip/ksz8863_smi.c
> @@ -104,6 +104,7 @@ static const struct regmap_config ksz8863_regmap_config[] = {
>  		.cache_type = REGCACHE_NONE,
>  		.lock = ksz_regmap_lock,
>  		.unlock = ksz_regmap_unlock,
> +		.max_register = BIT(8) - 1,

Maybe SZ_256 - 1 is more readable?

>  	},
>  	{
>  		.name = "#16",
> @@ -113,6 +114,7 @@ static const struct regmap_config ksz8863_regmap_config[] = {
>  		.cache_type = REGCACHE_NONE,
>  		.lock = ksz_regmap_lock,
>  		.unlock = ksz_regmap_unlock,
> +		.max_register = BIT(8) - 2,

- 2?

Is this the 16 bit regmap? So it has 1/2 the number of registers of
the 8 bit regmap? So i would of thought it should be BIT(7)-1, or
SZ_128-1 ?

	Andrew

