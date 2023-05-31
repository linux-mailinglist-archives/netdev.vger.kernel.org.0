Return-Path: <netdev+bounces-6795-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAC367180A9
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:57:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AE5E2814CC
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:57:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 194541428F;
	Wed, 31 May 2023 12:57:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1B3A936
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 12:57:29 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6A3E47;
	Wed, 31 May 2023 05:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=9a9sWcV3B1HupudEIN770V6gR2bhvM4pEaGkOVzI7Dg=; b=6Qf3UDOaSEL6pVq3e6HbaJSGSo
	eoeenu6PzU7F7oFw2BgTfA9SxiECFR+nEK5Aflf4i3R5rqyaJtjkmUD/qjQ2xQjblcsYqRVRSFOWG
	ifxktaLOrzhVsYlGkyNaBt1eb8Y4x70wdvcYNNWDSnkDLtAM/+fYsm7uLB4r4s67Opms=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q4LNM-00ESZe-Ov; Wed, 31 May 2023 14:56:28 +0200
Date: Wed, 31 May 2023 14:56:28 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Lukasz Majewski <lukma@denx.de>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
	Vivien Didelot <vivien.didelot@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC] net: dsa: slave: Advertise correct EEE capabilities at
 slave PHY setup
Message-ID: <1a3342eb-5a0f-486d-90af-4e052760cf7b@lunn.ch>
References: <20230530122621.2142192-1-lukma@denx.de>
 <ZHXzTBOtlPKqNfLw@shell.armlinux.org.uk>
 <20230530160743.2c93a388@wsk>
 <ZHYGv7zcJd/Ad4hH@shell.armlinux.org.uk>
 <35546c34-17a6-4295-b263-3f2a97d53b94@lunn.ch>
 <20230530164731.0b711649@wsk>
 <ZHYRgIb6UCYq1n/Z@shell.armlinux.org.uk>
 <20230531104346.2a131c42@wsk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531104346.2a131c42@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Thanks for the detailed explanation.
> 
> With "switch" setup - where I do have MAC from imx8 (fec driver)
> connected to e.g. mv88e6071 with "fixed-link", I do guess that the EEE
> management is done solely in mv88e6071?

So you have the MAC-MAC connection? No back to back PHYs in the
middle. If there is no PHY, linux will not do anything with EEE. What
happens will depend on the reset defaults of the switch. For the FEC
phy_eee_init() will return false, so i expect EEE is disabled.

> In other words - the mv88e6071 solely decides if its internal PHY shall
> signal EEE to the peer switch.

Handling EEE in the mv88e6xxx driver is something on my todo list. But
i don't expect it to happen soon. And before it will happen we
actually need to decide how the user API should work.

	Andrew

