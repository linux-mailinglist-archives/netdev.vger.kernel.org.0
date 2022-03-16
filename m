Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920B84DA953
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 05:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353506AbiCPEe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 00:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353524AbiCPEei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 00:34:38 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5CF5DE72;
        Tue, 15 Mar 2022 21:33:22 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id j29so843243ila.4;
        Tue, 15 Mar 2022 21:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=euyETXMgn8MJLQ5JLOKxT1wE375qEl1JaBfagPRCmDw=;
        b=I5VY0PAvEGPxIpCB5RsIl7EXg/2gQ4tBknfNaS08R5G57kj/UFfzVqeOsUbXfGqKpf
         LiqRUmIFF2DSJ4P34pS4t4BbgKIJWd/ch17df6bT7xpJk8bP+3WKdkqiFJW70U+8SY1s
         7HVwBstORMXaqS1gFfnIXGEDsA7+kXMed/q7TusqY1MbhUWSqYxYiPE0Wm1iaSR5tRRF
         PPhuR63qFYgqHz3S3krzf/YeGRSIh934pBP59pTdQN9wDsaNXz7OzNQe6kB2z/dulj+i
         2HRmHZlyWZ8gShAjPKKOYBquH3YioWrFbJbB4H2dSbNXnJSVqOlFE5WcjwcaXsrt51dO
         iXqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=euyETXMgn8MJLQ5JLOKxT1wE375qEl1JaBfagPRCmDw=;
        b=HGfDZXPOnQnBqGivZEPwLKvTRwesM2WpccGz38Pn+CLRZy6qWE/7Sa/akh5Y5Z0bPK
         rdgMYmrQCwZrnoQn1/fpbr/PIGWMBHQlPAt+kTw+b2FqlTjzZmIGkbXMSJT9WoeV7AuF
         PdJLXHIYsfTCgkiI1PG/JUnbNXQ3odXhEn8Zk3ebBsSyZye4Os7NUDtaWhF4a+bwK3k9
         IWvKYjz7RCN0kB83x3limG9cL6Fyck7eMYm8JtXf1VWLUE7CNkLlZ1WndnTCuuBD6I5x
         eSkmTmHmyu0QRI+DxiIADTAK4eV+LQR+541Yv3BXCO8M+zxy7/VRPx9Q1iweCteajDqi
         4p4Q==
X-Gm-Message-State: AOAM5310CGxzd2fPXCA2cpUCjMJE4iN+jfhPZK3TH+Ysjewyi7AmgD4Q
        3MdCJtSl8uAmJBG3F9InZ01l62iWp6BAsxAzX/k=
X-Google-Smtp-Source: ABdhPJxWtFEeDlJiuu2zlKNDVeKePR8y3j8VIENMj0vEm2jiIAfcbI0J3mkEsBYeSmrZSWHWhDNeyT8Ib2e+8XT8eIA=
X-Received: by 2002:a92:6406:0:b0:2bb:f1de:e13e with SMTP id
 y6-20020a926406000000b002bbf1dee13emr23408371ilb.305.1647405201746; Tue, 15
 Mar 2022 21:33:21 -0700 (PDT)
MIME-Version: 1.0
References: <1647000658-16149-1-git-send-email-alan.maguire@oracle.com> <1647000658-16149-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1647000658-16149-2-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Mar 2022 21:33:10 -0700
Message-ID: <CAEf4BzZAYjaFQEk13F5q3hXBCP0PzbsLdx9X41YnUtuviM4r7g@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 1/5] libbpf: bpf_program__attach_uprobe_opts()
 should determine paths for programs/libraries where possible
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 4:11 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> bpf_program__attach_uprobe_opts() requires a binary_path argument
> specifying binary to instrument.  Supporting simply specifying
> "libc.so.6" or "foo" should be possible too.
>
> Library search checks LD_LIBRARY_PATH, then /usr/lib64, /usr/lib.
> This allows users to run BPF programs prefixed with
> LD_LIBRARY_PATH=/path2/lib while still searching standard locations.
> Similarly for non .so files, we check PATH and /usr/bin, /usr/sbin.
>
> Path determination will be useful for auto-attach of BPF uprobe programs
> using SEC() definition.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/lib/bpf/libbpf.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 50 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 43161fd..b577577 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -10320,6 +10320,45 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
>         return pfd;
>  }
>
> +/* Get full path to program/shared library. */
> +static int resolve_full_path(const char *file, char *result, size_t result_sz)
> +{
> +       char *search_paths[2];
> +       int i;
> +
> +       if (strstr(file, ".so")) {
> +               search_paths[0] = getenv("LD_LIBRARY_PATH");
> +               search_paths[1] = (char *)"/usr/lib64:/usr/lib";
> +       } else {
> +               search_paths[0] = getenv("PATH");
> +               search_paths[1] = (char *)"/usr/bin:/usr/sbin";

It's strange you chose to cast to mutable char * instead of sticking
to `const char*`. getenv() returns char *, but that string is not
supposed to be modified, so effectively it is `const char *`. Let's
keep it safe (and it also won't require any casting)

> +       }
> +
> +       for (i = 0; i < ARRAY_SIZE(search_paths); i++) {
> +               char *s, *search_path, *currpath, *saveptr = NULL;

I'll nitpick on naming, and it feels like we've talked about this
before. Please stick to libbpf naming conventions: cur_path, save_ptr,
etc.

> +
> +               if (!search_paths[i])
> +                       continue;
> +               search_path = strdup(search_paths[i]);
> +               s = search_path;
> +               while ((currpath = strtok_r(s, ":", &saveptr)) != NULL) {

hm... I don't see any benefit to using strtok_r, which assumes mutable
input string, according to its input argument type, and thus requires
strdup, etc. Why so complicated? We have a single delimiter, ':',
right? strchr(s, ':'), advance read-only const char * pointer,
snprintf("%*s", len_of_segment, segment_start), where len_of_segment
should be a pointer difference between two ':' occurrences. No
strdup(), no strtok(), wdyt?

> +                       struct stat sb;
> +
> +                       s = NULL;
> +                       snprintf(result, result_sz, "%s/%s", currpath, file);
> +                       /* ensure it is an executable file/link */
> +                       if (stat(result, &sb) == 0 && (sb.st_mode & (S_IFREG | S_IFLNK)) &&
> +                           (sb.st_mode & (S_IXUSR | S_IXGRP | S_IXOTH))) {

wouldn't access(path, R_OK) (or maybe `R_OK | X_OK`, not sure if it's
important) do the same?

> +                               pr_debug("resolved '%s' to '%s'\n", file, result);
> +                               free(search_path);
> +                               return 0;
> +                       }
> +               }
> +               free(search_path);
> +       }
> +       return -ENOENT;
> +}
> +
>  LIBBPF_API struct bpf_link *
>  bpf_program__attach_uprobe_opts(const struct bpf_program *prog, pid_t pid,
>                                 const char *binary_path, size_t func_offset,
> @@ -10327,6 +10366,7 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
>  {
>         DECLARE_LIBBPF_OPTS(bpf_perf_event_opts, pe_opts);
>         char errmsg[STRERR_BUFSIZE], *legacy_probe = NULL;
> +       char full_binary_path[PATH_MAX];
>         struct bpf_link *link;
>         size_t ref_ctr_off;
>         int pfd, err;
> @@ -10338,13 +10378,22 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
>         retprobe = OPTS_GET(opts, retprobe, false);
>         ref_ctr_off = OPTS_GET(opts, ref_ctr_offset, 0);
>         pe_opts.bpf_cookie = OPTS_GET(opts, bpf_cookie, 0);

nit: empty line to logically separate this piece of logic below?

> +       if (binary_path && !strchr(binary_path, '/')) {
> +               err = resolve_full_path(binary_path, full_binary_path,
> +                                       sizeof(full_binary_path));
> +               if (err) {
> +                       pr_warn("could not find full path for %s\n", binary_path);

consistency nit: "failed to resolve full path for '%s'\n"?

> +                       return libbpf_err_ptr(err);

we don't use libbpf_err*() helpers in internal helpers, this is
responsibility of user-facing API functions


> +               }
> +               binary_path = full_binary_path;
> +       }
>
>         legacy = determine_uprobe_perf_type() < 0;
>         if (!legacy) {
>                 pfd = perf_event_open_probe(true /* uprobe */, retprobe, binary_path,
>                                             func_offset, pid, ref_ctr_off);
>         } else {
> -               char probe_name[512];
> +               char probe_name[PATH_MAX + 64];
>
>                 if (ref_ctr_off)
>                         return libbpf_err_ptr(-EINVAL);
> --
> 1.8.3.1
>
