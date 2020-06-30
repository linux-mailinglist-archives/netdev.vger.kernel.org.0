Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B37A20F4EF
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387887AbgF3MpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387855AbgF3Mov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:44:51 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F13C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 05:44:51 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id i4so20771472iov.11
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 05:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hhprUszVmOlah4/Ur36hFj2E6ek/4IJi+AwyXGta/Jg=;
        b=KkXHJTeUKg/muI7mgvHgvdw0wHDkMhda+sgSpItV1HTVh8YztFciCNhoOjQKWdxzUb
         RMVDJrke3LdwacR2ltk3mQ0OlSf/j1AqcB3jIlm6404ZT9Heg4oq4QeMghI0Y9JH1yFr
         X97j/i2ZuE3dGuSaz3Jyz3AQSmzNzdUFS2mtYDKcvP4jlThSZRMq1vOX+UHU+vUwyn/7
         /HSw5KsZL5AQUls3hoBL7q2dOeaTdPwEpqdmtnK8DCpDvwBPV96o8Hzz3/B9dFYd7o0G
         k1SBdVn17rh2y210NAK51W80Nmjdf0VA4aJjgdKYq+75o1r6JefIpzP5NwntSVNRWgag
         gytA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hhprUszVmOlah4/Ur36hFj2E6ek/4IJi+AwyXGta/Jg=;
        b=PRrc/rmJG0fXNQU+Gm6rgtpVcZTx8cF4x5HTr/XuNlRRcGQUqcf1xbc65qyGGKZmdI
         AjW0LXD5HW5+KHeGPbqZC2xCO7elOBVCPpNWJJ5TGkJOrkf/J/VPgdx7z2rWv5/itDa5
         6WLGdEkEueTHyv4LXz2+BDkByymCMMCT0I29MBv8yzdGvgWEoNYaS9FlX+iIahNN9bkT
         2VKCOModL3ss/YB1d/lE/06s0oZkdSUFdOtEkMNeut86Nq6dTVAJ3zW1tg3tDe5qrYw8
         x9+zKfEltGDTm9XYcyVRAgt7rGnrZYxlhtrGHw6mNsUuFPUAS6UjYtPK0lF/ux45z0Vr
         xdBQ==
X-Gm-Message-State: AOAM533f20XFkqvjnuUSjxlY/utbnSUg06Qzbq/Pi2Wtsj3iaETn0iJZ
        jNo24zkO9AN0AZQ5SgkdPmXslg==
X-Google-Smtp-Source: ABdhPJx5QCzEAoSIXCAgs7Xjvdp9nA0ty9XkbxyGtHSAg4gn8mcdGAFfplB1eox2dAesFk+KXERksw==
X-Received: by 2002:a05:6602:2c8f:: with SMTP id i15mr21731390iow.45.1593521091047;
        Tue, 30 Jun 2020 05:44:51 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id t83sm1697536ilb.47.2020.06.30.05.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 05:44:50 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 3/3] net: ipa: introduce ipa_cmd_tag_process()
Date:   Tue, 30 Jun 2020 07:44:44 -0500
Message-Id: <20200630124444.1240107-4-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200630124444.1240107-1-elder@linaro.org>
References: <20200630124444.1240107-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new function ipa_cmd_tag_process() that simply allocates a
transaction, adds a tag process command to it to clear the hardware
pipeline, and commits the transaction.

Call it in from ipa_endpoint_suspend(), after suspending the modem
endpoints but before suspending the AP command TX and AP LAN RX
endpoints (which are used by the tag sequence).

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: No change from v1.

 drivers/net/ipa/ipa_cmd.c      | 15 +++++++++++++++
 drivers/net/ipa/ipa_cmd.h      |  8 ++++++++
 drivers/net/ipa/ipa_endpoint.c |  2 ++
 3 files changed, 25 insertions(+)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index c9ab865e7290..d92dd3f09b73 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -586,6 +586,21 @@ u32 ipa_cmd_tag_process_count(void)
 	return 4;
 }
 
+void ipa_cmd_tag_process(struct ipa *ipa)
+{
+	u32 count = ipa_cmd_tag_process_count();
+	struct gsi_trans *trans;
+
+	trans = ipa_cmd_trans_alloc(ipa, count);
+	if (trans) {
+		ipa_cmd_tag_process_add(trans);
+		gsi_trans_commit_wait(trans);
+	} else {
+		dev_err(&ipa->pdev->dev,
+			"error allocating %u entry tag transaction\n", count);
+	}
+}
+
 static struct ipa_cmd_info *
 ipa_cmd_info_alloc(struct ipa_endpoint *endpoint, u32 tre_count)
 {
diff --git a/drivers/net/ipa/ipa_cmd.h b/drivers/net/ipa/ipa_cmd.h
index e440aa69c8b5..1a646e0264a0 100644
--- a/drivers/net/ipa/ipa_cmd.h
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -171,6 +171,14 @@ void ipa_cmd_tag_process_add(struct gsi_trans *trans);
  */
 u32 ipa_cmd_tag_process_count(void);
 
+/**
+ * ipa_cmd_tag_process() - Perform a tag process
+ *
+ * @Return:	The number of elements to allocate in a transaction
+ *		to hold tag process commands
+ */
+void ipa_cmd_tag_process(struct ipa *ipa);
+
 /**
  * ipa_cmd_trans_alloc() - Allocate a transaction for the command TX endpoint
  * @ipa:	IPA pointer
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 9f50d0d11704..9e58e495d373 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1450,6 +1450,8 @@ void ipa_endpoint_suspend(struct ipa *ipa)
 	if (ipa->modem_netdev)
 		ipa_modem_suspend(ipa->modem_netdev);
 
+	ipa_cmd_tag_process(ipa);
+
 	ipa_endpoint_suspend_one(ipa->name_map[IPA_ENDPOINT_AP_LAN_RX]);
 	ipa_endpoint_suspend_one(ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX]);
 }
-- 
2.25.1

