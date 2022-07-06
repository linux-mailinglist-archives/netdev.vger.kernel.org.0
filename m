Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB48568EF4
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 18:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbiGFQV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 12:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbiGFQV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 12:21:27 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B075193E6
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 09:21:21 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 4F0E632092A;
        Wed,  6 Jul 2022 17:21:20 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.95)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1o97m5-0001iR-5f;
        Wed, 06 Jul 2022 17:21:13 +0100
Subject: [PATCH net-next 1/2] sfc: Add EF100 BAR config support
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Wed, 06 Jul 2022 17:21:13 +0100
Message-ID: <165712447305.6549.5015491740374054340.stgit@palantir17.mph.net>
In-Reply-To: <165712441387.6549.4915238154843073311.stgit@palantir17.mph.net>
References: <165712441387.6549.4915238154843073311.stgit@palantir17.mph.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,
        T_SPF_HELO_TEMPERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a "bar_config" file in the sysfs directory of the PCI device.
This can be used to switch the PCI BAR layout to/from vDPA mode.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c |   45 ++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_nic.h |    6 +++++
 2 files changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index f89e695cf8ac..218db3cb31eb 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -704,6 +704,49 @@ static unsigned int efx_ef100_recycle_ring_size(const struct efx_nic *efx)
 	return 10 * EFX_RECYCLE_RING_SIZE_10G;
 }
 
+/* BAR configuration */
+static ssize_t bar_config_show(struct device *dev,
+			       struct device_attribute *attr, char *buf_out)
+{
+	struct efx_nic *efx = pci_get_drvdata(to_pci_dev(dev));
+	struct ef100_nic_data *nic_data = efx->nic_data;
+
+	switch (nic_data->bar_config) {
+	case EF100_BAR_CONFIG_EF100:
+		sprintf(buf_out, "EF100\n");
+		break;
+	case EF100_BAR_CONFIG_VDPA:
+		sprintf(buf_out, "vDPA\n");
+		break;
+	default: /* this should not happen */
+		WARN_ON_ONCE(1);
+		return 0;
+	}
+
+	return strlen(buf_out);
+}
+
+static ssize_t bar_config_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct efx_nic *efx = pci_get_drvdata(to_pci_dev(dev));
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	enum ef100_bar_config new_config;
+
+	if (!strncasecmp(buf, "ef100", min_t(size_t, count, 5)))
+		new_config = EF100_BAR_CONFIG_EF100;
+	else if (!strncasecmp(buf, "vdpa", min_t(size_t, count, 4)))
+		new_config = EF100_BAR_CONFIG_VDPA;
+	else
+		return -EIO;
+
+	nic_data->bar_config = new_config;
+	return count;
+}
+
+static DEVICE_ATTR_RW(bar_config);
+
 static int compare_versions(const char *a, const char *b)
 {
 	int a_major, a_minor, a_point, a_patch;
@@ -1039,6 +1082,7 @@ static int ef100_probe_main(struct efx_nic *efx)
 		goto fail;
 	}
 
+	device_create_file(&efx->pci_dev->dev, &dev_attr_bar_config);
 	return 0;
 fail:
 	return rc;
@@ -1072,6 +1116,7 @@ void ef100_remove(struct efx_nic *efx)
 {
 	struct ef100_nic_data *nic_data = efx->nic_data;
 
+	device_remove_file(&efx->pci_dev->dev, &dev_attr_bar_config);
 	efx_mcdi_detach(efx);
 	efx_mcdi_fini(efx);
 	if (nic_data)
diff --git a/drivers/net/ethernet/sfc/ef100_nic.h b/drivers/net/ethernet/sfc/ef100_nic.h
index 744dbbdb4adc..64b82cae6b54 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.h
+++ b/drivers/net/ethernet/sfc/ef100_nic.h
@@ -61,6 +61,11 @@ enum {
 	EF100_STAT_COUNT
 };
 
+enum ef100_bar_config {
+	EF100_BAR_CONFIG_EF100,
+	EF100_BAR_CONFIG_VDPA,
+};
+
 struct ef100_nic_data {
 	struct efx_nic *efx;
 	struct efx_buffer mcdi_buf;
@@ -70,6 +75,7 @@ struct ef100_nic_data {
 	unsigned int pf_index;
 	u16 warm_boot_count;
 	u8 port_id[ETH_ALEN];
+	enum ef100_bar_config bar_config;
 	DECLARE_BITMAP(evq_phases, EFX_MAX_CHANNELS);
 	u64 stats[EF100_STAT_COUNT];
 	u16 tso_max_hdr_len;


