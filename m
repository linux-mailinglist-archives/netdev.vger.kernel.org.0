Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBF4637558
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229450AbiKXJhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 04:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKXJhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:37:40 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF90211C38
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:37:38 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id i10so2885554ejg.6
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hnCN7ZuWHtgfJvUjcdMFMiyMnm264/VkK0BZtAHklho=;
        b=UmqVAJjNNAbVC1ffphGUaISsdvC/D9ZTQe4teRtQAo0jD01nf9e8It1FObPWGc+u2H
         PjbY911Kv4MBk0/hPoZMjt+dzWr69WE9379jFK0W19qNUld22ieMm1yUGFvomW8CHGma
         nK3i5Hyn673+mmdU5ZGKkKwgBj1AUHMMyAZqqe7Grv/uKcPyCBLyv4a5tAITkw8fCx/b
         x37uE6Owyajsic3BgkLSBF6Kl0ki2wmLWIbGbLQReb+z9Eefw9MhrZ7TjinUYysWg4a7
         CAaJKFy9MWEglAAbzRfVtTGlZDS91zVD2wTne58U3KcZ9speDjdUkI0Da7qEEAH9meEN
         nHDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hnCN7ZuWHtgfJvUjcdMFMiyMnm264/VkK0BZtAHklho=;
        b=sBg0qGI6EuZf9qU+9yPR7WtK5uEZrxS2W9rF/sJYQVSqozqfYNkdBqZb9m3g/uzYL/
         dJeqU6U6DSBPRyek+4H8dkcGw/wQ3oGzXc1mdYvLqpi6Tjmzvhe6IVvBF6bR8fzgVgWI
         TItyQnIEZjHK0yqwCOcr7bZ64LYrKp4RKN68QSs2HwKS7E4c92dlLqtHvJ99LPvVhm+I
         TTDoe8oG6MTlTvqzQ88hQKQ5Kbt2AhOOSol0aB3p8a61vrr/MiyVD+f8RZSlpXLoT562
         ocUzIkCxOCi7KG+CLo34bfQSnJmL8dWWlZa727m9kaZeA9nIDXWRubhjW157MWW6gLUW
         PJ6w==
X-Gm-Message-State: ANoB5pnuOKoF+2K73RsfLj1JkbXDJMxbyYdFs6x5/rrw6PpgxyTxJWft
        JVL2rNltpmr0RxiqQw+Gp2nSyMLPC0jHuS7TyzM=
X-Google-Smtp-Source: AA0mqf46DAzQuaBbghctdquMul3HjgkCsvIQtBUK3Xe0MyKG7RDVW5eCl+0kRxREC7XB2ebPtuU2apIuWfn5HdWec94=
X-Received: by 2002:a17:906:ce4a:b0:7ae:5ad1:e834 with SMTP id
 se10-20020a170906ce4a00b007ae5ad1e834mr26943331ejb.312.1669282656862; Thu, 24
 Nov 2022 01:37:36 -0800 (PST)
MIME-Version: 1.0
References: <CAO4mrfcuDa5hKFksJtBLskA3AAuHUTP_wO9JOfD9Kq0ZvEPPCA@mail.gmail.com>
 <20221123152205.79232-1-kuniyu@amazon.com> <73f71d4e6f867a90538b48894249be3902eb38e4.camel@redhat.com>
In-Reply-To: <73f71d4e6f867a90538b48894249be3902eb38e4.camel@redhat.com>
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Thu, 24 Nov 2022 17:37:04 +0800
Message-ID: <CAO4mrffDLiqo3hWRC=uP_E-3VQSV4O=1BiOaS0Z1J0GHLVgzVQ@mail.gmail.com>
Subject: Re: [PATCH v1 net] af_unix: Call sk_diag_fill() under the bucket lock.
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, kuni1840@gmail.com,
        netdev@vger.kernel.org, syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Linux developers,

My step tracing over Linux found the following C program would trigger
the reported crash. I hope it is helpful for bug fix.

#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <linux/netlink.h>
#include <linux/rtnetlink.h>
#include <linux/sock_diag.h>
#include <linux/unix_diag.h>
#include <linux/stat.h>
#include <sys/types.h>
#include <sys/stat.h>

int main(void) {
    int fd1 = socket(AF_UNIX, SOCK_STREAM, 0);
    struct stat file_stat;
    fstat(fd1, &file_stat);
    int fd2 = socket(AF_NETLINK, SOCK_RAW, NETLINK_SOCK_DIAG);

    struct sockaddr_nl nladdr = {
        .nl_family = AF_NETLINK
    };
    struct {
        struct nlmsghdr nlh;
        struct unix_diag_req udr;
    } req = {
        .nlh = {
            .nlmsg_len = sizeof(req),
            .nlmsg_type = SOCK_DIAG_BY_FAMILY,
            .nlmsg_flags = NLM_F_REQUEST
        },
        .udr = {
            .sdiag_family = AF_UNIX,
            .udiag_states = -1,
            .udiag_ino = file_stat.st_ino,
            .udiag_show = 0x40
        }
    };
    struct iovec iov = {
        .iov_base = &req,
        .iov_len = sizeof(req)
    };
    struct msghdr msg = {
        .msg_name = &nladdr,
        .msg_namelen = sizeof(nladdr),
        .msg_iov = &iov,
        .msg_iovlen = 1
    };

    sendmsg(fd2, &msg, 0);
    return 0;
}

Best,
Wei

On Wed, 23 Nov 2022 at 23:38, Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Wed, 2022-11-23 at 07:22 -0800, Kuniyuki Iwashima wrote:
> > From:   Wei Chen <harperchen1110@gmail.com>
> > Date:   Wed, 23 Nov 2022 23:09:53 +0800
> > > Dear Paolo,
> > >
> > > Could you explain the meaning of modified "ss" version to reproduce
> > > the bug? I'd like to learn how to reproduce the bug in the user space
> > > to facilitate the bug fix.
> >
> > I think it means to drop NLM_F_DUMP and modify args as needed because
> > ss dumps all sockets, not exactly a single socket.
>
> Exactly! Additionally 'ss' must fill udiag_ino and udiag_cookie with
> values matching a live unix socket. And before that you have to add
> more code to allow 'ss' dumping such values (or fetch them with some
> bpf/perf probe).
>
> >
> > Ah, I misunderstood that the found sk is passed to sk_user_ns(), but it's
> > skb->sk.
>
> I did not double check the race you outlined in this patch. That could
> still possibly be a valid/existing one.
>
> > P.S.  I'm leaving for Japan today and will be bit slow this and next week
> > for vacation.
>
> Have a nice trip ;)
>
> /P
>
