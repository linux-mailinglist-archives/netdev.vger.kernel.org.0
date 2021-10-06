Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54231424814
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 22:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239529AbhJFUky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 16:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239406AbhJFUkx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 16:40:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0947261058;
        Wed,  6 Oct 2021 20:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633552741;
        bh=VTBzooLj3EuJxi9iH98uEr4AABNwYA30SDrRw8VZ+Zg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KgIiOs8N4KEN5nGFJVJL19I+5qZKXY0JEJeDl0aGz7AKHh+gmI2d3iJzGTVMSnomN
         vHy/IrZJU5U7VwUvYeD1/q9ujwD4Mkt7hwmn2CWP6pQpZ4I41W4VPIDuIAdaKSaqxG
         dmnEP0wl6PNATfLysazP7Yci3YezDljydNNIj2XUDw+YbgeI+hJ7VlfAroPC8OD38r
         QF/mQ89ZKR9UZGv7OjVKaemxkJCuEgeh7MujOcdom2ymoBG0sAxh/DkrLcNQ/ync/D
         TAa2E1OfsBDzZldCrIXp1i8DvnTV9uQAkVYHyuTBl38sX6Mg8hPzwJ1SL0lY+HiQW3
         9nEPUF6ZYfx9Q==
Received: by mail-lf1-f44.google.com with SMTP id u18so15242338lfd.12;
        Wed, 06 Oct 2021 13:39:00 -0700 (PDT)
X-Gm-Message-State: AOAM531eDkQeSQwCeVG6/cLF+byx9MVxRypKnfTI9WWECesXCtJUE2Hd
        2YfeVxDoahHBGNWkZI93E0LAyXixJ0aZje4DASo=
X-Google-Smtp-Source: ABdhPJwdIyTDzNHCwBrzqvUz/F6xTsbyvZjCw2eq5zjc3OE+0ofddclYIB62k3eb/4VLrRFzir3qn1e+DZxuAfWi2nk=
X-Received: by 2002:a2e:b545:: with SMTP id a5mr228131ljn.48.1633552739345;
 Wed, 06 Oct 2021 13:38:59 -0700 (PDT)
MIME-Version: 1.0
References: <20211006203135.2566248-1-songliubraving@fb.com>
In-Reply-To: <20211006203135.2566248-1-songliubraving@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 6 Oct 2021 13:38:48 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6QF09R4C5R-y=o-vo_v5h_yCyAaR1LAsLopq_K17tMyg@mail.gmail.com>
Message-ID: <CAPhsuW6QF09R4C5R-y=o-vo_v5h_yCyAaR1LAsLopq_K17tMyg@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: skip get_branch_snapshot in vm
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 6, 2021 at 1:32 PM Song Liu <songliubraving@fb.com> wrote:
>
> VMs running on latest kernel support LBR. However, bpf_get_branch_snapshot
> couldn't stop the LBR before too many entries are flushed. Skip the test
> for VMs before we find a proper fix for VMs.
>
> Read the "flags" line from /proc/cpuinfo, if it contains "hypervisor",
> skip test get_branch_snapshot.

Forgot to use --subject-prefix. This applies to bpf-next.

Thanks,
Song

>
> Fixes: 025bd7c753aa (selftests/bpf: Add test for bpf_get_branch_snapshot)
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  .../bpf/prog_tests/get_branch_snapshot.c      | 32 +++++++++++++++++++
>  1 file changed, 32 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c b/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
> index 67e86f8d86775..bf9d47a859449 100644
> --- a/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
> +++ b/tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
> @@ -6,6 +6,30 @@
>  static int *pfd_array;
>  static int cpu_cnt;
>
> +static bool is_hypervisor(void)
> +{
> +       char *line = NULL;
> +       bool ret = false;
> +       size_t len;
> +       FILE *fp;
> +
> +       fp = fopen("/proc/cpuinfo", "r");
> +       if (!fp)
> +               return false;
> +
> +       while (getline(&line, &len, fp) != -1) {
> +               if (strstr(line, "flags") == line) {
> +                       if (strstr(line, "hypervisor") != NULL)
> +                               ret = true;
> +                       break;
> +               }
> +       }
> +
> +       free(line);
> +       fclose(fp);
> +       return ret;
> +}
> +
>  static int create_perf_events(void)
>  {
>         struct perf_event_attr attr = {0};
> @@ -54,6 +78,14 @@ void test_get_branch_snapshot(void)
>         struct get_branch_snapshot *skel = NULL;
>         int err;
>
> +       if (is_hypervisor()) {
> +               /* As of today, LBR in hypervisor cannot be stopped before
> +                * too many entries are flushed. Skip the test for now in
> +                * hypervisor until we optimize the LBR in hypervisor.
> +                */
> +               test__skip();
> +               return;
> +       }
>         if (create_perf_events()) {
>                 test__skip();  /* system doesn't support LBR */
>                 goto cleanup;
> --
> 2.30.2
>
