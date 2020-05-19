Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171011D911F
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 09:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgESHct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 03:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgESHcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 03:32:48 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA20C061A0C
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 00:32:48 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id h17so14620676wrc.8
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 00:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=DOyM4FTrdaFQirVapWoENpb4Jxom1X9ujHcN6b9PlLY=;
        b=ORBXGggSkyuYZ3em8fURazxgp362O07FsaygDUyvQtpwEYw0NvOpxSA2lnXnzzpIoh
         cowyGw9br8W7/wm2Lsivtx/9MovDAAWo/DB2tdkFpblVuJMszi3MdQZYHX5aY0g0GiLP
         QBVl1WXSdF8bMwJK7W0zOjLslD7xa/gmbF+CU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=DOyM4FTrdaFQirVapWoENpb4Jxom1X9ujHcN6b9PlLY=;
        b=POa8ekxNYZwHgTmzzSBZDT7IH4D8LH8H87iIjz2twSSdJQ4xHqX64+4hkXxpDfWy9G
         818UNeDLapEZleq57quVXdnYxGukBj1ryAiedQp+csos1jXAg60Jxkusi9WnQyYuhFjC
         RfO6D8pBNWtieYD+4Z1eIW1UBg9ZOo1tF/4YGjQiL2YWcKi4PlaHc/2aT8N2yvIbroUp
         5AwtdWxh/Sg5pI1PcfPeq6URH2ab5H9G6AiSkx9DZ+sa5B/naVONvzuR60H1cy7Me9i1
         JINDhVsjYg3tad7eDxkxeARq1mSK7ulIxS1DmZSiDTPhsN5z/fkdktVca3XrcIGeFgB3
         tf1Q==
X-Gm-Message-State: AOAM533INSBA6C40wda0Io4awHZ+xr+0srdLHsS2acqlgTPeEh8rIA/r
        oh6ZKToVH7kE3X4KZD8RTCg+CwHc4sMsEPcUiFHXvduSgew/gNtJmaf3syGmr2bGCjyqPjT3Xg8
        yiTellcORHhrU/PyNKTvwT74bcQaNTYApQssfP2qm3BYHLBtZda8TSykGNCJyS39KXjfaRpqArd
        W7bw==
X-Google-Smtp-Source: ABdhPJzGmTY9atK5RLZq+kx1o96kX7HELv/+YbvE/f6LjizxuiTh6mO1sErJMgG4YPCC8yoynaxLtA==
X-Received: by 2002:a5d:6a01:: with SMTP id m1mr25317034wru.64.1589873566351;
        Tue, 19 May 2020 00:32:46 -0700 (PDT)
Received: from noodle ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id f128sm3017587wme.1.2020.05.19.00.32.45
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 May 2020 00:32:45 -0700 (PDT)
Date:   Tue, 19 May 2020 10:32:37 +0300
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     netdev@vger.kernel.org
Subject: [PATCH net v2] __netif_receive_skb_core: pass skb by reference
Message-ID: <20200519073229.GA20624@noodle>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__netif_receive_skb_core may change the skb pointer passed into it (e.g.
in rx_handler). The original skb may be freed as a result of this
operation.

The callers of __netif_receive_skb_core may further process original skb
by using pt_prev pointer returned by __netif_receive_skb_core thus
leading to unpleasant effects.

The solution is to pass skb by reference into __netif_receive_skb_core.

v2: Added Fixes tag and comment regarding ppt_prev and skb invariant.

Fixes: 88eb1944e18c ("net: core: propagate SKB lists through packet_type lookup")
Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
---
 net/core/dev.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6d327b7aa813..38adb56624f7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4988,7 +4988,7 @@ static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
 	return 0;
 }
 
-static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
+static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 				    struct packet_type **ppt_prev)
 {
 	struct packet_type *ptype, *pt_prev;
@@ -4997,6 +4997,7 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 	bool deliver_exact = false;
 	int ret = NET_RX_DROP;
 	__be16 type;
+	struct sk_buff *skb = *pskb;
 
 	net_timestamp_check(!netdev_tstamp_prequeue, skb);
 
@@ -5023,8 +5024,10 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 		ret2 = do_xdp_generic(rcu_dereference(skb->dev->xdp_prog), skb);
 		preempt_enable();
 
-		if (ret2 != XDP_PASS)
-			return NET_RX_DROP;
+		if (ret2 != XDP_PASS) {
+			ret = NET_RX_DROP;
+			goto out;
+		}
 		skb_reset_mac_len(skb);
 	}
 
@@ -5174,6 +5177,13 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 	}
 
 out:
+	/* The invariant here is that if *ppt_prev is not NULL
+	 * then skb should also be non-NULL.
+	 *
+	 * Apparently *ppt_prev assignment above holds this invariant due to
+	 * skb dereferencing near it.
+	 */
+	*pskb = skb;
 	return ret;
 }
 
@@ -5183,7 +5193,7 @@ static int __netif_receive_skb_one_core(struct sk_buff *skb, bool pfmemalloc)
 	struct packet_type *pt_prev = NULL;
 	int ret;
 
-	ret = __netif_receive_skb_core(skb, pfmemalloc, &pt_prev);
+	ret = __netif_receive_skb_core(&skb, pfmemalloc, &pt_prev);
 	if (pt_prev)
 		ret = INDIRECT_CALL_INET(pt_prev->func, ipv6_rcv, ip_rcv, skb,
 					 skb->dev, pt_prev, orig_dev);
@@ -5261,7 +5271,7 @@ static void __netif_receive_skb_list_core(struct list_head *head, bool pfmemallo
 		struct packet_type *pt_prev = NULL;
 
 		skb_list_del_init(skb);
-		__netif_receive_skb_core(skb, pfmemalloc, &pt_prev);
+		__netif_receive_skb_core(&skb, pfmemalloc, &pt_prev);
 		if (!pt_prev)
 			continue;
 		if (pt_curr != pt_prev || od_curr != orig_dev) {
-- 
2.19.2

