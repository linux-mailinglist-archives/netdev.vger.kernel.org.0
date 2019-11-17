Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B04DAFF77E
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 04:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbfKQDku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 22:40:50 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45847 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfKQDku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 22:40:50 -0500
Received: by mail-ed1-f68.google.com with SMTP id b5so10703728eds.12;
        Sat, 16 Nov 2019 19:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gGM2OrO+vwasXlJDGevaHyVoUmS9msRq0TdP1VtCXT8=;
        b=TLxovJLWHY2N/CIWowODzZLJ6aM2UF2Mb6ghs/iWlTlY9zR+26OnJzyy3dE6BsNaSq
         QX71XHlQ4UXY3L+5a+HPIRbi+IMwh8Ggxea8/PdCiGnUvdF/VWJwld3cwx24s5BZAfLj
         ruRuonJIzlI82EEOu5OLEPEvV9hKsW7w6KmEhsyyaG+SGAy+g0IQWZ/2+56tmK8F0NH0
         VUy15Hq3PLa55N0HB4tG5S0Fc5gg5Zw83+5yT2jMMlKRgEx0dgbmo3yNGdcdIvNbVeHH
         CSvXGu8IFZ5IBrr/ZnSu1NEymnhPCNH2uubjbJ0CJbwvX+VMZ2dCMiPK5InA4mBcgvga
         UbnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gGM2OrO+vwasXlJDGevaHyVoUmS9msRq0TdP1VtCXT8=;
        b=FMm7VrISG7nTDChS1ufENROdipz7oGFcVge/kG8MDAO/Hvvp+HpoZh2KgfglG3M3de
         3+qO2PiL8JND8jzo8Xzrv/zev+a2rNdmjt8bMfCYjM7FzRhTes0d9Wh5e8VOYpwwW0xv
         hnIzfw49SCknf99mT32V/ZnW5wiFGeeVRpBvzagaFvPdxNeYeA+De6ezEuyGUfrhcqc1
         hCmV9Mwf2hUs5zrbYOeTWdwYumKPQYHsmqlfDWsdeK9tWKpTfDzGlpA7JW6Q6E2PVGGj
         xgGX1tmuCZdRf8zaFU4p5aicAlVYU+3VGj4dI3DvgF8pSGL5XqQQtaqhTLv6SrQm8V8z
         1vvw==
X-Gm-Message-State: APjAAAUlmwqSi3dmDK/BrRcf/LNEvyBYrroHUbF9rmVnE8HMyEOnswFa
        /vZzsIi9jy9l5dmUpv+ViITH7TqNrBUXB8EY42NucNqaEN0=
X-Google-Smtp-Source: APXvYqzSbzTFlgWQCpEmWKm0DalrXM/6PN68uuFfTb2nVHiCFjHeoKgXAiCaVG+tUaNMxINbEiNNsxYb091bkYREbKw=
X-Received: by 2002:a17:906:e297:: with SMTP id gg23mr15359965ejb.41.1573962048611;
 Sat, 16 Nov 2019 19:40:48 -0800 (PST)
MIME-Version: 1.0
References: <20191116142310.13770-1-hslester96@gmail.com> <20191116.121710.1143094650284471912.davem@davemloft.net>
In-Reply-To: <20191116.121710.1143094650284471912.davem@davemloft.net>
From:   Chuhong Yuan <hslester96@gmail.com>
Date:   Sun, 17 Nov 2019 11:40:37 +0800
Message-ID: <CANhBUQ2Sr4qXUW0aFG+jD=ncRiuLZz5uVN6zyNv29ai3fZYTWg@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: macb: add missed tasklet_kill
To:     David Miller <davem@davemloft.net>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 17, 2019 at 4:17 AM David Miller <davem@davemloft.net> wrote:
>
> From: Chuhong Yuan <hslester96@gmail.com>
> Date: Sat, 16 Nov 2019 22:23:10 +0800
>
> > This driver forgets to kill tasklet in remove.
> > Add the call to fix it.
> >
> > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> > ---
> > Changes in v2:
> >   - Rebase on net-next.
>
> Does this bug exist in mainline?  Then this bug fix should target 'net'.
>

This bug exists in mainline but this file has been modified in net-next, so
the line number is a little different.

> You must also provide an appropriate Fixes: tag which indicates the commit
> which introduced this bug.
>
> Thank you.
