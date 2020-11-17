Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C692B6998
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgKQQLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:11:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727298AbgKQQLv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 11:11:51 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7F6C2463D;
        Tue, 17 Nov 2020 16:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605629511;
        bh=L63llMV2FMC+E9qdiSTIJ//xn/d4NWH+qdGamgCxkJQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=v2sl2oz12YbryGBOd2sByIEKQ/YCxX0nfN+kIW8Wu3YibAXAlOAdNW6HF8O71BKUF
         dF98dpigKw9Y5U2RsH8jurGARVEclLn8CPo/fkvFxpTLrqdAlrbrBvesD82a3idu5+
         61ziDNM45vw/dZwtX6vF14fOreWkUj85A2B/OkL0=
Date:   Tue, 17 Nov 2020 08:11:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next] r8153_ecm: avoid to be prior to r8152 driver
Message-ID: <20201117081149.20723b4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <02f38e505a3a45389e2f3c06b2f6c850@realtek.com>
References: <7fd014f2-c9a5-e7ec-f1c6-b3e4bb0f6eb6@samsung.com>
        <CGME20201116065317eucas1p2a2d141857bbdd6b4998dd11937d52f56@eucas1p2.samsung.com>
        <1394712342-15778-393-Taiwan-albertk@realtek.com>
        <5f3db229-940c-c8ed-257b-0b4b3dd2afbb@samsung.com>
        <20201116090231.423afc8f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <02f38e505a3a45389e2f3c06b2f6c850@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 01:50:03 +0000 Hayes Wang wrote:
> Jakub Kicinski <kuba@kernel.org>
> > Sent: Tuesday, November 17, 2020 1:03 AM  
> [...]
> > > Yes, this fixes this issue, although I would prefer a separate Kconfig
> > > entry for r8153_ecm with proper dependencies instead of this ifdefs in
> > > Makefile.  
> > 
> > Agreed, this is what dependency resolution is for.
> > 
> > Let's just make this a separate Kconfig entry.  
> 
> Excuse me. I am not familiar with Kconfig.
> 
> I wish r8153_ecm could be used, even
> CONFIG_USB_RTL8152 is not defined.
> 
> How should set it in Kconfig? 

Something like this?

config USB_RTL8153_ECM
	tristate <headline text>
	select MII
	select USB_NET_CDCETHER
	depends on USB_RTL8152 || USB_RTL8152=n
	help
		<you help text>


select clauses will pull in the dependencies you need, and the
dependency on RTL8152 will be satisfied either when RTL8152's code 
is reachable (both are modules or RTL8152 is built in) or when RTL8152
is not built at all.

Does that help?
