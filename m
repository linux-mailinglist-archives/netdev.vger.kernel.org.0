Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CCF35CE35
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343651AbhDLQnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:43:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245091AbhDLQh6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:37:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDC64613F0;
        Mon, 12 Apr 2021 16:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244881;
        bh=PKWGjn59mD7Mm5VpJQLtqmDQ2WQyPivU4D3AlBj5KVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUEUF0dYAjCCxRu+6ZZkaieCmXXdT+J7bLwCGVobx7RQbLeWrTbCwNdt9CvfyEJ2P
         IO2GA/dkHt5a6qoqcwpqN1lbgzU3XwAPBuWhHHZFnqKMqnF9fGE2629Ct75MpRlbEy
         axwdsa6ut/UE0QPUMDUg2uEzQHJ3+WVEBOj2PgO1Ur8Ayz9nzd9HGNobo/ShtuPTah
         h0C0324v5E0WjfKgj5qAWygClGOPpNJfoBikzvJhkBcYlHuKU2RZ2HoMpC0xjfjYAA
         gSNdVMuuay/IzwhWQH6reJVG5JMPg9hNmv0lWWUK3Ai56qubqfNsNA2vG2FbQPsq3D
         6vaoj+IrAKe4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 19/23] net: mac802154: Fix general protection fault
Date:   Mon, 12 Apr 2021 12:27:32 -0400
Message-Id: <20210412162736.316026-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162736.316026-1-sashal@kernel.org>
References: <20210412162736.316026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 1165affd484889d4986cf3b724318935a0b120d8 ]

syzbot found general protection fault in crypto_destroy_tfm()[1].
It was caused by wrong clean up loop in llsec_key_alloc().
If one of the tfm array members is in IS_ERR() range it will
cause general protection fault in clean up function [1].

Call Trace:
 crypto_free_aead include/crypto/aead.h:191 [inline] [1]
 llsec_key_alloc net/mac802154/llsec.c:156 [inline]
 mac802154_llsec_key_add+0x9e0/0xcc0 net/mac802154/llsec.c:249
 ieee802154_add_llsec_key+0x56/0x80 net/mac802154/cfg.c:338
 rdev_add_llsec_key net/ieee802154/rdev-ops.h:260 [inline]
 nl802154_add_llsec_key+0x3d3/0x560 net/ieee802154/nl802154.c:1584
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reported-by: syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210304152125.1052825-1-paskripkin@gmail.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac802154/llsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac802154/llsec.c b/net/mac802154/llsec.c
index a13d02b7cee4..55ed8a97b33f 100644
--- a/net/mac802154/llsec.c
+++ b/net/mac802154/llsec.c
@@ -158,7 +158,7 @@ llsec_key_alloc(const struct ieee802154_llsec_key *template)
 	crypto_free_blkcipher(key->tfm0);
 err_tfm:
 	for (i = 0; i < ARRAY_SIZE(key->tfm); i++)
-		if (key->tfm[i])
+		if (!IS_ERR_OR_NULL(key->tfm[i]))
 			crypto_free_aead(key->tfm[i]);
 
 	kzfree(key);
-- 
2.30.2

