Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F692F7591
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 10:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbhAOJh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 04:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbhAOJh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 04:37:28 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BD4C0613C1;
        Fri, 15 Jan 2021 01:36:56 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id p18so5634030pgm.11;
        Fri, 15 Jan 2021 01:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=OTtsm6dyKrVJ0jbDg2f7EoVgwZ5It1gTjh6wfzgk4d0=;
        b=ruZCSYW1oaH2ZJTusFo2uZ/K0IMbZDczPU59YHk6oizEtzQABrl5XR6MypzlQADjhb
         WtQHqCEMQ+Vpyg2tE9zydMVaom0CRU1KQXcc3xSGVKKsvCiOP789sAQ0xSBFckK64kzi
         BbYWThJg/NPdu70urKVQ+0//sHJhwZQTyrzgeTfrEh+2WYiIpo1jiBCwoJM7y6i6T4sK
         lzw4m3hP2RMEndRGIFoPBmTmGlYF82xG1saJj9gE7+ZQkiPVSmfxvSB1hdVR8ybo6u5+
         ZkW7I3LX1RmGcu0zWaEdZYA6zk+VhV8in8rIVOhdtxC+LgryjF8gelKUWxPBlv1NCBcR
         Lceg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=OTtsm6dyKrVJ0jbDg2f7EoVgwZ5It1gTjh6wfzgk4d0=;
        b=jU3ehZmHG71ujNYB4alnq+s/1mdPQkmzHbcGKsfMa+uuYcTB7YjQgGaNOaW5PaNaMH
         UvweSHZgSJIEglQfYWAEVESgXpjQoqCCtZuf7xwJMv6P/6FrwI1fkIU0XiID+5WVF59U
         uI/oYje2lvUMsnX7PO66PsSIte/4B18HqDRN+jS3N00t6OpUJiX/q0e7AoP8nKmqrY27
         ly1d9NUqNUVZzheT1mvXV3HSs4vi8n7fF/qgwO8f06PeJERFLrIAfd95uT3lxfzHnNr5
         BwWgPSjDlI8vH3fICOaqu6Wp4ZTOubFu7/uymebYqxQhIletzEDoC0HobrWnhN/abZdg
         gyXw==
X-Gm-Message-State: AOAM530aU6C2c6YMN6HLtSdFIKjnE312zWSNsDYq0rEqQ+Pjr1NxIdzl
        GFcuzCwkEouZAJ/Uq2//btg4Tg/YIvSZBw==
X-Google-Smtp-Source: ABdhPJwPl2srwtVq1yf83n3skm/79nBDwiN9RbAJwUTcuWmGFlsxzZ3eXyoWlVZf3lkbJviIL9wcBQ==
X-Received: by 2002:aa7:9055:0:b029:19e:4bf4:c6bc with SMTP id n21-20020aa790550000b029019e4bf4c6bcmr12002200pfo.58.1610703415627;
        Fri, 15 Jan 2021 01:36:55 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o83sm259099pfd.158.2021.01.15.01.36.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 01:36:55 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCHv3 net-next 1/2] net: move the hsize check to the else block in skb_segment
Date:   Fri, 15 Jan 2021 17:36:38 +0800
Message-Id: <bfecc76748f5dc64eaddf501c258dca9efb92bdf.1610703289.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1610703289.git.lucien.xin@gmail.com>
References: <cover.1610703289.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610703289.git.lucien.xin@gmail.com>
References: <cover.1610703289.git.lucien.xin@gmail.com>
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

v1->v2:
  - change to do "hsize <= 0" check instead of "!hsize", and also move
    "hsize < 0" into else block, to save some cycles, as Alex suggested.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/core/skbuff.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6039069..e835193 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3894,12 +3894,8 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 		}
 
 		hsize = skb_headlen(head_skb) - offset;
-		if (hsize < 0)
-			hsize = 0;
-		if (hsize > len || !sg)
-			hsize = len;
 
-		if (!hsize && i >= nfrags && skb_headlen(list_skb) &&
+		if (hsize <= 0 && i >= nfrags && skb_headlen(list_skb) &&
 		    (skb_headlen(list_skb) == len || sg)) {
 			BUG_ON(skb_headlen(list_skb) > len);
 
@@ -3942,6 +3938,11 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 			skb_release_head_state(nskb);
 			__skb_push(nskb, doffset);
 		} else {
+			if (hsize > len || !sg)
+				hsize = len;
+			else if (hsize < 0)
+				hsize = 0;
+
 			nskb = __alloc_skb(hsize + doffset + headroom,
 					   GFP_ATOMIC, skb_alloc_rx_flag(head_skb),
 					   NUMA_NO_NODE);
-- 
2.1.0

