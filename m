Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67CB3534E00
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 13:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239028AbiEZLWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 07:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347157AbiEZLWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 07:22:20 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288961128
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 04:22:01 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id a9so1070525pgv.12
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 04:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wRyXjUnbuN8AArPJcHoUjYeWkLPL7LreNSYdLAK0u9k=;
        b=B0xy+3RUGPdeJE34oJ+ShJjF1I809kPfObCH500XadV1bePmTTJKBRbAD2ieBC+ysO
         2DT6QUCgLMqGimKyXkICXmUcppD2Ndob6ILn9uZGQyL1ZIT9blB4p4eiiaosTyo08Wwo
         DFzott6m4wObq8TjrTeBfoL9XLRrNnTPpZg8Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wRyXjUnbuN8AArPJcHoUjYeWkLPL7LreNSYdLAK0u9k=;
        b=b7tkKR1cIg/qOyaeA5OOhAYYbPrnTts795y5qwblek5IRJNCWJ/aztjBtqR55SFAWz
         LPdRu4f397zDRJTs9mUaziEGvjAcBGjwh+SDl828siQ+Pj7ldJxOk1iT+Ex8RarvEG9D
         rRn2/+IS8/Xbr6Yn26Hqv6vw1Ca8Anq/TXJIgfje5bal6W4+zzwEzw12OyCNBAxI2C7Y
         eijwJp3DMZDu4XzEzL3SDYAjUw+8MS1UWOqVFM/LaQQ0jjQ9sRCikTfwAcsCjV6KuH+H
         rZqvbdo0Dq/IVimFzsM9/WvLHE6Fb8hYuZJHDMQQ/F7ri8MgQqJyE4mL6/HsjwK4IPS+
         nxCw==
X-Gm-Message-State: AOAM530nYe1MaNduO8VSLeidOPp/LscvQfZ+UGRuZ5xIAFcq3RU9p+vZ
        WpOVEgoHftKs+WBV5daPmsOSzw==
X-Google-Smtp-Source: ABdhPJxnxtIlJ7ULQJ8KTu/+loAsvXfALnBvt6eaj1i0FdCDRbJ9YrYd6QHBB+uN6hwoH0xG8m7HKg==
X-Received: by 2002:a63:82c7:0:b0:3f9:e153:6a54 with SMTP id w190-20020a6382c7000000b003f9e1536a54mr23972141pgd.409.1653564121453;
        Thu, 26 May 2022 04:22:01 -0700 (PDT)
Received: from localhost (174.71.80.34.bc.googleusercontent.com. [34.80.71.174])
        by smtp.gmail.com with UTF8SMTPSA id 2-20020a170902e9c200b001614cd997a8sm1230287plk.236.2022.05.26.04.21.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 May 2022 04:22:01 -0700 (PDT)
From:   Joseph Hwang <josephsih@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, pali@kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org, josephsih@google.com,
        Joseph Hwang <josephsih@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v6 5/5] Bluetooth: let HCI_QUALITY_REPORT persist over adapter power cycle
Date:   Thu, 26 May 2022 19:21:34 +0800
Message-Id: <20220526112135.2486883-3-josephsih@chromium.org>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
In-Reply-To: <20220526112135.2486883-1-josephsih@chromium.org>
References: <20220526112135.2486883-1-josephsih@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The quality report specifications, including AOSP Bluetooth Quality
Report and Intel Telemetry Event, do not define what happen when
the adapter is turned off and then on. To be consistent among
different specifications and vendors, the quality report feature is
turned off when the adapter is powered off and is turned on when
the adapter is powered on if the feature has been on before power
cycle.

Signed-off-by: Joseph Hwang <josephsih@chromium.org>
Reviewed-by: Archie Pusaka <apusaka@chromium.org>
---

(no changes since v5)

Changes in v5:
- This is a new patch in this series changes version.

 include/net/bluetooth/hci_core.h |  1 -
 net/bluetooth/hci_sync.c         | 35 +++++++++++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 9e48d606591e..5788350efa68 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -807,7 +807,6 @@ extern struct mutex hci_cb_list_lock;
 		hci_dev_clear_flag(hdev, HCI_LE_ADV);		\
 		hci_dev_clear_flag(hdev, HCI_LL_RPA_RESOLUTION);\
 		hci_dev_clear_flag(hdev, HCI_PERIODIC_INQ);	\
-		hci_dev_clear_flag(hdev, HCI_QUALITY_REPORT);	\
 	} while (0)
 
 #define hci_dev_le_state_simultaneous(hdev) \
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index a6ada9dcede5..12a18d046bb6 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3849,6 +3849,31 @@ static const struct {
 			 "advertised, but not supported.")
 };
 
+static void suspend_resume_quality_report(struct hci_dev *hdev, bool enable)
+{
+	int err;
+
+	/* Suspend and resume quality report only when the feature has
+	 * already been enabled. The HCI_QUALITY_REPORT flag, as an indicator
+	 * whether to re-enable the feature after resume, is not changed by
+	 * suspend/resume.
+	 */
+	if (!hci_dev_test_flag(hdev, HCI_QUALITY_REPORT))
+		return;
+
+	if (hdev->set_quality_report)
+		err = hdev->set_quality_report(hdev, enable);
+	else
+		err = aosp_set_quality_report(hdev, enable);
+
+	if (err)
+		bt_dev_err(hdev, "%s quality report error %d",
+			   enable ? "resume" : "suspend", err);
+	else
+		bt_dev_info(hdev, "%s quality report",
+			    enable ? "resume" : "suspend");
+}
+
 int hci_dev_open_sync(struct hci_dev *hdev)
 {
 	int ret = 0;
@@ -4013,6 +4038,7 @@ int hci_dev_open_sync(struct hci_dev *hdev)
 	if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
 		msft_do_open(hdev);
 		aosp_do_open(hdev);
+		suspend_resume_quality_report(hdev, true);
 	}
 
 	clear_bit(HCI_INIT, &hdev->flags);
@@ -4095,6 +4121,14 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 
 	hci_request_cancel_all(hdev);
 
+	/* Disable quality report and close aosp before shutdown()
+	 * is called. Otherwise, some chips may panic.
+	 */
+	if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
+		suspend_resume_quality_report(hdev, false);
+		aosp_do_close(hdev);
+	}
+
 	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
 	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
 	    test_bit(HCI_UP, &hdev->flags)) {
@@ -4158,7 +4192,6 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 	hci_sock_dev_event(hdev, HCI_DEV_DOWN);
 
 	if (!hci_dev_test_flag(hdev, HCI_USER_CHANNEL)) {
-		aosp_do_close(hdev);
 		msft_do_close(hdev);
 	}
 
-- 
2.36.1.124.g0e6072fb45-goog

