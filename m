Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935273E5C37
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241958AbhHJNwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:52:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42784 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233318AbhHJNwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:52:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vwFLT4+27CRtnUCkJziUxWxlelBpkqj0pMbthsbnvyI=; b=xQ3SfSF38IFEQn5iWl1kPU5XLO
        4ALStzGe9c1Mm1CADIqxcSiA0/hrYAJYl8YLWloLC+gUvRInplId0ZFIJGfX0fSmghNBU0LScczsJ
        l6aS6MUXo+8SYXYak3PmUjga72w9fNWkhTmhSlU+vqcdxH8F+Gj1UjHVvTZ6tWmAawmk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDSB2-00GuhG-Rb; Tue, 10 Aug 2021 15:52:20 +0200
Date:   Tue, 10 Aug 2021 15:52:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Message-ID: <YRKElHYChti9EeHo@lunn.ch>
References: <20210809102152.719961-1-idosch@idosch.org>
 <20210809102152.719961-2-idosch@idosch.org>
 <YRE7kNndxlGQr+Hw@lunn.ch>
 <YRIqOZrrjS0HOppg@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRIqOZrrjS0HOppg@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The transition from low power to high power can take a few seconds with
> QSFP/QSFP-DD and it's likely to only get longer with future / more
> complex modules. Therefore, to reduce link-up time, the firmware
> automatically transitions modules to high power mode.
> 
> There is obviously a trade-off here between power consumption and
> link-up time. My understanding is that Mellanox is not the only vendor
> favoring shorter link-up times as users have the ability to control the
> low power mode of the modules in other implementations.
> 
> Regarding "why do we need user space involved?", by default, it does not
> need to be involved (the system works without this API), but if it wants
> to reduce the power consumption by setting unused modules to low power
> mode, then it will need to use this API.

O.K. Thanks for the better explanation. Some of this should go into
the commit message.

I suggest it gets a different name and semantics, to avoid
confusion. I think we should consider this the default power mode for
when the link is administratively down, rather than direct control
over the modules power mode. The driver should transition the module
to this setting on link down, be it high power or low power. That
saves a lot of complexity, since i assume you currently need a udev
script or something which sets it to low power mode on link down,
where as you can avoid this be configuring the default and let the
driver do it.

I also wonder if a hierarchy is needed? You can set the default for
the switch, and then override is per module? I _guess_ most users will
decide at a switch level they want to save power and pay the penalty
over longer link up times. But then we have the question, is it an
ethtool option, or a devlink parameter?

	Andrew
