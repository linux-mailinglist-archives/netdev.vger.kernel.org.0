Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18E56BD70D
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjCPR3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCPR3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:29:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA913A9D;
        Thu, 16 Mar 2023 10:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SEN+HKxo7EQ3q5D6tuhe44Eox24eDP+iTTu9PwnX/OM=; b=r+edEyVdE8CHzECGKqBOw2z/6K
        pmwPgko9E9SA73wK+2z4oOZWpCopkXUaE5ym0bys0jdwzPDo6kraGswMtU87rc/adnU9rk/zyFN/h
        5ICv8yRV71KH4jem5zFLwoESEv41E4dclTYq5L4qs/1EegQkOxHIyoRxw8HKBGcgeTN2ARXr8oz23
        0eYYj2EHDmhrqCz2dDGjCTGHKBsgzqCO0FDLUtedrD3mnegEZybLCRJuWXhKOqJJYh8u7uwUY+xxc
        xbrG0pH/tRc2U9v4mUJrLqa22NZ6uIr5MTBVRFYhWDGL2gA/WyyAEVT1H6yFIrBPnlo06u+othVO6
        OaUm+ZdA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pcrP8-00F226-M0; Thu, 16 Mar 2023 17:28:42 +0000
Date:   Thu, 16 Mar 2023 17:28:42 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Tom Talpey <tom@talpey.com>, linux-rdma@vger.kernel.org
Subject: Re: [RFC PATCH 02/28] Add a special allocator for staging netfs
 protocol to MSG_SPLICE_PAGES
Message-ID: <ZBNRysLdgZsfVaSj@casper.infradead.org>
References: <20230316152618.711970-1-dhowells@redhat.com>
 <20230316152618.711970-3-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316152618.711970-3-dhowells@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 03:25:52PM +0000, David Howells wrote:
> If a network protocol sendmsg() sees MSG_SPLICE_DATA, it expects that the
> iterator is of ITER_BVEC type and that all the pages can have refs taken on
> them with get_page() and discarded with put_page().  Bits of network
> filesystem protocol data, however, are typically contained in slab memory
> for which the cleanup method is kfree(), not put_page(), so this doesn't
> work.
> 
> Provide a simple allocator, zcopy_alloc(), that allocates a page at a time
> per-cpu and sequentially breaks off pieces and hands them out with a ref as
> it's asked for them.  The caller disposes of the memory it was given by
> calling put_page().  When a page is all parcelled out, it is abandoned by
> the allocator and another page is obtained.  The page will get cleaned up
> when the last skbuff fragment is destroyed.

This feels a _lot_ like the page_frag allocator.  Can the two be
unified?
