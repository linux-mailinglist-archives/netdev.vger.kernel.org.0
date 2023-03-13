Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1AC6B7DC4
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjCMQh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjCMQh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:37:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB01C3802A;
        Mon, 13 Mar 2023 09:37:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D2B3F20676;
        Mon, 13 Mar 2023 16:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1678725404; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DX7mBzmKKfcM2HuODm/+5FefEjTjA8Vp+Q98rewow2A=;
        b=j6iQskk8H7diMVNHczY1aV7fkHvRKIwG3bc4Kl9ZbUa+tRDnYLj3RnaHy5sYnzAxw0m3jv
        M9mVV3eFteDgDImzzbZ+q/TAcIKDKLStcl+drfaTughWYkObovtRaMW30Q1HYD0ff8PxO4
        nQrGIT6UCrRa90UneiNISQqL/jWFkWw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1678725404;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DX7mBzmKKfcM2HuODm/+5FefEjTjA8Vp+Q98rewow2A=;
        b=ioRERLVvqvnqO1qwwQLGqTJRVb3O7tnPx8P0djrxd8iO49bdlnmG5SmCwmrQRiABU/fZ8b
        7scvi92G6gdXmvBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 662B013517;
        Mon, 13 Mar 2023 16:36:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yp4tGBxRD2ShFAAAMHmgww
        (envelope-from <vbabka@suse.cz>); Mon, 13 Mar 2023 16:36:44 +0000
Message-ID: <93d33f35-fc5e-3ab2-1ac0-891f018b4b06@suse.cz>
Date:   Mon, 13 Mar 2023 17:36:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 0/7] remove SLOB and allow kfree() with kmem_cache_alloc()
Content-Language: en-US
To:     Mike Rapoport <mike.rapoport@gmail.com>
Cc:     Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mike Rapoport <rppt@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20230310103210.22372-1-vbabka@suse.cz>
 <ZA2gofYkXRcJ8cLA@kernel.org>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <ZA2gofYkXRcJ8cLA@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/23 10:51, Mike Rapoport wrote:
> Hi Vlastimil,
> 
> On Fri, Mar 10, 2023 at 11:32:02AM +0100, Vlastimil Babka wrote:
>> Also in git:
>> https://git.kernel.org/vbabka/h/slab-remove-slob-v1r1
>> 
>> The SLOB allocator was deprecated in 6.2 so I think we can start
>> exposing the complete removal in for-next and aim at 6.4 if there are no
>> complaints.
>> 
>> Besides code cleanup, the main immediate benefit will be allowing
>> kfree() family of function to work on kmem_cache_alloc() objects (Patch
>> 7), which was incompatible with SLOB.
>> 
>> This includes kfree_rcu() so I've updated the comment there to remove
>> the mention of potential future addition of kmem_cache_free_rcu() as
>> there should be no need for that now.
>> 
>> Otherwise it's straightforward. Patch 2 is a cleanup in net area, that I
>> can either handle in slab tree or submit in net after SLOB is removed.
>> Another cleanup in tomoyo is already in the tomoyo tree as that didn't
>> need to wait until SLOB removal.
>> 
>> Vlastimil Babka (7):
>>   mm/slob: remove CONFIG_SLOB
>>   net: skbuff: remove SLOB-specific ifdefs
>>   mm, page_flags: remove PG_slob_free
>>   mm, pagemap: remove SLOB and SLQB from comments and documentation
>>   mm/slab: remove CONFIG_SLOB code from slab common code
>>   mm/slob: remove slob.c
>>   mm/slab: document kfree() as allowed for kmem_cache_alloc() objects
>> 
>>  Documentation/admin-guide/mm/pagemap.rst     |   6 +-
>>  Documentation/core-api/memory-allocation.rst |  15 +-
>>  fs/proc/page.c                               |   5 +-
>>  include/linux/page-flags.h                   |   4 -
>>  include/linux/rcupdate.h                     |   6 +-
>>  include/linux/slab.h                         |  39 -
>>  init/Kconfig                                 |   2 +-
>>  kernel/configs/tiny.config                   |   1 -
>>  mm/Kconfig                                   |  22 -
>>  mm/Makefile                                  |   1 -
>>  mm/slab.h                                    |  61 --
>>  mm/slab_common.c                             |   7 +-
>>  mm/slob.c                                    | 757 -------------------
>>  net/core/skbuff.c                            |  16 -
>>  tools/mm/page-types.c                        |   6 +-
>>  15 files changed, 23 insertions(+), 925 deletions(-)
>>  delete mode 100644 mm/slob.c
> 
> git grep -in slob still gives a couple of matches. I've dropped the
> irrelevant ones it it left me with these:
> 
> CREDITS:14:D: SLOB slab allocator

I think it wouldn't be fair to remove that one as it's a historical record
of some sort?

> kernel/trace/ring_buffer.c:358: * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
> mm/Kconfig:251:    SLOB allocator and is not recommended for systems with more than

Yeah that's a help text for SLUB_TINY which can still help those who migrate
from SLOB.

> mm/Makefile:25:KCOV_INSTRUMENT_slob.o := n

That one I will remove, thanks!

> Except the comment in kernel/trace/ring_buffer.c all are trivial.
> 
> As for the comment in ring_buffer.c, it looks completely irrelevant at this
> point.
> 
> @Steve?
> 
>> -- 
>> 2.39.2
>> 
> 

