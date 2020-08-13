Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929CB24398B
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 14:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgHMMAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 08:00:43 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33922 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726570AbgHML7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Aug 2020 07:59:19 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 43880746B97B89570544;
        Thu, 13 Aug 2020 19:59:10 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Thu, 13 Aug 2020
 19:59:04 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: correct zerocopy refcnt with newly allocated UDP or RAW uarg
Date:   Thu, 13 Aug 2020 07:58:00 -0400
Message-ID: <20200813115800.4546-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The var extra_uref is introduced to pass the initial reference taken in
sock_zerocopy_alloc to the first generated skb. But now we may fail to pass
the initial reference with newly allocated UDP or RAW uarg when the skb is
zcopied.

If the skb is zcopied, we always set extra_uref to false. This is fine with
reallocted uarg because no extra ref is taken by UDP and RAW zerocopy. But
if uarg is newly allocated via sock_zerocopy_alloc(), we lost the initial
reference because extra_uref is false and we missed to pass it to the first
generated skb.

To fix this, we should set extra_uref to true if UDP or RAW uarg is newly
allocated when the skb is zcopied.

Fixes: 522924b58308 ("net: correct udp zerocopy refcnt also when zerocopy only on append")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/ipv4/ip_output.c  | 4 +++-
 net/ipv6/ip6_output.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 61f802d5350c..78d3b5d48617 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1019,7 +1019,9 @@ static int __ip_append_data(struct sock *sk,
 		uarg = sock_zerocopy_realloc(sk, length, skb_zcopy(skb));
 		if (!uarg)
 			return -ENOBUFS;
-		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
+		/* Only ref on newly allocated uarg. */
+		if (!skb_zcopy(skb) || (sk->sk_type != SOCK_STREAM && skb_zcopy(skb) != uarg))
+			extra_uref = true;
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index c78e67d7747f..0f82923239a9 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1476,7 +1476,9 @@ static int __ip6_append_data(struct sock *sk,
 		uarg = sock_zerocopy_realloc(sk, length, skb_zcopy(skb));
 		if (!uarg)
 			return -ENOBUFS;
-		extra_uref = !skb_zcopy(skb);	/* only ref on new uarg */
+		/* Only ref on newly allocated uarg. */
+		if (!skb_zcopy(skb) || (sk->sk_type != SOCK_STREAM && skb_zcopy(skb) != uarg))
+			extra_uref = true;
 		if (rt->dst.dev->features & NETIF_F_SG &&
 		    csummode == CHECKSUM_PARTIAL) {
 			paged = true;
-- 
2.19.1

