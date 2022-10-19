Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51085604FF0
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiJSSw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiJSSwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:52:24 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFD2196B57
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 11:52:22 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id E048F504ECD;
        Wed, 19 Oct 2022 21:48:13 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru E048F504ECD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1666205295; bh=rrcojiHEGdTalHMJUCoiXmTaDBjAYuomC2SSYCOidgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYSjo22o/PmHvgOpqxynpw5GRGbAnC+fqjl5CWBcN5bkNjZngLQ8krPSOa3HTzzPt
         ZF1CbDCkVAneoO7W0Ui+MwKs2tSDVmdAw7/CI6TcOCmMBHeWm2+/OiDSkbjwSPf9NR
         XRmiOIkJPLUJds6rdMExA6k21Q4RTyPPV8WkvTJA=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>,
        Charles Parent <charles.parent@orolia2s.com>
Subject: [PATCH net-next v4 4/5] ptp: ocp: expose config and temperature for ART card
Date:   Wed, 19 Oct 2022 21:51:11 +0300
Message-Id: <20221019185112.28294-5-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221019185112.28294-1-vfedorenko@novek.ru>
References: <20221019185112.28294-1-vfedorenko@novek.ru>
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
index 9bdfb82d5402..dd6a68762231 100644
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
@@ -3334,6 +3337,131 @@ DEVICE_FREQ_GROUP(freq2, 1);
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
@@ -3353,9 +3481,11 @@ static struct attribute *fb_timecard_attrs[] = {
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
@@ -3384,8 +3514,15 @@ static struct attribute *art_timecard_attrs[] = {
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

