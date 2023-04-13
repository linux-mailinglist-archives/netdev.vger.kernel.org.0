Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD316E1634
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 23:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjDMVBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 17:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjDMVBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 17:01:19 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E9093D9;
        Thu, 13 Apr 2023 14:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KYHbzCI9LXyDIUFvJhYJMsas+FJ9lhW+iBOsXt4bUjI=; b=m9duPWlEGjDU8+VCf197UaEupq
        LmiGNeX5d9YHt6/xhMqh+0OMTFW2a1Be1J2tKTGq1r1+Uchpe6v/yGf/0R05b3zOb8PzC6kRvN0vm
        fb1Y8c7xO8rUV2GDKMtTbRV168AyJyngsher5v7fO3ZqvKWN07iACzr2Nk7RcJrNv7w/fJVJaz1Q/
        zEC+jLGw5Z+eEZ3NfEdQj6G3mxmH0IWXUq1pwbhKiK0lWDR3gFKtrLQd52tuvgF/ZmBzpyfEnReLY
        9wHZvOc3wwBjlXfE9JnBb88p9qZPL2b62vsOxxoUKoJrB4jUOtWElqTKhCcuTIiyPquDP3jUKF/Xw
        k9u+K00Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pn448-008kCS-2f;
        Thu, 13 Apr 2023 21:01:12 +0000
Date:   Thu, 13 Apr 2023 22:01:12 +0100
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
Message-ID: <20230413210112.GD3390869@ZenIV>
References: <20230413042917.GA3390869@ZenIV>
 <20230411160902.4134381-1-dhowells@redhat.com>
 <20230411160902.4134381-2-dhowells@redhat.com>
 <20230413005129.GZ3390869@ZenIV>
 <1147766.1681418362@warthog.procyon.org.uk>
 <20230413204918.GC3390869@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413204918.GC3390869@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 09:49:18PM +0100, Al Viro wrote:
> On Thu, Apr 13, 2023 at 09:39:22PM +0100, David Howells wrote:
> > Al Viro <viro@zeniv.linux.org.uk> wrote:
> > 
> > > Note that io_sendmsg_prep() handles both IORING_OP_SENDMSG and IORING_OP_SEND,
> > > so this pair of functions can hit the same request.  And sqe->msg_flags is
> > > not sanitized at all - it comes straight from user buffer.
> > 
> > Assuming ____sys_sendmsg() is fixed, I think it should be sufficient to make
> > io_send() and io_send_zc().  io_sendmsg() and io_sendmsg_zc() will go through
> > ____sys_sendmsg().
> 
> 	Sure; what I wanted to point out was that despite the name,
> io_sendmsg_prep() gets used not only with io_sendmsg().  io_sendmsg()
> does go through ____sys_sendmsg(), but io_send() goes straight to
> sock_sendmsg() and evades all your checks...

	Incidentally, having ____sendmsg and ___sendmsg in the same file
is more than slightly antisocial - compiler can sort it out, but there
are human readers as well.  We have
____sys_sendmsg
___sys_sendmsg
__sys_sendmsg
__sys_sendmmsg
next to each other.  Maze of twisty little identifiers, all alike...
