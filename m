Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 500931826FF
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 03:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387651AbgCLCUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 22:20:21 -0400
Received: from mail-pj1-f74.google.com ([209.85.216.74]:52890 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387404AbgCLCUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 22:20:21 -0400
Received: by mail-pj1-f74.google.com with SMTP id c6so2384052pjs.2
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 19:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rcj6bBjC8eeTo0oFTOG03100dOPRd+sT+MeVFj1k6mA=;
        b=TN0Hk9Vlr9nUe66Kfks1oZvflGet0NTOh+FTOaukrvmsiQhyz1hkirVE+pcJxrjokZ
         tWHYqt2TtIzz6QyFRErqrCDZwcVWklLYXQZDzeVDAuhDgfxSOz+cAALYjVcLaf318zoq
         rYRp9b3Mr5gbqIBu20VCBrksnpjvymocYkKKwwqzWWzy6vCuxvYc7jRZ122sol6tkEG2
         JNxlRbJeYLeThZ2E8c/nXi5wrlyGbVPjq+WstnjMY3t5Fed27YW9+Thl1iVkflatHe0O
         HLpcY2gt0NQUocPF6a1eJLfZkrCYL8h/SStFxJXpeH74sZTNpuxv1c21ofZyHAWGZMfT
         iLZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rcj6bBjC8eeTo0oFTOG03100dOPRd+sT+MeVFj1k6mA=;
        b=qxo+0uluZp3rsYF6sX9kiahJGxkwzTzHp2U2bQclAahuLF7nYDzN7nHeyPIESRY/ZM
         lZeYYs4lq2M8pUkmQAeWwlQjZXmSZq1YalhTKzXBOyXT2oO6+5FexIrCc+E6AioKBNXD
         1/6Cpd7kWQtkaJv/JyCNY+LPHxmhTbGpViMw1lwUkxKyaIRf0MtSuTq4nmmC4Uj78SYn
         iUcv3RngFAMEWXODX8EodeV/PfG2I63mFO1XzdMdz8lqICSLHKefWyqd7tGrxUdV05K8
         W7imwC+NRX9zwT0hwkQHfO7KW5MMvtXK1viJDHgIsu5ACrDXLwI9nzVczdmCvP+ATKQi
         0Gzg==
X-Gm-Message-State: ANhLgQ2uboQGtMcZWWW/iPVnYkQMF6xyH8VrfUN2xtLTywUCIK6kGmwl
        WdAo8aD6reNIVUfIjCtSSXTmp3PTwUuGFg==
X-Google-Smtp-Source: ADFU+vt1IpdsKjnyDHOBBFNJ/1UpXWbObj4AfBQQ8ULIYIUPaCwDt98YX8rrJ9mZbbobHSxkLh4ho/ykSS30ew==
X-Received: by 2002:a17:90a:cf0c:: with SMTP id h12mr1679625pju.164.1583979619855;
 Wed, 11 Mar 2020 19:20:19 -0700 (PDT)
Date:   Wed, 11 Mar 2020 19:20:14 -0700
Message-Id: <20200311191939.v2.1.I12c0712e93f74506385b67c6df287658c8fdad04@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH v2] Bluetooth: clean up connection in hci_cs_disconnect
From:   Manish Mandlik <mmandlik@google.com>
To:     marcel@holtmann.org
Cc:     Alain Michaud <alainm@chromium.org>,
        linux-bluetooth@vger.kernel.org,
        Miao-chen Chou <mcchou@chromium.org>,
        Joseph Hwang <josephsih@chromium.org>,
        Yoni Shavit <yshavit@chromium.org>,
        Manish Mandlik <mmandlik@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joseph Hwang <josephsih@chromium.org>

In bluetooth core specification 4.2,
Vol 2, Part E, 7.8.9 LE Set Advertise Enable Command, it says

    The Controller shall continue advertising until ...
    or until a connection is created or ...
    In these cases, advertising is then disabled.

Hence, advertising would be disabled before a connection is
established. In current kernel implementation, advertising would
be re-enabled when all connections are terminated.

The correct disconnection flow looks like

  < HCI Command: Disconnect

  > HCI Event: Command Status
      Status: Success

  > HCI Event: Disconnect Complete
      Status: Success

Specifically, the last Disconnect Complete Event would trigger a
callback function hci_event.c:hci_disconn_complete_evt() to
cleanup the connection and re-enable advertising when proper.

However, sometimes, there might occur an exception in the controller
when disconnection is being executed. The disconnection flow might
then look like

  < HCI Command: Disconnect

  > HCI Event: Command Status
      Status: Unknown Connection Identifier

  Note that "> HCI Event: Disconnect Complete" is missing when such an
exception occurs. This would result in advertising staying disabled
forever since the connection in question is not cleaned up correctly.

To fix the controller exception issue, we need to do some connection
cleanup when the disconnect command status indicates an error.

Signed-off-by: Joseph Hwang <josephsih@chromium.org>
Signed-off-by: Manish Mandlik <mmandlik@google.com>
---

Changes in v2:
- Moved "u8 type" declaration inside if block

 net/bluetooth/hci_event.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index a40ed31f6eb8f..a116114279107 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2202,10 +2202,22 @@ static void hci_cs_disconnect(struct hci_dev *hdev, u8 status)
 	hci_dev_lock(hdev);
 
 	conn = hci_conn_hash_lookup_handle(hdev, __le16_to_cpu(cp->handle));
-	if (conn)
+	if (conn) {
+		u8 type = conn->type;
+
 		mgmt_disconnect_failed(hdev, &conn->dst, conn->type,
 				       conn->dst_type, status);
 
+		/* If the disconnection failed for any reason, the upper layer
+		 * does not retry to disconnect in current implementation.
+		 * Hence, we need to do some basic cleanup here and re-enable
+		 * advertising if necessary.
+		 */
+		hci_conn_del(conn);
+		if (type == LE_LINK)
+			hci_req_reenable_advertising(hdev);
+	}
+
 	hci_dev_unlock(hdev);
 }
 
-- 
2.25.1.481.gfbce0eb801-goog

