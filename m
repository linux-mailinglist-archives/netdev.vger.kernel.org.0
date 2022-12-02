Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0FA8640CCE
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbiLBSF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbiLBSFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:05:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C458E8E590
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 10:05:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AED862389
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 18:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C60EC433D6;
        Fri,  2 Dec 2022 18:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670004323;
        bh=8K/Rfjv0BmIiCvXeLMYXOmZ3f0y9XGipUOzuaXNvHrg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ijHHF40LOnoTR25/m0DUEf77sl0VY0xePBBZjjTxJKYnYMX4dIMhGhU3gXOq525Eo
         unr7t0K2k6ygr6Q9Ab6A+hbLnUeM8P2w/nQsCyUbttpXgzeVyhotNGCppdGAQgr3rq
         7D2vIZQG8P3MW1tcJUGv5gfdDnSUjGsS/4AUdzX9JfwjGjzIamZs4OeX4johpc1uCO
         rlizsnc4W0p6CjKvltvNNTuI5n+zBlhjp6EemGNoWDOfwN/j9bPNG+PyjFpwdZXxji
         xMyZRAmdJxfqgRgh4hAempHlIbeouFQBu3W+cRwpoQ/ghiCKTRhToE9nfPwfb2F3Iv
         7NiJ+Ts8FnWfA==
Date:   Fri, 2 Dec 2022 20:05:19 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH xfrm-next v9 0/8] Extend XFRM core to allow packet
 offload configuration
Message-ID: <Y4o+X0bOz0hHh9bL@unreal>
References: <cover.1669547603.git.leonro@nvidia.com>
 <20221202094243.GA704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202094243.GA704954@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 10:42:43AM +0100, Steffen Klassert wrote:
> On Sun, Nov 27, 2022 at 01:18:10PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Changelog:
> > v9:
> >  * Added acquire support
> > v8: https://lore.kernel.org/all/cover.1668753030.git.leonro@nvidia.com
> >  * Removed not-related blank line
> >  * Fixed typos in documentation
> > v7: https://lore.kernel.org/all/cover.1667997522.git.leonro@nvidia.com
> > As was discussed in IPsec workshop:
> >  * Renamed "full offload" to be "packet offload".
> >  * Added check that offloaded SA and policy have same device while sending packet
> >  * Added to SAD same optimization as was done for SPD to speed-up lookups.
> > v6: https://lore.kernel.org/all/cover.1666692948.git.leonro@nvidia.com
> >  * Fixed misplaced "!" in sixth patch.
> > v5: https://lore.kernel.org/all/cover.1666525321.git.leonro@nvidia.com
> >  * Rebased to latest ipsec-next.
> >  * Replaced HW priority patch with solution which mimics separated SPDs
> >    for SW and HW. See more description in this cover letter.
> >  * Dropped RFC tag, usecase, API and implementation are clear.
> > v4: https://lore.kernel.org/all/cover.1662295929.git.leonro@nvidia.com
> >  * Changed title from "PATCH" to "PATCH RFC" per-request.
> >  * Added two new patches: one to update hard/soft limits and another
> >    initial take on documentation.
> >  * Added more info about lifetime/rekeying flow to cover letter, see
> >    relevant section.
> >  * perf traces for crypto mode will come later.
> > v3: https://lore.kernel.org/all/cover.1661260787.git.leonro@nvidia.com
> >  * I didn't hear any suggestion what term to use instead of
> >    "packet offload", so left it as is. It is used in commit messages
> >    and documentation only and easy to rename.
> >  * Added performance data and background info to cover letter
> >  * Reused xfrm_output_resume() function to support multiple XFRM transformations
> >  * Add PMTU check in addition to driver .xdo_dev_offload_ok validation
> >  * Documentation is in progress, but not part of this series yet.
> > v2: https://lore.kernel.org/all/cover.1660639789.git.leonro@nvidia.com
> >  * Rebased to latest 6.0-rc1
> >  * Add an extra check in TX datapath patch to validate packets before
> >    forwarding to HW.
> >  * Added policy cleanup logic in case of netdev down event
> > v1: https://lore.kernel.org/all/cover.1652851393.git.leonro@nvidia.com
> >  * Moved comment to be before if (...) in third patch.
> > v0: https://lore.kernel.org/all/cover.1652176932.git.leonro@nvidia.com
> > -----------------------------------------------------------------------
> 
> Please move the Changelog to the end of the commit message.
> 
> Except of the minor nit I had in patch 4/8, the patchset looks
> ready for merging. I'd prefer to merge it after the upcomming
> merge window. But Linus might do a rc8, so I leave it up to you
> in that case.

I'm sending new version now and my preference is to merge it in this
cycle. It will allow us to easily merge mlx5 part in next cycle without
any ipsec tree involvement. You won't need to apply and deal with any
merge conflicts which can bring our code :).

Of course, we will CC you and ipsec ML.

Thanks
