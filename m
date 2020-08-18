Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF0F2487F9
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 16:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgHROlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 10:41:49 -0400
Received: from pbmsgap02.intersil.com ([192.157.179.202]:53826 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbgHROlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 10:41:47 -0400
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.27/8.16.0.27) with SMTP id 07IEfTpg007666;
        Tue, 18 Aug 2020 10:41:45 -0400
Received: from pbmxdp02.intersil.corp (pbmxdp02.pb.intersil.com [132.158.200.223])
        by pbmsgap02.intersil.com with ESMTP id 32x9vdhpvn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 10:41:45 -0400
Received: from pbmxdp03.intersil.corp (132.158.200.224) by
 pbmxdp02.intersil.corp (132.158.200.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Tue, 18 Aug 2020 10:41:44 -0400
Received: from localhost (132.158.202.109) by pbmxdp03.intersil.corp
 (132.158.200.224) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 18 Aug 2020 10:41:43 -0400
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH v2 net] ptp: ptp_clockmatrix: use i2c_master_send for i2c write
Date:   Tue, 18 Aug 2020 10:41:22 -0400
Message-ID: <1597761682-31111-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_10:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=823
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-2006250000 definitions=main-2008180107
X-Proofpoint-Spam-Reason: mlx
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

The old code for i2c write would break on some controllers, which fails
at handling Repeated Start Condition. So we will just use i2c_master_send
to handle write in one transanction.

Changes since v1:
- Remove indentation change

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 56 +++++++++++++++++++++++++++++++++----------
 drivers/ptp/ptp_clockmatrix.h |  2 ++
 2 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index 73aaae5..e020faf 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -142,16 +142,15 @@ static int idtcm_strverscmp(const char *ver1, const char *ver2)
 	return result;
 }
 
-static int idtcm_xfer(struct idtcm *idtcm,
-		      u8 regaddr,
-		      u8 *buf,
-		      u16 count,
-		      bool write)
+static int idtcm_xfer_read(struct idtcm *idtcm,
+			   u8 regaddr,
+			   u8 *buf,
+			   u16 count)
 {
 	struct i2c_client *client = idtcm->client;
 	struct i2c_msg msg[2];
 	int cnt;
-	char *fmt = "i2c_transfer failed at %d in %s for %s, at addr: %04X!\n";
+	char *fmt = "i2c_transfer failed at %d in %s, at addr: %04X!\n";
 
 	msg[0].addr = client->addr;
 	msg[0].flags = 0;
@@ -159,7 +158,7 @@ static int idtcm_xfer(struct idtcm *idtcm,
 	msg[0].buf = &regaddr;
 
 	msg[1].addr = client->addr;
-	msg[1].flags = write ? 0 : I2C_M_RD;
+	msg[1].flags = I2C_M_RD;
 	msg[1].len = count;
 	msg[1].buf = buf;
 
@@ -170,7 +169,6 @@ static int idtcm_xfer(struct idtcm *idtcm,
 			fmt,
 			__LINE__,
 			__func__,
-			write ? "write" : "read",
 			regaddr);
 		return cnt;
 	} else if (cnt != 2) {
@@ -182,6 +180,37 @@ static int idtcm_xfer(struct idtcm *idtcm,
 	return 0;
 }
 
+static int idtcm_xfer_write(struct idtcm *idtcm,
+			    u8 regaddr,
+			    u8 *buf,
+			    u16 count)
+{
+	struct i2c_client *client = idtcm->client;
+	/* we add 1 byte for device register */
+	u8 msg[IDTCM_MAX_WRITE_COUNT + 1];
+	int cnt;
+	char *fmt = "i2c_master_send failed at %d in %s, at addr: %04X!\n";
+
+	if (count > IDTCM_MAX_WRITE_COUNT)
+		return -EINVAL;
+
+	msg[0] = regaddr;
+	memcpy(&msg[1], buf, count);
+
+	cnt = i2c_master_send(client, msg, count + 1);
+
+	if (cnt < 0) {
+		dev_err(&client->dev,
+			fmt,
+			__LINE__,
+			__func__,
+			regaddr);
+		return cnt;
+	}
+
+	return 0;
+}
+
 static int idtcm_page_offset(struct idtcm *idtcm, u8 val)
 {
 	u8 buf[4];
@@ -195,7 +224,7 @@ static int idtcm_page_offset(struct idtcm *idtcm, u8 val)
 	buf[2] = 0x10;
 	buf[3] = 0x20;
 
-	err = idtcm_xfer(idtcm, PAGE_ADDR, buf, sizeof(buf), 1);
+	err = idtcm_xfer_write(idtcm, PAGE_ADDR, buf, sizeof(buf));
 
 	if (err) {
 		idtcm->page_offset = 0xff;
@@ -223,11 +252,12 @@ static int _idtcm_rdwr(struct idtcm *idtcm,
 	err = idtcm_page_offset(idtcm, hi);
 
 	if (err)
-		goto out;
+		return err;
 
-	err = idtcm_xfer(idtcm, lo, buf, count, write);
-out:
-	return err;
+	if (write)
+		return idtcm_xfer_write(idtcm, lo, buf, count);
+
+	return idtcm_xfer_read(idtcm, lo, buf, count);
 }
 
 static int idtcm_read(struct idtcm *idtcm,
diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
index ffae56c..82840d7 100644
--- a/drivers/ptp/ptp_clockmatrix.h
+++ b/drivers/ptp/ptp_clockmatrix.h
@@ -55,6 +55,8 @@
 
 #define PEROUT_ENABLE_OUTPUT_MASK		(0xdeadbeef)
 
+#define IDTCM_MAX_WRITE_COUNT			(512)
+
 /* Values of DPLL_N.DPLL_MODE.PLL_MODE */
 enum pll_mode {
 	PLL_MODE_MIN = 0,
-- 
2.7.4

