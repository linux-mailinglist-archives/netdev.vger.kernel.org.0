Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9EC8ECC04
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 00:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfKAXoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 19:44:24 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:45549 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfKAXoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 19:44:24 -0400
Received: by mail-il1-f193.google.com with SMTP id b12so10012159ilf.12
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 16:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vApdD0cyWp1gequOZwCkgF28X03XoepLwg+U2Z1WeHE=;
        b=KPuTkFIsLHohR9U3I/34IvScPi4bWl+7yfg1BGni7YmwyGhOcsAMsOiCBCKNu8G6mi
         K1Jx4fXK2KJUjW+i9u+wzaOFwVS+BV53aLVqBXck8qebxzcpN7MgLUwhzEHfkp8TV3DR
         PDvXoCYjcs1cMRg7ec9hqrK4HSVVCMRWg6R7VhIoEftPGQym3fjgfour1fXEL2Nnw+OY
         7zxkyh6S8UXcQ5IzjW3aQV5YnsnH+3krz/76aPgoxiuUEH8fx5JWbQqDM3IrVRl88Exz
         fd/A/0JNfa1T8J54j11tJXOJUPEJWkEtHB9G5F64gJpUuVwNNYORlGZ4GPptqBotpKPR
         2x9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vApdD0cyWp1gequOZwCkgF28X03XoepLwg+U2Z1WeHE=;
        b=SIwrhE2NygLoarY2qbkj1DovV9Gost10LJ78hO36regvtfHIX6avGbgIRbbYRopgOZ
         IgiYssqaPz4D7XHgUNYEasBkAaLaKbr12XBIF3diKK/+3hE4iI/hX/VvuZamw1xwdTjZ
         ePDbBDlv9MyYSyeCgwqr4HNtwfUhv39+zktKasIyZjFJOQe1y+eIItG/oiS+knhJxlcr
         2KFl+G5YLLhzvYPm7gCrseE3HWlLzuAfxF/3Mz4eOfO9gLffzK3DidF/6+YUmjbgEqeh
         BtfB6rRihdNEabSD24aK4IP+W5WtVrCCOKcivIUiJ26B0M9wvmOy4Xj5Ui09t4U6NGMb
         mB+w==
X-Gm-Message-State: APjAAAWZAFYtuja3/CLDYNLxVYYq8btmf/syZLp+Q90e3QkzCDYlgz5/
        Azt7fCsnX+k8L+IoJ8PYcKA0M1FlHtNsq8jwbSArOg==
X-Google-Smtp-Source: APXvYqx+cZIlIusKXnc/yzwAHhpQokhvISKsEjazvqjzsDqtpSlCNPvp1rA0Zo1t+gEFrVmmUhjKz9JmNKZP/cNTfjc=
X-Received: by 2002:a92:ba1b:: with SMTP id o27mr15823797ili.269.1572651861761;
 Fri, 01 Nov 2019 16:44:21 -0700 (PDT)
MIME-Version: 1.0
References: <20191101221605.32210-1-xiyou.wangcong@gmail.com>
 <CANn89iKS6fas9O74U5w1wb+8DN==fXRKQ8nzq0tkT_VOXRtYBQ@mail.gmail.com> <CAM_iQpUGAaV9hsP4Z7YoHD6rQuJDSP_WNk_-d97Uxyed2SsgrA@mail.gmail.com>
In-Reply-To: <CAM_iQpUGAaV9hsP4Z7YoHD6rQuJDSP_WNk_-d97Uxyed2SsgrA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 1 Nov 2019 16:44:10 -0700
Message-ID: <CANn89iLhmbhaJDhPtThh2Nt8BMp1tnAZjBwwMdsk0V=SmkMJmQ@mail.gmail.com>
Subject: Re: [RFC Patch] tcp: make icsk_retransmit_timer pinned
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 1, 2019 at 3:43 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:

> So let's make the sysctl timer_migration disabled by default? It is
> always how we want to trade off CPU power saving with latency.

At least timer_migration sysctl deserves a proper documentation.
I do not see any.

And maybe automatically disable it for hosts with more than 64
possible cpus would make sense,
but that  is only a suggestion. I won't fight this battle.

(All sysctls can be set by admins, we do not need to change the default)
