Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E626568EFC
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 18:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbiGFQVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 12:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbiGFQVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 12:21:34 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F134413D1E
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 09:21:30 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 4DFA63201DA;
        Wed,  6 Jul 2022 17:21:30 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.95)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1o97mH-0001ie-Im;
        Wed, 06 Jul 2022 17:21:25 +0100
Subject: [PATCH net-next 2/2] sfc: Implement change of BAR configuration
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Wed, 06 Jul 2022 17:21:25 +0100
Message-ID: <165712448547.6549.16558323295042569801.stgit@palantir17.mph.net>
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

Placeholders are added for vDPA. These will be assigned with
a later patch.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c |   39 ++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 218db3cb31eb..ce4b7b4e705e 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -704,7 +704,25 @@ static unsigned int efx_ef100_recycle_ring_size(const struct efx_nic *efx)
 	return 10 * EFX_RECYCLE_RING_SIZE_10G;
 }
 
-/* BAR configuration */
+/* BAR configuration.
+ * To change BAR configuration we tear down the current configuration (which
+ * leaves the hardware in the PROBED state), and then initialise the new
+ * BAR state.
+ */
+static struct {
+	int (*init)(struct efx_probe_data *probe_data);
+	void (*fini)(struct efx_probe_data *probe_data);
+} bar_config_std[] = {
+	[EF100_BAR_CONFIG_EF100] = {
+		.init = ef100_probe_netdev,
+		.fini = ef100_remove_netdev
+	},
+	[EF100_BAR_CONFIG_VDPA] = {
+		.init = NULL,	/* TODO: assign these */
+		.fini = NULL
+	},
+};
+
 static ssize_t bar_config_show(struct device *dev,
 			       struct device_attribute *attr, char *buf_out)
 {
@@ -732,7 +750,9 @@ static ssize_t bar_config_store(struct device *dev,
 {
 	struct efx_nic *efx = pci_get_drvdata(to_pci_dev(dev));
 	struct ef100_nic_data *nic_data = efx->nic_data;
-	enum ef100_bar_config new_config;
+	enum ef100_bar_config new_config, old_config;
+	struct efx_probe_data *probe_data;
+	int rc;
 
 	if (!strncasecmp(buf, "ef100", min_t(size_t, count, 5)))
 		new_config = EF100_BAR_CONFIG_EF100;
@@ -741,7 +761,22 @@ static ssize_t bar_config_store(struct device *dev,
 	else
 		return -EIO;
 
+	old_config = nic_data->bar_config;
+	if (new_config == old_config)
+		return count;
+
+	probe_data = container_of(efx, struct efx_probe_data, efx);
+	if (bar_config_std[old_config].fini)
+		bar_config_std[old_config].fini(probe_data);
+
 	nic_data->bar_config = new_config;
+	if (bar_config_std[new_config].init) {
+		rc = bar_config_std[new_config].init(probe_data);
+		if (rc)
+			return rc;
+	}
+
+	pci_info(efx->pci_dev, "BAR configuration changed to %s", buf);
 	return count;
 }
 


