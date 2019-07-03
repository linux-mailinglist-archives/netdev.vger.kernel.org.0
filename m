Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C205E866
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 18:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfGCQIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 12:08:11 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:39127 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfGCQIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 12:08:10 -0400
Received: by mail-ed1-f49.google.com with SMTP id m10so2623126edv.6
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 09:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DC6q0KOD/XYLr7a71D1P9CFOnC+xocWAYAxJGy/GqR0=;
        b=Px3gxBJE08uPK7XwxpPpz03lD0M8ioZyCCvZC4dCjWnbcN4oQsxq2XYkCmdOMROC2n
         IbjvXUOEskWzvGt5zYWYTXd85Vf1kNqJsi0lYK7VqlNSCiZS/YBaSRXTfTvpWQlbgNNr
         +4Yp+zCUk1Bxpne4JUR7Ahwl5P+vWuFGvuv/YWXf/GiLkP/bUoVhZxeUyeW5yHIsmwqo
         Kt2yQpOOuBJk9e4JlBgnWIeVeZj4nMKbOfzvHcTFWE0JowaKGixLEOeRlrD73yeUnXFr
         NSUnAnz21/V67iMe6Dmk7nLCpjkn5xHwnGB2F7pmehykApqR1Yib9dJ0QJWgdQbFxzGo
         QXRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DC6q0KOD/XYLr7a71D1P9CFOnC+xocWAYAxJGy/GqR0=;
        b=rnC6Ch+epm2cr6+Vups5zjYUtJCbtAFqrc+4tmwr37I+Ukgjzt3jfJySz1Op22Dqlo
         WQHtqJ1wC7wN8adzkiZkgkeTXy8U4csj/3ggIpbdgkgfue1NcUibyYKG29gp9NqoobIw
         hPx3mQ4WSQWEjAaPhCseblPuh9FzC3A0Qt1VZDiF2A+ZQTEkbTL+x74f5o6HlTu/UHjM
         D8LYZKsDc5sSnX13taK+LymRpVwmnWRHaqB4bFpN5/A5AyLcFAtobqqO5bd43BAEIl4a
         lU9otM93AwoQlp92T31IHt8m1LlFl0eFSgcnRQWLPvjF8hgTFuWFg5HGRduugfgwbmZq
         Edkw==
X-Gm-Message-State: APjAAAWVdhm9zjGOGcO0K8PlxirDZUHk8bElYYBJ+9ZS3GKACaRqNYhr
        /CzkvmkVUecVf1FdcJMToMg0NU5TroaAackTibcr0Q==
X-Google-Smtp-Source: APXvYqzbftJjOm2fvc73vkqvjCeR4E72car6L0dSTx4MmzIYlyFuH8+cDxDy061kdZqnBx8uzra91F6P/YB3i/G/D6E=
X-Received: by 2002:a50:eb8f:: with SMTP id y15mr26991571edr.31.1562170088877;
 Wed, 03 Jul 2019 09:08:08 -0700 (PDT)
MIME-Version: 1.0
References: <1562152028-2693-1-git-send-email-debrabander@gmail.com>
In-Reply-To: <1562152028-2693-1-git-send-email-debrabander@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 3 Jul 2019 12:07:32 -0400
Message-ID: <CAF=yD-+wHzfP6QWJzc=num_VaFvN3RYXV-c3+-VY8EjS87WEiA@mail.gmail.com>
Subject: Re: bug: tpacket_snd can cause data corruption
To:     Frank de Brabander <debrabander@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 7:08 AM Frank de Brabander <debrabander@gmail.com> wrote:
>
> In commit 5cd8d46e a fix was applied for data corruption in
> tpacket_snd. A selftest was added in commit 358be656 which
> validates this fix.
>
> Unfortunately this bug still persists, although since this fix less
> likely to trigger. This bug was initially observed using a PACKET_MMAP
> application, but can also be seen by tweaking the kernel selftest.
>
> By tweaking the selftest txring_overwrite.c to run
> as an infinite loop, the data corruption will still trigger. It
> seems to occur faster by generating interrupts (e.g. by plugging
> in USB devices). Tested with kernel version 5.2-RC7.
>
> Cause for this bug is still unclear.

The cause of the original bug is well understood.

The issue you report I expect is due to background traffic. And more
about the test than the kernel implementation.

Can you reproduce the issue when running the modified test in a
network namespace (./in_netns.sh ./txring_overwrite)?

I observe the issue report outside that, but not inside. That implies
that what we're observing is random background traffic. The modified
test then drops the unexpected packet because it mismatches on length.
As a result the next read (the test always sends two packets, then
reads both) will report a data mismatch. Because it is reading the
first test packet, but expecting the second. Output with a bit more
data:

count: 200
count: 300
count: 400
count: 500
 read: 90B != 100B
wrong pattern: 0x61 != 0x62
count: 600
count: 700
count: 800
 read: 90B != 100B
wrong pattern: 0x61 != 0x62
count: 900
 read: 90B != 100B
wrong pattern: 0x61 != 0x62

Notice the clear pattern.

This does not trigger inside a network namespace, which is how
kselftest invokes txring_override (from run_afpackettests).
