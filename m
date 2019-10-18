Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEE5DBD1A
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 07:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395065AbfJRFge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 01:36:34 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:42297 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727399AbfJRFge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 01:36:34 -0400
Received: by mail-oi1-f196.google.com with SMTP id i185so4188057oif.9
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 22:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+ZfQ3YcR54EbpttrnQUrtNXWUUftHFVFQjHIRQYfMjw=;
        b=CZwxzmm29wlEIKR/7b2q8DbocmeFVU0EUjx7L5M5j5Ll7zEx8p+Z3AbxsipxjN0Ukv
         hzKH58FkBft4vf+MiYKSBVznDszWlYkTxyKh7nmcni2y+UxghB11x6FCOaGUE2LdJCKm
         Wk0koikhjDT8JPXEX7vC0b5LrA+rhZEqtRWQRpQoLygbu99wOpUP08guBJQZXF+up/dL
         VoGj8kYtSflPCt5JbHrVgF1g6y+C5LbbT5kpL9AiAVu9H7HhFVOaKTP6afsOo7ioTQMv
         qZAkNVwO65jyHnjVym/i/bMBGx/nB8QLPZJyo3cWZaHbdrwcEqhBP/60nuJH7eJ/cNlQ
         mm2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+ZfQ3YcR54EbpttrnQUrtNXWUUftHFVFQjHIRQYfMjw=;
        b=QYrY2US/2S87B1UacbohuZelAtZb4LM0wsP5OUdRuGaE5BRlH0eDi9CaB+cnvk4MB/
         foLT2Jg2uddjPP1HEDQdFBRB8cDSektkHLOSOLc73Mg17jheCpevCGNsHDX0jAxDq7vI
         kKHc0AAxIZFgtJ6hBaWO2n0OxUChBm6LQvKrW7+tH/1gtpSI4PIZGq3aRkOwWH/8/cH9
         6P7cp5lf84mLKWl1y5KUKCosXGZhII/Fl68I4HczEDeCRIm02TIQxXN+3kupXXLLoJpI
         1IYxfUXnsO0LS8ShOGh39vlnvvr54081R824NdzDSsUEafJkcJT6GCQUoNE3vVme7vn+
         c3fA==
X-Gm-Message-State: APjAAAWy47aO8vV4XGGeCIef+tezQmCFY+Pe+ZR+liVKWcPvcuTJzxQi
        AUoYbsKrZBj35UaHZqnzdS6JirOmoE4I3TbsHY09GsY99ZPlWg==
X-Google-Smtp-Source: APXvYqzWeSTVVWr5DlCgqsMN+TRetKV+8M8BdxIvQZEvTo07uvNK7CrlnKXFvsQaG0ikNcs7MBggK6EgScwD/RYsv7Y=
X-Received: by 2002:aca:aac5:: with SMTP id t188mr6056901oie.39.1571366510570;
 Thu, 17 Oct 2019 19:41:50 -0700 (PDT)
MIME-Version: 1.0
References: <20191017212858.13230-1-axboe@kernel.dk> <20191017212858.13230-2-axboe@kernel.dk>
In-Reply-To: <20191017212858.13230-2-axboe@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 18 Oct 2019 04:41:22 +0200
Message-ID: <CAG48ez0G2y0JS9=S2KmePO3xq-5DuzgovrLFiX4TJL-G897LCA@mail.gmail.com>
Subject: Re: [PATCH 1/3] io_uring: add support for async work inheriting files table
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 4:01 AM Jens Axboe <axboe@kernel.dk> wrote:
> This is in preparation for adding opcodes that need to modify files
> in a process file table, either adding new ones or closing old ones.

Closing old ones would be tricky. Basically if you call
get_files_struct() while you're between an fdget()/fdput() pair (e.g.
from sys_io_uring_enter()), you're not allowed to use that
files_struct reference to replace or close existing FDs through that
reference. (Or more accurately, if you go through fdget() with
files_struct refcount 1, you must not replace/close FDs in there in
any way until you've passed the corresponding fdput().)

You can avoid that if you ensure that you never use fdget()/fdput() in
the relevant places, only fget()/fput().

> If an opcode needs this, it must set REQ_F_NEED_FILES in the request
> structure. If work that needs to get punted to async context have this
> set, they will grab a reference to the process file table. When the
> work is completed, the reference is dropped again.
[...]
> @@ -2220,6 +2223,10 @@ static void io_sq_wq_submit_work(struct work_struct *work)
>                                 set_fs(USER_DS);
>                         }
>                 }
> +               if (s->files && !old_files) {
> +                       old_files = current->files;
> +                       current->files = s->files;
> +               }

AFAIK e.g. stuff like proc_fd_link() in procfs can concurrently call
get_files_struct() even on kernel tasks, so you should take the
task_lock(current) while fiddling with the ->files pointer.

Also, maybe I'm too tired to read this correctly, but it seems like
when io_sq_wq_submit_work() is processing multiple elements with
->files pointers, this part will only consume a reference to the first
one?

>
>                 if (!ret) {
>                         s->has_user = cur_mm != NULL;
> @@ -2312,6 +2319,11 @@ static void io_sq_wq_submit_work(struct work_struct *work)
>                 unuse_mm(cur_mm);
>                 mmput(cur_mm);
>         }
> +       if (old_files) {
> +               struct files_struct *files = current->files;
> +               current->files = old_files;
> +               put_files_struct(files);
> +       }

And then here the first files_struct reference is dropped, and the
rest of them leak?

>  }
>
>  /*
> @@ -2413,6 +2425,8 @@ static int __io_queue_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>
>                         s->sqe = sqe_copy;
>                         memcpy(&req->submit, s, sizeof(*s));
> +                       if (req->flags & REQ_F_NEED_FILES)
> +                               req->submit.files = get_files_struct(current);

Stupid question: How does this interact with sqpoll mode? In that
case, this function is running on a kernel thread that isn't sharing
the application's files_struct, right?
