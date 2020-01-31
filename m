Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8218214E8F9
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 07:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbgAaG4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 01:56:49 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44901 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgAaG4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 01:56:48 -0500
Received: by mail-lf1-f65.google.com with SMTP id v201so4061144lfa.11
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 22:56:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dgHAL/b3H25F9Kmx9hlQ4Nh6RfK5rJn2yUGqAi/ncBk=;
        b=a2IsS0zknbBg6CdNwWDJU3HFktms+9xOSGaJYNih2A7T0dkdkmQSW46HNV5vlRfcRE
         Tt+P9JVFwm97WNuzIDc9VyVjDcvJZw8sKRZRasohvFcNu9EirYfOBMsPIyARoDFcfzut
         kdV1UKg7/Zw58zW6MslJBTrJDbp+EHsQinJiu7LvnJNXH4hoIKjQo75tSK1ByQ6NFtr2
         rJZwCzByEbVsC5SdoHfx+olqnkQ8xTx5eyQpT+dsHlK34cPWomM7MVwkXfGQWnKiwv/0
         kVyqfbXhr8LKPjKuSwtvhkvA+qnznL6sXuH+6f2KQKhyYT3l5OhnDhmUlx/eMnIU5KfK
         6Upw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dgHAL/b3H25F9Kmx9hlQ4Nh6RfK5rJn2yUGqAi/ncBk=;
        b=dTwr8ITkd5EGLwub2FHIlKMxdsZPPVVpHKCvkxQ0dsXQzmyCI3lssosAMQUw2cQhS+
         uDnf6MiF1qLbEmx2DjUJ0WJLWl7c2kXqhGhl8lSTsoYgFiw3fktJ3lu+axQ6JEi7TNF7
         4kDyv5ZSQ52gDtsax+Gyhng0M+Sa6ODXOSI9TSDqrJlfttLA1qOSdm13BdxQyTW1oNxl
         pDFDMzNgsGxbB7zMlG/fzN7FTfBg9umd+M5eFhh5aU75JHCOPG+MuRo8eTsoQT/uvQEi
         G4LRYSBsxgAce0yPlitavhXqAtOPECsmGGc31g0MvlI4DOmKRBd40vCAi0ohbJ9LtMls
         ZQTw==
X-Gm-Message-State: APjAAAVcBKO+V35tsAby985cM21gFL3usMyf0YZlYFk24MUrTgXwKfgZ
        +03UmAfXgAKo/esTpyunQ8iqAnTCNBzFzEqg3M85yXOz
X-Google-Smtp-Source: APXvYqyNb9nbs8PHwV1ohRbIuBuzDt7Zpt4fevnU1NBTFfxg6RhKCQOnsFSuMN6BZtFGYWYiuwSDZVzHKu/LzdV0New=
X-Received: by 2002:ac2:5509:: with SMTP id j9mr4595589lfk.135.1580453806958;
 Thu, 30 Jan 2020 22:56:46 -0800 (PST)
MIME-Version: 1.0
References: <20200127142957.1177-1-ap420073@gmail.com> <20200127065755.12cf7eb6@cakuba>
 <CAMArcTV9bt7SEo2010JBUj3DQAakFmkHD3hWTiMj-0kW+RVXDQ@mail.gmail.com> <20200130094459.22649bb8@cakuba>
In-Reply-To: <20200130094459.22649bb8@cakuba>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Fri, 31 Jan 2020 15:56:35 +0900
Message-ID: <CAMArcTXoA8=r0ARzToDhHgyVMco2EP-mE7Wmn2XVjbtZ55sCKg@mail.gmail.com>
Subject: Re: [PATCH net v2 1/6] netdevsim: fix race conditions in netdevsim operations
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 at 02:45, Jakub Kicinski <kuba@kernel.org> wrote:
>

Hi Jakub,

> On Fri, 31 Jan 2020 00:09:43 +0900, Taehee Yoo wrote:
> > > > @@ -99,6 +100,8 @@ new_port_store(struct device *dev, struct device_attribute *attr,
> > > >       unsigned int port_index;
> > > >       int ret;
> > > >
> > > > +     if (!nsim_bus_dev->init)
> > > > +             return -EBUSY;
> > >
> > > I think we should use the acquire/release semantics on those variables.
> > > The init should be smp_store_release() and the read in ops should use
> > > smp_load_acquire().
> >
> > Okay, I will use a barrier for the 'init' variable.
> > Should a barrier be used for 'enable' variable too?
> > Although this value is protected by nsim_bus_dev_list_lock,
> > I didn't use the lock for this value in the nsim_bus_init()
> > because I thought it's enough.
>
> To be clear I think the code as you wrote it would behave correctly
> (it's reasonable to expect that the call to driver_register() implies
> a barrier).
>
> > How do you think about this? Should lock or barrier is needed?
>
> IMO having both of the flag variables have the load/store semantics
> (that's both 'init' and 'enable') is just less error prone and easier
> to understand.
>
> And then the locks can go back to only protecting the lists, I think.

I will try to test it then send a v3 patch.
Thank you!
Taehee Yoo
