Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C3267912F
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 07:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbjAXGm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 01:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbjAXGm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 01:42:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2D222A1E;
        Mon, 23 Jan 2023 22:42:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85FC3611FA;
        Tue, 24 Jan 2023 06:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6FDC433D2;
        Tue, 24 Jan 2023 06:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674542574;
        bh=fjOxeVwNvpxlkZWGMF5OTJaz+EFvtIXBxImQnPiLr0s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P8Qy3Sk0+ndw7G9Qoe4QHzvSLvwt4L3bMMWZnDbX4hlMWqGGZulvMi0SEhCFhG8gm
         8QHr4QEh43dw06DZqy4BIvHVo+IxDVBPYXdOzYYPOMUTYAvkjasIQaiqMX2/689IsK
         +hCAWmJrgrSIJeWF0hs4tpx8lPVQ8l6n808nBLkU=
Date:   Tue, 24 Jan 2023 07:42:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ajit Khaparde <ajit.khaparde@broadcom.com>,
        andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH net-next v8 1/8] bnxt_en: Add auxiliary driver support
Message-ID: <Y89964YCQKwKlyB1@kroah.com>
References: <20230120060535.83087-1-ajit.khaparde@broadcom.com>
 <20230120060535.83087-2-ajit.khaparde@broadcom.com>
 <20230123223305.30c586ee@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123223305.30c586ee@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 10:33:05PM -0800, Jakub Kicinski wrote:
> On Thu, 19 Jan 2023 22:05:28 -0800 Ajit Khaparde wrote:
> > @@ -13212,6 +13214,7 @@ static void bnxt_remove_one(struct pci_dev *pdev)
> >  	kfree(bp->rss_indir_tbl);
> >  	bp->rss_indir_tbl = NULL;
> >  	bnxt_free_port_stats(bp);
> > +	bnxt_aux_priv_free(bp);
> >  	free_netdev(dev);
> 
> You're still freeing the memory in which struct device sits regardless
> of its reference count.
> 
> Greg, is it legal to call:
>   
> 	auxiliary_device_delete(adev);  // AKA device_del(&auxdev->dev);
> 	auxiliary_device_uninit(adev);  // AKA put_device(&auxdev->dev);
> 	free(adev);			// frees struct device

Ick, the aux device release callback should be doing the freeing of the
memory, you shouldn't ever have to free it "manually" like this.  To do
so would be a problem (i.e. the release callback would then free it
again, right?)

> ? I tried to explain this three times, maybe there's some wait during
> device_del() I'm not seeing which makes this safe :S

Nope, no intentional wait normally.  You can add one by enabling a
debugging option to find all of the places where people are doing bad
things like this by delaying the freeing of the device memory until a
few seconds later, but that's generally not something you should run in
a production kernel as it finds all sorts of nasty bugs...

thanks,

greg k-h
