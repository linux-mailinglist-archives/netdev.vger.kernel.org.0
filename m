Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781AD26CAF8
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgIPUUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbgIPUQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 16:16:16 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFB8C06178C
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 13:16:13 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id a13so5494982qvl.6
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 13:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ouJiHCy9pxH2T5sj1WvYnJy8YM/MOUySnAX+tlwL2Gg=;
        b=UH8BwLtkHWhbvtlrnOx6o/E+DHvd5pUr9rXriuBNxKQ8cgR4HYRcjlG+1Uhz8PsJmJ
         iszKYxgls1Lm7qMJE++pD96lGlHyUh6T0EQt7h+KYlbxQNyRF/225JVRS1z1M+f2ktnv
         am1k7dS8Ju9FsCpWZDUHpgA7ZyF8ETcqT5BSEwwzq33wM3QmAAsObTZHr7aAmTnsrdX5
         ePRCv3rBzh64mrTm/pMOgQ8mi7T/yuxblGUjCdKoGi1ZXR6paZ3NSB+GlzlHa5GUrs2l
         df5UN0cmCy7Wd7NDRDmV/WikaCe3inVRL2MehUEmzlsWoAxkHQ7m7YNdNN65NsAGLy/E
         qb6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ouJiHCy9pxH2T5sj1WvYnJy8YM/MOUySnAX+tlwL2Gg=;
        b=Fj6XbZ77bHuz8i/AD4M/3LoX71Mxj8VA1i3CR+owe/jiyjo9yqGmHcviA5ZI3F9lLP
         CKUUsiq6cYiIp+y2doeOPnUyDaWF0jDuF2O3HDITTikHDi+8aSH2r+79f3+J9pLl4Rj2
         kDjiaofmjF3Zul70ksTo3+wowLQsHDFAVQ8zcDrI62l9KEKH7PcFBA8Azu0x1aYROymr
         xMa3fJ3QK2xfCmrPOuEX1IjFDX9VMonKfTSejkxKJv7ETgQ4RSIYk6xbLrIaoWnh2mkH
         iRwZsx9eLSgtyDe3ksfu7JaWUvMx+4lSAbToVo0vAmi3PbQX+W/RDj+vcNNhbFXbJnXC
         N/bA==
X-Gm-Message-State: AOAM531MvycaBWthvo0eqVkg/hWRHSZl1mMUiPSYGGewij5rC9MTEV0m
        Av4PM9dLaPCCyJjQTx01y/O/TLcQsXQbkU3MeVid
X-Google-Smtp-Source: ABdhPJyOpQ4N29pZDC8hPDv7B7QRLfS+4nlHD81FOSX8Yz1lGNTqb8jjD+/PxRtpoZl1uLpN42r/+zYEa3sofnMw/bLj
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:ad4:57cc:: with SMTP id
 y12mr8902976qvx.48.1600287371193; Wed, 16 Sep 2020 13:16:11 -0700 (PDT)
Date:   Wed, 16 Sep 2020 13:15:57 -0700
In-Reply-To: <20200916201602.1223002-1-danielwinkler@google.com>
Message-Id: <20200916131430.1.I5f4fa6a76fe81f977f78f06b7e68ff1c76c6bddf@changeid>
Mime-Version: 1.0
References: <20200916201602.1223002-1-danielwinkler@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH 1/6] Bluetooth: Add helper to set adv data
From:   Daniel Winkler <danielwinkler@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Daniel Winkler <danielwinkler@google.com>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We wish to handle advertising data separately from advertising
parameters in our new MGMT requests. This change adds a helper that
allows the advertising data and scan response to be updated for an
existing advertising instance.

Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
Signed-off-by: Daniel Winkler <danielwinkler@google.com>
---

 include/net/bluetooth/hci_core.h |  3 +++
 net/bluetooth/hci_core.c         | 31 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 9873e1c8cd163b..300b3572d479e1 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1291,6 +1291,9 @@ int hci_add_adv_instance(struct hci_dev *hdev, u8 instance, u32 flags,
 			 u16 adv_data_len, u8 *adv_data,
 			 u16 scan_rsp_len, u8 *scan_rsp_data,
 			 u16 timeout, u16 duration);
+int hci_set_adv_instance_data(struct hci_dev *hdev, u8 instance,
+			 u16 adv_data_len, u8 *adv_data,
+			 u16 scan_rsp_len, u8 *scan_rsp_data);
 int hci_remove_adv_instance(struct hci_dev *hdev, u8 instance);
 void hci_adv_instances_set_rpa_expired(struct hci_dev *hdev, bool rpa_expired);
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 8a2645a8330137..3f73f147826409 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3005,6 +3005,37 @@ int hci_add_adv_instance(struct hci_dev *hdev, u8 instance, u32 flags,
 	return 0;
 }
 
+/* This function requires the caller holds hdev->lock */
+int hci_set_adv_instance_data(struct hci_dev *hdev, u8 instance,
+			      u16 adv_data_len, u8 *adv_data,
+			      u16 scan_rsp_len, u8 *scan_rsp_data)
+{
+	struct adv_info *adv_instance;
+
+	adv_instance = hci_find_adv_instance(hdev, instance);
+
+	/* If advertisement doesn't exist, we can't modify its data */
+	if (!adv_instance)
+		return -ENOENT;
+
+	if (adv_data_len) {
+		memset(adv_instance->adv_data, 0,
+		       sizeof(adv_instance->adv_data));
+		memcpy(adv_instance->adv_data, adv_data, adv_data_len);
+		adv_instance->adv_data_len = adv_data_len;
+	}
+
+	if (scan_rsp_len) {
+		memset(adv_instance->scan_rsp_data, 0,
+		       sizeof(adv_instance->scan_rsp_data));
+		memcpy(adv_instance->scan_rsp_data,
+		       scan_rsp_data, scan_rsp_len);
+		adv_instance->scan_rsp_len = scan_rsp_len;
+	}
+
+	return 0;
+}
+
 /* This function requires the caller holds hdev->lock */
 void hci_adv_monitors_clear(struct hci_dev *hdev)
 {
-- 
2.28.0.618.gf4bc123cb7-goog

