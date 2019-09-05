Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A63FAAACE9
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 22:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389769AbfIEUWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 16:22:02 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:36362 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388502AbfIEUWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 16:22:02 -0400
Received: by mail-yb1-f196.google.com with SMTP id m9so1342777ybm.3
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 13:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=50gAuLZtacd+ZD7WEnSJn9K6hqclCaMwF3YjxU9BnBE=;
        b=tdKzQ8jsoGamLUXna5uj+vAKF2okfXsCOL1kiJzuiMUF0OUMsWY8ddk3t8RP7J1LZu
         m1iICTkFsKcsOJMmtBhfhZ8glSofKu6SvJ7pFIOwxODJhgNc1+iZ+yacAW/JpYBEcQ6L
         nPfRm23jHAe0YSUIZvinvMKVJQMaxIKgQg3hpY7brnD2uny660LqiQ+11oyjX9FUndEK
         JjomANtMIlQP3H8/PbSNZJzfzkIMagqCwsPkV3y5dsUMi4jOUNA9/L5Gu8jrhtwgBByA
         /WMHZRKNeqoelyQLX53/VVJvaJOXnfKukon4QofkrVS8Dy5sMlA2ebGtCF1CEvisIaud
         qsRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=50gAuLZtacd+ZD7WEnSJn9K6hqclCaMwF3YjxU9BnBE=;
        b=TpuUVtjd8JTqQC0lAxb5tXAvkxMCjpLDduMzdhaYGPJXhJSy/Fj/pNpHlmOJjo6xZY
         VIGICzflI0TYXs7wWBRBZ+yKd/pi7rCgf5lxfCiQe079UJutbaGOD0EDi9hLYbYLt6YJ
         uNo+dAbwZ62dUsJUdyVqYm8IXj4+7IGqW5tdYHWXH+4ylElLVn/SFyxv4LkSlUHc9oyY
         dEDvs+vfoyK1UcyPwpClPTjCLz6ANvUiCmxKBrBKKFeZaoQ1SqoX84kKXjI8BDEF2cAd
         vecNUWGedy6xp8zsux0Uc40WKapz/GjHmT/ZVYYtTc/aB+m0oQ4ksf5jE8qfYC7OQiIy
         RNcQ==
X-Gm-Message-State: APjAAAXYMvXyBDbldoPc7+INk23rdj4+cSbwHPqHKNgXqLFUGM3XdR5r
        3Q5Um+E5CBkCUuxe145wur5kAcBJ9Zfa6xccyIAJew==
X-Google-Smtp-Source: APXvYqxT2rewGkATHiU+S0WBXZ03vO2g8ZpSn+h4gzU/IaKVa96ovOslZ7gXWKlreXBbjmJe9c/6rU3bzMdJfkbBmvE=
X-Received: by 2002:a25:8149:: with SMTP id j9mr3543891ybm.132.1567714920852;
 Thu, 05 Sep 2019 13:22:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190905202041.138085-1-edumazet@google.com>
In-Reply-To: <20190905202041.138085-1-edumazet@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 5 Sep 2019 22:21:49 +0200
Message-ID: <CANn89iLqqe9U+vzwVv6afDjf_qXNbSF+wQr+pAjBvqXajAsSqA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: ulp: fix possible crash in tcp_diag_get_aux_size()
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Luke Hsiao <lukehsiao@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Davide Caratti <dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 5, 2019 at 10:20 PM Eric Dumazet <edumazet@google.com> wrote:
>
> tcp_diag_get_aux_size() can be called with sockets in any state.
>
> icsk_ulp_ops is only present for full sockets.
>
> For SYN_RECV or TIME_WAIT ones we would access garbage.
>
> Fixes: 61723b393292 ("tcp: ulp: add functions to dump ulp-specific information")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Luke Hsiao <lukehsiao@google.com>
> Reported-by: Neal Cardwell <ncardwell@google.com>
> Cc: Davide Caratti <dcaratti@redhat.com>
> ---

Sorry for the 'net' tag. This patch targets net-next tree only.
