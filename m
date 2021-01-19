Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFE72FC53D
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 01:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730828AbhASX6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395010AbhASNzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 08:55:19 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F26C061575;
        Tue, 19 Jan 2021 05:54:38 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id n7so13015549pgg.2;
        Tue, 19 Jan 2021 05:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dQsO/EmArEXp+xjehbwD5uyX9Cu3rc2d/LRGhvZR/k8=;
        b=vBLoNsMrixsho9dWLeOk5XJtNqAlJe56Fl9QpxEDu+8FbtZ+/0VskFPPFkJ8IMwRI8
         U9bIsWm84ywa51T/l6zC2/2IFgyL/Sqf9EXE6+sPLbWouPcDh0JQem7h82xcbvNa16TC
         OK0Ykmft7oJZYZdskwr5ZekjNi9O4/7qOrubT6elo++Ve1F/Ycoot+WPkMYKHp5+Rm3p
         JmyQNrG91ck7BiaERcYjAlNI9WYLksiA49NeAtUsI3+jGdXDBUQlHYpwx4yJC70zYN0w
         lB27sxCA9jybvzX11QMe+68u6u1ByxAsg+1zwJFXtn9cIes79J7w9D8aJ/3JVvUYd9y8
         Q11g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dQsO/EmArEXp+xjehbwD5uyX9Cu3rc2d/LRGhvZR/k8=;
        b=fd7H1GlMACK6m4LnDMZ6s/j8pFDlUDrwgWVH7atPSaCs3UbGO5jAsyMLqmuNuYRaic
         Ee38aGpBkjUB6vaJzS1WCE1Ua25qcSFK0DJitkdPsvUktn2SINhIjcpl2VtBhBupZrG0
         FvopL0IVAfbXtZ9yfcrcgpP4u7dWNpHOdzDxRW9VXd4iIlKRAkfwH8ivMr22WMugcXCl
         8iXdqn9NBs8humJGvWBXI67+byEuhiuhQe7WN02NurIJdEWNmiCJd3MCACxx6PJNbW6M
         7GG0gFAckgBqjSBNr3M8UBBBC/24MH3TL3uD5wkmZ4XOfnjA13acOXtPv/eg9SdjYD5i
         e2bQ==
X-Gm-Message-State: AOAM532ehqbDksdfwawqw9zqoXmM22hKHwvQshl4ONZsCprbJtB/8852
        c6OSHv18Rx5CqqVSXx2cVPoKauUWCgvLnhcDyNQ=
X-Google-Smtp-Source: ABdhPJwwNxR/gEbvF4slzl8eUnH0gi1BdK4y4umdmBIZmrOtRnhHWeKEyy6/ciK9zsTXnxrf+OEszR7ovrnirQ69+k4=
X-Received: by 2002:a65:4783:: with SMTP id e3mr4539691pgs.368.1611064477480;
 Tue, 19 Jan 2021 05:54:37 -0800 (PST)
MIME-Version: 1.0
References: <20210117224750.6572-1-xie.he.0141@gmail.com> <6fb2a40bf347997416cd38454d1b194a@dev.tdt.de>
In-Reply-To: <6fb2a40bf347997416cd38454d1b194a@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 19 Jan 2021 05:54:26 -0800
Message-ID: <CAJht_EMYEvcsOn6QGxGFBeR288ep+vJNxJVan48R8mEoVaVpUg@mail.gmail.com>
Subject: Re: [PATCH net v2] net: lapb: Add locking to the lapb module
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 3:34 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> > 4. In lapb_device_event, replace the "lapb_disconnect_request" call
> > with
> > the content of "lapb_disconnect_request", to avoid trying to hold the
> > lock twice. When I do this, I removed "lapb_start_t1timer" because I
> > don't think it's necessary to start the timer when "NETDEV_GOING_DOWN".
>
> I don't like the code redundancy this creates. Maybe you should move the
> actual functionality from lapb_disconnect_request() to a
> __lapb_disconnect_request(), and in lapb_disconnect_request() call this
> function including locking around it and also in lapb_device_event
> (without locking).
>
> Calling lapb_start_t1timer() on a "NETDEV_GOING_DOWN" event does not
> hurt and is correct from a protocol flow point of view after sending
> the DISC.

Thanks! I created a new __lapb_disconnect_request function and the
code indeed looked cleaner. I'll send a new version.
