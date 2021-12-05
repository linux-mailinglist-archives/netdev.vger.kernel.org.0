Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2FBB468CD6
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 19:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237044AbhLESlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 13:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhLESlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 13:41:46 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7EA1C061714;
        Sun,  5 Dec 2021 10:38:18 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id o19-20020a1c7513000000b0033a93202467so6107727wmc.2;
        Sun, 05 Dec 2021 10:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7qmACymnRp+f5lldVkIlBCWA+61jLGtYnmZv5x59OqM=;
        b=KSCZeeDMornLhUNQ8nIRU9UbmsaVgeE6SGqpFYcOCQlI0nEHgSjHVcRFsTYrUCcDz0
         DirrXSKQZlLnf4j2Y2FFfx7kneXVcEAdDbgefI2pWEp+4AjPVjawKm3TwvjBYkviD84E
         10igp67xZvGztTX4zKB5aAsYBt2DLli/Be2iN8ZWQbTINwRe3h+ENcDGLgRA7WzMxX0D
         Mg/r40zB9RN+B7iTg3k+NCS3OxjjVxqsmUHrVYA1IV2QxT+ggOSB9/Sh3kfiBpCfRorF
         EDzd/GuvPJskN62Y7OEpWohMO81ZE8ySNQWZqMKWGEO85MOgMYkTPQorNfClIJUXcLrN
         PX1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7qmACymnRp+f5lldVkIlBCWA+61jLGtYnmZv5x59OqM=;
        b=6puTNS75EHxUsIfJy5exmUjnLfnNLwIAlTMQiOXGrBS+SKzHEKGZstr9BSY6wXuFTi
         BQqlOXkreyqRj0kGxzLLzb9YUwhVrdUxAK1lJbS6LpfQBxyKt78fYqj8X1HfYkwa5ZrS
         XzZ/3T6v6bkpIBX2SmObXRJ0HUuIMkKtHEW5T1B1ANZYERm1esBPR5LwNzHnhl/MHWNc
         qbY2HdRn/i2MisQfI7QDLoJKFk52v+92AS5QdLHVlBspHcMTMhvYtK6njcSV+LSYePVB
         gQ5lV2U+S2vq8raq2/BGwxIDLYO2WAkzoKAsffZCYOU4H0b7L9y2u0VszYIkitOuEpoe
         xcYg==
X-Gm-Message-State: AOAM531+W5gr4PMvJv0pdhVE8XcVZX31f8u1IURI93gqIxFO8xenixyx
        JoU0XT9GNUdCmUsthWTC7sdstkKKMHdJvCzj
X-Google-Smtp-Source: ABdhPJx7cGv/2Lus4x3B1e0/JqBG+KQ+ruK05aih6u9wLmzpOVxVAm/15umdVbGyokPNUNeju8/EEA==
X-Received: by 2002:a1c:1906:: with SMTP id 6mr33883133wmz.19.1638729497234;
        Sun, 05 Dec 2021 10:38:17 -0800 (PST)
Received: from localhost.localdomain ([39.48.147.147])
        by smtp.gmail.com with ESMTPSA id z8sm9501340wrh.54.2021.12.05.10.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Dec 2021 10:38:16 -0800 (PST)
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     jeroendb@google.com, csully@google.com, awogbemila@google.com,
        davem@davemloft.net, kuba@kernel.org, bcf@google.com,
        willemb@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        amhamza.mgc@gmail.com
Subject: [PATCH v2] gve: fix for null pointer dereference.
Date:   Sun,  5 Dec 2021 23:38:10 +0500
Message-Id: <20211205183810.8299-1-amhamza.mgc@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211205183316.7800-1-amhamza.mgc@gmail.com>
References: <20211205183316.7800-1-amhamza.mgc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid passing NULL skb to __skb_put() function call if
napi_alloc_skb() returns NULL.

Addresses-Coverity: 1494144 (Dereference NULL return value)

Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>

---
Change in v2:
checking for correct skb pointer for NULL check
---
 drivers/net/ethernet/google/gve/gve_utils.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve_utils.c b/drivers/net/ethernet/google/gve/gve_utils.c
index 88ca49cbc1e2..d57508bc4307 100644
--- a/drivers/net/ethernet/google/gve/gve_utils.c
+++ b/drivers/net/ethernet/google/gve/gve_utils.c
@@ -68,6 +68,9 @@ struct sk_buff *gve_rx_copy(struct net_device *dev, struct napi_struct *napi,
 		set_protocol = ctx->curr_frag_cnt == ctx->expected_frag_cnt - 1;
 	} else {
 		skb = napi_alloc_skb(napi, len);
+
+		if (unlikely(!skb))
+			return NULL;
 		set_protocol = true;
 	}
 	__skb_put(skb, len);
-- 
2.25.1

