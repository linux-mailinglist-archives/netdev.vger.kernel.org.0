Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B3F630B03
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 04:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbiKSDQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 22:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiKSDQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 22:16:28 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC41E56D7C;
        Fri, 18 Nov 2022 19:16:26 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id p27-20020a056830319b00b0066d7a348e20so4209807ots.8;
        Fri, 18 Nov 2022 19:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0NBA36PGJ/cO1i8M+swqvjlGpAb5Eb3TET8AUSbEexY=;
        b=dcREEXgqP+4nAyRKQhU7komKK4hSC1dUZFp2BzjBlGiyJRQU3SLG5XsDs1zLV+2wC4
         YUmIhY8lvvJ9e/VWLEx6IEwlXqP3jTuoo9QHMAZYsWJwaEEHjaDoxzY6prPLysnR4SMD
         DyWU0U/mx/HjXlyeX0E9C9ifQAnimD4GSM+nylqT3pGuII03vFQLEfE/Vg1QCIMzyh7n
         MOx9afmovhkMCevwQdrOMqO7BXv4luwin2yWjzwzhkDQWZdoSkrkm2FvLyJ9WToDSw0u
         n9ZLMeH63ZOGe0++LhjcgOHjtInQtz+xmK2inkWjU0UUCzyV4Z4Js9JUlWLX3GuvfweM
         15JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0NBA36PGJ/cO1i8M+swqvjlGpAb5Eb3TET8AUSbEexY=;
        b=bx3lS6fBtrCB3zqIhcPuOyM1D1DQtiYXDSWLAPKhUSMeDV2G+ZsxDc9oOPui8GFpDA
         bOPwM6HDYEnysXLU0iV9wK5pXMrAs/d+hnVJib5RUv+wckKi6ksjO9gDmMFxJItQ9gmJ
         n1ldguA+AKDA33o3e/jWFSRQXEsuL0ZPQixRhDlX4/fUZTRYnRGNBTt9FypwMJ5zV4Iu
         x29xju+PrB/j4iTNVxQAPFjRiQAvGsd/TcrE1P+kn+WLwBl7+Ms2C9s+yjziIOmtQinH
         loCP61689tlauuVqa7nv/1r/9nxS/rBlBq4armQodpQrFazmKAylfNEalXCOo6u/dGfo
         X6Yg==
X-Gm-Message-State: ANoB5plryYZLRfpzCUjFBaE/HXLcYX6qEO4SNt4TsBVkDEnigGDuYN1Q
        AzxmVip837BcTHeL9N9kZI8zZrDaeGd9wzNtBes=
X-Google-Smtp-Source: AA0mqf4VlbFfJ00JcQ8+Kt3F3xj8zJflcwbUyUe5BC3bIVAA3B7WBvHC4PDbvnoJDZwgOKTUuwnwgCoC+HJUVdN/Dmk=
X-Received: by 2002:a05:6830:1254:b0:665:da4d:8d22 with SMTP id
 s20-20020a056830125400b00665da4d8d22mr5076763otp.295.1668827785970; Fri, 18
 Nov 2022 19:16:25 -0800 (PST)
MIME-Version: 1.0
References: <20221118085030.121297-1-shaozhengchao@huawei.com>
In-Reply-To: <20221118085030.121297-1-shaozhengchao@huawei.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 18 Nov 2022 22:15:50 -0500
Message-ID: <CADvbK_frWVFTSLMwC_xYvE+jDuk917K7SqZHUON3srLz8TxotQ@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix memory leak in sctp_stream_outq_migrate()
To:     Zhengchao Shao <shaozhengchao@huawei.com>,
        marcelo.leitner@gmail.com
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
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

On Fri, Nov 18, 2022 at 3:48 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>
> When sctp_stream_outq_migrate() is called to release stream out resources,
> the memory pointed to by prio_head in stream out is not released.
>
> The memory leak information is as follows:
> unreferenced object 0xffff88801fe79f80 (size 64):
>   comm "sctp_repo", pid 7957, jiffies 4294951704 (age 36.480s)
>   hex dump (first 32 bytes):
>     80 9f e7 1f 80 88 ff ff 80 9f e7 1f 80 88 ff ff  ................
>     90 9f e7 1f 80 88 ff ff 90 9f e7 1f 80 88 ff ff  ................
>   backtrace:
>     [<ffffffff81b215c6>] kmalloc_trace+0x26/0x60
>     [<ffffffff88ae517c>] sctp_sched_prio_set+0x4cc/0x770
>     [<ffffffff88ad64f2>] sctp_stream_init_ext+0xd2/0x1b0
>     [<ffffffff88aa2604>] sctp_sendmsg_to_asoc+0x1614/0x1a30
>     [<ffffffff88ab7ff1>] sctp_sendmsg+0xda1/0x1ef0
>     [<ffffffff87f765ed>] inet_sendmsg+0x9d/0xe0
>     [<ffffffff8754b5b3>] sock_sendmsg+0xd3/0x120
>     [<ffffffff8755446a>] __sys_sendto+0x23a/0x340
>     [<ffffffff87554651>] __x64_sys_sendto+0xe1/0x1b0
>     [<ffffffff89978b49>] do_syscall_64+0x39/0xb0
>     [<ffffffff89a0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Fixes: 637784ade221 ("sctp: introduce priority based stream scheduler")
> Reported-by: syzbot+29c402e56c4760763cc0@syzkaller.appspotmail.com
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/sctp/stream.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index ef9fceadef8d..a17dc368876f 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -70,6 +70,9 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
>                  * sctp_stream_update will swap ->out pointers.
>                  */
>                 for (i = 0; i < outcnt; i++) {
> +                       if (SCTP_SO(new, i)->ext)
> +                               kfree(SCTP_SO(new, i)->ext->prio_head);
> +
>                         kfree(SCTP_SO(new, i)->ext);
>                         SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
>                         SCTP_SO(stream, i)->ext = NULL;
> @@ -77,6 +80,9 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
>         }
>
>         for (i = outcnt; i < stream->outcnt; i++) {
> +               if (SCTP_SO(stream, i)->ext)
> +                       kfree(SCTP_SO(stream, i)->ext->prio_head);
> +
>                 kfree(SCTP_SO(stream, i)->ext);
>                 SCTP_SO(stream, i)->ext = NULL;
>         }
> --
> 2.17.1
>
This is not a proper fix:
1. you shouldn't access "prio_head" outside stream_sched_prio.c.
2. the prio_head you freed might be used by other out streams, freeing
it unconditionally would cause either a double free or use after free.

I'm afraid we have to add a ".free_sid" in sctp_sched_ops, and
implement it for sctp_sched_prio, like:

+static void sctp_sched_prio_free_sid(struct sctp_stream *stream, __u16 sid)
+{
+       struct sctp_stream_priorities *prio = SCTP_SO(stream,
sid)->ext->prio_head;
+       int i;
+
+       if (!prio)
+               return;
+
+       SCTP_SO(stream, sid)->ext->prio_head = NULL;
+       for (i = 0; i < stream->outcnt; i++) {
+               if (SCTP_SO(stream, i)->ext &&
+                   SCTP_SO(stream, i)->ext->prio_head == prio)
+                       return;
+       }
+       kfree(prio);
+}
+
 static void sctp_sched_prio_free(struct sctp_stream *stream)
 {
        struct sctp_stream_priorities *prio, *n;
@@ -323,6 +340,7 @@ static struct sctp_sched_ops sctp_sched_prio = {
        .get = sctp_sched_prio_get,
        .init = sctp_sched_prio_init,
        .init_sid = sctp_sched_prio_init_sid,
+       .free_sid = sctp_sched_prio_free_sid,
        .free = sctp_sched_prio_free,
        .enqueue = sctp_sched_prio_enqueue,
        .dequeue = sctp_sched_prio_dequeue,

then call it in sctp_stream_outq_migrate(), like:

+static void sctp_stream_free_ext(struct sctp_stream *stream, __u16 sid)
+{
+       struct sctp_sched_ops *sched = sctp_sched_ops_from_stream(stream);
+
+       sched->free_sid(stream, sid);
+       kfree(SCTP_SO(stream, sid)->ext);
+       SCTP_SO(stream, sid)->ext = NULL;
+}
+
 /* Migrates chunks from stream queues to new stream queues if needed,
  * but not across associations. Also, removes those chunks to streams
  * higher than the new max.
@@ -70,16 +79,14 @@ static void sctp_stream_outq_migrate(struct
sctp_stream *stream,
                 * sctp_stream_update will swap ->out pointers.
                 */
                for (i = 0; i < outcnt; i++) {
-                       kfree(SCTP_SO(new, i)->ext);
+                       sctp_stream_free_ext(new, i);
                        SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
                        SCTP_SO(stream, i)->ext = NULL;
                }
        }

-       for (i = outcnt; i < stream->outcnt; i++) {
-               kfree(SCTP_SO(stream, i)->ext);
-               SCTP_SO(stream, i)->ext = NULL;
-       }
+       for (i = outcnt; i < stream->outcnt; i++)
+               sctp_stream_free_ext(new, i);
 }

Marcelo, do you see a better solution?

Thanks.
