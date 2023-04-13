Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2446E0931
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 10:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjDMIpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 04:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjDMIpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 04:45:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502A983C3
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:45:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E05AB63B1C
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 08:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C7EC4339B;
        Thu, 13 Apr 2023 08:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681375510;
        bh=wJ/4+2XMYSF0zPh+4Lkmp0fniMEjvCokuYvmqVomIa0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WbkVTvN/8eA3KrbWhaCVUuCAvk6ijUf5uyg82/buM6RedLR4oO6URF57NTjEAFgRb
         6IMMUvOGKo1/Ws1hAxL/B05hRNC3D8IMxqpk9lW5b7OAqbUJFkw5CcytjPgBqzb9to
         2wtawW1Q1t3RCo/glbkzIgPZZgB22BXGSGp6FwZupDCssJyUi4SqMiKkRhCSL64qiU
         i0t6gHUxpBBRidvpoLeoJrtGmb27KWVDkjLgecjJjLDwrZdNDwSJ6av8Xp/ZbPGanq
         LcmXQToVfBIiePdvEgFrCQRVR0djUNkIeGss/kA8XJVf9/YipTw1u7OJ0pTTrPo/l8
         f+/jv/nLonnGQ==
Date:   Thu, 13 Apr 2023 11:45:05 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 12/14] pds_core: add the aux client API
Message-ID: <20230413084505.GG17993@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-13-shannon.nelson@amd.com>
 <20230409170727.GG182481@unreal>
 <94a4ae9e-bd27-1553-593c-89b8bb9d0360@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94a4ae9e-bd27-1553-593c-89b8bb9d0360@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 01:50:52PM -0700, Shannon Nelson wrote:
> On 4/9/23 10:07 AM, Leon Romanovsky wrote:
> > 
> > On Thu, Apr 06, 2023 at 04:41:41PM -0700, Shannon Nelson wrote:
> > > Add the client API operations for running adminq commands.
> > > The core registers the client with the FW, then the client
> > > has a context for requesting adminq services.  We expect
> > > to add additional operations for other clients, including
> > > requesting additional private adminqs and IRQs, but don't have
> > > the need yet.
> > > 
> > > Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> > > ---
> > >   drivers/net/ethernet/amd/pds_core/auxbus.c | 135 ++++++++++++++++++++-
> > >   include/linux/pds/pds_auxbus.h             |  28 +++++
> > >   2 files changed, 160 insertions(+), 3 deletions(-)

<...>

> > 
> > > diff --git a/include/linux/pds/pds_auxbus.h b/include/linux/pds/pds_auxbus.h
> > > index aa0192af4a29..f98efd578e1c 100644
> > > --- a/include/linux/pds/pds_auxbus.h
> > > +++ b/include/linux/pds/pds_auxbus.h
> > > @@ -10,7 +10,35 @@ struct pds_auxiliary_dev {
> > >        struct auxiliary_device aux_dev;
> > >        struct pci_dev *vf_pdev;
> > >        struct pci_dev *pf_pdev;
> > > +     struct pds_core_ops *ops;
> > 
> > I honestly don't understand why pds_core functionality is espoused
> > through ops callbacks on auxdevice. IMHO, they shouldn't be callbacks
> > and that functionality shouldn't operate on auxdevice.
> 
> The original design had several more operations and wrapped all the
> interaction into a single defined interface rather that polluting the kernel
> with additional direct EXPORTed functions from the PF.  Since much has
> disappeared as we simplified the interface and don't yet have use for some
> of them, this ops struct with its single entry is the last vestige of that
> idea.
> 
> Perhaps it is time to put it away and add one more EXPORTed function. We can
> revisit this idea if/when the interface grows again.

Thanks
