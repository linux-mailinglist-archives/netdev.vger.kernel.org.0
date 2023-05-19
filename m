Return-Path: <netdev+bounces-3949-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69EE3709C18
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 18:11:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8DFF281C0C
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 16:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E913111AD;
	Fri, 19 May 2023 16:11:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B4E5679
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 16:11:33 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DF61AB;
	Fri, 19 May 2023 09:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=fEghx6mVjcgBf40Xq8ewYu2k1cwOduuzKJ9E2w6kTwM=; b=i1W21HiP4BIviwkn1gcVZAGlHI
	frWQrTpRodMyiUCDpfrOXFUrdkqUDsqQN5UhcGyWxJW5IkZHtevoCdkub2+rufkSMsPx1jaUNH/3w
	VAD1yJZwxtVK5eSgtdBCbr9E2DPYlqzGXaCn2sr1YoQa4SAULzUi26L9O6RmWgJ8GZPU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q02hN-00DLRZ-MI; Fri, 19 May 2023 18:11:21 +0200
Date: Fri, 19 May 2023 18:11:21 +0200
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
Subject: Re: [PATCH net-next v2 4/7] net: dsa: mv88e6xxx: add field to
 specify internal phys layout
Message-ID: <31103ab4-c055-43bc-a124-84976ee47e32@lunn.ch>
References: <20230519141303.245235-1-alexis.lothore@bootlin.com>
 <20230519141303.245235-5-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519141303.245235-5-alexis.lothore@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> @@ -1198,13 +1198,17 @@ int mv88e6xxx_g2_irq_mdio_setup(struct mv88e6xxx_chip *chip,
>  {
>  	int phy, irq;
>  
> -	for (phy = 0; phy < chip->info->num_internal_phys; phy++) {
> +	for (phy = chip->info->internal_phys_offset;
> +	     phy <
> +	     chip->info->num_internal_phys + chip->info->internal_phys_offset;
> +	     phy++) {

The code style is not so nice. How about moving this addition out of
the for loop, it is static anyway. And then you can avoid splitting
the expression over multiple lines.

>  		irq = irq_find_mapping(chip->g2_irq.domain, phy);
>  		if (irq < 0)
>  			return irq;
>  
>  		bus->irq[chip->info->phy_base_addr + phy] = irq;
>  	}
> +

No whitespace changed please.

    Andrew

---
pw-bot: cr

