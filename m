Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6530F6C5414
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjCVStm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbjCVStl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:49:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EA17D8F;
        Wed, 22 Mar 2023 11:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5ch/QuOr2IZ30W763hH9kORlChf/b8rQ2pXYI9kCiyM=; b=Jg+7Mh/3ttDZ569MnI38xXsm2M
        KgOQL4twwfiN/0R2VTr8Q+E6Q7BG5RVG5PQ51jZaxo2UwDyWAtBoOngLa0nDD9UdOuk905yFNRJcx
        bP8twzpPWKr6Hz/hYDZNWZyxeB+4n12owINGX84Uej0E6eobHvVFkRCdDM6zNxNWwzI1017gEIfSr
        fA1Zs/7xWDwt/bH1Vg83A2Zc8GjiNrb3+5SHWd8MYFMRFknWwKUr6s9iG34Zfws4qzN5NovEv3O76
        d0tHhIxq4NdfGSstfThJxzufIS6d3bgdvBLfeTeSgLfw4SydRopROv43UIDvNQSd3BIwH2xecBwFW
        N5VO2O9Q==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pf3WX-003Fix-V1; Wed, 22 Mar 2023 18:49:26 +0000
Date:   Wed, 22 Mar 2023 18:49:25 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Trond Myklebust <trondmy@hammerspace.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Jeffrey Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Anna Schumaker <anna@kernel.org>,
        Charles Edward Lever <chuck.lever@oracle.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: [RFC PATCH] iov_iter: Add an iterator-of-iterators
Message-ID: <ZBtNtWKIejBGlKVv@casper.infradead.org>
References: <9C741BDB-31B0-460C-8FE7-F1C9B49002D5@hammerspace.com>
 <8F8B62FD-0F16-4383-BB34-97E850DAA7AF@hammerspace.com>
 <3DFBF27C-A62B-4AFE-87FD-3DF53FC39E8E@hammerspace.com>
 <20230316152618.711970-1-dhowells@redhat.com>
 <20230316152618.711970-28-dhowells@redhat.com>
 <754534.1678983891@warthog.procyon.org.uk>
 <809995.1678990010@warthog.procyon.org.uk>
 <3416400.1679508945@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3416400.1679508945@warthog.procyon.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 06:15:45PM +0000, David Howells wrote:
> @@ -43,17 +44,17 @@ struct iov_iter {
>  	bool nofault;
>  	bool data_source;
>  	bool user_backed;
> -	union {
> -		size_t iov_offset;
> -		int last_offset;
> -	};
> +	bool spliceable;

We've now up to five u8s in a row here (iter_type, nofault, data_source,
user_backed).  Is it time to turn some/all of them into:

	bool nofault:1;
	bool data_source:1;
	bool user_backed:1;
	bool spliceable:1;

You can't take the address of them then, but I don't believe we do that
anywhere.

