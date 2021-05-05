Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C926637403F
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbhEEQde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:33:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234164AbhEEQc5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:32:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC94D613CB;
        Wed,  5 May 2021 16:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232320;
        bh=A6XwZIRj3cPG/0PWTLC7UH8xv/Ij3Tu1pDZ73764Tu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k46O2w9FYw8DctVTYru2my1PPfEezZz22VenBXeJqTFzu5ntBDURi/i3xVAPKfh+N
         uYHD9luTGOmM7a8vvLX1+umN4Kj9wu0Griqb+s+bzGMNGyJClR0AaFMZAV2LdKP08S
         WHK4gwMhPEQCkV/KiYJjaoVkqgB7+IzzFE+OaZfN/aIqXiFYZGt8TXYWlgW2xF6uMF
         lX9lI+hYX6KZu09RWegRshPpsuy3glO36k/oKdpkYJzQ9/CWNY8JlZmUgqo+WvpfnR
         BUY2ZJgjdIEhwB2C/eoEh+LIWKpev0LoEviQX+GGL8M9Jo440J0W8Af3w6TIr2UPmc
         VKbFui5tRoNUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 026/116] net/sched: cls_flower: use ntohs for struct flow_dissector_key_ports
Date:   Wed,  5 May 2021 12:29:54 -0400
Message-Id: <20210505163125.3460440-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 6215afcb9a7e35cef334dc0ae7f998cc72c8465f ]

A make W=1 build complains that:

net/sched/cls_flower.c:214:20: warning: cast from restricted __be16
net/sched/cls_flower.c:214:20: warning: incorrect type in argument 1 (different base types)
net/sched/cls_flower.c:214:20:    expected unsigned short [usertype] val
net/sched/cls_flower.c:214:20:    got restricted __be16 [usertype] dst

This is because we use htons on struct flow_dissector_key_ports members
src and dst, which are defined as __be16, so they are already in network
byte order, not host. The byte swap function for the other direction
should have been used.

Because htons and ntohs do the same thing (either both swap, or none
does), this change has no functional effect except to silence the
warnings.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_flower.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index c69a4ba9c33f..3035f96c6e6c 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -209,16 +209,16 @@ static bool fl_range_port_dst_cmp(struct cls_fl_filter *filter,
 				  struct fl_flow_key *key,
 				  struct fl_flow_key *mkey)
 {
-	__be16 min_mask, max_mask, min_val, max_val;
+	u16 min_mask, max_mask, min_val, max_val;
 
-	min_mask = htons(filter->mask->key.tp_range.tp_min.dst);
-	max_mask = htons(filter->mask->key.tp_range.tp_max.dst);
-	min_val = htons(filter->key.tp_range.tp_min.dst);
-	max_val = htons(filter->key.tp_range.tp_max.dst);
+	min_mask = ntohs(filter->mask->key.tp_range.tp_min.dst);
+	max_mask = ntohs(filter->mask->key.tp_range.tp_max.dst);
+	min_val = ntohs(filter->key.tp_range.tp_min.dst);
+	max_val = ntohs(filter->key.tp_range.tp_max.dst);
 
 	if (min_mask && max_mask) {
-		if (htons(key->tp_range.tp.dst) < min_val ||
-		    htons(key->tp_range.tp.dst) > max_val)
+		if (ntohs(key->tp_range.tp.dst) < min_val ||
+		    ntohs(key->tp_range.tp.dst) > max_val)
 			return false;
 
 		/* skb does not have min and max values */
@@ -232,16 +232,16 @@ static bool fl_range_port_src_cmp(struct cls_fl_filter *filter,
 				  struct fl_flow_key *key,
 				  struct fl_flow_key *mkey)
 {
-	__be16 min_mask, max_mask, min_val, max_val;
+	u16 min_mask, max_mask, min_val, max_val;
 
-	min_mask = htons(filter->mask->key.tp_range.tp_min.src);
-	max_mask = htons(filter->mask->key.tp_range.tp_max.src);
-	min_val = htons(filter->key.tp_range.tp_min.src);
-	max_val = htons(filter->key.tp_range.tp_max.src);
+	min_mask = ntohs(filter->mask->key.tp_range.tp_min.src);
+	max_mask = ntohs(filter->mask->key.tp_range.tp_max.src);
+	min_val = ntohs(filter->key.tp_range.tp_min.src);
+	max_val = ntohs(filter->key.tp_range.tp_max.src);
 
 	if (min_mask && max_mask) {
-		if (htons(key->tp_range.tp.src) < min_val ||
-		    htons(key->tp_range.tp.src) > max_val)
+		if (ntohs(key->tp_range.tp.src) < min_val ||
+		    ntohs(key->tp_range.tp.src) > max_val)
 			return false;
 
 		/* skb does not have min and max values */
@@ -783,16 +783,16 @@ static int fl_set_key_port_range(struct nlattr **tb, struct fl_flow_key *key,
 		       TCA_FLOWER_UNSPEC, sizeof(key->tp_range.tp_max.src));
 
 	if (mask->tp_range.tp_min.dst && mask->tp_range.tp_max.dst &&
-	    htons(key->tp_range.tp_max.dst) <=
-	    htons(key->tp_range.tp_min.dst)) {
+	    ntohs(key->tp_range.tp_max.dst) <=
+	    ntohs(key->tp_range.tp_min.dst)) {
 		NL_SET_ERR_MSG_ATTR(extack,
 				    tb[TCA_FLOWER_KEY_PORT_DST_MIN],
 				    "Invalid destination port range (min must be strictly smaller than max)");
 		return -EINVAL;
 	}
 	if (mask->tp_range.tp_min.src && mask->tp_range.tp_max.src &&
-	    htons(key->tp_range.tp_max.src) <=
-	    htons(key->tp_range.tp_min.src)) {
+	    ntohs(key->tp_range.tp_max.src) <=
+	    ntohs(key->tp_range.tp_min.src)) {
 		NL_SET_ERR_MSG_ATTR(extack,
 				    tb[TCA_FLOWER_KEY_PORT_SRC_MIN],
 				    "Invalid source port range (min must be strictly smaller than max)");
-- 
2.30.2

