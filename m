Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742FF306A8E
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbhA1Bkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbhA1BkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:40:16 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D389C061574
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:39:35 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id c128so3270553wme.2
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 17:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bD/VCVjj32VNsX3HNf6RUTS6We9z8YAWKdn/ZRhfnFk=;
        b=CPR//aHwcRkYpWg0dG1iMwmilRiWOfIz8Q0SeopKQFDFBXrddmR6ZoL2qcQV4wk9d9
         eNlNO+LnD8dHLSNIaaTLveM5g9nXKWiaFZ5vLMuM9m68tM2CI8JjB+fj3lv1Xq98rvRP
         +IZBqaR1K9TmJvTwxsTnn4K9APcX+9bYI5aAttDJln1hnFY4nPHLVNCxZI8jXuu++Aza
         wJoe88xF4WRkJj2IV4lbB30CXGZobcp7cP73XZsW75V4mi5HQYujGZWfSy/JJYx0GdJb
         wQJodLylsvkZSF5H77rzUV8pO7zUQwdzTqTHnlV/NU33qeKHZ3v5pR7PfiqijR6Zy9RN
         /ABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bD/VCVjj32VNsX3HNf6RUTS6We9z8YAWKdn/ZRhfnFk=;
        b=fuffBuy+/lngStwLqpgQuYHOdZZrcujfpyVMmnIoAzIgLaNKqKlba3rVbq4H06Eiaj
         fUfbNBbktddU2X94Xp9iJUe5YGV6e0ek/EfmvK3kHmSLG/VUy87/Mw+FnngzuULsFNVO
         Lg5oQDKEMtJcqGvmzxXd4hclpjLV2YZJ3y4O+28uwAfXrLg0C3YnRdSXqtND2S3yE37Q
         v0ZGLcOliM66xMBugdpwhyeXsSCWHKvFj7oFr1VGvdo9W2aCtwspNlgawczxctvuE6ul
         eWCQDOax8ayBYHmwYdQ4GpESZ4b+ByaH4lHAQ6KzmnCKzfSYWsznn0CAbF45MTn7Dufi
         N2FA==
X-Gm-Message-State: AOAM533L2FBuzGs/D6fN0ILMvoJyzpsVAy3sR5NWcZuKOK9vVSSL+nre
        tnKrILzS7kaMZKZlOPMfIVlNZS7E7YySqaALvwU=
X-Google-Smtp-Source: ABdhPJzWHbzYC3IaCOplYSVbKv4PpN9hKZOdvRc2w2583PleTZVxhrnUhxELOb544xyyg2doSlrsQM+4oOwNiFDmtjI=
X-Received: by 2002:a7b:cbd7:: with SMTP id n23mr6452368wmi.162.1611797974426;
 Wed, 27 Jan 2021 17:39:34 -0800 (PST)
MIME-Version: 1.0
References: <20210125232023.78649-1-ljp@linux.ibm.com> <20210127170105.011ebb9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAOhMmr7B4T6XRiGbawsyGBg_Ysa+fBVVacHFPACM8_+4+yjs_g@mail.gmail.com> <20210127173133.1fb08b8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210127173133.1fb08b8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Wed, 27 Jan 2021 19:39:22 -0600
Message-ID: <CAOhMmr4K3kbGRSozw9GLpeo=8pTExeb3_Zu0A4O0UXdykHGEyQ@mail.gmail.com>
Subject: Re: [PATCH net v2] ibmvnic: Ensure that CRQ entry read are correctly ordered
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 7:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 27 Jan 2021 19:22:25 -0600 Lijun Pan wrote:
> > On Wed, Jan 27, 2021 at 7:06 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Mon, 25 Jan 2021 17:20:23 -0600 Lijun Pan wrote:
> > > > Ensure that received Command-Response Queue (CRQ) entries are
> > > > properly read in order by the driver. dma_rmb barrier has
> > > > been added before accessing the CRQ descriptor to ensure
> > > > the entire descriptor is read before processing.
> > > >
> > > > Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
> > > > Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> > > > ---
> > > > v2: drop dma_wmb according to Jakub's opinion
> > > >
> > > >  drivers/net/ethernet/ibm/ibmvnic.c | 8 ++++++++
> > > >  1 file changed, 8 insertions(+)
> > > >
> > > > diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> > > > index 9778c83150f1..d84369bd5fc9 100644
> > > > --- a/drivers/net/ethernet/ibm/ibmvnic.c
> > > > +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> > > > @@ -5084,6 +5084,14 @@ static void ibmvnic_tasklet(struct tasklet_struct *t)
> > > >       while (!done) {
> > > >               /* Pull all the valid messages off the CRQ */
> > > >               while ((crq = ibmvnic_next_crq(adapter)) != NULL) {
> > > > +                     /* Ensure that the entire CRQ descriptor queue->msgs
> > > > +                      * has been loaded before reading its contents.
> > >
> > > I still find this sentence confusing, maybe you mean to say stored
> > > instead of loaded?
> >
> > The above 2 lines are the general description. The below 4 lines are
> > detailed explanations. If it is still confusing, we can delete the above
> > 2 lines of comments.
>
> Yes, I'd find the comment clearer without them, thanks.

v3 has been sent out:
https://patchwork.kernel.org/project/netdevbpf/patch/20210128013442.88319-1-ljp@linux.ibm.com/

Thanks,
Lijun
