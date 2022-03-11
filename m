Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4434D599F
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 05:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345073AbiCKEfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 23:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239849AbiCKEfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 23:35:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39749C1155
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 20:34:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3758B81FE1
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 04:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3268BC340EC;
        Fri, 11 Mar 2022 04:34:12 +0000 (UTC)
Date:   Fri, 11 Mar 2022 06:34:09 +0200
From:   Leon Romanovsky <leon@ikernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sudheer.mogilappagari@intel.com, sridhar.samudrala@intel.com,
        amritha.nambiar@intel.com, jiri@nvidia.com
Subject: Re: [PATCH net-next 0/2][pull request] 10GbE Intel Wired LAN Driver
 Updates 2022-03-10
Message-ID: <YirRQWT7dtTV4fwG@unreal>
References: <20220310231235.2721368-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310231235.2721368-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 03:12:33PM -0800, Tony Nguyen wrote:
> Sudheer Mogilappagari says:
> 
> Add support to enable inline flow director which allows uniform
> distribution of flows among queues of a TC. This is configured
> on a per TC basis using devlink interface.
> 
> Devlink params are registered/unregistered during TC creation
> at runtime. To allow that commit 7a690ad499e7 ("devlink: Clean
> not-executed param notifications") needs to be reverted.
> 
> The following are changes since commit 3126b731ceb168b3a780427873c417f2abdd5527:
>   net: dsa: tag_rtl8_4: fix typo in modalias name
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE
> 
> Kiran Patil (1):
>   ice: Add inline flow director support for channels
> 
> Sridhar Samudrala (1):
>   devlink: Allow parameter registration/unregistration during runtime

Sorry, NO to whole series.

I don't see any explanation why it is good idea and must-to-be
implemented one to configure global TC parameter during runtime.

You created TC with special tool, you should use that tool to configure
TC and not devlink. Devlink parameters can be seen as better replacement
of module parameters, which are global by nature. It means that this
tc_inline_fd can be configured without relation if TC was created or
not.

I didn't look too deeply in revert patch, but from glance view it
is not correct too as it doesn't have any protection from users
who will try to configure params during devlink_params_unregister().

Thanks

> 
>  drivers/net/ethernet/intel/ice/ice.h          |  83 +++++
>  .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  12 +
>  drivers/net/ethernet/intel/ice/ice_devlink.c  | 130 ++++++++
>  drivers/net/ethernet/intel/ice/ice_devlink.h  |   2 +
>  drivers/net/ethernet/intel/ice/ice_ethtool.c  |   1 +
>  drivers/net/ethernet/intel/ice/ice_fdir.c     |  25 +-
>  drivers/net/ethernet/intel/ice/ice_fdir.h     |   5 +
>  .../net/ethernet/intel/ice/ice_hw_autogen.h   |   1 +
>  .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |   3 +
>  drivers/net/ethernet/intel/ice/ice_main.c     | 173 ++++++++++-
>  drivers/net/ethernet/intel/ice/ice_txrx.c     | 294 ++++++++++++++++++
>  drivers/net/ethernet/intel/ice/ice_txrx.h     |   8 +-
>  drivers/net/ethernet/intel/ice/ice_type.h     |   1 +
>  net/core/devlink.c                            |  14 +-
>  14 files changed, 734 insertions(+), 18 deletions(-)
> 
> -- 
> 2.31.1
> 
