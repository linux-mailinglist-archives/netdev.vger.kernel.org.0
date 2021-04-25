Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3A336A914
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 21:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhDYUAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 16:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbhDYUAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 16:00:20 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6444BC061574
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 12:59:38 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id i3so37598676edt.1
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 12:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JsQW66FPoDvh4bDg+CLeWdTxzH3o92LPSw/y4Dw9EXk=;
        b=mbZ5K34Sc8FVuJleBCVwxld4UwQ9cOQXSo9+QjnYP32hMSdVZvzUvFdlvt2HWJaF8X
         /+Ge3y5MroAKEfHzSKyKKftjN3m0ntdc102wohV9tzzTWbPZG7nu3I5c1VkjJjpxfuZp
         JK767SPhrKNBa8eevCgxUuk7AL5Y1BrH0fLzprWVT9zETKzhy+RS6ffETwFvdldpO2+5
         u7limXmbKzkXNOlMdalmMvSqOXK29cwr5nTGXdwebAYl7Gknk4A6knf/PFvjjNE1m/ND
         JUu3LeP9DwjIJ+CEPiPtZK0BUjMYz0o/H8skQ9WE83rvnnRLfu6m2e8NEj/lRAWUs42w
         3Gnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JsQW66FPoDvh4bDg+CLeWdTxzH3o92LPSw/y4Dw9EXk=;
        b=qXOK4DR0mjDNxLMfIc44y5q4b99tUbgy14XlgFVblCc9WGnrMt9BfUwVUZabpjiqWR
         yrWX7FFn6Fnal+dY/hOH8qoqIONKVp+GXdISOi11qg1xaKQzr212xM9B+e+oeuO8UHXy
         dSorUrsgJjnpgiNwl6ErspIvUKnb664I0CHQoWNdooXE5ky6vuzaguq9M8CMjpGk1tWS
         tMVzHZ+gE/dXGWjXt2Q4oaqWJ0Vc4q1Ax+KZI4gCXtkpQAU9b+B4Hx267E5MIQOAk31O
         kA7tmUKrT2XJOXQ3gokHM/zEhiaTUlxIt0He09o4meIg7BVp6ihAnRD+lwKZsjCBclbV
         EsjA==
X-Gm-Message-State: AOAM531L335pSRUd/R0rSnKxntaO8dG20+MuyuQw67mDn4hrHTMZyNJE
        RFmD/kErJxp2zYy2ASydHXHCf9mxFCkVm/WuFECGoQ==
X-Google-Smtp-Source: ABdhPJxnxj7UpEL8yQZDw8FhPgdgHN0ajVg/uf4BjnP4bkrKJuykOE00A3qjlxJ85AqyVPxWmb/PH2mk6wrSmhXLdB8=
X-Received: by 2002:a05:6402:51d0:: with SMTP id r16mr17205548edd.52.1619380776823;
 Sun, 25 Apr 2021 12:59:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210415173753.3404237-1-eric.dumazet@gmail.com> <20210416105735.073466b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210416105735.073466b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 26 Apr 2021 01:29:25 +0530
Message-ID: <CA+G9fYtVYvD5W24U7gMK-wfK+BZ4vaj44pn4kwY6Hn6vN4HPZA@mail.gmail.com>
Subject: Re: [PATCH net-next] scm: optimize put_cmsg()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        lkft-triage@lists.linaro.org,
        Linux-Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Fri, 16 Apr 2021 at 23:27, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 15 Apr 2021 10:37:53 -0700 Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Calling two copy_to_user() for very small regions has very high overhead.
> >
> > Switch to inlined unsafe_put_user() to save one stac/clac sequence,
> > and avoid copy_to_user().
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Soheil Hassas Yeganeh <soheil@google.com>
>
> Hi Eric!
>
> This appears to break boot on my systems.

I have been noticing this problem.

>
> IDK how exactly, looks like systemd gets stuck waiting for nondescript
> services to start in initramfs. I have lots of debug enabled and didn't
> spot anything of note in kernel logs.

We (LKFT) are still seeing this problem only on arm architecture on
next-20210416 tag onwards. our bisect script points to this commit.

Steps to reproduce:
- build linux next latest next-20210423 tag with below config
     -  kernel-config:
https://builds.tuxbuild.com/1reqrnNLnHEX9uEZFngRfaoJa9E/config
- boot qemu-arm with below command
   -  /usr/bin/qemu-system-aarch64 -cpu host,aarch64=off -machine
virt-2.10,accel=kvm -nographic -net
nic,model=virtio,macaddr=BA:DD:AD:CC:09:04 -net tap -m 2048 -monitor
none -kernel zImage --append "console=ttyAMA0 root=/dev/vda rw" -hda
rpb-console-image-lkft-am57xx-evm-20201022181203-3085.rootfs.ext4 -m
4096 -smp 2 -nographic

- After the mount rootfs - the systemd gets stuck

>
> I'll try to poke at this more, but LMK if you have any ideas. The
> commit looks "obviously correct" :S

May I request to investigate this on arm architecture.
The qemu_arm boot failed link,
https://lkft.validation.linaro.org/scheduler/job/2565371#L540

The qemu_arm boot pass after the reverting this patch,
    commit 38ebcf5096a86762b82262e96b2c8b170fe79040
    scm: optimize put_cmsg()

on the latest linux next tags i have to revert two commits.
   "scm: fix a typo in put_cmsg()"
   "scm: optimize put_cmsg()"

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
