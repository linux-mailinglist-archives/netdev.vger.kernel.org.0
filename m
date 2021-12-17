Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C51478F06
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 16:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbhLQPHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 10:07:46 -0500
Received: from mail-oi1-f174.google.com ([209.85.167.174]:36836 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237855AbhLQPHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 10:07:46 -0500
Received: by mail-oi1-f174.google.com with SMTP id t23so4021160oiw.3;
        Fri, 17 Dec 2021 07:07:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MbOJyx0ICqsDBsXqhrfTxawCvgzjFoYCCHF95Prip3E=;
        b=RiDhcJMb78rRzBLmIxbP5OkQydXAjBA72RxB29xIUOpt1mXMykSZn6mCckNHkEwzPS
         GQL6J66SU4X75b91WK8HeCgtaez2TjJ/UHOwXgM9pWI9r465Fa3ngUdKo7Wgi10hP/OH
         KJKPS7UFIlQcHRrzfuY0NEinyMSUZQ4kUMv9Rw/X+E83fK1vnoWLi6Pu7FLYakRTLL3C
         BlLNslq2d/KjdxmHx9U2FPiiNCiTmyBwaWNqAoGuUzEf3PshovvpbkdmYUvlYQ+5a8f2
         2adkXUHo7sCIdUmoOv95OLzz5PSm9jMQfaHByvrunQRggT5jh50ikMh0pnensDt8ZShN
         fxvA==
X-Gm-Message-State: AOAM530SqCgXXA5nr1fq7vrgA/2WPyVOdewp9Kb/pm94JEkEV166MCzs
        vLzRjXV0adm3p+Usa3xEiZNIL3DAIZukZfGc5vE=
X-Google-Smtp-Source: ABdhPJzIcKm353itWUd26MvND37q/kv/4/a54huG34fc7b6KcS+FdmapZEPP8pthrG9sJ/xgldU8kp89r2g0YypaCFQ=
X-Received: by 2002:aca:eb0b:: with SMTP id j11mr8185991oih.51.1639753665410;
 Fri, 17 Dec 2021 07:07:45 -0800 (PST)
MIME-Version: 1.0
References: <20211207002102.26414-1-paul@crapouillou.net> <CAK8P3a3xfuFN+0Gb694R_W2tpC7PfFEFcpsAyPdanqZ6FpVoxQ@mail.gmail.com>
In-Reply-To: <CAK8P3a3xfuFN+0Gb694R_W2tpC7PfFEFcpsAyPdanqZ6FpVoxQ@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 17 Dec 2021 16:07:34 +0100
Message-ID: <CAJZ5v0jifFWLJgjJywGrjWgE9ZQkjD03rQDHw+4YL-VzkfL1Hg@mail.gmail.com>
Subject: Re: [PATCH 0/5] Rework pm_ptr() and *_PM_OPS macros
To:     Arnd Bergmann <arnd@arndb.de>, Paul Cercueil <paul@crapouillou.net>
Cc:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
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

On Tue, Dec 7, 2021 at 10:22 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Tue, Dec 7, 2021 at 1:20 AM Paul Cercueil <paul@crapouillou.net> wrote:
> >
> > This patchset reworks the pm_ptr() macro I introduced a few versions
> > ago, so that it is not conditionally defined.
> >
> > It applies the same treatment to the *_PM_OPS macros. Instead of
> > modifying the existing ones, which would mean a 2000+ patch bomb, this
> > patchset introduce two new macros to replace the now deprecated
> > UNIVERSAL_DEV_PM_OPS() and SIMPLE_DEV_PM_OPS().
> >
> > The point of all of this, is to progressively switch from a code model
> > where PM callbacks are all protected behind CONFIG_PM guards, to a code
> > model where PM callbacks are always seen by the compiler, but discarded
> > if not used.
> >
> > Patch [4/5] and [5/5] are just examples to illustrate the use of the new
> > macros. As such they don't really have to be merged at the same time as
> > the rest and can be delayed until a subsystem-wide patchset is proposed.
> >
> > - Patch [4/5] modifies a driver that already used the pm_ptr() macro,
> >   but had to use the __maybe_unused flag to avoid compiler warnings;
> > - Patch [5/5] modifies a driver that used a #ifdef CONFIG_PM guard
> >   around its suspend/resume functions.
>
> This is fantastic, I love the new naming and it should provide a great path
> towards converting all drivers eventually. I've added the patches to
> my randconfig test build box to see if something breaks, but otherwise
> I think these are ready to get into linux-next, at least patches 1-3,
> so subsystem
> maintainers can start queuing up the conversion patches once the
> initial set is merged.
>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Patches [0-3/5] applied as 5.17 material.

The mmc patches need ACKs, but I can take them too.
