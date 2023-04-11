Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4416DDB22
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjDKMrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjDKMrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:47:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EC426BE
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 05:47:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 130C761E7A
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 12:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49F5C433EF;
        Tue, 11 Apr 2023 12:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681217228;
        bh=NOVkgwwnP1xahHAfcsJty72kyo9GnktJkyts7RtER3M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eJXRDNB4ojUBQPHoawNEn7jU6PA3rrQL1b0+bvIOYvrT1/xvdL00aoDIuVCbGeaPt
         ygRYjModYuF7AuZaK0AcSfcjM0gjoBfG0BG4/hlTcrn2hFydusge4I+pXi5CiV8PrX
         BfTj9FLF0rMOBRKtC4vNTOSI1VKFmNRKNUBBFAXOWSgvaZZmaZCQqiZ1CBEkxvJj+d
         L2IRXgFiP51rtl9ad07b6bzbIWruVq/KaDbMp/CtF5jVHCbbAaRVYenTxMPWDuJfKp
         sKCXwYKysgH+kKZyDMAmXmVkYzra3WxYra1bB8FX6r/Dxm192T5V9AXwF0+PPZR0HL
         /0P89imJnVFkg==
Date:   Tue, 11 Apr 2023 15:47:04 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Brett Creeley <bcreeley@amd.com>
Cc:     Brett Creeley <brett.creeley@amd.com>, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, drivers@pensando.io,
        shannon.nelson@amd.com, neel.patel@amd.com
Subject: Re: [PATCH net] ionic: Fix allocation of q/cq info structures from
 device local node
Message-ID: <20230411124704.GX182481@unreal>
References: <20230407233645.35561-1-brett.creeley@amd.com>
 <20230409105242.GR14869@unreal>
 <bd48d23b-093c-c6d4-86f1-677c2a0ab03c@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd48d23b-093c-c6d4-86f1-677c2a0ab03c@amd.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 11:16:03AM -0700, Brett Creeley wrote:
> On 4/9/2023 3:52 AM, Leon Romanovsky wrote:
> > Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> > 
> > 
> > On Fri, Apr 07, 2023 at 04:36:45PM -0700, Brett Creeley wrote:
> > > Commit 116dce0ff047 ("ionic: Use vzalloc for large per-queue related
> > > buffers") made a change to relieve memory pressure by making use of
> > > vzalloc() due to the structures not requiring DMA mapping. However,
> > > it overlooked that these structures are used in the fast path of the
> > > driver and allocations on the non-local node could cause performance
> > > degredation. Fix this by first attempting to use vzalloc_node()
> > > using the device's local node and if that fails try again with
> > > vzalloc().
> > > 
> > > Fixes: 116dce0ff047 ("ionic: Use vzalloc for large per-queue related buffers")
> > > Signed-off-by: Neel Patel <neel.patel@amd.com>
> > > Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> > > Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> > > ---
> > >   .../net/ethernet/pensando/ionic/ionic_lif.c   | 24 ++++++++++++-------
> > >   1 file changed, 16 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> > > index 957027e546b3..2c4e226b8cf1 100644
> > > --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> > > +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> > > @@ -560,11 +560,15 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
> > >        new->q.dev = dev;
> > >        new->flags = flags;
> > > 
> > > -     new->q.info = vzalloc(num_descs * sizeof(*new->q.info));
> > > +     new->q.info = vzalloc_node(num_descs * sizeof(*new->q.info),
> > > +                                dev_to_node(dev));
> > >        if (!new->q.info) {
> > > -             netdev_err(lif->netdev, "Cannot allocate queue info\n");
> > > -             err = -ENOMEM;
> > > -             goto err_out_free_qcq;
> > > +             new->q.info = vzalloc(num_descs * sizeof(*new->q.info));
> > > +             if (!new->q.info) {
> > > +                     netdev_err(lif->netdev, "Cannot allocate queue info\n");
> > 
> > Kernel memory allocator will try local node first and if memory is
> > depleted it will go to remote nodes. So basically, you open-coded that
> > behaviour but with OOM splash when first call to vzalloc_node fails and
> > with custom error message about memory allocation failure.
> > 
> > Thanks
> 
> Leon,
> 
> We want to allocate memory from the node local to our PCI device, which is
> not necessarily the same as the node that the thread is running on where
> vzalloc() first tries to alloc.

I'm not sure about it as you are running kernel thread which is
triggered directly by device and most likely will run on same node as
PCI device.

> Since it wasn't clear to us that vzalloc_node() does any fallback, 

vzalloc_node() doesn't do fallback, but vzalloc will find the right node
for you.

> we followed the example in the ena driver to follow up with a more
> generic vzalloc() request.

I don't know about ENA implementation, maybe they have right reasons to
do it, but maybe they don't.

> 
> Also, the custom message helps us quickly figure out exactly which
> allocation failed.

If OOM is missing some info to help debug allocation failures, let's add
it there, but please do not add any custom prints after alloc failures.

Thanks

> 
> Thanks,
> 
> Brett
