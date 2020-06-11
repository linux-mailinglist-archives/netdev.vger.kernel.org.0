Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90EB91F6F20
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 23:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgFKVEU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 17:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbgFKVEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 17:04:20 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4522C08C5C2
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 14:04:18 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id i25so8023387iog.0
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 14:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QOSq7LGEuq7joF0MKi0FZitcudqJi1UF8Oe0ZqqRITY=;
        b=ejBFiBbtcNieZodpXk84vlOp76dBFyUz0It9ZB89Bm0gwwgSkiQ3Ld3c+E4rAHn+tc
         Ky7P4kv0a3jv8tCtxGD7hbtix7zY1KY0C0+21gkKa3fwbxfDECedpuSWHULM6G/xucVO
         BkK4P2urYL+E7Ek3rsHbB85Lw//zCtmOX3CyO6UXC0FDaJLJUPp61MYlLa6BW3CeUIQv
         hz/3ghDmDm7MMNQwQC8ay46xt5gvI0xZrfxXiSLKUdIsvk2EZVb+fXb/dLexqaC4yak6
         md8V7tpMgcI/yfHTw1GC0foKLJdIws+xSr6EsZpUXE4GwjxSpG9CQxLixDptY57BDvQS
         6isw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QOSq7LGEuq7joF0MKi0FZitcudqJi1UF8Oe0ZqqRITY=;
        b=ZPv9s7he+AnaT3YGiY0GQek6ciLcEbQGbVh3j2aiwsSQuYYbWYQhrsAFviPgFW/S+p
         TxDIJhMhvzALdvpGjU8M1FqpLuj0+qHVQ2iCvZSpovFB7ebW6bx658rMUZf9Go8dmKyO
         NhilfS7lm7Der+r+yEJfYBRjUqth0ErXkC8GDfppVtmUEG689rxp4WboYNduXcjRa2iA
         m8/QFEN2ctck7Nm1v4Fqwv94Xi8ncpZwj0LBi4P9s2KR/82F158xQjxky0s8/m3zAfWG
         AB1fzXwkbuzZMeIzk7XqE2Q3K9Gz01vzLI5if12CDzA638LUdpDKsRMySVtGiIw3gRiQ
         eaTw==
X-Gm-Message-State: AOAM532iBnxpIxQwIaR7RP+DjsB+rPVXMM5kuUhLImXrsUZr62Ys+tlk
        k0WzWXyURzl2CE82rbldawvltSoouhUP6k3Y1swqKQ==
X-Google-Smtp-Source: ABdhPJyO4AzvzoVU07IvyqRN0BNwJCqq3fQQMT4qsrccrqgOXdW1x8Jpn2kXepafXKggJLeehXQ4LnD64mv/X7/NjJU=
X-Received: by 2002:a05:6638:b:: with SMTP id z11mr4888189jao.114.1591909457976;
 Thu, 11 Jun 2020 14:04:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200611140139.17702-1-brgl@bgdev.pl> <20200611.125140.717118972991857444.davem@davemloft.net>
In-Reply-To: <20200611.125140.717118972991857444.davem@davemloft.net>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Thu, 11 Jun 2020 23:04:07 +0200
Message-ID: <CAMRc=MdcW-FQecZViyAEevpJrkREGTc4Xr8zPTAW_QvqGm7P1w@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: mtk-star-emac: simplify interrupt handling
To:     David Miller <davem@davemloft.net>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

czw., 11 cze 2020 o 21:51 David Miller <davem@davemloft.net> napisa=C5=82(a=
):
>
> From: Bartosz Golaszewski <brgl@bgdev.pl>
> Date: Thu, 11 Jun 2020 16:01:39 +0200
>
> > Unfortunately after thorough testing of current mainline, we noticed th=
e
> > driver has become unstable under heavy load. While this is hard to
> > reproduce, it's quite consistent in the driver's current form.
>
> Maybe you should work to pinpoint the actual problem before pushing forwa=
rd
> a solution?

Why would you assume I didn't? I've been trying to figure out this
problem since Monday but since I'm not sure how much time I will be
able to spend on this going forward and due to the fact that this is
now upstream (and broken), I sent this patch. As I said: it doesn't
impact performance nor is this solution inherently wrong - many
drivers do it this way.

I will continue working on this driver on and off so I *do* intend on
fixing it as well as extending it with more support, hence the FIXME
and previous TODO.

Best regards,
Bartosz
