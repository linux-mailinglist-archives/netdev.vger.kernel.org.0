Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1014A28A22D
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388401AbgJJWzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731435AbgJJTWZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 15:22:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99FC12237B;
        Sat, 10 Oct 2020 15:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602344662;
        bh=c+6LMXEZzk1A7ncH7/sCGuE4n/FGZyKgDHsr3FeDQJM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uE2WZWZ9o8F3vVGsdME6aFIsv4ylgXRKPxBisANoo3GaXljeSsDeWqMoPM1recgTu
         7fhouVQI4iIYJvq0oBzjo7l6uK5rSqvNizYYUrTaclRlYjJFU9nsaFcWg94Ssu4iPs
         XYcbwa5PTVW4dBjRDu1EeKZQygJ3DwZbMeGuXKXQ=
Date:   Sat, 10 Oct 2020 08:44:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 08/17] can: add ISO 15765-2:2016 transport protocol
Message-ID: <20201010084421.308645a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bcebf26e-3cfb-c7aa-e7fc-4faa744b9c2f@hartkopp.net>
References: <20201007213159.1959308-1-mkl@pengutronix.de>
        <20201007213159.1959308-9-mkl@pengutronix.de>
        <20201009175751.5c54097f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <bcebf26e-3cfb-c7aa-e7fc-4faa744b9c2f@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Oct 2020 16:29:06 +0200 Oliver Hartkopp wrote:
> >> diff --git a/net/can/Kconfig b/net/can/Kconfig
> >> index 25436a715db3..021fe03a8ed6 100644
> >> --- a/net/can/Kconfig
> >> +++ b/net/can/Kconfig
> >> @@ -55,6 +55,19 @@ config CAN_GW
> >>   
> >>   source "net/can/j1939/Kconfig"
> >>   
> >> +config CAN_ISOTP
> >> +	tristate "ISO 15765-2:2016 CAN transport protocol"
> >> +	default y  
> > 
> > default should not be y unless there is a very good reason.
> > I don't see such reason here. This is new functionality, users
> > can enable it if they need it.
> 
> Yes. I agree. But there is a good reason for it.
> The ISO 15765-2 protocol is used for vehicle diagnosis and is a *very* 
> common CAN bus use case.

More common than j1939? (Google uses words like 'widely used' and
'common' :)) To give you some perspective we don't enable Ethernet 
vlan support by default, vlans are pretty common, too.

> The config item only shows up when CONFIG_CAN is selected and then ISO 
> 15765-2 should be enabled too. I have implemented and maintained the 
> out-of-tree driver for ~12 years now and the people have real problems 
> using e.g. Ubuntu with signed kernel modules when they need this protocol.
> 
> Therefore the option should default to 'y' to make sure the common 
> distros (that enable CONFIG_CAN) enable ISO-TP too.

I understand the motivation, but Linus had pushed back on defaulting to
'y' many times over the years, please read this:

https://lkml.org/lkml/2012/1/6/354

This really must not pop up on his screen as default 'y' when he does
an oldconfig after pulling the networking tree..
