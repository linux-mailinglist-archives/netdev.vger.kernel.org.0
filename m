Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E082C68CAA0
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 00:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjBFXji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 18:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjBFXjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 18:39:37 -0500
Received: from stravinsky.debian.org (stravinsky.debian.org [IPv6:2001:41b8:202:deb::311:108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E5923C4E;
        Mon,  6 Feb 2023 15:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
        s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:MIME-Version
        :References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=d2aAI7nq5qjPdi4iyodyYV5YWQahnsSAlmEeUrEnhGQ=; b=CkJ2/sNnuduAI7IgD9RMXvl+wy
        8lpmCIXqdrHxKPe1u6iI8SAunPN82zw2RKIKz6F43nR6w8L+YspK4XtLCnIJ05Df9TlHMugrTYyYW
        8hENvdJLmTpwFhW8qF37/IxNfmu3zMl7HzOJp/LmPwNogqNHoPqRydksFFJ+rsLuijVUGaXGGLhKQ
        HsVAWlSWkpvXQaDc7EAeClqMTc5jdYO579lVzg4NQlU+8R+K8oy0Orz/pEMZH2nlIrTCsQ5jvqGtK
        ERz5savZSehOsCmuCH+bHe08ItUNPNqPIbcTyUfwEQoPBt16rQ1dPZMaCX4Jl64K4F6RIf3wuNfNs
        yA30kUtg==;
Received: from authenticated user
        by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <bage@debian.org>)
        id 1pPB53-00CT8W-Kq; Mon, 06 Feb 2023 23:39:25 +0000
From:   Bastian Germann <bage@debian.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Vasily Khoruzhick <anarsoul@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Bastian Germann <bage@debian.org>
Subject: [PATCH v3 1/2] Bluetooth: Add new quirk for broken local ext features page 2
Date:   Tue,  7 Feb 2023 00:39:10 +0100
Message-Id: <20230206233912.9410-2-bage@debian.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206233912.9410-1-bage@debian.org>
References: <20230206233912.9410-1-bage@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Debian-User: bage
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Khoruzhick <anarsoul@gmail.com>

Some adapters (e.g. RTL8723CS) advertise that they have more than
2 pages for local ext features, but they don't support any features
declared in these pages. RTL8723CS reports max_page = 2 and declares
support for sync train and secure connection, but it responds with
either garbage or with error in status on corresponding commands.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Signed-off-by: Bastian Germann <bage@debian.org>
---
 include/net/bluetooth/hci.h | 7 +++++++
 net/bluetooth/hci_event.c   | 4 +++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 8d773b042c85..7127313140cf 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -294,6 +294,13 @@ enum {
 	 * during the hdev->setup vendor callback.
 	 */
 	HCI_QUIRK_BROKEN_MWS_TRANSPORT_CONFIG,
+
+	/* When this quirk is set, max_page for local extended features
+	 * is set to 1, even if controller reports higher number. Some
+	 * controllers (e.g. RTL8723CS) report more pages, but they
+	 * don't actually support features declared there.
+	 */
+	HCI_QUIRK_BROKEN_LOCAL_EXT_FEATURES_PAGE_2,
 };
 
 /* HCI device flags */
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index ad92a4be5851..83ebc8e65b42 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -886,7 +886,9 @@ static u8 hci_cc_read_local_ext_features(struct hci_dev *hdev, void *data,
 	if (rp->status)
 		return rp->status;
 
-	if (hdev->max_page < rp->max_page)
+	if (!test_bit(HCI_QUIRK_BROKEN_LOCAL_EXT_FEATURES_PAGE_2,
+		      &hdev->quirks) &&
+	    hdev->max_page < rp->max_page)
 		hdev->max_page = rp->max_page;
 
 	if (rp->page < HCI_MAX_PAGES)
-- 
2.39.1

