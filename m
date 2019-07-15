Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA8C69021
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390020AbfGOOTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390059AbfGOOTQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:19:16 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A2FF21537;
        Mon, 15 Jul 2019 14:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200356;
        bh=NMeoXYrJmQ1di4bD3LxbW/ZnaQZYLZzYHOjpAxu2cvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ic5J4YZqfzb5ii0KeZaxQzn6pgkmMSSYOS3EqswEA+tyMGC6BIx1+hRgS/Jehrb+h
         1m96/R6zfO28nyMXOyK4ISA94fCx46T2CyK1NfASadt3eDwnV5puRTfg1PWc2LYlvt
         IIJKj2rJPf1TTP4323MIwAy6Kvh+eNSnH6Temw/g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        syzbot+4f0529365f7f2208d9f0@syzkaller.appspotmail.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 023/158] af_key: fix leaks in key_pol_get_resp and dump_sp.
Date:   Mon, 15 Jul 2019 10:15:54 -0400
Message-Id: <20190715141809.8445-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

[ Upstream commit 7c80eb1c7e2b8420477fbc998971d62a648035d9 ]

In both functions, if pfkey_xfrm_policy2msg failed we leaked the newly
allocated sk_buff.  Free it on error.

Fixes: 55569ce256ce ("Fix conversion between IPSEC_MODE_xxx and XFRM_MODE_xxx.")
Reported-by: syzbot+4f0529365f7f2208d9f0@syzkaller.appspotmail.com
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/key/af_key.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 0b79c9aa8eb1..1982f9f31deb 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2442,8 +2442,10 @@ static int key_pol_get_resp(struct sock *sk, struct xfrm_policy *xp, const struc
 		goto out;
 	}
 	err = pfkey_xfrm_policy2msg(out_skb, xp, dir);
-	if (err < 0)
+	if (err < 0) {
+		kfree_skb(out_skb);
 		goto out;
+	}
 
 	out_hdr = (struct sadb_msg *) out_skb->data;
 	out_hdr->sadb_msg_version = hdr->sadb_msg_version;
@@ -2694,8 +2696,10 @@ static int dump_sp(struct xfrm_policy *xp, int dir, int count, void *ptr)
 		return PTR_ERR(out_skb);
 
 	err = pfkey_xfrm_policy2msg(out_skb, xp, dir);
-	if (err < 0)
+	if (err < 0) {
+		kfree_skb(out_skb);
 		return err;
+	}
 
 	out_hdr = (struct sadb_msg *) out_skb->data;
 	out_hdr->sadb_msg_version = pfk->dump.msg_version;
-- 
2.20.1

