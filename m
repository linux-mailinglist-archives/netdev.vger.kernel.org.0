Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737471E0647
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 07:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgEYFCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 01:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgEYFCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 01:02:30 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BD5C061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 22:02:30 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id cx22so8139624pjb.1
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 22:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9dHlDCEbXF3961iEPMLjYB2prOXiSlpzYClRwGaOjrc=;
        b=Vsl/I0UG5HiMwVErFtg5cWCCjPLN9Yj3U4UV9+MIMa4Iw6oEeQTRTlbjxE0yxQ4aai
         zp1HMNG6ISlJDOgAPU+ydHLY+mpewVAcTJK+BxrIxORKyqKWzPTaQ0QGldHnrBsw6oVu
         hllFu4msnItz/sApIx8QrXCnKnYninTd5MQ1s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9dHlDCEbXF3961iEPMLjYB2prOXiSlpzYClRwGaOjrc=;
        b=qeI2E6oiJUrD1aj2xKyepz4UjKltW8m/lCWikqedKmLJj5kACWh3bG3CroZGmlUx7M
         aXjJANWtLgUMrjOzabOzutKDSV+FUDJ4dwDEgZ6h2bEfce5e/sY/M/lTyBtkbZBCtMxJ
         4azQ2Z3avF5wCBhzXJQWmpbcU3EZpSpBUa3mSIQYeL0F9ylvYHkuVsZsADYiI91ghjhM
         uEtd+0pxb2KtiQFpVq8bwb4Wu5DGTVHQ5YLv+9Tggs4D31Y+5MQCQ9GaKuCnpI4FyGou
         gZt8lTZcvhtHOtu2g+4UlCvG/SwJDrgs6IFvU2k++NLOaouMJz0ALmURC0z0MmAkWJOv
         103w==
X-Gm-Message-State: AOAM532jyzZpgH6PiGGigeCVGAnMZRxzSj/EKFXhEIXjPz0wG2MGxOFd
        uT646YWje4mtlmzfosuyhX+98vVmZ1U=
X-Google-Smtp-Source: ABdhPJyx3r7CLhScgibBYb+w6jX4rPhtmJk2INDwnJMuau0JedFi+XJLqMwrb1BwpxQW91tX8vJIxA==
X-Received: by 2002:a17:90a:985:: with SMTP id 5mr18058006pjo.23.1590382949657;
        Sun, 24 May 2020 22:02:29 -0700 (PDT)
Received: from f3.synalogic.ca (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id w21sm12740243pfu.47.2020.05.24.22.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2020 22:02:28 -0700 (PDT)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next] net: Avoid spurious rx_dropped increases with tap and rx_handler
Date:   Mon, 25 May 2020 14:01:37 +0900
Message-Id: <20200525050137.412072-1-bpoirier@cumulusnetworks.com>
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
Message-Id: <20200522011420.263574-1-bpoirier@cumulusnetworks.com>
Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 net/core/dev.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index ae37586f6ee8..07957a0f57e6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5061,11 +5061,11 @@ static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
 static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 				    struct packet_type **ppt_prev)
 {
+	bool deliver_exact = false, rx_tapped = false;
 	struct packet_type *ptype, *pt_prev;
 	rx_handler_func_t *rx_handler;
 	struct sk_buff *skb = *pskb;
 	struct net_device *orig_dev;
-	bool deliver_exact = false;
 	int ret = NET_RX_DROP;
 	__be16 type;
 
@@ -5158,12 +5158,14 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
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
@@ -5234,11 +5236,13 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
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

