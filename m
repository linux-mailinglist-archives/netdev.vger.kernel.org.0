Return-Path: <netdev+bounces-3954-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15315709C4F
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 18:22:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1EF51C212D4
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 16:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 276BE11CB3;
	Fri, 19 May 2023 16:22:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C16A5679
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 16:22:06 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BEF1BD;
	Fri, 19 May 2023 09:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=F9VR5GWsmaIvh2GRlnTeCnpK7d8csC6dZRD/nCtAshA=; b=Al8kK3YwCDmJ1zMU0PPrh+98h8
	xqSzwayDzUWNoLxxMXAB7v+uhAH/z0E2vIavco5dSEBhcQbK51En/1QsJzh7MiIvCVVjHo9brmfXn
	AHiUCl3EMKHxr4QXmv/qSdITOMrOOS/jj7B7adrLp+7MhpTrR0huboKi2NtukFNiTrOY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q02rL-00DLVY-Du; Fri, 19 May 2023 18:21:39 +0200
Date: Fri, 19 May 2023 18:21:39 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: alexis.lothore@bootlin.com
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com, paul.arola@telus.com,
	scott.roberts@telus.com,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH net-next v2 7/7] net: dsa: mv88e6xxx: enable support for
 88E6361 switch
Message-ID: <f8f60a03-b190-41ad-8b67-4c63fd43ae47@lunn.ch>
References: <20230519141303.245235-1-alexis.lothore@bootlin.com>
 <20230519141303.245235-8-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519141303.245235-8-alexis.lothore@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> @@ -421,9 +421,14 @@ phy_interface_t mv88e6390x_port_max_speed_mode(struct mv88e6xxx_chip *chip,
>  int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
>  				     int speed, int duplex)
>  {
> +	bool is_6361 =
> +		chip->info->prod_num == MV88E6XXX_PORT_SWITCH_ID_PROD_6361;
>  	u16 reg, ctrl;
>  	int err;
>  
> +	if (is_6361 && speed > 2500)
> +		return -EOPNOTSUPP;

I would move the comparison inside the if, so removing the ugly looking split is_6361 line.

> +
>  	if (speed == 200 && port != 0)
>  		return -EOPNOTSUPP;
>  
> @@ -506,8 +511,12 @@ int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
>  phy_interface_t mv88e6393x_port_max_speed_mode(struct mv88e6xxx_chip *chip,
>  					       int port)
>  {
> +	bool is_6361 =
> +		chip->info->prod_num == MV88E6XXX_PORT_SWITCH_ID_PROD_6361;
> +
>  	if (port == 0 || port == 9 || port == 10)
> -		return PHY_INTERFACE_MODE_10GBASER;
> +		return is_6361 ? PHY_INTERFACE_MODE_2500BASEX :
> +			PHY_INTERFACE_MODE_10GBASER;

Please see if you can rearrange this code as well.

Thanks
	Andrew

