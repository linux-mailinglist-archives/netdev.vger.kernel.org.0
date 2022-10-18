Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B889660245E
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 08:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiJRG2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 02:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiJRG2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 02:28:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C999378C
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 23:28:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71F51B81D01
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 06:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD17C433D6;
        Tue, 18 Oct 2022 06:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666074493;
        bh=NIv+zlkDF5GO2IOlENnUb+ooioXtneBtjHCzTbA2rrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qtLCX47Rf37mdnA7RJKVxanZOxUnpCreXPpWIU3GImtbRBHiHPnC6EdDZVhRlJe4A
         yKigKJKy27hZ/eNEjJldS05U+FSPNyqQ6rzSa5OoQFEGyDFt9mpJgqHa6WeT54P3MS
         bKkQEP7NIhWWixGPpl2EGiKzB+SWPJ4Bp+v4Vr5MU/Pg0kzEJDRHnZ/MyP+Ouhssbx
         jbwsMG3MwV0s8otpFu3QWQrzmyefWGk2oEXHgfam0pqtIcBvvd5S1EoCUu8pB/0D+W
         0nKJKWBYCX0/pNNvIc8NSXJXpsEMX+H0InsS4lMYx89K2Ic2U0Dq9/nNpeA56PjKqh
         Di7Jx9kJWH8/g==
Date:   Tue, 18 Oct 2022 09:28:08 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: Re: [PATCH net 0/5] macsec: offload-related fixes
Message-ID: <Y05HeGnTKBY0RVI4@unreal>
References: <cover.1665416630.git.sd@queasysnail.net>
 <Y0j+E+n/RggT05km@unreal>
 <Y0kTMXzY3l4ncegR@hog>
 <Y0lCHaGTQjsNvzVN@unreal>
 <166575623691.3451.2587099917911763555@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166575623691.3451.2587099917911763555@kwain>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 04:03:56PM +0200, Antoine Tenart wrote:
> Quoting Leon Romanovsky (2022-10-14 13:03:57)
> > On Fri, Oct 14, 2022 at 09:43:45AM +0200, Sabrina Dubroca wrote:
> > > 2022-10-14, 09:13:39 +0300, Leon Romanovsky wrote:
> > > > On Thu, Oct 13, 2022 at 04:15:38PM +0200, Sabrina Dubroca wrote:
> > > > > I'm working on a dummy offload for macsec on netdevsim. It just has a
> > > > > small SecY and RXSC table so I can trigger failures easily on the
> > > > > ndo_* side. It has exposed a couple of issues.
> > > > > 
> > > > > The first patch will cause some performance degradation, but in the
> > > > > current state it's not possible to offload macsec to lower devices
> > > > > that also support ipsec offload. 
> > > > 
> > > > Please don't, IPsec offload is available and undergoing review.
> > > > https://lore.kernel.org/netdev/cover.1662295929.git.leonro@nvidia.com/
> > > > 
> > > > This is whole series (XFRM + driver) for IPsec full offload.
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=xfrm-next
> > 
> > > That patchset is also doing nothing to address the issue I'm refering
> > > to here, where xfrm_api_check rejects the macsec device because it has
> > > the NETIF_F_HW_ESP flag (passed from the lower device) and no xfrmdev_ops.
> > 
> > Of course, why do you think that IPsec series should address MACsec bugs?
> 
> I was looking at this and the series LGTM. I don't get the above
> concern, can you clarify?
> 
> If a lower device has both IPsec & MACsec offload capabilities:
> 
> - Without the revert: IPsec can be offloaded to the lower dev, MACsec
>   can't. That's a bug.

And how does it possible that mlx5 macsec offload work?

> 
> - With the revert: IPsec and MACsec can be offloaded to the lower dev.
>   Some features might not propagate to the MACsec dev, which won't allow
>   some performance optimizations in the MACsec data path.

My concern is related to this sentence: "it's not possible to offload macsec
to lower devices that also support ipsec offload", because our devices support
both macsec and IPsec offloads at the same time.

I don't want to see anything (even in commit messages) that assumes that IPsec
offload doesn't exist.

Thanks

> 
> Thanks,
> Antoine
