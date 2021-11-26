Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2638145E520
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 03:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358333AbhKZCjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:39:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357599AbhKZChd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:37:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F9BA611B0;
        Fri, 26 Nov 2021 02:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893983;
        bh=Tsgww/qdhvyUADo/Sg017d6jlbzRTp12gSqKpU9/L1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6C72ua5MIhqA0I3+89q25aYX5acaOMS9UIbaeIiZ40QdmtrBaXNfFX3ttPoxuJ0T
         ohtIuvtmTmZcj5LocYZenU/cqoVKKh+D50KkjsR8zrBizkxK9KvE8mKexMiRU5ie2e
         7b4rDNhGVWBQF+mSOseHKscAEpGTbRr/tLiFClXI8VaYH+TAH4O2PPZ/5ff6TptJ0F
         3pcLYDm2WRgtAaJ8WvOqvwLulGAX7Tk2Z5YkjqgXHgzPaoLaOclf9NZD4gJR1wbW32
         RTnNUfUEf4QkGJ4EyIv998PKKQSnxyQqcpKa2ANiAX/X1enqFcC1G4i9a2nnbEPhEJ
         dGcNd6b2wuCzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jordy Zomer <jordy@pwning.systems>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, steffen.klassert@secunet.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 30/39] ipv6: check return value of ipv6_skip_exthdr
Date:   Thu, 25 Nov 2021 21:31:47 -0500
Message-Id: <20211126023156.441292-30-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jordy Zomer <jordy@pwning.systems>

[ Upstream commit 5f9c55c8066bcd93ac25234a02585701fe2e31df ]

The offset value is used in pointer math on skb->data.
Since ipv6_skip_exthdr may return -1 the pointer to uh and th
may not point to the actual udp and tcp headers and potentially
overwrite other stuff. This is why I think this should be checked.

EDIT:  added {}'s, thanks Kees

Signed-off-by: Jordy Zomer <jordy@pwning.systems>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/esp6.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index ed2f061b87685..f0bac6f7ab6bb 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -808,6 +808,12 @@ int esp6_input_done2(struct sk_buff *skb, int err)
 		struct tcphdr *th;
 
 		offset = ipv6_skip_exthdr(skb, offset, &nexthdr, &frag_off);
+
+		if (offset < 0) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		uh = (void *)(skb->data + offset);
 		th = (void *)(skb->data + offset);
 		hdr_len += offset;
-- 
2.33.0

