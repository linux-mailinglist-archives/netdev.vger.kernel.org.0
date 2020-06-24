Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F18207CF2
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 22:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgFXUbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 16:31:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:60330 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727981AbgFXUbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 16:31:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4F0ADACED;
        Wed, 24 Jun 2020 20:31:17 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 26A3A60346; Wed, 24 Jun 2020 22:31:17 +0200 (CEST)
Date:   Wed, 24 Jun 2020 22:31:17 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        amitc@mellanox.com, mlxsw@mellanox.com, jacob.e.keller@intel.com,
        andrew@lunn.ch, f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 04/10] Documentation: networking:
 ethtool-netlink: Add link extended state
Message-ID: <20200624203117.m5wnove437p775mb@lion.mk-sys.cz>
References: <20200624081923.89483-1-idosch@idosch.org>
 <20200624081923.89483-5-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624081923.89483-5-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 11:19:17AM +0300, Ido Schimmel wrote:
> From: Amit Cohen <amitc@mellanox.com>
> 
> Add link extended state attributes.
> 
> Signed-off-by: Amit Cohen <amitc@mellanox.com>
> Reviewed-by: Petr Machata <petrm@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  Documentation/networking/ethtool-netlink.rst | 110 ++++++++++++++++++-
>  1 file changed, 106 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index 82470c36c27a..a7cc53f905f5 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -443,10 +443,11 @@ supports.
>  LINKSTATE_GET
>  =============
>  
> -Requests link state information. At the moment, only link up/down flag (as
> -provided by ``ETHTOOL_GLINK`` ioctl command) is provided but some future
> -extensions are planned (e.g. link down reason). This request does not have any
> -attributes.
> +Requests link state information. Link up/down flag (as provided by
> +``ETHTOOL_GLINK`` ioctl command) is provided. Optionally, extended state might
> +be provided as well. In general, extended state describes reasons for why a port
> +is down, or why it operates in some non-obvious mode. This request does not have
> +any attributes.
>  
>  Request contents:
>  
> @@ -461,16 +462,117 @@ Kernel response contents:
>    ``ETHTOOL_A_LINKSTATE_LINK``          bool    link state (up/down)
>    ``ETHTOOL_A_LINKSTATE_SQI``           u32     Current Signal Quality Index
>    ``ETHTOOL_A_LINKSTATE_SQI_MAX``       u32     Max support SQI value
> +  ``ETHTOOL_A_LINKSTATE_EXT_STATE``     u8      link extended state
> +  ``ETHTOOL_A_LINKSTATE_EXT_SUBSTATE``  u8      link extended substate
>    ====================================  ======  ============================
>  
>  For most NIC drivers, the value of ``ETHTOOL_A_LINKSTATE_LINK`` returns
>  carrier flag provided by ``netif_carrier_ok()`` but there are drivers which
>  define their own handler.
>  
> +``ETHTOOL_A_LINKSTATE_EXT_STATE`` and ``ETHTOOL_A_LINKSTATE_EXT_SUBSTATE`` are
> +optional values. ethtool core can provide either both
> +``ETHTOOL_A_LINKSTATE_EXT_STATE`` and ``ETHTOOL_A_LINKSTATE_EXT_SUBSTATE``,
> +or only ``ETHTOOL_A_LINKSTATE_EXT_STATE``, or none of them.
> +
>  ``LINKSTATE_GET`` allows dump requests (kernel returns reply messages for all
>  devices supporting the request).
>  
>  
> +Link extended states:
> +
> +  ============================    =============================================
> +  ``Autoneg``                     States relating to the autonegotiation or
> +                                  issues therein
> +
> +  ``Link training failure``       Failure during link training
> +
> +  ``Link logical mismatch``       Logical mismatch in physical coding sublayer
> +                                  or forward error correction sublayer
> +
> +  ``Bad signal integrity``        Signal integrity issues
> +
> +  ``No cable``                    No cable connected
> +
> +  ``Cable issue``                 Failure is related to cable,
> +                                  e.g., unsupported cable
> +
> +  ``EEPROM issue``                Failure is related to EEPROM, e.g., failure
> +                                  during reading or parsing the data
> +
> +  ``Calibration failure``         Failure during calibration algorithm
> +
> +  ``Power budget exceeded``       The hardware is not able to provide the
> +                                  power required from cable or module
> +
> +  ``Overheat``                    The module is overheated
> +  ============================    =============================================

This file's primary purpose is to serve as kernel-userspace API
documentation so the table should IMHO show the ETHTOOL_LINK_EXT_STATE_*
constants. (And so should the substates tables below.)

Michal
