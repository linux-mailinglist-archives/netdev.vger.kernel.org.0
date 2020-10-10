Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587B628A3BF
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731354AbgJJW4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731600AbgJJTyP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 15:54:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61BD62222E;
        Sat, 10 Oct 2020 12:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602333590;
        bh=8kVjcuFRI46rDQajLnlADqQP7xJM+Czh0KbJDee7LoA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mvp7/XeSD/1zsA7y97uFXHjAj3MEnPctdDpxkMxYRg+ipmeaDMH7fVmxYneH3lufn
         qVXqoBT/yUbPRhA+iVPIo7JCnWi1V/ysegwsYQEHhKsI7fa4wdmOJpatDqnPjJWv4/
         zrZ5HfwcCg9u6pog2IRHbFgjdplTcmLoI2hvPcuA=
Date:   Sat, 10 Oct 2020 14:40:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 3/8] staging: wfx: standardize the error when vif does
 not exist
Message-ID: <20201010124034.GA1701199@kroah.com>
References: <20201009171307.864608-1-Jerome.Pouiller@silabs.com>
 <20201009171307.864608-4-Jerome.Pouiller@silabs.com>
 <87zh4vz0xs.fsf@codeaurora.org>
 <2632043.z0MBYUB4Ha@pc-42>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2632043.z0MBYUB4Ha@pc-42>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 02:22:13PM +0200, Jérôme Pouiller wrote:
> On Friday 9 October 2020 20:52:47 CEST Kalle Valo wrote:
> > Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> > 
> > > From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > >
> > > Smatch complains:
> > >
> > >    drivers/staging/wfx/hif_rx.c:177 hif_scan_complete_indication() warn: potential NULL parameter dereference 'wvif'
> > >    drivers/staging/wfx/data_tx.c:576 wfx_flush() warn: potential NULL parameter dereference 'wvif'
> > >
> > > Indeed, if the vif id returned by the device does not exist anymore,
> > > wdev_to_wvif() could return NULL.
> > >
> > > In add, the error is not handled uniformly in the code, sometime a
> > > WARN() is displayed but code continue, sometime a dev_warn() is
> > > displayed, sometime it is just not tested, ...
> > >
> > > This patch standardize that.
> > >
> > > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> > > ---
> > >  drivers/staging/wfx/data_tx.c |  5 ++++-
> > >  drivers/staging/wfx/hif_rx.c  | 34 ++++++++++++++++++++++++----------
> > >  drivers/staging/wfx/sta.c     |  4 ++++
> > >  3 files changed, 32 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/drivers/staging/wfx/data_tx.c b/drivers/staging/wfx/data_tx.c
> > > index b4d5dd3d2d23..8db0be08daf8 100644
> > > --- a/drivers/staging/wfx/data_tx.c
> > > +++ b/drivers/staging/wfx/data_tx.c
> > > @@ -431,7 +431,10 @@ static void wfx_skb_dtor(struct wfx_vif *wvif, struct sk_buff *skb)
> > >                             sizeof(struct hif_req_tx) +
> > >                             req->fc_offset;
> > >
> > > -     WARN_ON(!wvif);
> > > +     if (!wvif) {
> > > +             pr_warn("%s: vif associated with the skb does not exist anymore\n", __func__);
> > > +             return;
> > > +     }
> > 
> > I'm not really a fan of using function names in warning or error
> > messages as it clutters the log. In debug messages I think they are ok.
> 
> In the initial code, I used WARN() that far more clutters the log (I
> have stated that a backtrace won't provide any useful information, so
> pr_warn() was better suited).
> 
> In add, in my mind, these warnings are debug messages. If they appears,
> the user should probably report a bug.
> 
> Finally, in this patch, I use the same message several times (ok, not
> this particular one). So the function name is a way to differentiate
> them.

You should use dev_*() for these, that way you can properly determine
the exact device as well.

thanks,

greg k-h
