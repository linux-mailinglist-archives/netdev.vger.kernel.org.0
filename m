Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D51117AC60
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgCEROz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:14:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:41312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbgCEROw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 12:14:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44083217F4;
        Thu,  5 Mar 2020 17:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428492;
        bh=DSVLmcHuc32RxTyihN1Xc6Ef2bEnbbW4cyvwhbxU2pI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nz6YA8FzMIQW06sWzoSitQwhw3KNqhsFr87eAT5vfMKRk1DibPr18uRIqU0WG5i1M
         Faq+qVuGeORuTR30u+vDZ5HFD8J6FrjMtJEF16BzDlfenzZJ5kSfC28Gi4exKBv5Vq
         AQQFXuylC4Z7DtkOwfgObKNNpX1TQ/CWGkubbnck=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        syzbot+6a86565c74ebe30aea18@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 25/58] netfilter: ipset: Fix forceadd evaluation path
Date:   Thu,  5 Mar 2020 12:13:46 -0500
Message-Id: <20200305171420.29595-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171420.29595-1-sashal@kernel.org>
References: <20200305171420.29595-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 8af1c6fbd9239877998c7f5a591cb2c88d41fb66 ]

When the forceadd option is enabled, the hash:* types should find and replace
the first entry in the bucket with the new one if there are no reuseable
(deleted or timed out) entries. However, the position index was just not set
to zero and remained the invalid -1 if there were no reuseable entries.

Reported-by: syzbot+6a86565c74ebe30aea18@syzkaller.appspotmail.com
Fixes: 23c42a403a9c ("netfilter: ipset: Introduction of new commands and protocol version 7")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 2ac28c5c7e957..2389c9f89e481 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -931,6 +931,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		}
 	}
 	if (reuse || forceadd) {
+		if (j == -1)
+			j = 0;
 		data = ahash_data(n, j, set->dsize);
 		if (!deleted) {
 #ifdef IP_SET_HASH_WITH_NETS
-- 
2.20.1

