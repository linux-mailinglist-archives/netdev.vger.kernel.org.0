Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B7269D152
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 17:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbjBTQ3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 11:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbjBTQ3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 11:29:08 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36741DB94;
        Mon, 20 Feb 2023 08:29:07 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id v78so1883416ybe.3;
        Mon, 20 Feb 2023 08:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nzHEYETioASnqtKMsAReNmUZKSSBmv92prCt8QAsrVw=;
        b=nqanxfHfwTvEV+XsprkJKhK36w33aI0YlKMkIYP4GrlBTdDhyjs1Z7OnJ8YfqN+dyA
         cSizVjdht1RvwZg/0kLyKGeK6tQxUgVVfH0ZIwTYAhXAf4QVxGPM6+ojvm94zxC/anQH
         5nRKs99rjqzGmybzl3Rvr8c+3C+9yiSS/AhgzP7g5KkIqjpHu8J3NpxtBFkpRsLNPEkZ
         F6Ml4z0UAiKkfF9RYs/hZP/LWbxGFp6QmHZfMFHrXAPdvgt3hyXBdmEGsm0JqO3JQqV3
         W0hSaUQ26zAvpuvChYDe+dX1oH4G7pAYO0YzOv4AEXyUgUqlpjpA0v4vwqzVhukM6+eN
         lrBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nzHEYETioASnqtKMsAReNmUZKSSBmv92prCt8QAsrVw=;
        b=sdvN7f3MGbAyXa7t7NRNy+Zh/R2tv6GKfOcdTbyGpAAnrlZLtdCm6fGsCB68QBW3W4
         dLStjgzTEYIQSaRsizmwBCunvdu2Oluzq4m4ifP4ZhHY9vPDFDRCeqqsiptrd/uUEwJt
         c+YxRMVV3+eeQ4qYCCXTyNNUUOvEWVgc39Ea9OIL9XHYu6e7CjJuX5bHfzOvO1iZmzdk
         uAVFReUuz7sEGxK9cisfKdko/D5E/tUpT+dzUlT7UyLOkN8haTh1FjJiRxHZLby0IWom
         Ubse9bbq0qPvQ66pEqQPe26IiX8AztO085v9DGK4bd3FUKPbvGOuN/3YsxX68y9OBy5E
         UjnQ==
X-Gm-Message-State: AO0yUKVUOfm2Z4ateR5Dbo52kskImvLUWMKVQiRFUyVrv8l56Mlhqcs2
        xjw3VA3PeV0IYmfd79NxSCAfhDfIFFh18p7peVD8c03wo49QSQ==
X-Google-Smtp-Source: AK7set899bYdnTtR9h9yeupmPzXERIS7AgIUueiXM9tZ8LLA2jXiXXEMVA0FxpRQhRIJq6A2V15PBBKM/hW3yq9dAfE=
X-Received: by 2002:a25:8d11:0:b0:87e:266f:629d with SMTP id
 n17-20020a258d11000000b0087e266f629dmr286500ybl.57.1676910546914; Mon, 20 Feb
 2023 08:29:06 -0800 (PST)
MIME-Version: 1.0
References: <06ac4e517bff69c23646594d3b404b9ffb51001c.1676491484.git.lucien.xin@gmail.com>
 <744a8737ce7dc2f149c82738e4ab15233d0b35d9.camel@redhat.com>
In-Reply-To: <744a8737ce7dc2f149c82738e4ab15233d0b35d9.camel@redhat.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 20 Feb 2023 11:28:50 -0500
Message-ID: <CADvbK_e_5_TkHnFKtU5R0=+Gri++SZsMGZvp3hz4cFopLSVYSA@mail.gmail.com>
Subject: Re: [PATCH net] sctp: add a refcnt in sctp_stream_priorities to avoid
 a nested loop
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>
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

On Mon, Feb 20, 2023 at 2:31 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Wed, 2023-02-15 at 15:04 -0500, Xin Long wrote:
> > With this refcnt added in sctp_stream_priorities, we don't need to
> > traverse all streams to check if the prio is used by other streams
> > when freeing one stream's prio in sctp_sched_prio_free_sid(). This
> > can avoid a nested loop (up to 65535 * 65535), which may cause a
> > stuck as Ying reported:
> >
> >     watchdog: BUG: soft lockup - CPU#23 stuck for 26s! [ksoftirqd/23:136]
> >     Call Trace:
> >      <TASK>
> >      sctp_sched_prio_free_sid+0xab/0x100 [sctp]
> >      sctp_stream_free_ext+0x64/0xa0 [sctp]
> >      sctp_stream_free+0x31/0x50 [sctp]
> >      sctp_association_free+0xa5/0x200 [sctp]
> >
> > Note that it doesn't need to use refcount_t type for this counter,
> > as its accessing is always protected under the sock lock.
> >
> > Fixes: 9ed7bfc79542 ("sctp: fix memory leak in sctp_stream_outq_migrate()")
> > Reported-by: Ying Xu <yinxu@redhat.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  include/net/sctp/structs.h   |  1 +
> >  net/sctp/stream_sched_prio.c | 47 +++++++++++++-----------------------
> >  2 files changed, 18 insertions(+), 30 deletions(-)
> >
> > diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
> > index afa3781e3ca2..e1f6e7fc2b11 100644
> > --- a/include/net/sctp/structs.h
> > +++ b/include/net/sctp/structs.h
> > @@ -1412,6 +1412,7 @@ struct sctp_stream_priorities {
> >       /* The next stream in line */
> >       struct sctp_stream_out_ext *next;
> >       __u16 prio;
> > +     __u16 users;
>
> I'm sorry for the late feedback. Reading the commit message, it looks
> like this counter could reach at least 64K. Is a __u16 integer wide
> enough?
Normally, it will be enough. The max count of out streams is
SCTP_MAX_STREAM (65535), and each stream will hold the "prio_head" once
only. So when there's only one "prio_head", and 65535 streams will hold
this "prio_head" 65535 times, this is at most.

However, I notice in sctp_sched_prio_set() when changing one stream's
"prio_head", it picks and holds the new one, then releases the old
one. If the new one is the same as the old one while all streams are
already holding it, it may reach 65536 in a moment. Although it will
go back to 65535 soon, it's better to add a check to avoid this:

@@ -168,6 +170,9 @@ static int sctp_sched_prio_set(struct sctp_stream
*stream, __u16 sid,
        struct sctp_stream_priorities *prio_head, *old;
        bool reschedule = false;

+       if (soute->prio_head && soute->prio_head->prio == prio)
+               return 0;
+

I will post v2.

Thanks.
