Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8F246CCE
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbfFNXWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:22:46 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:47577 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFNXWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:22:46 -0400
Received: by mail-vs1-f74.google.com with SMTP id d139so1416733vsc.14
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 16:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3AvYIhNUVV/zrmA+EWxMeG1iXs6fMdL2NtjhLatsIo4=;
        b=bGMmSpjK8ASbkUhelaXtagNphIxAYdqSq0QgnmZwh+78nuaeHuNxFK42UnrYPGrDBX
         gf96xEy1YdVzSFn9wu/nokCvaKgJ0xOuMnVb5ICSOG60RLN2guRxOh2mLmP/IOtWKfiG
         CcPG7icyiz0geZx9Xv56AvP8vjg+gOUj3AIBSR9eVJxrqHTPHw+Q+U2Q7FHcnwVWjkUr
         z7qbz4nJUzGS0GFX7XZnGYTbW0BWVxYVE6p/LN8Qb4GaAWqlaYGYfQpmGkFmS6Twk7D8
         NsnfxwZWh26R/ejDTY9Jfv+YOb527WdOw89eahCzIFZ7OXE5vbWkj3id9twpDBYb7IZu
         jyHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3AvYIhNUVV/zrmA+EWxMeG1iXs6fMdL2NtjhLatsIo4=;
        b=XBVQz+xaTTn0fIp+wqsN2bJhyDM2hJthp0oNPGIEmeZfTlcTNq9TBpc0Auuh1BC4wu
         w2dK/cAAvMVW/DThoA1o9Ei9JxobUJr6euu2F3AQ4DAQVXX7MO2tuPbk5Wq5R83AwakX
         aCPGAJlKBfgQdx2x7hBOFRvCIHkxALuERDhCI2gucaHj0jqnLLYCXdG5cVCc276sfaY4
         fVZFzlrOF91KdCaXvfbHGWGHfqROxo4ddtID13MGGlCFYc1sHUEZTDJDT4a5aT1ZRnUS
         nJ9Xjtm/ywMzMfI8uvVXwN6IxPHM7B8WLLc8SS5UwrDs5yXCk8ePGabIG8xRC+KK8gko
         fCCg==
X-Gm-Message-State: APjAAAViGr1Awu+OnpszBmpQ91OXReGRLlXrwHpiIy4KiltRxVZBKM/6
        aH85NpzUEV29Ixm2eu490c4z5Iy+lZbdaQ==
X-Google-Smtp-Source: APXvYqzDI+ooWCNjvckMoHpoI2Xl+MsunICyVHuGVEpVknK2vk5uDpHiUzcDwhKYOT2fUVwfzRB63BpKx1+MRg==
X-Received: by 2002:ab0:30c7:: with SMTP id c7mr1608064uam.143.1560554564985;
 Fri, 14 Jun 2019 16:22:44 -0700 (PDT)
Date:   Fri, 14 Jun 2019 16:22:21 -0700
In-Reply-To: <20190614232221.248392-1-edumazet@google.com>
Message-Id: <20190614232221.248392-5-edumazet@google.com>
Mime-Version: 1.0
References: <20190614232221.248392-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net 4/4] net: add high_order_alloc_disable sysctl/static key
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From linux-3.7, (commit 5640f7685831 "net: use a per task frag
allocator") TCP sendmsg() has preferred using order-3 allocations.

While it gives good results for most cases, we had reports
that heavy uses of TCP over loopback were hitting a spinlock
contention in page allocations/freeing.

This commits adds a sysctl so that admins can opt-in
for order-0 allocations. Hopefully mm layer might optimize
order-3 allocations in the future since it could give us
a nice boost  (see 8 lines of following benchmark)

The following benchmark shows a win when more than 8 TCP_STREAM
threads are running (56 x86 cores server in my tests)

for thr in {1..30}
do
 sysctl -wq net.core.high_order_alloc_disable=0
 T0=`./super_netperf $thr -H 127.0.0.1 -l 15`
 sysctl -wq net.core.high_order_alloc_disable=1
 T1=`./super_netperf $thr -H 127.0.0.1 -l 15`
 echo $thr:$T0:$T1
done

1: 49979: 37267
2: 98745: 76286
3: 141088: 110051
4: 177414: 144772
5: 197587: 173563
6: 215377: 208448
7: 241061: 234087
8: 267155: 263373
9: 295069: 297402
10: 312393: 335213
11: 340462: 368778
12: 371366: 403954
13: 412344: 443713
14: 426617: 473580
15: 474418: 507861
16: 503261: 538539
17: 522331: 563096
18: 532409: 567084
19: 550824: 605240
20: 525493: 641988
21: 564574: 665843
22: 567349: 690868
23: 583846: 710917
24: 588715: 736306
25: 603212: 763494
26: 604083: 792654
27: 602241: 796450
28: 604291: 797993
29: 611610: 833249
30: 577356: 841062

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/sock.h         | 2 ++
 net/core/sock.c            | 4 +++-
 net/core/sysctl_net_core.c | 7 +++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 7d7f4ce63bb2aae7c87a9445d11339b6e6b19724..6cbc16136357d158cf1e84b98ecb7e06898269a6 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2534,6 +2534,8 @@ extern int sysctl_optmem_max;
 extern __u32 sysctl_wmem_default;
 extern __u32 sysctl_rmem_default;
 
+DECLARE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
+
 static inline int sk_get_wmem0(const struct sock *sk, const struct proto *proto)
 {
 	/* Does this proto have per netns sysctl_wmem ? */
diff --git a/net/core/sock.c b/net/core/sock.c
index 2b3701958486219a26385c8fca1498c4e294dc1d..7f49392579a5826b0a8446bb88428396422cc0b6 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2320,6 +2320,7 @@ static void sk_leave_memory_pressure(struct sock *sk)
 
 /* On 32bit arches, an skb frag is limited to 2^15 */
 #define SKB_FRAG_PAGE_ORDER	get_order(32768)
+DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
 
 /**
  * skb_page_frag_refill - check that a page_frag contains enough room
@@ -2344,7 +2345,8 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
 	}
 
 	pfrag->offset = 0;
-	if (SKB_FRAG_PAGE_ORDER) {
+	if (SKB_FRAG_PAGE_ORDER &&
+	    !static_branch_unlikely(&net_high_order_alloc_disable_key)) {
 		/* Avoid direct reclaim but allow kswapd to wake */
 		pfrag->page = alloc_pages((gfp & ~__GFP_DIRECT_RECLAIM) |
 					  __GFP_COMP | __GFP_NOWARN |
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 1a2685694abd537d7ae304754b84b237928fd298..f9204719aeeeb4700582d03fda244f2f8961f8a7 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -562,6 +562,13 @@ static struct ctl_table net_core_table[] = {
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
+	{
+		.procname	= "high_order_alloc_disable",
+		.data		= &net_high_order_alloc_disable_key.key,
+		.maxlen         = sizeof(net_high_order_alloc_disable_key),
+		.mode		= 0644,
+		.proc_handler	= proc_do_static_key,
+	},
 	{ }
 };
 
-- 
2.22.0.410.gd8fdbe21b5-goog

