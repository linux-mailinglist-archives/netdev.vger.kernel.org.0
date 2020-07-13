Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B492B21DB6B
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730050AbgGMQQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729644AbgGMQQQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 12:16:16 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B304620773;
        Mon, 13 Jul 2020 16:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594656976;
        bh=viaWXYM+Hs+AEgp6HyUr4ayigk0ciBjuIkl+U4M6f14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s3bpwgfdoyqBtvh7sbQq/zZG4qK0G98JmqWEADCQBOiodMVRITO0V7ERDvTR7fZad
         MMG7/bMEeQAQlhST0UqZrhqtF4uFHtq1NEgNHQIb21qIkICpYBBW3evZWakmoWa3sS
         vjCLjBeh31uGK/Y6COna+guDJQT7ANGqoEJ3Zh8c=
Date:   Mon, 13 Jul 2020 09:16:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     syzbot <syzbot+4c50ac32e5b10e4133e1@syzkaller.appspotmail.com>,
        andriin@fb.com, ast@kernel.org, axboe@kernel.dk,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: WARNING in submit_bio_checks
Message-ID: <20200713161614.GC1696@sol.localdomain>
References: <00000000000029663005aa23cff4@google.com>
 <20200713101836.GA536@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713101836.GA536@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 11:18:36AM +0100, Christoph Hellwig wrote:
> On Fri, Jul 10, 2020 at 10:34:19PM -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following crash on:
> 
> This is not a crash, but a WARN_ONCE.  A pre-existing one that just
> slightly changed the printed message recently.
> 

It doesn't really matter.  WARN is for indicating kernel bugs only.
A user-triggable WARN is a bug.  Either the bug that makes the WARN
reachable needs to be fixed, or if the WARN is legitimately user-reachable
it needs to be removed or replaced with a proper ratelimited log message.

This one looks legitimately user-reachable, so we could do:

diff --git a/block/blk-core.c b/block/blk-core.c
index d9d632639bd1..354c51ad5c81 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -854,8 +854,8 @@ static inline bool bio_check_ro(struct bio *bio, struct hd_struct *part)
 		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
 			return false;
 
-		WARN_ONCE(1,
-		       "Trying to write to read-only block-device %s (partno %d)\n",
+		pr_warn_ratelimited(
+		       "block: trying to write to read-only block-device %s (partno %d)\n",
 			bio_devname(bio, b), part->partno);
 		/* Older lvm-tools actually trigger this */
 		return false;


We could also show current->comm and current->pid if they would be useful here.

And yes, this is preexisting which is why syzbot has reported this before
(https://syzkaller.appspot.com/bug?id=79eda145ab047a0dc7d03ca5fcb1cf12206eb481).
Just no one has bothered to fix it yet.

- Eric
