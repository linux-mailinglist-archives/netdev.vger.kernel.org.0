Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8FEAC28B
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 00:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405017AbfIFWaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 18:30:02 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44364 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729244AbfIFWaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 18:30:02 -0400
Received: by mail-qt1-f196.google.com with SMTP id u40so9001155qth.11;
        Fri, 06 Sep 2019 15:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vh+tv90X665lH/REtb6+/d610dr7rZMEwkHzJTf882g=;
        b=Z3O3wzzSdrMCen6a3VYOrtXrC/0pmnPywB8TgWjdXJ8jQG0tRPdlJZpkOnuuTTxD5I
         jOe73Up7lDdHvNyzx/M+JjbwpOZtXBY82MuWBZCWuxTjpA6Nbd7D1lEpnyZwO3+Oq9Rl
         LMFCAjOrJQk1aBUkxS8x1piKBDd+KW0bpyI/6Ehs8sS3eOztmwxq24M8OcabgCAOpZsO
         wQcnIJX/h4IUxGDpOngbwJ29rGGRP2om+Ua+JZcgQOuHKTyloEJPuYoA3NqMK1Q69X9N
         hKbJVlL/SYEij5vu/+kkCGZeQ5f0IN/MkE+FfcEMrbF1xBYd7/QwHWOp4mItUGzUm41u
         FG8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vh+tv90X665lH/REtb6+/d610dr7rZMEwkHzJTf882g=;
        b=Byh5k0WRJYys07/9plfX6cjGkU8xojYt+CuQmBo67Hdy+v6k/3bWcy/S8ATJPvevcw
         RP6/REhX7nRox3zSxtMp0gS+yrGw76a4u1dmJU9T95p+W1XWhrtC6xPBYNaQKWNh4qzx
         NvVskElW/gus/8IffSrwLoPQalt18MhVPd1wCeCQ6PdUfC8rzBKDBVCCS0OzMpVI92a0
         HPcii8Vu/kdeG2vwwiaRVyueejsyOe1hE+kex4Ooq7mLYh2vOGCb9HlqwHvhjNnUDrQi
         XOACcv9cqUTtLIFZZwGnqARfUkRsW1Ua0MJCzFIDezXobGLPc2vpy5TSiVL2B0zoUK2D
         Pk2g==
X-Gm-Message-State: APjAAAXSelyXXpjeqMHAoLhgZ/i23yhRRE3aT4RTYV5Ii0GDdQDno0ds
        iwsPneHwX7W42LNAIJk1Z0y7RoPf/3Tz/aXqJyB4OLTx55265Q==
X-Google-Smtp-Source: APXvYqz9fb4t7d8gRm1dZxb0sRijNXhl4SHv/ja68oTb6HnH6D35H1gu4yLcVFjFMAFA2DcdwaoVyZrZ0UdHBjs0rQI=
X-Received: by 2002:ac8:c01:: with SMTP id k1mr11522625qti.59.1567809000648;
 Fri, 06 Sep 2019 15:30:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190905152709.111193-1-sdf@google.com> <20190905152709.111193-2-sdf@google.com>
In-Reply-To: <20190905152709.111193-2-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Sep 2019 23:29:49 +0100
Message-ID: <CAEf4Bzb=0gJv148r+RARMOYHikvvrzXJ-o5jQ7F_WtSzhRF38w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/6] selftests/bpf: test_progs: add
 test__join_cgroup helper
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 5, 2019 at 7:40 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> test__join_cgroup() combines the following operations that usually
> go hand in hand and returns cgroup fd:
>
>   * setup cgroup environment (make sure cgroupfs is mounted)
>   * mkdir cgroup
>   * join cgroup
>
> It also marks a test as a "cgroup cleanup needed" and removes cgroup
> state after the test is done.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

First of all, thanks a lot for all these improvements to test_progs
and converting existing tests to test_progs tests, it's great to see
this consolidation!

[...]

> @@ -17,6 +18,7 @@ struct prog_test_def {
>         int error_cnt;
>         int skip_cnt;
>         bool tested;
> +       bool need_cgroup_cleanup;
>
>         const char *subtest_name;
>         int subtest_num;
> @@ -122,6 +124,39 @@ void test__fail(void)
>         env.test->error_cnt++;
>  }
>
> +int test__join_cgroup(const char *path)

This doesn't seem to be testing-specific functionality, tbh. It's
certainly useful helper, but I don't think it warrants test__ prefix.

As for test->need_cgroup_cleanup field, this approach won't scale if
we need other types of custom/optional clean up after test ends.
Generic test framework code will need to know about every possible
custom setup to be able to cleanup/undo it.

I wonder if generalizing it to be able to add custom clean up code
(some test frameworks have "teardown" overrides for this) would be
cleaner and more maintainable solution.

Something like:

typedef void (* test_teardown_fn)(struct test *test, void *ctx);

/* somewhere at the beginning of test: */
test__schedule_teardown(test_teardown_fn cb, void *ctx);

[...]

> +
> +               if (test->need_cgroup_cleanup)
> +                       cleanup_cgroup_environment();

Then in generic framework we'll just process a list of callbacks and
call each one with stored ctx per each callback (in case we need some
custom data to be stored, of course).

Thoughts?

[...]
