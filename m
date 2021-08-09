Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950AF3E4785
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 16:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbhHIO24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 10:28:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40042 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233694AbhHIO24 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 10:28:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=F4DhbGUOPXo6ugmm0ah8Dj38i7Bdhu72dkHDQRmEwXQ=; b=mjUOz3p4boTX5PVGaLhmIfR1Jm
        qSxUIfsfiUo6mxQXMJfltepttZcAOxPJFjipQS8ysa+ERSRpl6sJm05cKSqkY0nC/3q5k8mrWrHmE
        sk/Dm0qoWFwaQ3HrfzI61iWmt6CGTXsc6JKDopshSLFZG5xip8+zTZy7GyX66lEvuIAw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mD6GW-00Gial-Dp; Mon, 09 Aug 2021 16:28:32 +0200
Date:   Mon, 9 Aug 2021 16:28:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Message-ID: <YRE7kNndxlGQr+Hw@lunn.ch>
References: <20210809102152.719961-1-idosch@idosch.org>
 <20210809102152.719961-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809102152.719961-2-idosch@idosch.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 01:21:45PM +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Add a pair of new ethtool messages, 'ETHTOOL_MSG_MODULE_SET' and
> 'ETHTOOL_MSG_MODULE_GET', that can be used to control transceiver
> modules parameters and retrieve their status.

Hi Ido

I've not read all the patchset yet, but i like the general direction.

> The first parameter to control is the low power mode of the module. It
> is only relevant for paged memory modules, as flat memory modules always
> operate in low power mode.
> 
> When a paged memory module is in low power mode, its power consumption
> is reduced to the minimum, the management interface towards the host is
> available and the data path is deactivated.
> 
> User space can choose to put modules that are not currently in use in
> low power mode and transition them to high power mode before putting the
> associated ports administratively up.
> 
> Transitioning into low power mode means loss of carrier, so error is
> returned when the netdev is administratively up.

However, i don't get this use case. With copper PHYs, putting the link
administratively down results in a call into phylib and into the
driver to down the link. This effectively puts the PHY into a low
power mode. The management interface, as defined by C22 and C45 remain
available, but the data path is disabled. For a 1G PHY, this can save
a few watts.

For SFPs managed by phylink and the kernal SFP driver, the exact same
happens. The TX_ENABLE pin of the SFP is set to false. The I2C bus
still works, but the data path is disabled.

So i would expect a driver using firmware, not Linux code to manage
SFPs, to just do this on link down. Why do we need user space
involved?

    Andrew

