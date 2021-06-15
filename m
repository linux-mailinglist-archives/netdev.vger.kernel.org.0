Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2303A7B80
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 12:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhFOKMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 06:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbhFOKMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 06:12:48 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D404C061574;
        Tue, 15 Jun 2021 03:10:44 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id u24so50304783edy.11;
        Tue, 15 Jun 2021 03:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oCpcZf2UhB1kUI420Fd2Oz53E4JiY49ICmqCxOkWky8=;
        b=dJUfgN+8aIX6uooBjZrDuUG21Okd7E9dQDRGfypdUfviFuP/OMdcJ1vDmE84Hoqt+M
         mwjEs/3Om84dIJp8ClqjoLQUJo40S7iocXGQlxmtx334ZrcWlroUfGO58XmwF8bLTaI/
         DJsNd6KH8P46m2r+HINUg8CvgMKRFZaDWS/+IjSLCxNNyHOpHFSV+eE0YZdf5JUGO9vK
         3DlK436iC5HZcJNmhVcFQgkEkM8m+jxjM8DKGSx47tlFc4QV1mVWHltSBJRzIAmI9W4T
         MtZh+jIOj9xZklgmArRbu0s1dMbV/MygT0QRliJ4BEWtcLYfn1HqJIX/xiGebDfMftsf
         Ud3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oCpcZf2UhB1kUI420Fd2Oz53E4JiY49ICmqCxOkWky8=;
        b=IE7m+uuf+V3OD6y3Onokd8uded8+jwlLeqQ52ETwQTb7l8IRgHxp71mUQOu/xUa0je
         2G8etHry1i8A+L+sXhS1NIi7fPTB1ybhH2JCRXSctT02zMDIxd8RBDKrLzSWoS8LQ9dI
         EwaGhY7uqRQaRYLVmvKdY1iZh5UtZ+lw9VuSpr6OKHRYcwunaCHFzdeRGDToieFQjTB4
         A0SM3HwmC0UA48zezGa/gqRfkvKjiuqs641xs16w9eP6bsCq/MoWR+cr9rfBUpcn/++m
         y28umqJeUoggGJR0rrTGjji4rqse0URNutLLND9BWpjfeKZjJq50oqUEO2giAhsH9KXr
         MjNg==
X-Gm-Message-State: AOAM532L1vVkJInlBXTCYQbDpR2yJbnv5FLFuXlXf9+TrUR/+EHILGYx
        1AJPYJ7oMJxMwF008nHtsIlSmZdP+tXPCxuxM9w=
X-Google-Smtp-Source: ABdhPJzbrBMJeWPE/dIGJn1IjaQLtUMTyyBT+ZAAB7UoAAAB2vZaDUlUW4xjpic9aPnw+wGMsgsXJ/PmAXy+9dZawsw=
X-Received: by 2002:a05:6402:54f:: with SMTP id i15mr21915437edx.339.1623751842851;
 Tue, 15 Jun 2021 03:10:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210614153712.2172662-1-mudongliangabcd@gmail.com>
 <YMhY9NHf1itQyup7@kroah.com> <CAD-N9QVfDQQo0rRiaa6Cx-xO80yox9hNzK91_UVj0KNgkhpvnQ@mail.gmail.com>
 <YMh2b0LvT9H7SuNC@kroah.com>
In-Reply-To: <YMh2b0LvT9H7SuNC@kroah.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Tue, 15 Jun 2021 18:10:16 +0800
Message-ID: <CAD-N9QV+GMURatPx4qJT2nMsKHQhj+BXC9C-ZyQed3pN8a9YUA@mail.gmail.com>
Subject: Re: [PATCH] net: usb: fix possible use-after-free in smsc75xx_bind
To:     Greg KH <greg@kroah.com>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 5:44 PM Greg KH <greg@kroah.com> wrote:
>
> On Tue, Jun 15, 2021 at 03:56:32PM +0800, Dongliang Mu wrote:
> > On Tue, Jun 15, 2021 at 3:38 PM Greg KH <greg@kroah.com> wrote:
> > >
> > > On Mon, Jun 14, 2021 at 11:37:12PM +0800, Dongliang Mu wrote:
> > > > The commit 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> > > > fails to clean up the work scheduled in smsc75xx_reset->
> > > > smsc75xx_set_multicast, which leads to use-after-free if the work is
> > > > scheduled to start after the deallocation. In addition, this patch also
> > > > removes one dangling pointer - dev->data[0].
> > > >
> > > > This patch calls cancel_work_sync to cancel the schedule work and set
> > > > the dangling pointer to NULL.
> > > >
> > > > Fixes: 46a8b29c6306 ("net: usb: fix memory leak in smsc75xx_bind")
> > > > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > > > ---
> > > >  drivers/net/usb/smsc75xx.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
> > > > index b286993da67c..f81740fcc8d5 100644
> > > > --- a/drivers/net/usb/smsc75xx.c
> > > > +++ b/drivers/net/usb/smsc75xx.c
> > > > @@ -1504,7 +1504,10 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
> > > >       return 0;
> > > >
> > > >  err:
> > > > +     cancel_work_sync(&pdata->set_multicast);
> > > >       kfree(pdata);
> > > > +     pdata = NULL;
> > >
> > > Why do you have to set pdata to NULL afterward?
> > >
> >
> > It does not have to. pdata will be useless when the function exits. I
> > just referred to the implementation of smsc75xx_unbind.
>
> It's wrong there too :)

/: I will fix such two sites in the v2 patch.
