Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68514462896
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 00:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhK2XyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 18:54:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58068 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231130AbhK2XyA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Nov 2021 18:54:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tF5Apw2PNzMwcQw1BOx9Us39yUpHvQHiehCJgExkWWg=; b=xvGdMd3ZrtNPSluu6VyRYfHW9z
        2tooonGjFjFd+KUKIUi80s6csdo+Nw6Tg9FmiizQgqq6avZoQkceiUSe+jane/GknPz6esjZyeOC3
        DA1dr9+jwqK0L+Ru2iDm542TkXnyIw/5orwVYGKLTViPp+H8jwAIkjQv7tdxzaZmRn5g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mrqPx-00Eyj8-4U; Tue, 30 Nov 2021 00:50:41 +0100
Date:   Tue, 30 Nov 2021 00:50:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, mkubecek@suse.cz, pali@kernel.org,
        jacob.e.keller@intel.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to flash and query
 transceiver modules' firmware
Message-ID: <YaVnUeWtCo7Zxwdc@lunn.ch>
References: <20211127174530.3600237-1-idosch@idosch.org>
 <20211129093724.3b76ebff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129093724.3b76ebff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 09:37:24AM -0800, Jakub Kicinski wrote:
> On Sat, 27 Nov 2021 19:45:26 +0200 Ido Schimmel wrote:
> > This patchset extends the ethtool netlink API to allow user space to
> > both flash transceiver modules' firmware and query the firmware
> > information (e.g., version, state).
> > 
> > The main use case is CMIS compliant modules such as QSFP-DD. The CMIS
> > standard specifies the interfaces used for both operations. See section
> > 7.3.1 in revision 5.0 of the standard [1].
> > 
> > Despite the immediate use case being CMIS compliant modules, the user
> > interface is kept generic enough to accommodate future use cases, if
> > these arise.
> > 
> > The purpose of this RFC is to solicit feedback on both the proposed user
> > interface and the device driver API which are described in detail in
> > patches #1 and #3. The netdevsim patches are for RFC purposes only. The
> > plan is to implement the CMIS functionality in common code (under lib/)
> > so that it can be shared by MAC drivers that will pass function pointers
> > to it in order to read and write from their modules EEPROM.
> > 
> > ethtool(8) patches can be found here [2].
> 
> Immediate question I have is why not devlink. We purposefully moved 
> FW flashing to devlink because I may take long, so doing it under
> rtnl_lock is really bad. Other advantages exist (like flashing
> non-Ethernet ports). Ethtool netlink already existed at the time.
> 
> I think device flashing may also benefit from the infra you're adding.

The idea of asynchronous operations without holding RTNL is not that
new. The cable test code does it, but clearly cable testing is likely
network specific, unlike FW flashing.

	Andrew
