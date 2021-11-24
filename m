Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F24D45CDEC
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhKXU2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:28:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbhKXU2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 15:28:03 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1874C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:24:53 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id g19so3722456pfb.8
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Yl0DG04mAxYInvrXqkjaY7TbRYAflil46ikhnClhS0=;
        b=bW5UKkmWFcueYJiHtHAq7pwIiNrz0g0IQlYhDD9r4h0wUnJMi51nTDUdGIbtYro3Kb
         RLsikSJZWeiTzUxNnqZ9aX/ZsJ8paKQf8DH2sAONVjW950BwMFjVtyUOexv076WTP9+m
         wCwslGWUGX1PoIkcB/OPMO+e9TjniZnV6FMV4ZE+e3VuiWG1r0ujUm2OK8DvfvuJ0lLK
         eIymnUaiA/vw+JSM28mnY02N66vDqrOzRLYJ/AGqQmQn7LzQxm8vUc4OmMcmy1orc1uC
         xi+UvPJD0f5BG65CjFIRde/T7/3v8aynjlMPP5nF/1qym8zJGlILGpwwtS1GKsPaPVck
         I9Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Yl0DG04mAxYInvrXqkjaY7TbRYAflil46ikhnClhS0=;
        b=uCnHi44HoBk81gzPrjx9ezBDY6kirii7YvNNg6NLiagGgf8v29hjOID5wUeOc1WeEA
         zqisv2jbrlCsXusvrtMaTeReclrt4+Lw7HEClZPmW2c5FnmIfAXEFwDTy9/p38hvYRM/
         YJQUFcAcVDF8NdxGeRyVMJCl+qKAa7dSM3lHlp6pIrtCbZ+/EydAKzXqtQL/STU4vZTO
         Gmf55aonopG/MI1obRuTzhhNoURj6y5qvz7aIW17ZI7p8xpAp1WcBkZC7+ehvsYBUKLt
         qReoj1R+aijPwTC6ZDNmL8wNku6fmi8VeJAqIro3S9o2euymCeMk+vdaIl8mfnuXNMJu
         S0xQ==
X-Gm-Message-State: AOAM530gK4u1fleMFhcvuciYsRUd1IAxb2xTqncnMELiBK5VzgPf5nqB
        l3m0VfM/GwUymWiceoeHXIA=
X-Google-Smtp-Source: ABdhPJyB4pz1Yd0kl2j69s5xIu2yYG6yexTD969UBMVtU7Ci8FBxrObh8rOBdyKy8EFeAOCIU24QuQ==
X-Received: by 2002:a05:6a00:248f:b0:4a0:1e25:3155 with SMTP id c15-20020a056a00248f00b004a01e253155mr9135168pfv.21.1637785493477;
        Wed, 24 Nov 2021 12:24:53 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b6ed:6a42:8a10:2f32])
        by smtp.gmail.com with ESMTPSA id i10sm472839pjd.3.2021.11.24.12.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 12:24:53 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
Date:   Wed, 24 Nov 2021 12:24:46 -0800
Message-Id: <20211124202446.2917972-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211124202446.2917972-1-eric.dumazet@gmail.com>
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Remove one pair of add/adc instructions and their dependency
against carry flag.

We can leverage third argument to csum_partial():

  X = csum_block_sub(X, csum_partial(start, len, 0), 0);

  -->

  X = csum_block_add(X, ~csum_partial(start, len, 0), 0);

  -->

  X = ~csum_partial(start, len, ~X);

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index eba256af64a577b458998845f2dc01a5ec80745a..eae4bd3237a41cc1b60b44c91fbfe21dfdd8f117 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3485,7 +3485,11 @@ __skb_postpull_rcsum(struct sk_buff *skb, const void *start, unsigned int len,
 static inline void skb_postpull_rcsum(struct sk_buff *skb,
 				      const void *start, unsigned int len)
 {
-	__skb_postpull_rcsum(skb, start, len, 0);
+	if (skb->ip_summed == CHECKSUM_COMPLETE)
+		skb->csum = ~csum_partial(start, len, ~skb->csum);
+	else if (skb->ip_summed == CHECKSUM_PARTIAL &&
+		 skb_checksum_start_offset(skb) < 0)
+		skb->ip_summed = CHECKSUM_NONE;
 }
 
 static __always_inline void
-- 
2.34.0.rc2.393.gf8c9666880-goog

