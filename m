Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40EFF11CFE7
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 15:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729755AbfLLOef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 09:34:35 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32845 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729732AbfLLOee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 09:34:34 -0500
Received: by mail-pf1-f193.google.com with SMTP id y206so863963pfb.0
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 06:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=bzIfo5QToARCZWLeqG3x/wMqUmg7NXaLyDxKE0gqU2E=;
        b=VwwbhCnMKjrkX0rSDf4zth6X6KeM3aDp3In1VIxvguObhnvih6HoCr92XASAZaME1x
         3jHOCcBkSCmiXku6CClRAJSoNrnuT1TfAHT5616k0tOl5q9Fy90lin6NX2007hbh0kHE
         A2h9PDxQ4aLfUnkItadB9jiDwbG5oOor22Oto8Sh4F2zqeWwMvkQ1H8QhitPSkvg3IpN
         fQr+VkY08CeZ5MV1df3jK77q5Ddv5pc62H1RhY5D73dktRqBgDPWVACtljVNFUXd8JAz
         ZJGHUV/5Q0ZeH/ysdQaqgVMGZ/8elQLfpAVggG+iB/fmyUiZSY8FhmrguKbn6GMKmSFe
         0HrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=bzIfo5QToARCZWLeqG3x/wMqUmg7NXaLyDxKE0gqU2E=;
        b=F9tvk7ijS6K5FKx7m1A+Kk9BoctAPLJoppoLOZaHOq/g1NJb0MpQkkZQFNihf7Ffct
         RW7kaxqGNYx5LamQmch0rm755U+5YVtZCkMTE666/UaKfsNs0ANcyt44hQnWp8wDgXHu
         wyDJ0Zqc2MYnzzW1Cb+JUbxG6PPDVVQ/JSBSYEq7l52Jmoj/8+HXgJDjZAJOmod45BAi
         ve0Ye78h26P5kI3LvvgtNkMDQnTvLUFeilToUnW7pM6uk7/Xqthd6h4d4LyHYtQzFPQG
         aDQ2gRe6Cq+5AwfI7s26v7f2Hztt0CRKqnmAr4DIU/BJwSAN1MonJJ3syzyGLaWDnznU
         rzpQ==
X-Gm-Message-State: APjAAAUjSasfmWlp1rURThn3T3a+5ruV9QMgJ9wH3vcDaONsO87A/8By
        idvGvRh7HU6XXq97hFy43Gw6hHS+
X-Google-Smtp-Source: APXvYqyu/6YSf/eUPXGZkv3H75n80k279XguW3EG1b/Md8tXNF9e5NgZUKrpKu1DldiJ0E7Jmf9a8g==
X-Received: by 2002:a63:4664:: with SMTP id v36mr10545724pgk.147.1576161273822;
        Thu, 12 Dec 2019 06:34:33 -0800 (PST)
Received: from martin-VirtualBox.dlink.router ([122.182.209.142])
        by smtp.gmail.com with ESMTPSA id o1sm1242832pje.7.2019.12.12.06.34.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 12 Dec 2019 06:34:33 -0800 (PST)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, pshelar@ovn.org,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: [PATCH net-next v2 1/3] net: skb_mpls_push() modified to allow MPLS header push at start of packet.
Date:   Thu, 12 Dec 2019 20:04:27 +0530
Message-Id: <5dbc2dbc222ff778861ef08b4e0a68a49a7afeb1.1576157907.git.martin.varghese@nokia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1576157907.git.martin.varghese@nokia.com>
References: <cover.1576157907.git.martin.varghese@nokia.com>
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

