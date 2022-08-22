Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B3659C90E
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 21:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbiHVTfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 15:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiHVTfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:35:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56911BE1;
        Mon, 22 Aug 2022 12:35:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0946C5CA41;
        Mon, 22 Aug 2022 19:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661196900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8LOpaT2Q971EUbjBeeWliYNilDBmmPl4LkCkk2UWfDk=;
        b=pGEsQUrii2Ffpmtr8KAOdRMqyQVwo8KxxpKgeV2D/hGy/FAz5HnnGfP7IbIGRpYoALy/83
        Z0JgiA3PYFUqXzFCRRTdOyzmioQ6Bv6y4aiwX2z9ik5cMyyYrSK5ef31rrS/qDgN6JTj/9
        FKohA1XnzPJ/oDg92mSqV9HH3EYkttw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DD8BA1332D;
        Mon, 22 Aug 2022 19:34:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BZy/MmPaA2OcbgAAMHmgww
        (envelope-from <mhocko@suse.com>); Mon, 22 Aug 2022 19:34:59 +0000
Date:   Mon, 22 Aug 2022 21:34:59 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
Message-ID: <YwPZ1lpJ98pZSLmw@dhcp22.suse.cz>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-4-shakeelb@google.com>
 <YwPM6o1+pZ2kRyy3@P9FQF9L96D>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwPM6o1+pZ2kRyy3@P9FQF9L96D>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 22-08-22 11:37:30, Roman Gushchin wrote:
[...]
> I wonder only if we want to make it configurable (Idk a sysctl or maybe
> a config option) and close the topic.

I do not think this is a good idea. We have other examples where we have
outsourced internal tunning to the userspace and it has mostly proven
impractical and long term more problematic than useful (e.g.
lowmem_reserve_ratio, percpu_pagelist_high_fraction, swappiness just to
name some that come to my mind). I have seen more often these to be used
incorrectly than useful.

In this case, I guess we should consider either moving to per memcg
charge batching and see whether the pcp overhead x memcg_count is worth
that or some automagic tuning of the batch size depending on how
effectively the batch is used. Certainly a lot of room for
experimenting.

-- 
Michal Hocko
SUSE Labs
