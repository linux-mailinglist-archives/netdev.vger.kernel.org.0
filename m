Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D673B2089
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 20:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhFWSrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 14:47:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52192 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWSrS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 14:47:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=42GPZFs4rINBWycXZaqV8FG8P886kdleDSzhHJCKgRU=; b=nikJP2KFEDPF78x0ag6cpCYtgn
        +ZgJNLsU56vewHaRPzFuvnSzsgmpdxmQyLVzrOEu7w4tysWTCNKnNM8cTHnAhkXxrey+HiX/A913s
        JnhpXCnzph+B4AfiRDHrLRa3/tzkBwywbUuvQTZBcqfA7UnSOB5agWcq6bx+DiY0HmWk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lw7rt-00AsNX-E8; Wed, 23 Jun 2021 20:44:57 +0200
Date:   Wed, 23 Jun 2021 20:44:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, vladyslavt@nvidia.com, moshe@nvidia.com,
        vadimp@nvidia.com, mkubecek@suse.cz, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 0/4] ethtool: Add ability to write to
 transceiver module EEPROMs
Message-ID: <YNOBKRzk4S7ZTeJr@lunn.ch>
References: <20210623075925.2610908-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210623075925.2610908-1-idosch@idosch.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 10:59:21AM +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset adds write support to transceiver module EEPROMs by
> extending the ethtool netlink API.
> 
> Motivation
> ==========
> 
> The kernel can currently dump the contents of module EEPROMs to user
> space via the ethtool legacy ioctl API or the new netlink API. These
> dumps can then be parsed by ethtool(8) according to the specification
> that defines the memory map of the EEPROM. For example, SFF-8636 [1] for
> QSFP and CMIS [2] for QSFP-DD.
> 
> In addition to read-only elements, these specifications also define
> writeable elements that can be used to control the behavior of the
> module. For example, controlling whether the module is put in low or
> high power mode to limit its power consumption.

Hi Ido

So power control is part of the specification? All CMIS devices should
implement it the same.

> The CMIS specification even defines a message exchange mechanism (CDB,
> Command Data Block) on top of the module's memory map. This allows the
> host to send various commands to the module. For example, to update its
> firmware.
 
> This approach allows the kernel to remain ignorant of the various
> standards and avoids the need to constantly update the kernel to support
> new registers / commands. More importantly, it allows advanced
> functionality such as firmware update to be implemented once in user
> space and shared across all the drivers that support read and write
> access to module EEPROMs.

I fear we are opening the door for user space binary blob drivers,
which do much more than just firmware upgrade. You seems to say that
power control is part of the CMIS standard. So we don't need userspace
involved for that. We can implement a library which any MAC driver can
share.

I also wonder if it is safe to perform firmware upgrade from user
space? I've not looked at the code yet, but i assume you only allow
write when the interface is down? Otherwise isn't there a danger you
can brick the SFP if the MAC accesses it at the same time as when an
upgrade is happening?

Do you have other concrete use cases for write from user space?

In general, we don't allow uncontrolled access to hardware from user
space. We add specific, well documented API calls, and expect kernel
drivers to implement them. I don't see why SFPs should be
different. Standardised parts we can implement in common code. None
standard parts we need device/vendor specific code. Which just means
we need drivers following the usual linux conventions, some sort of
bus driver which reads the vendor/device ID from the EEPROM and probes
a driver for the specific SFP.

  Andrew



