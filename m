Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADF5531E7F
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 00:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbiEWWTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 18:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiEWWTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 18:19:03 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B66082146;
        Mon, 23 May 2022 15:19:02 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id x11so7232590vkn.11;
        Mon, 23 May 2022 15:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o0jmOLbIBLC81iyA5yzsszbXfVOeW4ty6u6e0iBG1ak=;
        b=Q6spda00D8K2i1naxwniSrw8jg1W3WVi94CaLo8Km049sMI9f8AA1eDBhxZtAdkn9J
         yU8aY1JPVSAYtW+gahpiFeo1pZRnoWQF0jZmvQR8N/MDp8BjCQCE2Ve5i4T2eqdGdEfA
         /DciG7Z78vUq2S9CIFDLeu/5+ZD9h7/wedib4aBvbRbIIqVH+LMmQ7ICqgGO4muXiq1r
         H1PzwYkmdSEcg9ncZQpIpZlfGAxdm5kFRG/Sa7WNAkE5LuXalwXPMSEje5dnGxNyTIf7
         gp5ErRSaxDha4ypyd8aV6uMGmVt0D6MpyGm5PYUMr4qBFwEwxdahxUqsrBFIOB/u7uHr
         Ek+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o0jmOLbIBLC81iyA5yzsszbXfVOeW4ty6u6e0iBG1ak=;
        b=6vlPgrjfJPmihx6+sGFlfY9k8BexaLcIA47q7r/YkHTepSbbSFAdQPQP6tJwypAXhs
         hzkmpDUitbWoGTt/OL8+biiiLI37ktKheuXGJG0pFqFSb/dOXXDzzkGYFYgclMD8+SFl
         VTdTHf1HyD8UIzRVtI5wtDovmgNclEX6b6fYrarA9yTOKa7hHFgnEaxu0Hph6FQsF+JC
         k15wMgJtiHQ3yWbhJuE5SbRx3qI4g7aqoeOTDz7CO1NEjf1/VRfvdVJsLtmjTu0Yy03C
         QE6MUPFUVcQ9/Ua+HxmHNoFej5a+xerMEqXaww8v734aSGUdAXgaOQmhULE/w7IdVE+O
         DdJA==
X-Gm-Message-State: AOAM531fOx2U5sWQg7jtef8NdxTqHXhDK3jWheFYC4MAtWjxj/ZSixYA
        rXBMdKCFlI0Cwe0IwtwwzKvHX8YN3yq6aTuMlBU=
X-Google-Smtp-Source: ABdhPJwXGAJoIRCLkBVb6nbGLCaOQQ+/QyZqFuWiushHlGc6SCs3JQg4uMgLxbApU6UQAi4K8yn72yjFMuKXWksRjGQ=
X-Received: by 2002:a1f:ac14:0:b0:34e:c5cc:f97f with SMTP id
 v20-20020a1fac14000000b0034ec5ccf97fmr8856454vke.9.1653344341474; Mon, 23 May
 2022 15:19:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220523212808.603526-1-connoro@google.com>
In-Reply-To: <20220523212808.603526-1-connoro@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 23 May 2022 15:18:50 -0700
Message-ID: <CAEf4Bzb7RLdNjx8kiHUmv05vB+nF-4PH-FcYynWoKHLUsHR2+Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: also check /sys/kernel/tracing for
 tracefs files
To:     "Connor O'Brien" <connoro@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

On Mon, May 23, 2022 at 2:28 PM Connor O'Brien <connoro@google.com> wrote:
>
> libbpf looks for tracefs files only under debugfs, but tracefs may be
> mounted even if debugfs is not. When /sys/kernel/debug/tracing is
> absent, try looking under /sys/kernel/tracing instead.
>
> Signed-off-by: Connor O'Brien <connoro@google.com>
> ---
> v1->v2: cache result of debugfs check.
>
>  src/libbpf.c | 32 +++++++++++++++++++++++++-------
>  1 file changed, 25 insertions(+), 7 deletions(-)
>
> diff --git a/src/libbpf.c b/src/libbpf.c
> index 2262bcd..cc47c52 100644
> --- a/src/libbpf.c
> +++ b/src/libbpf.c
> @@ -9945,10 +9945,22 @@ static void gen_kprobe_legacy_event_name(char *buf, size_t buf_sz,
>                  __sync_fetch_and_add(&index, 1));
>  }
>
> +static bool debugfs_available(void)
> +{
> +       static bool initialized = false, available;
> +
> +       if (!initialized) {
> +               available = !access("/sys/kernel/debug/tracing", F_OK);
> +               initialized = true;
> +       }
> +       return available;
> +}

so thinking about this caching a bit, I'm not so sure we want to cache
this decision. Mounting and unmounting of tracefs can happen after BPF
application starts, so this debugfs_available flag can actually change
while program is running. On the other hand, we don't do this check
all that frequently, only during attach/detach, so it might be ok not
to cache this result at all? WDYT?

> +
>  static int add_kprobe_event_legacy(const char *probe_name, bool retprobe,
>                                    const char *kfunc_name, size_t offset)
>  {
> -       const char *file = "/sys/kernel/debug/tracing/kprobe_events";
> +       const char *file = debugfs_available() ? "/sys/kernel/debug/tracing/kprobe_events" :
> +               "/sys/kernel/tracing/kprobe_events";

reading through this patch, it's now quite hard to see what differs,
to be honest. While I do like full file path spelled out, now that we
have two different prefixes it seems better to have prefixes separate.
How about we do

#define TRACEFS_PFX "/sys/kernel/tracing"
#define DEBUGFS_PFX "/sys/kernel/debug/tracing"

and then use that to construct strings. Like in the above example


const char *file = has_debugfs() ? DEBUGFS_PFX "/kprobe_events" :
TRACEFS_PFX "/kprobe_events";

and similarly below. That way at least we see clearly the part that's
not dependent on debugfs/tracefs differences.

>
>         return append_to_file(file, "%c:%s/%s %s+0x%zx",
>                               retprobe ? 'r' : 'p',
> @@ -9958,7 +9970,8 @@ static int add_kprobe_event_legacy(const char *probe_name, bool retprobe,
>
>  static int remove_kprobe_event_legacy(const char *probe_name, bool retprobe)
>  {
> -       const char *file = "/sys/kernel/debug/tracing/kprobe_events";
> +       const char *file = debugfs_available() ? "/sys/kernel/debug/tracing/kprobe_events" :
> +               "/sys/kernel/tracing/kprobe_events";
>
>         return append_to_file(file, "-:%s/%s", retprobe ? "kretprobes" : "kprobes", probe_name);
>  }
> @@ -9968,7 +9981,8 @@ static int determine_kprobe_perf_type_legacy(const char *probe_name, bool retpro
>         char file[256];
>
>         snprintf(file, sizeof(file),
> -                "/sys/kernel/debug/tracing/events/%s/%s/id",
> +                debugfs_available() ? "/sys/kernel/debug/tracing/events/%s/%s/id" :
> +                "/sys/kernel/tracing/events/%s/%s/id",
>                  retprobe ? "kretprobes" : "kprobes", probe_name);
>
>         return parse_uint_from_file(file, "%d\n");
> @@ -10144,7 +10158,8 @@ static void gen_uprobe_legacy_event_name(char *buf, size_t buf_sz,
>  static inline int add_uprobe_event_legacy(const char *probe_name, bool retprobe,
>                                           const char *binary_path, size_t offset)
>  {
> -       const char *file = "/sys/kernel/debug/tracing/uprobe_events";
> +       const char *file = debugfs_available() ? "/sys/kernel/debug/tracing/uprobe_events" :
> +               "/sys/kernel/tracing/uprobe_events";
>
>         return append_to_file(file, "%c:%s/%s %s:0x%zx",
>                               retprobe ? 'r' : 'p',
> @@ -10154,7 +10169,8 @@ static inline int add_uprobe_event_legacy(const char *probe_name, bool retprobe,
>
>  static inline int remove_uprobe_event_legacy(const char *probe_name, bool retprobe)
>  {
> -       const char *file = "/sys/kernel/debug/tracing/uprobe_events";
> +       const char *file = debugfs_available() ? "/sys/kernel/debug/tracing/uprobe_events" :
> +               "/sys/kernel/tracing/uprobe_events";
>
>         return append_to_file(file, "-:%s/%s", retprobe ? "uretprobes" : "uprobes", probe_name);
>  }
> @@ -10164,7 +10180,8 @@ static int determine_uprobe_perf_type_legacy(const char *probe_name, bool retpro
>         char file[512];
>
>         snprintf(file, sizeof(file),
> -                "/sys/kernel/debug/tracing/events/%s/%s/id",
> +                debugfs_available() ? "/sys/kernel/debug/tracing/events/%s/%s/id" :
> +                "/sys/kernel/tracing/events/%s/%s/id",

like here, "events/%s/%s/id" is important to separate, so

snprintf(file, sizeof(file), "%s/events/%s/%s/id",
         has_debugfs() ? DEBUGFS_PFX : TRACEFS_PFX,
         retprobe ? "uretprobes" : "uprobes", probe_name);

seems easier to follow?


>                  retprobe ? "uretprobes" : "uprobes", probe_name);
>
>         return parse_uint_from_file(file, "%d\n");
> @@ -10295,7 +10312,8 @@ static int determine_tracepoint_id(const char *tp_category,
>         int ret;
>
>         ret = snprintf(file, sizeof(file),
> -                      "/sys/kernel/debug/tracing/events/%s/%s/id",
> +                      debugfs_available() ? "/sys/kernel/debug/tracing/events/%s/%s/id" :
> +                      "/sys/kernel/tracing/events/%s/%s/id",
>                        tp_category, tp_name);
>         if (ret < 0)
>                 return -errno;
> --
> 2.36.1.124.g0e6072fb45-goog
>
