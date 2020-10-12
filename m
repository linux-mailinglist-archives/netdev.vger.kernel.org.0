Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2A228BBA3
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 17:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389738AbgJLPQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 11:16:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389225AbgJLPQg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 11:16:36 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A6B920878;
        Mon, 12 Oct 2020 15:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602515795;
        bh=0j6qf98C/VHd5JVBKbDLdE4Pd0CIJdHg9Om9AIcfSm0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ivnuej6X8z4a8TCAuaJTm6INdDWC6yUxZPKyVGbSEVvL27mCCNRxqp1yjXAmY8dPB
         YCMn70Op0MPtEkAbQ/faDox7RvTPLfnmu/SxQsD7KLFCfyWMzws84aA2d73Ta4BWez
         +fJD2shGgoJ1BcHUrs8Eu9NSL0LeNVBHzh+WeSns=
Date:   Mon, 12 Oct 2020 08:16:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Yongxin Liu <yongxin.liu@windriver.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: ethernet: ixgbe: don't propagate -ENODEV from
 ixgbe_mii_bus_init()
Message-ID: <20201012081633.7b501cde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMRc=MexKweGRjF5KNg1saz7NmE+tQq=03oR3wzoMsaTcm+CAA@mail.gmail.com>
References: <20200928071744.18253-1-brgl@bgdev.pl>
        <CAMRc=MexKweGRjF5KNg1saz7NmE+tQq=03oR3wzoMsaTcm+CAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 14:20:16 +0200 Bartosz Golaszewski wrote:
> On Mon, Sep 28, 2020 at 9:17 AM Bartosz Golaszewski <brgl@bgdev.pl> wrote:
> >
> > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> >
> > It's a valid use-case for ixgbe_mii_bus_init() to return -ENODEV - we
> > still want to finalize the registration of the ixgbe device. Check the
> > error code and don't bail out if err == -ENODEV.
> >
> > This fixes an issue on C3000 family of SoCs where four ixgbe devices
> > share a single MDIO bus and ixgbe_mii_bus_init() returns -ENODEV for
> > three of them but we still want to register them.
> >
> > Fixes: 09ef193fef7e ("net: ethernet: ixgbe: check the return value of ixgbe_mii_bus_init()")
> > Reported-by: Yongxin Liu <yongxin.liu@windriver.com>
> > Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > ---
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > index 2f8a4cfc5fa1..d1623af30125 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > @@ -11032,7 +11032,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >                         true);
> >
> >         err = ixgbe_mii_bus_init(hw);
> > -       if (err)
> > +       if (err && err != -ENODEV)
> >                 goto err_netdev;
> >
> >         return 0;
>
> Gentle ping for this patch. Who's picking up networking patches now
> that David is OoO? Should I Cc someone else?

Intel went through a maintainer change of its own, and they usually
pick up their patches and send a PR.

Tony, do you want me to apply this directly?
