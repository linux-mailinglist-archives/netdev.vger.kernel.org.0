Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E40F4D6AD3
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 22:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733233AbfJNUdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 16:33:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36216 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729667AbfJNUdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 16:33:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id m18so18020253wmc.1
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 13:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=RL+qRYT6Goj58mWMl95r8FGMxjYOCcO4sf1iNuaKh9U=;
        b=dMpX4osW+Gizh9wuXThIULR+SMojXNXSVsVvoWi5OvVzxXiLGj195gyZ0EdA3ugmnf
         pNJa9ZRwkxgN96umOkiqmG22sEeEnHfHxbwOCABF932ETOIQozeKKpwV4kOYVqDZdYpg
         HCazf1SLvF8mNO3JApRICKFlRopM9A0+MQ9KKpJvlyBDThEZ2i3z8fb3COic55OAQtJM
         8uPRQDu4QUAbItWuMpA1YNQofcuzZx5hpVW/0/UlNHEzP8FGK2ePDh9KDJ/pasgRXdbd
         qmhX6qiIJmhColRpPsyAtExuKOWc9pX84aDJFFd9WvWi3x/EZikS4XryeAB1saHR+0vu
         jghQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=RL+qRYT6Goj58mWMl95r8FGMxjYOCcO4sf1iNuaKh9U=;
        b=b0gjrAyROKTZKLbVEzRAFjHr7SYn3GXqhmAp0Yp+I1MQ1R/TsfOyDWa/td9wBDSO4z
         Xqij9vb9uzkR0W8aMpoCvcZ9BMObEhGDIL3vcyxhzVzBjvFk+G4FgEQu6z+vpD2+6c+q
         29ydIO0nmlr+6iE1eybqjtK4yIpexZGILT9rCCTYx3HggB1qBFy9CalJoCZsCqleiznz
         LF9cIo9xMnRZZ3wjiLqXyD9DR39HrtA3d/QZJRrh0VrMI29PkXxmHqWNfpGF4OU0f2TJ
         MLW+Mw2E2CVodkKSCisKWflC4fDlDCJCBjsOa+ARjkabF1KyhKpM7yrOI6DY6XEhHttX
         gL9g==
X-Gm-Message-State: APjAAAV9D5hvVde07bNB/Z03H66jqn6cMjEBVHPX82umMiqHDE6HrzHE
        ymhzCWWhATFd6tajEXvyqed++2SwUTat+CHHJydyyGLGyPQ=
X-Google-Smtp-Source: APXvYqzXLid+PDcZKtgZAJnd+DnjNjmGs2LNAqZ3GOO2Khpo/muwpEqr2khANBlfQMDwxJ+eHJscGM6cBUWo4kOCBzY=
X-Received: by 2002:a1c:2d85:: with SMTP id t127mr15762182wmt.109.1571085213841;
 Mon, 14 Oct 2019 13:33:33 -0700 (PDT)
MIME-Version: 1.0
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Mon, 14 Oct 2019 22:33:22 +0200
Message-ID: <CAFLxGvwnOi6dSq5yLM78XskweQOY6aPbRt==G9wv5qS+dfj8bw@mail.gmail.com>
Subject: Bridge port userspace events broken?
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com, bridge@lists.linux-foundation.org,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

My userspace needs /sys/class/net/eth0/brport/group_fwd_mask, so I set
up udev rules
to wait for the sysfs file.
Without luck.
Also "udevadm monitor" does not show any event related to
/sys/class/net/eth0/brport when I assign eth0 to a bridge.

First I thought that the bridge code just misses to emit some events but
br_add_if() calls kobject_uevent() which is good.

Greg gave me the hint that the bridge code might not use the kobject model
correctly.

Enabling kobjekt debugging shows that all events are dropped:
[   36.904602] device eth0 entered promiscuous mode
[   36.904786] kobject: 'brport' (0000000028a47e33): kobject_uevent_env
[   36.904789] kobject: 'brport' (0000000028a47e33):
kobject_uevent_env: filter function caused the event to drop!

If I understood Greg correctly this is because the bridge code uses
plain kobjects which
have a parent object. Therefore all events are dropped.

Shouldn't brport be a kset just like net_device->queues_kset?

-- 
Thanks,
//richard
