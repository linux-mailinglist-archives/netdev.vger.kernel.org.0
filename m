Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21AF82A73BD
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 01:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgKEA2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 19:28:20 -0500
Received: from pbmsgap02.intersil.com ([192.157.179.202]:37596 "EHLO
        pbmsgap02.intersil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729682AbgKEA1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 19:27:51 -0500
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Nov 2020 19:27:51 EST
Received: from pps.filterd (pbmsgap02.intersil.com [127.0.0.1])
        by pbmsgap02.intersil.com (8.16.0.42/8.16.0.42) with SMTP id 0A50MfH4021545;
        Wed, 4 Nov 2020 19:22:41 -0500
Received: from pbmxdp03.intersil.corp (pbmxdp03.pb.intersil.com [132.158.200.224])
        by pbmsgap02.intersil.com with ESMTP id 34h23fa6ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 04 Nov 2020 19:22:41 -0500
Received: from pbmxdp02.intersil.corp (132.158.200.223) by
 pbmxdp03.intersil.corp (132.158.200.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.1979.3; Wed, 4 Nov 2020 19:22:39 -0500
Received: from localhost (132.158.202.109) by pbmxdp02.intersil.corp
 (132.158.200.223) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 4 Nov 2020 19:22:39 -0500
From:   <min.li.xe@renesas.com>
To:     <richardcochran@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH v3 net-next 2/3] ptp: idt82p33: use i2c_master_send for bus write
Date:   Wed, 4 Nov 2020 19:22:14 -0500
Message-ID: <1604535735-19180-2-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604535735-19180-1-git-send-email-min.li.xe@renesas.com>
References: <1604535735-19180-1-git-send-email-min.li.xe@renesas.com>
X-TM-AS-MML: disable
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-04_17:2020-11-04,2020-11-04 signatures=0
X-Proofpoint-Spam-Details: rule=junk_notspam policy=junk score=0 mlxscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 suspectscore=4 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050000
X-Proofpoint-Spam-Reason: mlx
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

Refactor idt82p33_xfer and use i2c_master_send for write operation.
Because some I2C controllers are only working with single-burst write
transaction.

Changes since v1:
- Fix broken build.

Signed-off-by: Min Li <min.li.xe@renesas.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/ptp_idt82p33.c | 50 ++++++++++++++++++++++++++++++++++------------
 drivers/ptp/ptp_idt82p33.h |  1 +
 2 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/ptp/ptp_idt82p33.c b/drivers/ptp/ptp_idt82p33.c
index d52fa67..b1528a0 100644
--- a/drivers/ptp/ptp_idt82p33.c
+++ b/drivers/ptp/ptp_idt82p33.c
@@ -78,11 +78,10 @@ static void idt82p33_timespec_to_byte_array(struct timespec64 const *ts,
 	}
 }
 
-static int idt82p33_xfer(struct idt82p33 *idt82p33,
-			 unsigned char regaddr,
-			 unsigned char *buf,
-			 unsigned int count,
-			 int write)
+static int idt82p33_xfer_read(struct idt82p33 *idt82p33,
+			      unsigned char regaddr,
+			      unsigned char *buf,
+			      unsigned int count)
 {
 	struct i2c_client *client = idt82p33->client;
 	struct i2c_msg msg[2];
@@ -94,7 +93,7 @@ static int idt82p33_xfer(struct idt82p33 *idt82p33,
 	msg[0].buf = &regaddr;
 
 	msg[1].addr = client->addr;
-	msg[1].flags = write ? 0 : I2C_M_RD;
+	msg[1].flags = I2C_M_RD;
 	msg[1].len = count;
 	msg[1].buf = buf;
 
@@ -110,6 +109,31 @@ static int idt82p33_xfer(struct idt82p33 *idt82p33,
 	return 0;
 }
 
+static int idt82p33_xfer_write(struct idt82p33 *idt82p33,
+			       u8 regaddr,
+			       u8 *buf,
+			       u16 count)
+{
+	struct i2c_client *client = idt82p33->client;
+	/* we add 1 byte for device register */
+	u8 msg[IDT82P33_MAX_WRITE_COUNT + 1];
+	int err;
+
+	if (count > IDT82P33_MAX_WRITE_COUNT)
+		return -EINVAL;
+
+	msg[0] = regaddr;
+	memcpy(&msg[1], buf, count);
+
+	err = i2c_master_send(client, msg, count + 1);
+	if (err < 0) {
+		dev_err(&client->dev, "i2c_master_send returned %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
 static int idt82p33_page_offset(struct idt82p33 *idt82p33, unsigned char val)
 {
 	int err;
@@ -117,7 +141,7 @@ static int idt82p33_page_offset(struct idt82p33 *idt82p33, unsigned char val)
 	if (idt82p33->page_offset == val)
 		return 0;
 
-	err = idt82p33_xfer(idt82p33, PAGE_ADDR, &val, sizeof(val), 1);
+	err = idt82p33_xfer_write(idt82p33, PAGE_ADDR, &val, sizeof(val));
 	if (err)
 		dev_err(&idt82p33->client->dev,
 			"failed to set page offset %d\n", val);
@@ -130,20 +154,20 @@ static int idt82p33_page_offset(struct idt82p33 *idt82p33, unsigned char val)
 static int idt82p33_rdwr(struct idt82p33 *idt82p33, unsigned int regaddr,
 			 unsigned char *buf, unsigned int count, bool write)
 {
+	u8 offset, page;
 	int err;
-	u8 page;
-	u8 offset;
 
 	page = _PAGE(regaddr);
 	offset = _OFFSET(regaddr);
 
 	err = idt82p33_page_offset(idt82p33, page);
 	if (err)
-		goto out;
+		return err;
 
-	err = idt82p33_xfer(idt82p33, offset, buf, count, write);
-out:
-	return err;
+	if (write)
+		return idt82p33_xfer_write(idt82p33, offset, buf, count);
+
+	return idt82p33_xfer_read(idt82p33, offset, buf, count);
 }
 
 static int idt82p33_read(struct idt82p33 *idt82p33, unsigned int regaddr,
diff --git a/drivers/ptp/ptp_idt82p33.h b/drivers/ptp/ptp_idt82p33.h
index 3a0e001..1c7a0f0 100644
--- a/drivers/ptp/ptp_idt82p33.h
+++ b/drivers/ptp/ptp_idt82p33.h
@@ -95,6 +95,7 @@ enum hw_tod_trig_sel {
 #define MAX_MEASURMENT_COUNT (5)
 #define SNAP_THRESHOLD_NS (150000)
 #define SYNC_TOD_TIMEOUT_SEC (5)
+#define IDT82P33_MAX_WRITE_COUNT (512)
 
 #define PLLMASK_ADDR_HI	0xFF
 #define PLLMASK_ADDR_LO	0xA5
-- 
2.7.4

