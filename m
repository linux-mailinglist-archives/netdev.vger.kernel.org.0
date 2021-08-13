Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DDD3EBA6C
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 18:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238019AbhHMQwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 12:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237397AbhHMQw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 12:52:28 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373D9C0617AF
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 09:52:00 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id qe12-20020a17090b4f8c00b00179321cbae7so6218200pjb.2
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 09:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LkBqhPYKF4IrcGjJi8/l5drU8dbI+zT/Lqp79I46kx8=;
        b=npwlEJFKPOqclNCInH8A646c+VISLbhAlRJVKy4wjoOK8F9i0H7o6zIp5lhOoh48Of
         +RFY6gwpkU/293kuAP/cQOvYvTBeVeq6mwwIqR9itkuSHjLCC/V+MQtmU627ZqHyWJnK
         JGkw51EQOtTlm7mE2nIEYm9NjMGksyUTNp7No=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LkBqhPYKF4IrcGjJi8/l5drU8dbI+zT/Lqp79I46kx8=;
        b=ml4uPPMoDx2HDCFFUJxCzknkbEIyQFdP5gYy5M75bHhBwuqSJLPeIiblR7N7WxExYd
         cJbPFHLrO0J0uXEfpORNbJ3Y2MAPP19tSyNApmB9j43lwyx5bPr4v43cu4qxtbJaaa7k
         WHaXcdAsUU86AltRHXLyCe3z0SuiWl2GlA6rRAah8igXSoHj7EjvCYVgrfCaOpaW0cXo
         OuchrsLe6+UVHX9B9m4EXXz6hT4nSSp8tEms1SWi9V4nS2MXQ52tr5t+uceJBbl9A3VI
         eY5LvCrrFsK3zn8pA1THK0gRKArOrodHIEJ+/5aeelJU1yI1LcbKFcu1Au6+Sm4RaZvB
         EEow==
X-Gm-Message-State: AOAM530SE79xtw6jD1F3cS5INcv14YsTJT1aFZsuulxj+nkH1wyMd/pe
        4KdhEwGd+0iaTvaa6T+FgmQXFg==
X-Google-Smtp-Source: ABdhPJxl5WsATksAAGyWNUqC1ngjXvIATDXUDX9bRcQ8bWTaSfHx3+gYcDhgayfBRD3E3NDpJNoiqA==
X-Received: by 2002:a63:f241:: with SMTP id d1mr3096903pgk.424.1628873519791;
        Fri, 13 Aug 2021 09:51:59 -0700 (PDT)
Received: from josephsih-z840.tpe.corp.google.com ([2401:fa00:1:10:755d:cdee:3203:71c5])
        by smtp.gmail.com with ESMTPSA id w3sm2907407pfn.96.2021.08.13.09.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 09:51:59 -0700 (PDT)
From:   Joseph Hwang <josephsih@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, pali@kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org, josephsih@google.com,
        Joseph Hwang <josephsih@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v8 3/5] Bluetooth: refactor set_exp_feature with a feature table
Date:   Sat, 14 Aug 2021 00:51:46 +0800
Message-Id: <20210814005024.v8.3.Ibd93c7f71f8819d2efdfa3ee2f096319e3c44ea4@changeid>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
In-Reply-To: <20210814005024.v8.1.I41aec59e65ffd3226d368dabeb084af13cc133c8@changeid>
References: <20210814005024.v8.1.I41aec59e65ffd3226d368dabeb084af13cc133c8@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch refactors the set_exp_feature with a feature table
consisting of UUIDs and the corresponding callback functions.
In this way, a new experimental feature setting function can be
simply added with its UUID and callback function.

Signed-off-by: Joseph Hwang <josephsih@chromium.org>
---

Changes in v8:
- Refactor the set_exp_feature function with a feature table.
- This is a new patch added in v8.

 net/bluetooth/mgmt.c | 248 +++++++++++++++++++++++++------------------
 1 file changed, 142 insertions(+), 106 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 1e21e014efd2..ffd526b2beab 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -3806,7 +3806,7 @@ static const u8 rpa_resolution_uuid[16] = {
 static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
 				  void *data, u16 data_len)
 {
-	char buf[62];	/* Enough space for 3 features */
+	char buf[62];   /* Enough space for 3 features */
 	struct mgmt_rp_read_exp_features_info *rp = (void *)buf;
 	u16 idx = 0;
 	u32 flags;
@@ -3892,150 +3892,186 @@ static int exp_debug_feature_changed(bool enabled, struct sock *skip)
 }
 #endif
 
-static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
-			   void *data, u16 data_len)
+#define EXP_FEAT(_uuid, _set_func)	\
+{					\
+	.uuid = _uuid,			\
+	.set_func = _set_func,		\
+}
+
+/* The zero key uuid is special. Multiple exp features are set through it. */
+static int set_zero_key_func(struct sock *sk, struct hci_dev *hdev,
+			     struct mgmt_cp_set_exp_feature *cp, u16 data_len)
 {
-	struct mgmt_cp_set_exp_feature *cp = data;
 	struct mgmt_rp_set_exp_feature rp;
 
-	bt_dev_dbg(hdev, "sock %p", sk);
-
-	if (!memcmp(cp->uuid, ZERO_KEY, 16)) {
-		memset(rp.uuid, 0, 16);
-		rp.flags = cpu_to_le32(0);
+	memset(rp.uuid, 0, 16);
+	rp.flags = cpu_to_le32(0);
 
 #ifdef CONFIG_BT_FEATURE_DEBUG
-		if (!hdev) {
-			bool changed = bt_dbg_get();
+	if (!hdev) {
+		bool changed = bt_dbg_get();
 
-			bt_dbg_set(false);
+		bt_dbg_set(false);
 
-			if (changed)
-				exp_debug_feature_changed(false, sk);
-		}
+		if (changed)
+			exp_debug_feature_changed(false, sk);
+	}
 #endif
 
-		if (hdev && use_ll_privacy(hdev) && !hdev_is_powered(hdev)) {
-			bool changed = hci_dev_test_flag(hdev,
-							 HCI_ENABLE_LL_PRIVACY);
+	if (hdev && use_ll_privacy(hdev) && !hdev_is_powered(hdev)) {
+		bool changed = hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY);
 
-			hci_dev_clear_flag(hdev, HCI_ENABLE_LL_PRIVACY);
+		hci_dev_clear_flag(hdev, HCI_ENABLE_LL_PRIVACY);
 
-			if (changed)
-				exp_ll_privacy_feature_changed(false, hdev, sk);
-		}
+		if (changed)
+			exp_ll_privacy_feature_changed(false, hdev, sk);
+	}
 
-		hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
+	hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
 
-		return mgmt_cmd_complete(sk, hdev ? hdev->id : MGMT_INDEX_NONE,
-					 MGMT_OP_SET_EXP_FEATURE, 0,
-					 &rp, sizeof(rp));
-	}
+	return mgmt_cmd_complete(sk, hdev ? hdev->id : MGMT_INDEX_NONE,
+				 MGMT_OP_SET_EXP_FEATURE, 0,
+				 &rp, sizeof(rp));
+}
 
 #ifdef CONFIG_BT_FEATURE_DEBUG
-	if (!memcmp(cp->uuid, debug_uuid, 16)) {
-		bool val, changed;
-		int err;
+static int set_debug_func(struct sock *sk, struct hci_dev *hdev,
+			  struct mgmt_cp_set_exp_feature *cp, u16 data_len)
+{
+	struct mgmt_rp_set_exp_feature rp;
 
-		/* Command requires to use the non-controller index */
-		if (hdev)
-			return mgmt_cmd_status(sk, hdev->id,
-					       MGMT_OP_SET_EXP_FEATURE,
-					       MGMT_STATUS_INVALID_INDEX);
+	bool val, changed;
+	int err;
 
-		/* Parameters are limited to a single octet */
-		if (data_len != MGMT_SET_EXP_FEATURE_SIZE + 1)
-			return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
-					       MGMT_OP_SET_EXP_FEATURE,
-					       MGMT_STATUS_INVALID_PARAMS);
+	/* Command requires to use the non-controller index */
+	if (hdev)
+		return mgmt_cmd_status(sk, hdev->id,
+				       MGMT_OP_SET_EXP_FEATURE,
+				       MGMT_STATUS_INVALID_INDEX);
 
-		/* Only boolean on/off is supported */
-		if (cp->param[0] != 0x00 && cp->param[0] != 0x01)
-			return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
-					       MGMT_OP_SET_EXP_FEATURE,
-					       MGMT_STATUS_INVALID_PARAMS);
+	/* Parameters are limited to a single octet */
+	if (data_len != MGMT_SET_EXP_FEATURE_SIZE + 1)
+		return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
+				       MGMT_OP_SET_EXP_FEATURE,
+				       MGMT_STATUS_INVALID_PARAMS);
 
-		val = !!cp->param[0];
-		changed = val ? !bt_dbg_get() : bt_dbg_get();
-		bt_dbg_set(val);
+	/* Only boolean on/off is supported */
+	if (cp->param[0] != 0x00 && cp->param[0] != 0x01)
+		return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
+				       MGMT_OP_SET_EXP_FEATURE,
+				       MGMT_STATUS_INVALID_PARAMS);
 
-		memcpy(rp.uuid, debug_uuid, 16);
-		rp.flags = cpu_to_le32(val ? BIT(0) : 0);
+	val = !!cp->param[0];
+	changed = val ? !bt_dbg_get() : bt_dbg_get();
+	bt_dbg_set(val);
 
-		hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
+	memcpy(rp.uuid, debug_uuid, 16);
+	rp.flags = cpu_to_le32(val ? BIT(0) : 0);
 
-		err = mgmt_cmd_complete(sk, MGMT_INDEX_NONE,
-					MGMT_OP_SET_EXP_FEATURE, 0,
-					&rp, sizeof(rp));
+	hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
 
-		if (changed)
-			exp_debug_feature_changed(val, sk);
+	err = mgmt_cmd_complete(sk, MGMT_INDEX_NONE,
+				MGMT_OP_SET_EXP_FEATURE, 0,
+				&rp, sizeof(rp));
 
-		return err;
-	}
+	if (changed)
+		exp_debug_feature_changed(val, sk);
+
+	return err;
+}
 #endif
 
-	if (!memcmp(cp->uuid, rpa_resolution_uuid, 16)) {
-		bool val, changed;
-		int err;
-		u32 flags;
+static int set_rpa_resolution_func(struct sock *sk, struct hci_dev *hdev,
+				   struct mgmt_cp_set_exp_feature *cp,
+				   u16 data_len)
+{
+	struct mgmt_rp_set_exp_feature rp;
+	bool val, changed;
+	int err;
+	u32 flags;
+
+	/* Command requires to use the controller index */
+	if (!hdev)
+		return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
+				       MGMT_OP_SET_EXP_FEATURE,
+				       MGMT_STATUS_INVALID_INDEX);
 
-		/* Command requires to use the controller index */
-		if (!hdev)
-			return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
-					       MGMT_OP_SET_EXP_FEATURE,
-					       MGMT_STATUS_INVALID_INDEX);
+	/* Changes can only be made when controller is powered down */
+	if (hdev_is_powered(hdev))
+		return mgmt_cmd_status(sk, hdev->id,
+				       MGMT_OP_SET_EXP_FEATURE,
+				       MGMT_STATUS_REJECTED);
 
-		/* Changes can only be made when controller is powered down */
-		if (hdev_is_powered(hdev))
-			return mgmt_cmd_status(sk, hdev->id,
-					       MGMT_OP_SET_EXP_FEATURE,
-					       MGMT_STATUS_REJECTED);
+	/* Parameters are limited to a single octet */
+	if (data_len != MGMT_SET_EXP_FEATURE_SIZE + 1)
+		return mgmt_cmd_status(sk, hdev->id,
+				       MGMT_OP_SET_EXP_FEATURE,
+				       MGMT_STATUS_INVALID_PARAMS);
 
-		/* Parameters are limited to a single octet */
-		if (data_len != MGMT_SET_EXP_FEATURE_SIZE + 1)
-			return mgmt_cmd_status(sk, hdev->id,
-					       MGMT_OP_SET_EXP_FEATURE,
-					       MGMT_STATUS_INVALID_PARAMS);
+	/* Only boolean on/off is supported */
+	if (cp->param[0] != 0x00 && cp->param[0] != 0x01)
+		return mgmt_cmd_status(sk, hdev->id,
+				       MGMT_OP_SET_EXP_FEATURE,
+				       MGMT_STATUS_INVALID_PARAMS);
 
-		/* Only boolean on/off is supported */
-		if (cp->param[0] != 0x00 && cp->param[0] != 0x01)
-			return mgmt_cmd_status(sk, hdev->id,
-					       MGMT_OP_SET_EXP_FEATURE,
-					       MGMT_STATUS_INVALID_PARAMS);
+	val = !!cp->param[0];
 
-		val = !!cp->param[0];
+	if (val) {
+		changed = !hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY);
+		hci_dev_set_flag(hdev, HCI_ENABLE_LL_PRIVACY);
+		hci_dev_clear_flag(hdev, HCI_ADVERTISING);
 
-		if (val) {
-			changed = !hci_dev_test_flag(hdev,
-						     HCI_ENABLE_LL_PRIVACY);
-			hci_dev_set_flag(hdev, HCI_ENABLE_LL_PRIVACY);
-			hci_dev_clear_flag(hdev, HCI_ADVERTISING);
+		/* Enable LL privacy + supported settings changed */
+		flags = BIT(0) | BIT(1);
+	} else {
+		changed = hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY);
+		hci_dev_clear_flag(hdev, HCI_ENABLE_LL_PRIVACY);
 
-			/* Enable LL privacy + supported settings changed */
-			flags = BIT(0) | BIT(1);
-		} else {
-			changed = hci_dev_test_flag(hdev,
-						    HCI_ENABLE_LL_PRIVACY);
-			hci_dev_clear_flag(hdev, HCI_ENABLE_LL_PRIVACY);
+		/* Disable LL privacy + supported settings changed */
+		flags = BIT(1);
+	}
 
-			/* Disable LL privacy + supported settings changed */
-			flags = BIT(1);
-		}
+	memcpy(rp.uuid, rpa_resolution_uuid, 16);
+	rp.flags = cpu_to_le32(flags);
 
-		memcpy(rp.uuid, rpa_resolution_uuid, 16);
-		rp.flags = cpu_to_le32(flags);
+	hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
 
-		hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
+	err = mgmt_cmd_complete(sk, hdev->id,
+				MGMT_OP_SET_EXP_FEATURE, 0,
+				&rp, sizeof(rp));
 
-		err = mgmt_cmd_complete(sk, hdev->id,
-					MGMT_OP_SET_EXP_FEATURE, 0,
-					&rp, sizeof(rp));
+	if (changed)
+		exp_ll_privacy_feature_changed(val, hdev, sk);
 
-		if (changed)
-			exp_ll_privacy_feature_changed(val, hdev, sk);
+	return err;
+}
 
-		return err;
+static const struct mgmt_exp_feature {
+	const u8 *uuid;
+	int (*set_func)(struct sock *sk, struct hci_dev *hdev,
+			struct mgmt_cp_set_exp_feature *cp, u16 data_len);
+} exp_features[] = {
+	EXP_FEAT(ZERO_KEY, set_zero_key_func),
+#ifdef CONFIG_BT_FEATURE_DEBUG
+	EXP_FEAT(debug_uuid, set_debug_func),
+#endif
+	EXP_FEAT(rpa_resolution_uuid, set_rpa_resolution_func),
+
+	/* end with a null feature */
+	EXP_FEAT(NULL, NULL)
+};
+
+static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
+			   void *data, u16 data_len)
+{
+	struct mgmt_cp_set_exp_feature *cp = data;
+	size_t i = 0;
+
+	bt_dev_dbg(hdev, "sock %p", sk);
+
+	for (i = 0; exp_features[i].uuid; i++) {
+		if (!memcmp(cp->uuid, exp_features[i].uuid, 16)) {
+			return exp_features[i].set_func(sk, hdev, cp, data_len);
 	}
 
 	return mgmt_cmd_status(sk, hdev ? hdev->id : MGMT_INDEX_NONE,
-- 
2.33.0.rc1.237.g0d66db33f3-goog

