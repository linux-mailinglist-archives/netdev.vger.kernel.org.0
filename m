Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E8B1F7FBF
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 01:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgFLXqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 19:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgFLXqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 19:46:22 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9D1C08C5C3
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 16:46:21 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b5so5031706pfp.9
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 16:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zMQlEqjqoacqpXZTlZ3YLpGiZUvYpLoVd15y+E+dpdQ=;
        b=NGNurGt0mvjvRu3TVbYjBlLXx7kZRBbxZcX1dx8qYHXbNnrnYAhK1jpSyzvbayiE51
         jUT5N2RscL+lrZSHZJk+i16ZueP/MW9JbREooTiSQ3ucp7UJzAm3biN8+KjSQnGh4Eef
         Z6N/mWieGMRZ8vWqGv599Y1jTI2X0VQopk31Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zMQlEqjqoacqpXZTlZ3YLpGiZUvYpLoVd15y+E+dpdQ=;
        b=a93IZev83ZyWxR49luDvK18K6EAefASycvYuwvDrqIdV9AQQiUgAwRKxKRaE8p79Eg
         cXmhZABZ1fl36yn7eSl52AjPDzOQTpEapm8UzkHBysX8EHBM4e4P0Lv1gdziGie7cXxB
         hS0JJ7kRbKvzCWZwuErPqUzOCm2QiGkslKGoM1U9lHTeW0YVclfilxXamgx0RuHPPhnf
         QXh4yyYnBx4RmZg97Y9Ev13OpqhlfcOZKBwX3NWs/Gw1RHZnkUQZre4t2rxFpsyABhWx
         FOOGAyMQ3qhVj1bMngkji9pC2hWIpVNcjRmL9e0TRkdQRUNtR8m6/XkC1Unadlc8PRSm
         HtkA==
X-Gm-Message-State: AOAM532Czfq686/oSMWO6ZFVcEUi3hZVIZcrlerVI+lvkE6HCKaI+aP+
        6ZwXS2czJZRWgsqhIbYnl1YrPg==
X-Google-Smtp-Source: ABdhPJwwI88y3KPf/uEawfB3t+HEZAdNVNlNRKE2cxEnE3yOADaWvv+z634q4m7eqFPim4FeU+hnzw==
X-Received: by 2002:a63:c204:: with SMTP id b4mr12500068pgd.67.1592005580978;
        Fri, 12 Jun 2020 16:46:20 -0700 (PDT)
Received: from mcchou0.mtv.corp.google.com ([2620:15c:202:201:b46:ac84:1014:9555])
        by smtp.gmail.com with ESMTPSA id b19sm6198639pjo.57.2020.06.12.16.46.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jun 2020 16:46:20 -0700 (PDT)
From:   Miao-chen Chou <mcchou@chromium.org>
To:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>
Cc:     Alain Michaud <alainm@chromium.org>,
        Michael Sun <michaelfsun@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Yoni Shavit <yshavit@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 5/7] Bluetooth: Notify adv monitor added event
Date:   Fri, 12 Jun 2020 16:45:54 -0700
Message-Id: <20200612164243.v4.5.Idb2c6bf4deb8728c363c3938b1d33057e07ca9c9@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200612164243.v4.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
References: <20200612164243.v4.1.I636f906bf8122855dfd2ba636352bbdcb50c35ed@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This notifies management sockets on MGMT_EV_ADV_MONITOR_ADDED event.

The following test was performed.
- Start two btmgmt consoles, issue a btmgmt advmon-add command on one
console and observe a MGMT_EV_ADV_MONITOR_ADDED event on the other

Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
---

Changes in v4: None
Changes in v3:
- Convert the endianness of the returned handle.

Changes in v2: None

 net/bluetooth/mgmt.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 887e193ce0038..0a1e89ce75eae 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -155,6 +155,7 @@ static const u16 mgmt_events[] = {
 	MGMT_EV_EXT_INFO_CHANGED,
 	MGMT_EV_PHY_CONFIGURATION_CHANGED,
 	MGMT_EV_EXP_FEATURE_CHANGED,
+	MGMT_EV_ADV_MONITOR_ADDED,
 };
 
 static const u16 mgmt_untrusted_commands[] = {
@@ -3853,6 +3854,16 @@ static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
 			       MGMT_STATUS_NOT_SUPPORTED);
 }
 
+static void mgmt_adv_monitor_added(struct sock *sk, struct hci_dev *hdev,
+				   u16 handle)
+{
+	struct mgmt_ev_adv_monitor_added ev;
+
+	ev.monitor_handle = cpu_to_le16(handle);
+
+	mgmt_event(MGMT_EV_ADV_MONITOR_ADDED, hdev, &ev, sizeof(ev), sk);
+}
+
 static int read_adv_monitor_features(struct sock *sk, struct hci_dev *hdev,
 				     void *data, u16 len)
 {
@@ -3905,8 +3916,8 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 	struct mgmt_rp_add_adv_patterns_monitor rp;
 	struct adv_monitor *m = NULL;
 	struct adv_pattern *p = NULL;
+	unsigned int mp_cnt = 0, prev_adv_monitors_cnt;
 	__u8 cp_ofst = 0, cp_len = 0;
-	unsigned int mp_cnt = 0;
 	int err, i;
 
 	BT_DBG("request for %s", hdev->name);
@@ -3970,6 +3981,8 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 
 	hci_dev_lock(hdev);
 
+	prev_adv_monitors_cnt = hdev->adv_monitors_cnt;
+
 	err = hci_add_adv_monitor(hdev, m);
 	if (err) {
 		if (err == -ENOSPC) {
@@ -3980,6 +3993,9 @@ static int add_adv_patterns_monitor(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
+	if (hdev->adv_monitors_cnt > prev_adv_monitors_cnt)
+		mgmt_adv_monitor_added(sk, hdev, m->handle);
+
 	hci_dev_unlock(hdev);
 
 	rp.monitor_handle = cpu_to_le16(m->handle);
-- 
2.26.2

