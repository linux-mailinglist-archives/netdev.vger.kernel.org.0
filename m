Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8B46E1617
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 22:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjDMUt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 16:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjDMUt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 16:49:26 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6E59014;
        Thu, 13 Apr 2023 13:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AKRqjOKvWTh8AITsGTpW2W5M1sf4F1a2mFDS4K7IwUQ=; b=TXn26RqZfT59uUv6txfliptdy0
        uljFWZK01bsVf+kp7pZsRM+hew3avu6LrziesUVT8qcKJolEv+3vkQN3aXIvVqQZ26i82PRybKaBG
        yxEybz4Xy3M26l2wmjouqiL/7XqyvNn1hiyD4IEHuckYM2ywqD6V8kmsUbB5Qjw6fxpDgtGvvI5f2
        pWAZf/uNesA+LjMXh6xADfBb1WYmz8wSq95v4JFKDK2cFM+mrjzAvL8j5Saqh+pQSRYTtjuIptZed
        ED2/+oqFIyhIIjRHzyePENhxrRvRx2ngir/yD3rHKVvIqMz6IYudp5gcHww08AWexJ55jzn1tXQ+F
        3mMDm+7A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pn3sc-008jyb-36;
        Thu, 13 Apr 2023 20:49:19 +0000
Date:   Thu, 13 Apr 2023 21:49:18 +0100
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
Message-ID: <20230413204918.GC3390869@ZenIV>
References: <20230413042917.GA3390869@ZenIV>
 <20230411160902.4134381-1-dhowells@redhat.com>
 <20230411160902.4134381-2-dhowells@redhat.com>
 <20230413005129.GZ3390869@ZenIV>
 <1147766.1681418362@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1147766.1681418362@warthog.procyon.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 09:39:22PM +0100, David Howells wrote:
> Al Viro <viro@zeniv.linux.org.uk> wrote:
> 
> > Note that io_sendmsg_prep() handles both IORING_OP_SENDMSG and IORING_OP_SEND,
> > so this pair of functions can hit the same request.  And sqe->msg_flags is
> > not sanitized at all - it comes straight from user buffer.
> 
> Assuming ____sys_sendmsg() is fixed, I think it should be sufficient to make
> io_send() and io_send_zc().  io_sendmsg() and io_sendmsg_zc() will go through
> ____sys_sendmsg().

	Sure; what I wanted to point out was that despite the name,
io_sendmsg_prep() gets used not only with io_sendmsg().  io_sendmsg()
does go through ____sys_sendmsg(), but io_send() goes straight to
sock_sendmsg() and evades all your checks...
