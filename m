Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D6BFB788
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 19:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbfKMS3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 13:29:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:54704 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbfKMS3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 13:29:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADIT0iJ118599;
        Wed, 13 Nov 2019 18:29:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=sGr/DIDnGTYsdgAAQOAvzvtrIvWYjXZuC3b0kLtXOyQ=;
 b=qA7Rtcc1IjJd8veNVWpkLuSGb6JekNurHL20+l6ioCTm0Ig7SWhXpAbRiQ3x7u6epKP6
 IBS1VVe/9rTZhbbmXWlBNTfTJ4W3CQvdfpOQVnToGNSBpGACYkOo8D10B+JodCm7v5VH
 qyYmmAP3T+pPnQ2bAQWVq6GUgNMJN/pn6EC/97fVSgp6FYAtxdmlS9tyu4wdkemmtXq9
 wqGshAqHvOlsQphxP2AbxocamwN0gATjkjm6pllyPJv8KFr/ZzNs8vuqEUfgpoO2znpN
 517d381eIE2qY5GwLT33S/lbrXPmjGMrJdIKnbR3NBZZC+TpUAMigWxuIVYSCw5bwgjt Lg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w5ndqedyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 18:29:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADISxlZ160232;
        Wed, 13 Nov 2019 18:29:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w7vppqqp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 18:29:03 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xADISeZw031201;
        Wed, 13 Nov 2019 18:28:40 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Nov 2019 10:28:40 -0800
Date:   Wed, 13 Nov 2019 21:28:31 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Oliver Neukum <oliver@neukum.org>
Cc:     "David S. Miller" <davem@davemloft.net>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: cdc_ncm: Signedness bug in cdc_ncm_set_dgram_size()
Message-ID: <20191113182831.yjbmhwacirh6kgzr@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9440 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130158
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code is supposed to test for negative error codes and partial
reads, but because sizeof() is size_t (unsigned) type then negative
error codes are type promoted to high positive values and the condition
doesn't work as expected.

Fixes: 332f989a3b00 ("CDC-NCM: handle incomplete transfer of MTU")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/usb/cdc_ncm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index a245597a3902..c2c82e6391b4 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -579,7 +579,7 @@ static void cdc_ncm_set_dgram_size(struct usbnet *dev, int new_size)
 	err = usbnet_read_cmd(dev, USB_CDC_GET_MAX_DATAGRAM_SIZE,
 			      USB_TYPE_CLASS | USB_DIR_IN | USB_RECIP_INTERFACE,
 			      0, iface_no, &max_datagram_size, sizeof(max_datagram_size));
-	if (err < sizeof(max_datagram_size)) {
+	if (err != sizeof(max_datagram_size)) {
 		dev_dbg(&dev->intf->dev, "GET_MAX_DATAGRAM_SIZE failed\n");
 		goto out;
 	}
-- 
2.11.0

