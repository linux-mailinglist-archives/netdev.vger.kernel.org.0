Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05C556AC9B
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 22:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbiGGURC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 16:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbiGGURA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 16:17:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36EA205E4
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 13:16:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EC8F62425
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 20:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96800C3411E;
        Thu,  7 Jul 2022 20:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657225018;
        bh=svFfBCqEXJBt8duPx2UI8bCgwqwyC99JhB0RkqkFknA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EWsgSCQoI2vpuzcl8I2suIXPZjUpmWfs0EBxjSRHcAyLb6TBo+TBPSx8T5ZIWGElS
         i6S9NSGL54T2BSl20/97uF9N34EAvzoHrrMK5zKIR6prbltS6E/+auDTxDa3hPtC8D
         AThs20nQjZRoT0bLD+ke+W3RkHusZu1VXK8NLz+HsUCmxb/yA4FnEzb/5o7oFWzGNi
         lh2G+8Q5pJH5o/RYG3v/Uq0g4uF8cvSq7qjJaXVEJFztGgyqfXrb0RFfugO1Q07IIY
         05fv7PLVFcxcqWPSweCX9uIrnAp4urENjADzI4ySuCdF8MV7B1xnbxNAmoEy5ZBKIb
         QdrmvitR0Q6pg==
Date:   Thu, 7 Jul 2022 13:16:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@nvidia.com>
Cc:     Dima Chumak <dchumak@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH net-next 0/5] devlink rate police limiter
Message-ID: <20220707131649.7302a997@kernel.org>
In-Reply-To: <YsbBbBt+DNvBIU2E@nanopsycho>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
        <20220620130426.00818cbf@kernel.org>
        <228ce203-b777-f21e-1f88-74447f2093ca@nvidia.com>
        <20220630111327.3a951e3b@kernel.org>
        <YsbBbBt+DNvBIU2E@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jul 2022 13:20:12 +0200 Jiri Pirko wrote:
> Wait. Lets draw the basic picture of "the wire":
> 
> --------------------------+                +--------------------------
> eswitch representor netdev|=====thewire====|function (vf/sf/whatever
> --------------------------+                +-------------------------
> 
> Now the rate setting Dima is talking about, it is the configuration of
> the "function" side. Setting the rate is limitting the "function" TX/RX
> Note that this function could be of any type - netdev, rdma, vdpa, nvme.

The patches add policing, are you saying we're gonna drop RDMA or NVMe
I/O?

> Configuring the TX/RX rate (including groupping) applies to all of
> these.

I don't understand why the "side of the wire" matters when the patches
target both Rx and Tx. Surely that covers both directions.

> Putting the configuration on the eswitch representor does not fit:
> 1) it is configuring the other side of the wire, the configuration
>    should be of the eswitch port. Configuring the other side is
>    confusing and misleading. For the purpose of configuring the
>    "function" side, we introduced "port function" object in devlink.
> 2) it is confuguring netdev/ethernet however the confuguration applies
>    to all queues of the function.

If you think it's technically superior to put it in devlink that's fine.
I'll repeat myself - what I'm asking for is convergence so that drivers
don't have  to implement 3 different ways of configuring this. We have
devlink rate for from-VF direction shaping, tc police for bi-dir
policing and obviously legacy NDOs. None of them translate between each
other so drivers and user space have to juggle interfaces.
