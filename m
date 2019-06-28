Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 878FB5A553
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 21:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfF1Tqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 15:46:53 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36032 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbfF1Tqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 15:46:53 -0400
Received: by mail-qk1-f194.google.com with SMTP id g18so5913802qkl.3;
        Fri, 28 Jun 2019 12:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YuxdVzWhD3MYKJVmt81mivMpX3VPBk7Gc49IeaeRJM4=;
        b=rQ2C0md6VDL+FL/6EOeRJWDtjVbEccgFRqlsU+54WD60QQpk1qlFMYhHF8m3d3Rp9d
         3im0lnLy4NelThZ09RuU1tEjjW4ipFcNjI1EYIHBHBYU3vBjqESQdzOBjBDeEEnXqG8i
         3drhPUbVxCH/hxGXqCazANe65u/CU+I9I0VXDj6h0kHy6COQl8mX8yTsI4aNLg9y2QfF
         kqF7NwLJ/Cuu7FjquttdkODAdUGkX7L104azZF8+xRD2d975+sH7OewDT8xfCHusO9xb
         wpN+xkmzXbXDCjfSZchQZAyzwhOLSB3EHV9rod51tFg9sqEc+BQkwLH3AZMv349QQCH6
         vTwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YuxdVzWhD3MYKJVmt81mivMpX3VPBk7Gc49IeaeRJM4=;
        b=Xk7I0B1R/nQlRwHW6O1XJ5jTa9efYDsDVl8KlYbAIG+GKrLpLHvrnnjOnh5BmhJw6h
         WlU7zUoQQDlX7Ih6A1tZUihnIfxia6B4vazxxWIHj3xh8Sz95CMB0RnjsQTScthz6Qho
         INcLm6vzWrty5fpypEcSW8D5AWFb+2zZUe5gpZBgvkmVvEGaEsbrk1skMrTxMJ2S55lM
         WjVSMkmIGJkGxVVGTNmKxK+lhUaBgkwr5ztCMtAJOExQAZYfj9Npb14qF7fXy2rEFS8l
         WRGtmll6o6QIv7xWumn39Ric4AneIqz+Fg573a9YybpaAN+K50BZ8AiGmQqmKMP5f+2n
         SFLQ==
X-Gm-Message-State: APjAAAWAmFHQu8hXin4ltFwfd+wvuYe2YwXJPrJhfRIgSG0RpWOszjRO
        /XWBRm/hNe/9MespZm/6ML5WNMhAMtZse8cxDu8=
X-Google-Smtp-Source: APXvYqxayKnuVZJxXJ5NqVB8pJ+JcTtqodYaHVycqp3AxIwYbDl6/nudC+tCj9APQ+kocqAz9cYznFls8WbUlUMwUvs=
X-Received: by 2002:a37:5cc3:: with SMTP id q186mr10128820qkb.74.1561751212031;
 Fri, 28 Jun 2019 12:46:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190628055303.1249758-1-andriin@fb.com> <20190628055303.1249758-5-andriin@fb.com>
In-Reply-To: <20190628055303.1249758-5-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Fri, 28 Jun 2019 12:46:41 -0700
Message-ID: <CAPhsuW6UMdHidpmgRzM0sZaGc5gZAnT1B7vCJVt-MrLCMjOdig@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 4/9] libbpf: add kprobe/uprobe attach API
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 10:53 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add ability to attach to kernel and user probes and retprobes.
> Implementation depends on perf event support for kprobes/uprobes.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c   | 213 +++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h   |   7 ++
>  tools/lib/bpf/libbpf.map |   2 +
>  3 files changed, 222 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 606705f878ba..65d2fef41003 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4016,6 +4016,219 @@ struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
>         return (struct bpf_link *)link;
>  }
>
> +static int parse_uint(const char *buf)
> +{
> +       int ret;
> +
> +       errno = 0;
> +       ret = (int)strtol(buf, NULL, 10);
> +       if (errno) {
> +               ret = -errno;
> +               pr_debug("failed to parse '%s' as unsigned int\n", buf);
> +               return ret;
> +       }
> +       if (ret < 0) {
> +               pr_debug("failed to parse '%s' as unsigned int\n", buf);
> +               return -EINVAL;
> +       }
> +       return ret;
> +}
> +
> +static int parse_uint_from_file(const char* file)
> +{
> +       char buf[STRERR_BUFSIZE];
> +       int fd, ret;
> +
> +       fd = open(file, O_RDONLY);
> +       if (fd < 0) {
> +               ret = -errno;
> +               pr_debug("failed to open '%s': %s\n", file,
> +                        libbpf_strerror_r(ret, buf, sizeof(buf)));
> +               return ret;
> +       }
> +       ret = read(fd, buf, sizeof(buf));
> +       ret = ret < 0 ? -errno : ret;
> +       close(fd);
> +       if (ret < 0) {
> +               pr_debug("failed to read '%s': %s\n", file,
> +                       libbpf_strerror_r(ret, buf, sizeof(buf)));
> +               return ret;
> +       }
> +       if (ret == 0 || ret >= sizeof(buf)) {
> +               buf[sizeof(buf) - 1] = 0;
> +               pr_debug("unexpected input from '%s': '%s'\n", file, buf);
> +               return -EINVAL;
> +       }
> +       return parse_uint(buf);
> +}
> +
> +static int determine_kprobe_perf_type(void)
> +{
> +       const char *file = "/sys/bus/event_source/devices/kprobe/type";
> +       return parse_uint_from_file(file);
> +}
> +
> +static int determine_uprobe_perf_type(void)
> +{
> +       const char *file = "/sys/bus/event_source/devices/uprobe/type";
> +       return parse_uint_from_file(file);
> +}
> +
> +static int parse_config_from_file(const char *file)
> +{
> +       char buf[STRERR_BUFSIZE];
> +       int fd, ret;
> +
> +       fd = open(file, O_RDONLY);
> +       if (fd < 0) {
> +               ret = -errno;
> +               pr_debug("failed to open '%s': %s\n", file,
> +                        libbpf_strerror_r(ret, buf, sizeof(buf)));
> +               return ret;
> +       }
> +       ret = read(fd, buf, sizeof(buf));
> +       ret = ret < 0 ? -errno : ret;
> +       close(fd);
> +       if (ret < 0) {
> +               pr_debug("failed to read '%s': %s\n", file,
> +                       libbpf_strerror_r(ret, buf, sizeof(buf)));
> +               return ret;
> +       }
> +       if (ret == 0 || ret >= sizeof(buf)) {
> +               buf[sizeof(buf) - 1] = 0;
> +               pr_debug("unexpected input from '%s': '%s'\n", file, buf);
> +               return -EINVAL;
> +       }
> +       if (strncmp(buf, "config:", 7)) {
> +               pr_debug("expected 'config:' prefix, found '%s'\n", buf);
> +               return -EINVAL;
> +       }
> +       return parse_uint(buf + 7);
> +}
> +
> +static int determine_kprobe_retprobe_bit(void)
> +{
> +       const char *file = "/sys/bus/event_source/devices/kprobe/format/retprobe";
> +       return parse_config_from_file(file);
> +}
> +
> +static int determine_uprobe_retprobe_bit(void)
> +{
> +       const char *file = "/sys/bus/event_source/devices/uprobe/format/retprobe";
> +       return parse_config_from_file(file);
> +}

Can we do the above with fscanf? Would that be easier?

> +
> +static int perf_event_open_probe(bool uprobe, bool retprobe, const char* name,
> +                                uint64_t offset, int pid)
> +{
> +       struct perf_event_attr attr = {};
> +       char errmsg[STRERR_BUFSIZE];
> +       int type, pfd, err;
> +
> +       type = uprobe ? determine_uprobe_perf_type()
> +                     : determine_kprobe_perf_type();
> +       if (type < 0) {
> +               pr_warning("failed to determine %s perf type: %s\n",
> +                          uprobe ? "uprobe" : "kprobe",
> +                          libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
> +               return type;
> +       }
> +       if (retprobe) {
> +               int bit = uprobe ? determine_uprobe_retprobe_bit()
> +                                : determine_kprobe_retprobe_bit();
> +
> +               if (bit < 0) {
> +                       pr_warning("failed to determine %s retprobe bit: %s\n",
> +                                  uprobe ? "uprobe" : "kprobe",
> +                                  libbpf_strerror_r(bit, errmsg,
> +                                                    sizeof(errmsg)));
> +                       return bit;
> +               }
> +               attr.config |= 1 << bit;
> +       }
> +       attr.size = sizeof(attr);
> +       attr.type = type;
> +       attr.config1 = (uint64_t)(void *)name; /* kprobe_func or uprobe_path */
> +       attr.config2 = offset;                 /* kprobe_addr or probe_offset */
> +
> +       /* pid filter is meaningful only for uprobes */
> +       pfd = syscall(__NR_perf_event_open, &attr,
> +                     pid < 0 ? -1 : pid /* pid */,
> +                     pid == -1 ? 0 : -1 /* cpu */,
> +                     -1 /* group_fd */, PERF_FLAG_FD_CLOEXEC);
> +       if (pfd < 0) {
> +               err = -errno;
> +               pr_warning("%s perf_event_open() failed: %s\n",
> +                          uprobe ? "uprobe" : "kprobe",
> +                          libbpf_strerror_r(err, errmsg, sizeof(errmsg)));

We have another warning in bpf_program__attach_[k|u]probe(). I guess
we can remove this one here.

> +               return err;
> +       }
> +       return pfd;
> +}
> +
> +struct bpf_link *bpf_program__attach_kprobe(struct bpf_program *prog,
> +                                           bool retprobe,
> +                                           const char *func_name)
> +{
> +       char errmsg[STRERR_BUFSIZE];
> +       struct bpf_link *link;
> +       int pfd, err;
> +
> +       pfd = perf_event_open_probe(false /* uprobe */, retprobe, func_name,
> +                                   0 /* offset */, -1 /* pid */);
> +       if (pfd < 0) {
> +               pr_warning("program '%s': failed to create %s '%s' perf event: %s\n",
> +                          bpf_program__title(prog, false),
> +                          retprobe ? "kretprobe" : "kprobe", func_name,
> +                          libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
> +               return ERR_PTR(pfd);
> +       }
> +       link = bpf_program__attach_perf_event(prog, pfd);
> +       if (IS_ERR(link)) {
> +               close(pfd);
> +               err = PTR_ERR(link);
> +               pr_warning("program '%s': failed to attach to %s '%s': %s\n",
> +                          bpf_program__title(prog, false),
> +                          retprobe ? "kretprobe" : "kprobe", func_name,
> +                          libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +               return link;
> +       }
> +       return link;
> +}
> +
> +struct bpf_link *bpf_program__attach_uprobe(struct bpf_program *prog,
> +                                           bool retprobe, pid_t pid,
> +                                           const char *binary_path,
> +                                           size_t func_offset)
> +{
> +       char errmsg[STRERR_BUFSIZE];
> +       struct bpf_link *link;
> +       int pfd, err;
> +
> +       pfd = perf_event_open_probe(true /* uprobe */, retprobe,
> +                                   binary_path, func_offset, pid);
> +       if (pfd < 0) {
> +               pr_warning("program '%s': failed to create %s '%s:0x%zx' perf event: %s\n",
> +                          bpf_program__title(prog, false),
> +                          retprobe ? "uretprobe" : "uprobe",
> +                          binary_path, func_offset,
> +                          libbpf_strerror_r(pfd, errmsg, sizeof(errmsg)));
> +               return ERR_PTR(pfd);
> +       }
> +       link = bpf_program__attach_perf_event(prog, pfd);
> +       if (IS_ERR(link)) {
> +               close(pfd);
> +               err = PTR_ERR(link);
> +               pr_warning("program '%s': failed to attach to %s '%s:0x%zx': %s\n",
> +                          bpf_program__title(prog, false),
> +                          retprobe ? "uretprobe" : "uprobe",
> +                          binary_path, func_offset,
> +                          libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
> +               return link;
> +       }
> +       return link;
> +}
> +
>  enum bpf_perf_event_ret
>  bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
>                            void **copy_mem, size_t *copy_size,
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 1bf66c4a9330..bd767cc11967 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -171,6 +171,13 @@ LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
>
>  LIBBPF_API struct bpf_link *
>  bpf_program__attach_perf_event(struct bpf_program *prog, int pfd);
> +LIBBPF_API struct bpf_link *
> +bpf_program__attach_kprobe(struct bpf_program *prog, bool retprobe,
> +                          const char *func_name);
> +LIBBPF_API struct bpf_link *
> +bpf_program__attach_uprobe(struct bpf_program *prog, bool retprobe,
> +                          pid_t pid, const char *binary_path,
> +                          size_t func_offset);
>
>  struct bpf_insn;
>
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 756f5aa802e9..57a40fb60718 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -169,7 +169,9 @@ LIBBPF_0.0.4 {
>         global:
>                 bpf_link__destroy;
>                 bpf_object__load_xattr;
> +               bpf_program__attach_kprobe;
>                 bpf_program__attach_perf_event;
> +               bpf_program__attach_uprobe;
>                 btf_dump__dump_type;
>                 btf_dump__free;
>                 btf_dump__new;
> --
> 2.17.1
>
