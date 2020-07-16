Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0482221B78
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 06:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgGPEmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 00:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgGPEmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 00:42:03 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B078EC061755;
        Wed, 15 Jul 2020 21:42:03 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id d27so3955986qtg.4;
        Wed, 15 Jul 2020 21:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d2+VUiTeP/3i8MXi5Fgv0f9682uC6rlMBdbv4Gmpydg=;
        b=fTCJdwEFQMWzND2j301sY82VhTJvX5qbT3lnIiVew6+eUbp5X2ouDPO8rVA60lVV3J
         ThPKTtDkkhbqZkcZIJKSkZ/dJjR/q4jIbKLTV0I6jWyYnr2z/zC/cig6jPBarMYK5uzb
         6TaoaGW6Q0lE8hynufGxNg/zy9CGhxAETVl+K0J6wzBp8Prav34eqObQYHSdRSQmUW4e
         IQQJKteP/6Qs9xJ/spi9amwVQUFgAYnhlw4LH5TneIp9KV0nKWE5DNbNNN2njmKhw9n3
         qWhUZ5jeElnUqOtoCPpRIGGj8Am0+TcxAormyTVGKPdgad27A4IBoiuEQEhlO5Vhhu5h
         RmQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d2+VUiTeP/3i8MXi5Fgv0f9682uC6rlMBdbv4Gmpydg=;
        b=RjJA+13mmFr2n6Q0pSloAn13PLIfmcTpajHe9isystEkL85r5cLB2egm4Z9bqGyNUi
         0sXvbE+S/JSVG4V466hsWhwwn0iD0Fmdi63r3RzpS6QgomRGNOJ9DLNDhX5A679d+FKA
         MNYWWS8to2nnYB/LtpMVOyGmPD5E9YqXkSTUc+jO4+m2fV38qS9YfikJVhh00GYiW0I2
         zbH7hvRRwzJbe/TS2E4PDAa/2QyZU/p2GyjFqdfe2cZ+OAvoqLVq8xT01Pu1ZzS34blx
         bv+AV1DBlxsmhUWiaGrOfu0EVz5IZP4gfQVUFLuDyhZHs+I6lTy8CkxyTRMRZYAOa9Xq
         qTSg==
X-Gm-Message-State: AOAM530S5ROLTusfQ0H1ql4klwjsfaDgcfAv7VH54MYdtyJWfKxF8m3J
        Qw4Oztu4w7cDER3FitH+emQA3U7gC+5pFIbUL0g=
X-Google-Smtp-Source: ABdhPJzkPqrqBp4OfozYc7EUsn04rJigqEDiiBnhB6HUDp2MhSYALix4jvYaRJNChTrVSv1EryJ3GItSwdTbO0J6Dxg=
X-Received: by 2002:ac8:19c4:: with SMTP id s4mr3302089qtk.117.1594874522755;
 Wed, 15 Jul 2020 21:42:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200715224107.3591967-1-sdf@google.com>
In-Reply-To: <20200715224107.3591967-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jul 2020 21:41:51 -0700
Message-ID: <CAEf4Bzajc9zZM8MLhJBQ+1DgVVC8UEwVHMvgcBiePOatZ-rovQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix possible hang in sockopt_inherit
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 3:41 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Andrii reported that sockopt_inherit occasionally hangs up on 5.5 kernel [0].
> This can happen if server_thread runs faster than the main thread.
> In that case, pthread_cond_wait will wait forever because
> pthread_cond_signal was executed before the main thread was blocking.
> Let's move pthread_mutex_lock up a bit to make sure server_thread
> runs strictly after the main thread goes to sleep.
>
> (Not sure why this is 5.5 specific, maybe scheduling is less
> deterministic? But I was able to confirm that it does indeed
> happen in a VM.)
>
> [0] https://lore.kernel.org/bpf/CAEf4BzY0-bVNHmCkMFPgObs=isUAyg-dFzGDY7QWYkmm7rmTSg@mail.gmail.com/
>
> Reported-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Great, thanks for figuring this out! Hopefully this is it.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c b/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
> index 8547ecbdc61f..ec281b0363b8 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c
> @@ -193,11 +193,10 @@ static void run_test(int cgroup_fd)
>         if (CHECK_FAIL(server_fd < 0))
>                 goto close_bpf_object;
>
> +       pthread_mutex_lock(&server_started_mtx);
>         if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
>                                       (void *)&server_fd)))
>                 goto close_server_fd;
> -
> -       pthread_mutex_lock(&server_started_mtx);
>         pthread_cond_wait(&server_started, &server_started_mtx);
>         pthread_mutex_unlock(&server_started_mtx);
>
> --
> 2.27.0.389.gc38d7665816-goog
>
