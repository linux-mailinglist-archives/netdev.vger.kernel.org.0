Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D5F207C02
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 21:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404900AbgFXTHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 15:07:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:21430 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404520AbgFXTHw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 15:07:52 -0400
IronPort-SDR: tWN3fy2AgTZQ0vqzf5084YAF5AWFIhcxXKTk60gZ1pZBJkfSJU6PajbbXH7QqqIqVOtaoUGuj0
 2qASp9mAqSrg==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="143707071"
X-IronPort-AV: E=Sophos;i="5.75,276,1589266800"; 
   d="scan'208";a="143707071"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 12:07:36 -0700
IronPort-SDR: rpDJfOw9C+8upJLedo5ntu7ntsfLHg6zrqUtcCM4WMfA1pElWKLrbsiXNaFfUYSMAVbt7tW7oL
 mbltiFiXJ3TQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,276,1589266800"; 
   d="scan'208";a="265152737"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.184.213]) ([10.209.184.213])
  by fmsmga008.fm.intel.com with ESMTP; 24 Jun 2020 12:07:35 -0700
Subject: Re: [PATCH net-next 04/10] Documentation: networking:
 ethtool-netlink: Add link extended state
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@rempel-privat.de, Ido Schimmel <idosch@mellanox.com>
References: <20200624081923.89483-1-idosch@idosch.org>
 <20200624081923.89483-5-idosch@idosch.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <b8aca89b-02f1-047c-a582-dacebfb8e480@intel.com>
Date:   Wed, 24 Jun 2020 12:07:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200624081923.89483-5-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/2020 1:19 AM, Ido Schimmel wrote:
> From: Amit Cohen <amitc@mellanox.com>
> 
> Add link extended state attributes.
> 
> Signed-off-by: Amit Cohen <amitc@mellanox.com>
> Reviewed-by: Petr Machata <petrm@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

I really like this concept.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

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

Ok, so basically in addition to the standard ETHTOOL_GLINK data, we also
add additional optional extended attributes over the netlink interface.
Neat.

>  Request contents:
>  
> @@ -461,16 +462,117 @@ Kernel response contents:
>    ``ETHTOOL_A_LINKSTATE_LINK``          bool    link state (up/down)
>    ``ETHTOOL_A_LINKSTATE_SQI``           u32     Current Signal Quality Index
>    ``ETHTOOL_A_LINKSTATE_SQI_MAX``       u32     Max support SQI value
> +  ``ETHTOOL_A_LINKSTATE_EXT_STATE``     u8      link extended state
> +  ``ETHTOOL_A_LINKSTATE_EXT_SUBSTATE``  u8      link extended substate
>    ====================================  ======  ============================

Ok so we have categories (state) and each category can have sub-states
indicating the specific failure. Good.

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

Good to clarify that it is allowed to specify only the main state, if a
substate isn't known.

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

A nice variety of states. I think it could be argued that "no cable" is
a sub-state of "cable issues" but personally I like that it's separate.

I can't think of any other states offhand, but we have a u8, so we have
plenty of space to add more states if/when we think of them in the future.

> +
> +Link extended substates:
> +
> +  Autoneg substates:
> +
> +  ==============================================    =============================================
> +  ``No partner detected``                           Peer side is down
> +
> +  ``Ack not received``                              Ack not received from peer side
> +
> +  ``Next page exchange failed``                     Next page exchange failed
> +
> +  ``No partner detected during force mode``         Peer side is down during force mode or there
> +                                                    is no agreement of speed
> +

This feels like it could be two separate states. It seems weird to
combine "peer side is down during force" with "no agreement of speed".
Am I missing something here?

> +  ``FEC mismatch during override``                  Forward error correction modes in both sides
> +                                                    are mismatched
> +
> +  ``No HCD``                                        No Highest Common Denominator
> +  ==============================================    =============================================
> +
> +  Link training substates:
> +
> +  ==============================================    =============================================
> +  ``KR frame lock not acquired``                    Frames were not recognized, the lock failed
> +
> +  ``KR link inhibit timeout``                       The lock did not occur before timeout
> +
> +  ``KR Link partner did not set receiver ready``    Peer side did not send ready signal after
> +                                                    training process
> +
> +  ``Remote side is not ready yet``                  Remote side is not ready yet
> +
> +  ==============================================    =============================================
> +
> +  Link logical mismatch substates:
> +
> +  ==============================================    =============================================
> +  ``PCS did not acquire block lock``                Physical coding sublayer was not locked in
> +                                                    first phase - block lock
> +
> +  ``PCS did not acquire AM lock``                   Physical coding sublayer was not locked in
> +                                                    second phase - alignment markers lock
> +
> +  ``PCS did not get align_status``                  Physical coding sublayer did not get align
> +                                                    status
> +
> +  ``FC FEC is not locked``                          FC forward error correction is not locked
> +
> +  ``RS FEC is not locked``                          RS forward error correction is not locked
> +  ==============================================    =============================================
> +
> +  Bad signal integrity substates:
> +
> +  ==============================================    =============================================
> +  ``Large number of physical errors``               Large number of physical errors
> +
> +  ``Unsupported rate``                              The system attempted to operate the cable at
> +                                                    a rate that is not formally supported, which
> +                                                    led to signal integrity issues
> +
> +  ``Unsupported cable``                             Unsupported cable
> +
> +  ``Cable test failure``                            Cable test failure
> +  ==============================================    =============================================
> +

Not every state has substates. Makes sense, since some of the main
states are pretty straight forward.

This feels very promising, and enables providing some useful information
to users about why something isn't working as expected. I think it's a
significant improvement to the status quo, given that a device can
report this data.

Thanks,
Jake

>  DEBUG_GET
>  =========
>  
> 
