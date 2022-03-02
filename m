Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F594CB161
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 22:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245318AbiCBVf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 16:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245242AbiCBVfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 16:35:50 -0500
Received: from smtp8.emailarray.com (smtp8.emailarray.com [65.39.216.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF23049687
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 13:35:04 -0800 (PST)
Received: (qmail 50534 invoked by uid 89); 2 Mar 2022 21:35:03 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjgzLjg3) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 2 Mar 2022 21:35:03 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel-team@fb.com
Subject: [PATCH net-next 3/5] ptp: ocp: add tod_correction attribute
Date:   Wed,  2 Mar 2022 13:34:57 -0800
Message-Id: <20220302213459.6565-4-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220302213459.6565-1-jonathan.lemon@gmail.com>
References: <20220302213459.6565-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

TOD correction register is used to compensate for leap seconds in
different domains.  Export it as an attribute with write access.

Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 803b67a3659a..2a3384c9e3b8 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1988,6 +1988,46 @@ clock_status_offset_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(clock_status_offset);
 
+static ssize_t
+tod_correction_show(struct device *dev,
+		    struct device_attribute *attr, char *buf)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	u32 val;
+	int res;
+
+	val = ioread32(&bp->tod->adj_sec);
+	res = (val & ~INT_MAX) ? -1 : 1;
+	res *= (val & INT_MAX);
+	return sysfs_emit(buf, "%d\n", res);
+}
+
+static ssize_t
+tod_correction_store(struct device *dev, struct device_attribute *attr,
+		     const char *buf, size_t count)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(dev);
+	unsigned long flags;
+	int err, res;
+	u32 val = 0;
+
+	err = kstrtos32(buf, 0, &res);
+	if (err)
+		return err;
+	if (res < 0) {
+		res *= -1;
+		val |= BIT(31);
+	}
+	val |= res;
+
+	spin_lock_irqsave(&bp->lock, flags);
+	iowrite32(val, &bp->tod->adj_sec);
+	spin_unlock_irqrestore(&bp->lock, flags);
+
+	return count;
+}
+static DEVICE_ATTR_RW(tod_correction);
+
 static struct attribute *timecard_attrs[] = {
 	&dev_attr_serialnum.attr,
 	&dev_attr_gnss_sync.attr,
@@ -2004,6 +2044,7 @@ static struct attribute *timecard_attrs[] = {
 	&dev_attr_irig_b_mode.attr,
 	&dev_attr_utc_tai_offset.attr,
 	&dev_attr_ts_window_adjust.attr,
+	&dev_attr_tod_correction.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(timecard);
-- 
2.31.1

