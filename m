Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5921A02DD
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgDGABf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726965AbgDGABe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 519CE208E4;
        Tue,  7 Apr 2020 00:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217693;
        bh=nSZIgXpFCKsSZKb4dKx/zHl30eiBHp5c5LbK7nJDkxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QoHxiqRgFLjnQDIWxntGWeLiEr6aFAvi5OvnazrebtGst/hOzL3ry5UtQa/xdXTQu
         HrYROmZDH/J5UuB+KjtKdE2afGXh2XwLYxEjAyImuJwqtyRCJQJjsYw2o7/x/GPzWz
         F/p6BQRWLtW94mZTNtnG8e1TXD7/93PNR4Zfk9Ks=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 27/35] netfilter: nf_tables: Allow set back-ends to report partial overlaps on insertion
Date:   Mon,  6 Apr 2020 20:00:49 -0400
Message-Id: <20200407000058.16423-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000058.16423-1-sashal@kernel.org>
References: <20200407000058.16423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 8c2d45b2b65ca1f215244be1c600236e83f9815f ]

Currently, the -EEXIST return code of ->insert() callbacks is ambiguous: it
might indicate that a given element (including intervals) already exists as
such, or that the new element would clash with existing ones.

If identical elements already exist, the front-end is ignoring this without
returning error, in case NLM_F_EXCL is not set. However, if the new element
can't be inserted due an overlap, we should report this to the user.

To this purpose, allow set back-ends to return -ENOTEMPTY on collision with
existing elements, translate that to -EEXIST, and return that to userspace,
no matter if NLM_F_EXCL was set.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 11a2a7b5312ee..a9f6bace16245 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4957,6 +4957,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 				err = -EBUSY;
 			else if (!(nlmsg_flags & NLM_F_EXCL))
 				err = 0;
+		} else if (err == -ENOTEMPTY) {
+			/* ENOTEMPTY reports overlapping between this element
+			 * and an existing one.
+			 */
+			err = -EEXIST;
 		}
 		goto err5;
 	}
-- 
2.20.1

