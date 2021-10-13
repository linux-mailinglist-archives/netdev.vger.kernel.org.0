Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85DF42C14A
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 15:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhJMNX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 09:23:56 -0400
Received: from www62.your-server.de ([213.133.104.62]:57342 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbhJMNXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 09:23:55 -0400
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1maeCd-0009A8-47; Wed, 13 Oct 2021 15:21:51 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH net-next 2/3] net, neigh: Use NLA_POLICY_MASK helper for NDA_FLAGS_EXT attribute
Date:   Wed, 13 Oct 2021 15:21:39 +0200
Message-Id: <20211013132140.11143-3-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20211013132140.11143-1-daniel@iogearbox.net>
References: <20211013132140.11143-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26321/Wed Oct 13 10:21:20 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of open-coding a check for invalid bits in NTF_EXT_MASK, we can just
use the NLA_POLICY_MASK() helper instead, and simplify NDA_FLAGS_EXT sanity
check this way.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 net/core/neighbour.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 4fc601f9cd06..922b9ed0fe76 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1834,7 +1834,7 @@ const struct nla_policy nda_policy[NDA_MAX+1] = {
 	[NDA_MASTER]		= { .type = NLA_U32 },
 	[NDA_PROTOCOL]		= { .type = NLA_U8 },
 	[NDA_NH_ID]		= { .type = NLA_U32 },
-	[NDA_FLAGS_EXT]		= { .type = NLA_U32 },
+	[NDA_FLAGS_EXT]		= NLA_POLICY_MASK(NLA_U32, NTF_EXT_MASK),
 	[NDA_FDB_EXT_ATTRS]	= { .type = NLA_NESTED },
 };
 
@@ -1936,10 +1936,6 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (tb[NDA_FLAGS_EXT]) {
 		u32 ext = nla_get_u32(tb[NDA_FLAGS_EXT]);
 
-		if (ext & ~NTF_EXT_MASK) {
-			NL_SET_ERR_MSG(extack, "Invalid extended flags");
-			goto out;
-		}
 		BUILD_BUG_ON(sizeof(neigh->flags) * BITS_PER_BYTE <
 			     (sizeof(ndm->ndm_flags) * BITS_PER_BYTE +
 			      hweight32(NTF_EXT_MASK)));
-- 
2.27.0

