Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD0D215D1C6
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 06:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgBNFuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 00:50:25 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:55194 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgBNFuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 00:50:25 -0500
Received: by mail-pj1-f73.google.com with SMTP id a31so5127959pje.4
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 21:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VuMUvY4EPSsAnctiTbAX9//yB+fu7ADTq9BoEKb9b4E=;
        b=Vt60nqCh04jNJlQG1C2SO+x1MYvBSBXPPEbEcdmmZmmmKoqjPAsFhaacd+Nd7oqOGm
         Z4bjZ/y5Db6F2TRJBvIY8m4JSDryeSyDPSxUytsRbOAd2pCE6WBaS+W59dKlbxrn3pn5
         YJtJh3MZ2hQcrAE/ndossw//e36IBAozr9DgQ/G68s3Pg8McUsupAZFayAoqrCwOlrjZ
         VAI6XvqNEcnvHEjxd7MzuLo8ILXWiNVKX2/8JwvT1pG08d2ZV8LACpFzVRkG0wLUBfkc
         L9HeTPklDz6O5RJqTQD7XzeFMPdliWb0xLCiwaFdxwOfcuhfJJTF82qPXmwmrjWAQnZs
         mBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VuMUvY4EPSsAnctiTbAX9//yB+fu7ADTq9BoEKb9b4E=;
        b=bw3FBIJzFiuVHbA/NmJJp4npCVrNFWRfDDSx1MgFaak3Ue5nh1qkN2KSq+VA2UlZSL
         uTJoa0zYZgfc3cjcfBYVlp52WZm6+0rET76BQZSMgkX+b00MxgS2okrx7FEy/IKHNNn9
         gliZgCySTS6ylYsEFdWcVMYOR60uwvOMqzaG5/edBP1owU5IRx92pgR9cUdfCxBZN78W
         H4KfoBnjFE/nRwaFHWimAihp8lAc+WN4q1OtciWDc+CoviUDPkQow52e3xuHEmFIp16F
         d+qkSZjuAG1bSwrvhs1DYbUZBHgUlgScJDQa759DqSpamlapuG9AAXaZjZnNbyBHPVVE
         /gWg==
X-Gm-Message-State: APjAAAUsSTXa3I8VoWCBhjum3edZ2dLKdw7XDiXC+4N3T58aEEo3OLbI
        BwZGikyY61I968xgtoG9bQvtp/XWGpZpdj2HsA==
X-Google-Smtp-Source: APXvYqwPDaunmaqVlP02nijZeyJBnOWt2astdc/4cUZr4fit6ZtUhE1op6K2IAnTo+ZhrjCjgGTCnPqrWS5AK8v/MA==
X-Received: by 2002:a63:de0b:: with SMTP id f11mr1591266pgg.89.1581659424364;
 Thu, 13 Feb 2020 21:50:24 -0800 (PST)
Date:   Fri, 14 Feb 2020 13:50:17 +0800
Message-Id: <20200214134922.Bluez.v4.1.Ia71869d2f3e19a76a6a352c61088a085a1d41ba6@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [Bluez PATCH v4] bluetooth: secure bluetooth stack from bluedump attack
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
 net/bluetooth/smp.c       | 19 +++++++++++++++++++
 2 files changed, 29 insertions(+)

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
index 2cba6e07c02b..bea64071bdd1 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2192,6 +2192,25 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
 		smp_send_cmd(conn, SMP_CMD_PAIRING_RANDOM, sizeof(smp->prnd),
 			     smp->prnd);
 		SMP_ALLOW_CMD(smp, SMP_CMD_DHKEY_CHECK);
+
+		/* May need further confirmation for Just-Works pairing  */
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
+							hcon->dst_type, passkey,
+							1);
+			if (err)
+				return SMP_UNSPECIFIED;
+			set_bit(SMP_FLAG_WAIT_USER, &smp->flags);
+		}
 	}
 
 mackey_and_ltk:
-- 
2.25.0.265.gbab2e86ba0-goog

