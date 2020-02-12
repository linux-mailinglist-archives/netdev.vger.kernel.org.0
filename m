Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F5F15A9FD
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 14:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbgBLNXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 08:23:32 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:36552 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgBLNXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 08:23:31 -0500
Received: by mail-pj1-f73.google.com with SMTP id m61so1361536pjb.1
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 05:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=w10epyxLvI1AMDusIOewZ9Hw+W4QXY5j4khGzCFE/qU=;
        b=CSRbTp0cgmvvYED86UShjM6ebVFBVWmoUEIeo7pq2N59MZTYbk+bADSbZt33gVePGq
         dphTBNLWIxyja9ri+3b1r98pQnYg/8UpvMhP+xiOBweai1HRwiziWao2g2GZivD+iW6n
         swP+Kr511KN0bQbdAH5H/t0NT1Cwp83IYTNQBJ7E9hGIqvoqFEa1KAyur0IxjadrQnaW
         RvzFWsbu0AHdSM8TF51meWPdH76N2QWOTjknXzJ7Lz2KMgrePb25g3IG6+btvzEtfiMc
         6kr5YOvTb81FA7625/4YvW1/UarZctyDBxz9w76Fiz6AbXuzATd4bRmJxPPlOrgugZWF
         697A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=w10epyxLvI1AMDusIOewZ9Hw+W4QXY5j4khGzCFE/qU=;
        b=U2P4Bsb44fFzynxtTh1mK1cWplY5cOM3sPc6FsJoXvdGJ6nzD5xZkzKcfBY741XqpD
         Lu59DP1fxVxf6FG/1U8B7UL+lO1CycqND4kZGxTyU1IY4rbG8pxwEEHzGrEPgAlEY10Z
         a/k5KthKhKJLP7ktuD+/TktxTo28tc729Qxbbwb3IA0aFACxH3osy/xB87QUG9M/m2EB
         AlmxDN4d4PtMiIpDjkGSVbYQxz/H7MLxhC+JFT1hObdYCFX8y4u89WDqwK1iPJs1uaTX
         T3l77n0YS09J4S8bkgJVKHUKVS039+FJOG6qF6iAxEEZRi49sjKHd+uX+4j5f3PycvC/
         6lNg==
X-Gm-Message-State: APjAAAURZM+ZE9k3rQxw9ovcWbOzGL4msjP+w1Y39P0JevC1dr2XKtRO
        f/B7I+je9ngxNPB2DFs9I42GGx6sHiW1vMJbMQ==
X-Google-Smtp-Source: APXvYqweIa+s3oYripbme3DsFRlxtH2ALwUEkVJB/JEHC77sTiqqrkzOYJqa4fBbraA0805Q2Wx0aFP/FapyKstnIA==
X-Received: by 2002:a63:7412:: with SMTP id p18mr8348417pgc.361.1581513809481;
 Wed, 12 Feb 2020 05:23:29 -0800 (PST)
Date:   Wed, 12 Feb 2020 21:23:23 +0800
Message-Id: <20200212212316.Bluez.v3.1.Ia71869d2f3e19a76a6a352c61088a085a1d41ba6@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.225.g125e21ebc7-goog
Subject: [Bluez PATCH v3] bluetooth: secure bluetooth stack from bluedump attack
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
index 2cba6e07c02b..1483ceea3bab 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2139,6 +2139,7 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
 	struct l2cap_chan *chan = conn->smp;
 	struct smp_chan *smp = chan->data;
 	struct hci_conn *hcon = conn->hcon;
+	struct smp_ltk *key;
 	u8 *pkax, *pkbx, *na, *nb;
 	u32 passkey;
 	int err;
@@ -2192,6 +2193,23 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
 		smp_send_cmd(conn, SMP_CMD_PAIRING_RANDOM, sizeof(smp->prnd),
 			     smp->prnd);
 		SMP_ALLOW_CMD(smp, SMP_CMD_DHKEY_CHECK);
+
+		key = hci_find_ltk(hcon->hdev, &hcon->dst, hcon->dst_type,
+				   hcon->role);
+
+		/* If there already exists link key in local host, leave the
+		 * decision to user space since the remote device could be
+		 * legitimate or malicious.
+		 */
+		if (smp->method == JUST_WORKS && key) {
+			err = mgmt_user_confirm_request(hcon->hdev, &hcon->dst,
+							hcon->type,
+							hcon->dst_type, passkey,
+							1);
+			if (err)
+				return SMP_UNSPECIFIED;
+			set_bit(SMP_FLAG_WAIT_USER, &smp->flags);
+		}
 	}
 
 mackey_and_ltk:
-- 
2.25.0.225.g125e21ebc7-goog

