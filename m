Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FB1458406
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 15:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238256AbhKUOTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 09:19:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:50286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236405AbhKUOTG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 09:19:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A835B603E9;
        Sun, 21 Nov 2021 14:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637504161;
        bh=NdN7wxU/ouLqpxo8zR4Fcy0GAiOMueq3uf3+8wncIXs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QEkj9s9N87UfWIPu2ywNL83UqHQKZ0ZHFthEDvalnxMoAufegvYOPL/L/1Sw6QbNH
         YNT5BDTwkTQ1ZUWRuosOodrZGGVaaQPzdwJnTpkTTrhtfxTqvcRQPSh5SAje9nuy3n
         3aLbUo0xfQtp0HawOLacmyMqzUyfrk5eX8z+s9AUr/K9g5S2oLJj7eHTQ4lU6ztrU5
         zZg8dsXYzrMj+T4ydh+chEo1QX4WBdtNF7QFVllxFObaER5xuuCvJXDMk8y/ga6wmf
         d7bnwL3soW3Gwrv7GnwMn3fyTB6x0qBSnr9gwiKN7ttQasNBcbDmSx4ZGVYnOy+HLb
         aY/TtbTxuJoXw==
Date:   Sun, 21 Nov 2021 16:15:57 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     syzbot <syzbot+aab53008a5adf26abe91@syzkaller.appspotmail.com>,
        dledford@redhat.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, zyjzyj2000@gmail.com
Subject: Re: [syzbot] KASAN: use-after-free Read in rxe_queue_cleanup
Message-ID: <YZpUnR05mK6taHs9@unreal>
References: <000000000000c4e52d05d120e1b0@google.com>
 <91426976-b784-e480-6e3a-52da5d1268cc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91426976-b784-e480-6e3a-52da5d1268cc@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 20, 2021 at 06:02:02PM +0300, Pavel Skripkin wrote:
> On 11/19/21 12:27, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    8d0112ac6fd0 Merge tag 'net-5.16-rc2' of git://git.kernel...
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=14e3eeaab00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=6d3b8fd1977c1e73
> > dashboard link: https://syzkaller.appspot.com/bug?extid=aab53008a5adf26abe91
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > 
> > Unfortunately, I don't have any reproducer for this issue yet.
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+aab53008a5adf26abe91@syzkaller.appspotmail.com
> > 
> > Free swap  = 0kB
> > Total swap = 0kB
> > 2097051 pages RAM
> > 0 pages HighMem/MovableOnly
> > 384517 pages reserved
> > 0 pages cma reserved
> > ==================================================================
> > BUG: KASAN: use-after-free in rxe_queue_cleanup+0xf4/0x100 drivers/infiniband/sw/rxe/rxe_queue.c:193
> > Read of size 8 at addr ffff88814a6b6e90 by task syz-executor.3/9534
> > 
> 
> On error handling path in rxe_qp_from_init() qp->sq.queue is freed and then
> rxe_create_qp() will drop last reference to this object. qp clean up
> function will try to free this queue one time and it causes UAF bug.
> 
> Just for thoughts.

You are right, can you please submit patch?

Thanks

> 
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c
> b/drivers/infiniband/sw/rxe/rxe_qp.c
> index 975321812c87..54b8711321c1 100644
> --- a/drivers/infiniband/sw/rxe/rxe_qp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_qp.c
> @@ -359,6 +359,7 @@ int rxe_qp_from_init(struct rxe_dev *rxe, struct rxe_qp
> *qp, struct rxe_pd *pd,
> 
>  err2:
>  	rxe_queue_cleanup(qp->sq.queue);
> +	qp->sq.queue = NULL;
>  err1:
>  	qp->pd = NULL;
>  	qp->rcq = NULL;
> 
> 
> 
> 
> 
> With regards,
> Pavel Skripkin
