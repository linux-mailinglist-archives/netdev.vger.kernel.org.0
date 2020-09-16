Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8809B26CAEC
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 22:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgIPUTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 16:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbgIPUQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 16:16:46 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A80C061788
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 13:16:19 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id f12so7136388qtq.5
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 13:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=a60adGDxqttpuFcY7jkALjROpt4E168K4TU36LymXcQ=;
        b=eA0nBtfTtG7rvNCSw/DDYVnI09PSqUgQFZkOgBxrmPPULPry28kBQ0zp0YUbhQRjOY
         X/E8NDeG2osSs/7lD3gCsOLOu6QL8awcC5TyO4wVvGV1l4WEs3zzPorZGkf+tG0Ri2c8
         j/KmtiLW/tqXu9JkGdHN2Ul/PEKR3PGhKDj8Y56rE96mQ5a4BD1wPiIY9/IcPJHyLeFS
         iHodk/vtswNP5kuPqaFTYFghWdGKDEh6aPduQ6vJLD5OsSPO1fMQXHjQ1TxAOR1+lU6P
         J/WzPQC5hevNpKvZmCd5aQ8LADPabI+kYKMJuoI+pPQhlN8YDxjFM4IfqB3WMIsxuGR2
         uVow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=a60adGDxqttpuFcY7jkALjROpt4E168K4TU36LymXcQ=;
        b=dBB1wqZeMAHVOXeujbA4H1/JGyc1olpQSD1k219BGltxwpukorxew0OCrLlU8w8gQf
         f+tsZZplfj7XXPh069cnqLXqQ8tQJyW4/GmN1C4SUzFPHrrbaNCkVNKoaWadfexMzEHt
         oudFWjbnM6yFGv0QPyhGJqZ6oR1ONMh8vkfnsvJ7bRRME14WVEgR+F2hOYwdVPrCJWi1
         lFqAsPkmZjnELhiLcr+TA6nHZcRvKXlplJw3K51ootYRxk+CjCTlDnOIO3q9KMRs8pNM
         hL75bb5H9iZS2WzpVAvPfRHdL2TYBhtddX3AYar9po8BuBIjjVnJsPVV2Ap2X7xLaAVx
         biaA==
X-Gm-Message-State: AOAM532UA1o+8NpmQu25AcJnC+hwkHsJV2PTkc9WDSz5B6ilq7dpCJ55
        QJhnvNg6d6NnEdy7tKA0KJbt0qoC6OSTiBYSrx4h
X-Google-Smtp-Source: ABdhPJzfBMACV3i9Ag2je48WjOHXDjCnBloIo08bMmmfrF6UQkcJ9p9JN/Tx9z7Yh/AB7BqsJ+OmUXhXeqT6/JFDXhz1
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:f693:9fff:fef4:4e59])
 (user=danielwinkler job=sendgmr) by 2002:ad4:5653:: with SMTP id
 bl19mr24887200qvb.7.1600287378198; Wed, 16 Sep 2020 13:16:18 -0700 (PDT)
Date:   Wed, 16 Sep 2020 13:16:00 -0700
In-Reply-To: <20200916201602.1223002-1-danielwinkler@google.com>
Message-Id: <20200916131430.4.I34169001276125c476e86ece0b4802c36aa08bca@changeid>
Mime-Version: 1.0
References: <20200916201602.1223002-1-danielwinkler@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH 4/6] Bluetooth: Emit tx power chosen on ext adv params completion
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

Our hci call to set extended advertising parameters returns the actual
tx power selected by the controller. This patch signals a new
TX_POWER_SELECTED mgmt event to alert the caller of the actual tx power
that is being used. This is important because the power selected will
not necessarily match the power requested by the user.

This patch is manually verified by ensuring the tx power selected event
is signalled and caught by bluetoothd.

Reviewed-by: Sonny Sasaka <sonnysasaka@chromium.org>
Signed-off-by: Daniel Winkler <danielwinkler@google.com>
---

 include/net/bluetooth/hci_core.h |  2 ++
 include/net/bluetooth/mgmt.h     |  6 ++++++
 net/bluetooth/hci_event.c        |  4 ++++
 net/bluetooth/mgmt.c             | 11 +++++++++++
 4 files changed, 23 insertions(+)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index ab168f46b6d909..667b9d37099dec 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1781,6 +1781,8 @@ void mgmt_advertising_added(struct sock *sk, struct hci_dev *hdev,
 			    u8 instance);
 void mgmt_advertising_removed(struct sock *sk, struct hci_dev *hdev,
 			      u8 instance);
+void mgmt_adv_tx_power_selected(struct hci_dev *hdev, u8 instance,
+				s8 tx_power);
 int mgmt_phy_configuration_changed(struct hci_dev *hdev, struct sock *skip);
 
 u8 hci_le_conn_update(struct hci_conn *conn, u16 min, u16 max, u16 latency,
diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 859f0d3cd6ea38..db64cf4747554c 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -1079,3 +1079,9 @@ struct mgmt_ev_controller_resume {
 #define MGMT_WAKE_REASON_NON_BT_WAKE		0x0
 #define MGMT_WAKE_REASON_UNEXPECTED		0x1
 #define MGMT_WAKE_REASON_REMOTE_WAKE		0x2
+
+#define MGMT_EV_ADV_TX_POWER_SELECTED	0x002f
+struct mgmt_ev_adv_tx_power_selected {
+	__u8	instance;
+	__s8	tx_power;
+}  __packed;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index bd306ba3ade545..9a24fd99d9e08e 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1749,6 +1749,10 @@ static void hci_cc_set_ext_adv_param(struct hci_dev *hdev, struct sk_buff *skb)
 	}
 	/* Update adv data as tx power is known now */
 	hci_req_update_adv_data(hdev, hdev->cur_adv_instance);
+
+	if (cp->handle)
+		mgmt_adv_tx_power_selected(hdev, cp->handle, rp->tx_power);
+
 	hci_dev_unlock(hdev);
 }
 
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 717c97affb1554..b9347ff1a1e961 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -167,6 +167,7 @@ static const u16 mgmt_events[] = {
 	MGMT_EV_DEVICE_FLAGS_CHANGED,
 	MGMT_EV_CONTROLLER_SUSPEND,
 	MGMT_EV_CONTROLLER_RESUME,
+	MGMT_EV_ADV_TX_POWER_SELECTED,
 };
 
 static const u16 mgmt_untrusted_commands[] = {
@@ -1152,6 +1153,16 @@ void mgmt_advertising_removed(struct sock *sk, struct hci_dev *hdev,
 	mgmt_event(MGMT_EV_ADVERTISING_REMOVED, hdev, &ev, sizeof(ev), sk);
 }
 
+void mgmt_adv_tx_power_selected(struct hci_dev *hdev, u8 instance, s8 tx_power)
+{
+	struct mgmt_ev_adv_tx_power_selected ev;
+
+	ev.instance = instance;
+	ev.tx_power = tx_power;
+
+	mgmt_event(MGMT_EV_ADV_TX_POWER_SELECTED, hdev, &ev, sizeof(ev), NULL);
+}
+
 static void cancel_adv_timeout(struct hci_dev *hdev)
 {
 	if (hdev->adv_instance_timeout) {
-- 
2.28.0.618.gf4bc123cb7-goog

