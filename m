Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4966F3EB1
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 10:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbjEBIAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 04:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjEBIAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 04:00:20 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E5AE5D;
        Tue,  2 May 2023 01:00:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9E54422316;
        Tue,  2 May 2023 08:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1683014417; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NP9x04IpamZ+4J4+YQ6L241Lqle1HdNEDLK94FhKL1s=;
        b=i0Ht6owzagxVsusrh+k5TXS/6F2cGI8FuxyGJtxaFJRM4m4Tbvw8zxYpoPAbak19HBxF5W
        cxJXamUCHUZLnK6iJcMa2ugn7dBT0o4+Usv0KcVpqAJ9chkraDeslIW2T4hEJ5YlEX4YME
        8K8Dtc7Sx2s/ac0VicMWDMCjyyb5saQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1683014417;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NP9x04IpamZ+4J4+YQ6L241Lqle1HdNEDLK94FhKL1s=;
        b=F85KhN7n9ZQMG5OTs4r7YsDZdS0LgI/nHqlYSWjEfVtH7P6F5XG6gXBa2RHb8jxNFawQrD
        W5FFX4gWEOqqNXDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6DE96134FB;
        Tue,  2 May 2023 08:00:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HTxOGxHDUGTwIwAAMHmgww
        (envelope-from <jack@suse.cz>); Tue, 02 May 2023 08:00:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id A2D8AA0735; Tue,  2 May 2023 10:00:16 +0200 (CEST)
Date:   Tue, 2 May 2023 10:00:16 +0200
From:   Jan Kara <jack@suse.cz>
To:     "Kirill A . Shutemov" <kirill@shutemov.name>
Cc:     David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <20230502080016.4tgmqb4sy2ztfgrd@quack3>
References: <62ec50da-5f73-559c-c4b3-bde4eb215e08@redhat.com>
 <6ddc7ac4-4091-632a-7b2c-df2005438ec4@redhat.com>
 <20230428160925.5medjfxkyvmzfyhq@box.shutemov.name>
 <39cc0f26-8fc2-79dd-2e84-62238d27fd98@redhat.com>
 <20230428162207.o3ejmcz7rzezpt6n@box.shutemov.name>
 <ZEv2196tk5yWvgW5@x1n>
 <173337c0-14f4-3246-15ff-7fbf03861c94@redhat.com>
 <20230428165623.pqchgi5gtfhxd5b5@box.shutemov.name>
 <1039c830-acec-d99b-b315-c2a6e26c34ca@redhat.com>
 <20230428234332.2vhprztuotlqir4x@box.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428234332.2vhprztuotlqir4x@box.shutemov.name>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat 29-04-23 02:43:32, Kirill A . Shutemov wrote:
> I think I found relevant snippet of code that solves similar issue.
> get_futex_key() uses RCU to stabilize page->mapping after GUP_fast:
> 
> 
> 		/*
> 		 * The associated futex object in this case is the inode and
> 		 * the page->mapping must be traversed. Ordinarily this should
> 		 * be stabilised under page lock but it's not strictly
> 		 * necessary in this case as we just want to pin the inode, not
> 		 * update the radix tree or anything like that.
> 		 *
> 		 * The RCU read lock is taken as the inode is finally freed
> 		 * under RCU. If the mapping still matches expectations then the
> 		 * mapping->host can be safely accessed as being a valid inode.
> 		 */
> 		rcu_read_lock();
> 
> 		if (READ_ONCE(page->mapping) != mapping) {
> 			rcu_read_unlock();
> 			put_page(page);
> 
> 			goto again;
> 		}
> 
> 		inode = READ_ONCE(mapping->host);
> 		if (!inode) {
> 			rcu_read_unlock();
> 			put_page(page);
> 
> 			goto again;
> 		}
> 
> I think something similar can be used inside GUP_fast too.

Yeah, inodes (and thus struct address_space) is RCU protected these days so
grabbing RCU lock in gup_fast() will get you enough protection for checking
aops if you are careful (like the futex code is).

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
