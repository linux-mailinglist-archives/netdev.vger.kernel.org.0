Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D6A15D66D
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 12:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbgBNLQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 06:16:50 -0500
Received: from mail-vs1-f73.google.com ([209.85.217.73]:35428 "EHLO
        mail-vs1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729210AbgBNLQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 06:16:50 -0500
Received: by mail-vs1-f73.google.com with SMTP id 123so674607vsg.2
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 03:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=c3okqhGXbbn+0UGnWI89nn927kUSh19dp4ivRMVKM2U=;
        b=iQAkM9MjICHpGcWO1za9HTHfLgysGmX4AvNhv0qrE8Eyc53ngdh1T8OpbzVHWkZ0fo
         KXNxqzuGBpFGVRu6EGDu2mxLR0mSVHjrqSUBirnlt6TtXajhTXSJzPQN561gCblVT/Bm
         d9O2k3B5DaTnJAJp0+Uqkkj3DsaCIjuER6vwEbnL9WeFAg5PoyCzy6tVwlZ0NRSe6DXP
         a6wDsljFgIyHhEKyFUHsfdZgua/fcyGPgCG3RcScdrCZTj6P15ukbzTPk6xjHhIjHzo/
         +3bn0EzWxXjzTivBC5zTYDoqdIGI63+qWx2PwA0Qdm2jglKCm5R1JWJPtZISzQNrKglc
         jexQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=c3okqhGXbbn+0UGnWI89nn927kUSh19dp4ivRMVKM2U=;
        b=mThaRp4dLi0a2j7F7PMyM25Bm827TUaY4dhP1TE9n22+0ZIZvM9Ryq0P3h9OUUwzA7
         kpOc/wNhugBWGSf/+hH3l9YQ4BYcIvehNU1I/RwoIgjOyQZySJwm+ftiH8ywyTtrWaLi
         faw6WfhIOUX978Mu0kw+q9GGawqNoPvA6v8iUkZjSs05NMbILeup5hrEHeMX/x/OxG2V
         C+pRM1vz68Kbp0aD/o4bwFQNYk1TU/A9PPtMHv/2AfeVPUu71wOFap3zFMyf3nKBfirG
         Bewmx/WEKMe7e35H/4hLAbmWD2KPUR2n+MLJcGIRntziTsWIKNPWmTqne6kceUI2shRZ
         Ww5A==
X-Gm-Message-State: APjAAAXExie8uLffSkP5vOPqiSqAZ6SOCqGBbQdUTf0w/gePhwA8ZMkm
        KQ0mdGpXPDz5LhMDaMayWaq9OXLHgwj4ddfSaw==
X-Google-Smtp-Source: APXvYqzsIA3nUi3NBbhp5dI9jRoSYsoMZCDaMZ07OVCCBOj8uKzTu0JiMAsaZ8k19Z0h13CTZjvl3d3xNuD/pHp54g==
X-Received: by 2002:ab0:2859:: with SMTP id c25mr1216302uaq.79.1581679007748;
 Fri, 14 Feb 2020 03:16:47 -0800 (PST)
Date:   Fri, 14 Feb 2020 19:16:41 +0800
Message-Id: <20200214191609.Bluez.v5.1.Ia71869d2f3e19a76a6a352c61088a085a1d41ba6@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [Bluez PATCH v5] bluetooth: secure bluetooth stack from bluedump attack
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
index 2cba6e07c02b..25dbf77d216b 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -2192,6 +2192,25 @@ static u8 smp_cmd_pairing_random(struct l2cap_conn *conn, struct sk_buff *skb)
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

