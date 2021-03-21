Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6123A3434F6
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 22:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhCUVGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 17:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhCUVGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 17:06:06 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69E4C061574
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 14:06:05 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id j3so16934591edp.11
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 14:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XNtWbXw6x/OOVYaLURf2eRzJJaBdLDDTOSlVzVGGol8=;
        b=qvpPd6ql5XKDUuJK43ZEwa0cQ3AJEliVyxg/SlPL9yW41+jsk7Gr9TfvMjblBHaCG+
         kRw0h3ycEfaf+7NYJ+N7dLsX/nnlCLkguGAEMwZqaA7M8uh+ytsxOVB45RKnzZwHj2Cz
         HS6VmPUMoujGkA7tSt2Y2uPInUnZLQ/10H1RX709j4NU8dh7RkLcRN3byLardIOMlatX
         nJAQoS9Hffdy5czA/JxTu3MTkhiCBqtgn2we4mS/xqBcx0ecb/MO8JzDJWFTovwospsl
         quDIRat+5OE0dJnSBXXqULVSTU9ir10f/+Rlayl3o42w21J+lCgLxUznFPtc6U2Hs+jq
         Ji5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XNtWbXw6x/OOVYaLURf2eRzJJaBdLDDTOSlVzVGGol8=;
        b=eD6pE8kPFClh8iKRIw7o9qnqNwj7O3JeB+8g90QWfK6BkwJKYMtnIJSwfs3gB2BxHH
         UY8aHhFH6TYCtxDAwIT4kuiBnHp95eEFNx8UHB3iuMzVX3LNe/rasjjMhe7wKrmLayTJ
         rlveUds62UBHJJaSmQ1xdYo4xg618XqaTDMbAlLxz3MnWWLNBD6i9uQ4K9x34ZJfhOfe
         8Z4kQKQ/goZz28g8kBa+BJ9yDel14NzhiTda2MmwG+jVBP7Oi8vGnv54peC7rOZtl+8o
         IPKYcQ+g6/LNpUO7+ulJGRab3gT9puRoBwqgLzBZnnL+OucpgWpcQiw29yMCXqmTpn+n
         aq0w==
X-Gm-Message-State: AOAM533FQ/7sg02zclrvlLwmKHOPa5rWPcaL4XJ9H6OiLGg8N0JhwHsZ
        cgfV5+QEDk93NhOflj9KAe8=
X-Google-Smtp-Source: ABdhPJy4rPb56OeEDT0PrT7PtBMYiY/MFvkA9bMp01wO4ys0x9FIab22OIPR5YMEhJruMzE6aENSZQ==
X-Received: by 2002:aa7:cb90:: with SMTP id r16mr22660765edt.139.1616360764545;
        Sun, 21 Mar 2021 14:06:04 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r17sm9195664edt.70.2021.03.21.14.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 14:06:04 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 1/2] net/sched: cls_flower: use ntohs for struct flow_dissector_key_ports
Date:   Sun, 21 Mar 2021 23:05:48 +0200
Message-Id: <20210321210549.3234265-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

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
---
 net/sched/cls_flower.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index d097b5c15faa..832a0ece6dbf 100644
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
2.25.1

