Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBB16E05FF
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 06:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjDME32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 00:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDME30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 00:29:26 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7222708;
        Wed, 12 Apr 2023 21:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8M2sS+bw0UFtWqhzE3h/j/MTuZqdYWtjs4JTT3oV6VQ=; b=RueyTb8wJz8ELSxoVMZR8rS+CH
        Q+M3dHGu+eqtOadQE/AZN6JE6gxdZr9ROGzytxwWxsUo15YN4ZZe5BcQm6o0hAcTFiVjkZXr5/PWr
        Iztw6GVgu3GwBN3KBjG/5knk+wnAX/pFfpkR0kS88psVMjdQDwe5RvAAmLcUnkLJvaahnFVVf/VJf
        KJb8bXmxflhz8P5dTis+BGYCFCfvT/3x15E2iPUOaMk1grcLC+wwFlNJ9c8qfJ52IpnBx+1s2cRyW
        TowDClY/PsWxoNFkG+6u/zix3NO3QcFqfNPAQ9KuR8ViXUW6xHXeOE36lPmHNj6m35e/Yygl4oF3e
        +WpGQg5g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pmoaD-008WRA-0t;
        Thu, 13 Apr 2023 04:29:17 +0000
Date:   Thu, 13 Apr 2023 05:29:17 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net-next v6 01/18] net: Declare MSG_SPLICE_PAGES internal
 sendmsg() flag
Message-ID: <20230413042917.GA3390869@ZenIV>
References: <20230411160902.4134381-1-dhowells@redhat.com>
 <20230411160902.4134381-2-dhowells@redhat.com>
 <20230413005129.GZ3390869@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413005129.GZ3390869@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 01:51:29AM +0100, Al Viro wrote:
> On Tue, Apr 11, 2023 at 05:08:45PM +0100, David Howells wrote:
> 
> > @@ -2483,6 +2484,7 @@ static int ____sys_sendmsg(struct socket *sock, struct msghdr *msg_sys,
> >  	}
> >  	msg_sys->msg_flags = flags;
> >  
> > +	flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
> >  	if (sock->file->f_flags & O_NONBLOCK)
> >  		msg_sys->msg_flags |= MSG_DONTWAIT;
> 
> A bit too late, innit?  There's no users of 'flags' downstream of that
> assignment to ->msg_flags, so your &= is a no-op; it should be done
> *before* that assignment...

While we are at it, io-uring has this:
int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
{
        struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
...
        sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;

and

int io_send(struct io_kiocb *req, unsigned int issue_flags)
{
        struct sockaddr_storage __address;
        struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);

...
        flags = sr->msg_flags;
        if (issue_flags & IO_URING_F_NONBLOCK)
                flags |= MSG_DONTWAIT;
        if (flags & MSG_WAITALL)
                min_ret = iov_iter_count(&msg.msg_iter);

        msg.msg_flags = flags;
        ret = sock_sendmsg(sock, &msg);

Note that io_sendmsg_prep() handles both IORING_OP_SENDMSG and IORING_OP_SEND,
so this pair of functions can hit the same request.  And sqe->msg_flags is
not sanitized at all - it comes straight from user buffer.


