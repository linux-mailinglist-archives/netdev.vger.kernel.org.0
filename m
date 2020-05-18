Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A891D1D736B
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 11:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgERJCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 05:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgERJCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 05:02:04 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02931C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 02:02:04 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u188so9372886wmu.1
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 02:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=4zXjvJpl0b23SZrLxFlUKMPcKSTCmOioUHlIceNAXFg=;
        b=OShgknf+1jAVVfdSVl6GnKrmLvOqIa0qWHlA+nr0aoYyeDQl/UKdWuRHWjxQaEGDy4
         TPI2oqQ2WHHERhW4ab/1CFxh3X0iXIQ2o2o0cVQL3M/H2tLbRcNu8gnoND/jcVIQ3FSo
         5soSOTM5N/emLcg1pB70MwWgBEXT6HANZzlfU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=4zXjvJpl0b23SZrLxFlUKMPcKSTCmOioUHlIceNAXFg=;
        b=Exas3/C2XbpbIiF6m2D7szrXlYCpxDvkljCmEmWFiCIP0vJb+EC6HFXeKvLCpxS7tf
         e//+44CxoptclBGGDRH0XKuqFZh8p5rJUoW0lQ3uLyjNrkW5Wg8IdZOyAfze6qdQzOoh
         j+3BgUF2tlFCP3YnZ3/Fo/tnR++tJsil9BnPPu6JNqusPjmk+s7R7ii/uBUGfuqSGOhQ
         d/um+ho4GXJqDEY9InFCYm+83Pp8mqBHMtMEA+KhtpHIZDC64kfLioG6ySm2nOlUlvNk
         ARi2Na79ppfhJpXnOZbCQ0Nd+1EUcU8R2pnBm/iOXyCcpGSU2rUNUdqpTYYNRPiQa3be
         QeJA==
X-Gm-Message-State: AOAM531XgtlmTWBC014N7eiI3ejsTo1Sh2vvL+tMoXkBperz2vZajILa
        a5bGn/CPwa9fNLG4mUt0fxQ++VcD2Bt5JR6wnoz5U0ozVHuMqRoUFoM2skKhmpdbLymhnD1kgyu
        h/cy0nf5afIVPprpHyAdeCJNXYntXZt1r1fgrC0/B1qXBzpF/pYNxZvDiRApTOndWC6Olx+dicV
        JjZA==
X-Google-Smtp-Source: ABdhPJwCT3Vtl9L7taL2nNctLv3B8JRo2p5lAcIf2BKFKwKeJ2LvVTwM6ZIFkNHgVuECM9YbpG6iQg==
X-Received: by 2002:a1c:4e0e:: with SMTP id g14mr18245061wmh.0.1589792522236;
        Mon, 18 May 2020 02:02:02 -0700 (PDT)
Received: from noodle ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id 77sm16348041wrc.6.2020.05.18.02.02.01
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 02:02:01 -0700 (PDT)
Date:   Mon, 18 May 2020 12:01:52 +0300
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     netdev@vger.kernel.org
Subject: [PATCH net] __netif_receive_skb_core: pass skb by reference
Message-ID: <20200518090152.GA10405@noodle>
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

Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
---
 net/core/dev.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6d327b7aa813..0c2bbf479f19 100644
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
 
@@ -5174,6 +5177,7 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 	}
 
 out:
+	*pskb = skb;
 	return ret;
 }
 
@@ -5183,7 +5187,7 @@ static int __netif_receive_skb_one_core(struct sk_buff *skb, bool pfmemalloc)
 	struct packet_type *pt_prev = NULL;
 	int ret;
 
-	ret = __netif_receive_skb_core(skb, pfmemalloc, &pt_prev);
+	ret = __netif_receive_skb_core(&skb, pfmemalloc, &pt_prev);
 	if (pt_prev)
 		ret = INDIRECT_CALL_INET(pt_prev->func, ipv6_rcv, ip_rcv, skb,
 					 skb->dev, pt_prev, orig_dev);
@@ -5261,7 +5265,7 @@ static void __netif_receive_skb_list_core(struct list_head *head, bool pfmemallo
 		struct packet_type *pt_prev = NULL;
 
 		skb_list_del_init(skb);
-		__netif_receive_skb_core(skb, pfmemalloc, &pt_prev);
+		__netif_receive_skb_core(&skb, pfmemalloc, &pt_prev);
 		if (!pt_prev)
 			continue;
 		if (pt_curr != pt_prev || od_curr != orig_dev) {
-- 
2.19.2

