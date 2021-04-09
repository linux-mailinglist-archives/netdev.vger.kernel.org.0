Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7DD635A143
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 16:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhDIOjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 10:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbhDIOjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 10:39:03 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E517C061760;
        Fri,  9 Apr 2021 07:38:50 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id g18-20020a7bc4d20000b0290116042cfdd8so4881298wmk.4;
        Fri, 09 Apr 2021 07:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q/s19jnmq9yXkDEdnIUWAHsNWisl9i8b1FxYCjtZZCk=;
        b=bzD0Y9C1nAqjHtDhfjK1ZkhUhuirtvB+CB5vkxNrNTZ23417sVN6Z/80FCsZsIBMnS
         Q3WQTvT6W9cFtfWYRLZycJFmeU47kJ+t6UbrCj+flIYxh5psKKRLkWOwbsYrwHp7VJOy
         yXT6vtqCrZjYVG8INSMgX4LAPW6i8ugCO0EDfMSOEGjgErDY9IyiJ+bsUI4j7c0BtcUV
         5s0gwv9/r1nS3c6nlFOWkjCKHMlFDqqlwzxXXhHMrl8m0DRqZ+4zFP9A4u5WKuVR3tX4
         bJo/D625jw6pFx+iIENjREbymWaF2qOoTgHll8ZPei7Net/dzZUNAcfWla/WkaZ15BXY
         PwAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q/s19jnmq9yXkDEdnIUWAHsNWisl9i8b1FxYCjtZZCk=;
        b=X7OXkkUL/7zsYrDjjH38Ub/cEP59CL9kfkIeuGWSKEPQaI0/oq3fxZqIXGgZCjMzdT
         dJkTZEX27mUmWMF8X19ZtwwXpficnNrsCrXBMu71hnpFWmFM5apmWvk0eYAGA6J0xZ4j
         C8rjSzrJjsapKtb5+iGNeisQoS5k8Pekdb8cz12FRiBhdMagwfTZY9uqKHL6iCC0UeRY
         YR0+YSGwjXLInlBA33HsDCwQDOuz45TFfayixFw8a9zj9LQ+Bk0MNZrZZiV0SMAtHQdr
         WYkfMI5KIbmKu6rGvSZXjCaB/rc4wyI/wkV/YXXyqOpCOLfbXj0Ach4dTZmgOZroSGMT
         Aq/w==
X-Gm-Message-State: AOAM532+YrMr6EYnctdSsNU4fYu8c1OximN5+8FjAZ6u0DbQ8KnvO831
        e/mO5gs6QTDsZU8XktSDjeiva3jkTrl3480M5u4=
X-Google-Smtp-Source: ABdhPJxXVuNOkYVwS5W2bY5LrHjVjeSj4QMZgXCdTnnox58HSDZ4lhh/3X6iWr24AQGaYcX3SvqG8y4KtOg6SkdnuLU=
X-Received: by 2002:a1c:20c2:: with SMTP id g185mr3380998wmg.74.1617979129019;
 Fri, 09 Apr 2021 07:38:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210409003904.8957-1-TheSven73@gmail.com> <CAFSKS=OQ0wv7mWVcZrDdrP_1WKZ+sGPZWyNMV6snc7SWRi-o5A@mail.gmail.com>
In-Reply-To: <CAFSKS=OQ0wv7mWVcZrDdrP_1WKZ+sGPZWyNMV6snc7SWRi-o5A@mail.gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Fri, 9 Apr 2021 10:38:38 -0400
Message-ID: <CAGngYiV6Msz8nkM7wegk4DEL+RAeYGNk+cufuz+nTHKNqtuk5A@mail.gmail.com>
Subject: Re: [PATCH net v1] lan743x: fix ethernet frame cutoff issue
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi George,

On Fri, Apr 9, 2021 at 10:12 AM George McCollister
<george.mccollister@gmail.com> wrote:
>
> I'm glad everyone was able to work together to get this fixed properly
> without any figure pointing or mud slinging! Kudos everyone.

Same, this is what the kernel community is supposed to be all about.

And thank you for testing+reviewing. And for not freaking out too much
when I lobbed that revert patch in your general direction :-]
