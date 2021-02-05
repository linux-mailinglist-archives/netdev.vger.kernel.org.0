Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60BC3114D3
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbhBEWPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:15:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbhBEOhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:37:37 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E498C06178C
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 08:15:31 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id p15so6268439ilq.8
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 08:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b3zypKCzWyxay+UIu/YEc9Osf3cOdr0Kv47aU++eg2A=;
        b=wHMwWR7atLxSylIAhPsg+XbGgy2ngza9cJiVuoTVVSRT0VYoznd3z5oa6u2NIK+423
         7ruKeIDQbtM7op5nTyQZmCjfIzSe2FJ2ZGzZp9qJtXTFOCDKC7YrV6YS1G+qT47ZCsEG
         yImFk7Z9WJdF99Z+PUzvlKEs+JTVCt7Ex3+iEc0Qw2h6zz/IN0CbNAY3178P1ufzwFHY
         2+mmqmYvTt/v2G9im0KE5xrUkTPqEuSwz1sduaV6b+TdaveBM45BWwxE2wq0IMMvINFJ
         Rn1jEa/YEN/wxt3xacyQMoyZFfx4F+KqRIkPAfe57u6t+tXRoUuhAllT1IDUT4MHIqH2
         ONPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b3zypKCzWyxay+UIu/YEc9Osf3cOdr0Kv47aU++eg2A=;
        b=BAVqyQNYWWwJ1PYpu6PVC3U2q6Zcl+sH8FZ2g7Y3lP0H6udRJ9jVCaj3AiPHDrSwmT
         qCiBMukyK+9lXJoPI0mdbYZhhSqCCsJHy8QCeS4H8TDwCAI/HrVCbAS0oFN8RPO/aWEK
         +ymzhjxhlhdPX/9bRgsWU96WxF1/LjAxYdOSkZuRn46gZ4FpcWX0OwkK+RUWk5ARo/xB
         h1c5jcyiQQIMGAOhgAutiO3YDU2ghUne1um5fpjgHEHtUGvV+2JQ6B5ZAu8lmNgS+b2o
         0ULBK8yn9kO2HlAEr11IOAnd/VIDrTFsBzLXCcrjCYB7Dz3UAVtxWUC2fTQDsLgZhUrT
         Ugzw==
X-Gm-Message-State: AOAM531SbSZBoNTIyjW9/dpMFGaU9myxRMUgX1WPKG/Bh4lH3jL2LBPf
        EZ7cYuhimLU6i2nVvCuTxf4bHwcDqDMvfkM0okCWOZ6isS9wzO+e
X-Google-Smtp-Source: ABdhPJxe5vVd/CExVuPqdcTkzVFPRKKdBfU/HunhfInTRU8aAUoq7Spk84lhtpbSN+V7AcZIdO4t/9CQJ0/PFYf74d8=
X-Received: by 2002:a92:d3c7:: with SMTP id c7mr3834270ilh.137.1612534233334;
 Fri, 05 Feb 2021 06:10:33 -0800 (PST)
MIME-Version: 1.0
References: <20210204213146.4192368-1-eric.dumazet@gmail.com>
 <dbad0731e30c920cf4ab3458dfce3c73060e917c.camel@kernel.org>
 <CANn89iJ4ki9m6ne0W72QZuSJsBvrv9BMf9Me5hL9gw2tUnHhWg@mail.gmail.com> <20210205130238.5741-1-alobakin@pm.me>
In-Reply-To: <20210205130238.5741-1-alobakin@pm.me>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 5 Feb 2021 15:10:21 +0100
Message-ID: <CANn89i+Rpxw__Yexvcaga5aQ84CjqAzPZ6FyaO4Ua1yWhB069w@mail.gmail.com>
Subject: Re: [PATCH net] net: gro: do not keep too many GRO packets in napi->rx_list
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Sperbeck <jsperbeck@google.com>,
        Jian Yang <jianyang@google.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Edward Cree <ecree@solarflare.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 5, 2021 at 2:03 PM Alexander Lobakin <alobakin@pm.me> wrote:
>

>
> It's strange why mailmap didn't pick up my active email at pm.me.

I took the signatures from c80794323e82, I CCed all people involved in
this recent patch.

It is very rare I use scripts/get_maintainer.pl since it tends to be noisy.

>
> Anyways, this fix is correct for me. It restores the original Edward's
> logics, but without spurious out-of-order deliveries.
> Moreover, the pre-patch behaviour can easily be achieved by increasing
> net.core.gro_normal_batch if needed.
>
> Thanks!
>
> Reviewed-by: Alexander Lobakin <alobakin@pm.me>
>

Thanks.
