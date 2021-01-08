Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666812EF17A
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 12:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbhAHLjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 06:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbhAHLjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 06:39:53 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64491C0612F6
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 03:39:13 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id c13so3378203pfi.12
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 03:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K2fvYLN1pMSqjB4UiNjF3R0AF7AoghruOrvOoxrJ58w=;
        b=MsOwKiaI6Ie1xJmWlc1+Z59/Cz5kb6LCO6Z4jp/bEZXlWzPlydo42TFOl8+XHe5VQm
         BNvmYGF3MOO3gKgWFJhp8Vv3i5hMtdre70g+USo9Gcpve6+Nz7E7jpP6wwzUHkHa+/3y
         0e4MS5GpDe7uDowdqr5DGqhIQgg1O68BrVy1foqtUNA0FGmR4dYrvtqV/X3qwqxOnKc/
         EJKl04JrAqNRbZ7Zr5VfRpxzoqEcoDdHSK8fWtW9bw6DEs6v3TD1li7q36UBu9NhvlO6
         i0M4J1EnKhwmmqvqCiNFfaGar4tDpEbxfLcGyBJTxw6LS+lPgfC6X+zTNG6dJNoML7u9
         AfOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K2fvYLN1pMSqjB4UiNjF3R0AF7AoghruOrvOoxrJ58w=;
        b=DvgoQvA7ZZaVaS8Hd3pxwAXKYpi2bDie3FXg6z2AXypVZPI3CbS3fGyj8ErNfe+4LE
         ppV/aB14eza5p5r52+MLQu6KEnfUc54yDA6DA+/DruAUvjnRLbUe3GP1v680HPNk2+sq
         b8+Rn00hzMDsLaGWPmyLjdMX8vVcU/acHYEjv9ZQJNaTF+TWJ+wKp9WPZ43s6mJzZh4W
         qZfUrnn+iWZhYzL2vPa2VSdUBm92gsC2E8Hv73lZd8z4sQP8/HqoUaTdpfdEEsbzLTEL
         3xsLgzQd82CzSrQ0ffFx8GsKMWsL+1CJ24v0l0NHuGfUtPfVzt0dXOUgGjNBHsz5sQdD
         +qAw==
X-Gm-Message-State: AOAM530udc91mqBp3WLwhMeM5uu39v9j6PmiOakZD0I1HHnhcdaSRLlF
        swoiEdeICpx62G7ThHki68U=
X-Google-Smtp-Source: ABdhPJz0pFwUIvYS1ikdgTyqzjhuMOVcgqHXBt/qQRvF8naEnlqG/xipf17QplsehVzRihfMbcJnbw==
X-Received: by 2002:a63:c64f:: with SMTP id x15mr6596425pgg.196.1610105953050;
        Fri, 08 Jan 2021 03:39:13 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id r20sm9939971pgb.3.2021.01.08.03.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 03:39:12 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next 2/2] net-gro: remove GRO_DROP
Date:   Fri,  8 Jan 2021 03:39:03 -0800
Message-Id: <20210108113903.3779510-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
In-Reply-To: <20210108113903.3779510-1-eric.dumazet@gmail.com>
References: <20210108113903.3779510-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

GRO_DROP can only be returned from napi_gro_frags()
if the skb has not been allocated by a prior napi_get_frags()

Since drivers must use napi_get_frags() and test its result
before populating the skb with metadata, we can safely remove
GRO_DROP since it offers no practical use.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 include/linux/netdevice.h |  1 -
 net/core/dev.c            | 11 -----------
 2 files changed, 12 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 1ec3ac5d5bbffe6062216fbd4009e88d8c909fa9..5b949076ed2319fc676a7172350480efea5807d9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -376,7 +376,6 @@ enum gro_result {
 	GRO_MERGED_FREE,
 	GRO_HELD,
 	GRO_NORMAL,
-	GRO_DROP,
 	GRO_CONSUMED,
 };
 typedef enum gro_result gro_result_t;
diff --git a/net/core/dev.c b/net/core/dev.c
index 7afbb642e203ad1556e96e2fc7595b6289152201..e4d77c8abe761408caf3a0d1880727f33b5134b6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6070,10 +6070,6 @@ static gro_result_t napi_skb_finish(struct napi_struct *napi,
 		gro_normal_one(napi, skb);
 		break;
 
-	case GRO_DROP:
-		kfree_skb(skb);
-		break;
-
 	case GRO_MERGED_FREE:
 		if (NAPI_GRO_CB(skb)->free == NAPI_GRO_FREE_STOLEN_HEAD)
 			napi_skb_free_stolen_head(skb);
@@ -6158,10 +6154,6 @@ static gro_result_t napi_frags_finish(struct napi_struct *napi,
 			gro_normal_one(napi, skb);
 		break;
 
-	case GRO_DROP:
-		napi_reuse_skb(napi, skb);
-		break;
-
 	case GRO_MERGED_FREE:
 		if (NAPI_GRO_CB(skb)->free == NAPI_GRO_FREE_STOLEN_HEAD)
 			napi_skb_free_stolen_head(skb);
@@ -6223,9 +6215,6 @@ gro_result_t napi_gro_frags(struct napi_struct *napi)
 	gro_result_t ret;
 	struct sk_buff *skb = napi_frags_skb(napi);
 
-	if (!skb)
-		return GRO_DROP;
-
 	trace_napi_gro_frags_entry(skb);
 
 	ret = napi_frags_finish(napi, skb, dev_gro_receive(napi, skb));
-- 
2.29.2.729.g45daf8777d-goog

