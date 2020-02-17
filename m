Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0AC216096E
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 05:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgBQEFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 23:05:15 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:35082 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727815AbgBQEFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 23:05:14 -0500
Received: by mail-pg1-f201.google.com with SMTP id j29so10895841pgj.2
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 20:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=KMuOOh+un+YCPFr8b6yeijMH6rF3UsQjfTXq1dL+TiU=;
        b=SJ77Fa0bkktg3YOKVByovnXj1UUsGEqdC5K+iVXXrTrxzeIRcidVk/fb4NFEOOfdL9
         s0Yu+L/nPWd7PXyqy09zpbxxm189pl7CeTweBTyyoz6p4FiNHjBNF49IpkdGiI3xYYwI
         b+plMsujhnnabbL5x7aybaprN4E2Sc/Z+F5EPRIYi3Gs4s8da0aNsQeL5B/DXstv1jfq
         hUMPBwt5R9Idh1OSifE2GZJjuozkR0R5obF1KZXr15l7gnJOJ+svm4z2mM9xV5UCCypd
         OF5WWC8exZ8FxkPaU/qsEXC7fokFwlJ5zInZGF5vWYxkNGPbyLBSrCshThNm89/PAXZZ
         UgqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=KMuOOh+un+YCPFr8b6yeijMH6rF3UsQjfTXq1dL+TiU=;
        b=bH3wohfHnwzwdnPZQN+pLB36c+1qwlUUu2ZFMAOf8xGRtnWYm/UVZ9Ew3+N27vqVld
         OCRSNMkpzrz70DwhilUOzp8mIvYDlGERgZH+rxcrXtBp4ngIIYRRFueVTZqgLpnR0Xre
         MtCEOr7KENV1QAq6Xa3cy3iCt/7eYaa4m5rWqXwlZebygG8xz2s1E9EaYhc5IVrLyPZ4
         6DglawjGiPwD8GebwrB6Lqtzlibxkyz+kHbzuWHZQ3ka98uUaOUTOF9F8JAn4mgGVcxp
         78e/HG7yqRshnJ47LEhU01kas3BwEV2YNvSlpMxKijE14Gk7lyXrMHSsyhwKkpUr7q4a
         7ujg==
X-Gm-Message-State: APjAAAUy9oPtRIFewkGGBAyaQKg/k7lMduqsMYeFQu+HHLAu5A7lqpKz
        DOu5npmSKn9l4kgx4FBV1lfF3C20rngtRSMMsw==
X-Google-Smtp-Source: APXvYqwzecOqFqAQbDjGxkj8H9g1SfJhMVodrpAyj+HwltbP1RJUNeMBDIJ9Xo+HM4GK8bjoqzV6361fiRur36qs1g==
X-Received: by 2002:a63:d18:: with SMTP id c24mr15930889pgl.218.1581912312201;
 Sun, 16 Feb 2020 20:05:12 -0800 (PST)
Date:   Mon, 17 Feb 2020 12:05:03 +0800
Message-Id: <20200217120454.Bluez.v6.1.Ia71869d2f3e19a76a6a352c61088a085a1d41ba6@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [Bluez PATCH v6] bluetooth: secure bluetooth stack from bluedump attack
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Howard Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Attack scenario:
1. A Chromebook (let's call this device A) is paired to a legitimate
   Bluetooth classic device (e.g. a speaker) (let's call this device
   B).
2. A malicious device (let's call this device C) pretends to be the
   Bluetooth speaker by using the same BT address.
3. If device A is not currently connected to device B, device A will
   be ready to accept connection from device B in the background
   (technically, doing Page Scan).
4. Therefore, device C can initiate connection to device A
   (because device A is doing Page Scan) and device A will accept the
   connection because device A trusts device C's address which is the
   same as device B's address.
5. Device C won't be able to communicate at any high level Bluetooth
   profile with device A because device A enforces that device C is
   encrypted with their common Link Key, which device C doesn't have.
   But device C can initiate pairing with device A with just-works
   model without requiring user interaction (there is only pairing
   notification). After pairing, device A now trusts device C with a
   new different link key, common between device A and C.
6. From now on, device A trusts device C, so device C can at anytime
   connect to device A to do any kind of high-level hijacking, e.g.
   speaker hijack or mouse/keyboard hijack.

Since we don't know whether the repairing is legitimate or not,
leave the decision to user space if all the conditions below are met.
- the pairing is initialized by peer
- the authorization method is just-work
- host already had the link key to the peer

Signed-off-by: Howard Chung <howardchung@google.com>
---

Changes in v6:
- Fix passkey uninitialized issue

Changes in v5:
- Rephrase the comment

Changes in v4:
- optimise the check in smp.c.

Changes in v3:
- Change confirm_hint from 2 to 1
- Fix coding style (declaration order)

Changes in v2:
- Remove the HCI_PERMIT_JUST_WORK_REPAIR debugfs option
- Fix the added code in classic
- Add a similar fix for LE

 net/bluetooth/hci_event.c | 10 ++++++++++
 net/bluetooth/smp.c       | 18 ++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 2c833dae9366..e6982f4f51ea 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4571,6 +4571,16 @@ static void hci_user_confirm_request_evt(struct hci_dev *hdev,
 			goto confirm;
 		}
 
+		/* If there already exists link key in local host, leave the
+		 * decision to user space since the remote device could be
+		 * legitimate or malicious.
+		 */
+		if (hci_find_link_key(hdev, &ev->bdaddr)) {
+			bt_dev_warn(hdev, "Local host already has link key");
+			confirm_hint = 1;
+			goto confirm;
+		}
+
 		BT_DBG("Auto-accept of user confirmation with %ums delay",
 		       hdev->auto_accept_delay);
 
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 2cba6e07c02b..2b6fb7454add 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2192,6 +2192,24 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
 		smp_send_cmd(conn, SMP_CMD_PAIRING_RANDOM, sizeof(smp->prnd),
 			     smp->prnd);
 		SMP_ALLOW_CMD(smp, SMP_CMD_DHKEY_CHECK);
+
+		/* Only Just-Works pairing requires extra checks */
+		if (smp->method != JUST_WORKS)
+			goto mackey_and_ltk;
+
+		/* If there already exists link key in local host, leave the
+		 * decision to user space since the remote device could be
+		 * legitimate or malicious.
+		 */
+		if (hci_find_ltk(hcon->hdev, &hcon->dst, hcon->dst_type,
+				 hcon->role)) {
+			err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
+							hcon->type,
+							hcon->dst_type, 0, 1);
+			if (err)
+				return SMP_UNSPECIFIED;
+			set_bit(SMP_FLAG_WAIT_USER, &smp->flags);
+		}
 	}
 
 mackey_and_ltk:
-- 
2.25.0.265.gbab2e86ba0-goog

