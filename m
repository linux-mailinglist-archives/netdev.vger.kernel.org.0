Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 291DD2ABBAA
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 14:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732891AbgKIN24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 08:28:56 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43939 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732305AbgKIN2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 08:28:53 -0500
Received: by mail-ot1-f66.google.com with SMTP id y22so8873031oti.10;
        Mon, 09 Nov 2020 05:28:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zOXXRFEvCqV75KdV8CFiYyzevl63vUlOHU2M7ixFD0c=;
        b=Jw6Vb5mfY61DgAQTk8IsCBKfRmTUTunjo0DIF1Cf0hjctmGP3yo5VuudPGthhZ3Cds
         vw/l979uFDktUIk5Z3B84Ik7GH8paBgeTo9+yRMCBSba2aAjkMrEx9W8/X0nOEhfbT7R
         7ThcZS9ZA6sdltjPGmAoEbC3VONhphk04l0UYAf5Ur2GGV401NIr1Qm8vNAVjkrDXQSs
         3Rbw4DYW/8BTi9Saif7+R0eQYH4R5nO+NEidOQEd74hS8wLV3XD4+DfZmosYi582LtLS
         N1aL9XDoQ0Tnh0kUTolrNrOEwZx0kyz0N+Xo3O7HqquzqG+C6JO1cRbQLR/CvEmbCNQT
         7u9g==
X-Gm-Message-State: AOAM533cRvGC5OoBDZuzUTKVMKzG2aeTJk6Or9shvndpNjtyHJlmEsu0
        eygJ3kYw0lTWuMlyY74a+OvXWFSA8GitoVb28kNX7hTQ
X-Google-Smtp-Source: ABdhPJzFnA1EcNfItKRbj7AfpNPiHbmZp9wKXreocQqaMZEQTaljxw7ROBYGbyId/Ii1edokqLecGcrHTOMZoyWm6ew=
X-Received: by 2002:a9d:16f:: with SMTP id 102mr11010809otu.206.1604928532743;
 Mon, 09 Nov 2020 05:28:52 -0800 (PST)
MIME-Version: 1.0
References: <20201109080938.4174745-1-zhangqilong3@huawei.com>
 <20201109080938.4174745-2-zhangqilong3@huawei.com> <CAJZ5v0gZp_R60FN+ZrKmEn+m0F4yjt_MB+N8uGG=fxKUnZdknQ@mail.gmail.com>
 <d05e3d35a68e41e2ac36acfcd577ad47@huawei.com>
In-Reply-To: <d05e3d35a68e41e2ac36acfcd577ad47@huawei.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 9 Nov 2020 14:28:41 +0100
Message-ID: <CAJZ5v0hpNNAyRuQyMbOE2Lwer_uJbC0uTpnpCBpPNTv54_fxRg@mail.gmail.com>
Subject: Re: [PATCH 1/2] PM: runtime: Add a general runtime get sync operation
 to deal with usage counter
To:     zhangqilong <zhangqilong3@huawei.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 2:24 PM zhangqilong <zhangqilong3@huawei.com> wrote:
>
> Hi
> >
> > On Mon, Nov 9, 2020 at 9:05 AM Zhang Qilong <zhangqilong3@huawei.com>
> > wrote:
> > >
> > > In many case, we need to check return value of pm_runtime_get_sync,
> > > but it brings a trouble to the usage counter processing. Many callers
> > > forget to decrease the usage counter when it failed. It has been
> > > discussed a lot[0][1]. So we add a function to deal with the usage
> > > counter for better coding.
> > >
> > > [0]https://lkml.org/lkml/2020/6/14/88
> > > [1]https://patchwork.ozlabs.org/project/linux-tegra/patch/202005200951
> > > 48.10995-1-dinghao.liu@zju.edu.cn/
> > > Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> > > ---
> > >  include/linux/pm_runtime.h | 32 ++++++++++++++++++++++++++++++++
> > >  1 file changed, 32 insertions(+)
> > >
> > > diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
> > > index 4b708f4e8eed..2b0af5b1dffd 100644
> > > --- a/include/linux/pm_runtime.h
> > > +++ b/include/linux/pm_runtime.h
> > > @@ -386,6 +386,38 @@ static inline int pm_runtime_get_sync(struct device
> > *dev)
> > >         return __pm_runtime_resume(dev, RPM_GET_PUT);  }
> > >
> > > +/**
> > > + * gene_pm_runtime_get_sync - Bump up usage counter of a device and
> > resume it.
> > > + * @dev: Target device.
> >
> > The force argument is not documented.
>
> (1) Good catch, I will add it in next version.
>
> >
> > > + *
> > > + * Increase runtime PM usage counter of @dev first, and carry out
> > > + runtime-resume
> > > + * of it synchronously. If __pm_runtime_resume return negative
> > > + value(device is in
> > > + * error state) or return positive value(the runtime of device is
> > > + already active)
> > > + * with force is true, it need decrease the usage counter of the
> > > + device when
> > > + * return.
> > > + *
> > > + * The possible return values of this function is zero or negative value.
> > > + * zero:
> > > + *    - it means success and the status will store the resume operation
> > status
> > > + *      if needed, the runtime PM usage counter of @dev remains
> > incremented.
> > > + * negative:
> > > + *    - it means failure and the runtime PM usage counter of @dev has
> > been
> > > + *      decreased.
> > > + * positive:
> > > + *    - it means the runtime of the device is already active before that. If
> > > + *      caller set force to true, we still need to decrease the usage
> > counter.
> >
> > Why is this needed?
>
> (2) If caller set force, it means caller will return even the device has already been active
> (__pm_runtime_resume return positive value) after calling gene_pm_runtime_get_sync,
> we still need to decrease the usage count.

But who needs this?

I don't think that it is a good idea to complicate the API this way.
