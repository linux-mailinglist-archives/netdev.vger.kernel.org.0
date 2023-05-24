Return-Path: <netdev+bounces-5135-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A2A6770FC21
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:03:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A80E1C20AB3
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 965C119E69;
	Wed, 24 May 2023 17:03:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5F96087C
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:03:49 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E5FFC;
	Wed, 24 May 2023 10:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=xngnOTHnMcuSLuO19bCUtMqmaPj/zfQQZoM9yYAXdxs=; b=z1qO6QeiyV6CNKz82XzH8bb/Km
	+w6RIScjeq1wtEU8MG13gJxNS1GH1d4J9bM5eky3JIdabQHpT/AHaisnrhRnTqg4SDFhhEcjffp+s
	E5b6HZWWeegeBqKQA1rT21DMnUtqk5COjNX2ZkjjVdatU66mmW5ku0DvZcWqa7DYTfkk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q1rti-00DocK-3N; Wed, 24 May 2023 19:03:38 +0200
Date: Wed, 24 May 2023 19:03:38 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>, kernel@pengutronix.de,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com,
	"Russell King (Oracle)" <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v1 2/5] net: dsa: microchip: add an enum for
 regmap widths
Message-ID: <9b1b2f17-0489-4adb-8e17-594a813c2dc9@lunn.ch>
References: <20230524123220.2481565-1-o.rempel@pengutronix.de>
 <20230524123220.2481565-3-o.rempel@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524123220.2481565-3-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 02:32:17PM +0200, Oleksij Rempel wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> It is not immediately obvious that this driver allocates, via the
> KSZ_REGMAP_TABLE() macro, 3 regmaps for register access: dev->regmap[0]
> for 8-bit access, dev->regmap[1] for 16-bit and dev->regmap[2] for
> 32-bit access.
> 
> In future changes that add support for reg_fields, each field will have
> to specify through which of the 3 regmaps it's going to go. Add an enum
> now, to denote one of the 3 register access widths, and make the code go
> through some wrapper functions for easier review and further
> modification.

Given the patches in this series, it is not obvious why the wrapper is
needed.

dev->regmap[KSZ_REGMAP_8] is just as readable as ksz_regmap_8(dev).

Do future changes add extra parameters to ksz_regmap_8()?

   Andrew

