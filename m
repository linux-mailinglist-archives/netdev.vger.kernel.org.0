Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F422DB029
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 16:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgLOPei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 10:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729798AbgLOPeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 10:34:23 -0500
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C287DC0617A6;
        Tue, 15 Dec 2020 07:33:42 -0800 (PST)
Received: by mail-ua1-x942.google.com with SMTP id y26so6827291uan.5;
        Tue, 15 Dec 2020 07:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CbSdNNYxeT6yqsudAjr7+iL0pQVPFdjuCIlK0EsWHU4=;
        b=Fwff4bYbl6xo3/Z+UeecGMQsCX5k205QvfZ+A0vxJGPj2+7mJmwk0XqRV89Z31WJD5
         JbGJYjQrBHiApB9GrFFeloPOFPq9bmHAacQ2UVL2+J0QvWsCrjHSwhQ8vOg6nbNjiEW5
         Rd3dbSrPDRUzGO/DnSZzG/VsLB2gn1nuL2jX38FcT+iq181W1BZvn0JVrWff4rDPxHy7
         Uz/bKP3++9iF8Bga9cYTM+xXvaBEzkdBHkdCS0RjTQWRKgp6Sh0QAJvbaZm6ZrpgIvBB
         e1YwdhNttt8cTH8yahuQuxUMRBjT4xEhiWZ14EGD29paUjsX3uw3Z95vx7bIE7uTLOa6
         vhCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CbSdNNYxeT6yqsudAjr7+iL0pQVPFdjuCIlK0EsWHU4=;
        b=HngiBTazB2S8W/hRjTy6HwAwK05jVqqwPqg4jWkDr/JW//8uDzDefAyczOU+VfM1Pw
         lBddO/tU8QauyNi3s/+WbxV6KI4EeB+NnIN4CVdFKNFlm53zuusx51pmQTx1M+t/f/nB
         vLZJqFATlEs3aYqgie3WBE1+Mf8VYX6BXKdoiOvut3ai1FUh2CeZuJpkwY9KRpMmEhTR
         Fx4NEdhpNsSuVDo2ZyHtrO9ReFu+L4FX0ADldbQd28iPhzaWkMqZuZmEdiT5Znqw8Vqz
         vWoeGLrqMlgHRYCuoa5EG+6Lk2CawlRIqZy6VXFqnoPO9P3FC01xq6rlkTfVgsu4ljWh
         f95A==
X-Gm-Message-State: AOAM533xFkOKu6AzsRlLerH4AYOX1bRvsFQoFD/RtLTO8h4PBbDUpgD6
        bU9zE26IaSs0KJMfO+KejLnSqpHsvyyqdo5cgM0=
X-Google-Smtp-Source: ABdhPJzOaAX6k5+L9+tvWa1R7tcpUWi4JNDyuQT/a2MeCpLJOxyiJNoR1JIYZFTwogHElX0eucap8vxSZbmuCztYP9Q=
X-Received: by 2002:ab0:2a1a:: with SMTP id o26mr28642075uar.101.1608046421829;
 Tue, 15 Dec 2020 07:33:41 -0800 (PST)
MIME-Version: 1.0
References: <20201211143758.28528-1-TheSven73@gmail.com>
In-Reply-To: <20201211143758.28528-1-TheSven73@gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Tue, 15 Dec 2020 10:33:30 -0500
Message-ID: <CAGngYiVmTU2U1b7qv+oFXi927z6pEw5H6tsBjGDT4HJeHK5DGQ@mail.gmail.com>
Subject: Re: [PATCH net v3] lan743x: fix rx_napi_poll/interrupt ping-pong
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Dec 11, 2020 at 9:38 AM Sven Van Asbroeck <thesven73@gmail.com> wrote:
>
> From: Sven Van Asbroeck <thesven73@gmail.com>
>
> Even if there is more rx data waiting on the chip, the rx napi poll fn
> will never run more than once - it will always read a few buffers, then
> bail out and re-arm interrupts. Which results in ping-pong between napi
> and interrupt.
>
> This defeats the purpose of napi, and is bad for performance.
>
> Fix by making the rx napi poll behave identically to other ethernet
> drivers:

I was wondering if maybe you had any lingering doubts about this patch?
Is there anything I can do to address these?
