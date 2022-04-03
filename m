Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEEF64F0996
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358424AbiDCNKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235661AbiDCNKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:11 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B623227159
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:16 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id d29so4584454wra.10
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cAQX/zAboHQHlBe7X9iztRMX0Jxv73yIQeqQNfVA2p0=;
        b=AQ2jgQ0nb1Ib0s7lPkTtMtx+3Rp9IttydMIpoldCY58nI37Nbin204jHnQp7xvtrNM
         ILH+oBzSnzZYJDLBS+fUhJBE/ZZ7vUFgXkb2i0tmizSxNoa/D51WNd1LedCqfDicP0/I
         IjW+X8ppLE3umvG12ypmzxfXE9LMv7NPdthKjn/B0h0DUFalqiruCvfUXVR6acGEGC3n
         xnJp/piyRWbvSdh3qd60QCCuDrwWncczF669oYovMHnGXDF6gdiTfFIpEPjn5KWyViX6
         4kf34R9MN1TQetGr5ANtiLHHQaNuWTbDvavsNlEXKIe98+Lc+3wDSxYco9Ua7JXo+SAY
         Cfug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cAQX/zAboHQHlBe7X9iztRMX0Jxv73yIQeqQNfVA2p0=;
        b=P1kRM4fajSM2+CdrCE6I2DpC2K0WllgW0JeJCX0/QmnC2Opv/dsKghNp/oa91fPD+v
         UQ68Uelw7wQOhY6UR8eOCYoRrZ1sjwLl8ovK7EGFiKdyEMCdoqm2K97VgLkHft6UZinK
         aW0pThdmh1byM7U4tnvYj+oE+vCJ1OMHVvwZ+k+c/3NLR90SRys4coBId1gA/rxzwxpR
         3VmdgS1+VruLBTOIqJwbDah70BodLaQKM0LS1T84w64lnvE+cD7oGjgtL645IPXESUI0
         fg9kboF+XzuVkMUn81Avjrujsna+wGtW2QS3E7WCPhebVbcMAeqm8v+FL+mfzPOLROfB
         ejzA==
X-Gm-Message-State: AOAM530IlddgTYBvQfd3G4Y2bimvCPYHAf4GMBGc5gD5qMfP54ncav1a
        J/6Z5e1tyxbsFtPCLH3JqYqIrquzKYY=
X-Google-Smtp-Source: ABdhPJzGkedqER16IvxV5imy4bKWlJJ1o1BcyQ9HTZOwLBXDl7fzYcMqhVDcmSr2LCPHM/Wc/o97Ag==
X-Received: by 2002:a5d:54ce:0:b0:205:133d:c152 with SMTP id x14-20020a5d54ce000000b00205133dc152mr13819458wrv.334.1648991295184;
        Sun, 03 Apr 2022 06:08:15 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 04/27] skbuff: drop zero check from skb_zcopy_set
Date:   Sun,  3 Apr 2022 14:06:16 +0100
Message-Id: <e8ca5cebbee024a6158ca5d1c9cc65bc8971c987.1648981571.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only two skb_zcopy_set() callers may pass a null skb, so kill a null
check from the function, which can't be easily compiled out and hand
code where needed. This will also help with further patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/skbuff.h | 2 +-
 net/ipv4/ip_output.c   | 3 ++-
 net/ipv6/ip6_output.c  | 3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3a30cae8b0a5..f5de5c9cc3da 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1679,7 +1679,7 @@ static inline void skb_zcopy_init(struct sk_buff *skb, struct ubuf_info *uarg)
 static inline void skb_zcopy_set(struct sk_buff *skb, struct ubuf_info *uarg,
 				 bool *have_ref)
 {
-	if (skb && uarg && !skb_zcopy(skb)) {
+	if (uarg && !skb_zcopy(skb)) {
 		if (unlikely(have_ref && *have_ref))
 			*have_ref = false;
 		else
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 00b4bf26fd93..f864b8c48e42 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1027,7 +1027,8 @@ static int __ip_append_data(struct sock *sk,
 			paged = true;
 		} else {
 			uarg->zerocopy = 0;
-			skb_zcopy_set(skb, uarg, &extra_uref);
+			if (skb)
+				skb_zcopy_set(skb, uarg, &extra_uref);
 		}
 	}
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index e23f058166af..e9b039f56637 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1529,7 +1529,8 @@ static int __ip6_append_data(struct sock *sk,
 			paged = true;
 		} else {
 			uarg->zerocopy = 0;
-			skb_zcopy_set(skb, uarg, &extra_uref);
+			if (skb)
+				skb_zcopy_set(skb, uarg, &extra_uref);
 		}
 	}
 
-- 
2.35.1

