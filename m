Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8728A46A5F9
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348195AbhLFTwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348734AbhLFTwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:52:30 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C0BC0613F8
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 11:49:00 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id e136so34393267ybc.4
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 11:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=44VnNMrcwElmJ7beq23CwgdYBTYILuvvj0GaQWXKwX4=;
        b=sXtj+tMfnjFOzuxyI7b+EvklqedC/j7aRm1UxNqMTgI/0XjUtkPcVkfsanhqtCVVdz
         vZnsur4EogDfzYBoQ9HfGjUgiZ4mSbbAFfOEvegScfRPX/oNXbviGr/+gjpUfcQR0AVm
         FgbKXa5JzyI8MsJBPT+fsuu02FtZRFGe0BxTn0RBj5rCZu7yvmrr4VR2sBlHqFC7x6BC
         Oa0upJ6O4Lbj1tsA9+qRFYrI7Jj9w1q+BTuciElhZcFCbgf/uh0bD79cWfcJmz08atri
         je47C6A0XuDTV+1B2rHSye9O5HFJl9oqoB6C575FsWp9yEpytYuW2BZBsQQo21OrzfMj
         dUIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=44VnNMrcwElmJ7beq23CwgdYBTYILuvvj0GaQWXKwX4=;
        b=SUkcon0y4KiOBQsZ+ruWy4vlGb+DMZLJs/RrfC+1volO0HGoGkiggJpSLIueRpNgLg
         bZnos6gi97gEBsI1ECYxkEeZbGndzgvcP9kNKsY8QYdHfNF9ELFyaSPmPAxPKDVkHPNQ
         EtC30B8guMTt+KHgVhh59d0lQtBMWTsqPFfjRzTiinSU3Si4Gw64z3xA0PBxr6kTD/q2
         PGtLWFH3zlZHJJp13//akC8c4ce0IEMcZUBLsYpRbxLTbQ1qfGIzJ1rvP8pG3G+e4qI5
         QhFwSNEZpS9CUdjaIE7FfbshH6CkIODQgK2Px2N6SVyCxGNHOyUaTZC5b3gAK1KH1yrD
         GJUw==
X-Gm-Message-State: AOAM530J+x+FyQdelE7DHjI63WvUFHAynNVQ7Td9ZjAoNxtwJLrJ+5q/
        ON9sroeDSxPfVmArrCt2ka2eOwrexyhQYZEUOfSLx9AUNLRGUQ==
X-Google-Smtp-Source: ABdhPJwSgaTdWDCWSpOiI/rUduIu2Xit9mHdvAA1rEnzUouE8FUICVn+DdE+77RCmxvDktsNdZiEOSkU6ptTv+kjiWk=
X-Received: by 2002:a05:6902:120e:: with SMTP id s14mr48270249ybu.277.1638820139023;
 Mon, 06 Dec 2021 11:48:59 -0800 (PST)
MIME-Version: 1.0
References: <20211025203521.13507-1-hmukos@yandex-team.ru> <20211206191111.14376-1-hmukos@yandex-team.ru>
 <20211206191111.14376-4-hmukos@yandex-team.ru>
In-Reply-To: <20211206191111.14376-4-hmukos@yandex-team.ru>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 6 Dec 2021 11:48:48 -0800
Message-ID: <CANn89iJWv5Dr7xauozUaCEzbuJpsGADBtgKOnDqZhDyQcnUhew@mail.gmail.com>
Subject: Re: [RFC PATCH v3 net-next 3/4] bpf: Add SO_TXREHASH setsockopt
To:     Akhmat Karakotov <hmukos@yandex-team.ru>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        mitradir@yandex-team.ru, tom@herbertland.com, zeil@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 6, 2021 at 11:11 AM Akhmat Karakotov <hmukos@yandex-team.ru> wrote:
>
> Add bpf socket option to override rehash behaviour from userspace or from bpf.
>
> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> ---
>

Reviewed-by: Eric Dumazet <edumazet@google.com>
