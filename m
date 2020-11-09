Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FB32AC310
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 19:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730311AbgKISAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 13:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730092AbgKISAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 13:00:06 -0500
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4087CC0613D3;
        Mon,  9 Nov 2020 10:00:06 -0800 (PST)
Received: by mail-vs1-xe43.google.com with SMTP id y73so5456413vsc.5;
        Mon, 09 Nov 2020 10:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=gT6NVd5kLg+vLhMsY5UL81nfbLscRMQ9JwMFR67gHxA=;
        b=g6zeul5lR9V/e3BNd2kOiNmdzXstvXXGf9X2Mfo+whfhM0YnswaptXBwwYejZmAAOO
         LbOcyWanx4JH/zZzOrDmsFm/ojjMdixbISL62BC50DuQrX6CVZw8LNItWp5QqfjepgrA
         z92Oi75z6uyRQLJXuNMD37zTwIqMXvLxbl/ea4CX6f2x6MqHvToFsL6WWCr6sElI8XU/
         7Xz1xdAfZQZyMaluQgC1VGDYb2vB9o4AJgxmaiTVhjZDu+TEaPY1NXMihoyc/2cduDId
         SZeWzHxv8fJYJ6DxOKHdBH5WAiSDExqrFyUBNHT2oXElJh9jMLGrHIIXEQafIY1ZuhU/
         jhAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gT6NVd5kLg+vLhMsY5UL81nfbLscRMQ9JwMFR67gHxA=;
        b=tXQ1mxZYvGV0OwkeHJAo3JC2cIoZrOffD63IugmnLT3LrzRUhTPPVWHnnuwDdAzByT
         yxwF3K01HZ2qmK769N7iKML/FxUkjDy6MM+bOS7LgdAd3G/E/boCy/o0t+xwGtjo3MzF
         XDscTSVweOWUeSsxEn9kIct6LWpzIK7OzIwzye4NuEkS+upBwSuJJpbE6U9+H/EoTc2c
         BPuX4idljSS4xe9q/18TxoXb+ilyGJj4L0uWz16DJMsx0Stu1NZxG5tl11UgOYrs6lxd
         nm1piPwlLwVCbJVnp1R29F5UXvHuaKvqkMc2wWKBlLmvNgjKJr/yzCC/A99HQ03Eo502
         K8xw==
X-Gm-Message-State: AOAM532oMVtc4J2JuWlr58jiivz3nmmn4vcA6L4trq/feLqcoiIELf3V
        uJyzLIiucZAPnmyPUTgejftNLqKOWAHsfxb13gI=
X-Google-Smtp-Source: ABdhPJy+gEHMTPNc8zvbT56ZbZW0Xi1l0xlYs5LPvzO6ABEjI3UDBL3FJ1QPhsfBdarG6+5D6FI0g/QdO6Z4nT6m5a4=
X-Received: by 2002:a67:b347:: with SMTP id b7mr9145347vsm.15.1604944805297;
 Mon, 09 Nov 2020 10:00:05 -0800 (PST)
MIME-Version: 1.0
References: <CAGngYiUVnq2BanL_JwDGVwRapO_oU0=-2xFmaPPmHB5XJft4MA@mail.gmail.com>
 <91E6EF39-9562-4654-BC6C-96C23460870F@berg-solutions.de>
In-Reply-To: <91E6EF39-9562-4654-BC6C-96C23460870F@berg-solutions.de>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Mon, 9 Nov 2020 12:59:54 -0500
Message-ID: <CAGngYiUy5D6xONticHdrcmwTtx4x6zsLXh_1V62k7yiQZFg7_Q@mail.gmail.com>
Subject: Re: [PATCH v2] lan743x: correctly handle chips with internal PHY
To:     Roelof Berg <rberg@berg-solutions.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roelof,

On Sun, Nov 8, 2020 at 2:57 PM Roelof Berg <rberg@berg-solutions.de> wrote:
>
> Well, it=E2=80=99s not an easy 4 hours attempt between breakfast and lunc=
h, unfortunately, but it=E2=80=99s based on inexpensive off-the-shelf parts=
 and doable in an experienced team.
>

I would love to test this patch on fixed-link, but unfortunately I
don't have the
resources to create a prototype as per your instructions.

Sven
