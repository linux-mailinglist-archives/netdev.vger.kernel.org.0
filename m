Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271106E035D
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 02:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjDMAvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 20:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDMAvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 20:51:36 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72593E6E;
        Wed, 12 Apr 2023 17:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+Di73Dcq4sxa3H9jRbxC9bukus+StxvYCTBkPSR1lRM=; b=LQ1Bz7JtOuSH1niLgur107JVw4
        gZXvIhGKayXkA2z1WSNtf0XSpfNtgdBbzpUM4NecQhIdXAONAqeqyyEdkQFfZLI3r0bgMpo+PDqSY
        KZ84fC2o/qEpzd7C6VtFgGpc8rNmqTrsqNgkyV09P/3JOCXKHsc1r7T4w2XbezJ7KOS8X9P0FteYS
        k4RxCT/Xkw5mo2dtTRZD6DV5WPaRnfUqb0Wfs5YDGjPPZ77/0W9/7jgVRw6qbYTQpDg/g3VuWxkQF
        cM1cNCFhaZ1UvAlqvGVs8lOTMRUDJcOnHBEY0CPZzdDjHq0IF75dh/1HDGn2nYYCrdBAPNlf2Mc1n
        RbwYiyuQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pmlBR-008TvN-2U;
        Thu, 13 Apr 2023 00:51:30 +0000
Date:   Thu, 13 Apr 2023 01:51:29 +0100
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
Message-ID: <20230413005129.GZ3390869@ZenIV>
References: <20230411160902.4134381-1-dhowells@redhat.com>
 <20230411160902.4134381-2-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411160902.4134381-2-dhowells@redhat.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 05:08:45PM +0100, David Howells wrote:

> @@ -2483,6 +2484,7 @@ static int ____sys_sendmsg(struct socket *sock, struct msghdr *msg_sys,
>  	}
>  	msg_sys->msg_flags = flags;
>  
> +	flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
>  	if (sock->file->f_flags & O_NONBLOCK)
>  		msg_sys->msg_flags |= MSG_DONTWAIT;

A bit too late, innit?  There's no users of 'flags' downstream of that
assignment to ->msg_flags, so your &= is a no-op; it should be done
*before* that assignment...
