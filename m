Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275CA316A5B
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 16:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhBJPiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 10:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbhBJPiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 10:38:07 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A725DC061574
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 07:37:26 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id o7so2235430ils.2
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 07:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cPPYhWPVUtWQ+tfv9PV9k3onc/N9kBVkks6+BBkJQZY=;
        b=o8+e0ZdqmAic6/EDlGh+rhnlkhQKipMz+j/1lQSzC+Ti7WKNBpK9cMHJvnXXlDyrVG
         3LFDDVab9CaH5rcAF9htxWn42RTU1zw1QaTKL3+p753XzP3fQnNPv+uorZv1a6H0Cxym
         gYcImbJMsdDmlP8CkOImmXp+AIXN5dCvJshpETmUkiNeA6n34EFBLc9Vm9F055Q8YEdQ
         6EeeGXNaN6g8SrAma/jhwI6OKZpDHW6nEKf9YB/UgQautRJBNu2G21MTDBudl5ZkxTc3
         SO0uXz6CvELLKjvfhYzWikYyZkrRPPLtwBQnryDURXSzbo8NeXSSuH7+ZrmPzLD6E2wj
         roHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cPPYhWPVUtWQ+tfv9PV9k3onc/N9kBVkks6+BBkJQZY=;
        b=pLFDXVaNkVHoTHn68kZwQhIWY2FigbA1ILqO3q00yrK6nywoKne5R2X+bARh0ppDGz
         QD7Y5S7nu56j9ceCX9EK0f5ngc6gD/KJ9NBDS006XYs7GKyCZ9TjwLZbFYfEYqcTI99B
         xwvgkDdZVwkTEnbRkLyF9EAJ0qzYa17flZMAgFwl6AnBOpjvhIHqbQQusVkIU+PaG/YL
         cBiV2qTMHfpEJIfOEvvpW+OFnoSwC/RB1/a4zXfdbWhI7Ar7hBJsAXCFiTH6Cm3knfd6
         JWkae3iOByqCJWizcqVppH5UG6bMLptJOeu8YQI9aDklCzOgwfx6Tw51OfZ5OM6VmEnq
         x75g==
X-Gm-Message-State: AOAM531qjf32gerX3rTQ7dlq7QyW7vqZB2ePF8xC4cqIqL+qoOVerO/C
        BdirKFnWe8lRXHIvQgwB/qlQAEJIBMsQXW6SB+Hykw==
X-Google-Smtp-Source: ABdhPJx4SbvjF9MdVBQTOshGvMNMZs+I/zUKOKksmOWIROa69vNUMp/RRTRuaXZPM4N+a6sQwYFF7I7EF1u412umUXM=
X-Received: by 2002:a05:6e02:2c2:: with SMTP id v2mr1513310ilr.137.1612971445700;
 Wed, 10 Feb 2021 07:37:25 -0800 (PST)
MIME-Version: 1.0
References: <CAM5yEy0ZU42Kew4JcQVNsda_X2O8QL9m8F15-02tPAVrz6o54w@mail.gmail.com>
In-Reply-To: <CAM5yEy0ZU42Kew4JcQVNsda_X2O8QL9m8F15-02tPAVrz6o54w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 10 Feb 2021 16:37:13 +0100
Message-ID: <CANn89i+XKN0kKdLzEMitvgk2sH8H-xfj-P+CRXKVke5tyL+s=w@mail.gmail.com>
Subject: Re: [Linux Kernel Network Bug Report] tcp_rmem[1] is not resulting in
 correct TCP window size since 3.4
To:     Zhibin Liu <zhibinliu@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Tianpeng Jin <tianpengjin@google.com>,
        Chunlei Zhu <chunleiz@google.com>,
        Weiming Liu <weimingliu@google.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 4:14 PM Zhibin Liu <zhibinliu@google.com> wrote:
>
> Hi, Linux Kernel Networking TCP maintainers,
>
> I sent this bug report mail following the reporting bug guideline.
>
> Here is the details of the bug:
> tcp_rmem[1] has value 87380, which will result in a window of 65535 when tcp_adv_win_scale=2. (87380 - 87380/2^2 = 65535)
>
> But since 3.4, commit b49960a05e32121d29316cfdf653894b88ac9190, tcp_adv_win_scale default value is changed from 2 to 1.
>
> The change causes tcp_rmem[1] with value 87380 will result in a window of 43690, instead of expected 65535.


win of 65535 was used in SYN and SYNACK way after commit
b49960a05e32121d (this commit is 8 years old : Wed May 2 02:28:41
2012)

Change was done by Yuchung in 2018
in commit a337531b942bd8a03e7052444d7e36972aac2d92 tcp: up initial
rmem to 128KB and SYN rwin to around 64KB



>
> Now the doc Documentation/networking/ip-sysctl.rst is still mentioning 87380 tcp_rmem[1] will result in 65535 window size with default tcp_adv_win_scale.
>
> tcp_rmem[1] should be changed from 87380 to 131070.


Do you have a packetdrill test demonstrating the issue, on recent
upstream kernels ?

I suspect you use an old kernel with missing backports.

>
> At same time, tcp_rmem[2] should be changed from "between 87380B and 6MB" to "between 131070B and 6MB".
>
> I've fired a bug in Kernel Bugzilla, too. The bug is assigned to Stephen Hemminger <stephen@networkplumber.org> instead of you. So I sent this mail.
>
> Thanks,
>
> Zhibin Liu | Software Engineer | zhibinliu@google.com | +86 21 6123 2345
