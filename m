Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38986DAFB0
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbjDGPb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238089AbjDGPbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:31:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B73CB454;
        Fri,  7 Apr 2023 08:31:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C14BC651ED;
        Fri,  7 Apr 2023 15:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7832C433D2;
        Fri,  7 Apr 2023 15:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680881491;
        bh=I6DnJ9Zqh1jn9OOO4m1KcVCW/TWFLvLu+8aVG256SOM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=TlbEUVgyFmLnNVwB3duAAyW5ILxTFVl85pTzyYH/z0XAHHMV/O0as45TMVykZXuPw
         /EuiP0csvRtp3uwXs9bD/fRB953OyM3rf2wzeoZa/cYgB76mT3ThRG+dXBZQ/xTktp
         I0lyTbjY8FIgHjWUm+m16lsfFDdwzf+Zb1Hb8NxuVKVKeKgO0QjkDeSBEM2os4GQXU
         r38y+j5oFoyL9tyQ3hhna55zc10wioZfM0CrL+YoIRtD6yUlZ6DndK/ngOJw7vt65V
         yB5eeQGh1aEd6iHYWrZU3v7obOCcUY48jHUwLXkZnPFSHe6AMW9Cf4evhFcOugju+P
         lNIGpy50o7zlg==
Date:   Fri, 7 Apr 2023 10:31:29 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Denis Plotnikov <den-plotnikov@yandex-team.ru>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        anirban.chakraborty@qlogic.com, sony.chacko@qlogic.com,
        GR-Linux-NIC-Dev@marvell.com, manishc@marvell.com,
        shshaikh@marvell.com
Subject: Re: [PATCH net-next v2] qlcnic: check pci_reset_function result
Message-ID: <20230407153129.GA3797408@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZC/b2lP5+MRwcGqb@corigine.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 11:01:14AM +0200, Simon Horman wrote:
> On Fri, Apr 07, 2023 at 10:18:49AM +0300, Denis Plotnikov wrote:
> > Static code analyzer complains to unchecked return value.
> > The result of pci_reset_function() is unchecked.
> > Despite, the issue is on the FLR supported code path and in that
> > case reset can be done with pcie_flr(), the patch uses less invasive
> > approach by adding the result check of pci_reset_function().

Text could possibly be smoothed out a bit, e.g.:

  Static code analyzer complains that the result of
  pci_reset_function() is unchecked.  Check it and return error if
  it fails because the driver relies on the device being reset.

> > Found by Linux Verification Center (linuxtesting.org) with SVACE.
> > 
> > Fixes: 7e2cf4feba05 ("qlcnic: change driver hardware interface mechanism")
> > Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
> 
> Thanks Denis,
> 
> With reference to,
> 
> Link: https://lore.kernel.org/all/20230405193708.GA3632282@bhelgaas/
> 
> I think this is the best approach in lieu of feedback from those
> with knowledge of the hardware / testing on the hardware.

Agreed, looks good to me, too.  It doesn't look like there's much
activity in this driver (except wider-scale cleanups, etc), so I doubt
anybody could be confident that relying pcie_flr() would be safe.

Seem a *little* weird that this reset is done in .ndo_open() instead
of once at probe-time, but that's a much bigger question and not worth
worrying about.

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> > ---
> >  drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> > index 87f76bac2e463..eb827b86ecae8 100644
> > --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> > +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> > @@ -628,7 +628,13 @@ int qlcnic_fw_create_ctx(struct qlcnic_adapter *dev)
> >  	int i, err, ring;
> >  
> >  	if (dev->flags & QLCNIC_NEED_FLR) {
> > -		pci_reset_function(dev->pdev);
> > +		err = pci_reset_function(dev->pdev);
> > +		if (err) {
> > +			dev_err(&dev->pdev->dev,
> > +				"Adapter reset failed (%d). Please reboot\n",
> > +				err);
> > +			return err;
> > +		}
> >  		dev->flags &= ~QLCNIC_NEED_FLR;
> >  	}
> >  
> > -- 
> > 2.25.1
> > 
