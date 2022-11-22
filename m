Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA82633AC0
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbiKVLHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbiKVLHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:07:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3631265D0
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 03:07:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6C226164D
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 11:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB80EC433C1;
        Tue, 22 Nov 2022 11:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669115252;
        bh=BgEji6npW8EgcnFGVHSvpi5jHa0Tr7lW2liTsOhGRqk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kcqMFwbBytsmoePnKicnK5MK6pNnHf6XWaICWPN4AF8ShrV+AGocQhBKgjEE31CIN
         oaL0FW4lTNgcyWzWWyJCw3grLZX/TmlAxfLs3gQUJjEu8NRx9a/YIfZyEKRJYfvoyz
         GiSIO9NFA2gzjQrMXTT6uSKFBwtXm1HTt5x3f+MGrMgVDYbkfNMf71Sb+lgKFlrR/x
         61KoYOKr5m+sAcFpoWsprKRLE5f/eRMoO0FTQbD4RJJKfMwsV9kwyQILXyDpbUSBTL
         diJtPBClGoCMBDpJ8avlhzDamadpg7id8FhgspvjCmC7s6v8IVaD4JAEdcWzTGhHTP
         WFm+csHNY+l3w==
Date:   Tue, 22 Nov 2022 13:07:28 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>
Cc:     tirtha@gmail.com, magnus.karlsson@intel.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        maciej.fijalkowski@intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH intel-next v4] i40e: allow toggling loopback mode via
 ndo_set_features callback
Message-ID: <Y3ytcGM2c52lzukO@unreal>
References: <20221118090306.48022-1-tirthendu.sarkar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118090306.48022-1-tirthendu.sarkar@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 02:33:06PM +0530, Tirthendu Sarkar wrote:
> Add support for NETIF_F_LOOPBACK. This feature can be set via:
> $ ethtool -K eth0 loopback <on|off>
> 
> This sets the MAC Tx->Rx loopback.
> 
> This feature is used for the xsk selftests, and might have other uses
> too.
> 
> Changelog:
>     v3 -> v4:
>     - Removed unused %_LEGACY macros as suggested by Alexandr Lobakin.
>     - Modified checks for interface bringup and i40e_set_loopback().
>     - Propagating up return value from i40_set_loopback().
> 
>     v2 -> v3:
>      - Fixed loopback macros as per NVM version 6.01+.
>      - Renamed existing macros as *_LEGACY.
>      - Based on NVM verison appropriate macro is used for MAC loopback.
> 
>     v1 -> v2:
>      - Moved loopback to netdev's hardware features as suggested by
>        Alexandr Lobakin.

Please put changelog after --- mark. It doesn't belong to the commit
message.

> 
> Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> ---
>  .../net/ethernet/intel/i40e/i40e_adminq_cmd.h |  8 ++++--
>  drivers/net/ethernet/intel/i40e/i40e_common.c | 26 +++++++++++++++++
>  drivers/net/ethernet/intel/i40e/i40e_main.c   | 28 ++++++++++++++++++-
>  .../net/ethernet/intel/i40e/i40e_prototype.h  |  3 ++
>  4 files changed, 61 insertions(+), 4 deletions(-)

<...>

>  /**
>   * i40e_set_features - set the netdev feature flags
>   * @netdev: ptr to the netdev being adjusted
> @@ -12960,6 +12983,9 @@ static int i40e_set_features(struct net_device *netdev,
>  	if (need_reset)
>  		i40e_do_reset(pf, I40E_PF_RESET_FLAG, true);
>  
> +	if ((features ^ netdev->features) & NETIF_F_LOOPBACK)
> +		return i40e_set_loopback(vsi, !!(features & NETIF_F_LOOPBACK));

Don't you need to disable loopback if NETIF_F_LOOPBACK was cleared?

> +
>  	return 0;
>  }
>  
> @@ -13722,7 +13748,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
>  	if (!(pf->flags & I40E_FLAG_MFP_ENABLED))
>  		hw_features |= NETIF_F_NTUPLE | NETIF_F_HW_TC;
>  
> -	netdev->hw_features |= hw_features;
> +	netdev->hw_features |= hw_features | NETIF_F_LOOPBACK;
>  

