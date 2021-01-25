Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CE5302DD9
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 22:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732134AbhAYVc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 16:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732710AbhAYVbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 16:31:07 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EF2C061786
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 13:29:54 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id x21so29627826iog.10
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 13:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JpZv+T7F3bf/GFAbswYSEjxp4C4JU0WA8H2GZ/JQhn0=;
        b=tTCfUMZuXXOxBVYrRDGvhRwfEDPgDy4t6wA+C8pWcN4V0hyLN2U+IXN1LwoDs0qraT
         sx4+DVP5A9M7joq5aUbhqwZvVx2F83jyJkZbt2bzhJ+gXAatK3IxpfvmbLNQ+q/s1QN7
         0fKSNRY/qKad7zA0P55n64XeTExtnnSUBhwO13w2N1NmvIU1Pz8j5b470s3px6sQZlRN
         6XfrcxpUeTT2DMCF30FnMVXepqox6mQuqJWX78r48/FQWjKq456DyNAej71Ar3qIGMyg
         pvyg/2f/mya4+umdwOIcgfF5zcZDL4NSPNlVuO7F+VRlaGQidsza29hyL3hsC/T4HmW2
         VfRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JpZv+T7F3bf/GFAbswYSEjxp4C4JU0WA8H2GZ/JQhn0=;
        b=hQ2hYMtANsRuw+seQzL8loKxv0HHBkZ+B0EyotmNnP7HoCr+buMZ8XGKQwJYMWueUY
         bxP4Y6pKiZMPf5L49vZmiqg1gy9KA8+1JOynZY/2Ti6RCUVkLzfvH68jN+MUxKhurIQM
         059qDMUcwzetJGsGYMZCXhGLkJHsINms6O8X00YzXF7FMslAqrdgfcXAlCHI+mgnMJeE
         jMP9TQ7bx/sEI0r46k52qeb7iQkxAGYe1wyh/JaGMamo1rXU0BwkaxEySCmG+xsmmJjl
         yeYq3sw5aCMB8OueLWg0zJoszoDMz9DjaTRRnPQg9X4GtkKpTUwuSNroUI1oO2XCjJKu
         QOMg==
X-Gm-Message-State: AOAM531k+mFhNYO4sP2u6F9JEwXeKOWt6Yh66aDMuUg9vmvgfSvW6t0x
        xzSrzyGiMFZCe8TSnE7W4evCAA==
X-Google-Smtp-Source: ABdhPJyzRCXz0E1tVEFkhBN9u8PRqrJEetO7mQx9rC4ivB78aX3cmT8tnDASVx4G5hhRnji9Dt0rBg==
X-Received: by 2002:a92:48ce:: with SMTP id j75mr2055154ilg.160.1611610194258;
        Mon, 25 Jan 2021 13:29:54 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o18sm11136241ioa.39.2021.01.25.13.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 13:29:53 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/6] net: ipa: minor update to handling of packet with status
Date:   Mon, 25 Jan 2021 15:29:43 -0600
Message-Id: <20210125212947.17097-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210125212947.17097-1-elder@linaro.org>
References: <20210125212947.17097-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rearrange some comments and assignments made when handling a packet
that is received with status, aiming to improve understandability.

Use DIV_ROUND_CLOSEST() to get a better per-packet true size estimate.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 39ae0dd4e0471..c5524215054c8 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1213,12 +1213,11 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 			continue;
 		}
 
-		/* Compute the amount of buffer space consumed by the
-		 * packet, including the status element.  If the hardware
-		 * is configured to pad packet data to an aligned boundary,
-		 * account for that.  And if checksum offload is is enabled
-		 * a trailer containing computed checksum information will
-		 * be appended.
+		/* Compute the amount of buffer space consumed by the packet,
+		 * including the status element.  If the hardware is configured
+		 * to pad packet data to an aligned boundary, account for that.
+		 * And if checksum offload is enabled a trailer containing
+		 * computed checksum information will be appended.
 		 */
 		align = endpoint->data->rx.pad_align ? : 1;
 		len = le16_to_cpu(status->pkt_len);
@@ -1226,16 +1225,21 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 		if (endpoint->data->checksum)
 			len += sizeof(struct rmnet_map_dl_csum_trailer);
 
-		/* Charge the new packet with a proportional fraction of
-		 * the unused space in the original receive buffer.
-		 * XXX Charge a proportion of the *whole* receive buffer?
-		 */
 		if (!ipa_status_drop_packet(status)) {
-			u32 extra = unused * len / total_len;
-			void *data2 = data + sizeof(*status);
-			u32 len2 = le16_to_cpu(status->pkt_len);
+			void *data2;
+			u32 extra;
+			u32 len2;
 
 			/* Client receives only packet data (no status) */
+			data2 = data + sizeof(*status);
+			len2 = le16_to_cpu(status->pkt_len);
+
+			/* Have the true size reflect the extra unused space in
+			 * the original receive buffer.  Distribute the "cost"
+			 * proportionately across all aggregated packets in the
+			 * buffer.
+			 */
+			extra = DIV_ROUND_CLOSEST(unused * len, total_len);
 			ipa_endpoint_skb_copy(endpoint, data2, len2, extra);
 		}
 
-- 
2.20.1

