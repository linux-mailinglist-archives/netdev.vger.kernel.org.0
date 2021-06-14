Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825493A67BA
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 15:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhFNNZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbhFNNZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 09:25:14 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8B0C061574;
        Mon, 14 Jun 2021 06:23:11 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id w21so46411846edv.3;
        Mon, 14 Jun 2021 06:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=RUx64tq9BpIwVZt1SvBA673QJ3mEok3gmg2Ilw9YkAw=;
        b=edAA06FfFrqR55mdDZHjATZP2XflwzR4lokED4y77aoKEyLqnkDPxKYC+w90mKk++U
         pFg2SuYmbbV+qjgaC4ZlHlbsWxhWVWxpsPZkBYDrAIhmmlaDA6akh1MjwgZkCS1YKVEK
         G16IW7FfBqkvb6GUHhfbBPA733Z4KcHU6oPf0fH9XpqakBA2qgugMb1RNPD3gcBwh6fo
         7nEeIL+vZkuKxHYbw+Miny8+AXwS69hDPMUzbPbZABibnW3XiWIwDiqpQFpFv9IPxuNr
         8pXq3oB3bkpfoAOjdjSMJdrX7dJV3cC+ziAtKE6Gt8NFehxL7zJPxnok+VpOZlAZs01K
         ue/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=RUx64tq9BpIwVZt1SvBA673QJ3mEok3gmg2Ilw9YkAw=;
        b=PrWdmsJcGl8pwXDyjTCCrfxhDi4R22zBLfcY8X49L3cZb+20Gq1yfAXbzhT7x7GbIF
         t9NwLpSyx7OipqsXIJ1WJk73XTpmCAkLPANhOR0NdGGozJjFpeFlL2LU6721a6fRLgxE
         C2oryufYyVxTKmwBDDggUzuMKZ8f7cTNJSlL41jFXiKEy9CDL9cd17p0hzNqkCEOp2jn
         WsXMcgZOMyDHEgiiZ2v97QMBAOoih68cCbtRryN2uZ1JQceawqqA+RkdVoSbIkHQW95B
         44oqgA7KI2Pfcodca3Dp+g88YejS1S/tZ9q8lHmBCeyVlKqmRELPz0pTE8DK5/pkkK1W
         iQoA==
X-Gm-Message-State: AOAM532nsx5bBgBSRL/qUjQ1reFy3g7B/u8HtCpPmNeSnGGDR8re2ixk
        eiWZFR/FhpYhXj8TA/OccSFbtn/7UK9WA7hTjBA=
X-Google-Smtp-Source: ABdhPJwj7ZM5/GfOD9oHG48QJhQeKaOGZLGhXIFLtD6xyup/eUmEGjWlC27fAHOQoenMThw9CnBQR/XbRSYRc5ooilY=
X-Received: by 2002:a05:6402:22f9:: with SMTP id dn25mr16985626edb.241.1623676989585;
 Mon, 14 Jun 2021 06:23:09 -0700 (PDT)
MIME-Version: 1.0
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Mon, 14 Jun 2021 21:22:43 +0800
Message-ID: <CAD-N9QUUCSpZjg5RwdKBNF7xx127E6fUowTZkUhm66C891Fpkg@mail.gmail.com>
Subject: Suggestions on how to debug kernel crashes where printk and gdb both
 does not work
To:     alex.aring@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        stefan@datenfreihafen.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot+b80c9959009a9325cdff@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear kernel developers,

I was trying to debug the crash - memory leak in hwsim_add_one [1]
recently. However, I encountered a disgusting issue: my breakpoint and
printk/pr_alert in the functions that will be surely executed do not
work. The stack trace is in the following. I wrote this email to ask
for some suggestions on how to debug such cases?

Thanks very much. Looking forward to your reply.

[<ffffffff82b09f12>] kmalloc include/linux/slab.h:556 [inline]
[<ffffffff82b09f12>] kzalloc include/linux/slab.h:686 [inline]
[<ffffffff82b09f12>] hwsim_alloc_edge.constprop.0+0x22/0x80
drivers/net/ieee802154/mac802154_hwsim.c:385
[<ffffffff82b0b0f3>] hwsim_subscribe_all_others
drivers/net/ieee802154/mac802154_hwsim.c:709 [inline]
[<ffffffff82b0b0f3>] hwsim_add_one+0x3b3/0x640
drivers/net/ieee802154/mac802154_hwsim.c:802
[<ffffffff82b0b3c4>] hwsim_probe+0x44/0xd0
drivers/net/ieee802154/mac802154_hwsim.c:848
[<ffffffff82628bf1>] platform_probe+0x81/0x120 drivers/base/platform.c:1447
[<ffffffff82625679>] really_probe+0x159/0x500 drivers/base/dd.c:576
[<ffffffff82625aab>] driver_probe_device+0x8b/0x100 drivers/base/dd.c:763
[<ffffffff82626325>] device_driver_attach+0x105/0x110 drivers/base/dd.c:1039
[<ffffffff826263d1>] __driver_attach drivers/base/dd.c:1117 [inline]
[<ffffffff826263d1>] __driver_attach+0xa1/0x140 drivers/base/dd.c:1070
[<ffffffff82622459>] bus_for_each_dev+0xa9/0x100 drivers/base/bus.c:305
[<ffffffff826244e0>] bus_add_driver+0x160/0x280 drivers/base/bus.c:622
[<ffffffff82627233>] driver_register+0xc3/0x150 drivers/base/driver.c:171
[<ffffffff874fa3dc>] hwsim_init_module+0xae/0x107
drivers/net/ieee802154/mac802154_hwsim.c:899
[<ffffffff81001083>] do_one_initcall+0x63/0x2e0 init/main.c:1249
[<ffffffff87489873>] do_initcall_level init/main.c:1322 [inline]
[<ffffffff87489873>] do_initcalls init/main.c:1338 [inline]
[<ffffffff87489873>] do_basic_setup init/main.c:1358 [inline]
[<ffffffff87489873>] kernel_init_freeable+0x1f4/0x26e init/main.c:1560
[<ffffffff84359255>] kernel_init+0xc/0x1a7 init/main.c:1447
[<ffffffff810022ef>] ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

[1] https://groups.google.com/g/syzkaller-bugs/c/iEEZ_UOvoEY/m/6sm4bt6EAgAJ

--
My best regards to you.

     No System Is Safe!
     Dongliang Mu
