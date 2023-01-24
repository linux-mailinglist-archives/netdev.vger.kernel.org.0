Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6F167921F
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 08:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbjAXHic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 02:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjAXHib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 02:38:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86261116B;
        Mon, 23 Jan 2023 23:38:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CF20611FD;
        Tue, 24 Jan 2023 07:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F020C433D2;
        Tue, 24 Jan 2023 07:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674545909;
        bh=t/lco/MTbx/wDRY+Z4GwD+CMjCT9SE/4+xxVFTkugmQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b3E0oPOO4K9o2D5osjl8TSo5xt4tID40bZ/zG9oEPC1ISWPYzsSr0PShsqhmKzw0B
         X3RnU0+CQn1WCWuy3HnwX3NSGRI36UkD6IHhY1RP2vPT6IcfM43aAzY05oIuldNnJT
         t4HbByYdVBm83oRoZ+5dRFedKJbsy/R2kficcWN0=
Date:   Tue, 24 Jan 2023 08:38:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ajit Khaparde <ajit.khaparde@broadcom.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, andrew.gospodarek@broadcom.com,
        davem@davemloft.net, edumazet@google.com, jgg@ziepe.ca,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com, Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH net-next v8 1/8] bnxt_en: Add auxiliary driver support
Message-ID: <Y8+K8fCJ03R4h1dF@kroah.com>
References: <20230120060535.83087-1-ajit.khaparde@broadcom.com>
 <20230120060535.83087-2-ajit.khaparde@broadcom.com>
 <20230123223305.30c586ee@kernel.org>
 <Y89964YCQKwKlyB1@kroah.com>
 <CACZ4nhs2pSq73wEiySUgP8Gczmb=rz90pJOe747VtjKmm0yJbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACZ4nhs2pSq73wEiySUgP8Gczmb=rz90pJOe747VtjKmm0yJbA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 11:07:07PM -0800, Ajit Khaparde wrote:
> On Mon, Jan 23, 2023 at 10:42 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Jan 23, 2023 at 10:33:05PM -0800, Jakub Kicinski wrote:
> > > On Thu, 19 Jan 2023 22:05:28 -0800 Ajit Khaparde wrote:
> > > > @@ -13212,6 +13214,7 @@ static void bnxt_remove_one(struct pci_dev *pdev)
> > > >     kfree(bp->rss_indir_tbl);
> > > >     bp->rss_indir_tbl = NULL;
> > > >     bnxt_free_port_stats(bp);
> > > > +   bnxt_aux_priv_free(bp);
> > > >     free_netdev(dev);
> > >
> > > You're still freeing the memory in which struct device sits regardless
> > > of its reference count.
> > >
> > > Greg, is it legal to call:
> > >
> > >       auxiliary_device_delete(adev);  // AKA device_del(&auxdev->dev);
> > >       auxiliary_device_uninit(adev);  // AKA put_device(&auxdev->dev);
> > >       free(adev);                     // frees struct device
> >
> > Ick, the aux device release callback should be doing the freeing of the
> > memory, you shouldn't ever have to free it "manually" like this.  To do
> > so would be a problem (i.e. the release callback would then free it
> > again, right?)
> Yikes!
> Thanks for the refresher.
> 
> >
> > > ? I tried to explain this three times, maybe there's some wait during
> > > device_del() I'm not seeing which makes this safe :S
> Apologies.
> I thought since the driver was allocating the memory, it had to free it.

Yes, you do, in the release function that will be called when the device
reference count is dropped to 0.

thanks,

greg k-h
