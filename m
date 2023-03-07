Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2846AEEBF
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232587AbjCGSPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbjCGSOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:14:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796A6A400D;
        Tue,  7 Mar 2023 10:10:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7B0AECE1C6A;
        Tue,  7 Mar 2023 18:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CF2C433EF;
        Tue,  7 Mar 2023 18:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212623;
        bh=Vv+iVSSOi8Umlt3lBcorE0IUmeDtulkHvsT93WekQvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XtKE3wyF+RdxuNbcJi7CYQjbuz9oiY1Bj6sBA5hIivzSpyPgb6iQoYlXzSNmktc26
         x6+B//SEw8zDgjMiii0hHawxwqW/J6GIQuvL31oX2v/XhhoJBESv/FCvku9YztDlOb
         uFko4lFoGvqxCiVdHiP3OqHQAKlHt3+dpwCmkYK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Simon Horman <simon.horman@corigine.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 213/885] Bluetooth: hci_conn: Refactor hci_bind_bis() since it always succeeds
Date:   Tue,  7 Mar 2023 17:52:27 +0100
Message-Id: <20230307170011.338040639@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit a00a29b0eeea6caaaf9edc3dd284f81b072ee343 ]

The compiler thinks "conn" might be NULL after a call to hci_bind_bis(),
which cannot happen. Avoid any confusion by just making it not return a
value since it cannot fail. Fixes the warnings seen with GCC 13:

In function 'arch_atomic_dec_and_test',
    inlined from 'atomic_dec_and_test' at ../include/linux/atomic/atomic-instrumented.h:576:9,
    inlined from 'hci_conn_drop' at ../include/net/bluetooth/hci_core.h:1391:6,
    inlined from 'hci_connect_bis' at ../net/bluetooth/hci_conn.c:2124:3:
../arch/x86/include/asm/rmwcc.h:37:9: warning: array subscript 0 is outside array bounds of 'atomic_t[0]' [-Warray-bounds=]
   37 |         asm volatile (fullop CC_SET(cc) \
      |         ^~~
...
In function 'hci_connect_bis':
cc1: note: source object is likely at address zero

Fixes: eca0ae4aea66 ("Bluetooth: Add initial implementation of BIS connections")
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-bluetooth@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 3c3b79f2e4c03..09e7f841f149d 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1983,16 +1983,14 @@ static void hci_iso_qos_setup(struct hci_dev *hdev, struct hci_conn *conn,
 		qos->latency = conn->le_conn_latency;
 }
 
-static struct hci_conn *hci_bind_bis(struct hci_conn *conn,
-				     struct bt_iso_qos *qos)
+static void hci_bind_bis(struct hci_conn *conn,
+			 struct bt_iso_qos *qos)
 {
 	/* Update LINK PHYs according to QoS preference */
 	conn->le_tx_phy = qos->out.phy;
 	conn->le_tx_phy = qos->out.phy;
 	conn->iso_qos = *qos;
 	conn->state = BT_BOUND;
-
-	return conn;
 }
 
 static int create_big_sync(struct hci_dev *hdev, void *data)
@@ -2128,11 +2126,7 @@ struct hci_conn *hci_connect_bis(struct hci_dev *hdev, bdaddr_t *dst,
 	if (IS_ERR(conn))
 		return conn;
 
-	conn = hci_bind_bis(conn, qos);
-	if (!conn) {
-		hci_conn_drop(conn);
-		return ERR_PTR(-ENOMEM);
-	}
+	hci_bind_bis(conn, qos);
 
 	/* Add Basic Announcement into Peridic Adv Data if BASE is set */
 	if (base_len && base) {
-- 
2.39.2



