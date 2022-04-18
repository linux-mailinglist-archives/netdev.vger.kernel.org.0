Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D02D50602A
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 01:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234817AbiDRXVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 19:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234808AbiDRXUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 19:20:50 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754BD23BE8
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:18:10 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id hf18so10639775qtb.0
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0dcJHoI59iupk/XZrTeiSOhbOxLwLKCBzj4Z2fI2tTc=;
        b=LhCy4Xw3XN068oiUmiq1/1Q8uv7ZgPx8f0g98Osy317QhjxRDf3CkOOZPc1ftvYJnJ
         gxOnCH8bESAgzEqHoyAL70WuiVudZ2fj2ItxFXVGHqPNIU0Hj+kI/gpT7q3dnW+7t9YN
         ffDvkK5FKc6Flz2lKRs5lZvpB7Mi0a3S+yVSA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0dcJHoI59iupk/XZrTeiSOhbOxLwLKCBzj4Z2fI2tTc=;
        b=7HkmPkVGIVC0kIkHXzdHloxt9YalaORVcpkGw/g31srhMdUyMliQu64qmrwKEy+YIW
         jjTLjS6rtUtPFsJ6812qtkTV49HOpYddMNiOPZg9XQZVpebQYAC5+un4egS3p2V6mJZ7
         Jf+2x9hdniFUhlDcl9+ezo62+n1kxY+FMnw0PSDbEOPpKScT64wsLYg+72JClJanMIDb
         logEQor9wAUq2nLHr3msNU/Djv0f1YE8cRjn+NLXVdch2qMfVwthrzcwzHTwuM284r22
         /Babyjizw6QVL5pMl6hWa2PlEBO8uMgy2MTSee6rJoUxBRT9b4teBlyTPLr1AkKM6PxA
         6wug==
X-Gm-Message-State: AOAM532TKbvm8RrQ9yRZyomrdTF71hUN3WOWFcGfZsYPh+vkOJ+HcZqK
        u54V5JYasnll2xwetEMdK1FnNA==
X-Google-Smtp-Source: ABdhPJzVmagn0Rfc5cXZudhsLyucFUBeBfCKmqRoxtX4m60vigQt1WYkqD8XBGNWp/r7n0HZ6vDLmg==
X-Received: by 2002:ac8:5206:0:b0:2f1:e8cc:7800 with SMTP id r6-20020ac85206000000b002f1e8cc7800mr8620403qtn.501.1650323889668;
        Mon, 18 Apr 2022 16:18:09 -0700 (PDT)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id a1-20020a05622a02c100b002f17cba4930sm8214048qtx.85.2022.04.18.16.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 16:18:09 -0700 (PDT)
From:   Grant Grundler <grundler@chromium.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Aashay Shringarpure <aashay@google.com>,
        Yi Chou <yich@google.com>,
        Shervin Oloumi <enlightened@google.com>,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH 5/5] net: atlantic: verify hw_head_ is reasonable
Date:   Mon, 18 Apr 2022 16:17:46 -0700
Message-Id: <20220418231746.2464800-6-grundler@chromium.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220418231746.2464800-1-grundler@chromium.org>
References: <20220418231746.2464800-1-grundler@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bounds check hw_head index to verify it lies within the TX buffer ring.

Unexpected values of hw_head may cause aq_ring_tx_clean to double
dev_kfree_skb_any already cleaned parts of the ring.

Reported-by: Aashay Shringarpure <aashay@google.com>
Reported-by: Yi Chou <yich@google.com>
Reported-by: Shervin Oloumi <enlightened@google.com>
Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index e72b9d86f6ad..9b6b93bb3e86 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -889,6 +889,27 @@ int hw_atl_b0_hw_ring_tx_head_update(struct aq_hw_s *self,
 		err = -ENXIO;
 		goto err_exit;
 	}
+
+	/* Validate that the new hw_head_ is reasonable. */
+	if (hw_head_ >= ring->size) {
+		err = -ENXIO;
+		goto err_exit;
+	}
+
+	if (ring->sw_head >= ring->sw_tail) {
+		/* Head index hasn't wrapped around to below tail index. */
+		if (hw_head_ < ring->sw_head && hw_head_ >= ring->sw_tail) {
+			err = -ENXIO;
+			goto err_exit;
+		}
+	} else {
+		/* Head index has wrapped around and is below tail index. */
+		if (hw_head_ < ring->sw_head || hw_head_ >= ring->sw_tail) {
+			err = -ENXIO;
+			goto err_exit;
+		}
+	}
+
 	ring->hw_head = hw_head_;
 	err = aq_hw_err_from_flags(self);
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

