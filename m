Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17CF48375C
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 18:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733174AbfHFQzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 12:55:06 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43586 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732117AbfHFQzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 12:55:05 -0400
Received: by mail-qt1-f195.google.com with SMTP id w17so4617284qto.10;
        Tue, 06 Aug 2019 09:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Df+LCEv+T4b6Z6pfKKCOSvHh3va9XEDcttnpJg7RZRE=;
        b=SKA3DTVoMvfB/VQQfZZdFXoYKREoJipx1zYEirYw7RTuUHHLkdX38xN3zvzMK6bmdP
         AU7tT9n1NeWduxX4amIEjYkLLqcaeN2d5/cg3UytSKWX5saF4PmeA3vGWguyKLnXgZJG
         f1j6tu/7BbdHk9SXJrdfCc8wJoS02kHK3QHg6Q+JPrNpURALiIFCM1P3aA5tGFrixWse
         cmtmQ9HxpvQ4BHXFI0WsAn/WKh+z5B6hqe+dsrtePo0txG9Y3UE/o0aZBpoHvDrSx1nK
         gv6/ACIjsDYaVY+crDFCEukPqhe+muFTchnFuDjkjdqVsu9xLg6bXseWx7JZCpWml90z
         AHIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Df+LCEv+T4b6Z6pfKKCOSvHh3va9XEDcttnpJg7RZRE=;
        b=C2y7ENfZas5QHWmVjk9MhQFtg5OjaOhGnfc7iPnfj/211dcBF0ua5UNx0AUtekoHfe
         B3qWtsebszTfETOSpPb8OuvmO0w0V2q+vGE7qk0zqn8n8oIsuREVHY+La5Vx7Ndc4feP
         aXJZmF5Ei1yiU0yfVFiEZncY/yop2/9n+kK1uInVXe0VsTBEzHrBPrP7fVk1Z8fneLts
         QXCLIaDIXFcrqbAM8Xn48q3q0XmB8QzUlqkta4XnGvckC7MwyEsE93MzUeewR9SUZpRt
         ZRjIzItCq29jSQN3nwzPgEp52PjEZiRwEE39qiAQ6jDETRkzDl3uK+egxJ0ZoTBNiAsF
         +ucA==
X-Gm-Message-State: APjAAAXrklGAhIpkq8H6MaXPabhpA9JlnVZrATYpceB1mlb2T+LqjtQ7
        5JpH8QIJg4RiTi7EGFlhCIGY3kQFUJONDuOFtD0=
X-Google-Smtp-Source: APXvYqzhBIYUu6BvwTk+uqJsACasncn44f1p+JK5OpiLU7fHDo/YNVIMSRLZjYONZ53stRAEugDWcmHB29eGcnHHGjk=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr3891178qta.171.1565110504261;
 Tue, 06 Aug 2019 09:55:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190805154055.197664-1-sdf@google.com> <20190805154055.197664-2-sdf@google.com>
In-Reply-To: <20190805154055.197664-2-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 6 Aug 2019 09:54:53 -0700
Message-ID: <CAEf4BzYmhLU1E4gFg8cGcx0_JOF_qW21zoFAYOTq0v1_TnkJEA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/3] selftests/bpf: test_progs: switch to open_memstream
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

On Mon, Aug 5, 2019 at 8:41 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Use open_memstream to override stdout during test execution.
> The copy of the original stdout is held in env.stdout and used
> to print subtest info and dump failed log.
>
> test_{v,}printf are now simple wrappers around stdout and will be
> removed in the next patch.
>
> v3:
> * don't do strlen over log_buf, log_cnt has it already (Andrii Nakryiko)
>
> v2:
> * add ifdef __GLIBC__ around open_memstream (maybe pointless since
>   we already depend on glibc for argp_parse)
> * hijack stderr as well (Andrii Nakryiko)
> * don't hijack for every test, do it once (Andrii Nakryiko)
> * log_cap -> log_size (Andrii Nakryiko)
> * do fseeko in a proper place (Andrii Nakryiko)
> * check open_memstream returned value (Andrii Nakryiko)
>
> Cc: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

Thanks a lot, this looks very good. Just please let's do one field per
line in structs (see below).

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  tools/testing/selftests/bpf/test_progs.c | 115 ++++++++++++-----------
>  tools/testing/selftests/bpf/test_progs.h |   2 +-
>  2 files changed, 61 insertions(+), 56 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> index db00196c8315..9556439c607c 100644
> --- a/tools/testing/selftests/bpf/test_progs.c
> +++ b/tools/testing/selftests/bpf/test_progs.c
> @@ -40,14 +40,20 @@ static bool should_run(struct test_selector *sel, int num, const char *name)
>
>  static void dump_test_log(const struct prog_test_def *test, bool failed)
>  {
> +       if (stdout == env.stdout)
> +               return;
> +
> +       fflush(stdout); /* exports env.log_buf & env.log_cnt */
> +
>         if (env.verbose || test->force_log || failed) {
>                 if (env.log_cnt) {
> -                       fprintf(stdout, "%s", env.log_buf);
> +                       fprintf(env.stdout, "%s", env.log_buf);
>                         if (env.log_buf[env.log_cnt - 1] != '\n')
> -                               fprintf(stdout, "\n");
> +                               fprintf(env.stdout, "\n");
>                 }
>         }
> -       env.log_cnt = 0;
> +
> +       fseeko(stdout, 0, SEEK_SET); /* rewind */
>  }
>
>  void test__end_subtest()
> @@ -62,7 +68,7 @@ void test__end_subtest()
>
>         dump_test_log(test, sub_error_cnt);
>
> -       printf("#%d/%d %s:%s\n",
> +       fprintf(env.stdout, "#%d/%d %s:%s\n",
>                test->test_num, test->subtest_num,
>                test->subtest_name, sub_error_cnt ? "FAIL" : "OK");
>  }
> @@ -79,7 +85,8 @@ bool test__start_subtest(const char *name)
>         test->subtest_num++;
>
>         if (!name || !name[0]) {
> -               fprintf(stderr, "Subtest #%d didn't provide sub-test name!\n",
> +               fprintf(env.stderr,
> +                       "Subtest #%d didn't provide sub-test name!\n",
>                         test->subtest_num);
>                 return false;
>         }
> @@ -100,53 +107,7 @@ void test__force_log() {
>
>  void test__vprintf(const char *fmt, va_list args)
>  {
> -       size_t rem_sz;
> -       int ret = 0;
> -
> -       if (env.verbose || (env.test && env.test->force_log)) {
> -               vfprintf(stderr, fmt, args);
> -               return;
> -       }
> -
> -try_again:
> -       rem_sz = env.log_cap - env.log_cnt;
> -       if (rem_sz) {
> -               va_list ap;
> -
> -               va_copy(ap, args);
> -               /* we reserved extra byte for \0 at the end */
> -               ret = vsnprintf(env.log_buf + env.log_cnt, rem_sz + 1, fmt, ap);
> -               va_end(ap);
> -
> -               if (ret < 0) {
> -                       env.log_buf[env.log_cnt] = '\0';
> -                       fprintf(stderr, "failed to log w/ fmt '%s'\n", fmt);
> -                       return;
> -               }
> -       }
> -
> -       if (!rem_sz || ret > rem_sz) {
> -               size_t new_sz = env.log_cap * 3 / 2;
> -               char *new_buf;
> -
> -               if (new_sz < 4096)
> -                       new_sz = 4096;
> -               if (new_sz < ret + env.log_cnt)
> -                       new_sz = ret + env.log_cnt;
> -
> -               /* +1 for guaranteed space for terminating \0 */
> -               new_buf = realloc(env.log_buf, new_sz + 1);
> -               if (!new_buf) {
> -                       fprintf(stderr, "failed to realloc log buffer: %d\n",
> -                               errno);
> -                       return;
> -               }
> -               env.log_buf = new_buf;
> -               env.log_cap = new_sz;
> -               goto try_again;
> -       }
> -
> -       env.log_cnt += ret;
> +       vprintf(fmt, args);
>  }
>
>  void test__printf(const char *fmt, ...)
> @@ -477,6 +438,48 @@ static error_t parse_arg(int key, char *arg, struct argp_state *state)
>         return 0;
>  }
>
> +static void stdio_hijack(void)
> +{
> +#ifdef __GLIBC__
> +       if (env.verbose || (env.test && env.test->force_log)) {
> +               /* nothing to do, output to stdout by default */
> +               return;
> +       }
> +
> +       /* stdout and stderr -> buffer */
> +       fflush(stdout);
> +
> +       env.stdout = stdout;
> +       env.stderr = stderr;
> +
> +       stdout = open_memstream(&env.log_buf, &env.log_cnt);
> +       if (!stdout) {
> +               stdout = env.stdout;
> +               perror("open_memstream");
> +               return;
> +       }
> +
> +       stderr = stdout;
> +#endif
> +}
> +
> +static void stdio_restore(void)
> +{
> +#ifdef __GLIBC__
> +       if (stdout == env.stdout)
> +               return;
> +
> +       fclose(stdout);
> +       free(env.log_buf);
> +
> +       env.log_buf = NULL;
> +       env.log_cnt = 0;
> +
> +       stdout = env.stdout;
> +       stderr = env.stderr;
> +#endif
> +}
> +
>  int main(int argc, char **argv)
>  {
>         static const struct argp argp = {
> @@ -496,6 +499,7 @@ int main(int argc, char **argv)
>
>         env.jit_enabled = is_jit_enabled();
>
> +       stdio_hijack();
>         for (i = 0; i < prog_test_cnt; i++) {
>                 struct prog_test_def *test = &prog_test_defs[i];
>                 int old_pass_cnt = pass_cnt;
> @@ -523,13 +527,14 @@ int main(int argc, char **argv)
>
>                 dump_test_log(test, test->error_cnt);
>
> -               printf("#%d %s:%s\n", test->test_num, test->test_name,
> -                      test->error_cnt ? "FAIL" : "OK");
> +               fprintf(env.stdout, "#%d %s:%s\n",
> +                       test->test_num, test->test_name,
> +                       test->error_cnt ? "FAIL" : "OK");
>         }
> +       stdio_restore();
>         printf("Summary: %d/%d PASSED, %d FAILED\n",
>                env.succ_cnt, env.sub_succ_cnt, env.fail_cnt);
>
> -       free(env.log_buf);
>         free(env.test_selector.num_set);
>         free(env.subtest_selector.num_set);
>
> diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
> index afd14962456f..4c00fc79ac5f 100644
> --- a/tools/testing/selftests/bpf/test_progs.h
> +++ b/tools/testing/selftests/bpf/test_progs.h
> @@ -56,9 +56,9 @@ struct test_env {
>         bool jit_enabled;
>
>         struct prog_test_def *test;
> +       FILE *stdout, *stderr;

Please, let's not do this in structs: one field per line.

>         char *log_buf;
>         size_t log_cnt;
> -       size_t log_cap;
>
>         int succ_cnt; /* successful tests */
>         int sub_succ_cnt; /* successful sub-tests */
> --
> 2.22.0.770.g0f2c4a37fd-goog
>
