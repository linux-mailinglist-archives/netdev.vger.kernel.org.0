Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49475805F5
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235916AbiGYUu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiGYUu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:50:58 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BF6140B7
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:50:57 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id pv18-20020a17090b3c9200b001f2460e8ce1so4037747pjb.3
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1Za1Aa1XyejlriGsxVodfndQYPiCoycbGfY9ypYSrVk=;
        b=WCjWFx92rpMcqBq+k47HLwVRSXboTSm3ylECC4lQ8uG8VugsZjAt8ZTygSLtkrtTw+
         GUn12mwOjnk7iexUKu4lDqJGDE1MMRZ14RpZsnTY32JcJDWV2M1soLipxHmSyhBBx4Tg
         hEFacU4wAzTwRUXfg5Ge0vYJalqQjMgMj0PfzCneZUhGct4pTkF38zDZBVJX7u2IxbfO
         C4XsFNgFvbKxNuX6G8k1rtCntwBHrDXg6xrE5yUxWbVXDuwcpBSRbn6UhqkojYj2tbA+
         vjj/rhDU/RrK318zoUQJpwBxoDrnkpXyBOT/AMoSTMJEsJ/u2EDFSANIl/39N51EkPLH
         bRrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1Za1Aa1XyejlriGsxVodfndQYPiCoycbGfY9ypYSrVk=;
        b=ALmZqHNbrYHqCx8qzHGfZpeoh1SJqzhP+0WzzzDXSSKb1Kt1TdeDJ3rKAPQ464avpF
         OSPe6OIUPLwIrfTBsMyB3LztyzwptrhUSOuqy6lmxw9UgOBNnJ9kOqm2wEopE+oks0OE
         tIs4IBtxSRvP5zJ3FxafEoKMrlV8UzrwBf0nDUzf+64x3yqp5asmk6XW2J8AjLMrNpId
         5cHSU5e3iWwhIOrdltOgq6hTNf68tySkGA34PMq+02sNVtz1S3LgVB9RgXpP8Xh0QOaL
         1oDajyb3TLmLcM61iVnvfXanGqFt4zbOTn1tnSQdxBjrpcpn8tCjUPlEnY+hPQ89Kjm3
         K0pA==
X-Gm-Message-State: AJIora/3p3cuuE23rx3bXOyyg33HmoNqBUzLHXnXqIYz8auWJGzse5Wo
        4ymY1KXWGcu2hbOKZn0JWz4PvoxZtFCpMt85mJ5Ptg==
X-Google-Smtp-Source: AGRyM1u5w6mYXW8nAhYXzl2hi+FZuzSjQ9f1UdWsS8eXCiGWHFPrLpmxbhYNP8MbCxND8xggcBp+ZKXBE3KkCVt39U3WAA==
X-Received: from abps.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:9b4])
 (user=abhishekpandit job=sendgmr) by 2002:a05:6a00:892:b0:52b:c986:c781 with
 SMTP id q18-20020a056a00089200b0052bc986c781mr14664144pfj.64.1658782257066;
 Mon, 25 Jul 2022 13:50:57 -0700 (PDT)
Date:   Mon, 25 Jul 2022 13:50:53 -0700
Message-Id: <20220725135026.1.Ia18502557c4ba9ba7cd2d1da2bae3aeb71b37e4e@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH] Bluetooth: Always set event mask on suspend
From:   Abhishek Pandit-Subedi <abhishekpandit@google.com>
To:     luiz.dentz@gmail.com, linux-bluetooth@vger.kernel.org
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

When suspending, always set the event mask once disconnects are
successful. Otherwise, if wakeup is disallowed, the event mask is not
set before suspend continues and can result in an early wakeup.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---
Observed on ChromeOS as follows:

< HCI Command: Disconnect (0x01|0x0006) plen 3
        Handle: 256
        Reason: Remote Device Terminated due to Power Off (0x15)
> HCI Event: Command Status (0x0f) plen 4
      Disconnect (0x01|0x0006) ncmd 1
        Status: Success (0x00)
@ MGMT Event: Device Disconnected (0x000c) plen 8
        BR/EDR Address: 04:52:C7:C3:65:B5 (Bose Corporation)
        Reason: Connection terminated by local host for suspend (0x05)
@ MGMT Event: Controller Suspended (0x002d) plen 1
        Suspend state: Disconnected and not scanning (1)
> HCI Event: Disconnect Complete (0x05) plen 4
        Status: Success (0x00)
        Handle: 256
        Reason: Connection Terminated By Local Host (0x16)

The expectation is that we should see Set Event Mask before completing
the suspend so that the `Disconnect Complete` doesn't wake us up.


 net/bluetooth/hci_sync.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 148ce629a59f..e6d804b82b67 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5297,6 +5297,9 @@ int hci_suspend_sync(struct hci_dev *hdev)
 		return err;
 	}
 
+	/* Update event mask so only the allowed event can wakeup the host */
+	hci_set_event_mask_sync(hdev);
+
 	/* Only configure accept list if disconnect succeeded and wake
 	 * isn't being prevented.
 	 */
@@ -5308,9 +5311,6 @@ int hci_suspend_sync(struct hci_dev *hdev)
 	/* Unpause to take care of updating scanning params */
 	hdev->scanning_paused = false;
 
-	/* Update event mask so only the allowed event can wakeup the host */
-	hci_set_event_mask_sync(hdev);
-
 	/* Enable event filter for paired devices */
 	hci_update_event_filter_sync(hdev);
 
-- 
2.37.1.359.gd136c6c3e2-goog

