Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4291C4AA8
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 01:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgEDXyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 19:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728487AbgEDXxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 19:53:55 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98764C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 16:53:55 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id q7so628127qkf.3
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 16:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J9/+jSfAO5uVtsy08VBfE/cXZ1ZZuTjaQBRNqSysMl8=;
        b=qNEfM6KCHAQ3DFoPRFMlee13HOCpIwYim87Gg36Ug3SycsFMIj0B1izfcG9F3uJ/jh
         NjFkISB2tC3cr0tzUq2MTkDgYdsBpog28NPcHcVTtDZioPpu9+IjctkVgvbaHbRqYJtL
         Gi7us4ob5RRTC166S8lqViKknPMz4uWBTqyeFUMNs+W+Erk6rM7JFQv+v8oxak7uFWN8
         xy5RykBq5EFHsw3mw3Mpr2sbrjSdm3HGuO5Dh4vtM3KLqozCvdtVj+bRDE0MjiEd0FXs
         PevAvWF7f63R8RXOJahOwqaSCR2p0O+yrPupKNnKCQcddsZYGNR3Mi8UXw0QQ9wqHBSy
         xuww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J9/+jSfAO5uVtsy08VBfE/cXZ1ZZuTjaQBRNqSysMl8=;
        b=eQR0cBnLLIzk/Tnpzd8YS71v6tCudXbo4cXmMlyKQfQh/MEJwtYf46e22zrsUAdtEH
         2gWNZqJCmspEm9mVeoLu+LFUwo8bJUN+ukpGCJLNItC6qgA3Bx/0Ck6zPA+zZDspPMl/
         yQUhLic833ydViTHPs9X8j7BF5g2vE7GTMJJcYNhtAyFnr7fEKxQDNUNvdxQl8cObXtj
         CT505TIg95ARfo/T+dZMBHY1dBYHzTTQCJDgaIy2mm07ZmVpccwAbDPYw7Myt/8OvAla
         65/hCFMGbMwCWF/9cpip0idMkGUmYY393JUMU7Dot4wK8akcsW6Uh7ZYf5Eu5yX9I+bC
         0GbA==
X-Gm-Message-State: AGi0PuaocJ2F+7mbq/INLuR2aXuEj/i02is7dGB7yOYpTTQPk3C6c6g0
        nl1dPEzlE7HaJ6vjgs8zQDypqg==
X-Google-Smtp-Source: APiQypLzRcE16QGkqp2iQMTOxWic29/SV6Cm5W9uXk/J8SHsYprpZDXvSq5Of6c1xf3rZIxAa6cPQA==
X-Received: by 2002:a05:620a:1521:: with SMTP id n1mr917818qkk.293.1588636434782;
        Mon, 04 May 2020 16:53:54 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z18sm296004qti.47.2020.05.04.16.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 16:53:54 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] net: ipa: don't retry in ipa_endpoint_stop()
Date:   Mon,  4 May 2020 18:53:43 -0500
Message-Id: <20200504235345.17118-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200504235345.17118-1-elder@linaro.org>
References: <20200504235345.17118-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only reason ipa_endpoint_stop() had a retry loop was that the
just-removed workaround required an IPA DMA command to occur between
attempts.  The gsi_channel_stop() call that implements the stop does
its own retry loop, to cover a channel's transition from started to
stop-in-progress to stopped state.

Get rid of the unnecessary retry loop in ipa_endpoint_stop().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index c20a5a32fbaa..4939fdd3fca0 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -32,8 +32,6 @@
 /* The amount of RX buffer space consumed by standard skb overhead */
 #define IPA_RX_BUFFER_OVERHEAD	(PAGE_SIZE - SKB_MAX_ORDER(NET_SKB_PAD, 0))
 
-#define IPA_ENDPOINT_STOP_RX_RETRIES		10
-
 #define IPA_ENDPOINT_RESET_AGGR_RETRY_MAX	3
 #define IPA_AGGR_TIME_LIMIT_DEFAULT		1000	/* microseconds */
 
@@ -1254,20 +1252,9 @@ static void ipa_endpoint_reset(struct ipa_endpoint *endpoint)
  */
 int ipa_endpoint_stop(struct ipa_endpoint *endpoint)
 {
-	u32 retries = IPA_ENDPOINT_STOP_RX_RETRIES;
-	int ret;
+	struct gsi *gsi = &endpoint->ipa->gsi;
 
-	do {
-		struct gsi *gsi = &endpoint->ipa->gsi;
-
-		ret = gsi_channel_stop(gsi, endpoint->channel_id);
-		if (ret != -EAGAIN || endpoint->toward_ipa)
-			break;
-
-		msleep(1);
-	} while (retries--);
-
-	return retries ? ret : -EIO;
+	return gsi_channel_stop(gsi, endpoint->channel_id);
 }
 
 static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
-- 
2.20.1

