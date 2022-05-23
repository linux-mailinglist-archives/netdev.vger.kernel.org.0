Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F072F531D21
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241440AbiEWS2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 14:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245571AbiEWS1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 14:27:10 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0780DDE302;
        Mon, 23 May 2022 11:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=kdOaPNqdKiUqGPqTepXude0v1LHBppL38xhTNFAbyUE=; b=JFgRBwGvqStc/xVkxZN1fSAgNI
        eoeei7L1fZ2sul7FXSHr1xAG5XHoKLc3P9YsQeH4W3SZhO0xWCXJJOiXyyTGCf3z5cowiATentBeT
        ndpFHvaIAP4qcSLaZkRigQWE++Wtc/C8eeT2fsVxJhOvjo3FmLSR0Tqxa4G3wiqJra0T9kmtwJPhc
        OVXC8q1IGfcerbwhca97OkTFuK7igLWk6048kz8aKrbjn+zSir21oG/aUxa85ZBdgpspT9nzUlFQc
        of+YJ+muE3Kc2v8OZClQotwRyVp6Mw4Ub4D0pmOWzj1TTh2iwLSUctqH1MJwIE7KnVkHOY8jI+PeI
        UzGWzXO7Tune+mjnH0oxIRuOLqr5y93m2iB6KPrNyLzneTJelcJRl4D4HqGK8az4isVKT4vg47tbq
        7zKwrZl6gi5zDkCr4lsx0rOEDgRrXFspjFDKRScxA8A06lR3G1pdjaTHMm0oB//byzf0A+oWkptnO
        MVePdl1LLPVNcPMiQmfUh99FYyXoiuAfh8EDMvm949esGEGCWFRM194LlPYx61A7Xuai+MOu7Uc1s
        Y2Rr94yywbsz5ugOX85CeUvUE/ZBOToXlAPjFJfD2ajRCqSUtOTofTv/JYvRcSxVIhrGSUCG+Ysr1
        hsDCvgiT3HHzNQpIXMO9ytusaKgOYCRzFwgQrTXME=;
From:   Christian Schoenebeck <qemu_oss@crudebyte.com>
To:     qemu-devel@nongnu.org
Cc:     Latchesar Ionkov <lucho@ionkov.net>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        Greg Kurz <groug@kaod.org>,
        Keno Fischer <keno@juliacomputing.com>,
        Michael Roitzsch <reactorcontrol@icloud.com>,
        Will Cohen <wwcohen@gmail.com>, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: Re: [RFC PATCH] 9p: case-insensitive host filesystems
Date:   Mon, 23 May 2022 19:59:55 +0200
Message-ID: <6485122.aT25ngTQys@silver>
In-Reply-To: <YmMItCb97KqegQw5@codewreck.org>
References: <1757498.AyhHxzoH2B@silver> <YmMItCb97KqegQw5@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Freitag, 22. April 2022 21:57:40 CEST Dominique Martinet wrote:
> Christian Schoenebeck wrote on Fri, Apr 22, 2022 at 08:02:46PM +0200:
> > So maybe it's better to handle case-insensitivity entirely on client side?
> > I've read that some generic "case fold" code has landed in the Linux
> > kernel
> > recently that might do the trick?
> 
> I haven't tried, but settings S_CASEFOLD on every inodes i_flags might do
> what you want client-side.
> That's easy enough to test and could be a mount option

I just made a quick test using:

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 08f48b70a741..5d8e77daed53 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -257,6 +257,7 @@ int v9fs_init_inode(struct v9fs_session_info *v9ses,
        inode->i_atime = inode->i_mtime = inode->i_ctime = 
current_time(inode);
        inode->i_mapping->a_ops = &v9fs_addr_operations;
        inode->i_private = NULL;
+       inode->i_flags |= S_CASEFOLD;
 
        switch (mode & S_IFMT) {
        case S_IFIFO:

Unfortunately that did not help much. I still get EEXIST error e.g. when 
trying 'ln -s foo FOO'.

I am not sure though whether there would be more code places to touch or 
whether that's even the expected behaviour with S_CASEFOLD for some reason.

> Even with that it's possible to do a direct open without readdir first
> if one knows the path and I that would only be case-insensitive if the
> backing server is case insensitive though, so just setting the option
> and expecting it to work all the time might be a little bit
> optimistic... I believe guess that should be an optimization at best.
> 
> Ideally the server should tell the client they are casefolded somehow,
> but 9p doesn't have any capability/mount time negotiation besides msize
> so that's difficult with the current protocol.


