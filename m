Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76FAB4DFC8
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 06:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfFUEeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 00:34:31 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36272 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfFUEeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 00:34:31 -0400
Received: by mail-qk1-f193.google.com with SMTP id g18so3556105qkl.3;
        Thu, 20 Jun 2019 21:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QCbXtPhlxrhkqkq0TpUWZHElKJz6v/OXqJAKelhStxs=;
        b=ezSiILzOVhoFZu53v443oKyHOK5B6op5lXOPYs2e+ymd7MDhybSkJTXCOvpeqDetbw
         TzOHeYZeK4cyxCTvvOQlvLC2xbQHIt6tBnGUMymPzLq5q8/RiJs2XRVPxVNtdbvnzZ0T
         xyT4r1fSS+hh0rgM4l1mz4Z48nTjd1M4qBp38PZ525WvPr7mFeIFQpZTZ3BTiyLRF8Az
         89slgbjr4944OSm+IPf7qzOVwvdAoJeYmvnY0NOzlYMaQAuzGky5/MsmJs6kROz9QYkI
         VLMa8uS51p5LJTdPpqC22VFa27wcRQTa5/GnaFZMXkdEXIz1Cp8bqMzFuTJVAtft5USM
         6q3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QCbXtPhlxrhkqkq0TpUWZHElKJz6v/OXqJAKelhStxs=;
        b=Wtzn5r5+xlf9IM8k68kJuLyTeLQTx5m19b7uxshx24gU874M4eq4LBbeza3MEIQ5wC
         W5zp3jxn6f9Y2+Rji1NG7Muv4WDwbFiWhWfCLjpTj3iJIQto34728ASAi/DLkrwUsOQM
         5+qV4PQFw64v5i8sweGm1y1W0/nDL2DvImALX8nWgzs5SuNegPIQ4XL5xgmEs9IhHjov
         BKWfEcdIe6mq/f4+XXgk33Nipb3Zl06fyFubgVeY1mLpv+FEdxRALpyy63AY6wLk7EIp
         2ajcy9+wkBR8MlklYCMROYLm7A47QPhmu5YCCih5k/mz5FuhweGYFCc0GjXNed2x1AJT
         JyOA==
X-Gm-Message-State: APjAAAXEpIWUh5REJhKd9vln7yvczFpkK50z8zFpaab5mI1H+puoROtT
        jYR4Bb8Z7QTYfYQhtUOpkPf3u3Ro01gflH5hyd4=
X-Google-Smtp-Source: APXvYqwbAKBYwmcnrNTHKQsKHBCUz4kDuq05yFTy5XxhxeSFiEoYDzVPxZuo6dpRr1Dlabej+S2qsRwbFFY6laNJYZY=
X-Received: by 2002:a37:a643:: with SMTP id p64mr88813339qke.36.1561091669798;
 Thu, 20 Jun 2019 21:34:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190620230951.3155955-1-andriin@fb.com> <20190620230951.3155955-4-andriin@fb.com>
 <20190621000402.GB1383@mini-arch>
In-Reply-To: <20190621000402.GB1383@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 Jun 2019 21:34:18 -0700
Message-ID: <CAEf4BzZ6SRJtwbmHq4vAwn2-njP4M3jNhax-VZqs2wZJCU1RRw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/7] libbpf: add kprobe/uprobe attach API
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 5:04 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 06/20, Andrii Nakryiko wrote:
> > Add ability to attach to kernel and user probes and retprobes.
> > Implementation depends on perf event support for kprobes/uprobes.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c   | 207 +++++++++++++++++++++++++++++++++++++++
> >  tools/lib/bpf/libbpf.h   |   8 ++
> >  tools/lib/bpf/libbpf.map |   2 +
> >  3 files changed, 217 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 2bb1fa008be3..11329e05530e 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -3969,6 +3969,213 @@ int bpf_program__attach_perf_event(struct bpf_program *prog, int pfd)
> >       return 0;
> >  }
> >
> > +static int parse_uint(const char *buf)
> > +{
> > +     int ret;
> > +
> > +     errno = 0;
> > +     ret = (int)strtol(buf, NULL, 10);
> > +     if (errno) {
> > +             ret = -errno;
> > +             pr_debug("failed to parse '%s' as unsigned int\n", buf);
> > +             return ret;
> > +     }
> > +     if (ret < 0) {
> > +             pr_debug("failed to parse '%s' as unsigned int\n", buf);
> > +             return -EINVAL;
> > +     }
> > +     return ret;
> > +}
> > +
> > +static int parse_uint_from_file(const char* file)
> > +{
> > +     char buf[STRERR_BUFSIZE];
> > +     int fd, ret;
> > +
> > +     fd = open(file, O_RDONLY);
> > +     if (fd < 0) {
> > +             ret = -errno;
> > +             pr_debug("failed to open '%s': %s\n", file,
> > +                      libbpf_strerror_r(ret, buf, sizeof(buf)));
> > +             return ret;
> > +     }
> > +     ret = read(fd, buf, sizeof(buf));
> > +     close(fd);
> > +     if (ret < 0) {
> > +             ret = -errno;
> Is -errno still valid here after a close(fd) above? Do we have any
> guarantee of errno preservation when we do another syscall?

Good catch! No, close() can change errno. Fixed. Also fixed for
parse_config_from_file below.

>
> > +             pr_debug("failed to read '%s': %s\n", file,
> > +                     libbpf_strerror_r(ret, buf, sizeof(buf)));
> > +             return ret;
> > +     }
> > +     if (ret == 0 || ret >= sizeof(buf)) {
> > +             buf[sizeof(buf) - 1] = 0;
> > +             pr_debug("unexpected input from '%s': '%s'\n", file, buf);
> > +             return -EINVAL;
> > +     }
> > +     return parse_uint(buf);
> > +}
> > +
> > +static int determine_kprobe_perf_type(void)
> > +{
> > +     const char *file = "/sys/bus/event_source/devices/kprobe/type";
> > +     return parse_uint_from_file(file);
> > +}
> > +
> > +static int determine_uprobe_perf_type(void)
> > +{
> > +     const char *file = "/sys/bus/event_source/devices/uprobe/type";
> > +     return parse_uint_from_file(file);
> > +}
> > +
> > +static int parse_config_from_file(const char *file)
> > +{
> > +     char buf[STRERR_BUFSIZE];
> > +     int fd, ret;
> > +
> > +     fd = open(file, O_RDONLY);
> > +     if (fd < 0) {
> > +             ret = -errno;
> > +             pr_debug("failed to open '%s': %s\n", file,
> > +                      libbpf_strerror_r(ret, buf, sizeof(buf)));
> > +             return ret;
> > +     }
> > +     ret = read(fd, buf, sizeof(buf));
> > +     close(fd);
> > +     if (ret < 0) {
> > +             ret = -errno;
> > +             pr_debug("failed to read '%s': %s\n", file,
> > +                     libbpf_strerror_r(ret, buf, sizeof(buf)));
> > +             return ret;
> > +     }
> > +     if (ret == 0 || ret >= sizeof(buf)) {
> > +             buf[sizeof(buf) - 1] = 0;
> > +             pr_debug("unexpected input from '%s': '%s'\n", file, buf);
> > +             return -EINVAL;
> > +     }
> > +     if (strncmp(buf, "config:", 7)) {
> > +             pr_debug("expected 'config:' prefix, found '%s'\n", buf);
> > +             return -EINVAL;
> > +     }
> > +     return parse_uint(buf + 7);
> > +}
> > +

<snip>
