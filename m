Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 821B9123FD3
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 07:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfLRGz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 01:55:27 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38943 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfLRGz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 01:55:27 -0500
Received: by mail-pf1-f193.google.com with SMTP id q10so674934pfs.6
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 22:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=bzIfo5QToARCZWLeqG3x/wMqUmg7NXaLyDxKE0gqU2E=;
        b=WpiFi+P243pgZwyZZX1fE4hheEMWsNjMJ2xiHkNJvjgWmVYBWKCgtgcAO/AhFJXr1M
         CkgOe4ne7PWJKswPpIIrgUj2B7oNrejXMO3726H1CiDJ7uMbZsTrGrGf+/DNB4yX3mW5
         eZbM35DyLAiYcqEqp5beVXIGjtRKHpkC82aqbXk2kY91vzyesmLNl4o9Z2iac/ahJUly
         Ds1to5xwBiQsy6WzaYHdufG5xh5Kw95Hew0uFmtGud0eZbMLgAQbIqhtdFZGuCnux6eH
         bFHgvUu0UQZVGsQGJiYNhxV52Ejk12Yi4HVlUbdP+/48yR/R3SeHosuwvzkPlQoYnOf+
         GZXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=bzIfo5QToARCZWLeqG3x/wMqUmg7NXaLyDxKE0gqU2E=;
        b=TJce1y3gqa4QoqhMRUplDNMfC3jXWw/KBkv46uIUDNWTC1j/KtTPopaTJOB5iUlFWe
         UXC+AcD2ouHE8RFS61CnKmAgpOLj4UZBz6JwzkJhKWoDLeZ/9yz6gaaPtza4gim8howt
         RAiMc6Y/e3vYzKs03hW/Sw9BIvFIzuWZ6JtDj2bpOt1InyV/3SFPejJqWXemasUMuK2L
         I6W03IwVwndx+0Hc3p46poj16YZQFbGhUd7HnXrvX/fVYJrn4WlqQ1fg0duKS4W+wDMB
         KeBig3AG7SsRSHFzCT6NmzJDtlo0s87IsmDe4knaHPpwNB2TEm8AqxJ16SeJxYqiqXhp
         T7Kg==
X-Gm-Message-State: APjAAAVcEFR5o4VIXPQ3cPkXQaSQRCdOgO35LGKbfwsAJidmC+WIVzTv
        nXoLtv5DtvrvYU8M+Wt7geyOLlDq
X-Google-Smtp-Source: APXvYqzjcUizAzcj4XiqmGBTd60EDhwTT5rN9brGZgQ8vXQSlVVsswIppMOe4PwC6PlfU0Ud73P2NQ==
X-Received: by 2002:a62:4ec6:: with SMTP id c189mr1293397pfb.159.1576652126399;
        Tue, 17 Dec 2019 22:55:26 -0800 (PST)
Received: from localhost.localdomain ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id d24sm1555570pfq.75.2019.12.17.22.55.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 22:55:25 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v4 1/3] net: skb_mpls_push() modified to allow MPLS header push at start of packet.
Date:   Wed, 18 Dec 2019 12:17:50 +0530
Message-Id: <5dbc2dbc222ff778861ef08b4e0a68a49a7afeb1.1576648350.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1576648350.git.martin.varghese@nokia.com>
References: <cover.1576648350.git.martin.varghese@nokia.com>
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

