Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0E461181FF
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 09:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfLJIQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 03:16:33 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37140 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfLJIQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 03:16:33 -0500
Received: by mail-pj1-f67.google.com with SMTP id ep17so7094671pjb.4
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 00:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=tRyQF0AimEpmHeM0niHHqBhGZ9fxbZ7s+UOuTQPf/CQ=;
        b=R3gll97hwzWSi03Wm/Xlt90jQ5j5bxyrscxHdNgq5QJ458mksQmC1pKUq7HSbl9C5x
         1RmABqqwO+214MLdzpsnGaGCR0jFFqOe0aPO3MR/DZkpMYZ0j8c8HcQkbcNcRO5YsQuU
         BhcZBJrICINiqz3r8YmZjZgqnXe1kyv0omTXOdCZGnB++2TRRndtYYEgPEPV+jcKiumH
         00m4oBIwhq4608m5HnYPRRGvlM+hZ7m5U9M1EIBEnbTkBTC5cm22RWPf7jqO2w5eZMRZ
         PsAfOV7UurES7oifR0HFIeqHJevfPr8fEkfEGxTanVQyf+Pj6nob/p00tqePGkK4Fmoc
         dtrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=tRyQF0AimEpmHeM0niHHqBhGZ9fxbZ7s+UOuTQPf/CQ=;
        b=OJ7ynoR96YLdB4WkiHG7VRXhAC0he2gUAWrXBA8wQKr0T2urTl8u9ZCnzWtVSAHjW1
         eKbaBig/fS0jxf9msMXJeBg2cvg8ZpnMmVMNSwZAK2UZEuVsp6Mp6y4fiaEt1CHrcmqb
         MXdFYvtnexZBVLE4nkzXOqIqtv3grSbSzP7UOXjchOIHYTwXzuy/ih0lNdlOVWboZD7L
         ax2tJ0RFoBElJaxhxFTrLeI1JcP9MFwfl1KegES0z7MHswNPPewDtrQdPCqCT46s9lBC
         iRdijCw8CSP5h0V0tnQqTTfhD5ZVpxY6aHDNQaJ2tlxr8vaipoIfQ3nKEoEZNl7MzxQf
         R/qg==
X-Gm-Message-State: APjAAAXjrNIYjWsh6C5ZgYl/kYU8Mm/Z+S0pVkUsyrNk/0G3xGF63rI6
        K387iyBrmfgxDMOh1aD9G1mSWuka
X-Google-Smtp-Source: APXvYqyU0JgfTerATTuGSHYgUiDASkk0SwGQmPzWk5vuMoL2Tn03A39lcPxlUp/JqPz+s+SxF+AX7w==
X-Received: by 2002:a17:902:d905:: with SMTP id c5mr34562308plz.60.1575965792905;
        Tue, 10 Dec 2019 00:16:32 -0800 (PST)
Received: from martin-VirtualBox.in.alcatel-lucent.com ([1.39.147.184])
        by smtp.gmail.com with ESMTPSA id e10sm2319797pfm.3.2019.12.10.00.16.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Dec 2019 00:16:32 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next 1/3] net: skb_mpls_push() modified to allow MPLS header push at start of packet.
Date:   Tue, 10 Dec 2019 13:45:52 +0530
Message-Id: <8ff8206cc062f1755292b26a32421a66eeb17ce7.1575964218.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1575964218.git.martin.varghese@nokia.com>
References: <cover.1575964218.git.martin.varghese@nokia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

The existing skb_mpls_push() implementation always inserts mpls header
after the mac header. L2 VPN use cases requires MPLS header to be
inserted before the ethernet header as the ethernet packet gets tunnelled
inside MPLS header in those cases.

Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
 net/core/skbuff.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 973a71f..7773176 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5472,12 +5472,15 @@ static void skb_mod_eth_type(struct sk_buff *skb, struct ethhdr *hdr,
 }
 
 /**
- * skb_mpls_push() - push a new MPLS header after the mac header
+ * skb_mpls_push() - push a new MPLS header after mac_len bytes from start of
+ *                   the packet
  *
  * @skb: buffer
  * @mpls_lse: MPLS label stack entry to push
  * @mpls_proto: ethertype of the new MPLS header (expects 0x8847 or 0x8848)
  * @mac_len: length of the MAC header
+ * #ethernet: flag to indicate if the resulting packet after skb_mpls_push is
+ *            ethernet
  *
  * Expects skb->data at mac header.
  *
@@ -5501,7 +5504,7 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
 		return err;
 
 	if (!skb->inner_protocol) {
-		skb_set_inner_network_header(skb, mac_len);
+		skb_set_inner_network_header(skb, skb_network_offset(skb));
 		skb_set_inner_protocol(skb, skb->protocol);
 	}
 
-- 
1.8.3.1

