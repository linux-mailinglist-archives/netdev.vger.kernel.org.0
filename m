Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F742EE86D
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 23:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbhAGWYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 17:24:41 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55902 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728287AbhAGWYl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 17:24:41 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxdhG-00GlDY-HM; Thu, 07 Jan 2021 23:23:58 +0100
Date:   Thu, 7 Jan 2021 23:23:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net, krishna.c.sudi@intel.com
Subject: Re: [PATCH 17/18] net: iosm: readme file
Message-ID: <X/eJ/rl4U6edWr3i@lunn.ch>
References: <20210107170523.26531-1-m.chetan.kumar@intel.com>
 <20210107170523.26531-18-m.chetan.kumar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107170523.26531-18-m.chetan.kumar@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/wwan/iosm/README b/drivers/net/wwan/iosm/README

Please convert this to rst, and put it somewhere under Documentation.

> +Multiplexed IP sessions (IPS)
> +-----------------------------
> +IOSM driver allows multiplexing of several IP sessions over the single network
> +device of type wwan0. IOSM driver models such IP sessions as 802.1q VLAN
> +subdevices of the master wwanY device, mapping MBIM IP session M to VLAN ID M
> +for all values of M greater than 0.
> +
> +The userspace management application is responsible for adding new VLAN links
> +prior to establishing MBIM IP sessions where the SessionId is greater than 0.
> +These links can be added by using the normal VLAN kernel interfaces.
> +
> +For example, adding a link for a MBIM IP session with SessionId 5:
> +
> +  ip link add link wwan0 name wwan0.<name> type vlan id 5

So, this is what all the Ethernet nonsense is all about. You have a
session ID you need to somehow represent to user space. And you
decided to use VLANs. But to use VLANs, you need an Ethernet
header. So you added a bogus Ethernet header.

Is any of this VLAN stuff required by MBIM?

I suggest you throw away the pretence this is an Ethernet device. It
is not.

Linux allows you to dynamically create/destroy network
interfaces. So you want to do something like

ip link add link wwan0 name wwan42 type mbim id 42

Which will create a new mbim netdev interface using session id 42 on
top of the device which provides wwan0. I don't actually like this
last bit, but you somehow need to indicate on which MBIM transport you
want to create the new session, since you could have multiple bits of
hardware providing MBIM services.

	 Andrew
