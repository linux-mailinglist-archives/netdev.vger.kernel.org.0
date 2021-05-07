Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D83376870
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 18:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238075AbhEGQKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 12:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235662AbhEGQKp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 12:10:45 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4DDF61377;
        Fri,  7 May 2021 16:09:43 +0000 (UTC)
Date:   Fri, 7 May 2021 12:09:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Joel Fernandes <joelaf@google.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [RFC][PATCH] vhost/vsock: Add vsock_list file to map cid with
 vhost tasks
Message-ID: <20210507120942.0b06655e@gandalf.local.home>
In-Reply-To: <20210507154332.hiblsd6ot5wzwkdj@steredhat>
References: <20210505163855.32dad8e7@gandalf.local.home>
        <20210507141120.ot6xztl4h5zyav2c@steredhat>
        <20210507104036.711b0b10@gandalf.local.home>
        <20210507154332.hiblsd6ot5wzwkdj@steredhat>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 May 2021 17:43:32 +0200
Stefano Garzarella <sgarzare@redhat.com> wrote:

> >The start/stop of a seq_file() is made for taking locks. I do this with all
> >my code in ftrace. Yeah, there's a while loop between the two, but that's
> >just to fill the buffer. It's not that long and it never goes to userspace
> >between the two. You can even use this for spin locks (but I wouldn't
> >recommend doing it for raw ones).  
> 
> Ah okay, thanks for the clarification!
> 
> I was worried because building with `make C=2` I had these warnings:
> 
> ../drivers/vhost/vsock.c:944:13: warning: context imbalance in 'vsock_start' - wrong count at exit
> ../drivers/vhost/vsock.c:963:13: warning: context imbalance in 'vsock_stop' - unexpected unlock
> 
> Maybe we need to annotate the functions somehow.

Yep, I it should have been.

static void *vsock_start(struct seq_file *m, loff_t *pos)
	__acquires(rcu)
{
	[...]

}

static void vsock_stop(struct seq_file *m, void *p)
	__releases(rcu)
{
	[...]
}

static int vsock_show(struct seq_file *m, void *v)
	__must_hold(rcu)
{
	[...]
}


And guess what? I just copied those annotations from sock_hash_seq_start(),
sock_hash_seq_show() and sock_hash_seq_stop() from net/core/sock_map.c
which is doing exactly the same thing ;-)

So there's definitely precedence for this.

> 
> >  
> >>  
> >> >+
> >> >+	iter->index = -1;
> >> >+	iter->node = NULL;
> >> >+	t = vsock_next(m, iter, NULL);
> >> >+
> >> >+	for (; iter->index < HASH_SIZE(vhost_vsock_hash) && l < *pos;
> >> >+	     t = vsock_next(m, iter, &l))
> >> >+		;  
> >>
> >> A while() maybe was more readable...  
> >
> >Again, I just cut and pasted from my other code.
> >
> >If you have a good idea on how to implement this with netlink (something
> >that ss or netstat can dislpay), I think that's the best way to go.  
> 
> Okay, I'll take a look and get back to you.
> If it's too complicated, we can go ahead with this patch.

Awesome, thanks!

-- Steve
