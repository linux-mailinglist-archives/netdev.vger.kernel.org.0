Return-Path: <netdev+bounces-5140-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E38170FC39
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:10:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB3C3280D99
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5F521B8E3;
	Wed, 24 May 2023 17:10:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F0219E6E
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:10:12 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E42BB;
	Wed, 24 May 2023 10:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=obSv2d9CNF4TRo5tXs9NOApHq5GFeZyX6XlxyKD/0ls=; b=yE
	gkY/FlfNGqIFvgACokn7CPlkszMIyq8ZvFxmW/N2kvEMFKsjfSbWOuw/lfuzV14U1O6q9Vom0otQC
	yEHtyJ8QlDVp0SHxT+0J6T25nJeIk7YfYGT+wDgYWGCIjEzklgKpxNr5wCHYci+7xDOHjq9mT1Yfs
	15h0G4UupaNobJE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q1rzx-00Dofj-6Y; Wed, 24 May 2023 19:10:05 +0200
Date: Wed, 24 May 2023 19:10:05 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Alexis =?iso-8859-1?Q?Lothor=E9?= <alexis.lothore@bootlin.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, devicetree@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	paul.arola@telus.com, scott.roberts@telus.com,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH net-next v3 4/7] net: dsa: mv88e6xxx: add field to
 specify internal phys layout
Message-ID: <93e2804a-0da2-48a7-942b-5231772459b9@lunn.ch>
References: <20230524130127.268201-1-alexis.lothore@bootlin.com>
 <20230524130127.268201-5-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230524130127.268201-5-alexis.lothore@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 03:01:24PM +0200, Alexis Lothoré wrote:
> mv88e6xxx currently assumes that switch equipped with internal phys have
> those phys mapped contiguously starting from port 0 (see
> mv88e6xxx_phy_is_internal). However, some switches have internal PHYs but
> NOT starting from port 0. For example 88e6393X, 88E6193X and 88E6191X have
> integrated PHYs available on ports 1 to 8
> To properly support this offset, add a new field to allow specifying an
> internal PHYs layout. If field is not set, default layout is assumed (start
> at port 0)
> 
> ---
> Changes since v2:
> - move start/end computation out of for loop
> - remove whitespace
> 
> Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

