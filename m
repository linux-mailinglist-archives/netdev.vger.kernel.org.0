Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F57263B1B9
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 20:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiK1TAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 14:00:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiK1TAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 14:00:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68ABE24BF5
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 11:00:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01605613C5
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 19:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AF1C433D7;
        Mon, 28 Nov 2022 19:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669662008;
        bh=MJuMaWfuHqsDQ1pSCuRgBmvfdr+ZHwUfh6yhD9zD5uY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X8ii6oP2VlwwX0Zh+kAvjEN4NpTQyLquUnQyzUW/qniEYdj+MRBwH+m4amYueiAUS
         Wd7bZC/B60/mdAr0n+rmibN9CTKKuTDBlduHmVvGNmuQwQHT300tfwAR3QTB2d/dQU
         p1fE4dHzt76hNZvmJMxhJF720cgqyh+MAAGhFZtd8R2LOt1DZxPHyqKAEsp8FgDUkc
         xUdCpPzHK1seV9V6AK8O8YfakbYfe0pZGLfjOXSKdebbe5Uvyaa+9f6NF95eiXNppG
         fBfC9UZIKhq8CXXpMAr02u+zOrNHEVlNtw89OWnNZGMxzkdm6IfytPaPW7NdOG1aS/
         MxVppvVcRvZ4A==
Date:   Mon, 28 Nov 2022 11:00:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 5/9] devlink: refactor
 region_read_snapshot_fill to use a callback function
Message-ID: <20221128110007.0c362163@kernel.org>
In-Reply-To: <CO1PR11MB5089966656A01AF44BD6F17ED6139@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
        <20221123203834.738606-6-jacob.e.keller@intel.com>
        <Y381byfh6Oz6xKBD@nanopsycho>
        <CO1PR11MB5089966656A01AF44BD6F17ED6139@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Nov 2022 18:27:42 +0000 Keller, Jacob E wrote:
> > Hmm, I tried to figure out how to do this without extra alloc and
> > memcpy, didn't find any nice solution :/
> 
> I also came up blank as well :( I can take another look when sending v3 with the other fixups.

You can certainly rearrange things to nla_reserve() the space in the
message and pass to the driver a pointer to a buffer already in the
skb. But I don't think it's worth the code complexity.
