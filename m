Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC24953330D
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 23:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241965AbiEXVid convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 May 2022 17:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241961AbiEXVia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 17:38:30 -0400
Received: from sender11-of-o53.zoho.eu (sender11-of-o53.zoho.eu [31.186.226.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503CB7CB0E
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 14:38:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1653427341; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=b0vA92DoaPGCbvh5GAQDzhj1RCYG3rkzYb53XhGgWwjAavb8ZmW2JW2ea/EpUjRtgISSz5QuEO1+8hlKd9G/4tfL+vDfewikWr+8j7gOSSbUINqSkTi/9jsGQzH+pLofSmSs8Nou+zjLqPo4+gSBCIsOkGvmSwTk1uxzOV5a1bw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1653427341; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=mGz9geOh9bVL8VNTmK+t7n+LCbps3NKlP/XHOE2cdBw=; 
        b=JEUXSn1ZMumJ6Oyn2vEVEr/EKWQljGc/Rc3dtTbq7jsdn+guzK8uhRx9fuz/Duz/PDZAuspWC7dRl/D0q3OQJ5Ej04EJ+zeOXN4yK2aByeCuXOxr5xvdPHe+nrHiPp45zgR2EjPH0C3N2PNncKDNOsdc+qPUO5Wn7ve+/oyQzio=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=hostmaster@neglo.de;
        dmarc=pass header.from=<bage@debian.org>
Received: from localhost.localdomain (port-92-194-239-176.dynamic.as20676.net [92.194.239.176]) by mx.zoho.eu
        with SMTPS id 1653427340856773.1976815347725; Tue, 24 May 2022 23:22:20 +0200 (CEST)
From:   Bastian Germann <bage@debian.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kubakici@wp.pl>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vasily Khoruzhick <anarsoul@gmail.com>,
        Bastian Germann <bage@debian.org>
Message-ID: <20220524212155.16944-2-bage@debian.org>
Subject: [PATCH v2 1/3] Bluetooth: Add new quirk for broken local ext features max_page
Date:   Tue, 24 May 2022 23:21:52 +0200
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220524212155.16944-1-bage@debian.org>
References: <20220524212155.16944-1-bage@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=utf8
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
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
[rebase on current tree]
Signed-off-by: Bastian Germann <bage@debian.org>
---
 include/net/bluetooth/hci.h | 7 +++++++
 net/bluetooth/hci_event.c   | 4 +++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 69ef31cea582..af26e8051905 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -265,6 +265,13 @@ enum {
 	 * runtime suspend, because event filtering takes place there.
 	 */
 	HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL,
+
+	/* When this quirk is set, max_page for local extended features
+	 * is set to 1, even if controller reports higher number. Some
+	 * controllers (e.g. RTL8723CS) report more pages, but they
+	 * don't actually support features declared there.
+	 */
+	HCI_QUIRK_BROKEN_LOCAL_EXT_FTR_MAX_PAGE,
 };
 
 /* HCI device flags */
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 66451661283c..52b358c33344 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -837,7 +837,9 @@ static u8 hci_cc_read_local_ext_features(struct hci_dev *hdev, void *data,
 	if (rp->status)
 		return rp->status;
 
-	if (hdev->max_page < rp->max_page)
+	if (!test_bit(HCI_QUIRK_BROKEN_LOCAL_EXT_FTR_MAX_PAGE,
+		      &hdev->quirks) &&
+	    hdev->max_page < rp->max_page)
 		hdev->max_page = rp->max_page;
 
 	if (rp->page < HCI_MAX_PAGES)
-- 
2.36.1


