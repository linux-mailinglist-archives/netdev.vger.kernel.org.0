Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 122EA5E9DAD
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 11:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbiIZJbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 05:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235000AbiIZJbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 05:31:22 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8809931372;
        Mon, 26 Sep 2022 02:30:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E4BA922100;
        Mon, 26 Sep 2022 09:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664184606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bih9TmuQiIX+2I5xDF+OS0kAuWMZpXGCT3GD+YoKLCM=;
        b=UFRF8LH7nYOh+cFoa+rPZ4LJVzLAlIMi4omuft9vyKbxhJNE5zH0yffwP/MrJ2NQk858V4
        GPXbaFJLat68x/ZhEfKCReJr/gLCecipF+Nl5jADAN3yvxhToNCM14uLMuNHFdw2MEpYaC
        WTYKdgD2npnLqSUq3t55LFOg4bv76Rg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C2E6D139BD;
        Mon, 26 Sep 2022 09:30:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JE1nLB5xMWOgdwAAMHmgww
        (envelope-from <mhocko@suse.com>); Mon, 26 Sep 2022 09:30:06 +0000
Date:   Mon, 26 Sep 2022 11:30:06 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org, urezki@gmail.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH mm] mm: fix BUG with kvzalloc+GFP_ATOMIC
Message-ID: <YzFxHlYoncuDl2fM@dhcp22.suse.cz>
References: <20220923103858.26729-1-fw@strlen.de>
 <Yy20toVrIktiMSvH@dhcp22.suse.cz>
 <20220923133512.GE22541@breakpoint.cc>
 <YzFZf0Onm6/UH7/I@dhcp22.suse.cz>
 <20220926075639.GA908@breakpoint.cc>
 <YzFplwSxwwsLpzzX@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzFplwSxwwsLpzzX@dhcp22.suse.cz>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 26-09-22 10:58:00, Michal Hocko wrote:
[...]
> A better option to me seems to be reworking the rhashtable_insert_rehash
> to not rely on an atomic allocation. I am not familiar with that code
> but it seems to me that the only reason this allocation mode is used is
> due to rcu locking around rhashtable_try_insert. Is there any reason we
> cannot drop the rcu lock, allocate with the full GFP_KERNEL allocation
> power and retry with the pre allocated object? rhashtable_insert_slow is
> already doing that to implement its never fail semantic.

So a very blunt and likely not 100% correct take on this side of things.
But it should give an idea at least.
--- 
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index e12bbfb240b8..fc547c43b05d 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -437,31 +437,11 @@ static void rht_deferred_worker(struct work_struct *work)
 }
 
 static int rhashtable_insert_rehash(struct rhashtable *ht,
-				    struct bucket_table *tbl)
+				    struct bucket_table *tbl,
+				    struct bucket_table *new_tbl)
 {
-	struct bucket_table *old_tbl;
-	struct bucket_table *new_tbl;
-	unsigned int size;
 	int err;
 
-	old_tbl = rht_dereference_rcu(ht->tbl, ht);
-
-	size = tbl->size;
-
-	err = -EBUSY;
-
-	if (rht_grow_above_75(ht, tbl))
-		size *= 2;
-	/* Do not schedule more than one rehash */
-	else if (old_tbl != tbl)
-		goto fail;
-
-	err = -ENOMEM;
-
-	new_tbl = bucket_table_alloc(ht, size, GFP_ATOMIC | __GFP_NOWARN);
-	if (new_tbl == NULL)
-		goto fail;
-
 	err = rhashtable_rehash_attach(ht, tbl, new_tbl);
 	if (err) {
 		bucket_table_free(new_tbl);
@@ -471,17 +451,6 @@ static int rhashtable_insert_rehash(struct rhashtable *ht,
 		schedule_work(&ht->run_work);
 
 	return err;
-
-fail:
-	/* Do not fail the insert if someone else did a rehash. */
-	if (likely(rcu_access_pointer(tbl->future_tbl)))
-		return 0;
-
-	/* Schedule async rehash to retry allocation in process context. */
-	if (err == -ENOMEM)
-		schedule_work(&ht->run_work);
-
-	return err;
 }
 
 static void *rhashtable_lookup_one(struct rhashtable *ht,
@@ -619,9 +588,33 @@ static void *rhashtable_try_insert(struct rhashtable *ht, const void *key,
 		}
 	} while (!IS_ERR_OR_NULL(new_tbl));
 
-	if (PTR_ERR(data) == -EAGAIN)
-		data = ERR_PTR(rhashtable_insert_rehash(ht, tbl) ?:
+	if (PTR_ERR(data) == -EAGAIN) {
+		struct bucket_table *old_tbl;
+		unsigned int size;
+
+		old_tbl = rht_dereference_rcu(ht->tbl, ht);
+		size = tbl->size;
+
+		data = ERR_PTR(-EBUSY);
+
+		if (rht_grow_above_75(ht, tbl))
+			size *= 2;
+		/* Do not schedule more than one rehash */
+		else if (old_tbl != tbl)
+			return data;
+
+		data = ERR_PTR(-ENOMEM);
+
+		rcu_read_unlock();
+		new_tbl = bucket_table_alloc(ht, size, GFP_KERNEL);
+		rcu_read_lock();
+
+		if (!new_tbl)
+			return data;
+
+		data = ERR_PTR(rhashtable_insert_rehash(ht, tbl, new_tbl) ?:
 			       -EAGAIN);
+	}
 
 	return data;
 }

-- 
Michal Hocko
SUSE Labs
