Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D842B583B2
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfF0Nhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:37:45 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40351 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfF0Nhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:37:45 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so7108637eds.7
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 06:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=Doc1i1yF2hdT9gqnV2H2iHz8wRHPrvzzQnBUUKgcxNo=;
        b=CwFH2p9e/+qN4HKT4fe97M7JWp/BL17OYLFEtBougqyE9gbTdTIZqf5xCI9s5hZUh+
         BIt5AiaSbQcQwtquaCDrNiTejidBn0YDe0T06/Fg5+aG8Fh0pnM5Pcz3THRm8rAOkMmo
         mTils+iHlouCKwyWAXvcg8Z2/XgNKMLYj4UNmzajAdVoJXcf2OrUXMzwMJ1cTomCsNAk
         Z0bbRtRwwwX2gvyRpjqBjKTR7diZJ1jkf5tCaylS6JLrx8ve9mum2vV0tJFVx8wuQl0D
         pxgEVTN2JKoawFuU6NsfBvCKuYaVC9SsXr6V11qRxCHtsGt3+xuf8/574tDUIUreQdoT
         3GQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Doc1i1yF2hdT9gqnV2H2iHz8wRHPrvzzQnBUUKgcxNo=;
        b=unAMKyR8C4x3vBEo2tHZLdlOvLX8YRxNzztYMkMiYyNxlbRN//PNRUtCvqFmhWsLYP
         /lTEkDt6T/yHpm/XD8YbXoqJGUug2BrQoonzvPHacHKd46156q+mHoJ2HGP9/EQm4fNT
         naX+SZYR7JFOpPowc06jKj8pICjfWfrr34JADMowKC71Osx/Z3PhRRfv0O3CdJEOEAzo
         QUYmr6O6jYtcukgM8ET65Jk5mB8K36bsaGtBO6XpDU3Qi0PzoehhoA+4I/0XJ881G079
         Pkpg6m+hbUiOy9blrUhcyh2vdGAD0RBCHFNgni93z2tE1PlPzJSo3GRXAGhSHJOQGXWi
         sxqA==
X-Gm-Message-State: APjAAAUgPQhZsP2P5jLg8aZjvWTEpMowJkOSiBF7ekscJlX9L6xFlbiz
        K61JZQV/RL1xEhmQtd+D5OgFlT4GPTA=
X-Google-Smtp-Source: APXvYqzMz/ACI9gVqGnb2QuBtxbnfSMDvH2X1irb50p2fpphsFNQQv4EnckPUfB7ocBO0eZf5DoGog==
X-Received: by 2002:a17:906:1596:: with SMTP id k22mr3342657ejd.102.1561642663435;
        Thu, 27 Jun 2019 06:37:43 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id t13sm794380edd.13.2019.06.27.06.37.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 27 Jun 2019 06:37:42 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, pshelar@ovn.org, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net 1/1] net: openvswitch: fix csum updates for MPLS actions
Date:   Thu, 27 Jun 2019 14:37:30 +0100
Message-Id: <1561642650-1974-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Skbs may have their checksum value populated by HW. If this is a checksum
calculated over the entire packet then the CHECKSUM_COMPLETE field is
marked. Changes to the data pointer on the skb throughout the network
stack still try to maintain this complete csum value if it is required
through functions such as skb_postpush_rcsum.

The MPLS actions in Open vSwitch modify a CHECKSUM_COMPLETE value when
changes are made to packet data without a push or a pull. This occurs when
the ethertype of the MAC header is changed or when MPLS lse fields are
modified.

The modification is carried out using the csum_partial function to get the
csum of a buffer and add it into the larger checksum. The buffer is an
inversion of the data to be removed followed by the new data. Because the
csum is calculated over 16 bits and these values align with 16 bits, the
effect is the removal of the old value from the CHECKSUM_COMPLETE and
addition of the new value.

However, the csum fed into the function and the outcome of the
calculation are also inverted. This would only make sense if it was the
new value rather than the old that was inverted in the input buffer.

Fix the issue by removing the bit inverts in the csum_partial calculation.

The bug was verified and the fix tested by comparing the folded value of
the updated CHECKSUM_COMPLETE value with the folded value of a full
software checksum calculation (reset skb->csum to 0 and run
skb_checksum_complete(skb)). Prior to the fix the outcomes differed but
after they produce the same result.

Fixes: 25cd9ba0abc0 ("openvswitch: Add basic MPLS support to kernel")
Fixes: bc7cc5999fd3 ("openvswitch: update checksum in {push,pop}_mpls")
Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 net/openvswitch/actions.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 151518d..bd13146 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -166,8 +166,7 @@ static void update_ethertype(struct sk_buff *skb, struct ethhdr *hdr,
 	if (skb->ip_summed == CHECKSUM_COMPLETE) {
 		__be16 diff[] = { ~(hdr->h_proto), ethertype };
 
-		skb->csum = ~csum_partial((char *)diff, sizeof(diff),
-					~skb->csum);
+		skb->csum = csum_partial((char *)diff, sizeof(diff), skb->csum);
 	}
 
 	hdr->h_proto = ethertype;
@@ -259,8 +258,7 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	if (skb->ip_summed == CHECKSUM_COMPLETE) {
 		__be32 diff[] = { ~(stack->label_stack_entry), lse };
 
-		skb->csum = ~csum_partial((char *)diff, sizeof(diff),
-					  ~skb->csum);
+		skb->csum = csum_partial((char *)diff, sizeof(diff), skb->csum);
 	}
 
 	stack->label_stack_entry = lse;
-- 
2.7.4

