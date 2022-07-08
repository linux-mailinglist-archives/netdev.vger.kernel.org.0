Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A8656C0C5
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239276AbiGHSXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239500AbiGHSXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:23:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A1357228;
        Fri,  8 Jul 2022 11:23:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFC40B8291F;
        Fri,  8 Jul 2022 18:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B653C341C0;
        Fri,  8 Jul 2022 18:23:40 +0000 (UTC)
Subject: [PATCH v3 00/32] Overhaul NFSD filecache
From:   Chuck Lever <chuck.lever@oracle.com>
To:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Cc:     david@fromorbit.com, jlayton@redhat.com, tgraf@suug.ch
Date:   Fri, 08 Jul 2022 14:23:38 -0400
Message-ID: <165730437087.28142.6731645688073512500.stgit@klimt.1015granger.net>
User-Agent: StGit/1.5.dev3+g9561319
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series overhauls the NFSD filecache, a cache of server-side
"struct file" objects recently used by NFS clients. The purposes of
this overhaul are an immediate improvement in cache scalability in
the number of open files, and preparation for further improvements.

There are three categories of patches in this series:

1. Add observability of cache operation so we can see what we're
doing as changes are made to the code.

2. Improve the scalability of filecache garbage collection,
addressing several bugs along the way.

3. Improve the scalability of the filecache hash table by converting
it to use rhashtable.

These patches are available in the for-next branch of:

https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git 

Changes since v2:
- Fix a cred use-after-free crasher
- Fix a Smatch error reported by Dan Carpenter
- Replace dereferences of nfsd_file::nf_inode
- Further clean-ups and white-space adjustments

Changes since RFC:
- Fixed several crashers
- Adjusted some of the new observability
- Tests with generic/531 now pass
- Fixed bugzilla 387 too, maybe
- Plenty of clean-ups

---

Chuck Lever (32):
      NFSD: Demote a WARN to a pr_warn()
      NFSD: Report filecache LRU size
      NFSD: Report count of calls to nfsd_file_acquire()
      NFSD: Report count of freed filecache items
      NFSD: Report average age of filecache items
      NFSD: Add nfsd_file_lru_dispose_list() helper
      NFSD: Refactor nfsd_file_gc()
      NFSD: Refactor nfsd_file_lru_scan()
      NFSD: Report the number of items evicted by the LRU walk
      NFSD: Record number of flush calls
      NFSD: Zero counters when the filecache is re-initialized
      NFSD: Hook up the filecache stat file
      NFSD: WARN when freeing an item still linked via nf_lru
      NFSD: Trace filecache LRU activity
      NFSD: Leave open files out of the filecache LRU
      NFSD: Fix the filecache LRU shrinker
      NFSD: Never call nfsd_file_gc() in foreground paths
      NFSD: No longer record nf_hashval in the trace log
      NFSD: Remove lockdep assertion from unhash_and_release_locked()
      NFSD: nfsd_file_unhash can compute hashval from nf->nf_inode
      NFSD: Refactor __nfsd_file_close_inode()
      NFSD: nfsd_file_hash_remove can compute hashval
      NFSD: Remove nfsd_file::nf_hashval
      NFSD: Replace the "init once" mechanism
      NFSD: Set up an rhashtable for the filecache
      NFSD: Convert the filecache to use rhashtable
      NFSD: Clean up unused code after rhashtable conversion
      NFSD: Separate tracepoints for acquire and create
      NFSD: Move nfsd_file_trace_alloc() tracepoint
      NFSD: Update the nfsd_file_fsnotify_handle_event() tracepoint
      NFSD: NFSv4 CLOSE should release an nfsd_file immediately
      NFSD: Ensure nf_inode is never dereferenced


 fs/nfsd/filecache.c       | 727 ++++++++++++++++++++++++--------------
 fs/nfsd/filecache.h       |   7 +-
 fs/nfsd/nfs4proc.c        |   6 +-
 fs/nfsd/nfs4state.c       |   7 +-
 fs/nfsd/nfsctl.c          |  10 +
 fs/nfsd/trace.h           | 300 +++++++++++++---
 include/trace/events/fs.h |  37 ++
 7 files changed, 774 insertions(+), 320 deletions(-)

--
Chuck Lever

