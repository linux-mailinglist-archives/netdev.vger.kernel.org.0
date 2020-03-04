Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A04D5179240
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 15:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgCDOZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 09:25:00 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58626 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729398AbgCDOY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 09:24:59 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 024ENxsI196239;
        Wed, 4 Mar 2020 14:24:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=mdNJZT+R9Wl9X6lUKY7ywTdeuLRuZU8N2jiMQrlzeP8=;
 b=ezKYPp5szdcAOu6oxch/fG/KAGQxXGRY7Nk7jl/d6rRavjmlcJEtMYFn2LtppQXRJEZ5
 3214kYn7a2/2XUZQbGerzTUFhUJAcWTJdgI4XV20D+fA59in3SCU1a6JjkafEMiFMOOi
 vyPppsM4av6DrddFZhFOKasxEKsqSxpjPK6CBqd+viDSJN0z36KiahdcWmOQOwdjmGon
 f1bd7+rFQ0yMD1tzFB97nlVzfJl/2TKdrODD7SM2+Lamq7N3Wt3ei4TioGqELRRgck+O
 T1g1DQ0ppjMXqt5g0zZ9bdERu9JyWcJ7Ul4cx1k6k9n4dPkm+p3PqlnRPFeksIBAEg2j MQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2yffcupn1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 14:24:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 024EDDjn170735;
        Wed, 4 Mar 2020 14:24:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2yg1h0y896-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Mar 2020 14:24:44 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 024EOeEB008114;
        Wed, 4 Mar 2020 14:24:40 GMT
Received: from kili.mountain (/41.210.146.162)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Mar 2020 06:24:40 -0800
Date:   Wed, 4 Mar 2020 17:24:31 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Christophe Ricard <christophe.ricard@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>, netdev@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: nfc: fix bounds checking bugs on "pipe"
Message-ID: <20200304142429.2734khtbfyyoxmwc@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003040109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003040109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is similar to commit 674d9de02aa7 ("NFC: Fix possible memory
corruption when handling SHDLC I-Frame commands") and commit d7ee81ad09f0
("NFC: nci: Add some bounds checking in nci_hci_cmd_received()") which
added range checks on "pipe".

The "pipe" variable comes skb->data[0] in nfc_hci_msg_rx_work().
It's in the 0-255 range.  We're using it as the array index into the
hdev->pipes[] array which has NFC_HCI_MAX_PIPES (128) members.

Fixes: 118278f20aa8 ("NFC: hci: Add pipes table to reference them with a tuple {gate, host}")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/nfc/hci/core.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/nfc/hci/core.c b/net/nfc/hci/core.c
index 6f1b096e601c..43811b5219b5 100644
--- a/net/nfc/hci/core.c
+++ b/net/nfc/hci/core.c
@@ -181,13 +181,20 @@ void nfc_hci_resp_received(struct nfc_hci_dev *hdev, u8 result,
 void nfc_hci_cmd_received(struct nfc_hci_dev *hdev, u8 pipe, u8 cmd,
 			  struct sk_buff *skb)
 {
-	u8 gate = hdev->pipes[pipe].gate;
 	u8 status = NFC_HCI_ANY_OK;
 	struct hci_create_pipe_resp *create_info;
 	struct hci_delete_pipe_noti *delete_info;
 	struct hci_all_pipe_cleared_noti *cleared_info;
+	u8 gate;
 
-	pr_debug("from gate %x pipe %x cmd %x\n", gate, pipe, cmd);
+	pr_debug("from pipe %x cmd %x\n", pipe, cmd);
+
+	if (pipe >= NFC_HCI_MAX_PIPES) {
+		status = NFC_HCI_ANY_E_NOK;
+		goto exit;
+	}
+
+	gate = hdev->pipes[pipe].gate;
 
 	switch (cmd) {
 	case NFC_HCI_ADM_NOTIFY_PIPE_CREATED:
@@ -375,8 +382,14 @@ void nfc_hci_event_received(struct nfc_hci_dev *hdev, u8 pipe, u8 event,
 			    struct sk_buff *skb)
 {
 	int r = 0;
-	u8 gate = hdev->pipes[pipe].gate;
+	u8 gate;
+
+	if (pipe >= NFC_HCI_MAX_PIPES) {
+		pr_err("Discarded event %x to invalid pipe %x\n", event, pipe);
+		goto exit;
+	}
 
+	gate = hdev->pipes[pipe].gate;
 	if (gate == NFC_HCI_INVALID_GATE) {
 		pr_err("Discarded event %x to unopened pipe %x\n", event, pipe);
 		goto exit;
-- 
2.11.0

