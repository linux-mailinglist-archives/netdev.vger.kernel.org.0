Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED7F6D8709
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 21:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbjDETit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 15:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbjDETib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 15:38:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F869109;
        Wed,  5 Apr 2023 12:37:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AE84640BE;
        Wed,  5 Apr 2023 19:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97283C433EF;
        Wed,  5 Apr 2023 19:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680723429;
        bh=TLG3NZx0ALC463PDdufiBKczspw2zuA1W3rAJxepf5k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=DTAlaf5qV1uSiQa5LuJCDGh/hcwXVcZFLUHADH/hguhCT/5asojITIl11hbOfUD4I
         WEp7f4zsiFPpt7MZHXgDyCm6UG1y3a0CAn4ZmVd4lGyakXjZH0MGDsXJx/WShChi3E
         p1+/Baw4gZykoqsFEiejtkDuVyjs3oPs9/bRD89LqFfEyHL5OiGzOkdPu7ZnFYegJu
         0X5xKiFKYZQRSgUmExpzXr/f/Y6GC0oI+7DIsxxwXQXtq6Jeu9saRp9j+Q2RRi6IrF
         HMruhZtAyGqwpOxwu2Ag8JCFs8aCQNZwMlYleJ6p/YWva8D1ultBAArTnD5/bVweNK
         /woEU+KZWin+w==
Date:   Wed, 5 Apr 2023 14:37:08 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Denis Plotnikov <den-plotnikov@yandex-team.ru>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] qlcnic: check pci_reset_function result
Message-ID: <20230405193708.GA3632282@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZC1x57v1JdUyK7aG@corigine.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 03:04:39PM +0200, Simon Horman wrote:
> On Mon, Apr 03, 2023 at 01:58:49PM +0300, Denis Plotnikov wrote:
> > On 31.03.2023 20:52, Simon Horman wrote:
> > > On Fri, Mar 31, 2023 at 11:06:05AM +0300, Denis Plotnikov wrote:
> > > > Static code analyzer complains to unchecked return value.
> > > > It seems that pci_reset_function return something meaningful
> > > > only if "reset_methods" is set.
> > > > Even if reset_methods isn't used check the return value to avoid
> > > > possible bugs leading to undefined behavior in the future.
> > > > 
> > > > Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
> > > nit: The tree this patch is targeted at should be designated, probably
> > >       net-next, so the '[PATCH net-next]' in the subject.
> > > 
> > > > ---
> > > >   drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c | 4 +++-
> > > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> > > > index 87f76bac2e463..39ecfc1a1dbd0 100644
> > > > --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> > > > +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
> > > > @@ -628,7 +628,9 @@ int qlcnic_fw_create_ctx(struct qlcnic_adapter *dev)
> > > >   	int i, err, ring;
> > > >   	if (dev->flags & QLCNIC_NEED_FLR) {
> > > > -		pci_reset_function(dev->pdev);
> > > > +		err = pci_reset_function(dev->pdev);
> > > > +		if (err && err != -ENOTTY)
> > > Are you sure about the -ENOTTY part?
> > > 
> > > It seems odd to me that an FLR would be required but reset is not supported.
> > No, I'm not sure. My logic is: if the reset method isn't set than
> > pci_reset_function() returns -ENOTTY so treat that result as ok.
> > pci_reset_function may return something different than -ENOTTY only if
> > pci_reset_fn_methods[m].reset_fn is set.
> 
> I see your reasoning: -ENOTTY means nothing happened, and probably that is ok.
> I think my main question is if that can ever happen.
> If that is unknown, then I think this conservative approach makes sense.

The commit log mentions "reset_methods", which I don't think is really
relevant here because reset_methods is an internal implementation
detail.  The point is that pci_reset_function() returns 0 if it was
successful and a negative value if it failed.

If the driver thinks the device needs to be reset, ignoring any
negative return value seems like a mistake because the device was not
reset.

If the reset is required for a firmware update to take effect, maybe a
diagnostic would be helpful if it fails, e.g., the other "Adapter
initialization failed.  Please reboot" messages.

"QLCNIC_NEED_FLR" suggests that the driver expects an FLR (as opposed
to other kinds of reset).  If the driver knows that all qlcnic devices
support FLR, it could use pcie_flr() directly.

pci_reset_function() does have the possibility that the reset works on
some devices but not all.  Secondary Bus Reset fails if there are
other functions on the same bus, e.g., a multi-function device.  And
there's some value in doing the reset the same way in all cases.

So I would suggest something like:

  if (dev->flags & QLCNIC_NEED_FLR) {
    err = pcie_flr(dev->pdev);
    if (err) {
      dev_err(&pdev->dev, "Adapter reset failed (%d). Please reboot\n", err);
      return err;
    }
    dev->flags &= ~QLCNIC_NEED_FLR;
  }

Or, if there are qlcnic devices that don't support FLR:

  if (dev->flags & QLCNIC_NEED_FLR) {
    err = pci_reset_function(dev->pdev);
    if (err) {
      dev_err(&pdev->dev, "Adapter reset failed (%d). Please reboot\n", err);
      return err;
    }
    dev->flags &= ~QLCNIC_NEED_FLR;
  }

> > > > +			return err;
> > > >   		dev->flags &= ~QLCNIC_NEED_FLR;
> > > >   	}
> > > > -- 
> > > > 2.25.1
> > > > 
