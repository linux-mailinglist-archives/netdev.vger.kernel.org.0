Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6918545E402
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 02:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239553AbhKZBbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 20:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243939AbhKZB3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 20:29:47 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CCFC061748
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 17:26:35 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id r26so15815824oiw.5
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 17:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5oNBS8OmaTUtwU3kMYEIEBaTl0RUNCIhAJalrCeAiOA=;
        b=BKwMGoXFCscIs9sGb+witkRrlwfU6blOgARYPziR+QgSeA10DyQJMhRqFaCsnuvONQ
         FkNFx0kKmLZYk/SdnaTLW4G+4IX72eY2rxXyBSTYp6GIW2Xs0PquvJpsVgWasEH6nTTO
         j2OwRazGrmX+JvygN4apI5yYOVRsDlsTMiu/nC0462PzZ0xRPSA3rV/8AyaNwc0YiorT
         8GocwqnjpW/lFHxvS3clgb+HJL9drbgEkuGWu20cWAQRQSnn6U5Lk2I6Kgopbvyf+e3B
         XKyiVjle+vWCn3BYoCC3/64XY0dFJj4DWZ+rOrfxtGBMDXS4lk84Olz2CzubiHtIhjJv
         k9Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5oNBS8OmaTUtwU3kMYEIEBaTl0RUNCIhAJalrCeAiOA=;
        b=GMUdVT0cMxmVMhJt0PUXWrDS8llMQLAsZBLZyoe5wSaOFePzyLQ0GoRDzpGvIVMPXD
         qBqSA3oFdEQilR1t9fFztCvLr3yvZEqpDKanr1wGIUboqkRk39DaUqCzIbRFIgF964Ti
         LrN1C5bZEKSQWIfrJnC0mOBv4Zrgm0Ov1j2Q27aAM/OTbJiTTYeH3PB/xJRxIAdvdgIc
         KkXxT5odl0kR2FZJwIY9wc1jRCKwIMwL9Qb2M/EuHkNt2gZFspXMXn2hhUjx6su+EMGP
         DIGIvTQuF8W80Z37SUydKds7TU6+QcfqAosxLzg6ZrmRquzfRr3jtgvsxEKWN8L2n8L/
         a/AA==
X-Gm-Message-State: AOAM533D0r/aRnhH7qYafGG/bMkb0JANLy543PRiCkt+Vq1Bx4QrAyrH
        Z1rCeRkPvx9N6F7YKib4ZiKw+gdMGsFy9j8mF8m9bA==
X-Google-Smtp-Source: ABdhPJy13UUNs8Mz9F8I/18eOC4wZpt0zC3KnNwmGTfWQ2tnn6vi0HhFiDXUtwPKoP1S29e7C7Nq6liBkGIfelEOCOk=
X-Received: by 2002:aca:120f:: with SMTP id 15mr19695338ois.132.1637889994924;
 Thu, 25 Nov 2021 17:26:34 -0800 (PST)
MIME-Version: 1.0
References: <20211126011039.32-1-tangbin@cmss.chinamobile.com>
In-Reply-To: <20211126011039.32-1-tangbin@cmss.chinamobile.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 26 Nov 2021 02:26:23 +0100
Message-ID: <CACRpkdayKYeizBt=dspQ2VdsQvpc8iq7XeaT7SnRiCyMVO2Bsw@mail.gmail.com>
Subject: Re: [PATCH] ptp: ixp46x: Fix error handling in ptp_ixp_probe()
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        wanjiabing@vivo.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 2:10 AM Tang Bin <tangbin@cmss.chinamobile.com> wrote:

> In the function ptp_ixp_probe(), when get irq failed
> after executing platform_get_irq(), the negative value
> returned will not be detected here. So fix error handling
> in this place.
>
> Fixes: 9055a2f591629 ("ixp4xx_eth: make ptp support a platform driver")
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>

OK the intention is right but:

> -           !ixp_clock.master_irq || !ixp_clock.slave_irq)
> +           (ixp_clock.master_irq < 0) || (ixp_clock.slave_irq < 0))

Keep disallowing 0. Because that is not a valid IRQ.

... <= 0 ...

Yours,
Linus Walleij
