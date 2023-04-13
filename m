Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937576E0612
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 06:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjDMEl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 00:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDMEl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 00:41:28 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C4446B9;
        Wed, 12 Apr 2023 21:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6sG3AiyiM7RBR5syEPdqKTpBbcBuB1IEexi+k/rw2bU=; b=N2wDv10mH1eRELcaGDIhhfrC/X
        PKXw8TloGBGgmaWkWPyJ7pnLJe9PN6dDwebeLQQvZBrkRstWL4H7RMJ8sojdrt2/6O2Jy7v042nvK
        dtybLlkGUhzy4xR+hDyV4gm14c+0j4dYc8FrzjIDPT8ozVC6l4ERwOhXJN1q2Ptda5TSgQRWW2IsB
        57Nhy3k5PDsn8pamzEmWJ6DsfoK6/TTtY2AceKkN9SFMBun67gSyEIYQjUI6oNJBu8vpIMvTtIhKu
        ISOSTKarUReRQSlUuuC1O9RMlgEV6Ws4iDDCO5uMfXyQAf0dCXKcKoKwM6czVmFwCbebcq8QVs2Qo
        QKwTsrBw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pmolv-008Wc8-2g;
        Thu, 13 Apr 2023 04:41:23 +0000
Date:   Thu, 13 Apr 2023 05:41:23 +0100
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
        linux-mm@kvack.org
Subject: Re: [PATCH net-next v6 06/18] net: Add a function to splice pages
 into an skbuff for MSG_SPLICE_PAGES
Message-ID: <20230413044123.GB3390869@ZenIV>
References: <20230411160902.4134381-1-dhowells@redhat.com>
 <20230411160902.4134381-7-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411160902.4134381-7-dhowells@redhat.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 05:08:50PM +0100, David Howells wrote:
> Add a function to handle MSG_SPLICE_PAGES being passed internally to
> sendmsg().  Pages are spliced into the given socket buffer if possible and
> copied in if not (ie. they're slab pages or have a zero refcount).

That "ie." would better be "e.g." - that condition is *not* enough for
tell the unsafe ones from the rest.

sendpage_ok() would be better off called "might_be_ok_to_sendpage()".
If it's false, we'd better not grab a reference to the page and expect the
sucker to stay safe until the reference is dropped.  However, AFAICS
it might return true on a page that is not safe in that respect.

What rules do you propose for sendpage users?  "Pass whatever page reference
you want, it'll do the right thing"?  Anything short of that would better
be documented as explicitly as possible...
