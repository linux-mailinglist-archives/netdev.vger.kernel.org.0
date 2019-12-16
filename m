Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA971207DD
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 15:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbfLPODK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 09:03:10 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43538 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727979AbfLPODK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 09:03:10 -0500
Received: by mail-pg1-f195.google.com with SMTP id k197so3749090pga.10
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 06:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=bzIfo5QToARCZWLeqG3x/wMqUmg7NXaLyDxKE0gqU2E=;
        b=ecEMBKX35YsZArRPQ0gjOPR2B1e77K4/6Dar4BMOdWAhHDNCAz88nnZTb8dkMLo2ef
         LNO4tgjXPudTO79f15A4nfrszL0xHDdsIH8ZTUAMLZTQtaav9gip3YJb1QhhCmlO5OE6
         Zwx8MdA0tvZCViitSuiSpNUCupK/RMurwU+uJoqny2a5rSEsZ4EiDNbOVf9iJ6taO5Pu
         PKy2a4agh6frNiidPvVCqmzpxl5SwhHs7Cb9Odrx5avjz12nTtJMET2cKc6s3zw5eDkC
         Pprg8QQRpafEie3UYcvQEbvw6qAp/vOlVShJLCi6jznlmkx60aQwATTj2jhkfaUTHh3D
         /BcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=bzIfo5QToARCZWLeqG3x/wMqUmg7NXaLyDxKE0gqU2E=;
        b=lYwF6HpVWTzjPHvb/jwx/zfKs+jjGaojTMZjEBJ/t+swMolyPtANMQ8j0E2yt9JMGk
         e2EoO7ByBNsK1I5vEo3zpe458GeTHl+3CPJctJRZCTlQ+Fhn1RInTf1zU6PZoSTrj7fx
         nc4AOZtvIvThf4w6d+oA3VW2xAwZfz3QHEKzA/0ru2XV29shBjf+V6dp9RgsaBoRXjid
         joXxa3a+u1iC/C1Z7B6foJOAVvErCbB4xaNvqXyenvOKSWCZa7bgeYVkYa0XStZN/r7Y
         Q0CUTIcX5ek305xbjn35qZqXPpMDB6z207qTgCIKqcLK/gA2qL7910zAFjDMLreAvoei
         RKCg==
X-Gm-Message-State: APjAAAUm/Vf/r7V6fI9USUAsJLdA5raFKYjAEURIsPABktpeD0xVzJ0u
        5s/RaegMYL4m/lnY8VQXotrxnTaW
X-Google-Smtp-Source: APXvYqwtQtx5VoS9RmgiRtDKTQYKU86+tgV4Vt5s0U0a5zlITBxwktrt3iAYP232zT0c/Sl9r+I6vg==
X-Received: by 2002:a63:510e:: with SMTP id f14mr18460738pgb.35.1576504989599;
        Mon, 16 Dec 2019 06:03:09 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id k3sm22777541pgc.3.2019.12.16.06.03.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 16 Dec 2019 06:03:09 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v3 1/3] net: skb_mpls_push() modified to allow MPLS header push at start of packet.
Date:   Mon, 16 Dec 2019 19:32:50 +0530
Message-Id: <5dbc2dbc222ff778861ef08b4e0a68a49a7afeb1.1576488935.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1576488935.git.martin.varghese@nokia.com>
References: <cover.1576488935.git.martin.varghese@nokia.com>
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

