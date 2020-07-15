Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B3A220E98
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 16:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731990AbgGOOAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 10:00:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36228 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbgGOOAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 10:00:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FDuxe3028030;
        Wed, 15 Jul 2020 13:59:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=X5aHssNeQL48ZUYU8QwYkzEedA7YhYPjUmyihWY11gA=;
 b=Ik7tm6sbOizfEOqKf9I8JviWMD62YT1K0G+WDStPln8KtDp3mttY97JvbHKCtkARki4L
 7xv/DMqzHvQXgoaK2ISKk9T66SlUyCKy3AMCUMHwDtm1bMMRcYFJHzlvWErmoJu7nDXb
 KsV62/+ITFSS+xZVlrZfZnc6JAbEhieviilOyXdzuQEtnr2H5lU+/bIkrShZcjsr+P/B
 Hwplj0V88ggMdaEeFt/1/np5Mz2Zj6cCg10f1UODERB5ZclVWA627wKc41gfAaK8nWqh
 GzqgpS6pTZvFH0XNobczRrrRTBuZlMJvXmnynNGAOGjdg2xMwlOrwba6wuVVVdsPvvag 1Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3275cmbhk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 13:59:57 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FDvePZ050473;
        Wed, 15 Jul 2020 13:59:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 327q6uhavu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 13:59:56 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06FDxsLr012747;
        Wed, 15 Jul 2020 13:59:54 GMT
Received: from dhcp-10-152-34-21.usdhcp.oraclecorp.com.com (/10.152.34.21)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 06:59:54 -0700
From:   George Kennedy <george.kennedy@oracle.com>
To:     george.kennedy@oracle.com, davem@davemloft.net,
        netdev@vger.kernel.org, dan.carpenter@oracle.com, kuba@kernel.org,
        dhaval.giani@oracle.com
Subject: [PATCH v2 1/1] ax88172a: fix ax88172a_unbind() failures
Date:   Wed, 15 Jul 2020 09:59:31 -0400
Message-Id: <1594821571-17833-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=11
 phishscore=0 malwarescore=0 mlxlogscore=985 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=11 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If ax88172a_unbind() fails, make sure that the return code is
less than zero so that cleanup is done properly and avoid UAF.

Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Reported-by: syzbot+4cd84f527bf4a10fc9c1@syzkaller.appspotmail.com
---
 drivers/net/usb/ax88172a.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
index 4e514f5..fd3a04d 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -187,6 +187,7 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
 	ret = asix_read_cmd(dev, AX_CMD_READ_NODE_ID, 0, 0, ETH_ALEN, buf, 0);
 	if (ret < ETH_ALEN) {
 		netdev_err(dev->net, "Failed to read MAC address: %d\n", ret);
+		ret = -EIO;
 		goto free;
 	}
 	memcpy(dev->net->dev_addr, buf, ETH_ALEN);
-- 
1.8.3.1

