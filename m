Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB9F631939
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfFADNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:13:04 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43632 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726547AbfFADNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 23:13:04 -0400
Received: by mail-lj1-f195.google.com with SMTP id z5so11361781lji.10;
        Fri, 31 May 2019 20:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W7y0t1BE57lzfu+uhdY3ylGWznDBN9VdOiMaLtHbq9Q=;
        b=Ko/E4KiNUOEV/aYbKYehkF2WPxT7IHS+RfF/MLa0r+Elqiy4hKUbkeRC4mX7C+BwWe
         S7GyN+1kAlEQ5LZ11/L46Tho+5OYTVM/Q+3yHFmFWafrQKbygG4Kct5ZmbqjhSv61geN
         2rDH3mm4Kc+0dbq89YGycPhanJJiCrgUch3mSA8Kyb3Ed1855r5qoOpIZjqgmmSEUqxL
         FIyMobAuOLwA3nV0nra7AlAK8CYqJ2Te6TsiGaMonRo3lcgWhydDNLDIp7g8fQu/GqD8
         /OkRQBPIxZMj+Xrax0HoAyVaara0CKMgVdd15ufruLk+a+sxuO9Z2v2dsR3VEYB+W4P/
         fpXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W7y0t1BE57lzfu+uhdY3ylGWznDBN9VdOiMaLtHbq9Q=;
        b=nSp5YomLRecdrmJnfPlFg0gW/gzh807VoIC7VyctaFlm6R7nX92/82b/XkoCFFopi0
         HCR19sQSSRdpLlrFPetXuHB0LjFGYj5n+SfvgYAJzxRpALpAEweqdriTFlRuRyKFzDIi
         I06Je0VG438NSwgZ+uATC5o909T7X351Y4GVbF/sxvhbsmjNel/cGsEL4NKVT1RuP/Nc
         K35Q6iTSOFzA+sWmg7dFc20i1wQgfqj+BDr56UFgW4toE/zDl3j5hmi6O98Gu93ucouI
         H0TaUY01Vtg3zRsWEMxGF6z8IDsxNhS6lyFpa79X7mBpOcVXaY6AxViATfXC1tgwhjIp
         1aOQ==
X-Gm-Message-State: APjAAAWTOtJl560S1V/Vt6oNf79UB7xyvcZJqR0GkZxVLPNiK/eRziQL
        4R7/GySZmMmdNHAHmqWak28Qz8k40+RGA/czZqs=
X-Google-Smtp-Source: APXvYqzqURqxpAAoiO7eRZBWY1kPr5Erc0XlfyqAjvnwbGRYvXInlNmsMurhDZCieIEYUjLZZ5efUacCg2SVGA5tSLM=
X-Received: by 2002:a2e:9f44:: with SMTP id v4mr7758548ljk.85.1559358781222;
 Fri, 31 May 2019 20:13:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190531223735.4998-1-mmullins@fb.com> <B719E003-E100-463E-A921-E59189572181@fb.com>
In-Reply-To: <B719E003-E100-463E-A921-E59189572181@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 31 May 2019 20:12:49 -0700
Message-ID: <CAADnVQKS1eMMzDRh-fkXQyQihoDBbdg3vAC9jvuOB9QgAakxag@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf: preallocate a perf_sample_data per event fd
To:     Song Liu <songliubraving@fb.com>
Cc:     Matt Mullins <mmullins@fb.com>, Andrew Hall <hall@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 6:28 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On May 31, 2019, at 3:37 PM, Matt Mullins <mmullins@fb.com> wrote:
> >
> > It is possible that a BPF program can be called while another BPF
> > program is executing bpf_perf_event_output.  This has been observed with
> > I/O completion occurring as a result of an interrupt:
> >
> >       bpf_prog_247fd1341cddaea4_trace_req_end+0x8d7/0x1000
> >       ? trace_call_bpf+0x82/0x100
> >       ? sch_direct_xmit+0xe2/0x230
> >       ? blk_mq_end_request+0x1/0x100
> >       ? blk_mq_end_request+0x5/0x100
> >       ? kprobe_perf_func+0x19b/0x240
> >       ? __qdisc_run+0x86/0x520
> >       ? blk_mq_end_request+0x1/0x100
> >       ? blk_mq_end_request+0x5/0x100
> >       ? kprobe_ftrace_handler+0x90/0xf0
> >       ? ftrace_ops_assist_func+0x6e/0xe0
> >       ? ip6_input_finish+0xbf/0x460
> >       ? 0xffffffffa01e80bf
> >       ? nbd_dbg_flags_show+0xc0/0xc0 [nbd]
> >       ? blkdev_issue_zeroout+0x200/0x200
> >       ? blk_mq_end_request+0x1/0x100
> >       ? blk_mq_end_request+0x5/0x100
> >       ? flush_smp_call_function_queue+0x6c/0xe0
> >       ? smp_call_function_single_interrupt+0x32/0xc0
> >       ? call_function_single_interrupt+0xf/0x20
> >       ? call_function_single_interrupt+0xa/0x20
> >       ? swiotlb_map_page+0x140/0x140
> >       ? refcount_sub_and_test+0x1a/0x50
> >       ? tcp_wfree+0x20/0xf0
> >       ? skb_release_head_state+0x62/0xc0
> >       ? skb_release_all+0xe/0x30
> >       ? napi_consume_skb+0xb5/0x100
> >       ? mlx5e_poll_tx_cq+0x1df/0x4e0
> >       ? mlx5e_poll_tx_cq+0x38c/0x4e0
> >       ? mlx5e_napi_poll+0x58/0xc30
> >       ? mlx5e_napi_poll+0x232/0xc30
> >       ? net_rx_action+0x128/0x340
> >       ? __do_softirq+0xd4/0x2ad
> >       ? irq_exit+0xa5/0xb0
> >       ? do_IRQ+0x7d/0xc0
> >       ? common_interrupt+0xf/0xf
> >       </IRQ>
> >       ? __rb_free_aux+0xf0/0xf0
> >       ? perf_output_sample+0x28/0x7b0
> >       ? perf_prepare_sample+0x54/0x4a0
> >       ? perf_event_output+0x43/0x60
> >       ? bpf_perf_event_output_raw_tp+0x15f/0x180
> >       ? blk_mq_start_request+0x1/0x120
> >       ? bpf_prog_411a64a706fc6044_should_trace+0xad4/0x1000
> >       ? bpf_trace_run3+0x2c/0x80
> >       ? nbd_send_cmd+0x4c2/0x690 [nbd]
> >
> > This also cannot be alleviated by further splitting the per-cpu
> > perf_sample_data structs (as in commit 283ca526a9bd ("bpf: fix
> > corruption on concurrent perf_event_output calls")), as a raw_tp could
> > be attached to the block:block_rq_complete tracepoint and execute during
> > another raw_tp.  Instead, keep a pre-allocated perf_sample_data
> > structure per perf_event_array element and fail a bpf_perf_event_output
> > if that element is concurrently being used.
> >
> > Fixes: 20b9d7ac4852 ("bpf: avoid excessive stack usage for perf_sample_data")
> > Signed-off-by: Matt Mullins <mmullins@fb.com>
>
> This looks great. Thanks for the fix.
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> > ---
> > v1->v2:
> >       keep a pointer to the struct perf_sample_data rather than directly
> >       embedding it in the structure, avoiding the circular include and
> >       removing the need for in_use.  Suggested by Song.
> >
> > include/linux/bpf.h      |  1 +
> > kernel/bpf/arraymap.c    |  3 ++-
> > kernel/trace/bpf_trace.c | 29 ++++++++++++++++-------------
> > 3 files changed, 19 insertions(+), 14 deletions(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 4fb3aa2dc975..47fd85cfbbaf 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -472,6 +472,7 @@ struct bpf_event_entry {
> >       struct file *perf_file;
> >       struct file *map_file;
> >       struct rcu_head rcu;
> > +     struct perf_sample_data *sd;
> > };
> >
> > bool bpf_prog_array_compatible(struct bpf_array *array, const struct bpf_prog *fp);
> > diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> > index 584636c9e2eb..c7f5d593e04f 100644
> > --- a/kernel/bpf/arraymap.c
> > +++ b/kernel/bpf/arraymap.c
> > @@ -654,11 +654,12 @@ static struct bpf_event_entry *bpf_event_entry_gen(struct file *perf_file,
> > {
> >       struct bpf_event_entry *ee;
> >
> > -     ee = kzalloc(sizeof(*ee), GFP_ATOMIC);
> > +     ee = kzalloc(sizeof(*ee) + sizeof(struct perf_sample_data), GFP_ATOMIC);
> >       if (ee) {
> >               ee->event = perf_file->private_data;
> >               ee->perf_file = perf_file;
> >               ee->map_file = map_file;
> > +             ee->sd = (void *)ee + sizeof(*ee);

This bit looks quite weird, but I don't have better ideas
to avoid circular .h pain.

Applied to bpf tree. Thanks
