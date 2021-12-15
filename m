Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FA6475504
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 10:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241097AbhLOJTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 04:19:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56030 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236370AbhLOJTA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 04:19:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=N/BHcqYbeBKuPaHbSSkfkqmZ1iq2aVpkVjLY1d/Xf0I=; b=Td0skQN7yczo1H98juij9wlKix
        QuRalEGmBQu1KHUcssGLRbNpaJSEwIQI0VjldRpAZ3zrToDKhh0Cc2vpqb2gKpXgF3VcBPcJLkuyw
        DsWyrtaTDSpCZtfI9/hIpDXc7+ijEewMEfD0bwYKys9+x984r16MAjVpFrQWAQ5+3sT0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mxQR8-00GcrH-FN; Wed, 15 Dec 2021 10:18:58 +0100
Date:   Wed, 15 Dec 2021 10:18:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alex Elder <elder@linaro.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>
Subject: Re: Port mirroring (RFC)
Message-ID: <YbmzAkE+5v7Mv89D@lunn.ch>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <YbjiCNRffWYEcWDt@lunn.ch>
 <3bd97657-7a33-71ce-b33a-e4eb02ee7e20@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bd97657-7a33-71ce-b33a-e4eb02ee7e20@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> IPA is a device that sits between the main CPU and a modem,
> carrying WWAN network data between them.
> 
> In addition, there is a small number of other entities that
> could be reachable through the IPA hardware, such as a WiFi
> device providing access to a WLAN.
> 
> Packets can travel "within IPA" between any of these
> "connected entities."  So far only the path between the
> AP and the modem is supported upstream, but I'm working
> on enabling more capability.
> 
> Technically, the replicated packets aren't visible on
> any one port; the only way to see that traffic is in
> using this special port.  To me this seemed like port
> mirroring, which is why I suggested that.  I'm want to
> use the proper model though, so I appreciate your
> response.

Do you have netdevs for the modem, the wifi, and whatever other
interfaces the hardware might have?

To setup a mirror you would do something like:

sudo tc filter add dev eth0 parent ffff: protocol all u32 match u32 0 0 action mirred egress mirror dev tun0

where you are mirroring eth0 to tun0. eth0 would have to be your modem
netdev, or your wifi netdev, and tun0 would be your monitor device.

If you do have a netdev on the host for each of these network
interfaces, mirroring could work. Architecturally, it would make sense
to have these netdevs, so you can run wpa_supplicant on the wifi
interface to do authentication, etc.

Do you have control over selecting egress and ingress packets to be
mirrored?

	Andrew
