Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112DB637EDD
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 19:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiKXSSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 13:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiKXSSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 13:18:02 -0500
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDBD7D2AA;
        Thu, 24 Nov 2022 10:18:00 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-141ca09c2fbso2740699fac.6;
        Thu, 24 Nov 2022 10:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hbnUE6H/mwSBuTH5PXVa22n7XTgSQHSv+QT6cH7N6RM=;
        b=BEKtVudjDl/utMwSzHWkR6HeNWRgAHK65e9TF1sn+AovxRPPU9WUXdNn1MAc2gBddp
         v0o2na7dX16fYaOoc8ZhDhuGPXVlZ65DPEPqgaLq5qSfz5V+MSQO+QcdaTflY9ctqQ3g
         XuarFRVKepbUkRqI8sbOOWmViOTi0VCcudWmgvk36MaRK6JQBpCAbEZGKJKIs7ejRjDY
         UHJK8TEUTM5SxQePMqX4hNMByYrirxDgK+P144LkI7tbe+PezCkgP+RjLs4azfqMSEJ+
         NHp9503++RRinpdxEH4VrDTKmvfqIKcw+msm5KsbGTWipnSHM4GF3w45lU1gKHt8e2J6
         bpag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hbnUE6H/mwSBuTH5PXVa22n7XTgSQHSv+QT6cH7N6RM=;
        b=Dm0ymXYvykOMh4gWgkDVsrG/2GdUBuFEgWr4gwntmSWQsmqgSJTnOy4fuXCDfs8Bbx
         7mrL+aR7/iodborXV/KFX/Fs2cXiF4R1tMyjQmLYS0ov58weB+kNrSCHLMnbe++uY4lr
         OBfBhPCosE5K/GRwBR7nPt0vp83obQ31KuBdqUw3pOnhlud+awpa1pE7LvolmkTlrn7B
         AuhxMYuraBdemzz6BfHu2oKk3BrEx3qvvbtiUN2vgSkq5bvdMIMD+EwFk7buOokOwoO9
         ml7gBi/PDARiteGic7K5tmF0zTM91PObHuxb8UQzOwTCgCZ+Q+TjvM2LkocTpD4fPKJH
         LCSQ==
X-Gm-Message-State: ANoB5pnH0DgajrYdaPf8WXyHhvgFI3CQ3KmJdQe+IWMFxSML6oF69+RH
        CCNm7HT5umKISXtBUJBSTr4TuXZ05gxc7gxekmnkZmJYUqLofw==
X-Google-Smtp-Source: AA0mqf7Thx2UjWF8ykIguaj75BoXnLooZz86BAklvESk6W6zqMhYWKSj/FrVp47utRZSo/Acq3Ll15AsAcwXU/CbeaI=
X-Received: by 2002:a05:6870:b426:b0:142:c277:2e94 with SMTP id
 x38-20020a056870b42600b00142c2772e94mr8437513oap.129.1669313879935; Thu, 24
 Nov 2022 10:17:59 -0800 (PST)
MIME-Version: 1.0
References: <20221124131100.369106-1-shaozhengchao@huawei.com> <Y3+nUwOWejYot+M5@t14s.localdomain>
In-Reply-To: <Y3+nUwOWejYot+M5@t14s.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 24 Nov 2022 13:17:20 -0500
Message-ID: <CADvbK_e0MJVrGK8DnuUYhP9ieHotgN5YqECTvYgF1bQe5dtH1w@mail.gmail.com>
Subject: Re: [PATCH net v2] sctp: fix memory leak in sctp_stream_outq_migrate()
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
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

On Thu, Nov 24, 2022 at 12:26 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Thu, Nov 24, 2022 at 09:11:00PM +0800, Zhengchao Shao wrote:
> > When sctp_stream_outq_migrate() is called to release stream out resources,
> > the memory pointed to by prio_head in stream out is not released.
> >
> > The memory leak information is as follows:
> >  unreferenced object 0xffff88801fe79f80 (size 64):
> >    comm "sctp_repo", pid 7957, jiffies 4294951704 (age 36.480s)
> >    hex dump (first 32 bytes):
> >      80 9f e7 1f 80 88 ff ff 80 9f e7 1f 80 88 ff ff  ................
> >      90 9f e7 1f 80 88 ff ff 90 9f e7 1f 80 88 ff ff  ................
> >    backtrace:
> >      [<ffffffff81b215c6>] kmalloc_trace+0x26/0x60
> >      [<ffffffff88ae517c>] sctp_sched_prio_set+0x4cc/0x770
> >      [<ffffffff88ad64f2>] sctp_stream_init_ext+0xd2/0x1b0
> >      [<ffffffff88aa2604>] sctp_sendmsg_to_asoc+0x1614/0x1a30
> >      [<ffffffff88ab7ff1>] sctp_sendmsg+0xda1/0x1ef0
> >      [<ffffffff87f765ed>] inet_sendmsg+0x9d/0xe0
> >      [<ffffffff8754b5b3>] sock_sendmsg+0xd3/0x120
> >      [<ffffffff8755446a>] __sys_sendto+0x23a/0x340
> >      [<ffffffff87554651>] __x64_sys_sendto+0xe1/0x1b0
> >      [<ffffffff89978b49>] do_syscall_64+0x39/0xb0
> >      [<ffffffff89a0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > Link: https://syzkaller.appspot.com/bug?exrid=29c402e56c4760763cc0
> > Fixes: Fixes: 637784ade221 ("sctp: introduce priority based stream scheduler")
> > Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> > ---
> > v2: add .free_sid hook function and use it to free a stream
>
> It's missing the change to sctp_stream_free as well. Please lets try
> to avoid having multiple paths freeing it differently as much as
> possible.
>
Right, something like:

@@ -181,9 +181,9 @@ void sctp_stream_free(struct sctp_stream *stream)
        struct sctp_sched_ops *sched = sctp_sched_ops_from_stream(stream);
        int i;

-       sched->free(stream);
+       sched->unsched_all(stream)
        for (i = 0; i < stream->outcnt; i++)
-               kfree(SCTP_SO(stream, i)->ext);
+               sctp_stream_free_ext(stream, i);
        genradix_free(&stream->out);
        genradix_free(&stream->in);
 }

Thanks.
