Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB4BA15CBA8
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 21:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgBMUHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 15:07:34 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:39243 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727797AbgBMUHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 15:07:33 -0500
Received: by mail-yw1-f68.google.com with SMTP id h126so3196931ywc.6
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 12:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RuEdZ1XS/zxxsQBPs6EHYYJV5Z0QMXb/LLDf01NLX2E=;
        b=as0+dXYlbZ8odWoL1fK9PxUAJKLhXX8BamttY7y88w8KagJY2wl3ZZqhoST+gV0cx3
         0jCywvd6cT5CEo4zXNvny48bsjZnxbyESllSgJzamP4TKdRz84HPWBCEXK5RkbfSNF1N
         oR1guKZdNe1Zcn0iThGkwxXjaynF50u6CgXOgqYyO+vF41v0nqRq7g2U9thmDnr6x/rs
         CM42XiY0JiccxcpUbvKVN0akF163Doo+2h0fCjCwdqoLtq93FRUp1TIrimq24c6SrVqE
         sCFBwLmT2iB/FjltJoplINhJNJ8vGtlMxHPpfGaVZmNWnNnPXpUHf6L6gC0PLamL9N9G
         cfTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RuEdZ1XS/zxxsQBPs6EHYYJV5Z0QMXb/LLDf01NLX2E=;
        b=dl1pNxlCnOStoRvwO1R65pfnPYJ9hFoh3pKDg9CHyFwsbwfCBo0BpKYz6+I4DM/Xmw
         49XQxuZMqy3/t09Am3I/d/RHiT3K394PwDoUMt65vATTnYDGGdN/ibXVohJjRUN5qRh4
         guDggcRQU9OItqfEtCfArpPuwORK2/jNoM1rSii3dNAXE65tKfelzTq2XYWLPo918USh
         gyNCZy0MkKxhYjMMKAmQdAilkSYgWZaVOVrkEX2i3QFD8o5ok6qRh+rAC5+jHBiyPPRR
         xTjr3Z2HUxknESNoWxtUFTcmCBWwsskeCVVGwaiFyiQEb+5iBDW+omOA5fZr31HD2gsC
         nLdg==
X-Gm-Message-State: APjAAAWP8Xrg/T90yIHS9wsLANr3AGYNSvxctGnv83s1bopvVgoY3Ko6
        obFQm1QKa5WcIo+ylX21KugEzcTpG2GQzzIvMSw=
X-Google-Smtp-Source: APXvYqxBsrzdVhYVeVXzIPQm/1Ku9Kyfo3zU3lCOCv6L8PuHMym/cgiOwA+1N5Wq7uKwMSL0FPdbjt2AgV36fY3/6Io=
X-Received: by 2002:a81:7a52:: with SMTP id v79mr16657916ywc.474.1581624451552;
 Thu, 13 Feb 2020 12:07:31 -0800 (PST)
MIME-Version: 1.0
References: <20200213165407.60140-1-ogerlitz@mellanox.com> <20200213103228.2123025f@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200213103228.2123025f@kicinski-fedora-PC1C0HJN>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Thu, 13 Feb 2020 22:07:19 +0200
Message-ID: <CAJ3xEMjs0viZ6X5mkouSjcZrLNWwxVfxfffN=c1FuGK8MH8kDA@mail.gmail.com>
Subject: Re: [PATCH net] net/tls: Act on going down event
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Or Gerlitz <ogerlitz@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 8:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 13 Feb 2020 16:54:07 +0000 Or Gerlitz wrote:
> > By the time of the down event, the netdevice stop ndo was
> > already called and the nic driver is likely to destroy the HW
> > objects/constructs which are used for the tls_dev_resync op.

>> @@ -1246,7 +1246,7 @@ static int tls_dev_event(struct notifier_block *this, unsigned long event,
> > -     case NETDEV_DOWN:
> > +     case NETDEV_GOING_DOWN:

> Now we'll have two race conditions. 1. Traffic is still running while
> we remove the connection state. 2. We clean out the state and then
> close the device. Between the two new connections may be installed.
>
> I think it's an inherently racy to only be able to perform clean up
> while the device is still up.

good points, I have to think on both of them and re/sync (..) with
the actual design details here, I came across this while working
on something else which is still more of a research so just throwing
a patch here was moving too fast.

Repeating myself -- by the time of the down event, the netdevice
stop ndo was already called and the nic driver is likely to destroy
HW objects/constructs which are used for the tls_dev_resync op.

For example suppose a NIC driver uses some QP/ring to post resync
request to the HW and these rings are part of the driver's channels and
the channels are destroyed when the stop ndo is called - the tls code
here uses RW synchronization between invoking the resync driver op
to the down event handling. But the down event comes only after these
resources were destroyed, too late. If we will safely/stop the offload
at the going down stage, we can avoid a much more complex and per nic
driver locking which I guess would be needed to protect against that race.

thoughts?


- so here's
the point -- the driver resync op may use some HW


>
> >               return tls_device_down(dev);
> >       }
> >       return NOTIFY_DONE;
