Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328B0286319
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 18:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgJGQDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 12:03:50 -0400
Received: from mxout03.lancloud.ru ([89.108.73.187]:39426 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728503AbgJGQDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 12:03:50 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru BEBF82092EC1
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: [PATCH 1/2] bluetooth: hci_event: consolidate error paths in
 hci_phy_link_complete_evt()
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        <linux-bluetooth@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
References: <bbdd9cbe-b65e-b309-1188-71a3a4ca6fdc@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <b508265e-f08f-ea24-2815-bc2a5ec10d8d@omprussia.ru>
Date:   Wed, 7 Oct 2020 18:54:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <bbdd9cbe-b65e-b309-1188-71a3a4ca6fdc@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.87.153.155]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hci_phy_link_complete_evt() has several duplicate error paths -- consolidate
them, using the *goto* statements.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

---
 net/bluetooth/hci_event.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

Index: bluetooth-next/net/bluetooth/hci_event.c
===================================================================
--- bluetooth-next.orig/net/bluetooth/hci_event.c
+++ bluetooth-next/net/bluetooth/hci_event.c
@@ -4936,20 +4936,15 @@ static void hci_phy_link_complete_evt(st
 	hci_dev_lock(hdev);
 
 	hcon = hci_conn_hash_lookup_handle(hdev, ev->phy_handle);
-	if (!hcon) {
-		hci_dev_unlock(hdev);
-		return;
-	}
+	if (!hcon)
+		goto unlock;
 
-	if (!hcon->amp_mgr) {
-		hci_dev_unlock(hdev);
-		return;
-	}
+	if (!hcon->amp_mgr)
+		goto unlock;
 
 	if (ev->status) {
 		hci_conn_del(hcon);
-		hci_dev_unlock(hdev);
-		return;
+		goto unlock;
 	}
 
 	bredr_hcon = hcon->amp_mgr->l2cap_conn->hcon;
@@ -4966,6 +4961,7 @@ static void hci_phy_link_complete_evt(st
 
 	amp_physical_cfm(bredr_hcon, hcon);
 
+unlock:
 	hci_dev_unlock(hdev);
 }
 
