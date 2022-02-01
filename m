Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65D44A6827
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 23:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbiBAWqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 17:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiBAWqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 17:46:45 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1B6C061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 14:46:45 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id z19so36759088lfq.13
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 14:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZB6sZygULvONH287KY9xbyCmvq2QLSmoH4jTsAJE8qE=;
        b=ZKDJtql7NA05u1FVTY6GG02i9d03ssYSRIpXA9b3B5C9OaC9xCd/dcIKWRSql+EipR
         IR2nMqELtUlil4mXNXDdKLO2VSyXGQTEK+n9xXAgBUuxLFdCf4WJ930LM+wRo2Jf9NZa
         P4HGHdFGTF9MI3S8d7vTnsBfrdNUl87gpx/6PR8iwTGS0I9LI+dTOrhTNHsU2gEUNaJd
         XZNAJGoGJ+BsiHgtKr2qPKog0Iqd3o9GgLQ11rrjtVfZMZRlEosXi0RAKz0ZAbz0ByMF
         5YNp2082rPQaR98wRBm8986U3UFSx9zTolozdHkESH66ezgSZ4Rjv+VZ/CMwtm3lvJQl
         3oJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZB6sZygULvONH287KY9xbyCmvq2QLSmoH4jTsAJE8qE=;
        b=25GajSHbt4Tx/f4Rc1hHb/VT9jqMY86rq8axwV9pP18c37WHY7PnZ2mF1vSjpOweaf
         EQffh8eenem4A25fpNThAi8Lo7ZYe8zAvTtYMbZra3+x5gyqHKVU1saXSPBoUC+CUfZd
         s13LN732RZOuerG41QfOxjHVbDs2Sbd5rsKBdZcROVmPWzlmCyuVUCi83gX74aUh9VDn
         AXp3Be6TQo2BbXOv6yaEO4nrBZMKbR1ucNO6aYMB9brJ3k2P/sfNgmv/ieQI9faEOAJk
         WvbNlcNk4RiERpzvoJfgsFGYNYFvId24sBQkNN4qdHJXr/WDssYJOMfCLx3xm+OKUVri
         xSIQ==
X-Gm-Message-State: AOAM533THb3k000uLt06UPKUxu1oDZguqbJDn+smFViGEQ6kppfY/yek
        AQ4yLPrqQm4JAtQWAG2qSWuqyETSlBPAnujhICIa+Q==
X-Google-Smtp-Source: ABdhPJy8vDwNzwEaIeOFhfQo+M8s8+6OPdW3QljaSF0UIWy3xrqGjbVn3CVyx1pcLUx2R3waVBl9XZcgeNt+vnxOlUA=
X-Received: by 2002:a05:6512:3e07:: with SMTP id i7mr18315112lfv.283.1643755603060;
 Tue, 01 Feb 2022 14:46:43 -0800 (PST)
MIME-Version: 1.0
References: <CAG48ez0MHBbENX5gCdHAUXZ7h7s20LnepBF-pa5M=7Bi-jZrEA@mail.gmail.com>
 <20220127181930.355c8c82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220127181930.355c8c82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jann Horn <jannh@google.com>
Date:   Tue, 1 Feb 2022 23:46:16 +0100
Message-ID: <CAG48ez0sa2+eEAnS3UMLmLbDRfM6iC4K3vRcUdA9LpDbSJF0XA@mail.gmail.com>
Subject: Re: [BUG] net_device UAF: linkwatch_fire_event() calls dev_hold()
 after netdev_wait_allrefs() is done
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 3:19 AM Jakub Kicinski <kuba@kernel.org> wrote:
> Interesting..
>
> I don't know what link_reset does, but since it turns the carrier on it
> seems like something that should be flushed/canceled when the device
> goes down. unregister brings the device down under rtnl_lock.
>
> On Fri, 28 Jan 2022 02:51:24 +0100 Jann Horn wrote:
> > Is the bug that usbnet_disconnect() should be stopping &dev->kevent
> > before calling unregister_netdev()?
>
> I'd say not this one, I think the generally agreed on semantics are that
> the netdev is under users control between register and unregister, we
> should not cripple it before unregister.
>
> > Or is the bug that ax88179_link_reset() doesn't take some kind of lock
> > and re-check that the netdev is still alive?
>
> That'd not be an uncommon way to fix this.. taking rtnl_lock, not even
> a driver lock in similar.

Ah, I found a comment with a bit of explanation on how this is
supposed to work... usbnet_stop() explains:

    /* deferred work (task, timer, softirq) must also stop.
     * can't flush_scheduled_work() until we drop rtnl (later),
     * else workers could deadlock; so make workers a NOP.
     */

And usbnet_stop() is ->ndo_stop(), which indeed runs under RTNL.

I wonder what the work items can do that'd conflict with RTNL... or is
the comment just talking about potential issues if a bunch of *other*
work items need RTNL and clog up the system_wq so that
flush_scheduled_work() blocks forever?

If it's the latter case, I guess we could instead do cancel_work_sync() and
then maybe re-run the work function's handler one more time
synchronously?
