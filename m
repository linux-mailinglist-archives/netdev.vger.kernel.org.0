Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8B95FECD8
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 13:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiJNLEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 07:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJNLEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 07:04:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1508D1C97D1
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 04:04:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 605FFB822A3
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 11:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E96EC433C1;
        Fri, 14 Oct 2022 11:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665745442;
        bh=nAU/Vrmzydc+asKnXPPfUaY1UgriouVqUiLcS1+N7Os=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kmUZI8LPl6KwPDw6ZrvZDoinD2arIDcz+7yTURXYdjkV9sJPEUcLuTDqg56YEeMFt
         B0/N2Whx6ZMDdTPV1COBPt9G+bzH3IDH/rrfyPsPORQGiOrpoVmbPxPRO6Hssr2ouY
         ybsLBb7Re6f3+jAGxp37gxvcauqdLQiApq9/fzR/mEtQIDFde4Qg8BV4/eSDu/Y02r
         aPJDVJvQirha/32TfXAxs+iak5ReoVZ5L5QJgtdcxETw+IaoDimpYdwFU12Nnyg4JH
         +Lf2C6fBJVKjAbTG2HuJJAtNQZaHqo7fXDVCh8ppxavD6lmUxmN/DupUBtMxP84O2o
         Daa5ojuRs4djA==
Date:   Fri, 14 Oct 2022 14:03:57 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, Antoine Tenart <atenart@kernel.org>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: Re: [PATCH net 0/5] macsec: offload-related fixes
Message-ID: <Y0lCHaGTQjsNvzVN@unreal>
References: <cover.1665416630.git.sd@queasysnail.net>
 <Y0j+E+n/RggT05km@unreal>
 <Y0kTMXzY3l4ncegR@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0kTMXzY3l4ncegR@hog>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 09:43:45AM +0200, Sabrina Dubroca wrote:
> 2022-10-14, 09:13:39 +0300, Leon Romanovsky wrote:
> > On Thu, Oct 13, 2022 at 04:15:38PM +0200, Sabrina Dubroca wrote:
> > > I'm working on a dummy offload for macsec on netdevsim. It just has a
> > > small SecY and RXSC table so I can trigger failures easily on the
> > > ndo_* side. It has exposed a couple of issues.
> > > 
> > > The first patch will cause some performance degradation, but in the
> > > current state it's not possible to offload macsec to lower devices
> > > that also support ipsec offload. 
> > 
> > Please don't, IPsec offload is available and undergoing review.
> > https://lore.kernel.org/netdev/cover.1662295929.git.leonro@nvidia.com/
> > 
> > This is whole series (XFRM + driver) for IPsec full offload.
> > https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=xfrm-next
> 
> Yes, and that's not upstream yet. 

For this conversation, you can assume what that series is merged.
It is not merged due to request to change how we store XFRM policies
in XFRM core code.

> That patchset is also doing nothing to address the issue I'm refering
> to here, where xfrm_api_check rejects the macsec device because it has
> the NETIF_F_HW_ESP flag (passed from the lower device) and no xfrmdev_ops.

Of course, why do you think that IPsec series should address MACsec bugs?

Thanks
