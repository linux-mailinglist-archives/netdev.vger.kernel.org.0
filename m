Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4563BDC6F
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 12:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390626AbfIYKyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 06:54:53 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42852 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfIYKyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 06:54:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PAsgBS039757;
        Wed, 25 Sep 2019 10:54:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=gyYFAUNAdywRa6OHydGl6yQtUCIfaaz3p9EVMJVB5/A=;
 b=fIxYQ1ruvurRt6h7H46XvKZ+hu5uktrt+YyA2rd3Tk7Yqwt767wFZruNX2ZcadKeV/P9
 fzbyyEedmVldOW3Dk44NXXznq/ze31vdiokipXWYixs4MuZB4QVox0j4pkuXbe1L+0Wf
 Cdksd+XWB5Pbm+VHULyTNvKF3L4Ilj+KUahA3ODR2veT1+FgZV5e29S1IvwfLKGqvJff
 ogPgrJ6VmftNq4XOELxcik5ngf9CIVLv1MvzLNvT9XZ/qjde6h0EGQtjmwNfRICVJ6IG
 6g9IoCIrC2i1vF4wMlbMCw4P8Bn6kiyjhlowmNHzwGPl5TczG3qyQVO5r9cfHs/wWzCz DA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v5btq3vbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:54:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PArxPT136277;
        Wed, 25 Sep 2019 10:54:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2v829uujkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:54:41 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PAscpv017014;
        Wed, 25 Sep 2019 10:54:40 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 03:54:38 -0700
Date:   Wed, 25 Sep 2019 13:54:30 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Igor Russkikh <igor.russkikh@aquantia.com>,
        David VomLehn <vomlehn@texas.net>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: aquantia: Fix aq_vec_isr_legacy() return value
Message-ID: <20190925105430.GA3264@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250112
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The irqreturn_t type is an enum or an unsigned int in GCC.  That
creates to problems because it can't detect if the
self->aq_hw_ops->hw_irq_read() call fails and at the end the function
always returns IRQ_HANDLED.

drivers/net/ethernet/aquantia/atlantic/aq_vec.c:316 aq_vec_isr_legacy() warn: unsigned 'err' is never less than zero.
drivers/net/ethernet/aquantia/atlantic/aq_vec.c:329 aq_vec_isr_legacy() warn: always true condition '(err >= 0) => (0-u32max >= 0)'

Fixes: 970a2e9864b0 ("net: ethernet: aquantia: Vector operations")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index 28892b8acd0e..a95c263a45aa 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -306,15 +306,13 @@ irqreturn_t aq_vec_isr_legacy(int irq, void *private)
 {
 	struct aq_vec_s *self = private;
 	u64 irq_mask = 0U;
-	irqreturn_t err = 0;
+	int err;
 
-	if (!self) {
-		err = -EINVAL;
-		goto err_exit;
-	}
+	if (!self)
+		return IRQ_NONE;
 	err = self->aq_hw_ops->hw_irq_read(self->aq_hw, &irq_mask);
 	if (err < 0)
-		goto err_exit;
+		return IRQ_NONE;
 
 	if (irq_mask) {
 		self->aq_hw_ops->hw_irq_disable(self->aq_hw,
@@ -322,11 +320,10 @@ irqreturn_t aq_vec_isr_legacy(int irq, void *private)
 		napi_schedule(&self->napi);
 	} else {
 		self->aq_hw_ops->hw_irq_enable(self->aq_hw, 1U);
-		err = IRQ_NONE;
+		return IRQ_NONE;
 	}
 
-err_exit:
-	return err >= 0 ? IRQ_HANDLED : IRQ_NONE;
+	return IRQ_HANDLED;
 }
 
 cpumask_t *aq_vec_get_affinity_mask(struct aq_vec_s *self)
-- 
2.20.1

