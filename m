Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E94136A978
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 23:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhDYVW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 17:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbhDYVW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 17:22:57 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842F1C061760
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 14:22:15 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id e8so2418798ybq.11
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 14:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L6BpeE1aEuanzABqaiqJe/WhiSRZpiVxeNsPQoiVcjQ=;
        b=XRRtPhTy5UVkWCIldr0yhHVR6JL1erPVHuasuepQQj9AbISGWpZ4TXQKfcaUfCEcLL
         GTwYYEi8bcPMmM2YeMEho32+WvCRd6Cn9nXlMldTcCmtuR4NbIUW2M/vfwYfzIdap0jK
         sXBSwm8FhXwDeOGYoqk38dlbqqcTF0CrnhJlaOL3FwQ/NGss0WozK9j4sWCEb4cYMdZY
         VPHdYrHaJBtgCUtWfjtacGGQ2Mjs/SVIvegBOf34NnkS7wuPU6yIp0TZmEN7fLTiwcyq
         t3Ruyr3PNabwavi1bWigGHx4LHvL/gQzd9QD0/JWmXTqiXLSSbXPwJp5Y+GqNJY31MwK
         oT5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L6BpeE1aEuanzABqaiqJe/WhiSRZpiVxeNsPQoiVcjQ=;
        b=BgTycuUoAJR0aLjU/mVlgYwJzWKdJsgt/PEzowyT32ZwsU2HwZn23UViCxaxkR/Dsd
         d8kYychLY5u2yje2S3sj3SSgunp4Z8ucIGeCkqB9HwlgxM5ax0N/bBINv4zF60L5kDgx
         PnBVkzQFOCCABNLbQEYUHeSnwjvDqFy7bL0v+5Q+Wms05inUZhFNADkSzP501TtxWzoA
         8/usUfefvG7/5wvGg/AAcmpMFE+VXxjrzs/6qke6eXYUUBtvvYkaCJB2tv5qkUwJn7eH
         KNbSa5MQJfCM1nC5nEFErkN5tPNDJHkRatmewQ0Cpn8sTO+xl3dChNs+UryJC27zvQ3S
         EHVg==
X-Gm-Message-State: AOAM533v1za9y+aLQZNql92k4WLDXlLvE+HeT0fEHskDbH+0jBf+uV2l
        TDS1240I7F5bP6fXuBvJCp3aG/3mv8yPGcpq8BF3yMtldVdaR+RF
X-Google-Smtp-Source: ABdhPJyXkiLFDpqF6LQusmx6QQrODfREx1udELp0a+1pOSmyzuuAb9kzdgiQcaK0qiS6rrmT3ZZg5FG8kdmcVGOYXWo=
X-Received: by 2002:a5b:906:: with SMTP id a6mr11528357ybq.446.1619385734134;
 Sun, 25 Apr 2021 14:22:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210415173753.3404237-1-eric.dumazet@gmail.com>
 <20210416105735.073466b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CA+G9fYtVYvD5W24U7gMK-wfK+BZ4vaj44pn4kwY6Hn6vN4HPZA@mail.gmail.com>
In-Reply-To: <CA+G9fYtVYvD5W24U7gMK-wfK+BZ4vaj44pn4kwY6Hn6vN4HPZA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 25 Apr 2021 23:22:04 +0200
Message-ID: <CANn89iLtpbvpJecdOqitedN_ZtRFz0R3HiAw2WKXN-pHy4geDw@mail.gmail.com>
Subject: Re: [PATCH net-next] scm: optimize put_cmsg()
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        lkft-triage@lists.linaro.org,
        Linux-Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 25, 2021 at 9:59 PM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> Hi Eric,
>
> On Fri, 16 Apr 2021 at 23:27, Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 15 Apr 2021 10:37:53 -0700 Eric Dumazet wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > Calling two copy_to_user() for very small regions has very high overhead.
> > >
> > > Switch to inlined unsafe_put_user() to save one stac/clac sequence,
> > > and avoid copy_to_user().
> > >
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > Cc: Soheil Hassas Yeganeh <soheil@google.com>
> >
> > Hi Eric!
> >
> > This appears to break boot on my systems.
>
> I have been noticing this problem.
>
> >
> > IDK how exactly, looks like systemd gets stuck waiting for nondescript
> > services to start in initramfs. I have lots of debug enabled and didn't
> > spot anything of note in kernel logs.
>
> We (LKFT) are still seeing this problem only on arm architecture on
> next-20210416 tag onwards. our bisect script points to this commit.
>
> Steps to reproduce:
> - build linux next latest next-20210423 tag with below config
>      -  kernel-config:
> https://builds.tuxbuild.com/1reqrnNLnHEX9uEZFngRfaoJa9E/config
> - boot qemu-arm with below command
>    -  /usr/bin/qemu-system-aarch64 -cpu host,aarch64=off -machine
> virt-2.10,accel=kvm -nographic -net
> nic,model=virtio,macaddr=BA:DD:AD:CC:09:04 -net tap -m 2048 -monitor
> none -kernel zImage --append "console=ttyAMA0 root=/dev/vda rw" -hda
> rpb-console-image-lkft-am57xx-evm-20201022181203-3085.rootfs.ext4 -m
> 4096 -smp 2 -nographic
>
> - After the mount rootfs - the systemd gets stuck
>
> >
> > I'll try to poke at this more, but LMK if you have any ideas. The
> > commit looks "obviously correct" :S
>
> May I request to investigate this on arm architecture.
> The qemu_arm boot failed link,
> https://lkft.validation.linaro.org/scheduler/job/2565371#L540
>
> The qemu_arm boot pass after the reverting this patch,
>     commit 38ebcf5096a86762b82262e96b2c8b170fe79040
>     scm: optimize put_cmsg()

Well, as already reported, this patch had an obvious typo.

Fixed later by "scm: fix a typo in put_cmsg()"

Can you trace put_cmsg() and check that systemd passes an aligned
control buffer ?

Kernel was indeed able to handle arbitrary alignment, but why the
application would
force slow copyout() (alignment mismatch between source/destination buffers)
is quite strange.



>
> on the latest linux next tags i have to revert two commits.
>    "scm: fix a typo in put_cmsg()"
>    "scm: optimize put_cmsg()"
>
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
>
> --
> Linaro LKFT
> https://lkft.linaro.org
