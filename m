Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 486B7C0679
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 15:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbfI0Nhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 09:37:38 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34750 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727502AbfI0Nhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 09:37:38 -0400
Received: by mail-lf1-f65.google.com with SMTP id r22so1974237lfm.1
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 06:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VrL164IRw5ZRQ8ez5WYp+BsUCKNYHEZMANPL6uyKjTE=;
        b=RbS/iZAtUjzGWBny0pRamfP18YdqNNCm11l0OVCzg20sIN4gPc9qpBUV56s0D3gDbe
         kEcJvXPnv0r+bR3p2KjjP6p6A5/7d+LBG+dmWBqeSTiGilxsIlGeK070uDeIL50esPoT
         PA682s0gDHmhFAb/8OAc41aZlbqQ41KbWUZHg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VrL164IRw5ZRQ8ez5WYp+BsUCKNYHEZMANPL6uyKjTE=;
        b=Ozb1M9oRtI+EuN8jEZAIcquqBY2V80lOPbvYcJa9uRXNHPI2sx92jtWy6UH2uxMprK
         MJjwGXvGsk9He+ls4rsNAGTqe263rvqpXed0Y3JYRFeTrg7/e3fiLRjsA8P3CLC7kEDM
         WKeVvES8oYo4MB+B5KlAUvcjYAjgsJvC7j3upqLPrAus0qhpUtLihUF+A/mC+zBYn2Iw
         YB8dt91k4IKmnX3O4zMkHKiOE2ak0cuKvvVEV/4c2yDr69ol9yuvuIDEtQh/jSgqo43y
         EkwuPHa8JeEyE/pLccCo4E0eQ9OIaRR1H0G3uoxTKLCplzLyshVPUZs5JzMIOpj8Nn0f
         UEwg==
X-Gm-Message-State: APjAAAUb76zj2FjqCllZpo2iQmrQZG7IBITUtaDPB/HmB/RDt8emFXlC
        ua+OjU9i/WeKsSqGhwi1ZUI++L4eFBVfnG/hkEXCCQ==
X-Google-Smtp-Source: APXvYqwky2nKiODmvUAevMHMP7Dpb39dta+k8c6iPH3c28gGZu/rsZILB2Scet6DOZ/UhnXZ+UpCfv+w72jZ0LFIUXI=
X-Received: by 2002:a19:c002:: with SMTP id q2mr2971629lff.62.1569591456107;
 Fri, 27 Sep 2019 06:37:36 -0700 (PDT)
MIME-Version: 1.0
References: <1569490554-21238-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20190926122726.GE1864@lunn.ch> <CAACQVJpgZz3Fb36=x_wPb+hAaXecHj6oVuUsD-GgEhz9yfRgKg@mail.gmail.com>
 <20190927123129.GB25474@lunn.ch>
In-Reply-To: <20190927123129.GB25474@lunn.ch>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Fri, 27 Sep 2019 19:07:24 +0530
Message-ID: <CAACQVJqMNU6GkZbYif_nPpRyB8d2o+ONLo4xR0B8RpXQrqdZrA@mail.gmail.com>
Subject: Re: [PATCH net] devlink: Fix error handling in param and info_get
 dumpit cb
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 27, 2019 at 6:01 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Sep 27, 2019 at 10:28:36AM +0530, Vasundhara Volam wrote:
> > On Thu, Sep 26, 2019 at 5:57 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Thu, Sep 26, 2019 at 03:05:54PM +0530, Vasundhara Volam wrote:
> > > > If any of the param or info_get op returns error, dumpit cb is
> > > > skipping to dump remaining params or info_get ops for all the
> > > > drivers.
> > > >
> > > > Instead skip only for the param/info_get op which returned error
> > > > and continue to dump remaining information, except if the return
> > > > code is EMSGSIZE.
> > >
> > > Hi Vasundhara
> > >
> > > How do we get to see something did fail? If it failed, it failed for a
> > > reason, and we want to know.
> > >
> > > What is your real use case here? What is failing, and why are you
> > > O.K. to skip this failure?
> > >
> > >      Andrew
> > Hi Andrew,
> >
> > Thank you for looking into the patch.
> >
> > If any of the devlink parameter is returning error like EINVAL, then
> > current code is not displaying any further parameters for all the other
> > devices as well.
> >
> > In bnxt_en driver case, some of the parameters are not supported in
> > certain configurations like if the parameter is not part of the
> > NVM configuration, driver returns EINVAL error to the stack. And devlink is
> > skipping to display all the remaining parameters for that device and others
> > as well.
> >
> > I am trying to fix to skip only the error parameter and display the remaining
> > parameters.
>
> Hi Vasundhara
>
> Thanks for explaining your use case. It sounds sensible. But i would
> narrow this down.
>
> Make the driver return EOPNOTSUP, not EINVAL. And then in dump, only
> skip EOPNOTSUP. Any other errors cause the error to be returned, so we
> get to see them.
Thank you Andrew, I will modify the patch and resubmit.
>
>    Andrew
