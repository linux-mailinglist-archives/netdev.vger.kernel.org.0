Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22EA5D9B33
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 22:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732857AbfJPUNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 16:13:37 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43972 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731781AbfJPUNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 16:13:37 -0400
Received: by mail-qt1-f195.google.com with SMTP id t20so32708091qtr.10;
        Wed, 16 Oct 2019 13:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LC0y7kLEaD0/+g/awxDip6/YjJkRa+fzM+ASYceAP1Y=;
        b=RqLFqBrzQ12oXmM81YkFxmfKtmWGCkdtcYmefGIVT8RjpUCZWDbYFo7yem8vwUTcqo
         ew/J382Rhg+wJCegUvsAoQokinHHbKfpNcTmzXYfaHtOfi6PZ3QdqGBgYc22NmaXWVZ7
         Pd7S+ATUYUgNhon8MsfOkzKN/LUfvY8xjBXNkXglK5st/bR8gmN0XVf4olmC9Dyxn8NJ
         VfyB9IMo2cuR+caTAKFRPUblGgltLxKEWp+YtynKmqQ/m2RCHkmw8baXiwG2avnXrZT/
         qKjLiSdtXEps87KRudlVkwZl7hE3QUtvZzjlbIYWj/G2KJyfGb9IYE2CRe8W1VnZ2Lus
         kLGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LC0y7kLEaD0/+g/awxDip6/YjJkRa+fzM+ASYceAP1Y=;
        b=icm6IJa9kuPqE2VrDLDbHXrld+oqwyZrmtkkgiCboRJE+uM+/us9jWixJgRk8cEyp4
         Vq0c+4jDo1ektlO/Hpfj144KqSOlR4miz/6mX7v/6YiU2vWX7doi919sDSNf+TgkCb2x
         WZHCn4G0zADK7GmvKYMQM15fqXVD55bjhRsTHMTFL9wDdM118T5GvyDmLJnhXAYagrqT
         McjBInj7BJsu4OhSP2/IksNOku0wgQjRazxOdMwEu2iaTnxww/DRr/dXK24GfVGYoGC2
         WYGCVKxlhafle+EAixjk8f0annIqWXTg6W3+om4USmhFzgoGKPx6Ok+hlBThuUjRmQ01
         AHoA==
X-Gm-Message-State: APjAAAU7cZvg9ARX7/H9jt8V2fkXJAQLlK+fkOPStLtzLqkxNVpX7u9X
        z0S8k5NlW9aeerberhnclFP1nHU6UVjiRaWNRVI=
X-Google-Smtp-Source: APXvYqzSEDZP0klJ470HfWWZ1NPFKxXzpv3cGPwsGwpY6xF/zEcQcDE2MVN0jzq/9Giga/1c7MsEM1NiNur5Jrp7TDQ=
X-Received: by 2002:ac8:108e:: with SMTP id a14mr45562406qtj.171.1571256816274;
 Wed, 16 Oct 2019 13:13:36 -0700 (PDT)
MIME-Version: 1.0
References: <20191016032505.2089704-1-ast@kernel.org> <20191016032505.2089704-8-ast@kernel.org>
In-Reply-To: <20191016032505.2089704-8-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Oct 2019 13:13:25 -0700
Message-ID: <CAEf4BzYeMSavRrab4yG539S_DzRfMfMcmR93JuxA0wLhEEb2yg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 07/11] bpf: attach raw_tp program with BTF via
 type name
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 4:16 AM Alexei Starovoitov <ast@kernel.org> wrote:
>
> BTF type id specified at program load time has all
> necessary information to attach that program to raw tracepoint.
> Use kernel type name to find raw tracepoint.
>
> Add missing CHECK_ATTR() condition.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
> There is a tiny chance that CHECK_ATTR() may break some user space.
> In such case the CHECK_ATTR change will be reverted.

Sounds good.

Acked-by: Andrii Nakryiko <andriin@fb.com>

> ---
>  kernel/bpf/syscall.c | 70 +++++++++++++++++++++++++++++---------------
>  1 file changed, 47 insertions(+), 23 deletions(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index b56c482c9760..523e3ac15a08 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1816,17 +1816,52 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
>         struct bpf_raw_tracepoint *raw_tp;
>         struct bpf_raw_event_map *btp;
>         struct bpf_prog *prog;
> -       char tp_name[128];
> +       const char *tp_name;
> +       char buf[128];
>         int tp_fd, err;
>
> -       if (strncpy_from_user(tp_name, u64_to_user_ptr(attr->raw_tracepoint.name),
> -                             sizeof(tp_name) - 1) < 0)
> -               return -EFAULT;
> -       tp_name[sizeof(tp_name) - 1] = 0;
> +       if (CHECK_ATTR(BPF_RAW_TRACEPOINT_OPEN))
> +               return -EINVAL;
> +
> +       prog = bpf_prog_get(attr->raw_tracepoint.prog_fd);
> +       if (IS_ERR(prog))
> +               return PTR_ERR(prog);
> +
> +       if (prog->type != BPF_PROG_TYPE_RAW_TRACEPOINT &&
> +           prog->type != BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE) {
> +               err = -EINVAL;
> +               goto out_put_prog;
> +       }
> +
> +       if (prog->type == BPF_PROG_TYPE_RAW_TRACEPOINT &&
> +           prog->aux->attach_btf_id) {
> +               if (attr->raw_tracepoint.name) {
> +                       /* raw_tp name should not be specified in raw_tp
> +                        * programs that were verified via in-kernel BTF info
> +                        */
> +                       err = -EINVAL;
> +                       goto out_put_prog;
> +               }
> +               /* raw_tp name is taken from type name instead */
> +               tp_name = kernel_type_name(prog->aux->attach_btf_id);
> +               /* skip the prefix */
> +               tp_name += sizeof("btf_trace_") - 1;
> +       } else {
> +               if (strncpy_from_user(buf,
> +                                     u64_to_user_ptr(attr->raw_tracepoint.name),
> +                                     sizeof(buf) - 1) < 0) {
> +                       err = -EFAULT;
> +                       goto out_put_prog;
> +               }
> +               buf[sizeof(buf) - 1] = 0;
> +               tp_name = buf;
> +       }
>
>         btp = bpf_get_raw_tracepoint(tp_name);
> -       if (!btp)
> -               return -ENOENT;
> +       if (!btp) {
> +               err = -ENOENT;
> +               goto out_put_prog;
> +       }
>
>         raw_tp = kzalloc(sizeof(*raw_tp), GFP_USER);
>         if (!raw_tp) {
> @@ -1834,38 +1869,27 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
>                 goto out_put_btp;
>         }
>         raw_tp->btp = btp;
> -
> -       prog = bpf_prog_get(attr->raw_tracepoint.prog_fd);
> -       if (IS_ERR(prog)) {
> -               err = PTR_ERR(prog);
> -               goto out_free_tp;
> -       }
> -       if (prog->type != BPF_PROG_TYPE_RAW_TRACEPOINT &&
> -           prog->type != BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE) {
> -               err = -EINVAL;
> -               goto out_put_prog;
> -       }
> +       raw_tp->prog = prog;
>
>         err = bpf_probe_register(raw_tp->btp, prog);
>         if (err)
> -               goto out_put_prog;
> +               goto out_free_tp;
>
> -       raw_tp->prog = prog;
>         tp_fd = anon_inode_getfd("bpf-raw-tracepoint", &bpf_raw_tp_fops, raw_tp,
>                                  O_CLOEXEC);
>         if (tp_fd < 0) {
>                 bpf_probe_unregister(raw_tp->btp, prog);
>                 err = tp_fd;
> -               goto out_put_prog;
> +               goto out_free_tp;
>         }
>         return tp_fd;
>
> -out_put_prog:
> -       bpf_prog_put(prog);
>  out_free_tp:
>         kfree(raw_tp);
>  out_put_btp:
>         bpf_put_raw_tracepoint(btp);
> +out_put_prog:
> +       bpf_prog_put(prog);
>         return err;
>  }
>
> --
> 2.17.1
>
