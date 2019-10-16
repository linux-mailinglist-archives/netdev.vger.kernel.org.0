Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C315D8B88
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 10:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390062AbfJPImr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 04:42:47 -0400
Received: from smtp2.goneo.de ([85.220.129.33]:59808 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731936AbfJPImr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 04:42:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.goneo.de (Postfix) with ESMTP id 8B717240A7C;
        Wed, 16 Oct 2019 10:42:43 +0200 (CEST)
X-Virus-Scanned: by goneo
X-Spam-Flag: NO
X-Spam-Score: -3.08
X-Spam-Level: 
X-Spam-Status: No, score=-3.08 tagged_above=-999 tests=[ALL_TRUSTED=-1,
        AWL=-0.180, BAYES_00=-1.9] autolearn=ham
Received: from smtp2.goneo.de ([127.0.0.1])
        by localhost (smtp2.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id h5fgb4HpxPzc; Wed, 16 Oct 2019 10:42:42 +0200 (CEST)
Received: from lem-wkst-02.lemonage (hq.lemonage.de [87.138.178.34])
        by smtp2.goneo.de (Postfix) with ESMTPSA id B4BA5240FB1;
        Wed, 16 Oct 2019 10:42:41 +0200 (CEST)
Date:   Wed, 16 Oct 2019 10:42:37 +0200
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jilayne Lovejoy <opensource@jilayne.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steve Winslow <swinslow@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Johan Hovold <johan@kernel.org>,
        "open list:NFC SUBSYSTEM" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH v9 4/7] nfc: pn533: Split pn533 init & nfc_register
Message-ID: <20191016084236.GA6610@lem-wkst-02.lemonage>
References: <20191008140544.17112-1-poeschel@lemonage.de>
 <20191008140544.17112-5-poeschel@lemonage.de>
 <20191009174023.528c278b@cakuba.netronome.com>
 <20191015095124.GA17778@lem-wkst-02.lemonage>
 <20191015091642.6f49dd8f@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015091642.6f49dd8f@cakuba.netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 09:16:42AM -0700, Jakub Kicinski wrote:
> On Tue, 15 Oct 2019 11:51:24 +0200, Lars Poeschel wrote:
> > > > -	priv->nfc_dev = nfc_allocate_device(&pn533_nfc_ops, protocols,
> > > > -					   priv->ops->tx_header_len +
> > > > -					   PN533_CMD_DATAEXCH_HEAD_LEN,
> > > > -					   priv->ops->tx_tail_len);
> > > > -	if (!priv->nfc_dev) {
> > > > -		rc = -ENOMEM;
> > > > -		goto destroy_wq;
> > > > -	}
> > > > -
> > > > -	nfc_set_parent_dev(priv->nfc_dev, parent);
> > > > -	nfc_set_drvdata(priv->nfc_dev, priv);
> > > > -
> > > > -	rc = nfc_register_device(priv->nfc_dev);
> > > > -	if (rc)
> > > > -		goto free_nfc_dev;  
> > > 
> > > Aren't you moving too much out of here? Looking at commit 32ecc75ded72
> > > ("NFC: pn533: change order operations in dev registation") it seems like
> > > IRQ handler may want to access the data structures, do this change not
> > > reintroduce the problem?  
> > 
> > Yes, you are right, there could be a problem if an irq gets served
> > before the driver is registered to the nfc subsystem.
> > Well, but the purpose of this patch is exactly that: Prevent use of nfc
> > subsystem before the chip is fully initialized.
> > To address this, I would not change the part above, but move the
> > request_threaded_irq to the very bottom in pn533_i2c_probe, after the
> > call to pn53x_register_nfc. So it is not possible to use nfc before the
> > chip is initialized and irqs don't get served before the driver is
> > registered to nfc subsystem.
> > Thank you for this!
> > I will include this in v10 of the patchset.
> 
> You can run nfc_allocate_device() etc. early, then allocate the IRQ,
> and then run nfc_register_device(), would that work? Is that what you
> have in mind?

Well, I think my proposed solution above would technically do it, but I
think I will do it like you proposed. I think for someone reading the
code it is far more easier to understand, what the idea behind it is, if
the irq is requested right between nfc_allocate_device and
nfc_register_device.
Thanks again!

