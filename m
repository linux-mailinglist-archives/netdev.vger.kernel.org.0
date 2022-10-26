Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25C760E56D
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 18:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbiJZQYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 12:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbiJZQYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 12:24:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4633A1F631
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 09:24:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C342161FB2
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 16:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493EAC433D6;
        Wed, 26 Oct 2022 16:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666801491;
        bh=sdMVHJ7YVzmlZFdgGUBqaHkQQ3i1Zkvt/syyOVJqNLs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B3zDHdYQU5LGZWkXKLRPfBH5Yqev1WITEWmIwcxJuFUJK7Mz2Xx2h6TevrrofOZHv
         daJjzkPae3KfOSqmu/H/9SnMsDgwhSecmHzLteyi1BKe2CTwQzeeOdTMhML19mHet8
         0SkL/Pmm6yVIVlt93J9Olfo2LTUwGwrVa3LxwfhpVsOKeNOOQCL1YWugefEEZ+YMpt
         QzOZg8442oNy3YB/73DWq7C2WouCMZbgQyDwj48QiDgZUV+LqQIiCDmuTlXNfysYLS
         ToELU9qBKOE63MhQFG2ZqxOmfw95wUGUZ3kNrX1HE0bXlriU6tr3mlNt+hAt/iifj3
         TQmY1gzRUxXxQ==
Date:   Wed, 26 Oct 2022 09:24:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shai Malin <smalin@nvidia.com>
Cc:     Aurelien Aptel <aaptel@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>
Subject: Re: [PATCH v7 01/23] net: Introduce direct data placement tcp
 offload
Message-ID: <20221026092449.5f839b36@kernel.org>
In-Reply-To: <DM6PR12MB3564FB23C582CEF338D11435BC309@DM6PR12MB3564.namprd12.prod.outlook.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
        <20221025135958.6242-2-aaptel@nvidia.com>
        <20221025153925.64b5b040@kernel.org>
        <DM6PR12MB3564FB23C582CEF338D11435BC309@DM6PR12MB3564.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Oct 2022 15:01:42 +0000 Shai Malin wrote:
> > > @@ -14,7 +14,7 @@ typedef u64 netdev_features_t;
> > >  enum {
> > >       NETIF_F_SG_BIT,                 /* Scatter/gather IO. */
> > >       NETIF_F_IP_CSUM_BIT,            /* Can checksum TCP/UDP over IPv4. */
> > > -     __UNUSED_NETIF_F_1,
> > > +     NETIF_F_HW_ULP_DDP_BIT,         /* ULP direct data placement offload */  
> > 
> > Why do you need a feature bit if there is a whole caps / limit querying
> > mechanism?  
> 
> The caps are used for the HW device to publish the supported 
> capabilities/limitation, while the feature bit is used for the DDP 
> enablement "per net-device".
> 
> Disabling will be required in case that another feature which is 
> mutually exclusive to the DDP is needed (as an example in the mlx case, 
> CQE compress which is controlled from ethtool).

It's a big enough feature to add a genetlink or at least a ethtool
command to control. If you add more L5 protos presumably you'll want
to control disable / enable separately for them. Also it'd be cleaner
to expose the full capabilities and report stats via a dedicated API.
Feature bits are not a good fix for complex control-pathy features.

> > It's somewhat unclear to me why we add ops to struct net_device,
> > rather than to ops.. can you explain?  
> 
> We were trying to follow the TLS design which is similar.

Ack, TLS should really move as well, IMHO, but that's a separate convo.

> Can you please clarify what do you mean by "rather than to ops.."?

Add the ulp_dpp_ops pointer to struct net_device_ops rather than struct
net_device.
