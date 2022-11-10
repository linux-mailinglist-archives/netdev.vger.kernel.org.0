Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD963623EBB
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 10:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiKJJg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 04:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKJJgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 04:36:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F5366CA6
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 01:36:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96FB660C26
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E14C433C1;
        Thu, 10 Nov 2022 09:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668073014;
        bh=RZqc4mTiOP4vHCoLOzhs8cd5CUewb+ZTdoCBF3l9m3o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oqRTx2dBtIzO5DVM2Ix3kjuQyy9CauAeJJv00fp7rVe6lFW7S6Hobd39Wm11PxzIX
         Pk52qGyEUe0sQz8RWIQyU67EG/Iouz1fCNGuY8l21itesAc/6PNK+ib7MBTirpTVaE
         lZHdVPLSwIjqMzVmazEDJ611U8Tlw82He7/RLfd/RrFr3j4YRAhe5KazM17pbwOHPR
         t2cJhGdYceg3G+NhM3qI5Qa6V3F0CdWjZkQbdKxkZ3Di8BiM2Ohi5bc9t492HKVFTF
         ZudO++ahmnlSUsvQzjRNHkhdjAey2EvszFi1gA4+beYUXyIH5k38vr4OxzZ+gWJ/Gw
         3HONbRNkbqXVw==
Date:   Thu, 10 Nov 2022 11:36:48 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Jonathan Lemon <bsd@meta.com>,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next v2] genetlink: fix single op policy dump when do
 is present
Message-ID: <Y2zGMIaDv3UkmESQ@unreal>
References: <20221109183254.554051-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109183254.554051-1-kuba@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 10:32:54AM -0800, Jakub Kicinski wrote:
> Jonathan reports crashes when running net-next in Meta's fleet.
> Stats collection uses ethtool -I which does a per-op policy dump
> to check if stats are supported. We don't initialize the dumpit
> information if doit succeeds due to evaluation short-circuiting.
> 
> The crash may look like this:
> 
>    BUG: kernel NULL pointer dereference, address: 0000000000000cc0
>    RIP: 0010:netlink_policy_dump_add_policy+0x174/0x2a0
>      ctrl_dumppolicy_start+0x19f/0x2f0
>      genl_start+0xe7/0x140
> 
> Or we may trigger a warning:
> 
>    WARNING: CPU: 1 PID: 785 at net/netlink/policy.c:87 netlink_policy_dump_get_policy_idx+0x79/0x80
>    RIP: 0010:netlink_policy_dump_get_policy_idx+0x79/0x80
>      ctrl_dumppolicy_put_op+0x214/0x360
> 
> depending on what garbage we pick up from the stack.
> 
> Reported-by: Jonathan Lemon <bsd@meta.com>
> Fixes: 26588edbef60 ("genetlink: support split policies in ctrl_dumppolicy_put_op()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: jacob.e.keller@intel.com
> CC: leon@kernel.org
> 
> v2:
>  - add a helper instead of doing magic sums
>  - improve title
> v1: https://lore.kernel.org/all/20221108204041.330172-1-kuba@kernel.org/
> ---
>  net/netlink/genetlink.c | 30 +++++++++++++++++++++---------
>  1 file changed, 21 insertions(+), 9 deletions(-)
> 

Thanks,
Tested-by: Leon Romanovsky <leonro@nvidia.com>
