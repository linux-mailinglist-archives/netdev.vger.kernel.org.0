Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3A562406B
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 11:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbiKJKx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 05:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiKJKxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 05:53:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A950663EB;
        Thu, 10 Nov 2022 02:53:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E94EB61163;
        Thu, 10 Nov 2022 10:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACC9C433D6;
        Thu, 10 Nov 2022 10:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668077633;
        bh=80un1UQl9SnCr4a2NiWX+f4Tujo0o139HD42RGnQZm4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=In2Imx46CBLp/Sb1jXlXJhAmXkSfE4mOq8qJJTB3A2Vn3K8U32nEtDsNuQAT0DsD6
         ZmAyUztomPFK6hifxNeuX6xcINVmdq5XyeEDyCUcqVVesw5D1BDbuIjG9jrY8Yx01+
         kBiVVhzMYmxolpcvAwKW9k2YwHA4/V1aISUadymsUHWt1l6YJog9yNBQmlNpyPl0so
         74m+zyV9+s3fvvcKIXIWvsVZ2wy0C+k/YCwNbcv4diN3foA/t+GP50kUCs8Sqrdm7c
         QlUTn8OH1dsXv+QC26Gad0TYsn8obPV8XxbmxdQF8O58KNmA1+SU7yYNJImlGL1KMo
         29TRFO+dtrycA==
Date:   Thu, 10 Nov 2022 12:53:48 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com
Subject: Re: [PATCH v4 0/6] Add Auxiliary driver support
Message-ID: <Y2zYPOUKgoArq7mM@unreal>
References: <20221109184244.7032-1-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109184244.7032-1-ajit.khaparde@broadcom.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 10:42:38AM -0800, Ajit Khaparde wrote:
> Add auxiliary device driver for Broadcom devices.
> The bnxt_en driver will register and initialize an aux device
> if RDMA is enabled in the underlying device.
> The bnxt_re driver will then probe and initialize the
> RoCE interfaces with the infiniband stack.
> 
> We got rid of the bnxt_en_ops which the bnxt_re driver used to
> communicate with bnxt_en.
> Similarly  We have tried to clean up most of the bnxt_ulp_ops.
> In most of the cases we used the functions and entry points provided
> by the auxiliary bus driver framework.
> And now these are the minimal functions needed to support the functionality.
> 
> We will try to work on getting rid of the remaining if we find any
> other viable option in future.

I still see extra checks for something that was already checked in upper
functions, for example in bnxt_re_register_netdev() you check rdev, which
you already checked before.

However, the most important part is still existence of bnxt_ulp_ops,
which shows completely no-go thing - SR-IOV config in RDMA code.

   302 static struct bnxt_ulp_ops bnxt_re_ulp_ops = {
   303         .ulp_sriov_config = bnxt_re_sriov_config,
   304         .ulp_irq_stop = bnxt_re_stop_irq,
   305         .ulp_irq_restart = bnxt_re_start_irq
   306 };

All PCI management logic and interfaces are needed to be inside eth part
of your driver and only that part should implement SR-IOV config. Once
user enabled SR-IOV, the PCI driver should create auxiliary devices for
each VF. These device will have RDMA capabilities and it will trigger RDMA
driver to bind to them.

Thanks
