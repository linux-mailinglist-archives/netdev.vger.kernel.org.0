Return-Path: <netdev+bounces-3911-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37F77709854
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 298A71C2124B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A030DDB7;
	Fri, 19 May 2023 13:31:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD4E7C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:31:20 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4A910F8;
	Fri, 19 May 2023 06:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=fASWcQQZFu9vJAgQoBF8AHHKBRfu7PRMfFGfAqrEr2E=; b=I5lFAz6MfIdiaABPErD7w+7M2B
	xwmf+C1bL/EsCujrpprezIWb4g2expSKqoYA+sR2iiGy0+FjLwEwtN36+37lNn29NOLBgZePp2mSI
	uOoHihrDOiN+Re5ZG8FlY4h/eiFTECkaas28R9trMRDBxe3/e8Aiv9DdtE+ydN1n9r2U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q00Bg-00DKTX-DY; Fri, 19 May 2023 15:30:28 +0200
Date: Fri, 19 May 2023 15:30:28 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Alexis =?iso-8859-1?Q?Lothor=E9?= <alexis.lothore@bootlin.com>
Cc: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com, paul.arola@telus.com,
	scott.roberts@telus.com
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: enable support for
 88E6361 switch
Message-ID: <85c07e51-8a0b-4328-bab3-acad2ee104e1@lunn.ch>
References: <20230517203430.448705-1-alexis.lothore@bootlin.com>
 <20230517203430.448705-3-alexis.lothore@bootlin.com>
 <9a836863-c279-490f-a49a-de4db5de9fd4@lunn.ch>
 <ee281c0f-5e8b-8453-08bf-858c5503dc22@bootlin.com>
 <6643e099-7b72-4da2-aba1-521e1a4c961b@lunn.ch>
 <20230519143713.1ac9c7a1@thinkpad>
 <7419ffc0-b292-97c4-fee6-610a1a841265@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7419ffc0-b292-97c4-fee6-610a1a841265@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> >> Ports 1 and 2 should hopefully be protected by the
> >> invalid_port_mask. It should not even be possible to create those
> >> ports. port 0 is interesting, and possibly currently broken on
> >> 6393. Please take a look at that.
> > 
> > Why would port 0 be broken on 6393x ?
> By "broken", I guess Andrew means that if we feed port 0 to
> mv88e6xxx_phy_is_internal, it will return true, which is wrong since there is no
> internal phy for port 0 on 6393X ?

Yes, that is what i was thinking. But i did not spend the time to look
at the code see if this is actually true. There might be a special
case somewhere in the code.

But in general, we try to avoid special cases, and add device specific
ops.

	Andrew

