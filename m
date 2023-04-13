Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C006E0BFE
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 13:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjDMLCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 07:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjDMLCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 07:02:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D24C270D
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 04:02:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 176CB63D90
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 11:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F353AC433EF;
        Thu, 13 Apr 2023 11:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681383752;
        bh=zHZeY9MBFstoey01DGFfpeYxgl+CEVbgfYTuew27hCU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cWHSK1G6OFfmf0aSj2MG0vwBW2nmedxZFfTs7yMUTN4lq5xbWMZnnmzYTMRkHCiiT
         mQ08enZ1reY0i+3ygNdkz0QL1DF6s/8ZmRuxOCkwG013wXuwlCmgC0G++sNb6E8Lux
         qHM3gji2Du/729UFD1T6Vw0MuG5n2aE79UllzaZW0QeI1ytgnGWLTphEGlXuE8l3bS
         GeTQxJDWDvJyakefl8djhlhqskrYfwGUcNjSTDvFVZUt//l25SEwbuh2duOa/axrmq
         Rv1OWPBaUnHFnzbUi5lPKRt9pwzTydnkz2tw/1zvfCLjEFUtsz54nOVs3vcYivNAaq
         EUOJ9ZydZATQQ==
Date:   Thu, 13 Apr 2023 14:02:28 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        "alexander.sschmidt" <alexander.sschmidt@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        netdev@vger.kernel.org, rrameshbabu@nvidia.com, gal@nvidia.com,
        moshe@nvidia.com, shayd@nvidia.com
Subject: Re: Kernel crash after FLR reset of a ConnectX-5 PF in switchdev mode
Message-ID: <20230413110228.GJ17993@unreal>
References: <90e1efad457f40c1f9f7b8cb56852072d8ea00fd.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90e1efad457f40c1f9f7b8cb56852072d8ea00fd.camel@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 05:11:11PM +0200, Niklas Schnelle wrote:
> Hi Saeed, Hi Leon,
> 
> While testing PCI recovery with a ConnectX-5 card (MT28800, fw
> 16.35.1012) and vanilla 6.3-rc4/5/6 on s390 I've run into a kernel
> crash (stacktrace attached) when the card is in switchdev mode. No
> crash occurs and the recovery succeeds in legacy mode (with VFs). I
> found that the same crash occurs also with a simple Function Level
> Reset instead of the s390 specific PCI recovery, see instructions
> below. From the looks of it I think this could affect non-s390 too but
> I don't have a proper x86 test system with a ConnectX card to test
> with.
> 
> Anyway, I tried to analyze further but got stuck after figuring out
> that in mlx5e_remove() deep down from mlx5_fw_fatal_reporter_err_work()
> (see trace) the mlx5e_dev->priv pointer is valid but the pointed to
> struct only contains zeros as it was previously zeroed by
> mlx5_mdev_uninit() which then leads to a NULL pointer access.
> 
> The crash itself can be prevented by the following debug patch though
> clearly this is not a proper fix:
> 
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -6012,6 +6012,10 @@ static void mlx5e_remove(struct auxiliary_device
> *adev)
>         struct mlx5e_priv *priv = mlx5e_dev->priv;
>         pm_message_t state = {};
> 
> +       if (!priv->mdev) {
> +               pr_err("%s with zeroed mlx5e_dev->priv\n", __func__);
> +               return;
> +       }
>         mlx5_core_uplink_netdev_set(priv->mdev, NULL);
>         mlx5e_dcbnl_delete_app(priv);
>         unregister_netdev(priv->netdev);
> 
> With that I then tried to track down why mlx5_mdev_uninit() is called
> and this might actually be s390 specific in that this happens during
> the removal of the VF which on s390 causes extra hot unplug events for
> the VFs (our virtualized PCI hotplug is per-PCI function) resulting in
> the following call trace:
> 
> ...
> zpci_bus_remove_device()
>    zpci_iov_remove_virtfn()
>       pci_iov_remove_virtfn()
>          pci_stop_and_remove_bus_device()
>             pci_stop_bus_device()
>                device_release_driver_internal()
>                   pci_device_remove()
>                      remove_one()
>                         mlx5_mdev_uninit()
> 
> Then again I would expect that on other architectures VFs become at
> leastunresponsive during a FLR of the PF not sure if that also lead to
> calls to remove_one() though.
> 
> As another data point I tried the same on the default Ubuntu 22.04
> generic 5.15 kernel and there no crash occurs so this might be a newer
> issue.
> 
> Also, I did test with and without the patch I sent recently for
> skipping the wait in mlx5_health_wait_pci_up() but that made no
> difference.
> 
> Any hints on how to debug this further and could you try to see if this
> occurs on other architectures as well?

My guess that the splash, which complains about missing mutex_init(), is an outcome of these failures:
[ 1375.771395] mlx5_core 0004:00:00.0 eth0 (unregistering): vport 1 error -67 reading stats
[ 1376.151345] mlx5_core 0004:00:00.0: mlx5e_init_nic_tx:5376:(pid 1505): create tises failed, -67
[ 1376.238808] mlx5_core 0004:00:00.0 ens8832f0np0: mlx5e_netdev_change_profile: new profile init failed, -67
[ 1376.243746] mlx5_core 0004:00:00.0: mlx5e_init_rep_tx:1101:(pid 1505): create tises failed, -67
[ 1376.328623] mlx5_core 0004:00:00.0 ens8832f0np0: mlx5e_netdev_change_profile: failed to rollback to orig profile,

-67 is -ENOLINK from mlx5_internal_err_ret_value().

Thanks
