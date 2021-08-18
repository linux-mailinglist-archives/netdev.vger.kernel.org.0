Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F55A3F0E71
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 00:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbhHRW4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 18:56:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57460 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229478AbhHRW4W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 18:56:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6fgndGUwPDLOoHHMWBat09B116X4cJTIkzdn9KacSgk=; b=L/c7d5a5YCJHNI0YTq19osSBPG
        oUgfe/S3SvqgSaoYFMK/JFq4PfaInxuokDazLytAkRIUIrI8lw1P95QXlhNu37kuHnqjx6/w1MgAo
        hMunARwDx+KGrwQ+rZGL/fGUKsEW+r7ylvcbLX7ISmfK+UvJsRqe2Cgpv98Btk5nfiYM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mGUTH-000rpJ-RW; Thu, 19 Aug 2021 00:55:43 +0200
Date:   Thu, 19 Aug 2021 00:55:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, mkubecek@suse.cz, pali@kernel.org,
        jacob.e.keller@intel.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v2 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Message-ID: <YR2P7+1ZGiEBDtAq@lunn.ch>
References: <20210818155202.1278177-1-idosch@idosch.org>
 <20210818155202.1278177-2-idosch@idosch.org>
 <20210818153241.7438e611@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818153241.7438e611@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 03:32:41PM -0700, Jakub Kicinski wrote:
> On Wed, 18 Aug 2021 18:51:57 +0300 Ido Schimmel wrote:
> > +MODULE_SET
> > +==========
> > +
> > +Sets transceiver module parameters.
> > +
> > +Request contents:
> > +
> > +  ======================================  ======  ==========================
> > +  ``ETHTOOL_A_MODULE_HEADER``             nested  request header
> > +  ``ETHTOOL_A_MODULE_POWER_MODE_POLICY``  u8      power mode policy
> > +  ======================================  ======  ==========================
> > +
> > +When set, the optional ``ETHTOOL_A_MODULE_POWER_MODE_POLICY`` attribute is used
> > +to set the transceiver module power policy enforced by the host. Possible
> > +values are:
> > +
> > +.. kernel-doc:: include/uapi/linux/ethtool.h
> > +    :identifiers: ethtool_module_power_mode_policy
> > +
> > +For SFF-8636 modules, low power mode is forced by the host according to table
> > +6-10 in revision 2.10a of the specification.
> > +
> > +For CMIS modules, low power mode is forced by the host according to table 6-12
> > +in revision 5.0 of the specification.
> > +
> > +To avoid changes to the operational state of the device, power mode policy can
> > +only be set when the device is administratively down.
> 
> Would you mind explaining why?

Part of the issue is we have two different sorts of policy mixed
together.

ETHTOOL_MODULE_POWER_MODE_POLICY_LOW and
ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH change the state now. This could
be a surprise to a user when there link disappears for the
ETHTOOL_MODULE_POWER_MODE_POLICY_LOW case, when the interface is admin up.

ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP however follows the state
of the interface. So there should not be any surprises.

I actually think ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP should be
allowed at any time, just to make it easier to use.

> > +/**
> > + * enum ethtool_module_power_mode_policy - plug-in module power mode policy
> > + * @ETHTOOL_MODULE_POWER_MODE_POLICY_LOW: Module is always in low power mode.
> 
> Did you have a use case for this one or is it for completeness? Seems
> like user can just bring the port down if they want no carrier? My
> understanding was you primarily wanted the latter two, and those can
> be freely changed when netdev is running, right?
> 
> > + * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH: Module is always in high power mode.
> > + * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP: Module is transitioned by the
> > + *	host to high power mode when the first port using it is put
> > + *	administratively up and to low power mode when the last port using it
> > + *	is put administratively down.
> 
> s/HIGH_ON_UP/AUTO/ ?
> high on up == low on down, right, seems arbitrary to pick one over the
> other

Should we also document what the default is? Seems like
ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP is the generic network
interface default, so maybe it should also be the default for SFPs?

	  Andrew
