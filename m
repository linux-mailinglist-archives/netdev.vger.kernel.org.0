Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FFF42C14C
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 15:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbhJMNX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 09:23:58 -0400
Received: from www62.your-server.de ([213.133.104.62]:57348 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbhJMNX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 09:23:56 -0400
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1maeCd-0009AO-Ud; Wed, 13 Oct 2021 15:21:52 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH net-next 3/3] net, neigh: Reject creating NUD_PERMANENT with NTF_MANAGED entries
Date:   Wed, 13 Oct 2021 15:21:40 +0200
Message-Id: <20211013132140.11143-4-daniel@iogearbox.net>
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

The combination of NUD_PERMANENT + NTF_MANAGED is not supported and does
not make sense either given the former indicates a static/fixed neighbor
entry whereas the latter a dynamically resolved one. While it is possible
to transition from one over to the other, we should however reject such
creation attempts.

Fixes: 7482e3841d52 ("net, neigh: Add NTF_MANAGED flag for managed neighbor entries")
Suggested-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 net/core/neighbour.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 922b9ed0fe76..47931c8be04b 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1999,15 +1999,20 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	neigh = neigh_lookup(tbl, dst, dev);
 	if (neigh == NULL) {
-		bool exempt_from_gc;
+		bool ndm_permanent  = ndm->ndm_state & NUD_PERMANENT;
+		bool exempt_from_gc = ndm_permanent ||
+				      ndm_flags & NTF_EXT_LEARNED;
 
 		if (!(nlh->nlmsg_flags & NLM_F_CREATE)) {
 			err = -ENOENT;
 			goto out;
 		}
+		if (ndm_permanent && (ndm_flags & NTF_MANAGED)) {
+			NL_SET_ERR_MSG(extack, "Invalid NTF_* flag for permanent entry");
+			err = -EINVAL;
+			goto out;
+		}
 
-		exempt_from_gc = ndm->ndm_state & NUD_PERMANENT ||
-				 ndm_flags & NTF_EXT_LEARNED;
 		neigh = ___neigh_create(tbl, dst, dev,
 					ndm_flags &
 					(NTF_EXT_LEARNED | NTF_MANAGED),
-- 
2.27.0

