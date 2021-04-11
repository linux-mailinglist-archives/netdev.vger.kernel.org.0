Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E9235B6FF
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 23:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbhDKVXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 17:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235338AbhDKVXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 17:23:52 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34651C061574
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 14:23:33 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id z1so12825034ybf.6
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 14:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s6wkbqBA5jKWZN4q21yFCGp918hjP1L7ivFeYGjBOqQ=;
        b=Oa0ZMgio6Z9baxTPoSl6M1bPnIC/KoXwqmD93MdVLOcBNx76z186BfpzBKrkRFvqo1
         VrdvVi8lEsMAN1ALzS5dRjHYuBfTLN3oSYELdmJg+TKlvVLhqSucgga/kFE1Oh0akApz
         XmbGwae/WmP2OoAiD6r/+tZoLAMk8y2QSDz1ilXs1MA6HPIGHMO7V0IV+GT3quS5qFSY
         l828/nm4v713WheizgsfWEnC6Xe6uYbWYLq0k8o9INX/dR+WtGg+Hp05XEDsnYgaAy/s
         3C9XHeAghZ/fTtWMs7bowBTDnO8qpDwn987ZYgPC0I6e/XTz9Iv3NqqP2m/U682OWKE6
         igrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s6wkbqBA5jKWZN4q21yFCGp918hjP1L7ivFeYGjBOqQ=;
        b=T6sCUDfcpjXS6d+6E31VodMLwgsqWLs/yc4jLqIG/r9AszPENmrQcj12HpYioq9ejR
         JDSXrz7rrEadTC3MJ0Tjz7+pf6G08CU2B2BE1fVi91DNIoqcNAYOWIzV0AgShZMr5Sle
         zc55yKVkK+EKy6ASKCvhrmCdGfNkAoLgsLGaJkPsOZQeWq8Btr1mAjgYVqg7XuGTNfvC
         GYy/WWjf1AeJw+3zoyu0go8b2Avn2gO61+s1DjuF+lfWuK35j13Ik6LhcFMHt8alBIrD
         ESik+qSyUyVOOXtt6eJWNUWC1cx3pb57/7foQYX3ikOTsI2y8vySCg6gvmMxcLMrCyEf
         lKNw==
X-Gm-Message-State: AOAM533MticN5x3cDFCf86uHmd6jNiApLAPlKQrA5+uiKMfVWgaGXmZ2
        T5IuT/6zBl+ConwwLtQEgUe4OYOLnJ75aOTLe23pHw==
X-Google-Smtp-Source: ABdhPJxu+cegXOLCQP6ej753YV30YyK7KGcm6ddWduFIt3Nzk7J7ZQUUrWIBdXA3Xj16yXYHsaRk/MAcgAsLqO4qu80=
X-Received: by 2002:a25:7e01:: with SMTP id z1mr35375662ybc.253.1618176212047;
 Sun, 11 Apr 2021 14:23:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210402132602.3659282-1-eric.dumazet@gmail.com>
 <20210411134329.GA132317@roeck-us.net> <CANn89iJ+RjYPY11zUtvmMkOp1E2DKLuAk2q0LHUbcJpbcZVSjw@mail.gmail.com>
 <0f63dc52-ea72-16b6-7dcd-efb24de0c852@roeck-us.net>
In-Reply-To: <0f63dc52-ea72-16b6-7dcd-efb24de0c852@roeck-us.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 11 Apr 2021 23:23:20 +0200
Message-ID: <CANn89iJa8KAnfWvUB8Jr8hsG5x_Amg90DbpoAHiuNZigv75MEA@mail.gmail.com>
Subject: Re: [PATCH net] virtio_net: Do not pull payload in skb->head
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 10:37 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 4/11/21 8:06 AM, Eric Dumazet wrote:
> > On Sun, Apr 11, 2021 at 3:43 PM Guenter Roeck <linux@roeck-us.net> wrote:
> >
> >> This patch causes a virtio-net interface failure when booting sh4 images
> >> in qemu. The test case is nothing special: Just try to get an IP address
> >> using udhcpc. If it fails, udhcpc reports:
> >>
> >> udhcpc: started, v1.33.0
> >> udhcpc: sending discover
> >> FAIL
> >>
> >
> > Can you investigate where the incoming packet is dropped ?
> >
>
> Unless I am missing something, packets are not dropped. It looks more
> like udhcpc gets bad indigestion in the receive path and exits immediately.
> Plus, it doesn't happen all the time; sometimes it receives the discover
> response and is able to obtain an IP address.
>
> Overall this is quite puzzling since udhcpc exits immediately when the problem
> is seen, no matter which option I give it on the command line; it should not
> really do that.


Could you strace both cases and report differences you can spot ?

strace -o STRACE -f -s 1000 udhcpc
