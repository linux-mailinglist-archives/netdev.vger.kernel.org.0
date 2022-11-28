Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A39D63ACBB
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 16:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbiK1PhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 10:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbiK1Pgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 10:36:48 -0500
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091BD1C117;
        Mon, 28 Nov 2022 07:36:46 -0800 (PST)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1432a5f6468so13399309fac.12;
        Mon, 28 Nov 2022 07:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sWCPUcggo4Bt++OOvehOfrDF3MJqBtSO2lDLybQSkR0=;
        b=jmcsxQITEaC6T8QHNTehEmw3gEzhwWGvaqII74aoEGnACxfygSRDGxsM3CfTDxMdHF
         WhbKkmWWPD76HUdHX7rxvN1tySv/0s0qVdTa7afXCiziGH+b4Kw5Y4dAkBLyJ0FGJlDR
         Yt6lSx45ABQPMvbSD/oxsxHQL0ULlKP7DCKBgczclKo7cKBfnziuBZtI3TkEFQNRTvUb
         55s8nsr9pr/QOYVXxzRncOAq16orSqzTb+eBTryxu1n0bMQUjayy7jRL7hdFsm0OsiAm
         qJ69BZLSAEJHqCmMeE6ENvvhYeMDZ9hHNmp0eY33Tg7Dl8iqsSIENQXfTwCQoMu9Xp6U
         RIBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sWCPUcggo4Bt++OOvehOfrDF3MJqBtSO2lDLybQSkR0=;
        b=uMF62gynf4jeXsvS5d1y2yjFXdbn4oZ9iShR2Llz7KYj5KpUKu28EN4ptYvPWGeGX7
         K0qSCpjZ2Gpd6tH1s0dTfFaCa6u0HsOWSeYqSNL1VupGx9B6o8vw8rWA2NxVjZrrTcZ/
         k05WYO3oibg3Q86Hitc3SaFhmFJj2AdPs0riLSJprjZhIkQ2svzYC38TCBa/wo2Yl4Yw
         38A7PXcwaUCdkhVgL675rUx6y5a++uxNPzlsv8oeR7KD/aMrZIV0XCAtF1aHQ5SqXCVW
         HrINXZNQRrHpuTXG7OFn8tHb78B2R+ucR7D1fUN4sUWtUj48PuhHwnnvrcaBeB1DG0HD
         bsbg==
X-Gm-Message-State: ANoB5pm+snChVwISwWR6IYTw+/geXOccK3BCwUWQRIe2xZoTmu/W0McQ
        ++CbO+6cfwUzCjHOrRfzXHqJIrE0B19BYiz262HsFLkWUgtgQA==
X-Google-Smtp-Source: AA0mqf7D3dk6WRfW3019uzvP+HpGNn3XFwkvYhC500dpi8iWdADK15vK+8KTMX3nxSJGHdzKExqmit0zHoXdNY7hjtg=
X-Received: by 2002:a05:6871:4494:b0:142:6cb4:8b3a with SMTP id
 ne20-20020a056871449400b001426cb48b3amr19053857oab.190.1669649805085; Mon, 28
 Nov 2022 07:36:45 -0800 (PST)
MIME-Version: 1.0
References: <20221126031720.378562-1-shaozhengchao@huawei.com>
In-Reply-To: <20221126031720.378562-1-shaozhengchao@huawei.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 28 Nov 2022 10:36:02 -0500
Message-ID: <CADvbK_cFEJpq7ysejB+vJZK1JEoThihA80+f_1_znpAw4-B+nw@mail.gmail.com>
Subject: Re: [PATCH net v4] sctp: fix memory leak in sctp_stream_outq_migrate()
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

On Fri, Nov 25, 2022 at 10:11 PM Zhengchao Shao
<shaozhengchao@huawei.com> wrote:
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
> Fixes: 637784ade221 ("sctp: introduce priority based stream scheduler")
> Reported-by: syzbot+29c402e56c4760763cc0@syzkaller.appspotmail.com
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
> v4: use .free_sid to free a new stream
> v3: also add .free_sid for sctp_sched_fcfs/rr and make sure only free
>     once in sctp_stream_free()
> v2: add .free_sid hook function and use it to free a stream
> ---
>  include/net/sctp/stream_sched.h |  2 ++
>  net/sctp/stream.c               | 25 ++++++++++++++++++-------
>  net/sctp/stream_sched.c         |  5 +++++
>  net/sctp/stream_sched_prio.c    | 19 +++++++++++++++++++
>  net/sctp/stream_sched_rr.c      |  5 +++++
>  5 files changed, 49 insertions(+), 7 deletions(-)
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
> index ef9fceadef8d..ee6514af830f 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -52,6 +52,19 @@ static void sctp_stream_shrink_out(struct sctp_stream *stream, __u16 outcnt)
>         }
>  }
>
> +static void sctp_stream_free_ext(struct sctp_stream *stream, __u16 sid)
> +{
> +       struct sctp_sched_ops *sched;
> +
> +       if (!SCTP_SO(stream, sid)->ext)
> +               return;
> +
> +       sched = sctp_sched_ops_from_stream(stream);
> +       sched->free_sid(stream, sid);
> +       kfree(SCTP_SO(stream, sid)->ext);
> +       SCTP_SO(stream, sid)->ext = NULL;
> +}
> +
>  /* Migrates chunks from stream queues to new stream queues if needed,
>   * but not across associations. Also, removes those chunks to streams
>   * higher than the new max.
> @@ -70,16 +83,14 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
>                  * sctp_stream_update will swap ->out pointers.
>                  */
>                 for (i = 0; i < outcnt; i++) {
> -                       kfree(SCTP_SO(new, i)->ext);
> +                       sctp_stream_free_ext(new, i);
>                         SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
>                         SCTP_SO(stream, i)->ext = NULL;
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
>
>  static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
> @@ -174,9 +185,9 @@ void sctp_stream_free(struct sctp_stream *stream)
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

Thanks.

Reviewed-by: Xin Long <lucien.xin@gmail.com>
