Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE2A2F1289
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 13:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbhAKMqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 07:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbhAKMqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 07:46:11 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64B1C061794;
        Mon, 11 Jan 2021 04:45:31 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id x18so9456534pln.6;
        Mon, 11 Jan 2021 04:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=LvewK14z2tnoQQFBHxeP4pTUt9/S6bcFl6WhHhcYiqA=;
        b=D+143fYalN1AAOLEgF+unyOVQbPFVIadK9j1LVHvsG9Vz0AvB7f+ZqhKWj4Sp39E1X
         Tirxp+c7dAt6K5a9qOCRi+HEMRHtykBUTNhU68aFJEzpZVe0ry/TGJtWKMyhobOLQcQs
         cVqWygPYHvRYlMa/E7K38VbwG4anJk8Z1s/wtAuQ7sCNeK3GFKPXnJXd7N3i2xZeqTPR
         PJMyNigxEEgJcidfsXzy7Yk8KUhAxaikRvIJkXGApKGBVRSCGzB3tVOE70QM1QjRWvTF
         ySUZ/gayyPX7P+YjqW3RRODOzgIw5u3PuGecV3jWO7ustFpNX2fY7OXoTUnF3jd4POLu
         xIdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=LvewK14z2tnoQQFBHxeP4pTUt9/S6bcFl6WhHhcYiqA=;
        b=QYFK7PdTV4M0YwjA8vTeG0e4WBE7GcUbpxTE2C+K0BpNhiitfnxYQKZBZdgt3sELH9
         MdXZnzEquftjyrEwjuX9AUYESkBS2n2IA05qP0KY8bJ3y4ao6bPlgVEmuM6Knsciq8Lb
         k2ARZVCi3+qS5DVgSixjR8f6pfG/G64lGoDW5D1hVud4KfajI99k5G6S6zj1Kfq0ihBF
         Mc9H9zKWm1yfJ7HJi4lnAFEZ8K/oL/J7omfKmY9P9YgcBwSviddniqbOW/N+Hysheb9Z
         L1ljD+mk/I5kdoIC/6IgoZP8gz3ePP99IL7bzo2OpivUoBgjvV8Bq8yDAsINu8p7dLvE
         oFrg==
X-Gm-Message-State: AOAM530D2qh5ByZom3EVWJAwg+dolbZxl/v7oEpf8uj4P+aSFKJLeiRS
        oWrQnAZya94Jt2b9P0ewcAU5vLyy6ZxPjQ==
X-Google-Smtp-Source: ABdhPJyoXRaKWLUV1WpWgYvzmY2+2LarB0Ge3hZoRSkfApm81IDU9vjUZ8myRx3CBN1KYah9M8lxhQ==
X-Received: by 2002:a17:902:b416:b029:dc:3657:9265 with SMTP id x22-20020a170902b416b02900dc36579265mr16147635plr.24.1610369131017;
        Mon, 11 Jan 2021 04:45:31 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j12sm15862452pjd.8.2021.01.11.04.45.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 04:45:30 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next 1/2] net: move the hsize check to the else block in skb_segment
Date:   Mon, 11 Jan 2021 20:45:13 +0800
Message-Id: <a34a8dcde6a158c64b0478c7098da757a6690f0b.1610368918.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1610368918.git.lucien.xin@gmail.com>
References: <cover.1610368918.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610368918.git.lucien.xin@gmail.com>
References: <cover.1610368918.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 89319d3801d1 ("net: Add frag_list support to skb_segment"),
it goes to process frag_list when !hsize in skb_segment(). However, when
using skb frag_list, sg normally should not be set. In this case, hsize
will be set with len right before !hsize check, then it won't go to
frag_list processing code.

So the right thing to do is move the hsize check to the else block, so
that it won't affect the !hsize check for frag_list processing.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/core/skbuff.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7626a33..ea79359 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3855,8 +3855,6 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 		hsize = skb_headlen(head_skb) - offset;
 		if (hsize < 0)
 			hsize = 0;
-		if (hsize > len || !sg)
-			hsize = len;
 
 		if (!hsize && i >= nfrags && skb_headlen(list_skb) &&
 		    (skb_headlen(list_skb) == len || sg)) {
@@ -3901,6 +3899,9 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 			skb_release_head_state(nskb);
 			__skb_push(nskb, doffset);
 		} else {
+			if (hsize > len || !sg)
+				hsize = len;
+
 			nskb = __alloc_skb(hsize + doffset + headroom,
 					   GFP_ATOMIC, skb_alloc_rx_flag(head_skb),
 					   NUMA_NO_NODE);
-- 
2.1.0

