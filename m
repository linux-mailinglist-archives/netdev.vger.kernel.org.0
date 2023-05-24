Return-Path: <netdev+bounces-5006-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 48DD470F6AA
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:40:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C6801C20CFD
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 594C860846;
	Wed, 24 May 2023 12:40:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451B560843
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:40:04 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BEB999;
	Wed, 24 May 2023 05:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=p9jtkTU6w6N+Se7bpb6cKhTNXMlbx5R+g3G68tHH3fI=; b=q4afkSF547n2x/Eh++o0qH9q57
	sC5Yj9bj8i7TPP3UxAdGHPjSjX+/eZEF8ZbkTv7n9WGqpU2ody/RS9qYRcqx6hbldOK0oMagXazma
	YxwR0hR/iF4MiXkuXe56qGi4+3J8uuQflrP0Jqy+iKiyRDBVJAUstx0qghXkfMiQDZHvgJ5KkG6eg
	Il+hOaIDZczLFhP2uGNCV3+u7oC9xtlv8+h0GQXVdznIEbCe4zzYryCcPdN3+R58bhfdIMG2ZNv9f
	sRYLfzGEYNVXtHGQQNPAxDZqEZ1SVS/wzeJNmcHpr/DtXyrOb5ICJ2EGAmeXbIt8V100ZNrpe6sJ6
	Ck1XIEBA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59500)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q1nmU-0002It-Gy; Wed, 24 May 2023 13:39:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q1nmT-0001dY-K4; Wed, 24 May 2023 13:39:53 +0100
Date: Wed, 24 May 2023 13:39:53 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Woojung Huh <woojung.huh@microchip.com>,
	Arun Ramadoss <arun.ramadoss@microchip.com>, kernel@pengutronix.de,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 1/5] net: dsa: microchip: improving error
 handling for 8-bit register RMW operations
Message-ID: <ZG4FmSKeQzp6yG7z@shell.armlinux.org.uk>
References: <20230524123220.2481565-1-o.rempel@pengutronix.de>
 <20230524123220.2481565-2-o.rempel@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524123220.2481565-2-o.rempel@pengutronix.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 02:32:16PM +0200, Oleksij Rempel wrote:
> This patch refines the error handling mechanism for 8-bit register
> read-modify-write operations. In case of a failure, it now logs an error
> message detailing the problematic offset. This enhancement aids in
> debugging by providing more precise information when these operations
> encounter issues.
> 
> Furthermore, the ksz_prmw8() function has been updated to return error
> values rather than void, enabling calling functions to appropriately
> respond to errors.

What happens when there is an error that affects the current and future
accesses? Does this PHY driver then begin to flood the kernel log?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

