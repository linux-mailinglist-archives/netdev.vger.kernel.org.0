Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4521638E4D
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 17:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiKYQf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 11:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiKYQf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 11:35:26 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75E2209B7;
        Fri, 25 Nov 2022 08:35:24 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id l42-20020a9d1b2d000000b0066c6366fbc3so2967325otl.3;
        Fri, 25 Nov 2022 08:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l6vrZ16TDPZuyJzWYEugmSFgV01CDwkCM6LbP9heBUk=;
        b=poYUTTfEiCo3XvvrWNeGy/uhS00DiKYqMhn+1DKllhmPKCyD2CGuuhme67kLw0JOo1
         6ao+n6w/EB68pUMs2RCMoX9jfLghD0zYViHxv2VP5WV4lrDWni5yOqlqOTLA+FUYyYSw
         HA0LnFakn25cktba2MmcA/CLyYJJegvvs3NinvYaDpD4nPxrlpUvuYuiyVJd6e7uEIa3
         vV/XIyOYsbRwES1FjVI/1WUthfAOuaOvgwU1oJ8n39orM/5mU0p/98qDSu1Vy5C7haF1
         WOL3If0IdlYWq2f0psQ1JyN9J4L106sQW+cViIeM4LKYFMuYDd+f2kXxW/kLwqJ5xzjc
         iumQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l6vrZ16TDPZuyJzWYEugmSFgV01CDwkCM6LbP9heBUk=;
        b=3td78E2P0EUbhrTrSnO5SI0MV34qEUyGCTCvQmNlgkXgV0sPz3j4bdYFfb5tgtXyR+
         AQm4LnRkawpGM0n93lm/kOB6YJQD1KqB48wEvkYsXdLe3527ZrxzexcgVS2nic1fGvw8
         JOlReyit7vUcS+g/KCkd52PgREicGMmaKUEY6q5fNIld2Cx3hHC4EB1GvE1pY3S6FceS
         09zsqDGQApGBdy41ILh1lYC+YMCl9vdMLKewkkYmxkAtBBd0WnP/LlR5VFB4yqNDk6qu
         Q88zsHGl/VS0jmt3RBxE5narqRfDf1p8FhfNFzaQ0T7icTt9sctGGNmawq5kVTfS0Hsd
         YZMA==
X-Gm-Message-State: ANoB5pnqUJlH5T64oyuampm+Wn8JOP6KVbVMgLXEwAw8g5Vi0qB1Yhr4
        XwQT6nGADQiXe8Lyan6yY3rKgAepaLFArBKO7RIKG/8ceX5O+w==
X-Google-Smtp-Source: AA0mqf4Qjm2tFoJDSp/jZN4LX93tt1AbFeebKchwipPyn+oae1Mz4NIbyQr8dBz32+lK8s7b2Axz7kFl6X6C2O8yHeg=
X-Received: by 2002:a05:6830:4b:b0:66c:50ce:2a2f with SMTP id
 d11-20020a056830004b00b0066c50ce2a2fmr21000384otp.46.1669394122732; Fri, 25
 Nov 2022 08:35:22 -0800 (PST)
MIME-Version: 1.0
References: <20221125030540.268725-1-shaozhengchao@huawei.com>
In-Reply-To: <20221125030540.268725-1-shaozhengchao@huawei.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 25 Nov 2022 11:34:41 -0500
Message-ID: <CADvbK_ega+KX6agrHw603H-=t6MhN60wm0_f4Z7wt=0j-4A6RQ@mail.gmail.com>
Subject: Re: [PATCH net v3] sctp: fix memory leak in sctp_stream_outq_migrate()
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

,

On Thu, Nov 24, 2022 at 9:59 PM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>
> When sctp_stream_outq_migrate() is called to release stream out resources,
> the memory pointed to by prio_head in stream out is not released.
>
> The memory leak information is as follows:
>  unreferenced object 0xffff88801fe79f80 (size 64):
>    comm "sctp_repo", pid 7957, jiffies 4294951704 (age 36.480s)
>    hex dump (first 32 bytes):
>      80 9f e7 1f 80 88 ff ff 80 9f e7 1f 80 88 ff ff  ................
>      90 9f e7 1f 80 88 ff ff 90 9f e7 1f 80 88 ff ff  ................
>    backtrace:
>      [<ffffffff81b215c6>] kmalloc_trace+0x26/0x60
>      [<ffffffff88ae517c>] sctp_sched_prio_set+0x4cc/0x770
>      [<ffffffff88ad64f2>] sctp_stream_init_ext+0xd2/0x1b0
>      [<ffffffff88aa2604>] sctp_sendmsg_to_asoc+0x1614/0x1a30
>      [<ffffffff88ab7ff1>] sctp_sendmsg+0xda1/0x1ef0
>      [<ffffffff87f765ed>] inet_sendmsg+0x9d/0xe0
>      [<ffffffff8754b5b3>] sock_sendmsg+0xd3/0x120
>      [<ffffffff8755446a>] __sys_sendto+0x23a/0x340
>      [<ffffffff87554651>] __x64_sys_sendto+0xe1/0x1b0
>      [<ffffffff89978b49>] do_syscall_64+0x39/0xb0
>      [<ffffffff89a0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Link: https://syzkaller.appspot.com/bug?exrid=29c402e56c4760763cc0
> Fixes: Fixes: 637784ade221 ("sctp: introduce priority based stream scheduler")
> Reported-by: syzbot+29c402e56c4760763cc0@syzkaller.appspotmail.com
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
> v3: also add .free_sid for sctp_sched_fcfs/rr and make sure only free
>     once in sctp_stream_free()
> v2: add .free_sid hook function and use it to free a stream
> ---
>  include/net/sctp/stream_sched.h |  2 ++
>  net/sctp/stream.c               | 21 +++++++++++++++------
>  net/sctp/stream_sched.c         |  5 +++++
>  net/sctp/stream_sched_prio.c    | 19 +++++++++++++++++++
>  net/sctp/stream_sched_rr.c      |  5 +++++
>  5 files changed, 46 insertions(+), 6 deletions(-)
>
> diff --git a/include/net/sctp/stream_sched.h b/include/net/sctp/stream_sched.h
> index 01a70b27e026..65058faea4db 100644
> --- a/include/net/sctp/stream_sched.h
> +++ b/include/net/sctp/stream_sched.h
> @@ -26,6 +26,8 @@ struct sctp_sched_ops {
>         int (*init)(struct sctp_stream *stream);
>         /* Init a stream */
>         int (*init_sid)(struct sctp_stream *stream, __u16 sid, gfp_t gfp);
> +       /* free a stream */
> +       void (*free_sid)(struct sctp_stream *stream, __u16 sid);
>         /* Frees the entire thing */
>         void (*free)(struct sctp_stream *stream);
>
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index ef9fceadef8d..30bf9ba10f8e 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -52,6 +52,17 @@ static void sctp_stream_shrink_out(struct sctp_stream *stream, __u16 outcnt)
>         }
>  }
>
> +static void sctp_stream_free_ext(struct sctp_stream *stream, __u16 sid)
> +{
> +       struct sctp_sched_ops *sched = sctp_sched_ops_from_stream(stream);
> +
> +       if (SCTP_SO(stream, sid)->ext) {
> +               sched->free_sid(stream, sid);
> +               kfree(SCTP_SO(stream, sid)->ext);
> +               SCTP_SO(stream, sid)->ext = NULL;
> +       }
> +}
> +
static void sctp_stream_free_ext(struct sctp_stream *stream, __u16 sid)
{
        struct sctp_sched_ops *sched;

        if (!SCTP_SO(stream, sid)->ext)
                return;

        sched = sctp_sched_ops_from_stream(stream);
        sched->free_sid(stream, sid);
        kfree(SCTP_SO(stream, sid)->ext);
        SCTP_SO(stream, sid)->ext = NULL;
}

This will look better to me.

>  /* Migrates chunks from stream queues to new stream queues if needed,
>   * but not across associations. Also, removes those chunks to streams
>   * higher than the new max.
> @@ -76,10 +87,8 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
>                 }
>         }
>
> -       for (i = outcnt; i < stream->outcnt; i++) {
> -               kfree(SCTP_SO(stream, i)->ext);
> -               SCTP_SO(stream, i)->ext = NULL;
> -       }
> +       for (i = outcnt; i < stream->outcnt; i++)
> +               sctp_stream_free_ext(stream, i);
>  }
                for (i = 0; i < outcnt; i++) {
-                       kfree(SCTP_SO(new, i)->ext);
+                       sctp_stream_free_ext(new, i);
                        SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
                        SCTP_SO(stream, i)->ext = NULL;
                }

We should replace this one too so that all ext frees go to the same function.

That's all from me.

Thanks.

>
>  static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
> @@ -174,9 +183,9 @@ void sctp_stream_free(struct sctp_stream *stream)
>         struct sctp_sched_ops *sched = sctp_sched_ops_from_stream(stream);
>         int i;
>
> -       sched->free(stream);
> +       sched->unsched_all(stream);
>         for (i = 0; i < stream->outcnt; i++)
> -               kfree(SCTP_SO(stream, i)->ext);
> +               sctp_stream_free_ext(stream, i);
>         genradix_free(&stream->out);
>         genradix_free(&stream->in);
>  }
> diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
> index 1ad565ed5627..7c8f9d89e16a 100644
> --- a/net/sctp/stream_sched.c
> +++ b/net/sctp/stream_sched.c
> @@ -46,6 +46,10 @@ static int sctp_sched_fcfs_init_sid(struct sctp_stream *stream, __u16 sid,
>         return 0;
>  }
>
> +static void sctp_sched_fcfs_free_sid(struct sctp_stream *stream, __u16 sid)
> +{
> +}
> +
>  static void sctp_sched_fcfs_free(struct sctp_stream *stream)
>  {
>  }
> @@ -96,6 +100,7 @@ static struct sctp_sched_ops sctp_sched_fcfs = {
>         .get = sctp_sched_fcfs_get,
>         .init = sctp_sched_fcfs_init,
>         .init_sid = sctp_sched_fcfs_init_sid,
> +       .free_sid = sctp_sched_fcfs_free_sid,
>         .free = sctp_sched_fcfs_free,
>         .enqueue = sctp_sched_fcfs_enqueue,
>         .dequeue = sctp_sched_fcfs_dequeue,
> diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
> index 80b5a2c4cbc7..4fc9f2923ed1 100644
> --- a/net/sctp/stream_sched_prio.c
> +++ b/net/sctp/stream_sched_prio.c
> @@ -204,6 +204,24 @@ static int sctp_sched_prio_init_sid(struct sctp_stream *stream, __u16 sid,
>         return sctp_sched_prio_set(stream, sid, 0, gfp);
>  }
>
> +static void sctp_sched_prio_free_sid(struct sctp_stream *stream, __u16 sid)
> +{
> +       struct sctp_stream_priorities *prio = SCTP_SO(stream, sid)->ext->prio_head;
> +       int i;
> +
> +       if (!prio)
> +               return;
> +
> +       SCTP_SO(stream, sid)->ext->prio_head = NULL;
> +       for (i = 0; i < stream->outcnt; i++) {
> +               if (SCTP_SO(stream, i)->ext &&
> +                   SCTP_SO(stream, i)->ext->prio_head == prio)
> +                       return;
> +       }
> +
> +       kfree(prio);
> +}
> +
>  static void sctp_sched_prio_free(struct sctp_stream *stream)
>  {
>         struct sctp_stream_priorities *prio, *n;
> @@ -323,6 +341,7 @@ static struct sctp_sched_ops sctp_sched_prio = {
>         .get = sctp_sched_prio_get,
>         .init = sctp_sched_prio_init,
>         .init_sid = sctp_sched_prio_init_sid,
> +       .free_sid = sctp_sched_prio_free_sid,
>         .free = sctp_sched_prio_free,
>         .enqueue = sctp_sched_prio_enqueue,
>         .dequeue = sctp_sched_prio_dequeue,
> diff --git a/net/sctp/stream_sched_rr.c b/net/sctp/stream_sched_rr.c
> index ff425aed62c7..cc444fe0d67c 100644
> --- a/net/sctp/stream_sched_rr.c
> +++ b/net/sctp/stream_sched_rr.c
> @@ -90,6 +90,10 @@ static int sctp_sched_rr_init_sid(struct sctp_stream *stream, __u16 sid,
>         return 0;
>  }
>
> +static void sctp_sched_rr_free_sid(struct sctp_stream *stream, __u16 sid)
> +{
> +}
> +
>  static void sctp_sched_rr_free(struct sctp_stream *stream)
>  {
>         sctp_sched_rr_unsched_all(stream);
> @@ -177,6 +181,7 @@ static struct sctp_sched_ops sctp_sched_rr = {
>         .get = sctp_sched_rr_get,
>         .init = sctp_sched_rr_init,
>         .init_sid = sctp_sched_rr_init_sid,
> +       .free_sid = sctp_sched_rr_free_sid,
>         .free = sctp_sched_rr_free,
>         .enqueue = sctp_sched_rr_enqueue,
>         .dequeue = sctp_sched_rr_dequeue,
> --
> 2.17.1
>
