Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B54756C307
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239796AbiGHU2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 16:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239499AbiGHU17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 16:27:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F73D904F3;
        Fri,  8 Jul 2022 13:27:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F132762879;
        Fri,  8 Jul 2022 20:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AE5C341C0;
        Fri,  8 Jul 2022 20:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657312077;
        bh=KuDtVtBgAAnh9uZP6gE6jyKcu9o8adxwpziCKyw+D1Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WmufiYUcq3zcm6dd1iNTqtKpVgGdBvjLWzOU5sxv6VBz6Ay3tnHlmdnPtOjO+0Pue
         D3RG0EAbuoWeFbCQPvVmnXK+1V73J5ZQbN71NPMOYFLO0iMpK5+Rri4jxa7HOzFcDg
         nbPm75oa1l0vVE9K7eoUN7pk4RfbRiKE0CDWNL+RiPumaa+/6vl863wIeev2j91bLx
         Bxvj/cricHhcuY9/ans6GTUmiVSif5qya84lK/7Ys/DYrt9Pf9o8KPCPvQo4yRaDyP
         BhMXyGpn9x5itcChUYnxENjjvUeYo/MS888RT71PhPLhHIQq8dEVBzD8gUmRfQUORn
         iJA/f6e50poXg==
Message-ID: <6927644b409f92ed0622bb0e8a677b8d8007756d.camel@kernel.org>
Subject: Re: [PATCH v3 00/32] Overhaul NFSD filecache
From:   Jeff Layton <jlayton@kernel.org>
To:     Chuck Lever <chuck.lever@oracle.com>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     david@fromorbit.com, tgraf@suug.ch
Date:   Fri, 08 Jul 2022 16:27:55 -0400
In-Reply-To: <165730437087.28142.6731645688073512500.stgit@klimt.1015granger.net>
References: <165730437087.28142.6731645688073512500.stgit@klimt.1015granger.net>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (3.44.3-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-07-08 at 14:23 -0400, Chuck Lever wrote:
> This series overhauls the NFSD filecache, a cache of server-side
> "struct file" objects recently used by NFS clients. The purposes of
> this overhaul are an immediate improvement in cache scalability in
> the number of open files, and preparation for further improvements.
>=20
> There are three categories of patches in this series:
>=20
> 1. Add observability of cache operation so we can see what we're
> doing as changes are made to the code.
>=20
> 2. Improve the scalability of filecache garbage collection,
> addressing several bugs along the way.
>=20
> 3. Improve the scalability of the filecache hash table by converting
> it to use rhashtable.
>=20
> These patches are available in the for-next branch of:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git=20
>=20
> Changes since v2:
> - Fix a cred use-after-free crasher
> - Fix a Smatch error reported by Dan Carpenter
> - Replace dereferences of nfsd_file::nf_inode
> - Further clean-ups and white-space adjustments
>=20
> Changes since RFC:
> - Fixed several crashers
> - Adjusted some of the new observability
> - Tests with generic/531 now pass
> - Fixed bugzilla 387 too, maybe
> - Plenty of clean-ups
>=20
> ---
>=20
> Chuck Lever (32):
>       NFSD: Demote a WARN to a pr_warn()
>       NFSD: Report filecache LRU size
>       NFSD: Report count of calls to nfsd_file_acquire()
>       NFSD: Report count of freed filecache items
>       NFSD: Report average age of filecache items
>       NFSD: Add nfsd_file_lru_dispose_list() helper
>       NFSD: Refactor nfsd_file_gc()
>       NFSD: Refactor nfsd_file_lru_scan()
>       NFSD: Report the number of items evicted by the LRU walk
>       NFSD: Record number of flush calls
>       NFSD: Zero counters when the filecache is re-initialized
>       NFSD: Hook up the filecache stat file
>       NFSD: WARN when freeing an item still linked via nf_lru
>       NFSD: Trace filecache LRU activity
>       NFSD: Leave open files out of the filecache LRU
>       NFSD: Fix the filecache LRU shrinker
>       NFSD: Never call nfsd_file_gc() in foreground paths
>       NFSD: No longer record nf_hashval in the trace log
>       NFSD: Remove lockdep assertion from unhash_and_release_locked()
>       NFSD: nfsd_file_unhash can compute hashval from nf->nf_inode
>       NFSD: Refactor __nfsd_file_close_inode()
>       NFSD: nfsd_file_hash_remove can compute hashval
>       NFSD: Remove nfsd_file::nf_hashval
>       NFSD: Replace the "init once" mechanism
>       NFSD: Set up an rhashtable for the filecache
>       NFSD: Convert the filecache to use rhashtable
>       NFSD: Clean up unused code after rhashtable conversion
>       NFSD: Separate tracepoints for acquire and create
>       NFSD: Move nfsd_file_trace_alloc() tracepoint
>       NFSD: Update the nfsd_file_fsnotify_handle_event() tracepoint
>       NFSD: NFSv4 CLOSE should release an nfsd_file immediately
>       NFSD: Ensure nf_inode is never dereferenced
>=20
>=20
>  fs/nfsd/filecache.c       | 727 ++++++++++++++++++++++++--------------
>  fs/nfsd/filecache.h       |   7 +-
>  fs/nfsd/nfs4proc.c        |   6 +-
>  fs/nfsd/nfs4state.c       |   7 +-
>  fs/nfsd/nfsctl.c          |  10 +
>  fs/nfsd/trace.h           | 300 +++++++++++++---
>  include/trace/events/fs.h |  37 ++
>  7 files changed, 774 insertions(+), 320 deletions(-)
>=20
> --
> Chuck Lever
>=20

Nice work, Chuck!

You can add this to all but #15 (where I still have a question about
whether adding it to the LRU on every put is the right thing to do).

Reviewed-by: Jeff Layton <jlayton@kernel.org>
