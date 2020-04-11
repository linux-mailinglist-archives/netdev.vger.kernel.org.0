Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 401AD1A58C5
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbgDKXKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:10:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbgDKXKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:10:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D830320787;
        Sat, 11 Apr 2020 23:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646609;
        bh=L7usoMfa+pEQiXXtn3sfbAzram5W8WNwR3FcHvNx+yM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q97KD400Lry9yB7UvWoRjGPrJNNjGr8Qr0zXeTsPx4exA02ONk35a7ilCOCB3RLLe
         PV4Xox5tBnb27jlN2niLvRQn1/y5qHcqGe8xw/zsBuEmFwxXTgQ4gpifnhkuqeW+QX
         demHtmfzklhXXBP2xKhVcDL2Wr4xq8ZL6sJIOXps=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Howard Chung <howardchung@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 021/108] Bluetooth: L2CAP: handle l2cap config request during open state
Date:   Sat, 11 Apr 2020 19:08:16 -0400
Message-Id: <20200411230943.24951-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Howard Chung <howardchung@google.com>

[ Upstream commit 96298f640104e4cd9a913a6e50b0b981829b94ff ]

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
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index a845786258a0b..2f3e437faedbc 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -4131,7 +4131,8 @@ static inline int l2cap_config_req(struct l2cap_conn *conn,
 		return 0;
 	}
 
-	if (chan->state != BT_CONFIG && chan->state != BT_CONNECT2) {
+	if (chan->state != BT_CONFIG && chan->state != BT_CONNECT2 &&
+	    chan->state != BT_CONNECTED) {
 		cmd_reject_invalid_cid(conn, cmd->ident, chan->scid,
 				       chan->dcid);
 		goto unlock;
-- 
2.20.1

