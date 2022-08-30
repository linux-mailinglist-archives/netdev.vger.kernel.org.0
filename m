Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1675A599E
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 04:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiH3C6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 22:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiH3C6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 22:58:34 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAD3A00D2
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 19:58:33 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id z14-20020a170903018e00b00174fff57d17so1396712plg.14
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 19:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc;
        bh=mXODdFJOi47qFxuaBDFzWIBYSAQ55JCqgGs7Fum9gUw=;
        b=oXx1RFmFoaFpGoHeVLvUsAH/QO5H28u8zUgFjw5oflI5sieX1P5U3/Z7TXqAFe86GO
         clzJ4uCylokNoe46G/ldRWnVm5FQWxyZAb6g3Drk6G2HncBy0aq/ZiYBPw3tXZCcgNJy
         OLsVTH+rbA095vRPvrDH0IPRUnFUShEeEknHPwFBPCXSp01miFtUtxHrRRs1hPLWd2sV
         EfgpBLla/mP4qdmFmB+yFLWJzbc6I2c8oom4mv0o60Qu3PFpKkuWGH9htbfs9lYlxFwy
         Hp1CoE26ziYkh7cGeYjp8Fl31BKFNJNqMJYCtEGzZ1EEvEANHlEzDwPj7Av71FetwD7W
         RObg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc;
        bh=mXODdFJOi47qFxuaBDFzWIBYSAQ55JCqgGs7Fum9gUw=;
        b=mrzcgMrrx1N0W60M8hQSXIWXjjnR5gib5LOulNURZ96TtvBsXhpLEynRIJ8EUIbzoI
         afkhQ+wcqAGTnP72bfbjeg+qDsa4NJ8p8u1rQfLhuZxnzHyIBU0NuwIKqQME0s83yn7K
         rP+CWlxk0+0yR+iL/R7pykshRJ6XLOk+UutxT/XqglU6VmFjF8/P0NOsfwyS9YeAM9D6
         r2cFp9Z0ko1+1lYGZSUj0J4LcexZZqQLzkwRfZCG/7JvyWmSbXNKvUq4OB3Pmho39GWI
         1qgNcSVeeHF+pLBR1YV65V/5eZTMQcPBGlSn0RhsTzkYROQZXd1Uc883a+71+umsTEUg
         phHw==
X-Gm-Message-State: ACgBeo05aO1q7l+Y+eb7HsyI8SmGKparDBU0hgSdwzK+dbrS+6uXOAbw
        GDTG9srDdgiYqtUCsviqplxq+oV0NMIXmjn79Y8xAQ==
X-Google-Smtp-Source: AA6agR6NZUm4QwSTu5Mo0zFw2JMhgTEkHooh30Xuym1xPQd7iaesgJ1yJQcjk+QRHUx17Y2Fbclio8SH5AxJYBUx/Yd7bQ==
X-Received: from abps.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:9b4])
 (user=abhishekpandit job=sendgmr) by 2002:a63:145:0:b0:42c:1f56:2799 with
 SMTP id 66-20020a630145000000b0042c1f562799mr6647738pgb.154.1661828312961;
 Mon, 29 Aug 2022 19:58:32 -0700 (PDT)
Date:   Mon, 29 Aug 2022 19:58:26 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220829195805.1.Ic8eabc8ed89a07c3d52726dd017539069faac6c4@changeid>
Subject: [PATCH] Bluetooth: Call shutdown for HCI_USER_CHANNEL
From:   Abhishek Pandit-Subedi <abhishekpandit@google.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

Some drivers depend on shutdown being called for proper operation.
There's no reason to restrict this from being called when using
HCI_USER_CHANNEL.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---
This is easy to reproduce on QCA6174-A, which uses the hci_qca driver.
Simply open the socket, bind as userchannel and close again. It will
succeed the first time and fail the second time (because shutdown wasn't
called). A similar bug also occurs with btmtksdio (using MT7921).

Question for maintainers: What is a driver supposed to be doing during
shutdown? We should add some documentation to `struct hci_dev` to
clarify.


 net/bluetooth/hci_sync.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index e08c0503027d..be78fd708f16 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4680,7 +4680,6 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 	}
 
 	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
-	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
 	    test_bit(HCI_UP, &hdev->flags)) {
 		/* Execute vendor specific shutdown routine */
 		if (hdev->shutdown)
-- 
2.37.2.672.g94769d06f0-goog

