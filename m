Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF576643DEA
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 08:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiLFH5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 02:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiLFH4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 02:56:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E5718352
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 23:56:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B69BAB81716
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 07:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89E8C433D6;
        Tue,  6 Dec 2022 07:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670313402;
        bh=5WDpyigyvzE/z9KtygVuNPN+PEnXzPkzlrdBsRM3SS4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CCMQVNzGTIzgI9ip8aqnc/FjyjYPYZtd3WpM6V9w6r3VSKQOD+zBChQS8y9/4irmK
         BN0DGPZhZvxyS7a3iTm7EayFt8ss9L6PsudfjadB9ww73g5OmjTk9ps+x6F8QRCP1n
         DECP2s8UGdjDjt5vvTUlmlb7EMWY++PEZ1qnxw8N8i6NyiWtHNcWWlOvr7r+iN/xqW
         j6LzIZkQWFxAnD8UcNavvJHULi4m9BCR8Xk3jTm0IRCDJa/cuGHLwtQOu8/XQeu0Xd
         wL2YHUqut0UFXNRJhlHU0opffBChaRaLuy8g+Jbb1WFbwfabEeLawAtLUtAGqcpBk5
         xLQrN+FAxEREQ==
Date:   Tue, 6 Dec 2022 09:56:38 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>, Shannon Nelson <shnelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        ioana.ciornei@nxp.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tchornyi@marvell.com, tariqt@nvidia.com, saeedm@nvidia.com,
        idosch@nvidia.com, petrm@nvidia.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        simon.horman@corigine.com, shannon.nelson@amd.com,
        brett.creeley@amd.com
Subject: Re: [patch net-next 1/8] devlink: call
 devlink_port_register/unregister() on registered instance
Message-ID: <Y471ttoWlBCVMFJf@unreal>
References: <20221205152257.454610-1-jiri@resnulli.us>
 <20221205152257.454610-2-jiri@resnulli.us>
 <5e97d5b5-3df4-c9b5-bca4-c82c75d353e8@amd.com>
 <Y47yMItMuOfCrwiO@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y47yMItMuOfCrwiO@nanopsycho>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 08:41:36AM +0100, Jiri Pirko wrote:
> Tue, Dec 06, 2022 at 12:55:32AM CET, shnelson@amd.com wrote:
> >On 12/5/22 7:22 AM, Jiri Pirko wrote:
> >> 
> >> From: Jiri Pirko <jiri@nvidia.com>
> >> 
> >> Change the drivers that use devlink_port_register/unregister() to call
> >> these functions only in case devlink is registered.
> >> 
> >> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> >> ---
> >> RFC->v1:
> >> - shortened patch subject
> >> ---
> >>   .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 29 ++++++++++---------
> >>   .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  7 +++--
> >>   .../ethernet/fungible/funeth/funeth_main.c    | 17 +++++++----
> >>   drivers/net/ethernet/intel/ice/ice_main.c     | 21 ++++++++------
> >>   .../ethernet/marvell/prestera/prestera_main.c |  6 ++--
> >>   drivers/net/ethernet/mscc/ocelot_vsc7514.c    | 10 +++----
> >>   .../ethernet/pensando/ionic/ionic_devlink.c   |  6 ++--
> >>   drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  7 +++--
> >>   8 files changed, 60 insertions(+), 43 deletions(-)
> >> 

<...>

> >I don't know about the rest of the drivers, but this seems to be the exact
> >opposite of what Leon did in this patch over a year ago:
> >https://lore.kernel.org/netdev/cover.1632565508.git.leonro@nvidia.com/
> 
> This patch did move for all objects, even for those where no issue
> existed. Ports are such.

Yeah, I was focused to move devlink_register() without any checks if
other devlink_* calls can be after it. The reason for that was desire
to make sure that we have devl_lock() on all netlink devlink calls.

Now, all commands are locked and we don't have commands which unlock
devlink internally and it is safe to move some devlink_* calls to be
after devlink_register() as long as they take devl_lock() and don't
mess with static devlink object data.

Thanks
