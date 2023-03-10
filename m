Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1646B3C2A
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 11:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjCJKcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 05:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbjCJKcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 05:32:18 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E00B1111FF;
        Fri, 10 Mar 2023 02:32:15 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4FCF020652;
        Fri, 10 Mar 2023 10:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1678444334; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=+UxaHT8mKSvWC1QwdfPHOIKK79hhmlWoe1rpbrZg63I=;
        b=Pi4jmECIhq9mt7ExG5YPIfVLCnWAsu13s1ZcnGG8QMsXvppeWz1uSPuiQAAUb4TWtAnyIK
        FFaCIxvGmlNxUZwx+6E7paW4fJEQ4r+txzLRaCowoeYJsr2zCk53dGc5tmS0m3rN5Lr0/K
        Kt/Mg6W6ijqhwCTTXPogOO/aOCVXxr0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1678444334;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=+UxaHT8mKSvWC1QwdfPHOIKK79hhmlWoe1rpbrZg63I=;
        b=qc9mtv8oEd3rdK+9AU0fRFP6mEP8TogXgGtqfBKs7DxeOUmeHcrefoqf50gZ3br6pltm6a
        mpmzxQWPR95dfxBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E502D13592;
        Fri, 10 Mar 2023 10:32:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bBceNy0HC2SsXQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 10 Mar 2023 10:32:13 +0000
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
        Vlastimil Babka <vbabka@suse.cz>,
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
Subject: [PATCH 0/7] remove SLOB and allow kfree() with kmem_cache_alloc()
Date:   Fri, 10 Mar 2023 11:32:02 +0100
Message-Id: <20230310103210.22372-1-vbabka@suse.cz>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also in git:
https://git.kernel.org/vbabka/h/slab-remove-slob-v1r1

The SLOB allocator was deprecated in 6.2 so I think we can start
exposing the complete removal in for-next and aim at 6.4 if there are no
complaints.

Besides code cleanup, the main immediate benefit will be allowing
kfree() family of function to work on kmem_cache_alloc() objects (Patch
7), which was incompatible with SLOB.

This includes kfree_rcu() so I've updated the comment there to remove
the mention of potential future addition of kmem_cache_free_rcu() as
there should be no need for that now.

Otherwise it's straightforward. Patch 2 is a cleanup in net area, that I
can either handle in slab tree or submit in net after SLOB is removed.
Another cleanup in tomoyo is already in the tomoyo tree as that didn't
need to wait until SLOB removal.

Vlastimil Babka (7):
  mm/slob: remove CONFIG_SLOB
  net: skbuff: remove SLOB-specific ifdefs
  mm, page_flags: remove PG_slob_free
  mm, pagemap: remove SLOB and SLQB from comments and documentation
  mm/slab: remove CONFIG_SLOB code from slab common code
  mm/slob: remove slob.c
  mm/slab: document kfree() as allowed for kmem_cache_alloc() objects

 Documentation/admin-guide/mm/pagemap.rst     |   6 +-
 Documentation/core-api/memory-allocation.rst |  15 +-
 fs/proc/page.c                               |   5 +-
 include/linux/page-flags.h                   |   4 -
 include/linux/rcupdate.h                     |   6 +-
 include/linux/slab.h                         |  39 -
 init/Kconfig                                 |   2 +-
 kernel/configs/tiny.config                   |   1 -
 mm/Kconfig                                   |  22 -
 mm/Makefile                                  |   1 -
 mm/slab.h                                    |  61 --
 mm/slab_common.c                             |   7 +-
 mm/slob.c                                    | 757 -------------------
 net/core/skbuff.c                            |  16 -
 tools/mm/page-types.c                        |   6 +-
 15 files changed, 23 insertions(+), 925 deletions(-)
 delete mode 100644 mm/slob.c

-- 
2.39.2

