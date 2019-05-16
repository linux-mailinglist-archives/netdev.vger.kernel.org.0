Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A15E420E95
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 20:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfEPSYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 14:24:24 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51712 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbfEPSYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 14:24:24 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4GI8U6H143431;
        Thu, 16 May 2019 18:24:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=4j7nl/lugVcYOJ2ZZ2mkpxLy+WU9GL+7H5/DNu1fn4w=;
 b=jD24ko3288p4jxSg0KdkSXk5QRL+8ITbrN1fFTG1ndonwanqb9zRJ3QuDQd7Ulnt/to+
 hDtzUJo7c/sE6dXLrG+Ck3gW6TgEomkdu1XYeSbIyXx8XTPUwiEDEXQrVasQZ7QdY1/P
 55hLe19pAImiloK4I+WAh03CQvHRzrhfZ7WIwXgHkz2AnSsMw7HPsiMvdqmKleEAzNvf
 RJsTcE96Zqnne09E0Ps6Ylk4cckM3NCKFWFIme2qN2YDqWTDy9VLvPTXnfv/o2GhBrlO
 c8TenLJy6A5F2qnE4Ez1pqzYFBEZqtdPlhxczCZDf9HPZF9g/oEy3Jz21ycWOjNW9QQW iA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2sdkwe5ha6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 May 2019 18:24:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4GINOnv086365;
        Thu, 16 May 2019 18:24:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2sgp335rws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 May 2019 18:24:13 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4GIO8bE032421;
        Thu, 16 May 2019 18:24:09 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 May 2019 11:24:08 -0700
Date:   Thu, 16 May 2019 21:24:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Mark Salyzyn <salyzyn@android.com>,
        Andrea Parri <andrea.parri@amarulasolutions.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Allen Pais <allen.pais@oracle.com>,
        Young Xiao <YangX92@hotmail.com>
Subject: [PATCH] Bluetooth: hidp: NUL terminate a string in the compat ioctl
Message-ID: <20190516182400.GA8270@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9259 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905160115
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9259 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905160114
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change is similar to commit a1616a5ac99e ("Bluetooth: hidp: fix
buffer overflow") but for the compat ioctl.  We take a string from the
user and forgot to ensure that it's NUL terminated.

I have also changed the strncpy() in to strscpy() in hidp_setup_hid().
The difference is the strncpy() doesn't necessarily NUL terminate the
destination string.  Either change would fix the problem but it's nice
to take a belt and suspenders approach and do both.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/bluetooth/hidp/core.c | 2 +-
 net/bluetooth/hidp/sock.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index a442e21f3894..5abd423b55fa 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -775,7 +775,7 @@ static int hidp_setup_hid(struct hidp_session *session,
 	hid->version = req->version;
 	hid->country = req->country;
 
-	strncpy(hid->name, req->name, sizeof(hid->name));
+	strscpy(hid->name, req->name, sizeof(hid->name));
 
 	snprintf(hid->phys, sizeof(hid->phys), "%pMR",
 		 &l2cap_pi(session->ctrl_sock->sk)->chan->src);
diff --git a/net/bluetooth/hidp/sock.c b/net/bluetooth/hidp/sock.c
index 2151913892ce..03be6a4baef3 100644
--- a/net/bluetooth/hidp/sock.c
+++ b/net/bluetooth/hidp/sock.c
@@ -192,6 +192,7 @@ static int hidp_sock_compat_ioctl(struct socket *sock, unsigned int cmd, unsigne
 		ca.version = ca32.version;
 		ca.flags = ca32.flags;
 		ca.idle_to = ca32.idle_to;
+		ca32.name[sizeof(ca32.name) - 1] = '\0';
 		memcpy(ca.name, ca32.name, 128);
 
 		csock = sockfd_lookup(ca.ctrl_sock, &err);
-- 
2.20.1
