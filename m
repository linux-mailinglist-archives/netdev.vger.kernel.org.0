Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2661821D570
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgGML7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:59:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58808 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728382AbgGML7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:59:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DBquLi054050;
        Mon, 13 Jul 2020 11:59:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id; s=corp-2020-01-29;
 bh=6GfIvdrYzUJSwmqErb69295pyab1LqwVAjC8pe/INEk=;
 b=vWmnrcKt0ZO6n6KIgEFnrepxekgV4OvVdmdypKrjPh1E0wLjYkj/DpK7ZXMh5trU5k+S
 Kpe9sBfLbxiYeFwQAUOlXkmaQAkGdbEj1MUMTpqY7HeMbJZdgA+fTHmsux5lbQawA93q
 4Rafoci3Oh3/rMlPXzx8h+YOqjNuqKqE+4anb42MkvzZSOzcn7hphVXA5xXTbk0z7UD3
 WEIryVLJJhhlPG9tURbzEpyfJ6OMPDCEWBmmgtcrGRXvo3L7laLBDtoZfJOMfGWDp69E
 QlPzJbQHJliv9KPIi0Dra3PWpLddcfgBuzmEURCUYKvFIlwaHPgUwVQaVrwXAHVUFTDM NQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32762n6ef1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jul 2020 11:59:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DBrcGo127397;
        Mon, 13 Jul 2020 11:59:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 327q0m82qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jul 2020 11:59:24 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06DBxNpV007358;
        Mon, 13 Jul 2020 11:59:23 GMT
Received: from dhcp-10-152-34-21.usdhcp.oraclecorp.com.com (/10.152.34.21)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 04:59:22 -0700
From:   George Kennedy <george.kennedy@oracle.com>
To:     george.kennedy@oracle.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com, dhaval.giani@oracle.com,
        netdev@vger.kernel.org
Subject: [PATCH 1/1] ax88172a: fix ax88172a_unbind() failures
Date:   Mon, 13 Jul 2020 07:58:57 -0400
Message-Id: <1594641537-1288-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9680 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=947 bulkscore=0 adultscore=0 phishscore=0 suspectscore=11
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130089
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9680 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1011 priorityscore=1501 mlxlogscore=969 lowpriorityscore=0
 bulkscore=0 suspectscore=11 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130089
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If ax88172a_unbind() fails, make sure that the return code is
less than zero so that cleanup is done properly and avoid UAF.

Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Reported-by: syzbot+4cd84f527bf4a10fc9c1@syzkaller.appspotmail.com
---
 drivers/net/usb/ax88172a.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
index 4e514f5..fd9faf2 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -237,6 +237,8 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
 
 free:
 	kfree(priv);
+	if (ret >= 0)
+		ret = -EIO;
 	return ret;
 }
 
-- 
1.8.3.1

