Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E901DDC7B
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 03:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgEVBOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 21:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgEVBOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 21:14:45 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EC0C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 18:14:43 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x2so4388500pfx.7
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 18:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ni3o2vG1ZC0dmLVUL4q+EY3s87shgAr9vJGvajxDUsk=;
        b=RsrVfuYAtnA2DEcA2IfHgPMHXqjiN3FxmPqOYo4VpjLjlX+uQhgj9Y+bAJGT7X7k3S
         Ku3i1etIVVpwYDqXEVYWb8invxvEOczCfovnx0uKAay6bKWVf3ocBBlOFXX6AXdLAe5G
         ndjJbLdw6Wj4McKOfbIIgdaUBar9VwK+D2r5g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ni3o2vG1ZC0dmLVUL4q+EY3s87shgAr9vJGvajxDUsk=;
        b=MhPoJxwWqmZjZoqVYkiB5VS7o+h71H5vaFRtibq/QX4wcu1CE8Ahu7KfzeZLazN05E
         oE/4a1NuP7kpiMkSbzPDwvBesXZVBoykYX+qW1e5NzUiqx1ITs2fbkFA5LgyZP/yoaNz
         pSxhAfV4JPv1xawEBKe6s6RdeWRjHBsE3Gfq6IHXN20oMYdUPIAa+HLtJFg0on/n3Xqr
         xzlQexDZO6vQRkivdIrzTt5jXPaau/hWuvpkxFBaehDKoQHyN78O2e+lawnuzuAoruCy
         HIEAGz+70AmkDVeb0A4JX1c1wvNzKO2K/6PXM0n1QwDMSxSQcx/q3G7541B/YUd7pS7N
         OPRA==
X-Gm-Message-State: AOAM531Bc6UtNLDLUBYb8V5FuQU8JytTrrQ5imf07iJhY7UcvoNIUg6i
        Wl1YXn/20KNkVmZ5ir21s/0Iq8EzlEU=
X-Google-Smtp-Source: ABdhPJydNkRkGSsVnQ+2UAQ6EfhmXjnZWlxQIr3lEBYArPTCkPOASASTSKWDJiTkCm2Lz84mXwl6xg==
X-Received: by 2002:a63:7a5e:: with SMTP id j30mr11608802pgn.5.1590110083085;
        Thu, 21 May 2020 18:14:43 -0700 (PDT)
Received: from f3.synalogic.ca (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id b24sm5292293pfi.4.2020.05.21.18.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 18:14:42 -0700 (PDT)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH RFC] net: Avoid spurious rx_dropped increases with tap and rx_handler
Date:   Fri, 22 May 2020 10:14:20 +0900
Message-Id: <20200522011420.263574-1-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consider an skb which doesn't match a ptype_base/ptype_specific handler. If
this skb is delivered to a ptype_all handler, it does not count as a drop.
However, if the skb is also processed by an rx_handler which returns
RX_HANDLER_PASS, the frame is now counted as a drop because pt_prev was
reset. An example of this situation is an LLDP frame received on a bridge
port while lldpd is listening on a packet socket with ETH_P_ALL (ex. by
specifying `lldpd -c`).

Fix by adding an extra condition variable to record if the skb was
delivered to a packet tap before running an rx_handler.

The situation is similar for RX_HANDLER_EXACT frames so their accounting is
also changed. OTOH, the behavior is unchanged for RX_HANDLER_ANOTHER frames
- they are accounted according to what happens with the new skb->dev.

Fixes: caf586e5f23c ("net: add a core netdev->rx_dropped counter")
Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---

The main problem (described above) involves RX_HANDLER_PASS and I think
it's clear that it needs fixing but I'm wondering if there are different
views on what the behavior should be in related cases.

For RX_HANDLER_ANOTHER,
Considering an example with bonding, currently, with a similar use case
as described for the bridge, an LLDP frame received on a bond slave is
counted as rx_dropped on the bond master, even if it was delivered to a
ptype_all tap bound to the slave. That seems a bit iffy to me but kind of
fair because it's counted as a drop _on the master_.

For RX_HANDLER_EXACT,
Also considering an example with bonding, currently, a unicast frame
received on a backup bond slave is counted as rx_nohandler on the slave,
even if it was delivered to a ptype_all tap. I'd say that's not correct
so the patch is changing that too.


Also, it looks to me like a better fix for these issues would be for
rx_handlers to avoid spuriously unsharing skbs in cases where they are not
trying to enqueue them (cf. commit 7b995651e373 "[BRIDGE]: Unshare skb upon
entry") and to return something like a pt_prev func in other cases so that
copies can be deferred. That looks like quite a bit more work though.


 net/core/dev.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f36bd3b21997..13ff1933e791 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5061,10 +5061,10 @@ static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
 static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 				    struct packet_type **ppt_prev)
 {
+	bool deliver_exact = false, rx_tapped = false;
 	struct packet_type *ptype, *pt_prev;
 	rx_handler_func_t *rx_handler;
 	struct net_device *orig_dev;
-	bool deliver_exact = false;
 	int ret = NET_RX_DROP;
 	__be16 type;
 
@@ -5155,12 +5155,14 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 		if (pt_prev) {
 			ret = deliver_skb(skb, pt_prev, orig_dev);
 			pt_prev = NULL;
+			rx_tapped = true;
 		}
 		switch (rx_handler(&skb)) {
 		case RX_HANDLER_CONSUMED:
 			ret = NET_RX_SUCCESS;
 			goto out;
 		case RX_HANDLER_ANOTHER:
+			rx_tapped = false;
 			goto another_round;
 		case RX_HANDLER_EXACT:
 			deliver_exact = true;
@@ -5231,11 +5233,13 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 			goto drop;
 		*ppt_prev = pt_prev;
 	} else {
+		if (!rx_tapped) {
 drop:
-		if (!deliver_exact)
-			atomic_long_inc(&skb->dev->rx_dropped);
-		else
-			atomic_long_inc(&skb->dev->rx_nohandler);
+			if (!deliver_exact)
+				atomic_long_inc(&skb->dev->rx_dropped);
+			else
+				atomic_long_inc(&skb->dev->rx_nohandler);
+		}
 		kfree_skb(skb);
 		/* Jamal, now you will not able to escape explaining
 		 * me how you were going to use this. :-)
-- 
2.26.2

