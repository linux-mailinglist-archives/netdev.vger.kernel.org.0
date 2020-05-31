Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989921E984F
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 17:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgEaPFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 11:05:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59288 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727863AbgEaPFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 11:05:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bbD+C23yGjZTYXAsHsUqw6g39HqoValm/pb3DEr+jU0=; b=mpSb6YjsIaNAC1u4Ga5kLHjcsJ
        ObZDy5FQ0Fo/TjJlWCXGf85rlF8xQpGzsIdMujNJRD3sbdo1epqJEsGDap4MZtsR9Bbm4DFj9dzjA
        92QiYV4kT104vVz+nNNc//9UCOCdJ0OBGnDdhi0NNPSfrbPPStPsSTOSRKvJVbRSbmhI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jfPWK-003o0K-6b; Sun, 31 May 2020 17:05:04 +0200
Date:   Sun, 31 May 2020 17:05:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: netif_device_present() and Runtime PM / PCI D3
Message-ID: <20200531150504.GB897737@lunn.ch>
References: <d7e70ee5-1c7b-c604-61ca-dff1f2995d0b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7e70ee5-1c7b-c604-61ca-dff1f2995d0b@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 31, 2020 at 02:07:46PM +0200, Heiner Kallweit wrote:
> I just wonder about the semantics of netif_device_present().
> If a device is in PCI D3 (e.g. being runtime-suspended), then it's
> not accessible. So is it present or not?
> The description of the function just mentions the obvious case that
> the device has been removed from the system.

Hi Heiner

Looking at the code, there is no directly link to runtime suspend.  If
the drivers suspend code has detached the device then it won't be
present, but that tends to be not runtime PM, but WOL etc.

> Related is the following regarding ethtool:
> dev_ethtool() returns an error if device isn't marked as present.
> If device is runtime-suspended and in PCI D3, then the driver
> may still be able to provide quite some (cached) info about the
> device. Same applies for settings: Even if device is sleeping,
> the driver may store new settings and apply them once the device
> is awake again.

I think playing with cached state of a device is going to be a sources
of hard to find bugs. I would want to see a compelling use case for
this.

	Andrew
