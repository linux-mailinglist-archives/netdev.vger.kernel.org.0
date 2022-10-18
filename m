Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC476027C8
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbiJRJBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiJRJBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:01:49 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3DC6F55B
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 02:01:46 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 8C082504ED6;
        Tue, 18 Oct 2022 11:58:05 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 8C082504ED6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1666083486; bh=OO9PDblGxXgu+IM/DIlCXSeP/ZP88sGizU6Mh8pYNlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oEDRu0q5bSwRsSvs5zFFufiaAtj5L20fYnr2tWA4Ioi15UegTEx/QMEMfsKxFBK54
         tqcDVB1raijJM6f91DzcsZmYp66/GSqSmw9B/4vc9q2egWROmATCTZfXsQt73zVRWw
         J51Dwk4FAjcNB0kptMO9iZueTjJ8L0i9zT075dAE=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>,
        Charles Parent <charles.parent@orolia2s.com>
Subject: [PATCH net-next v3 4/5] ptp: ocp: expose config and temperature for ART card
Date:   Tue, 18 Oct 2022 12:01:21 +0300
Message-Id: <20221018090122.3361-5-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221018090122.3361-1-vfedorenko@novek.ru>
References: <20221018090122.3361-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

Orolia card has disciplining configuration and temperature table
stored in EEPROM. This patch exposes them as binary attributes to
have read and write access.

Co-developed-by: Charles Parent <charles.parent@orolia2s.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
---
 drivers/ptp/ptp_ocp.c | 137 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 137 insertions(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 7da24a82f221..18baababb3e2 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -691,6 +691,9 @@ static struct ocp_resource ocp_fb_resource[] = {
 	{ }
 };
 
+#define OCP_ART_CONFIG_SIZE		144
+#define OCP_ART_TEMP_TABLE_SIZE		368
+
 struct ocp_art_gpio_reg {
 	struct {
 		u32	gpio;
@@ -3335,6 +3338,131 @@ DEVICE_FREQ_GROUP(freq2, 1);
 DEVICE_FREQ_GROUP(freq3, 2);
 DEVICE_FREQ_GROUP(freq4, 3);
 
+static ssize_t
+disciplining_config_read(struct file *filp, struct kobject *kobj,
+	    struct bin_attribute *bin_attr, char *buf,
+	    loff_t off, size_t count)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(kobj_to_dev(kobj));
+	size_t size = OCP_ART_CONFIG_SIZE;
+	struct nvmem_device *nvmem;
+	ssize_t err;
+
+	nvmem = ptp_ocp_nvmem_device_get(bp, NULL);
+	if (IS_ERR(nvmem))
+		return PTR_ERR(nvmem);
+
+	if (off > size) {
+		err = 0;
+		goto out;
+	}
+
+	if (off + count > size)
+		count = size - off;
+
+	// the configuration is in the very beginning of the EEPROM
+	err = nvmem_device_read(nvmem, off, count, buf);
+	if (err != count) {
+		err = -EFAULT;
+		goto out;
+	}
+
+out:
+	ptp_ocp_nvmem_device_put(&nvmem);
+
+	return err;
+}
+
+static ssize_t
+disciplining_config_write(struct file *filp, struct kobject *kobj,
+	     struct bin_attribute *bin_attr, char *buf,
+	     loff_t off, size_t count)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(kobj_to_dev(kobj));
+	struct nvmem_device *nvmem;
+	ssize_t err;
+
+	/* Allow write of the whole area only */
+	if (off || count != OCP_ART_CONFIG_SIZE)
+		return -EFAULT;
+
+	nvmem = ptp_ocp_nvmem_device_get(bp, NULL);
+	if (IS_ERR(nvmem))
+		return PTR_ERR(nvmem);
+
+
+	err = nvmem_device_write(nvmem, 0x00, count, buf);
+	if (err != count)
+		err = -EFAULT;
+
+	ptp_ocp_nvmem_device_put(&nvmem);
+
+	return err;
+}
+static BIN_ATTR_RW(disciplining_config, OCP_ART_CONFIG_SIZE);
+
+static ssize_t
+temperature_table_read(struct file *filp, struct kobject *kobj,
+	    struct bin_attribute *bin_attr, char *buf,
+	    loff_t off, size_t count)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(kobj_to_dev(kobj));
+	size_t size = OCP_ART_TEMP_TABLE_SIZE;
+	struct nvmem_device *nvmem;
+	ssize_t err;
+
+	nvmem = ptp_ocp_nvmem_device_get(bp, NULL);
+	if (IS_ERR(nvmem))
+		return PTR_ERR(nvmem);
+
+	if (off > size) {
+		err = 0;
+		goto out;
+	}
+
+	if (off + count > size)
+		count = size - off;
+
+	// the configuration is in the very beginning of the EEPROM
+	err = nvmem_device_read(nvmem, 0x90 + off, count, buf);
+	if (err != count) {
+		err = -EFAULT;
+		goto out;
+	}
+
+out:
+	ptp_ocp_nvmem_device_put(&nvmem);
+
+	return err;
+}
+
+static ssize_t
+temperature_table_write(struct file *filp, struct kobject *kobj,
+			struct bin_attribute *bin_attr, char *buf,
+			loff_t off, size_t count)
+{
+	struct ptp_ocp *bp = dev_get_drvdata(kobj_to_dev(kobj));
+	struct nvmem_device *nvmem;
+	ssize_t err;
+
+	/* Allow write of the whole area only */
+	if (off || count != OCP_ART_TEMP_TABLE_SIZE)
+		return -EFAULT;
+
+	nvmem = ptp_ocp_nvmem_device_get(bp, NULL);
+	if (IS_ERR(nvmem))
+		return PTR_ERR(nvmem);
+
+	err = nvmem_device_write(nvmem, 0x90, count, buf);
+	if (err != count)
+		err = -EFAULT;
+
+	ptp_ocp_nvmem_device_put(&nvmem);
+
+	return err;
+}
+static BIN_ATTR_RW(temperature_table, OCP_ART_TEMP_TABLE_SIZE);
+
 static struct attribute *fb_timecard_attrs[] = {
 	&dev_attr_serialnum.attr,
 	&dev_attr_gnss_sync.attr,
@@ -3354,9 +3482,11 @@ static struct attribute *fb_timecard_attrs[] = {
 	&dev_attr_tod_correction.attr,
 	NULL,
 };
+
 static const struct attribute_group fb_timecard_group = {
 	.attrs = fb_timecard_attrs,
 };
+
 static const struct ocp_attr_group fb_timecard_groups[] = {
 	{ .cap = OCP_CAP_BASIC,	    .group = &fb_timecard_group },
 	{ .cap = OCP_CAP_SIGNAL,    .group = &fb_timecard_signal0_group },
@@ -3385,8 +3515,15 @@ static struct attribute *art_timecard_attrs[] = {
 	NULL,
 };
 
+static struct bin_attribute *bin_art_timecard_attrs[] = {
+	&bin_attr_disciplining_config,
+	&bin_attr_temperature_table,
+	NULL,
+};
+
 static const struct attribute_group art_timecard_group = {
 	.attrs = art_timecard_attrs,
+	.bin_attrs = bin_art_timecard_attrs,
 };
 
 static const struct ocp_attr_group art_timecard_groups[] = {
-- 
2.27.0

