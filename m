Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4A799F8A
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 21:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403806AbfHVTMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 15:12:02 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34442 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732147AbfHVTMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 15:12:01 -0400
Received: by mail-qt1-f194.google.com with SMTP id q4so8970757qtp.1;
        Thu, 22 Aug 2019 12:12:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fb2qwZYsSzxhGRR5mo2zpxAtspNTusEf9sR5Gv8Wr0w=;
        b=pbxKW2Wq8ozKXk1AjQ0mKJp6ifr7KAHxIaLtad7RSOq9eHi42/Pz7fgajmpFp7nr/p
         ew30UMH3oZfrK15Tip2g3tkZlKEGRNTflzUC1wd+fHZeKolMNjYsW+EP4QdyTZlqaWL7
         VzsPQF69g9dCK+2mVWTOtrBgTv0BxmsXerNVMU5HRKDsKGu5GaOaEYATkn37qrijuuU9
         OixFqWrjuAPbhOihNA4oeRf6Msl4iv6n7P5U/j7lNGAHvEeUgGkHGxK0vY9Tj37vVZrV
         l8549p7C7NuBT173DIBnSvW3jHYbCo+fVAGHSVUb/MmDVhGhJtC8Hb29QOSbLrNoH0v7
         H23Q==
X-Gm-Message-State: APjAAAWnsoRAp2dNirUbtJQ98JjiAhQGagEFm3/HycQDzY1WVaKIQNcQ
        R1kO8vwTW2zB5FTz5mwrk66UtkABvEAdbM8SrVE=
X-Google-Smtp-Source: APXvYqx1AMqI9CgyyZgqTV3YCcQ8BJ60y0NK4/Q/PHkzZ0zdX2ddG7itfNLle3CCeAzbO68hX/6eptJKTEUE5tWG7Ig=
X-Received: by 2002:ac8:f99:: with SMTP id b25mr1258325qtk.142.1566501120558;
 Thu, 22 Aug 2019 12:12:00 -0700 (PDT)
MIME-Version: 1.0
References: <1566461871-21992-1-git-send-email-ayal@mellanox.com>
 <20190822140635.GH13020@lunn.ch> <20190822174037.GA18030@splinter>
In-Reply-To: <20190822174037.GA18030@splinter>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 22 Aug 2019 21:11:42 +0200
Message-ID: <CAK8P3a2mQHvQKzWSKofBPdzFDTZq9oJkDHqR2PR85Hswocy45g@mail.gmail.com>
Subject: Re: [net] devlink: Add method for time-stamp on reporter's dump
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Aya Levin <ayal@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 7:40 PM Ido Schimmel <idosch@idosch.org> wrote:
> On Thu, Aug 22, 2019 at 04:06:35PM +0200, Andrew Lunn wrote:
> > On Thu, Aug 22, 2019 at 11:17:51AM +0300, Aya Levin wrote:
> > > When setting the dump's time-stamp, use ktime_get_real in addition to
> > > jiffies. This simplifies the user space implementation and bypasses
> > > some inconsistent behavior with translating jiffies to current time.
> >
> > Is this year 2038 safe? I don't know enough about this to answer the
> > question myself.
>
> Good point. 'struct timespec' is not considered year 2038 safe and
> unfortunately I recently made the mistake of using it to communicate
> timestamps to user space over netlink. :/ The code is still in net-next,
> so I will fix it while I can.
>
> Arnd, would it be acceptable to use 'struct __kernel_timespec' instead?

The in-kernel representation should just use 'timespec64' if you need
separate seconds and nanoseconds, you can convert that to
__kernel_timespec while copying to user space.

However, please consider two other points:

- for simplicity, the general recommendation is to use 64-bit nanoseconds
  without separate seconds for timestamps
- instead of CLOCK_REALTIME, you could use CLOCK_MONOTONIC
  timestamps that are not affected by clock_settime() or leap second jumps.

      Arnd
