Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F7746A5FA
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348706AbhLFTxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346214AbhLFTxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:53:20 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0FAC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 11:49:51 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id j2so34336329ybg.9
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 11:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vZ2gwoV4XKJaAeZ6eTNGpFY/vqnDetYk/4eXucw/uUI=;
        b=l6sQmO9SiZjQ+Zlbb550qq0gYFOwelpAr+MudumgPzEHYY3qVHs9H7AJ5XIJd27Jnd
         0CT9fqTwHQ81cW2dAXNqEZO/0hyn4T0dnLka5UCnD6R53O4g8B/IpIWUledsPdqQ3jW4
         b/IjOBw1yfjENSlOo9XpPAPIES0va1DnrYu00VNCkg9BaS7NY+ZlquBfQmMGAekiPXjs
         jypcuzTdbjsccysT67P3ZG9DEz8WEiAmoOYmeinhw15JiLzvAHQo5mysYdNeQ3RZJOdH
         TdOo4xPendgyVCQ4kQHOCwlPjxzjBBQhBXhAPedhdJD7xPvCLPqH/1GrXfjR5S+gAzsq
         aGJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vZ2gwoV4XKJaAeZ6eTNGpFY/vqnDetYk/4eXucw/uUI=;
        b=C100/Uo3UO0QTk9wuj61SHR7gPoYXl4BT6lBaAc5kTsERgExwRKTdFMF2EsD6oAHqZ
         Bb4Jycq8jwdbsYdtVXQeLpfn+WGJkW3NtQJEWYjTsGhWk0yszJ+fWf39dyHAy7iSH8vY
         OSnE1oYFh50wwUXMwO8TAa4S2aqNaVCMBSsP6jFIdlCKDJxSo2xLQi4HlS/njXSOmSRB
         xT/MUwVRs+puFLuuj8loxSIHgiShRCizYWGgWlClbGhWiVXb1QOmyvtcnn9mpqD3lF1N
         0XO7+ZGMrru7gv/EOEDeGbtMMRoPNfg+WQpFxvBrSGzGAiW+H6F1gRtCIbax7lQd2cq+
         ki2w==
X-Gm-Message-State: AOAM530splYrJ2fpi23s8xYvPh1U6bnNC+jI5AlIVSepZT5NLzOsUhXv
        Gf+SozI82pIDGf3qPInK3L7fWafHru0eGULbl++h7M7p19x+eQ==
X-Google-Smtp-Source: ABdhPJx0seH0Fl0zKbqwmKef3k8IZObZYSk9GyJcK5oItxaZDsElvcEaTxmusX69lhZVNrQ7pPC9UT/ZONRui5rbSc4=
X-Received: by 2002:a25:9d82:: with SMTP id v2mr6148233ybp.383.1638820190101;
 Mon, 06 Dec 2021 11:49:50 -0800 (PST)
MIME-Version: 1.0
References: <20211025203521.13507-1-hmukos@yandex-team.ru> <20211206191111.14376-1-hmukos@yandex-team.ru>
 <20211206191111.14376-5-hmukos@yandex-team.ru>
In-Reply-To: <20211206191111.14376-5-hmukos@yandex-team.ru>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 6 Dec 2021 11:49:39 -0800
Message-ID: <CANn89iLMUqAuUprbNLUtXOcrbW6wvZytveb89S1T_7u_ZVS8GA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 net-next 4/4] tcp: change SYN ACK retransmit
 behaviour to account for rehash
To:     Akhmat Karakotov <hmukos@yandex-team.ru>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        mitradir@yandex-team.ru, tom@herbertland.com, zeil@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 6, 2021 at 11:11 AM Akhmat Karakotov <hmukos@yandex-team.ru> wrote:
>
> Disabling rehash behavior did not affect SYN ACK retransmits because hash
> was forcefully changed bypassing the sk_rethink_hash function. This patch
> adds a condition which checks for rehash mode before resetting hash.
>
> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> ---
>

Reviewed-by: Eric Dumazet <edumazet@google.com>
