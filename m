Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29225F6A16
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 16:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbiJFO4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 10:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbiJFO4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 10:56:23 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B6CA02FF
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 07:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=ZMNLSUf6Qyu+KAvj19SIjC94yMD3cu4FuP71CCwikco=; b=apay3AV+e6EflvSpAGN7446iGx
        Bx9yWzyD+DGQAT+uEgfm0r+HGI83ma3jW3qE21NDREDulKXM6NCasNtG+1sWcOOWgXaEerqR49wtm
        HlPJopd0gfUEq09TEjT5Pgj8+7ndP3aBhKZzg3fGY6i0XaNmdt6i7mlPzL25tdjZIKXnNWf45XUyS
        +fp2+mCr8EV38pbzD7+uqswIfgrbeu9xDUhqJtJjOCyTv5obWbN2cDA+1pa0ZxlYqc7x0DRP0m/HK
        dWvpCdtU72MvQOMg5P5L5ucqgooiVQ7BGlkBj37mU6SN0L62EWim/0ELgqc3mTy1zSjrH6Qa8d1tg
        porQub+l5qd9vUOUuSll3cGolp3so4sanafaeaUqA72ECjMRh9m4OOqzWInnn0qsYZmfeA7ef4Ivq
        YY9bUcKuFA0rD2aWMVD6sUK7nUgs5yfm+1JEp1ofZUKVUKC9O+kkaWox8MJHAVSYaMQ6Lo6wEzapt
        Nfu5uZozaS44n/GsLFx7ZFgGC9SxT+CHRVld5bE3PIRxdgZqcFIZBJ229bALobHRoXIzNABIdlD/7
        GvapyEl61a0ogg41frsE48tOijaYVep1bIiYgKT9hZiaCGZ9zaSYIcrNuQnIP779GUqCRsl+TGz2M
        6UZevLjAGMBdqb6y8fuGxPMmwlY5c2u5dJFPBE8jM=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Dominique Martinet <asmadeus@codewreck.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        syzbot <syzbot+8b41a1365f1106fd0f33@syzkaller.appspotmail.com>,
        v9fs-developer@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org
Subject: Re: [PATCH] 9p/trans_fd: always use O_NONBLOCK read/write
Date:   Thu, 06 Oct 2022 16:55:23 +0200
Message-ID: <4870107.4IDB3aycit@silver>
In-Reply-To: <345de429-a88b-7097-d177-adecf9fed342@I-love.SAKURA.ne.jp>
References: <00000000000039af4d05915a9f56@google.com>
 <000000000000c1d3ca0593128b24@google.com>
 <345de429-a88b-7097-d177-adecf9fed342@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Freitag, 26. August 2022 17:27:46 CEST Tetsuo Handa wrote:
> syzbot is reporting hung task at p9_fd_close() [1], for p9_mux_poll_stop()
>  from p9_conn_destroy() from p9_fd_close() is failing to interrupt already
> started kernel_read() from p9_fd_read() from p9_read_work() and/or
> kernel_write() from p9_fd_write() from p9_write_work() requests.
> 
> Since p9_socket_open() sets O_NONBLOCK flag, p9_mux_poll_stop() does not
> need to interrupt kernel_read()/kernel_write(). However, since p9_fd_open()
> does not set O_NONBLOCK flag, but pipe blocks unless signal is pending,
> p9_mux_poll_stop() needs to interrupt kernel_read()/kernel_write() when
> the file descriptor refers to a pipe. In other words, pipe file descriptor
> needs to be handled as if socket file descriptor.
> 
> We somehow need to interrupt kernel_read()/kernel_write() on pipes.
> 
> A minimal change, which this patch is doing, is to set O_NONBLOCK flag
>  from p9_fd_open(), for O_NONBLOCK flag does not affect reading/writing
> of regular files. But this approach changes O_NONBLOCK flag on userspace-
> supplied file descriptors (which might break userspace programs), and
> O_NONBLOCK flag could be changed by userspace. It would be possible to set
> O_NONBLOCK flag every time p9_fd_read()/p9_fd_write() is invoked, but still
> remains small race window for clearing O_NONBLOCK flag.
> 
> If we don't want to manipulate O_NONBLOCK flag, we might be able to
> surround kernel_read()/kernel_write() with set_thread_flag(TIF_SIGPENDING)
> and recalc_sigpending(). Since p9_read_work()/p9_write_work() works are
> processed by kernel threads which process global system_wq workqueue,
> signals could not be delivered from remote threads when p9_mux_poll_stop()
>  from p9_conn_destroy() from p9_fd_close() is called. Therefore, calling
> set_thread_flag(TIF_SIGPENDING)/recalc_sigpending() every time would be
> needed if we count on signals for making kernel_read()/kernel_write()
> non-blocking.
> 
> Link: https://syzkaller.appspot.com/bug?extid=8b41a1365f1106fd0f33 [1]
> Reported-by: syzbot <syzbot+8b41a1365f1106fd0f33@syzkaller.appspotmail.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Tested-by: syzbot <syzbot+8b41a1365f1106fd0f33@syzkaller.appspotmail.com>
> ---
> Although syzbot tested that this patch solves hung task problem, syzbot
> cannot verify that this patch will not break functionality of p9 users.
> Please test before applying this patch.
> 
>  net/9p/trans_fd.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

I would also prefer this simpler v1 instead of v2 for now. One nitpicking ...

> diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> index e758978b44be..9870597da583 100644
> --- a/net/9p/trans_fd.c
> +++ b/net/9p/trans_fd.c
> @@ -821,11 +821,13 @@ static int p9_fd_open(struct p9_client *client, int
> rfd, int wfd) goto out_free_ts;
>  	if (!(ts->rd->f_mode & FMODE_READ))
>  		goto out_put_rd;
> +	ts->rd->f_flags |= O_NONBLOCK;

... I think this deserves a short comment like:

    /* prevent hung task with pipes */

Anyway,

Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>

>  	ts->wr = fget(wfd);
>  	if (!ts->wr)
>  		goto out_put_rd;
>  	if (!(ts->wr->f_mode & FMODE_WRITE))
>  		goto out_put_wr;
> +	ts->wr->f_flags |= O_NONBLOCK;
> 
>  	client->trans = ts;
>  	client->status = Connected;



