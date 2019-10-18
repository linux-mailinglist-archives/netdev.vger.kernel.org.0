Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 904D9DC720
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 16:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410294AbfJROSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 10:18:37 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40114 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732676AbfJROSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 10:18:37 -0400
Received: by mail-qt1-f196.google.com with SMTP id o49so1458647qta.7;
        Fri, 18 Oct 2019 07:18:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OLiSW1jPhrfJpL7J2ChNokt+HsZ5l6CdeBUkdRu8tgI=;
        b=TBveMF19LhielilHg0AoAg4+K+roqfboErkW3EZRgu4YI5/9zg+aqTStcVO+YypqV4
         nRDZk/piIYfWGZ+fp2HGptc1NSfL8lar9AyiwWZ4qgXcAZjgnKcfSCHIApZARO+SBMar
         h/fddCmvRkzcn2Qjkq8GnZcQcmW/2UqbxOf/ww8YvboTcsbRlv4gNt6QAjoFn5eClNK/
         O5JFlEUDK9LzolIJb6SQduSJ19qMXx1ZdXbtdy/OjARddKQe4M7RkNV8mJ07LNVoRQHt
         AJgTJGo1mvOJS2pxQP1uys+hjy4cKXBUwtWdAl5JOEG2qgb30nAo4JkdOkVXYKv7yWpB
         ALrA==
X-Gm-Message-State: APjAAAV0ml7r9IQ/wyAYDxZwpdSslmrMypp21l8j2jIC7OlAy2DuvWA1
        B8ic178vNUjurZ3/yxH7rVhkSVeky2cNM5NV3thM7A==
X-Google-Smtp-Source: APXvYqwUNC10IHjYhGYMZPP/MmDp7/JcJCuP9HHh1sJXpI/WPpXPbrgxj4jvMWTEkThythJ+jUYtkhVJ/IhuzQHABWY=
X-Received: by 2002:ac8:38e3:: with SMTP id g32mr10144867qtc.304.1571408315568;
 Fri, 18 Oct 2019 07:18:35 -0700 (PDT)
MIME-Version: 1.0
References: <20191009190853.245077-1-arnd@arndb.de> <20191009191044.308087-16-arnd@arndb.de>
 <20ef0181f615a6dfe8698afb52597164d74f8637.camel@codethink.co.uk>
In-Reply-To: <20ef0181f615a6dfe8698afb52597164d74f8637.camel@codethink.co.uk>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 18 Oct 2019 16:18:19 +0200
Message-ID: <CAK8P3a3xOo6ccFbSmZNZs+9Z42oREx+gAObxDiwTQPujndEBBw@mail.gmail.com>
Subject: Re: [Y2038] [PATCH v6 16/43] compat_ioctl: move isdn/capi ioctl
 translation into driver
To:     Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Karsten Keil <isdn@linux-pingi.de>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        isdn4linux@listserv.isdn4linux.de,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 8:25 PM Ben Hutchings
<ben.hutchings@codethink.co.uk> wrote:
>
> On Wed, 2019-10-09 at 21:10 +0200, Arnd Bergmann wrote:
> [...]
> > --- a/drivers/isdn/capi/capi.c
> > +++ b/drivers/isdn/capi/capi.c
> > @@ -950,6 +950,34 @@ capi_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> >       return ret;
> >  }
> >
> > +#ifdef CONFIG_COMPAT
> > +static long
> > +capi_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> > +{
> > +     int ret;
> > +
> > +     if (cmd == CAPI_MANUFACTURER_CMD) {
> > +             struct {
> > +                     unsigned long cmd;
>
> Should be u32?

Good catch, changed to compat_ulong_t now.

Thanks,

      Arnd
