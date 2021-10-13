Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E8D42C148
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 15:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbhJMNXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 09:23:55 -0400
Received: from www62.your-server.de ([213.133.104.62]:57330 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhJMNXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 09:23:54 -0400
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1maeCc-0009A4-FP; Wed, 13 Oct 2021 15:21:50 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH net-next 1/3] net, neigh: Add build-time assertion to avoid neigh->flags overflow
Date:   Wed, 13 Oct 2021 15:21:38 +0200
Message-Id: <20211013132140.11143-2-daniel@iogearbox.net>
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

Currently, NDA_FLAGS_EXT flags allow a maximum of 24 bits to be used for
extended neighbor flags. These are eventually fed into neigh->flags by
shifting with NTF_EXT_SHIFT as per commit 2c611ad97a82 ("net, neigh:
Extend neigh->flags to 32 bit to allow for extensions").

If really ever needed in future, the full 32 bits from NDA_FLAGS_EXT can
be used, it would only require to move neigh->flags from u32 to u64 inside
the kernel.

Add a build-time assertion such that when extending the NTF_EXT_MASK with
new bits, we'll trigger an error once we surpass the 24th bit. This assumes
that no bit holes in new NTF_EXT_* flags will slip in from UAPI, but I
think this is reasonable to assume.

Suggested-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 net/core/neighbour.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index eae73efa9245..4fc601f9cd06 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1940,6 +1940,9 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 			NL_SET_ERR_MSG(extack, "Invalid extended flags");
 			goto out;
 		}
+		BUILD_BUG_ON(sizeof(neigh->flags) * BITS_PER_BYTE <
+			     (sizeof(ndm->ndm_flags) * BITS_PER_BYTE +
+			      hweight32(NTF_EXT_MASK)));
 		ndm_flags |= (ext << NTF_EXT_SHIFT);
 	}
 	if (ndm->ndm_ifindex) {
-- 
2.27.0

