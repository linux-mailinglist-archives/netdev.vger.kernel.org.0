Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD672F743D
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 09:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732562AbhAOIWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 03:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbhAOIWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 03:22:09 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894FBC061757;
        Fri, 15 Jan 2021 00:21:29 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id y12so4648992pji.1;
        Fri, 15 Jan 2021 00:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=OTtsm6dyKrVJ0jbDg2f7EoVgwZ5It1gTjh6wfzgk4d0=;
        b=ab09OwPQFc/dVOulO/JZZqI7Lt/7OaZS6W3Fs2pUlwzyCHyYr/g/CDyJtUPhKll2cT
         6zhn6aePO31JSyh0VW5N3tP0b1wXmXa2TztetggvPaSngnLfrrLW+V2rk+V2kSkNlyG3
         Xs0R+L2jDbuF37bP72DzeN5UMxf3iS66Re6wRhDe5DJ1Pq3RQbYGsUfYwbtL8Jb6eOed
         Wbx4ut5bI5dLvtCvgOdXPFXM40a/vja9cRUohEsEBHlkfugjVa9T9TV2SZ3EDptt2LDm
         VJ5uabWB4DvYgSiJDUbylz7UlLetNW3zxMIdybfd0nxTE3brMe3IYMQ5ZteY9NZ5EHbD
         gEew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=OTtsm6dyKrVJ0jbDg2f7EoVgwZ5It1gTjh6wfzgk4d0=;
        b=tiHND1JkWSz0xv4FX8MTFAeHLW2Rlh89MRIOwIAs+sxCLvCEnVHgRs+TpFa9zJ2wDa
         Jyxprnq7fmYWTQOqb2jaYuUFJLEVI7jgZk/dJmib3DhxLkC91Iz/WAQZLesX7V3eXlTK
         gNc9LPT9lLdUBvRUntDRe2JULERaWGcvjo7/qn5MbmM3QM9wYiHnxx43lW3nY6XzXLC1
         AdrF2pgolwB5yar3Pdn8OCBAN5L2R+dVpZ+cuzFd6D3yPPNDtmdM0OZtrOCvC/qBS17X
         XmMazk/08LOD7AmKhPsYEFkUfO2Uzg6xCaXViAYoA/smD0zkZWAzo6bPPxg3jPE9vmLe
         /skg==
X-Gm-Message-State: AOAM530RtFptNM8JJmpEBsfhy8O59HLbfnO93CJ41GXZNta89J4XmZjf
        Mv1xsKiD/c5+A0dI9Eyq4U0B170gRx2gYg==
X-Google-Smtp-Source: ABdhPJyW/zECmfCcKhB8La+o3Arts78sxZ54HghKqDH16ovF8o5NZIeQ8YSqwn9eWS8+zNg1Lq6Mjg==
X-Received: by 2002:a17:90b:1c0d:: with SMTP id oc13mr9678051pjb.156.1610698888874;
        Fri, 15 Jan 2021 00:21:28 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ay21sm7462635pjb.1.2021.01.15.00.21.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 00:21:28 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCHv2 net-next 1/2] net: move the hsize check to the else block in skb_segment
Date:   Fri, 15 Jan 2021 16:21:11 +0800
Message-Id: <bfecc76748f5dc64eaddf501c258dca9efb92bdf.1610698811.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1610698811.git.lucien.xin@gmail.com>
References: <cover.1610698811.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610698811.git.lucien.xin@gmail.com>
References: <cover.1610698811.git.lucien.xin@gmail.com>
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

