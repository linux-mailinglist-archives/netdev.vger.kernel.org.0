Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1A9206226
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404094AbgFWU4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:56:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:49306 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390647AbgFWU4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 16:56:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 52FF5AC46;
        Tue, 23 Jun 2020 20:56:07 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 59FD6602E3; Tue, 23 Jun 2020 22:56:07 +0200 (CEST)
Date:   Tue, 23 Jun 2020 22:56:07 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com, kuba@kernel.org, jiri@mellanox.com,
        jiri@resnulli.us
Subject: Re: [RFC net-next] devlink: Add reset subcommand.
Message-ID: <20200623205607.zgbkgczf64neea7h@lion.mk-sys.cz>
References: <1592911969-10611-1-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592911969-10611-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 05:02:49PM +0530, Vasundhara Volam wrote:
> Advanced NICs support live reset of some of the hardware
> components, that resets the device immediately with all the
> host drivers loaded.
> 
> Add devlink reset subcommand to support live and deferred modes
> of reset. It allows to reset the hardware components of the
> entire device and supports the following fields:
> 
> component:
> ----------
> 1. MGMT : Management processor.
> 2. IRA : Interrupt requester.
> 3. DMA : DMA engine.
> 4. FILTER : Filtering/flow direction.
> 5. OFFLOAD : Protocol offload.
> 6. MAC : Media access controller.
> 7. PHY : Transceiver/PHY.
> 8. RAM : RAM shared between multiple components.
> 9. ROCE : RoCE management processor.
> 10. AP : Application processor.
> 11. All : All possible components.
> 
> Drivers are allowed to reset only a subset of requested components.
> 
> width:
> ------
> 1. single - Single function.
> 2. multi  - Multiple functions.
> 
> mode:
> -----
> 1. deferred - Reset will happen after unloading all the host drivers
>               on the device. This is be default reset type, if user
>               does not specify the type.
> 2. live - Reset will happen immediately with all host drivers loaded
>           in real time. If the live reset is not supported, driver
>           will return the error.
> 
> This patch is a proposal in continuation to discussion to the
> following thread:
> 
> "[PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset' and 'allow_live_dev_reset' generic devlink params."
> 
> and here is the URL to the patch series:
> 
> https://patchwork.ozlabs.org/project/netdev/list/?series=180426&state=*
> 
> If the proposal looks good, I will re-send the whole patchset
> including devlink changes and driver usage.
> 
> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> Reviewed-by: Michael Chan <michael.chan@broadcom.com>

IIUC this is an extension (or rather replacement) of the ETHTOOL_RESET
ethtool subcommand. If this is the case, it would be probably better to
implement the driver backend only once and let ethtool_reset() use the
devlink handlers (future versions of ethtool utility could then use
devlink interface directly).

For this purpose, I would suggest to switch the flags for AP and ROCE in
enum devlink_reset_component:

> +enum devlink_reset_component {
> +	DEVLINK_RESET_COMP_MGMT		= (1 << 0),
> +	DEVLINK_RESET_COMP_IRQ		= (1 << 1),
> +	DEVLINK_RESET_COMP_DMA		= (1 << 2),
> +	DEVLINK_RESET_COMP_FILTER	= (1 << 3),
> +	DEVLINK_RESET_COMP_OFFLOAD	= (1 << 4),
> +	DEVLINK_RESET_COMP_MAC		= (1 << 5),
> +	DEVLINK_RESET_COMP_PHY		= (1 << 6),
> +	DEVLINK_RESET_COMP_RAM		= (1 << 7),
> +	DEVLINK_RESET_COMP_ROCE		= (1 << 8),
> +	DEVLINK_RESET_COMP_AP		= (1 << 9),
> +	DEVLINK_RESET_COMP_ALL		= 0xffffffff,
> +};

to make the flags match corresponding ETH_RESET_* flags.

Michal
