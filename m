Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE150837E4
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733175AbfHFR3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:29:12 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40820 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729898AbfHFR3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:29:12 -0400
Received: by mail-qt1-f194.google.com with SMTP id a15so85323898qtn.7;
        Tue, 06 Aug 2019 10:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zSlFpbTfADXnmp18wSkMezblJm4v25W9iEY35ivt4+8=;
        b=su8Y1Q0V9bNQSsWKvh/E1iGOu31UD3LaU4IaM4bDmVudN/lui4ysUZ7ziBR/XslQ9Q
         C9FW2+i0xtQHKwAQu/k1XHudHwNeF/ONtl2YPJMulGgkC2rbDzDTfLyy9hpB3vVYaXLN
         DRWdTd8gntSyaJktErpF7rgTSoh8+lfBeaF2bNZxppks9LjkNFVPSrnSr+U11aFpF9V5
         GqfR2d1C2x013vlW+NcAscUl1MO6HsYmkavhzj3Ew2b0kS0IvjO1NbOs+6o9bKurRxxi
         fDyWxVXZK/EAf2WrITtOlncepxwDkeZzdsMgQK/WLS9ywj9VPAk8jlXmDWbLdUinBZPv
         WyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zSlFpbTfADXnmp18wSkMezblJm4v25W9iEY35ivt4+8=;
        b=bxjMfoAKad6sNTTZf4b8Af6D+Ouu6KqoDcMcHTG57bbIyT1g8ioKqq99fXl/St+rc3
         WauyN0K0csJH1vCt5VDprVRgijiSLJiCaj2rn69X+XvmdRVOX1G1vOpdexNVX5YOnPSV
         PJIOnOyBGq73w8MewjwOxgAlx9r9+VTv1oE5X7lRDOYrC6hGej7BXtuj2U1iXAXOGQ9b
         5opCAErQhxG9OokoZeyC3WfkzJlPTV/WoXLuq7GcS3EBBwGd6hyV4wZTACcOZaimZ3UX
         IzRD+jmNppMCIdPHFjQZYmHUnRBQVp7+xz+ba4bue4BvQovZhXMtKfvNz676X85+6p6a
         DkVQ==
X-Gm-Message-State: APjAAAWEzVTBtGFpW44OUHgTL2Qtc77TQFgzCYcCdDTOHLytFD2rP/IX
        72GkPinrAl1iPWyjyw9w2ANvATBpOtvrZr2W3boE9WNgdfcGEQ==
X-Google-Smtp-Source: APXvYqyVrfBzEvkFVHSEVs+ZSSva5A0SE/7YjCZpeZJuT81jWkhWydeP1ORSlH8xfBJkJX/knz86JV9aevtxxsvHcWg=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr4054550qty.141.1565112551166;
 Tue, 06 Aug 2019 10:29:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190806170901.142264-1-sdf@google.com> <20190806170901.142264-2-sdf@google.com>
In-Reply-To: <20190806170901.142264-2-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 6 Aug 2019 10:29:00 -0700
Message-ID: <CAEf4BzYU6xfcPrHzz0p6dWL3_VM2mD9pKy3T-NfnuDUrd4RMDQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/3] selftests/bpf: test_progs: switch to open_memstream
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

On Tue, Aug 6, 2019 at 10:19 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Use open_memstream to override stdout during test execution.
> The copy of the original stdout is held in env.stdout and used
> to print subtest info and dump failed log.
>
> test_{v,}printf are now simple wrappers around stdout and will be
> removed in the next patch.
>
> v4:
> * one field per line for stdout/stderr (Andrii Nakryiko)
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
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/testing/selftests/bpf/test_progs.c | 115 ++++++++++++-----------
>  tools/testing/selftests/bpf/test_progs.h |   3 +-
>  2 files changed, 62 insertions(+), 56 deletions(-)
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

I just also realized that you don't need `(env.test &&
env.test->force_log)` test. We hijack stdout/stderr before env.test is
even set, so this does nothing anyways. Plus, force_log can be set in
the middle of test/sub-test, yet we hijack stdout just once (or even
if per-test), so it's still going to be "racy". Let's buffer output
(unless it's env.verbose, which is important to not buffer because
some tests will have huge output, when failing, so this allows to
bypass using tons of memory for those, when debugging) and dump at the
end.

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
> index afd14962456f..541f9eab5eed 100644
> --- a/tools/testing/selftests/bpf/test_progs.h
> +++ b/tools/testing/selftests/bpf/test_progs.h
> @@ -56,9 +56,10 @@ struct test_env {
>         bool jit_enabled;
>
>         struct prog_test_def *test;
> +       FILE *stdout;
> +       FILE *stderr;
>         char *log_buf;
>         size_t log_cnt;
> -       size_t log_cap;
>
>         int succ_cnt; /* successful tests */
>         int sub_succ_cnt; /* successful sub-tests */
> --
> 2.22.0.770.g0f2c4a37fd-goog
>
