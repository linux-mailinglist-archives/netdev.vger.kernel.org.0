Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56F22F1578
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 12:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbfKFLyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 06:54:10 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6159 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbfKFLyK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 06:54:10 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 7029CFB742F7A1F8A370;
        Wed,  6 Nov 2019 19:54:00 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Wed, 6 Nov 2019 19:53:54 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] ptp: Fix missing unlock on error in idtcm_probe()
Date:   Wed, 6 Nov 2019 11:53:08 +0000
Message-ID: <20191106115308.112645-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing unlock before return from function idtcm_probe()
in the error handling case.

Fixes: 3a6ba7dc7799 ("ptp: Add a ptp clock driver for IDT ClockMatrix.")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/ptp/ptp_clockmatrix.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index cf5889b7d825..a5110b7b4ece 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -1294,8 +1294,10 @@ static int idtcm_probe(struct i2c_client *client,
 
 	err = set_tod_write_overhead(idtcm);
 
-	if (err)
+	if (err) {
+		mutex_unlock(&idtcm->reg_lock);
 		return err;
+	}
 
 	err = idtcm_load_firmware(idtcm, &client->dev);



