Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9D56B3C3B
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 11:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbjCJKcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 05:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbjCJKcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 05:32:21 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE76C110285;
        Fri, 10 Mar 2023 02:32:16 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 05EA922A63;
        Fri, 10 Mar 2023 10:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1678444335; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ynur/BmfAMIVmRdtwJq2oWLnRqKGEqStLCEoP0mvCEk=;
        b=QZUez2xQfWCqt88eXGyNmcCVFR+o4XrrQNVUvQAQC/gEF+ZnoGWlvqfW173ZktqDIya0KM
        u7XqzWIx/f89HNDO83sLN6bThJZxwxp1m/86qDIFrPF8PQS+hjBI21MXT96fg2uEKNHTqg
        3VIb01dFL8+mA7J4ebsbtB44Rhs+7+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1678444335;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ynur/BmfAMIVmRdtwJq2oWLnRqKGEqStLCEoP0mvCEk=;
        b=6Z79qYSGrVUYEvCogt8O06nAIvmuaiI9MxaAVBbTvrKtYfNLDNSRW2zjRe6BzTeZchX+gP
        1d3ni6+77ilnXoCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C9A91139F9;
        Fri, 10 Mar 2023 10:32:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WEKPMC4HC2SsXQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 10 Mar 2023 10:32:14 +0000
From:   Vlastimil Babka <vbabka@suse.cz>
To:     Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>
Cc:     Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 3/7] mm, page_flags: remove PG_slob_free
Date:   Fri, 10 Mar 2023 11:32:05 +0100
Message-Id: <20230310103210.22372-4-vbabka@suse.cz>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310103210.22372-1-vbabka@suse.cz>
References: <20230310103210.22372-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With SLOB removed we no longer need the PG_slob_free alias for
PG_private. Also update tools/mm/page-types.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/page-flags.h | 4 ----
 tools/mm/page-types.c      | 6 +-----
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index a7e3a3405520..2bdc41cb0594 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -174,9 +174,6 @@ enum pageflags {
 	/* Remapped by swiotlb-xen. */
 	PG_xen_remapped = PG_owner_priv_1,
 
-	/* SLOB */
-	PG_slob_free = PG_private,
-
 #ifdef CONFIG_MEMORY_FAILURE
 	/*
 	 * Compound pages. Stored in first tail page's flags.
@@ -483,7 +480,6 @@ PAGEFLAG(Active, active, PF_HEAD) __CLEARPAGEFLAG(Active, active, PF_HEAD)
 PAGEFLAG(Workingset, workingset, PF_HEAD)
 	TESTCLEARFLAG(Workingset, workingset, PF_HEAD)
 __PAGEFLAG(Slab, slab, PF_NO_TAIL)
-__PAGEFLAG(SlobFree, slob_free, PF_NO_TAIL)
 PAGEFLAG(Checked, checked, PF_NO_COMPOUND)	   /* Used by some filesystems */
 
 /* Xen */
diff --git a/tools/mm/page-types.c b/tools/mm/page-types.c
index 381dcc00cb62..8d5595b6c59f 100644
--- a/tools/mm/page-types.c
+++ b/tools/mm/page-types.c
@@ -85,7 +85,6 @@
  */
 #define KPF_ANON_EXCLUSIVE	47
 #define KPF_READAHEAD		48
-#define KPF_SLOB_FREE		49
 #define KPF_SLUB_FROZEN		50
 #define KPF_SLUB_DEBUG		51
 #define KPF_FILE		61
@@ -141,7 +140,6 @@ static const char * const page_flag_names[] = {
 
 	[KPF_ANON_EXCLUSIVE]	= "d:anon_exclusive",
 	[KPF_READAHEAD]		= "I:readahead",
-	[KPF_SLOB_FREE]		= "P:slob_free",
 	[KPF_SLUB_FROZEN]	= "A:slub_frozen",
 	[KPF_SLUB_DEBUG]	= "E:slub_debug",
 
@@ -478,10 +476,8 @@ static uint64_t expand_overloaded_flags(uint64_t flags, uint64_t pme)
 	if ((flags & BIT(ANON)) && (flags & BIT(MAPPEDTODISK)))
 		flags ^= BIT(MAPPEDTODISK) | BIT(ANON_EXCLUSIVE);
 
-	/* SLOB/SLUB overload several page flags */
+	/* SLUB overloads several page flags */
 	if (flags & BIT(SLAB)) {
-		if (flags & BIT(PRIVATE))
-			flags ^= BIT(PRIVATE) | BIT(SLOB_FREE);
 		if (flags & BIT(ACTIVE))
 			flags ^= BIT(ACTIVE) | BIT(SLUB_FROZEN);
 		if (flags & BIT(ERROR))
-- 
2.39.2

