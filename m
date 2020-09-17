Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF76126E84B
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 00:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgIQWWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 18:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgIQWWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 18:22:31 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937AFC061788
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 15:22:30 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id v14so2477718qvq.10
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 15:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=F5sPlGRRVLln1OHpY3xzu4VxzaSsS7i3+4mGVYVmXPs=;
        b=GsPrOGW9MIc4kbFKIpt6UVGvX76M+zC0Ujv+anlq/wR4MJT8KJe8SxxNHS9su1xxgB
         CUTNyENmzO9M6XR7jyLq/7rWAnxI1lM1zmb/qoqFyZH86kr1oUF7DbQzMpI1oIxC2+Rd
         Foa6Sx7xdfThDYP1ukwt/RrhOCnyZaba/0awAFw52C/5pwSVMrUkGljwbJvnEveVOJDT
         Q4kBks1NSjEs+dOFqobEXIpV8ye1V95BuAewNdVz2Aw3P7opWSYTjRcZYsIZ6fzf8U17
         1ZBkYe8iUnhkO0leJnlwvtGvC9zlG1uKKKtRBAV7sDdQz7NEJMsKB91mzcOtwQ9+hXur
         sWHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=F5sPlGRRVLln1OHpY3xzu4VxzaSsS7i3+4mGVYVmXPs=;
        b=OzAu4hg13Gdh0eaY1nHvWDo5NkW3W8vqhcjaA3KcOesyGDnXd8oVNW+bQuR5izbeVn
         233jolSTdNyoPjK6TgVqrXsY5sMMPu7UCV32DltRKC/mEow7Ow6Z2dEVmtlBBecAWptJ
         2ilmS6SC4L2SL5nu6KuPvuATW78eHu7OQEQTQckmO3SsgxgmUmhynkG1C9pfE9oZxaZk
         t2AOZS+U0jTRgsiVwaggengO0fzLxJxG306nCqZ9tsNET52tbcKJ7EAqyuxvhLZeY6FU
         ie1iEerFWAu+SOuAmpHIAoSna1WEDjTszbOf1KNH8YB9seq2ejlZ/McDR4Z8wjFYAbFp
         w9gA==
X-Gm-Message-State: AOAM530FY1IaQUR76Y2ocf4dQLu8lYNsujAUSJNnIirJ350f5HBCQQjP
        CU5mNbv4HwzePNt9abcHC7nMMTDILqmlvwy4xVkh
X-Google-Smtp-Source: ABdhPJwT7E54N7UW/26IfDYWjmdUbQmZVOUAzWq+3GViiH9dggVfK7OCbfrcvwGYeT5J98WLBWcNE+LDRxGn5fFTzLHz
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:ad4:5565:: with SMTP id
 w5mr30020818qvy.24.1600381349707; Thu, 17 Sep 2020 15:22:29 -0700 (PDT)
Date:   Thu, 17 Sep 2020 15:22:12 -0700
In-Reply-To: <20200917222217.2534502-1-danielwinkler@google.com>
Message-Id: <20200917152052.v2.1.I5f4fa6a76fe81f977f78f06b7e68ff1c76c6bddf@changeid>
Mime-Version: 1.0
References: <20200917222217.2534502-1-danielwinkler@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v2 1/6] Bluetooth: Add helper to set adv data
From:   Daniel Winkler <danielwinkler@google.com>
To:     marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        linux-bluetooth@vger.kernel.org,
        Daniel Winkler <danielwinkler@google.com>,
        Sonny Sasaka <sonnysasaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

Changes in v2: None

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
2.28.0.681.g6f77f65b4e-goog

