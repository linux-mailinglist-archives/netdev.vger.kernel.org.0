Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B145E9CAB
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 10:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbiIZI6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 04:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbiIZI6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 04:58:04 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21DAA3DBC9;
        Mon, 26 Sep 2022 01:58:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C36D121F34;
        Mon, 26 Sep 2022 08:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664182680; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a16UwsJjCJ8ct9QxuBqwHjiBFMjsCmZvJCcB9CAGKV8=;
        b=Ldmbl3pLGFcFRLjiJ9cX2Gq6DNTlW9KFUoPFO9Em11djLCRi0QS113VPvebZvtr6MVZweN
        on/3J/KdM6KYaSSHbQYcFD9Re6eM1xfTxRZLBktK/DzXLkudV2Md0LlY3L50iBfKIl+15M
        s4UmD71EnrpY/bwnRVGsFuBncjhBpjQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9F4FE13486;
        Mon, 26 Sep 2022 08:58:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RwesJJhpMWO3ZgAAMHmgww
        (envelope-from <mhocko@suse.com>); Mon, 26 Sep 2022 08:58:00 +0000
Date:   Mon, 26 Sep 2022 10:57:59 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org, urezki@gmail.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH mm] mm: fix BUG with kvzalloc+GFP_ATOMIC
Message-ID: <YzFplwSxwwsLpzzX@dhcp22.suse.cz>
References: <20220923103858.26729-1-fw@strlen.de>
 <Yy20toVrIktiMSvH@dhcp22.suse.cz>
 <20220923133512.GE22541@breakpoint.cc>
 <YzFZf0Onm6/UH7/I@dhcp22.suse.cz>
 <20220926075639.GA908@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926075639.GA908@breakpoint.cc>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 26-09-22 09:56:39, Florian Westphal wrote:
> Michal Hocko <mhocko@suse.com> wrote:
> > > kvzalloc(GFP_ATOMIC) was perfectly fine, is this illegal again?
> > 
> > kvmalloc has never really supported GFP_ATOMIC semantic.
> 
> It did, you added it:
> ce91f6ee5b3b ("mm: kvmalloc does not fallback to vmalloc for incompatible gfp flags")

Yes, I am very well aware of this commit and I have to say I wasn't
really supper happy about it TBH. Linus has argued this will result in a
saner code and in some cases this was true.

Later on we really had to add support some extensions beyond
GFP_KERNEL. Your change would break those GFP_NOFAIL and NOFS
usecases. GFP_NOWAIT and GFP_ATOMIC are explicitly documented as
unsupported. One we can do to continue in ce91f6ee5b3b sense is to
do this instead

diff --git a/mm/util.c b/mm/util.c
index 0837570c9225..a27b3fce1f0e 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -618,6 +618,10 @@ void *kvmalloc_node(size_t size, gfp_t flags, int node)
 	 */
 	if (ret || size <= PAGE_SIZE)
 		return ret;
+	
+	/* non-sleeping allocations are not supported by vmalloc */
+	if (!gfpflags_allow_blocking(flags))
+		return NULL;
 
 	/* Don't even allow crazy sizes */
 	if (unlikely(size > INT_MAX)) {

A better option to me seems to be reworking the rhashtable_insert_rehash
to not rely on an atomic allocation. I am not familiar with that code
but it seems to me that the only reason this allocation mode is used is
due to rcu locking around rhashtable_try_insert. Is there any reason we
cannot drop the rcu lock, allocate with the full GFP_KERNEL allocation
power and retry with the pre allocated object? rhashtable_insert_slow is
already doing that to implement its never fail semantic.
-- 
Michal Hocko
SUSE Labs
