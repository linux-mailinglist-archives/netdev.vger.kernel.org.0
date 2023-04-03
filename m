Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6326D409C
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 11:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbjDCJaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 05:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjDCJaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 05:30:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C58273B;
        Mon,  3 Apr 2023 02:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oZ9EuazeRUfeoBlT6NsYXbe8mS7BH7YG6UzLkTP8fpk=; b=Gz8rVVvF9cvA5IjkYIbR+uKcER
        edvDOZRzBDasfoCEVOiVYehcpHRKVzhGyCMit+t1dzUTgvnM8OJZi2ifHRf3QX4fvaQQ3lIoxBico
        7f6rL6M+OMy3Rb5BJJLzvgRxzsd4OYfMWLvMmqmezpXl1iONGmDHU2w3RtiY9/6nSID32W3siJytd
        +7KS4FUmhNYd0NvHE5i94nH9QduYPMfIEt9PcwCtl5kquKFZophnn4RJ25phOSYmNGDsCVbYCGW7A
        i30ORjSDlOx4C4FDAzmiGJWd9RatiGZIPVmROsrxTWyeonijtTah/mHytYbQYnJ6jF/38y8/MAOJm
        AF+LD3Rw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pjGVn-00Ej59-0N;
        Mon, 03 Apr 2023 09:30:03 +0000
Date:   Mon, 3 Apr 2023 02:30:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Chuck Lever III <chuck.lever@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 00/55] splice, net: Replace sendpage with
 sendmsg(MSG_SPLICE_PAGES)
Message-ID: <ZCqcm7ISjDE6ZO9n@infradead.org>
References: <20230331160914.1608208-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331160914.1608208-1-dhowells@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 05:08:19PM +0100, David Howells wrote:
> Hi Willy, Dave, et al.,

Can we please finish the previous big API transitions before starting
yet another one?  We still have 10 callers if iov_iter_get_pages2 and
of iov_iter_get_pages_alloc2 that need conversion to
iov_iter_extract_pages.  Except for the legacy direct I/O code they
should be easy _and_ largerly overlap what this series touches.

I'll gladly take on direct-io.c.
