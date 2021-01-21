Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6C32FE961
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 12:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729940AbhAULzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 06:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730789AbhAULtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 06:49:08 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A092C0613CF
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 03:48:26 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id d81so3378448iof.3
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 03:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G8bjLZpoNIzOiv6PkD0iZ3h3ctPEFqZsMrd34LvNS2U=;
        b=JAFtsJX4NG1ehyjtn4swO/HcsgonIYApimTOBD7fbZ9tIigJYaY/JUxrpOotUR/PzP
         jDeiPwxedRzEvUGtRCjQZMWVX73vHZO3kctNZcWeLjrRh2P8IOeaX/jGkEhFCh3tW0lL
         MI2HeR8e6xBFvtT5R+H4lqjqD5h6BqzhNc9X2deLpWCopIZSPSAFWfcXvGPGXLKDCrRp
         0DtMV50E2Qfh5WSvjZF7QsCpOsQyFJBheLSAhNAP45XB1eblAqhxjNhHof2kc6ghBDL3
         F5c4jIy4QNdQ89ps3HFOVHCPF4nKOUarcUFgxOlb3lIMFLzPF4n4YQ0hchwQ2jZoFZbs
         Km2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G8bjLZpoNIzOiv6PkD0iZ3h3ctPEFqZsMrd34LvNS2U=;
        b=BeUaN1Tf5WsmJe+H9nIrxnFXPB4UahibRv8S7OOgy6tZOm4kIAokj9H+jRuBo88lMP
         gHUFz+pf7uqyvu+Mn8Jao+SJxCqceRgiHQrVj3GF+C4OQBsMNXd86sS9q2J0TOQkJHuG
         CL/7TnbEfi8pthyLGu46387/IH6Vw072YfPSi4KVFXB+h8TQKk9dRlHns2Gt8Xa8jPDL
         1nSQ3F3gM+ga9WwbbDqI0G0oLEdU6opGnIOVjEEndYT0dcU+shQk7s96mIzWgwL4r5VH
         Uj5vPRLcRCBIifrY1ZIpdM6kYE9d0NxSqt3iXlcQa/ctfbafqGuQshPL/SGupwDDwys3
         lg+A==
X-Gm-Message-State: AOAM532XRAtLtq3nxh4qL8EEgPiJArsdWT/93T0eKyR/aeme1Ao1SlNG
        8ZinOY3X756RuQINgnNQChmdO4Ce2ELkfw==
X-Google-Smtp-Source: ABdhPJxytns9aBX5a8j4JwVqUs2zc65IoCheMmpZXI6bDL2dn2AV/tjCM1VWX4T5viHR5LpiMREimQ==
X-Received: by 2002:a92:8587:: with SMTP id f129mr11964455ilh.119.1611229705925;
        Thu, 21 Jan 2021 03:48:25 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id p5sm2762766ilm.80.2021.01.21.03.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 03:48:25 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/5] net: ipa: count actual work done in gsi_channel_poll()
Date:   Thu, 21 Jan 2021 05:48:17 -0600
Message-Id: <20210121114821.26495-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210121114821.26495-1-elder@linaro.org>
References: <20210121114821.26495-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is an off-by-one problem in gsi_channel_poll().  The count of
transactions completed is incremented each time through the loop
*before* determining whether there is any more work to do.  As a
result, if we exit the loop early the counter its value is one more
than the number of transactions actually processed.

Instead, increment the count after processing, to ensure it reflects
the number of processed transactions.  The result is more naturally
described as a for loop rather than a while loop, so change that.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 5b29f7d9d6ac1..56a5eb61b20c4 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1543,13 +1543,12 @@ static struct gsi_trans *gsi_channel_poll_one(struct gsi_channel *channel)
 static int gsi_channel_poll(struct napi_struct *napi, int budget)
 {
 	struct gsi_channel *channel;
-	int count = 0;
+	int count;
 
 	channel = container_of(napi, struct gsi_channel, napi);
-	while (count < budget) {
+	for (count = 0; count < budget; count++) {
 		struct gsi_trans *trans;
 
-		count++;
 		trans = gsi_channel_poll_one(channel);
 		if (!trans)
 			break;
-- 
2.20.1

