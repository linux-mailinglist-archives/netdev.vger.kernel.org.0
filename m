Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8BC243B38
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 16:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgHMOIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 10:08:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45988 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgHMOIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 10:08:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07DE6fab136093;
        Thu, 13 Aug 2020 14:08:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=xCZ6+5wBr9Kp/jc7JBCHhLKeSVLpCQDfnVyN5MY6Cy4=;
 b=y1mnDaTWaQfkKuNdswqR9EGh9nwLAS1FjtMJfH7JIuCMUf4Lsql1ByzvAo38WdSufi1A
 U2+Vh/l7Pg1Bupu8o3OxLnOs44f75gPudTq4lxsk0+2FyZ7cyx1TsNRCMCjRZ5q3LWqh
 kYaSGiZ1VPUQfOQYLTMlI8bsOw0MI0Xev8jsmrqdqtyubs/Kmb+KMbroZfCi0/yBiysK
 Dunuz+zY/aqQs2BCmQGU9I2PWyNW48RD2G4DIF951EOv551sZwAzgTXwp2Lqrj413B9c
 qz9P7awiachhScsTnUCDE18orK+a+DJ8hvm5oiF7B+CCeuKuBg20CugqXhKF43LPcq3P KA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32smpnrtkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Aug 2020 14:08:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07DDvYmQ191005;
        Thu, 13 Aug 2020 14:06:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 32u3h5fjw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 14:06:17 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07DE6Ew1029177;
        Thu, 13 Aug 2020 14:06:14 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 Aug 2020 14:06:13 +0000
Date:   Thu, 13 Aug 2020 17:06:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andri Yngvason <andri.yngvason@marel.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] can: peak_usb: add range checking in decode operations
Message-ID: <20200813140604.GA456946@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008130105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9711 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 impostorscore=0 phishscore=0 clxscore=1011 spamscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008130106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These values come from skb->data so Smatch considers them untrusted.  I
believe Smatch is correct but I don't have a way to test this.

The usb_if->dev[] array has 2 elements but the index is in the 0-15
range without checks.  The cfd->len can be up to 255 but the maximum
valid size is CANFD_MAX_DLEN (64) so that could lead to memory
corruption.

Fixes: 0a25e1f4f185 ("can: peak_usb: add support for PEAK new CANFD USB adapters")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 48 +++++++++++++++++-----
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
index 47cc1ff5b88e..dee3e689b54d 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
@@ -468,12 +468,18 @@ static int pcan_usb_fd_decode_canmsg(struct pcan_usb_fd_if *usb_if,
 				     struct pucan_msg *rx_msg)
 {
 	struct pucan_rx_msg *rm = (struct pucan_rx_msg *)rx_msg;
-	struct peak_usb_device *dev = usb_if->dev[pucan_msg_get_channel(rm)];
-	struct net_device *netdev = dev->netdev;
+	struct peak_usb_device *dev;
+	struct net_device *netdev;
 	struct canfd_frame *cfd;
 	struct sk_buff *skb;
 	const u16 rx_msg_flags = le16_to_cpu(rm->flags);
 
+	if (pucan_msg_get_channel(rm) >= ARRAY_SIZE(usb_if->dev))
+		return -ENOMEM;
+
+	dev = usb_if->dev[pucan_msg_get_channel(rm)];
+	netdev = dev->netdev;
+
 	if (rx_msg_flags & PUCAN_MSG_EXT_DATA_LEN) {
 		/* CANFD frame case */
 		skb = alloc_canfd_skb(netdev, &cfd);
@@ -519,15 +525,21 @@ static int pcan_usb_fd_decode_status(struct pcan_usb_fd_if *usb_if,
 				     struct pucan_msg *rx_msg)
 {
 	struct pucan_status_msg *sm = (struct pucan_status_msg *)rx_msg;
-	struct peak_usb_device *dev = usb_if->dev[pucan_stmsg_get_channel(sm)];
-	struct pcan_usb_fd_device *pdev =
-			container_of(dev, struct pcan_usb_fd_device, dev);
+	struct pcan_usb_fd_device *pdev;
 	enum can_state new_state = CAN_STATE_ERROR_ACTIVE;
 	enum can_state rx_state, tx_state;
-	struct net_device *netdev = dev->netdev;
+	struct peak_usb_device *dev;
+	struct net_device *netdev;
 	struct can_frame *cf;
 	struct sk_buff *skb;
 
+	if (pucan_stmsg_get_channel(sm) >= ARRAY_SIZE(usb_if->dev))
+		return -ENOMEM;
+
+	dev = usb_if->dev[pucan_stmsg_get_channel(sm)];
+	pdev = container_of(dev, struct pcan_usb_fd_device, dev);
+	netdev = dev->netdev;
+
 	/* nothing should be sent while in BUS_OFF state */
 	if (dev->can.state == CAN_STATE_BUS_OFF)
 		return 0;
@@ -579,9 +591,14 @@ static int pcan_usb_fd_decode_error(struct pcan_usb_fd_if *usb_if,
 				    struct pucan_msg *rx_msg)
 {
 	struct pucan_error_msg *er = (struct pucan_error_msg *)rx_msg;
-	struct peak_usb_device *dev = usb_if->dev[pucan_ermsg_get_channel(er)];
-	struct pcan_usb_fd_device *pdev =
-			container_of(dev, struct pcan_usb_fd_device, dev);
+	struct pcan_usb_fd_device *pdev;
+	struct peak_usb_device *dev;
+
+	if (pucan_ermsg_get_channel(er) >= ARRAY_SIZE(usb_if->dev))
+		return -EINVAL;
+
+	dev = usb_if->dev[pucan_ermsg_get_channel(er)];
+	pdev = container_of(dev, struct pcan_usb_fd_device, dev);
 
 	/* keep a trace of tx and rx error counters for later use */
 	pdev->bec.txerr = er->tx_err_cnt;
@@ -595,11 +612,17 @@ static int pcan_usb_fd_decode_overrun(struct pcan_usb_fd_if *usb_if,
 				      struct pucan_msg *rx_msg)
 {
 	struct pcan_ufd_ovr_msg *ov = (struct pcan_ufd_ovr_msg *)rx_msg;
-	struct peak_usb_device *dev = usb_if->dev[pufd_omsg_get_channel(ov)];
-	struct net_device *netdev = dev->netdev;
+	struct peak_usb_device *dev;
+	struct net_device *netdev;
 	struct can_frame *cf;
 	struct sk_buff *skb;
 
+	if (pufd_omsg_get_channel(ov) >= ARRAY_SIZE(usb_if->dev))
+		return -EINVAL;
+
+	dev = usb_if->dev[pufd_omsg_get_channel(ov)];
+	netdev = dev->netdev;
+
 	/* allocate an skb to store the error frame */
 	skb = alloc_can_err_skb(netdev, &cf);
 	if (!skb)
@@ -716,6 +739,9 @@ static int pcan_usb_fd_encode_msg(struct peak_usb_device *dev,
 	u16 tx_msg_size, tx_msg_flags;
 	u8 can_dlc;
 
+	if (cfd->len > CANFD_MAX_DLEN)
+		return -EINVAL;
+
 	tx_msg_size = ALIGN(sizeof(struct pucan_tx_msg) + cfd->len, 4);
 	tx_msg->size = cpu_to_le16(tx_msg_size);
 	tx_msg->type = cpu_to_le16(PUCAN_MSG_CAN_TX);
-- 
2.28.0

