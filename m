Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E95FC1827D4
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 05:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731647AbgCLEfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 00:35:38 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:33226 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgCLEfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 00:35:37 -0400
Received: by mail-qk1-f202.google.com with SMTP id l27so3078171qkl.0
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 21:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=SR8hiNoADlxPJ7CcKI/cTH5wQLtIQvLTLgazJPJGNSY=;
        b=uLiENDqdQkSn5SrBwJEBq4oQcUDuZcSOG5zkYYqRIZZJCpxsJOQLFcGve4mlLBNzYd
         qg2YWmhBtIQM8vcHe83uofHEraq0fon4u6+TmW8lwHTIBaRcIi8z+BbHRC8BWhiUCaX7
         paEOla/sLyS/wDP9V9vOeniOWQLt2VbMsX8TGJ4EI9iuKCBmb90RT5IqMuJrwc7tpRxe
         HDPPaUds1DCq8lHfLZfFqhx6bbhmm8reYKzK9IYrdUXxeZ0T4cfI3OqOxGuDqVKPAiN/
         ouUCROrZxJ4Yqg67PfJ6mrdqCsqgZvXGBGZrEHMRFLBMsiJ51YnuQFJrwEy7loqKfIyM
         IQRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=SR8hiNoADlxPJ7CcKI/cTH5wQLtIQvLTLgazJPJGNSY=;
        b=FpBc+HY//IIbojIU66d3CpH72sFta1JvN/8rY2KRp4bJ76trk+Hx6WN5+wnGvtXx86
         m7oPAiNP4BCZ7sTkVTfeM6xJyS3euJQ7+rnxHAwXc0KuyZSFrJoPLgGJCExsgCmXgF8H
         CYTtBks7apyB5ldje5rjumCYqHWMKaKHMXBKE49tUx26Gc3l+/iMDxHjRYpiqRJOojRY
         gTvIYyoTumtK/jJIgEae+nXFgRnpBpP7YwMlNqfMmLOLs3H4Or9PEwBA4O/HHTz33bKh
         yzPv/XVGwfv0zS50icm4y2zDqNwgZlcyV8KEJoYnMefTkTrJhnJZteW23R3Du+PMikui
         D1EA==
X-Gm-Message-State: ANhLgQ2VVtjaZFvYmGx56mY13pWGyH2QJSWtqJp5C0VjN59LCzwNz2ZC
        X53sWkdWK15hlPR6wAX63eMMtP97/tFXfrP1Mg==
X-Google-Smtp-Source: ADFU+vsHKo49UpImt1uQNDK7E8mxBRFwbW1IJ+Ss7XMWSMMfaitQ/FWD3t/FqFEJZVeoiErHdrbE9g/Eoh1nfnb85Q==
X-Received: by 2002:a37:7d2:: with SMTP id 201mr6131242qkh.146.1583987734205;
 Wed, 11 Mar 2020 21:35:34 -0700 (PDT)
Date:   Thu, 12 Mar 2020 12:35:27 +0800
Message-Id: <20200312123453.Bluez.v2.1.I50b301a0464eb68e3d62721bf59e11ed2617c415@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [Bluez PATCH v2] Bluetooth: L2CAP: handle l2cap config request during
 open state
From:   Howard Chung <howardchung@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Howard Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Core Spec Version 5.2 | Vol 3, Part A 6.1.5,
the incoming L2CAP_ConfigReq should be handled during
OPEN state.

The section below shows the btmon trace when running
L2CAP/COS/CFD/BV-12-C before and after this change.

=== Before ===
...
> ACL Data RX: Handle 256 flags 0x02 dlen 12                #22
      L2CAP: Connection Request (0x02) ident 2 len 4
        PSM: 1 (0x0001)
        Source CID: 65
< ACL Data TX: Handle 256 flags 0x00 dlen 16                #23
      L2CAP: Connection Response (0x03) ident 2 len 8
        Destination CID: 64
        Source CID: 65
        Result: Connection successful (0x0000)
        Status: No further information available (0x0000)
< ACL Data TX: Handle 256 flags 0x00 dlen 12                #24
      L2CAP: Configure Request (0x04) ident 2 len 4
        Destination CID: 65
        Flags: 0x0000
> HCI Event: Number of Completed Packets (0x13) plen 5      #25
        Num handles: 1
        Handle: 256
        Count: 1
> HCI Event: Number of Completed Packets (0x13) plen 5      #26
        Num handles: 1
        Handle: 256
        Count: 1
> ACL Data RX: Handle 256 flags 0x02 dlen 16                #27
      L2CAP: Configure Request (0x04) ident 3 len 8
        Destination CID: 64
        Flags: 0x0000
        Option: Unknown (0x10) [hint]
        01 00                                            ..
< ACL Data TX: Handle 256 flags 0x00 dlen 18                #28
      L2CAP: Configure Response (0x05) ident 3 len 10
        Source CID: 65
        Flags: 0x0000
        Result: Success (0x0000)
        Option: Maximum Transmission Unit (0x01) [mandatory]
          MTU: 672
> HCI Event: Number of Completed Packets (0x13) plen 5      #29
        Num handles: 1
        Handle: 256
        Count: 1
> ACL Data RX: Handle 256 flags 0x02 dlen 14                #30
      L2CAP: Configure Response (0x05) ident 2 len 6
        Source CID: 64
        Flags: 0x0000
        Result: Success (0x0000)
> ACL Data RX: Handle 256 flags 0x02 dlen 20                #31
      L2CAP: Configure Request (0x04) ident 3 len 12
        Destination CID: 64
        Flags: 0x0000
        Option: Unknown (0x10) [hint]
        01 00 91 02 11 11                                ......
< ACL Data TX: Handle 256 flags 0x00 dlen 14                #32
      L2CAP: Command Reject (0x01) ident 3 len 6
        Reason: Invalid CID in request (0x0002)
        Destination CID: 64
        Source CID: 65
> HCI Event: Number of Completed Packets (0x13) plen 5      #33
        Num handles: 1
        Handle: 256
        Count: 1
...
=== After ===
...
> ACL Data RX: Handle 256 flags 0x02 dlen 12               #22
      L2CAP: Connection Request (0x02) ident 2 len 4
        PSM: 1 (0x0001)
        Source CID: 65
< ACL Data TX: Handle 256 flags 0x00 dlen 16               #23
      L2CAP: Connection Response (0x03) ident 2 len 8
        Destination CID: 64
        Source CID: 65
        Result: Connection successful (0x0000)
        Status: No further information available (0x0000)
< ACL Data TX: Handle 256 flags 0x00 dlen 12               #24
      L2CAP: Configure Request (0x04) ident 2 len 4
        Destination CID: 65
        Flags: 0x0000
> HCI Event: Number of Completed Packets (0x13) plen 5     #25
        Num handles: 1
        Handle: 256
        Count: 1
> HCI Event: Number of Completed Packets (0x13) plen 5     #26
        Num handles: 1
        Handle: 256
        Count: 1
> ACL Data RX: Handle 256 flags 0x02 dlen 16               #27
      L2CAP: Configure Request (0x04) ident 3 len 8
        Destination CID: 64
        Flags: 0x0000
        Option: Unknown (0x10) [hint]
        01 00                                            ..
< ACL Data TX: Handle 256 flags 0x00 dlen 18               #28
      L2CAP: Configure Response (0x05) ident 3 len 10
        Source CID: 65
        Flags: 0x0000
        Result: Success (0x0000)
        Option: Maximum Transmission Unit (0x01) [mandatory]
          MTU: 672
> HCI Event: Number of Completed Packets (0x13) plen 5     #29
        Num handles: 1
        Handle: 256
        Count: 1
> ACL Data RX: Handle 256 flags 0x02 dlen 14               #30
      L2CAP: Configure Response (0x05) ident 2 len 6
        Source CID: 64
        Flags: 0x0000
        Result: Success (0x0000)
> ACL Data RX: Handle 256 flags 0x02 dlen 20               #31
      L2CAP: Configure Request (0x04) ident 3 len 12
        Destination CID: 64
        Flags: 0x0000
        Option: Unknown (0x10) [hint]
        01 00 91 02 11 11                                .....
< ACL Data TX: Handle 256 flags 0x00 dlen 18               #32
      L2CAP: Configure Response (0x05) ident 3 len 10
        Source CID: 65
        Flags: 0x0000
        Result: Success (0x0000)
        Option: Maximum Transmission Unit (0x01) [mandatory]
          MTU: 672
< ACL Data TX: Handle 256 flags 0x00 dlen 12               #33
      L2CAP: Configure Request (0x04) ident 3 len 4
        Destination CID: 65
        Flags: 0x0000
> HCI Event: Number of Completed Packets (0x13) plen 5     #34
        Num handles: 1
        Handle: 256
        Count: 1
> HCI Event: Number of Completed Packets (0x13) plen 5     #35
        Num handles: 1
        Handle: 256
        Count: 1
...

Signed-off-by: Howard Chung <howardchung@google.com>

---

Changes in v2:
- Updated commit messages

 net/bluetooth/l2cap_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 697c0f7f2c1a..5e6e35ab44dd 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4300,7 +4300,8 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
 		return 0;
 	}
 
-	if (chan->state != BT_CONFIG && chan->state != BT_CONNECT2) {
+	if (chan->state != BT_CONFIG && chan->state != BT_CONNECT2 &&
+	    chan->state != BT_CONNECTED) {
 		cmd_reject_invalid_cid(conn, cmd->ident, chan->scid,
 				       chan->dcid);
 		goto unlock;
-- 
2.25.1.481.gfbce0eb801-goog

