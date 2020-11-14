Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042D32B3176
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 00:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgKNXqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 18:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgKNXqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 18:46:21 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D44B1C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 15:46:20 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id 142so1764257ljj.10
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 15:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=UAL3bcW2s4IdTET63HT7Zd8Pu5gebYj+0H6Ev3H0rXQ=;
        b=I1cxKmymFvIvvvrLAD5+6n2fkpwHW+yMLqpTBMEhLRnfL7f2/+XKY3I3fXlpG4rq68
         dLBWIGi9/BZliTIeQ/vB4iRIipKdO6UkQvoNsalK1ORDVV+HXgFT35NUco3R0Myr2Hsg
         SUmFSpKhgBEpP2oOE6unIR5QDa303Lr/p0jgH6hpOP5m2wR97jAMUBRLK+R2SKQ27zNn
         22quvwO7YGraG5FA69YdFAIv9spRVYcHXxwPJbFFgfjcq50O41j44cs/uE+RFdrJKl1S
         UnMwzPxX+0NodKxjPaLZAeLyxzGvO3lNjMqY+ROoBMxNJOYmfT03sliUe1QgrxNN90I7
         oWxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=UAL3bcW2s4IdTET63HT7Zd8Pu5gebYj+0H6Ev3H0rXQ=;
        b=P43uKFcIJkMgZCOx1uEYEsJbs3MGe6ZO3raTrVWQJIMzSKX9dGqcYK2nTDzAM434fd
         3XgUfP6prtmdogr3JCRbQh83KNb3oDEf4vbzfN9KrU67XUEBqoBI8WTO16rgs+qDOKsi
         oabpJJ2cQTGl6crda2CQW6x34uM+wD9kKRyBtj61WBdIt7XhjZ8KXLmf7Y3UgK7Ukhjk
         Vgs264+lZhxTqjTenybpByzMZzUobnOd20j3jrut/Sjdi6PQqhXbVIKmX4LOs/AJ09v/
         nl/a+8xwBNdF79uksfyiDUCmwPbRslPMwNSs5Cl6v5NDfd0Dsaf6BoSA0gotS90/85EJ
         vRSw==
X-Gm-Message-State: AOAM532ug3OOe1kNRIchLXDEevo4zElkP47VJv9qMgEbZXs9L+j5rpn/
        ebWjFpl+NU+G3FtXNanQ52b3QA==
X-Google-Smtp-Source: ABdhPJwD60DWLUiEy5UCKOKHyHQ8YkGMiLgrjAlMP/2+zrJvzI6W6kJwWZfml1uet7SnN6l18/d5TA==
X-Received: by 2002:a2e:b8d4:: with SMTP id s20mr3721097ljp.226.1605397578648;
        Sat, 14 Nov 2020 15:46:18 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id g3sm2112157lfd.209.2020.11.14.15.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 15:46:18 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 1/3] net: dsa: tag_dsa: Allow forwarding of redirected IGMP traffic
Date:   Sun, 15 Nov 2020 00:45:56 +0100
Message-Id: <20201114234558.31203-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201114234558.31203-1-tobias@waldekranz.com>
References: <20201114234558.31203-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When receiving an IGMP/MLD frame with a TO_CPU tag, the switch has not
performed any forwarding of it. This means that we should not set the
offload_fwd_mark on the skb, in case a software bridge wants it
forwarded.

This is a port of:

1ed9ec9b08ad ("dsa: Allow forwarding of redirected IGMP traffic")

Which corrected the issue for chips using EDSA tags, but not for those
using regular DSA tags.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/tag_dsa.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 63d690a0fca6..af340a4945dc 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -12,6 +12,11 @@
 
 #define DSA_HLEN	4
 
+#define FRAME_TYPE_TO_CPU	0x00
+#define FRAME_TYPE_FORWARD	0x03
+
+#define TO_CPU_CODE_IGMP_MLD_TRAP	0x02
+
 static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -61,6 +66,8 @@ static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
 	u8 *dsa_header;
 	int source_device;
 	int source_port;
+	int frame_type;
+	int code;
 
 	if (unlikely(!pskb_may_pull(skb, DSA_HLEN)))
 		return NULL;
@@ -73,8 +80,29 @@ static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
 	/*
 	 * Check that frame type is either TO_CPU or FORWARD.
 	 */
-	if ((dsa_header[0] & 0xc0) != 0x00 && (dsa_header[0] & 0xc0) != 0xc0)
+	frame_type = dsa_header[0] >> 6;
+
+	switch (frame_type) {
+	case FRAME_TYPE_TO_CPU:
+		code = (dsa_header[1] & 0x6) | ((dsa_header[2] >> 4) & 1);
+
+		/*
+		 * Mark the frame to never egress on any port of the same switch
+		 * unless it's a trapped IGMP/MLD packet, in which case the
+		 * bridge might want to forward it.
+		 */
+		if (code != TO_CPU_CODE_IGMP_MLD_TRAP)
+			skb->offload_fwd_mark = 1;
+
+		break;
+
+	case FRAME_TYPE_FORWARD:
+		skb->offload_fwd_mark = 1;
+		break;
+
+	default:
 		return NULL;
+	}
 
 	/*
 	 * Determine source device and port.
@@ -132,8 +160,6 @@ static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev,
 			2 * ETH_ALEN);
 	}
 
-	skb->offload_fwd_mark = 1;
-
 	return skb;
 }
 
-- 
2.17.1

