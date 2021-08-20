Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF0A3F2A45
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 12:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbhHTKqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 06:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229847AbhHTKqg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 06:46:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D93260EB5
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 10:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629456359;
        bh=+DGoHVKtJ7UmAVXmUFJRYus1tJGMBTa/YfmC5cqdlMo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=S3b5fvqvUlR4NL3uJlKXhbKoSjDDA/CujQeymnwQR4NGQ7vfdkAcvs5cQVrtngjzN
         oi4EWCeW/vWOwTyEmdgr5CuNaDayq0jb9RkrrpJbQICkdc0/VRhonhzk3X1dJKG8xB
         FASiPtvrYc/uO1UlnXWU5WiKlw/hnVYxsRfIg4TdAvl1iwF4ZxE1sqB3yVI+onp9Ru
         fTHbVNhNP7o1q0wzq5jBzdm7/rF7oD6pjFbGGcAeW42zo4zXzU8AS6QHmWS78YSYzc
         Gq/wky/yGngQCBkjS6PTsrlOxRmdKo7+hb0WL+ZVCVkdlGKTmGUG91MEEK8qZdcB1U
         fAutVyvsI2rSw==
Received: by mail-wm1-f44.google.com with SMTP id v20-20020a1cf714000000b002e71f4d2026so1117822wmh.1
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 03:45:59 -0700 (PDT)
X-Gm-Message-State: AOAM530DukkSGDhL+r1KyfP7z69+7BiQ4JjG+fgtOUFpbIw8JbSG6hWs
        vQmuklSLET6VQe/44GbfSrZbBLPY7A5IAI7qAHU=
X-Google-Smtp-Source: ABdhPJzlR+qz2i4LlbY1my6uy5zHa6p8M7Wp9h7j2f8FHgSM0eRfmKb6W+5ldoNvc99GvgJLzp6aLwmOJD+KgaDZCxE=
X-Received: by 2002:a05:600c:1991:: with SMTP id t17mr3209240wmq.120.1629456357961;
 Fri, 20 Aug 2021 03:45:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210813203026.27687-1-rdunlap@infradead.org>
In-Reply-To: <20210813203026.27687-1-rdunlap@infradead.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 20 Aug 2021 12:45:42 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3QGF2=WZz6N8wQo2ZQxmVqKToHGmhT4wEtB7tAL+-ruQ@mail.gmail.com>
Message-ID: <CAK8P3a3QGF2=WZz6N8wQo2ZQxmVqKToHGmhT4wEtB7tAL+-ruQ@mail.gmail.com>
Subject: Re: [PATCH] ptp: ocp: don't allow on S390
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Networking <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 10:30 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> Fix kconfig warning on arch/s390/:
>
> WARNING: unmet direct dependencies detected for SERIAL_8250
>   Depends on [n]: TTY [=y] && HAS_IOMEM [=y] && !S390 [=y]
>   Selected by [m]:
>   - PTP_1588_CLOCK_OCP [=m] && PTP_1588_CLOCK [=m] && HAS_IOMEM [=y] && PCI [=y] && SPI [=y] && I2C [=m] && MTD [=m]
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
> There is no 8250 serial on S390. See commit 1598e38c0770.
> Is this driver useful even without 8250 serial?

I think an easier way to do this would be to remove the
'select SERIAL_8250', I don't think that is actually a compile-time
dependency, just something that you normally want to enable
to make the device useful.

I would also suggest removing all the 'imply' statements, they
usually don't do what the original author intended anyway.
If there is a compile-time dependency with those drivers,
it should be 'depends on', otherwise they can normally be
left out.

       Arnd
