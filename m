Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656B04A8962
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352526AbiBCRJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352560AbiBCRJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:09:45 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681B3C06175D
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 09:09:44 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id i1so2658834ils.5
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 09:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TIZyuqBufxAitJOiYAoUO6ML7BGyW72LuYL7A9Zd06I=;
        b=l0cNK/ZoNnrcd1AYeAyM4hvz0Xi7q+a9VciorTZrJw/NQUe/pu0lWzj2GADHrJT/G8
         L8mxRxQ4zJDPW3+Jrl6QFjLJFUlBQtFwDTI/HqZdN8Hm9CKwLYQL5sRCNQsRoF9KNYet
         Yw35Zk988oetFskQSyg2D6XV8d+TeHry9855Rq4qWIUZOcpgjqCT1XFJFvlwYOLQEevY
         aYMmaJHb44yUKpY1rRBqc75CtGitB/ayOiXx5SjGgYkloywhg7mSgLRHRMg6n7yd375G
         5dlrxRdCEeb75z8OiBmGTz4GqsbsU+IuuO8vAw6Fc8K2GMP4skS8H15oOFxouzHteLTP
         xbRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TIZyuqBufxAitJOiYAoUO6ML7BGyW72LuYL7A9Zd06I=;
        b=Hyb+3MfDVjPy7iyQhO240VMlkWKnjYrOIk709/jrOFdhkdDqmJpe57P5ZcmuLkJ8Yz
         sJOfepAvPkDa85thjwKi1BzxOjCUUaDtTfTha5NrF/hoYvjQUBllt28iApiskm4WPi6q
         IiC0RfuSCxziRLODOg4kvlios5pkosSysXxO/QshRCcpfBzqMWevJrQrfVfldqd5TSf0
         9Wl/DLU1HXWEDwqCAIljqKtsw36k88GTcIuHjZAnPPT/Kjtenfegppuf0hGroC9WBJdM
         FX1QAdrnUP7K52YPh79KvK0cJW4MveW88prpslVQvCPVQsYFIy06dgpbVzyHWDf8/Z0Q
         280A==
X-Gm-Message-State: AOAM532pevUir2yKP21xYDiKtlN7I78C5kbjMa0ZAkfIi3XFz1TzgIx6
        putf59TeUz/bOHK8FAf5wOhRgw==
X-Google-Smtp-Source: ABdhPJyk0r+iDfI5LvKb3rFl035/2uwyP9pIu2kHmets5AjQAqhM+87VIbldc+yqFQkHFsIgl4i4pw==
X-Received: by 2002:a05:6e02:2163:: with SMTP id s3mr19853641ilv.244.1643908183577;
        Thu, 03 Feb 2022 09:09:43 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m12sm21869671iow.54.2022.02.03.09.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 09:09:43 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, mka@chromium.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, avuyyuru@codeaurora.org,
        jponduru@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 08/10] net: ipa: kill replenish_backlog
Date:   Thu,  3 Feb 2022 11:09:25 -0600
Message-Id: <20220203170927.770572-9-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220203170927.770572-1-elder@linaro.org>
References: <20220203170927.770572-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We no longer use the replenish_backlog atomic variable to decide
when we've got work to do providing receive buffers to hardware.
Basically, we try to keep the hardware as full as possible, all the
time.  We keep supplying buffers until the hardware has no more
space for them.

As a result, we can get rid of the replenish_backlog field and the
atomic operations performed on it.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 7 -------
 drivers/net/ipa/ipa_endpoint.h | 2 --
 2 files changed, 9 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index b854a39c69925..9d875126a360e 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1086,7 +1086,6 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint)
 		return;
 
 	while ((trans = ipa_endpoint_trans_alloc(endpoint, 1))) {
-		WARN_ON(!atomic_dec_not_zero(&endpoint->replenish_backlog));
 		if (ipa_endpoint_replenish_one(endpoint, trans))
 			goto try_again_later;
 
@@ -1105,9 +1104,6 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint)
 	gsi_trans_free(trans);
 	clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
 
-	/* The last one didn't succeed, so fix the backlog */
-	atomic_inc(&endpoint->replenish_backlog);
-
 	/* Whenever a receive buffer transaction completes we'll try to
 	 * replenish again.  It's unlikely, but if we fail to supply even
 	 * one buffer, nothing will trigger another replenish attempt.
@@ -1346,7 +1342,6 @@ static void ipa_endpoint_rx_complete(struct ipa_endpoint *endpoint,
 	struct page *page;
 
 	ipa_endpoint_replenish(endpoint);
-	atomic_inc(&endpoint->replenish_backlog);
 
 	if (trans->cancelled)
 		return;
@@ -1693,8 +1688,6 @@ static void ipa_endpoint_setup_one(struct ipa_endpoint *endpoint)
 		 */
 		clear_bit(IPA_REPLENISH_ENABLED, endpoint->replenish_flags);
 		clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
-		atomic_set(&endpoint->replenish_backlog,
-			   gsi_channel_tre_max(gsi, endpoint->channel_id));
 		INIT_DELAYED_WORK(&endpoint->replenish_work,
 				  ipa_endpoint_replenish_work);
 	}
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index c95816d882a74..9a37f9387f011 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -66,7 +66,6 @@ enum ipa_replenish_flag {
  * @netdev:		Network device pointer, if endpoint uses one
  * @replenish_flags:	Replenishing state flags
  * @replenish_ready:	Number of replenish transactions without doorbell
- * @replenish_backlog:	Number of buffers needed to fill hardware queue
  * @replenish_work:	Work item used for repeated replenish failures
  */
 struct ipa_endpoint {
@@ -86,7 +85,6 @@ struct ipa_endpoint {
 	/* Receive buffer replenishing for RX endpoints */
 	DECLARE_BITMAP(replenish_flags, IPA_REPLENISH_COUNT);
 	u32 replenish_ready;
-	atomic_t replenish_backlog;
 	struct delayed_work replenish_work;		/* global wq */
 };
 
-- 
2.32.0

