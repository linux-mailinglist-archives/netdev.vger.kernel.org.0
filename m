Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DD55F502A
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 09:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiJEHKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 03:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJEHJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 03:09:58 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB11CE3A
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 00:09:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f9-20020a25b089000000b006be298e2a8dso4250036ybj.20
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 00:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=0kv7LZbwVvvTCY0FDOB7BWqbGQ4uCTTTGBzanUoZ/5c=;
        b=FxjCN8MEoO/P7TtrDCci6qecuNe+mYvoZwwIqXh+ZFVTP9pYumPENqeRRVX1V57FGt
         VmIhuBShQ85+xuhfo0OJnvaY6jh6xm1uotVlGCTndMdcs7UCmW1WAr0h4F70uMgWMuHH
         k3Nk+0Q+JLMBV1jELcfeZ78+i74EuDU/xV6DFKsThsGjRsnecnMWhQS44hlzs+JMVg8x
         9C6f7nQYTmLbYrhnzMUnkSV/gp2YYiGbRQULv4uG6DMgfHXzMUFsn/AVzv7c/JJdPDPv
         L818cWJ9KOkXTuoXzFyaVhbpFcknI8CnlKiAI7vw+KTQPs6JtDBYUwqXOMHPg2V1MIwK
         mMMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=0kv7LZbwVvvTCY0FDOB7BWqbGQ4uCTTTGBzanUoZ/5c=;
        b=WvFWQsSEKA5WsFTSSqXBLsXeEotIr5KmKIZOMCYDdJZlsxExTvpXVyyGFI9Iz8Mraw
         cEWwUNUY5C2YmBDC/Hh5JdRY01XPkfCIiAAbvLeQPn3/zJUySOrqIPNKWACERGllFOY6
         DOmxWP+zXiB4BuZQWwuA/ZXSuihd41rJBi/DJY3KGNJNMSjVQf46SDHfTnV0Az/OokwU
         n2RwUiYUiB5EAL2nGHmeeQurRb7RNy5Y8in+PSw/VgxxgmOQXp+kfPe5n4SnoXNnDrwB
         nEqemyjgnDa79prcMgmH5T8SAkwY+ByqkOO2dXgMpHGGsurWEbLmq09NqEj+HIGg0HGD
         6fYg==
X-Gm-Message-State: ACrzQf3borjnbqKhnWuNDPjJwlsWKtu/Ko262MZtW4Bt1jxat7aLMftA
        uDqaq2kBniwoFKa0XelNDNz6XPrl7O6x
X-Google-Smtp-Source: AMsMyM5G6SbVAJC0wRlFyL/5sIT96s+VNQjdmgANHz/PRa0/bVmVUatteDEjIeuOfCNl1UZWWA+w/88KYR5e
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:17:499:ff69:2084:388d])
 (user=apusaka job=sendgmr) by 2002:a05:6902:1083:b0:6b1:4a11:9cf5 with SMTP
 id v3-20020a056902108300b006b14a119cf5mr29727673ybu.537.1664953794404; Wed,
 05 Oct 2022 00:09:54 -0700 (PDT)
Date:   Wed,  5 Oct 2022 15:09:47 +0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221005150934.1.Ife932473db2eec6f0bc54226c3328e5fa8c5f97b@changeid>
Subject: [PATCH] Bluetooth: hci_sync: cancel cmd_timer if hci_open failed
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
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

From: Archie Pusaka <apusaka@chromium.org>

If a command is already sent, we take care of freeing it, but we
also need to cancel the timeout as well.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@google.com>

---

 net/bluetooth/hci_sync.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 76c3107c9f91..a011065220e4 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4696,6 +4696,7 @@ int hci_dev_open_sync(struct hci_dev *hdev)
 			hdev->flush(hdev);
 
 		if (hdev->sent_cmd) {
+			cancel_delayed_work_sync(&hdev->cmd_timer);
 			kfree_skb(hdev->sent_cmd);
 			hdev->sent_cmd = NULL;
 		}
-- 
2.38.0.rc1.362.ged0d419d3c-goog

