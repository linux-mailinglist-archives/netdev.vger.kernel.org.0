Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8A53057BD
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 11:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S316773AbhAZXJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731451AbhAZS5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 13:57:39 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF8AC061356
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 10:57:14 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id z22so35766836ioh.9
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 10:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4XCw/DKlPzbfEbK7Wq85mEUjWal6SYNVmWAVH0HVNQI=;
        b=ttpVKqscHXaGViXdvSusZvZERSWcJPWvYrFU9sZywNA8AMsbqBK3qqsXM+VmaQ0sAx
         6pDXe50mX9MdwXdzf6HPA/JAeCOMg1wiI2BrTO10adpMmHAcSDrSsDFlyrcjTpQdhlMr
         kq6xvoIFeT4GX4IGY1llEZ4fW/aFINUcCcBaCCWM6L9v3VWnSa2L3YFGcN+ndos8iVwU
         jkGwlD+KXlet9d1CMy44S6GkaJS6lX4jaDKEO8SagXVkwNrm1xyhbgixjsMbtWd69td7
         /ujPltyUdXWNCWqJ+U1d9Jst10Xm24X8NXzBGKvjnMbKx9O0SS0u4wPzJwENRRf5JOhQ
         i8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4XCw/DKlPzbfEbK7Wq85mEUjWal6SYNVmWAVH0HVNQI=;
        b=sLF4+wFBK2aDzQLJjV1nsheOLH958QOc/izsVXwC3QkOMO4D4SFqam0qFNMqZeBOpZ
         SIRhXkzdqSmQpgSN72/sqXO5RHENp2uIQ7W3wbSRJaCE/bASX/G9/A3tWTZLTMa7DLr+
         U4HILrP8tKHUN1bSnn8YjA1USy3LSSIhEUn74qrEZ65pXPgaM42oqj/KjFyQ+8AJmJIv
         oTZUf6XhJvPx9tZoulYoEcRvMQfaPnjYRlSMiUySxrc0VvfHCErZ8ILcB8BsC7DzguIQ
         9TAKX4fF9zauYe2nR+a4FOy97bRnIZJuQVrCwbfw4GgCN8C/GaIJLtdrF4DNJvlYqprJ
         ds8Q==
X-Gm-Message-State: AOAM533q/NhWKhb+yCqfllA/UvjiKEjh/1XK8FP5vdBv65q3zWPh5Bm3
        GqX4pf8tpLjJZFHrnmr7fB8VtUWUt7Bt9g==
X-Google-Smtp-Source: ABdhPJxmdBae+jtQZrJUa1v7TtQbok3Z7C9DRv/TjW+uO6wbi2nuXcDzIrtbFLX44XiFXIP40gmBlg==
X-Received: by 2002:a05:6e02:541:: with SMTP id i1mr5962831ils.295.1611687433855;
        Tue, 26 Jan 2021 10:57:13 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l14sm13060681ilh.58.2021.01.26.10.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 10:57:13 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 6/6] net: ipa: don't pass size to ipa_cmd_transfer_add()
Date:   Tue, 26 Jan 2021 12:57:03 -0600
Message-Id: <20210126185703.29087-7-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210126185703.29087-1-elder@linaro.org>
References: <20210126185703.29087-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only time we transfer data (rather than issuing a command) out
of the AP->command TX endpoint is when we're clearing the hardware
pipeline.  All that's needed is a "small" data buffer, and its
contents aren't even important.

For convenience, we just transfer a command structure in this case
(it's already mapped for DMA).  The TRE is added to a transaction
using ipa_cmd_ip_tag_status_add(), but we ignore the size value
provided to that function.  So just get rid of the size argument.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index eb50e7437359a..97b50fee60089 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -550,7 +550,7 @@ static void ipa_cmd_ip_tag_status_add(struct gsi_trans *trans)
 }
 
 /* Issue a small command TX data transfer */
-static void ipa_cmd_transfer_add(struct gsi_trans *trans, u16 size)
+static void ipa_cmd_transfer_add(struct gsi_trans *trans)
 {
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
 	enum dma_data_direction direction = DMA_TO_DEVICE;
@@ -558,8 +558,6 @@ static void ipa_cmd_transfer_add(struct gsi_trans *trans, u16 size)
 	union ipa_cmd_payload *payload;
 	dma_addr_t payload_addr;
 
-	/* assert(size <= sizeof(*payload)); */
-
 	/* Just transfer a zero-filled payload structure */
 	payload = ipa_cmd_payload_alloc(ipa, &payload_addr);
 
@@ -590,7 +588,7 @@ void ipa_cmd_pipeline_clear_add(struct gsi_trans *trans)
 	endpoint = ipa->name_map[IPA_ENDPOINT_AP_LAN_RX];
 	ipa_cmd_ip_packet_init_add(trans, endpoint->endpoint_id);
 	ipa_cmd_ip_tag_status_add(trans);
-	ipa_cmd_transfer_add(trans, 4);
+	ipa_cmd_transfer_add(trans);
 }
 
 /* Returns the number of commands required to clear the pipeline */
-- 
2.20.1

