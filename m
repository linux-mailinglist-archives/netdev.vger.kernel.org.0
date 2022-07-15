Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D284E575B98
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 08:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiGOGbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 02:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiGOGaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 02:30:52 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B0F17046;
        Thu, 14 Jul 2022 23:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1657866651; x=1689402651;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=IKTE0WsoHbdtCDClI7Fv5lrmNNiRt8z95iB21d4OgXE=;
  b=PfAUa8jbYjjqES2iv10HPKqFzxPUHJEBg+dR2WSTLRmLb5dbuO6ZbA5t
   bLJX7EbKepBkti2OfsTxv6cMB+KpWW6l+tnOd0OwA0KoClLAmkfgSqCQF
   rO1UER3a+ZAYfA/ZwqkP/n0rFViMZRx9dwfDwRMaBVaJbXDWNq5kXxHid
   8=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 14 Jul 2022 23:30:50 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 23:30:50 -0700
Received: from zijuhu-gv.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 14 Jul 2022 23:30:45 -0700
From:   Zijun Hu <quic_zijuhu@quicinc.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <luiz.von.dentz@intel.com>, <quic_zijuhu@quicinc.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v3] Bluetooth: hci_sync: Remove redundant func definition
Date:   Fri, 15 Jul 2022 14:30:41 +0800
Message-ID: <1657866641-16668-1-git-send-email-quic_zijuhu@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

both hci_request.c and hci_sync.c have the same definition
for disconnected_accept_list_entries(), so remove a redundant
copy.

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
---
v2->v3
 -remove table char to solve gitlint checking failure
v1->v2
 -remove the func copy within hci_request.c instead of hci_sync.c
 net/bluetooth/hci_request.c | 18 ------------------
 net/bluetooth/hci_request.h |  2 ++
 net/bluetooth/hci_sync.c    |  2 +-
 3 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 635cc5fb451e..edec0447aaa7 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1784,24 +1784,6 @@ int hci_update_random_address(struct hci_request *req, bool require_privacy,
 	return 0;
 }
 
-static bool disconnected_accept_list_entries(struct hci_dev *hdev)
-{
-	struct bdaddr_list *b;
-
-	list_for_each_entry(b, &hdev->accept_list, list) {
-		struct hci_conn *conn;
-
-		conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &b->bdaddr);
-		if (!conn)
-			return true;
-
-		if (conn->state != BT_CONNECTED && conn->state != BT_CONFIG)
-			return true;
-	}
-
-	return false;
-}
-
 void __hci_req_update_scan(struct hci_request *req)
 {
 	struct hci_dev *hdev = req->hdev;
diff --git a/net/bluetooth/hci_request.h b/net/bluetooth/hci_request.h
index 7f8df258e295..e80b500878d9 100644
--- a/net/bluetooth/hci_request.h
+++ b/net/bluetooth/hci_request.h
@@ -120,6 +120,8 @@ void __hci_req_update_scan(struct hci_request *req);
 int hci_update_random_address(struct hci_request *req, bool require_privacy,
 			      bool use_rpa, u8 *own_addr_type);
 
+bool disconnected_accept_list_entries(struct hci_dev *hdev);
+
 int hci_abort_conn(struct hci_conn *conn, u8 reason);
 void __hci_abort_conn(struct hci_request *req, struct hci_conn *conn,
 		      u8 reason);
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 212b0cdb25f5..48a262f0ae49 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2419,7 +2419,7 @@ int hci_write_fast_connectable_sync(struct hci_dev *hdev, bool enable)
 	return err;
 }
 
-static bool disconnected_accept_list_entries(struct hci_dev *hdev)
+bool disconnected_accept_list_entries(struct hci_dev *hdev)
 {
 	struct bdaddr_list *b;
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

