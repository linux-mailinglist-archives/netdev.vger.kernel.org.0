Return-Path: <netdev+bounces-7342-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A390271FCC0
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:54:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DDD5281760
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 08:54:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52C43C8EC;
	Fri,  2 Jun 2023 08:53:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A0C46AA
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:53:26 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB73E6D
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 01:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=kbS2UwqF+dnVZY/XUMn7QZlmb5IKyGIwfOGYJB/ZAGg=; b=kSB1d0VR75hhl0Byvm0grU8b1/
	pUypk2+wtIzbk1gAZbW1eLw9VPEwkKt74L5Twx73A+nDAT9yFGZNkZt1bNtSlH/6agvmMd65ufgB+
	R04aquQ4jfgYd0+NDmWP65FhATzYvpRNSeZwtFpyAgwDbhkdjSgV9aEPI4nR0JJTinr0FIiVOOqP7
	OUz/LDz8a+rmSDlCzDBVlzeFg90nCyAd+GmN1eE/8tVEUxAsK9G0okCpkok9VVpnYH/mWV+Hx8LzD
	0hIQq/UQ3ZltSG220wXKfVM+abKWl+5nPldOSNQvUoJfU6KksXFWOQsXivD6/iEmN3l/ZLUjWnGKh
	1xynHb4g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39330)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q50X2-0007hF-Dq; Fri, 02 Jun 2023 09:53:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q50Wz-0002nS-NK; Fri, 02 Jun 2023 09:53:09 +0100
Date: Fri, 2 Jun 2023 09:53:09 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleksij Rempel <linux@rempel-privat.de>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylib: fix phy_read*_poll_timeout()
Message-ID: <ZHmt9c9VsYxcoXaI@shell.armlinux.org.uk>
References: <E1q4kX6-00BNuM-Mx@rmk-PC.armlinux.org.uk>
 <20230601213345.3aaee66a@kernel.org>
 <20230601213509.7ef8f199@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601213509.7ef8f199@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 09:35:09PM -0700, Jakub Kicinski wrote:
> On Thu, 1 Jun 2023 21:33:45 -0700 Jakub Kicinski wrote:
> > On Thu, 01 Jun 2023 16:48:12 +0100 Russell King (Oracle) wrote:
> > > +	__ret = read_poll_timeout(__val = phy_read, val, \  
> >                                                     ^^^
> > Is this not __val on purpose?
> 
> Yes it is :)  All this to save the single line of assignment
> after the read_poll_timeout() "call" ?

Okay, so it seems you don't like it. We can't fix it then, and we'll
have to go with the BUILD_BUG_ON() forcing all users to use a signed
varable (which better be larger than a s8 so negative errnos can fit)
or we just rely on Dan to report the problems.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

