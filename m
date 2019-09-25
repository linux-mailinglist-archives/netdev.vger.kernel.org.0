Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8BB1BDC72
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 12:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390692AbfIYKzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 06:55:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59204 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfIYKzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 06:55:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PAsTNZ087182;
        Wed, 25 Sep 2019 10:55:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=JoOZ1EKFBtCG9FnzIDDMYtDfQCjJFih17iKqEoFF5CU=;
 b=Nkb5EUr7dxn6Fku/B2yx4KlZa+VmJP5IBipPT8yRNH04O5k9jd6xCasv3f/vZAAuc2or
 ijMRYPFRFfOq6T6t4RMK8hDZ4LvX7IxQo2sc2NS9bOsCn0jWagwrCX5pxG++aOu1C1ac
 Ss5KoAs99GdeSToKwIv2EMymjwN+Dekr828RphczVfgwp3NQzdwm2OR5GGhrXToMavNH
 gAL7WQfbYoKrpOFC5mzGNcS9PsQmVQJHvC4MkSP6L+rhJRBE1quPZu+KOFmOhwOz0rwl
 3qOavriwcx/KKUhwORJzPRea5Kvo4jsQSG6Tx8GrC/kw0s0VrbG9DedY5tq7LrZzX/lz tw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2v5b9tuurg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:55:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PAs0eB136345;
        Wed, 25 Sep 2019 10:55:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2v829uukrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 10:55:06 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8PAt5xY016899;
        Wed, 25 Sep 2019 10:55:05 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 03:55:04 -0700
Date:   Wed, 25 Sep 2019 13:54:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Vishal Kulkarni <vishal@chelsio.com>,
        Ganesh Goudar <ganeshgr@chelsio.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] cxgb4: Signedness bug in init_one()
Message-ID: <20190925105459.GB3264@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9390 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250112
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "chip" variable is an enum, and it's treated as unsigned int by GCC
in this context so the error handling isn't triggered.

Fixes: e8d452923ae6 ("cxgb4: clean up init_one")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 71854a19cebe..38024877751c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -5701,7 +5701,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	whoami = t4_read_reg(adapter, PL_WHOAMI_A);
 	pci_read_config_word(pdev, PCI_DEVICE_ID, &device_id);
 	chip = t4_get_chip_type(adapter, CHELSIO_PCI_ID_VER(device_id));
-	if (chip < 0) {
+	if ((int)chip < 0) {
 		dev_err(&pdev->dev, "Device %d is not supported\n", device_id);
 		err = chip;
 		goto out_free_adapter;
-- 
2.20.1

