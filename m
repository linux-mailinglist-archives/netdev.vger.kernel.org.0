Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7351479402
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236660AbhLQSWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:22:47 -0500
Received: from mail-ot1-f52.google.com ([209.85.210.52]:43883 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhLQSWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 13:22:46 -0500
Received: by mail-ot1-f52.google.com with SMTP id i5-20020a05683033e500b0057a369ac614so3899522otu.10;
        Fri, 17 Dec 2021 10:22:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iacQ2xq7pRu5pLbunKAx9x9AO22U2fvGNMTvcbJAoKY=;
        b=xNn7oJtx0QjRWUCdgwuB43GTlFjTn4zTtquTx4SiQNsWPI9OfuRsBu5A91yq8tSV2q
         9Se1qyfWUBqtj3/mfIRDuCeQuHlAcknVmqCzyKYRSvaURGHgULw6lLk0enhQvGZSa/CI
         NF+2hd2Nwk3o+NDnVp1IqTLFX4iYzXPvrLLAldXuws1XZudaUW9u4rWWuZaEL9FC0j9o
         wwBu7NjDnHKwc4ahvdVOCyGN4ESXMqcz9JpBr/uiw9VrkNlQ6wQtXvEJEcKmHJbqCU+H
         FT2xDEBmglUELXCp3Cm/yKXKG+9EtT0nPai2hCWA1ME9yFhNh5pn3miz7B4Ctz0iCWJE
         5DuA==
X-Gm-Message-State: AOAM533n71aqDiVHAXFQSUCYduFrwrbwAYvy0U8s6qwogD0r61lVhp1A
        KmPDlzW7ib3zhok0tman98r7knlaXbkuLIOyPzI=
X-Google-Smtp-Source: ABdhPJxI12wARVUILH+ZCGLckVXEelIiMxBOxUhxY5dsu5jdzrnldizgAKVR1BVlGzCjq6KhCfNfsa2ikGJ0LMJBTng=
X-Received: by 2002:a05:6830:348f:: with SMTP id c15mr3179707otu.254.1639765365912;
 Fri, 17 Dec 2021 10:22:45 -0800 (PST)
MIME-Version: 1.0
References: <20211207002102.26414-1-paul@crapouillou.net> <CAK8P3a3xfuFN+0Gb694R_W2tpC7PfFEFcpsAyPdanqZ6FpVoxQ@mail.gmail.com>
 <CAJZ5v0jifFWLJgjJywGrjWgE9ZQkjD03rQDHw+4YL-VzkfL1Hg@mail.gmail.com> <CAPDyKFpfWZsw+7aZdQVsCsTxoEfUqpkZM6Ozfr5COQNNaqhLhA@mail.gmail.com>
In-Reply-To: <CAPDyKFpfWZsw+7aZdQVsCsTxoEfUqpkZM6Ozfr5COQNNaqhLhA@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 17 Dec 2021 19:22:34 +0100
Message-ID: <CAJZ5v0gqVtOhrC72ey8hPSCuP+DfHJk2qK_pemvpmHGLvPSFRQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] Rework pm_ptr() and *_PM_OPS macros
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Paul Cercueil <paul@crapouillou.net>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Jonathan Cameron <jic23@kernel.org>, list@opendingux.net,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 6:17 PM Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> On Fri, 17 Dec 2021 at 16:07, Rafael J. Wysocki <rafael@kernel.org> wrote:
> >
> > On Tue, Dec 7, 2021 at 10:22 AM Arnd Bergmann <arnd@arndb.de> wrote:
> > >
> > > On Tue, Dec 7, 2021 at 1:20 AM Paul Cercueil <paul@crapouillou.net> wrote:
> > > >
> > > > This patchset reworks the pm_ptr() macro I introduced a few versions
> > > > ago, so that it is not conditionally defined.
> > > >
> > > > It applies the same treatment to the *_PM_OPS macros. Instead of
> > > > modifying the existing ones, which would mean a 2000+ patch bomb, this
> > > > patchset introduce two new macros to replace the now deprecated
> > > > UNIVERSAL_DEV_PM_OPS() and SIMPLE_DEV_PM_OPS().
> > > >
> > > > The point of all of this, is to progressively switch from a code model
> > > > where PM callbacks are all protected behind CONFIG_PM guards, to a code
> > > > model where PM callbacks are always seen by the compiler, but discarded
> > > > if not used.
> > > >
> > > > Patch [4/5] and [5/5] are just examples to illustrate the use of the new
> > > > macros. As such they don't really have to be merged at the same time as
> > > > the rest and can be delayed until a subsystem-wide patchset is proposed.
> > > >
> > > > - Patch [4/5] modifies a driver that already used the pm_ptr() macro,
> > > >   but had to use the __maybe_unused flag to avoid compiler warnings;
> > > > - Patch [5/5] modifies a driver that used a #ifdef CONFIG_PM guard
> > > >   around its suspend/resume functions.
> > >
> > > This is fantastic, I love the new naming and it should provide a great path
> > > towards converting all drivers eventually. I've added the patches to
> > > my randconfig test build box to see if something breaks, but otherwise
> > > I think these are ready to get into linux-next, at least patches 1-3,
> > > so subsystem
> > > maintainers can start queuing up the conversion patches once the
> > > initial set is merged.
> > >
> > > Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> >
> > Patches [0-3/5] applied as 5.17 material.
> >
> > The mmc patches need ACKs, but I can take them too.
>
> Sure, please add my ack for them!

Both applied as 5.17 material with your ACKs, thanks!
