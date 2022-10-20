Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 816F0606C0D
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 01:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiJTXZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 19:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiJTXZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 19:25:23 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE708D226
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 16:25:17 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id E5FEF504EED;
        Fri, 21 Oct 2022 02:21:07 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru E5FEF504EED
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1666308069; bh=lPBrbvbrUPzBLiAl8PK8x2uOda+OujkuedTY/srEzv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEW0lcqrXmn5E7UItmEEfT6lSnzK2pKquMQOWhOkmctDGMMZAYYvtMY5py8Lvna3Z
         IZlm2RJRfDm6O3FEhwZDVLAN5qM7oawFx3FUw+hpgHtrE5Bvh+JEt+QJoLoUZEDOBR
         WXyiBlJJlfAz9tpjWivZwICG/co77vqww3+kHJ14=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>,
        Charles Parent <charles.parent@orolia2s.com>
Subject: [PATCH net-next v6 4/5] ptp: ocp: expose config and temperature for ART card
Date:   Fri, 21 Oct 2022 02:24:32 +0300
Message-Id: <20221020232433.9593-5-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221020232433.9593-1-vfedorenko@novek.ru>
References: <20221020232433.9593-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Fedorenko <vadfed@fb.com>

Orolia card has disciplining configuration and temperature table
stored in EEPROM. This patch exposes them as binary attributes to
have read and write access.

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Co-developed-by: Charles Parent <charles.parent@orolia2s.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
---
 drivers/ptp/ptp_ocp.c | 136 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 136 insertions(+)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 223980d725fe..d2d486ccd714 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -690,6 +690,9 @@ static struct ocp_resource ocp_fb_resource[] = {
 	{ }
 };
 
+#define OCP_ART_CONFIG_SIZE		144
+#define OCP_ART_TEMP_TABLE_SIZE		368
+
 struct ocp_art_gpio_reg {
 	struct {
 		u32	gpio;
@@ -3334,6 +3337,130 @@ DEVICE_FREQ_GROUP(freq2, 1);
 DEVICE_FREQ_GROUP(freq3, 2);
 DEVICE_FREQ_GROUP(freq4, 3);
 
+static ssize_t
+disciplining_config_read(struct file *filp, struct kobject *kobj,
+			 struct bin_attribute *bin_attr, char *buf,
+			 loff_t off, size_t count)
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
+			  struct bin_attribute *bin_attr, char *buf,
+			  loff_t off, size_t count)
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
+		       struct bin_attribute *bin_attr, char *buf,
+		       loff_t off, size_t count)
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
@@ -3353,9 +3480,11 @@ static struct attribute *fb_timecard_attrs[] = {
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
@@ -3384,8 +3513,15 @@ static struct attribute *art_timecard_attrs[] = {
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

