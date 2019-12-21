Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 111FA1286BB
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 04:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfLUDVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 22:21:00 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:35753 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbfLUDVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 22:21:00 -0500
Received: by mail-pj1-f68.google.com with SMTP id s7so4977030pjc.0
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 19:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=bzIfo5QToARCZWLeqG3x/wMqUmg7NXaLyDxKE0gqU2E=;
        b=pZlgGOgcByJE+H6g8DXuk7ZqU0Au8b68v4dDmLt9WZLM0/v8W3d+HMKboiaNSVSJgC
         uqB5HcqzP5qH2brEXwvr+okmTbXIvrUVSdIzikcJ9u22BiPTlCMW8JFPYRpwYjloAdz+
         Vf6GgaasBcSp3Z5iCX4ccK/Hs/1AAmw6UQyCBPGiyyocbe4M/m9ERFMAUnCI1IXLnsQs
         BHuVktV5NCcGtz93C38elAoJbbNs88q/V+ypmzwVI6MhxUnCqIrCZU0I4ZuFP7RMVCPl
         Lc4EOsWZguMd0AVFFVShyuGvYBMrhxMk/5R+FYxaRSE8fuyHxNpmFPODxZZFapB9yIZK
         HDCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=bzIfo5QToARCZWLeqG3x/wMqUmg7NXaLyDxKE0gqU2E=;
        b=IUpicgHjMDlpk8+lbHFxoAkE4JxLYM54mtBuIcKooEN5kinHLqx2LBMcA7Ob2bdYPD
         AXbumSeptKbEmBdHA10SGH0PJtHYc5cUg5jXK2s8tg9A4ZQ/FD2Y6rCBsRjM++B2irDP
         Ah4Dsn00862eNmjvowz0q+pMMA2Tu4H2DnrHHRigpAbIsN4eshkMBn8oSUDGwDKDLkNB
         BlXi4tGCmcjW1B+I4gVM6xoBTRv5jbhH3N+2izmKblkIOjWsM6uaXXovDtJsTtSRWgZz
         i1CGf3g7w53s7eHsDkKaolhkDrkXTtf4DXWu/T9ogIcT0lXleHYZxRdDJleRZnwjQEW6
         R59w==
X-Gm-Message-State: APjAAAXP4AFU64VyqyNFNEtTu/gLUmtUlwGs8HXbkWF9M4Z1HDPFmPrN
        /thHteR/TqOrM5Tb9kQq+ecz5LtN
X-Google-Smtp-Source: APXvYqwE8Bb0xW7Cjq3rZpYo1eNCKHuvCW22VtrTXX+dJBp3AoqiXADo2EzKRJHrI5ZpJbPzV72+AQ==
X-Received: by 2002:a17:90a:cb8c:: with SMTP id a12mr20392640pju.71.1576898459589;
        Fri, 20 Dec 2019 19:20:59 -0800 (PST)
Received: from localhost.localdomain ([42.109.147.248])
        by smtp.gmail.com with ESMTPSA id w6sm15639951pfq.99.2019.12.20.19.20.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 19:20:59 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v5 1/3] net: skb_mpls_push() modified to allow MPLS header push at start of packet.
Date:   Sat, 21 Dec 2019 08:50:01 +0530
Message-Id: <5dbc2dbc222ff778861ef08b4e0a68a49a7afeb1.1576896417.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1576896417.git.martin.varghese@nokia.com>
References: <cover.1576896417.git.martin.varghese@nokia.com>
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
Changes in v2:
    - Fixed comments section of skb_mpls_push().
    - Added skb_reset_mac_len() in skb_mpls_push(). The mac len changes
      when MPLS header in inserted at the start of the packet.

 net/core/skbuff.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 973a71f..d90c827 100644
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
+ * @ethernet: flag to indicate if the resulting packet after skb_mpls_push is
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
 
@@ -5510,6 +5513,7 @@ int skb_mpls_push(struct sk_buff *skb, __be32 mpls_lse, __be16 mpls_proto,
 		mac_len);
 	skb_reset_mac_header(skb);
 	skb_set_network_header(skb, mac_len);
+	skb_reset_mac_len(skb);
 
 	lse = mpls_hdr(skb);
 	lse->label_stack_entry = mpls_lse;
-- 
1.8.3.1

