Return-Path: <netdev+bounces-6498-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80BC7716AEF
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:29:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 215C21C20CB2
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A63E200C0;
	Tue, 30 May 2023 17:29:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903A91F179
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:29:14 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DFC1B0;
	Tue, 30 May 2023 10:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=UPIzzM2XTXYlyeunj9pSiEJHYLW/0kBAsxfRPWFzyzA=; b=Zivuydhf0oPmZYxawFyEJu8cl5
	tEPnHcyj7vLPGLzHaug/7uX05H9M0iL1uLFLpLrobUIt8be/bWbYSYqspdbLaYncZubNunEuXCiNv
	5Fuud/fF1+k+AcNyoUM3pjIHwIHB8uOqIjoXTxD81FY9KfF0FsUYEvg4VNzR4YCM4l88=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q438t-00EMVz-3z; Tue, 30 May 2023 19:28:19 +0200
Date: Tue, 30 May 2023 19:28:19 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Andreas Svensson <andreas.svensson@axis.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	kernel@axis.com, Baruch Siach <baruch@tkos.co.il>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Increase wait after reset
 deactivation
Message-ID: <be44dfe3-b4cb-4fd5-b4bd-23eec4bd401c@lunn.ch>
References: <20230530145223.1223993-1-andreas.svensson@axis.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530145223.1223993-1-andreas.svensson@axis.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 04:52:23PM +0200, Andreas Svensson wrote:
> A switch held in reset by default needs to wait longer until we can
> reliably detect it.
> 
> An issue was observed when testing on the Marvell 88E6393X (Link Street).
> The driver failed to detect the switch on some upstarts. Increasing the
> wait time after reset deactivation solves this issue.
> 
> The updated wait time is now also the same as the wait time in the
> mv88e6xxx_hardware_reset function.

Do you have an EEPROM attached and content in it?

It is not necessarily the reset itself which is the problem, but how
long it takes after the reset to read the contents of the
EEPROM. While it is doing that, is does not respond on the MDIO
bus. Which is why mv88e6xxx_hardware_reset() polls for that to
complete.

I know there are some users who want the switch to boot as fast as
possible, and don't really want the additional 9ms delay. But this is
also a legitimate change. I'm just wondering if we need to consider a
DT property here for those with EEPROM content. Or, if there is an
interrupt line, wait for the EEPROM complete interrupt. We just have
tricky chicken and egg problems. At this point in time, we don't
actually know if the devices exists or not.

	  Andrew

