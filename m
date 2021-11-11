Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF13444D16E
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 06:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhKKFXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 00:23:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbhKKFXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 00:23:52 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8C0C061767
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 21:21:03 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id h14-20020a0562140dae00b003ae664126e9so4698188qvh.3
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 21:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=4QGK+gsnB0i8v51ZJlvJzgAW5exC56xFsYJaAgqkcHM=;
        b=YG0KukbASgq1N77esyIQ9HWrllIl06n6PBi+UPAkNh8JQHAfOe7yu2UomP7G8Qn9F6
         6TkhSle1byBGFj4DoF6Gjw+pTixFhU65cuwPg1akViLjnoHGXvNy/kuDZWD5peMFDQVw
         ZbwVFPEC4EI204FZUUbQbf+2wkT1tDQ0aeUdRiPykNexXQpuZj6oHT5/cshGRNbRzXKi
         TlS6uBbeRUrCNpTygo2KnCg8QyarBy75QfdgsTO0ZkBtjEgU6CTEurd/4p38PcPsLpkR
         pq4wxRsrzBKZ5XYrLXhlmTuzsMDImnHuhInUQokQm6n/h+Duh8VYviVDrsKdgnkMljJK
         xbRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=4QGK+gsnB0i8v51ZJlvJzgAW5exC56xFsYJaAgqkcHM=;
        b=ebRjpWRV0Ju1UDjEdB3ClKum40TwHoYdpTJeJdpMJ4XAMBBLnKz8nb5OuBj0Q4oRyJ
         l+aP+3ujuLzfCNHllndzKdaPXXDtN68ENw2GBTHGrd8PULU79HMkwIcnU3IeRW0V4okM
         uuEUjqMAlfVMQvyUrLEbggoEJEsmk3vml9dynrOGPenanOO2fghgo4CbNCgIAB0KvMNC
         KSpcO8BNZqJmSrCge5lwP9lOyfZT0wThm0Tnaegnbjcfvzw3yeSNQXZlWbmBQcJBoIDe
         pxKwDC1JV+u4cWw4kTC84PGIz0FfrCLntI1jr6t9wwxpkjZjNQMkqMbd9yEfV5nr8buV
         42/g==
X-Gm-Message-State: AOAM532EKsUteUvd6isskm2AdQxe5UDOvJ7RlWYpWPr0aY3AuIGasHo+
        9DMkJOPWLpHYY5tyxm6qS+hsENPLKIAP
X-Google-Smtp-Source: ABdhPJxDHD1UOlNrc/Jl27bTgfN5RjcdbjW+C10h/DM/s2OxoJ90atmHrfalsaaQG783G4xuKl4hNic6mZZx
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:10:b87e:3eb:e17e:1273])
 (user=apusaka job=sendgmr) by 2002:ac8:7e91:: with SMTP id
 w17mr5032950qtj.191.1636608062561; Wed, 10 Nov 2021 21:21:02 -0800 (PST)
Date:   Thu, 11 Nov 2021 13:20:53 +0800
Message-Id: <20211111132045.v3.1.I3ba1a76d72da5a813cf6e6f219838c9ef28c5eaa@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH v3 1/2] Bluetooth: Ignore HCI_ERROR_CANCELLED_BY_HOST on adv
 set terminated event
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

This event is received when the controller stops advertising,
specifically for these three reasons:
(a) Connection is successfully created (success).
(b) Timeout is reached (error).
(c) Number of advertising events is reached (error).
(*) This event is NOT generated when the host stops the advertisement.
Refer to the BT spec ver 5.3 vol 4 part E sec 7.7.65.18. Note that the
section was revised from BT spec ver 5.0 vol 2 part E sec 7.7.65.18
which was ambiguous about (*).

Some chips (e.g. RTL8822CE) send this event when the host stops the
advertisement with status = HCI_ERROR_CANCELLED_BY_HOST (due to (*)
above). This is treated as an error and the advertisement will be
removed and userspace will be informed via MGMT event.

On suspend, we are supposed to temporarily disable advertisements,
and continue advertising on resume. However, due to the behavior
above, the advertisements are removed instead.

This patch returns early if HCI_ERROR_CANCELLED_BY_HOST is received.

Btmon snippet of the unexpected behavior:
@ MGMT Command: Remove Advertising (0x003f) plen 1
        Instance: 1
< HCI Command: LE Set Extended Advertising Enable (0x08|0x0039) plen 6
        Extended advertising: Disabled (0x00)
        Number of sets: 1 (0x01)
        Entry 0
          Handle: 0x01
          Duration: 0 ms (0x00)
          Max ext adv events: 0
> HCI Event: LE Meta Event (0x3e) plen 6
      LE Advertising Set Terminated (0x12)
        Status: Operation Cancelled by Host (0x44)
        Handle: 1
        Connection handle: 0
        Number of completed extended advertising events: 5
> HCI Event: Command Complete (0x0e) plen 4
      LE Set Extended Advertising Enable (0x08|0x0039) ncmd 2
        Status: Success (0x00)

Signed-off-by: Archie Pusaka <apusaka@chromium.org>

---

(no changes since v2)

Changes in v2:
* Split clearing HCI_LE_ADV into its own patch
* Reword comments

 include/net/bluetooth/hci.h |  1 +
 net/bluetooth/hci_event.c   | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 63065bc01b76..84db6b275231 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -566,6 +566,7 @@ enum {
 #define HCI_ERROR_INVALID_LL_PARAMS	0x1e
 #define HCI_ERROR_UNSPECIFIED		0x1f
 #define HCI_ERROR_ADVERTISING_TIMEOUT	0x3c
+#define HCI_ERROR_CANCELLED_BY_HOST	0x44
 
 /* Flow control modes */
 #define HCI_FLOW_CTL_MODE_PACKET_BASED	0x00
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index d4b75a6cfeee..7d875927c48b 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5538,6 +5538,18 @@ static void hci_le_ext_adv_term_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 	adv = hci_find_adv_instance(hdev, ev->handle);
 
+	/* The Bluetooth Core 5.3 specification clearly states that this event
+	 * shall not be sent when the Host disables the advertising set. So in
+	 * case of HCI_ERROR_CANCELLED_BY_HOST, just ignore the event.
+	 *
+	 * When the Host disables an advertising set, all cleanup is done via
+	 * its command callback and not needed to be duplicated here.
+	 */
+	if (ev->status == HCI_ERROR_CANCELLED_BY_HOST) {
+		bt_dev_warn_ratelimited(hdev, "Unexpected advertising set terminated event");
+		return;
+	}
+
 	if (ev->status) {
 		if (!adv)
 			return;
-- 
2.34.0.rc0.344.g81b53c2807-goog

