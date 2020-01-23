Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 377961470C3
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 19:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgAWSa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 13:30:29 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35133 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728792AbgAWSa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 13:30:29 -0500
Received: by mail-oi1-f193.google.com with SMTP id k4so3879274oik.2
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 10:30:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vr5I0S8ZDPxOb5zM5pXn+NYPnbMDsXdN1EMcB1OeG/I=;
        b=EfzovU400k/iI6tQ4V+8P783mqVa6lAfsbPnmDggINJlA+uxQoXoNeKrBrQwgvRc+I
         FlaikCSZkwvG35NBxEoXeAFFSM2HNYuXPWWU/78mMvp6yehIGlTpaNBQs4cx0cf/cqoz
         gTkFsB1e1TVPN44Ythuwzkkh/ROHOZibmEnI0tUbVJkNwEv4IDV251yYjFyEWcRDc5l8
         iE25/lxpPwMmlKPTxWfOJtnUd8V0LW8ni40NSklKcBuqBs0DSeuyt/Cwj8yxyiHzh2h9
         SJciiEy+cYSF3NpOOaapnuN5HCcffTNFNVLsRCb+91cDNl7S0JVHaM/dcP/q4g51q9La
         JlqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vr5I0S8ZDPxOb5zM5pXn+NYPnbMDsXdN1EMcB1OeG/I=;
        b=WPEgpwlu0I7pNsxQQmAlZ3FD9zzcom98nerwOHDPKaRO+Y2AdJuZUAT9wjE+6oBTPB
         2rjU/PrcYpaiQ+Fn54q72bocsuMsUDuMgJvBBqxS4YCyl7YDZkvSlR6AJnMZw8QgtSlw
         T0reQdgCZoBbf2/hhqiqaj3x02ywvMrPwCFbdd2iGUzZpN2M6Ra3Pd0Oi5z4cDublyeJ
         OUkYv40g6ykLGu9XXsWvY92rkmuDoncO0w0jcxu6e0kFtDRW8SmTrtI/WIEfpKPg6hSc
         VlNRIJsmWsOe8aZ8YmbizWpGDTIYvz/GMxvJdkwBd+t2QlEsOzLe8+JBtSabfwRARkdR
         NSNw==
X-Gm-Message-State: APjAAAXfL2Qndf2ZWTxt5RW2j+q4u+81pIRSU8eJSKMfzzyrX4zNoJC/
        PdVZJnjD4u2b8CNgR7Y/JaBYhMLyCCcg7xNN1fEqsg==
X-Google-Smtp-Source: APXvYqzYB9qVmIizLX0AZ33Y73eXnF05UQqSzJknBYFg1xJW6moIjSYfpovWOkuH9zwmJWTtrNz09rI88MtFKdXOnC4=
X-Received: by 2002:aca:3354:: with SMTP id z81mr11879179oiz.129.1579804228119;
 Thu, 23 Jan 2020 10:30:28 -0800 (PST)
MIME-Version: 1.0
References: <20200123050300.29767-1-edumazet@google.com>
In-Reply-To: <20200123050300.29767-1-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Thu, 23 Jan 2020 13:30:11 -0500
Message-ID: <CADVnQymsiHLv8N8QeEE-PSqYzB7KjZDwMHHkPtSgZpyW-C=RvQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: do not leave dangling pointers in tp->highest_sack
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Cambda Zhu <cambda@linux.alibaba.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 12:03 AM Eric Dumazet <edumazet@google.com> wrote:
>
> Latest commit 853697504de0 ("tcp: Fix highest_sack and highest_sack_seq")
> apparently allowed syzbot to trigger various crashes in TCP stack [1]
>
> I believe this commit only made things easier for syzbot to find
> its way into triggering use-after-frees. But really the bugs
> could lead to bad TCP behavior or even plain crashes even for
> non malicious peers.
>
> I have audited all calls to tcp_rtx_queue_unlink() and
> tcp_rtx_queue_unlink_and_free() and made sure tp->highest_sack would be updated
> if we are removing from rtx queue the skb that tp->highest_sack points to.
>
> These updates were missing in three locations :
>
> 1) tcp_clean_rtx_queue() [This one seems quite serious,
>                           I have no idea why this was not caught earlier]
>
> 2) tcp_rtx_queue_purge() [Probably not a big deal for normal operations]
>
> 3) tcp_send_synack()     [Probably not a big deal for normal operations]
...
>
> Fixes: 853697504de0 ("tcp: Fix highest_sack and highest_sack_seq")
> Fixes: 50895b9de1d3 ("tcp: highest_sack fix")
> Fixes: 737ff314563c ("tcp: use sequence distance to detect reordering")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Cambda Zhu <cambda@linux.alibaba.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> ---

Thanks, Eric! Indeed this seems to fix things so that now any time the
TCP code base calls either tcp_rtx_queue_unlink() or
tcp_rtx_queue_unlink_and_free() it has first taken care of updating
tp->highest_sack so that there is no dangling pointer.

Acked-by: Neal Cardwell <ncardwell@google.com>

neal
