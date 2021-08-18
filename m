Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156263F0E2F
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 00:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbhHRWdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 18:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234110AbhHRWdR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 18:33:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E5396101A;
        Wed, 18 Aug 2021 22:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629325962;
        bh=7LcMj6YYioQzorLIcQivKwwcxGsNDatozYb4yHSo5Yk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fTT+tDze6hA9ri9kDUUEBZ7Cg/P7X+oo0aXD0kfOPx0SLuH3+kcmQb88Zh0u21pAO
         E6+mlgrNRRs97zrBN0sP4vzN2Wu4lB8xDtS6ECeJflJOqYIpFeWIzuqcHB/Ue86I4D
         vUMFr4ul0vLt7Wi/wdSpszIamYoOwtaqp+cD5sNhOU9ajFTUg5XJ+pNtjC+3Ka/l5I
         7KKd6oSf4ExnC57ifIS8huhYFgudIHWjZCjlRcHZe5pn10L5HohsSrklqTDPVjuWmg
         jwt4jsjBjMDWPhQJg6Lue2lQZthuBELxnYPcPlE5eGciHaFINKtdDpZT6GlJL6fDbv
         9K/yljPe5iT7g==
Date:   Wed, 18 Aug 2021 15:32:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v2 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Message-ID: <20210818153241.7438e611@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210818155202.1278177-2-idosch@idosch.org>
References: <20210818155202.1278177-1-idosch@idosch.org>
        <20210818155202.1278177-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Aug 2021 18:51:57 +0300 Ido Schimmel wrote:
> +MODULE_SET
> +==========
> +
> +Sets transceiver module parameters.
> +
> +Request contents:
> +
> +  ======================================  ======  ==========================
> +  ``ETHTOOL_A_MODULE_HEADER``             nested  request header
> +  ``ETHTOOL_A_MODULE_POWER_MODE_POLICY``  u8      power mode policy
> +  ======================================  ======  ==========================
> +
> +When set, the optional ``ETHTOOL_A_MODULE_POWER_MODE_POLICY`` attribute is used
> +to set the transceiver module power policy enforced by the host. Possible
> +values are:
> +
> +.. kernel-doc:: include/uapi/linux/ethtool.h
> +    :identifiers: ethtool_module_power_mode_policy
> +
> +For SFF-8636 modules, low power mode is forced by the host according to table
> +6-10 in revision 2.10a of the specification.
> +
> +For CMIS modules, low power mode is forced by the host according to table 6-12
> +in revision 5.0 of the specification.
> +
> +To avoid changes to the operational state of the device, power mode policy can
> +only be set when the device is administratively down.

Would you mind explaining why?

> +/**
> + * enum ethtool_module_power_mode_policy - plug-in module power mode policy
> + * @ETHTOOL_MODULE_POWER_MODE_POLICY_LOW: Module is always in low power mode.

Did you have a use case for this one or is it for completeness? Seems
like user can just bring the port down if they want no carrier? My
understanding was you primarily wanted the latter two, and those can
be freely changed when netdev is running, right?

> + * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH: Module is always in high power mode.
> + * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH_ON_UP: Module is transitioned by the
> + *	host to high power mode when the first port using it is put
> + *	administratively up and to low power mode when the last port using it
> + *	is put administratively down.

s/HIGH_ON_UP/AUTO/ ?
high on up == low on down, right, seems arbitrary to pick one over the
other
