Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17B5422879
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 15:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbhJENwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 09:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235281AbhJENwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87F626152B;
        Tue,  5 Oct 2021 13:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441843;
        bh=yrpRKkL6xcRfyMkzjo9W+bYXu/RbUkXLCmi/o9RYsu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yc9/jDawrtuTj9SvnwucrMQGVqPEpXsrEzLBHlcre9XxrRzon9OuEtpgQObcIyTdq
         JdWuvulf/+FSBipom1Wy7xH5S6Gb4Glbuyif3wkmO7NKjC+ASpS5zbLgDuQUN6KGHJ
         MSTPJ3jBpWwt8MzymIDI4hJ7BltEq//y+BMqn/ct+9vzYXcMu8Y8xt2Tl9ejhXDnPJ
         rVJy+vXXbuJdUWhPGaGU1lY5w8FgCFKy0FJl+a1ZNfvf0o436KucuC6B075NgrtBgg
         qlFSkzwU2fw3KTsT35+wBcluWij78MJnG7BEVYjTiL0bcBP6Ho7M2rAD0hLs7AjB8/
         CvVZrAA7nonuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        syzbot+3493b1873fb3ea827986@syzkaller.appspotmail.com,
        syzbot+2b8443c35458a617c904@syzkaller.appspotmail.com,
        syzbot+ee5cb15f4a0e85e0d54e@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, vvs@virtuozzo.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 09/40] netfilter: ipset: Fix oversized kvmalloc() calls
Date:   Tue,  5 Oct 2021 09:49:48 -0400
Message-Id: <20211005135020.214291-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 7bbc3d385bd813077acaf0e6fdb2a86a901f5382 ]

The commit

commit 7661809d493b426e979f39ab512e3adf41fbcc69
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jul 14 09:45:49 2021 -0700

    mm: don't allow oversized kvmalloc() calls

limits the max allocatable memory via kvmalloc() to MAX_INT. Apply the
same limit in ipset.

Reported-by: syzbot+3493b1873fb3ea827986@syzkaller.appspotmail.com
Reported-by: syzbot+2b8443c35458a617c904@syzkaller.appspotmail.com
Reported-by: syzbot+ee5cb15f4a0e85e0d54e@syzkaller.appspotmail.com
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 6186358eac7c..6e391308431d 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -130,11 +130,11 @@ htable_size(u8 hbits)
 {
 	size_t hsize;
 
-	/* We must fit both into u32 in jhash and size_t */
+	/* We must fit both into u32 in jhash and INT_MAX in kvmalloc_node() */
 	if (hbits > 31)
 		return 0;
 	hsize = jhash_size(hbits);
-	if ((((size_t)-1) - sizeof(struct htable)) / sizeof(struct hbucket *)
+	if ((INT_MAX - sizeof(struct htable)) / sizeof(struct hbucket *)
 	    < hsize)
 		return 0;
 
-- 
2.33.0

