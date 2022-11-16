Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8264862C1E0
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 16:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbiKPPI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 10:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiKPPIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 10:08:21 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D8149B60;
        Wed, 16 Nov 2022 07:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Bkf7J5SqtYP5TrkKMJu0ChRTpG1efo8rA+SBT3dpslY=; b=ckZ+5LgILd7SJauDEX8D9WSniU
        vV7XA+63iywuvGDYY6fw+NcUMh72A36Cbke5bQ/WqmYT3eETkEadHmF0soQ5dYw9OG/6UK5btZbyi
        phgDd4KPB20KW3ALmtRVboByLAqqvmd4CiNsP4PwinIkKckxR/3f1PYXhbgimCtC6+NA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ovK0w-002Zu1-Eh; Wed, 16 Nov 2022 16:07:46 +0100
Date:   Wed, 16 Nov 2022 16:07:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xiaolei Wang <xiaolei.wang@windriver.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: fec: Create device link between phy dev and mac
 dev
Message-ID: <Y3T8wliAKdl/paS6@lunn.ch>
References: <20221116144305.2317573-1-xiaolei.wang@windriver.com>
 <20221116144305.2317573-3-xiaolei.wang@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116144305.2317573-3-xiaolei.wang@windriver.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 10:43:05PM +0800, Xiaolei Wang wrote:
> On imx6sx, there are two fec interfaces, but the external
> phys can only be configured by fec0 mii_bus. That means
> the fec1 can't work independently, it only work when the
> fec0 is active. It is alright in the normal boot since the
> fec0 will be probed first. But then the fec0 maybe moved
> behind of fec1 in the dpm_list due to various device link.
> So in system suspend and resume, we would get the following
> warning when configuring the external phy of fec1 via the
> fec0 mii_bus due to the inactive of fec0. In order to fix
> this issue, we create a device link between phy dev and fec0.
> This will make sure that fec0 is always active when fec1
> is in active mode.
> 
>   WARNING: CPU: 0 PID: 24 at drivers/net/phy/phy.c:983 phy_error+0x20/0x68
>   Modules linked in:
>   CPU: 0 PID: 24 Comm: kworker/0:2 Not tainted 6.1.0-rc3-00011-g5aaef24b5c6d-dirty #34
>   Hardware name: Freescale i.MX6 SoloX (Device Tree)
>   Workqueue: events_power_efficient phy_state_machine
>   unwind_backtrace from show_stack+0x10/0x14
>   show_stack from dump_stack_lvl+0x68/0x90
>   dump_stack_lvl from __warn+0xb4/0x24c
>   __warn from warn_slowpath_fmt+0x5c/0xd8
>   warn_slowpath_fmt from phy_error+0x20/0x68
>   phy_error from phy_state_machine+0x22c/0x23c
>   phy_state_machine from process_one_work+0x288/0x744
>   process_one_work from worker_thread+0x3c/0x500
>   worker_thread from kthread+0xf0/0x114
>   kthread from ret_from_fork+0x14/0x28
>   Exception stack(0xf0951fb0 to 0xf0951ff8)

Please add an explanation why you only do this for the FEC? Is this
not a problem for any board which has the PHY on an MDIO bus not
direct child of the MAC?

       Andrew
