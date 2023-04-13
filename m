Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09346E1719
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 00:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjDMWCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 18:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjDMWCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 18:02:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF30719D
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 15:02:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 471426135C
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 22:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFE1C4339B;
        Thu, 13 Apr 2023 22:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681423337;
        bh=fkxDv8uCGU3OLeKT8R8d8Cr6fxGIDLzjzzwXMy6EfI0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YQrHnlztL5tIvj/JBcglqIghDYfRx2AVILl0Bi0NPWgwoRfL0VwNYoFqDWVV+03++
         jWII/C5yw0PscNvRdSFXUcXSNPdPkokRkS68/NHQTVx4pXNzkWk97Wb7/36pYjSZcJ
         RPMTH356GYMTUwfr60fYtQg0VP1xKPzAcLcjhnUdm0M2njMF+dgw+o7He4cvV1NrVW
         uBy9m0UeRW0M5LJxj0CRxFLcJfqpEAdXFg0oG+KjmqicaT+KAd0WyDnErWb36TLsul
         51RrmFsbqMKvzI++yFQt8l11j4eJlZs2/SIJYfbSi6wURuznooC3evmYoNbKXdO6mL
         qTWVa/xwtlh/Q==
Date:   Thu, 13 Apr 2023 15:02:16 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        "alexander.sschmidt" <alexander.sschmidt@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        netdev@vger.kernel.org, rrameshbabu@nvidia.com, gal@nvidia.com,
        moshe@nvidia.com, shayd@nvidia.com
Subject: Re: Kernel crash after FLR reset of a ConnectX-5 PF in switchdev mode
Message-ID: <ZDh76MSj0hltzxwP@x130>
References: <90e1efad457f40c1f9f7b8cb56852072d8ea00fd.camel@linux.ibm.com>
 <20230413110228.GJ17993@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230413110228.GJ17993@unreal>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13 Apr 14:02, Leon Romanovsky wrote:
>On Tue, Apr 11, 2023 at 05:11:11PM +0200, Niklas Schnelle wrote:
>> Hi Saeed, Hi Leon,
>>
>> While testing PCI recovery with a ConnectX-5 card (MT28800, fw
>> 16.35.1012) and vanilla 6.3-rc4/5/6 on s390 I've run into a kernel
>> crash (stacktrace attached) when the card is in switchdev mode. No
>> crash occurs and the recovery succeeds in legacy mode (with VFs). I
>> found that the same crash occurs also with a simple Function Level
>> Reset instead of the s390 specific PCI recovery, see instructions
>> below. From the looks of it I think this could affect non-s390 too but
>> I don't have a proper x86 test system with a ConnectX card to test
>> with.
>>
>> Anyway, I tried to analyze further but got stuck after figuring out
>> that in mlx5e_remove() deep down from mlx5_fw_fatal_reporter_err_work()
>> (see trace) the mlx5e_dev->priv pointer is valid but the pointed to
>> struct only contains zeros as it was previously zeroed by
>> mlx5_mdev_uninit() which then leads to a NULL pointer access.
>>
>> The crash itself can be prevented by the following debug patch though
>> clearly this is not a proper fix:
>>
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> @@ -6012,6 +6012,10 @@ static void mlx5e_remove(struct auxiliary_device
>> *adev)
>>         struct mlx5e_priv *priv = mlx5e_dev->priv;
>>         pm_message_t state = {};
>>
>> +       if (!priv->mdev) {
>> +               pr_err("%s with zeroed mlx5e_dev->priv\n", __func__);
>> +               return;
>> +       }
>>         mlx5_core_uplink_netdev_set(priv->mdev, NULL);
>>         mlx5e_dcbnl_delete_app(priv);
>>         unregister_netdev(priv->netdev);
>>
>> With that I then tried to track down why mlx5_mdev_uninit() is called
>> and this might actually be s390 specific in that this happens during
>> the removal of the VF which on s390 causes extra hot unplug events for
>> the VFs (our virtualized PCI hotplug is per-PCI function) resulting in
>> the following call trace:
>>
>> ...
>> zpci_bus_remove_device()
>>    zpci_iov_remove_virtfn()
>>       pci_iov_remove_virtfn()
>>          pci_stop_and_remove_bus_device()
>>             pci_stop_bus_device()
>>                device_release_driver_internal()
>>                   pci_device_remove()
>>                      remove_one()
>>                         mlx5_mdev_uninit()
>>
>> Then again I would expect that on other architectures VFs become at
>> leastunresponsive during a FLR of the PF not sure if that also lead to
>> calls to remove_one() though.
>>
>> As another data point I tried the same on the default Ubuntu 22.04
>> generic 5.15 kernel and there no crash occurs so this might be a newer
>> issue.
>>
>> Also, I did test with and without the patch I sent recently for
>> skipping the wait in mlx5_health_wait_pci_up() but that made no
>> difference.
>>
>> Any hints on how to debug this further and could you try to see if this
>> occurs on other architectures as well?
>
>My guess that the splash, which complains about missing mutex_init(), is an outcome of these failures:
>[ 1375.771395] mlx5_core 0004:00:00.0 eth0 (unregistering): vport 1 error -67 reading stats
>[ 1376.151345] mlx5_core 0004:00:00.0: mlx5e_init_nic_tx:5376:(pid 1505): create tises failed, -67
>[ 1376.238808] mlx5_core 0004:00:00.0 ens8832f0np0: mlx5e_netdev_change_profile: new profile init failed, -67
>[ 1376.243746] mlx5_core 0004:00:00.0: mlx5e_init_rep_tx:1101:(pid 1505): create tises failed, -67
>[ 1376.328623] mlx5_core 0004:00:00.0 ens8832f0np0: mlx5e_netdev_change_profile: failed to rollback to orig profile,

Yes, I also agree with Leon, if rollback fails this could be fatal to mlx5e
aux device removal as we don't have a way to check the state of the mlx5e
priv, We always assume it is up as long as the aux is up, which is wrong
only in case of this un-expected error flow.

If we just add a flag and skip mlx5e_remove, then we will end up with
dangling netdev and some other resources as the cleanup wasn't complete..

I need to dive deeper to figure out a proper solution, I will create an internal
ticket to track this and help provide a solution soon, hopefully.

>
>-67 is -ENOLINK from mlx5_internal_err_ret_value().
>
>Thanks
