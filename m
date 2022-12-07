Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B16645157
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 02:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiLGBl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 20:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiLGBlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 20:41:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53EF52884
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 17:41:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A9D9B818C9
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 01:41:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA755C433C1;
        Wed,  7 Dec 2022 01:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670377297;
        bh=rQfATTT3pDmwwydHgHtdh3JFGbpeofwviTVOIOn5jIw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m4TYjBSFmHTgRDtw5+gAnt7E3GRzauziQbmGDl/V2nw5ApeYRibGcxYLCw/fuInju
         wq6zC3+s2SHszFnr1SRf7Vzu7qenGPW3z31Efmj40autk3j31YBeAGomwBv6KS/Mor
         P78QVwkM7oqtJs5Cm6LS5fcILJXf5fXBQss7JZ3A+qUu1yxhaicj+dLoUkVHyR1ygB
         bV89QZkFd8PobpUR6C69J74RQOqs+27hfwuWIOtyEmgl6xZSjsD3Sl4YEsOVnEaDv6
         FCJOMs2QzSrEGe8BRBNEqsiwBKPtOKmvzO8DqK696tOMgyYeQNMAEtikf4otQi+2r7
         Q0oTY7mu0KfMw==
Date:   Tue, 6 Dec 2022 17:41:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <jiri@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: add fw bank select parameter
Message-ID: <20221206174136.19af0e7e@kernel.org>
In-Reply-To: <20221205172627.44943-2-shannon.nelson@amd.com>
References: <20221205172627.44943-1-shannon.nelson@amd.com>
        <20221205172627.44943-2-shannon.nelson@amd.com>
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

On Mon, 5 Dec 2022 09:26:26 -0800 Shannon Nelson wrote:
> Some devices have multiple memory banks that can be used to
> hold various firmware versions that can be chosen for booting.
> This can be used in addition to or along with the FW_LOAD_POLICY
> parameter, depending on the capabilities of the particular
> device.
> 
> This is a parameter suggested by Jake in
> https://lore.kernel.org/netdev/CO1PR11MB508942BE965E63893DE9B86AD6129@CO1PR11MB5089.namprd11.prod.outlook.com/

Can we make this netlink attributes? 

What is the flow that you have in mind end to end (user actions)?
I think we should document that, by which I mean extend the pseudo 
code here:

https://docs.kernel.org/next/networking/devlink/devlink-flash.html#firmware-version-management

I expect we need to define the behavior such that the user can ignore
the banks by default and get the right behavior.

Let's define
 - current bank - the bank from which the currently running image has
   been loaded
 - active bank - the bank selected for next boot
 - next bank - current bank + 1 mod count

If we want to keep backward compat - if no bank specified for flashing:
 - we flash to "next bank"
 - if flashing is successful we switch "active bank" to "next bank"
not that multiple flashing operations without activation/reboot will
result in overwriting the same "next bank" preventing us from flashing
multiple banks without trying if they work..

"stored" versions in devlink info display the versions for "active bank"
while running display running (i.e. in RAM, not in the banks!)

In terms of modifications to the algo in documentation:
 - the check for "stored" versions check should be changed to an while
   loop that iterates over all banks
 - flashing can actually depend on the defaults as described above so
   no change

We can expose the "current" and "active" bank as netlink attrs in dev
info.
