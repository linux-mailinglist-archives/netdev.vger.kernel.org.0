Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8990D64FE33
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 10:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiLRJxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 04:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiLRJxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 04:53:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793FABDF;
        Sun, 18 Dec 2022 01:53:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24CB5B80A49;
        Sun, 18 Dec 2022 09:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4E6C433EF;
        Sun, 18 Dec 2022 09:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671357208;
        bh=RuYdwQB4ZI3x6re4FTlh0ngNIRbofnQu9Y6HdzOfg/g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XwlP15RdOfhkmn8EmvJKQVjdxzqrBoJ6mA6Po1gX72xDCmUc4VKQDnouTl48gQ5Ea
         YITjhSRBTdv2ivDtkauv4APqm/lwDzb+UR1NTQfwIL0+OAt/mu2dvX4m+jHRbyIqzm
         3NCHiqjatJNIPJN317/dsyU6wVQZQBfvpLsJii4+AAwkeYWP0RKsGSADz6h7m1r7pb
         Oo9RLX6EacXjhSMzS/rmTfahIb2DsOnQPME9awLTGEtHI1SXN6+XfhNrGMiHUEPdRM
         bzH8kr5s/6H5XLHyim6Ya5OefAWwBqgptNUA34/G/HJJ7xqdnzl9ul0t3NtwGTkJ0o
         SK3/mkLZVoRlQ==
Date:   Sun, 18 Dec 2022 11:53:23 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Petr Pavlu <petr.pavlu@suse.com>
Cc:     tariqt@nvidia.com, yishaih@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Part of devices not initialized with mlx4
Message-ID: <Y57jE03Rmr7wphlj@unreal>
References: <0a361ac2-c6bd-2b18-4841-b1b991f0635e@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a361ac2-c6bd-2b18-4841-b1b991f0635e@suse.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 10:51:15AM +0100, Petr Pavlu wrote:
> Hello,
> 
> We have seen an issue when some of ConnectX-3 devices are not initialized
> when mlx4 drivers are a part of initrd.

<...>

> * Systemd stops running services and then sends SIGTERM to "unmanaged" tasks
>   on the system to terminate them too. This includes the modprobe task.
> * Initialization of mlx4_en is interrupted in the middle of its init function.

And why do you think that this systemd behaviour is correct one?

>   The module remains inserted but only some eth devices are initialized and
>   operational.

<...>

> One idea how to address this issue is to model the mlx4 drivers using an
> auxiliary bus, similar to how the same conversion was already done in mlx5.
> This leaves all module loads to udevd which better integrates with the systemd
> processing and a load of mlx4_en doesn't get interrupted.
> 
> My incomplete patches implementing this idea are available at:
> https://github.com/petrpavlu/linux/commits/bsc1187236-wip-v1
> 
> The rework turned out to be not exactly straightforward and would need more
> effort.

Right, I didn't see any ROI of converting mlx4 to aux bus.

> 
> I realize mlx4 is only used for ConnectX-3 and older hardware. I wonder then
> if this kind of rework would be suitable and something to proceed with, or if
> some simpler idea how to address the described issue would be better and
> preferread.

Will it help if you move mlx4_en to rootfs?

Thanks

> 
> Thank you,
> Petr
> 
