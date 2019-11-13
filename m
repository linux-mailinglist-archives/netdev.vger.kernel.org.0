Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F253FB7A0
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 19:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbfKMScK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 13:32:10 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:32868 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728338AbfKMScK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 13:32:10 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADITHU6127460;
        Wed, 13 Nov 2019 18:32:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=wlOESdlP+I6ba8vhVLFzp7uW7rzgqu2CF/S70dfvgRY=;
 b=J+qUVnxObzgaitTeoQEgY/Ke0/iFviBQ+jYcu8+Lc8VRUk9riMBoMp/Bx5tALjwsXiNs
 qPVUE361JUkUiX4zYQHKYtiPpplc0xZO1ZgEfDm/5+hT/ZsJAVLMS5i109D3RR0pje2y
 wG2/8MCFdmYdejHL0z5gQmufG6Qi5FkX3I+fj2T0stHwyIG/GR029pl/TphZrtKMknp2
 BhTNRMJER1IXMEA4QqbqKPf/YvdwTqFofEOsVujnoFS4pYVqtA9gR6ygjfjC8davZznH
 NQrVIQnIrJGOHs1hn8xEsisUjeK2g+Cm3n0c5MnSohmOjUtXlnl3QNRAYNs0pntdNyqV Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w5mvtxeth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 18:32:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADISxTq160259;
        Wed, 13 Nov 2019 18:32:05 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w7vppqvjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 18:32:05 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xADIW5jM000801;
        Wed, 13 Nov 2019 18:32:05 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Nov 2019 10:32:04 -0800
Date:   Wed, 13 Nov 2019 21:31:58 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Igor Russkikh <irusskikh@marvell.com>,
        Nikita Danilov <ndanilov@marvell.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] net: atlantic: Signedness bug in aq_vec_isr_legacy()
Message-ID: <20191113183158.rogxsza632ppeen3@kili.mountain>
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

irqreturn_t type is an enum and in this context it's unsigned, so "err"
can't be irqreturn_t or it breaks the error handling.  In fact the "err"
variable is only used to store integers (never irqreturn_t) so it should
be declared as int.

I removed the initialization because it's not required.  Using a bogus
initializer turns off GCC's uninitialized variable warnings.  Secondly,
there is a GCC warning about unused assignments and we would like to
enable that feature eventually so we have been trying to remove these
unnecessary initializers.

Fixes: 7b0c342f1f67 ("net: atlantic: code style cleanup")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index 6e19e27b6200..f40a427970dc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -307,8 +307,8 @@ irqreturn_t aq_vec_isr(int irq, void *private)
 irqreturn_t aq_vec_isr_legacy(int irq, void *private)
 {
 	struct aq_vec_s *self = private;
-	irqreturn_t err = 0;
 	u64 irq_mask = 0U;
+	int err;
 
 	if (!self)
 		return IRQ_NONE;
-- 
2.11.0

