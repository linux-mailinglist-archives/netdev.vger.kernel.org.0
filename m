Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 417B954DE2D
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 11:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiFPJ3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 05:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiFPJ3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 05:29:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04413B3DA
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 02:29:33 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1o1loV-0006Nn-3D; Thu, 16 Jun 2022 11:29:19 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <afa@pengutronix.de>)
        id 1o1loR-000qKx-HY; Thu, 16 Jun 2022 11:29:16 +0200
Received: from afa by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <afa@pengutronix.de>)
        id 1o1loS-0036eS-5M; Thu, 16 Jun 2022 11:29:16 +0200
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>, kernel@pengutronix.de,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: hci_sync: complete LE connection on any event
Date:   Thu, 16 Jun 2022 11:24:20 +0200
Message-Id: <20220616092418.738877-1-a.fatoum@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: afa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 6cd29ec6ae5e ("Bluetooth: hci_sync: Wait for proper events when
connecting LE") changed HCI core to wait for specific events before
posting completion for a new LE connection. This commit introduced
regressions partially fixed in commits a56a1138cbd8
("Bluetooth: hci_sync: Fix not using conn_timeout") and
and c9f73a2178c1 ("Bluetooth: hci_conn: Fix hci_connect_le_sync").

Yet, a regression still remains where devices that worked previously
now timeout[1][2]. Restore working order by reverting the commit in
question until this issue can be properly resolved.

[1]: https://lore.kernel.org/linux-bluetooth/a1ce1743-e450-6cdb-dfab-56a3e3eb9aed@pengutronix.de/
[2]: https://github.com/bluez/bluez/issues/340

Fixes: 6cd29ec6ae5e ("Bluetooth: hci_sync: Wait for proper events when connecting LE")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
---
Event callbacks like hci_le_meta_evt() use hci_skb_event(hdev->sent_cmd)
for matching. I suspect the timeout is due to intermittent frames,
e.g. because of remote unpairing, replacing the sent_cmd and thus
breaking renewed pairing as the frames couldn't be matched. This is too
complex for me to fix and we have been carrying this fix for a month now,
so I think it's best we revert this upstream for now.

#regzb Link: https://lore.kernel.org/linux-bluetooth/a1ce1743-e450-6cdb-dfab-56a3e3eb9aed@pengutronix.de/
Cc: kernel@pengutronix.de
---
 net/bluetooth/hci_sync.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 286d6767f017..4cecf15922d4 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5272,7 +5272,7 @@ static int hci_le_ext_create_conn_sync(struct hci_dev *hdev,
 
 	return __hci_cmd_sync_status_sk(hdev, HCI_OP_LE_EXT_CREATE_CONN,
 					plen, data,
-					HCI_EV_LE_ENHANCED_CONN_COMPLETE,
+					0,
 					conn->conn_timeout, NULL);
 }
 
@@ -5366,9 +5366,7 @@ int hci_le_create_conn_sync(struct hci_dev *hdev, struct hci_conn *conn)
 	 */
 	err = __hci_cmd_sync_status_sk(hdev, HCI_OP_LE_CREATE_CONN,
 				       sizeof(cp), &cp,
-				       use_enhanced_conn_complete(hdev) ?
-				       HCI_EV_LE_ENHANCED_CONN_COMPLETE :
-				       HCI_EV_LE_CONN_COMPLETE,
+				       0,
 				       conn->conn_timeout, NULL);
 
 done:
-- 
2.30.2

