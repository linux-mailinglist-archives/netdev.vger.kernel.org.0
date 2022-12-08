Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1590646651
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiLHBL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiLHBLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:11:40 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880308B399
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670461898; x=1701997898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kP1xUnVzkR3tSxOrVNWrSpkpg858y1LjmHUO7Xx7Yj4=;
  b=NyrLDnGSm1wQRA4koBMS4zdd/CZGviwPKK8rezuD8PdlMnIUvZz2zK5I
   5bBI/Zu6V0rL+sS8kfhg4qFVjbRVUja1JhLrQkCAFsoZfHT1ovRmzxloe
   RkKK/y6n1C2kKr5jVHgfNvLaWzfOXawTO7xwC649ZQ5dWGexCBRY+stP+
   u06aNT+3mHqtH8GEEqhOPTR11uvkOWTZLr0fZHOW6h/7/6oXbX5baTOWc
   UilnQRPlOBXGKc+fCyH3YJxTvmx3ZabHV4X40TEDs9PykAIJ8T38CBx8s
   eZOxej1XaBqdYT2LU81Ct65070742jiQPCN8JgGU9kGTXoXiEoc1lnLCF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="304672883"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="304672883"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="640445365"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="640445365"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:30 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH ethtool v2 04/13] ethtool: commonize power related strings
Date:   Wed,  7 Dec 2022 17:11:13 -0800
Message-Id: <20221208011122.2343363-5-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When looking into the implementation of the qsfp.h file, I found three
pieces of code all doing the same thing and using similar, but bespoke
strings.

Just make one set of strings for all three places to use. I made an
effort to see if there was any size change due to making this change but
I see no difference.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 cmis.c       | 10 ++--------
 qsfp.c       | 15 +++++++--------
 sff-common.h |  3 +++
 sfpdiag.c    |  9 ++-------
 4 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/cmis.c b/cmis.c
index d0b62728e998..40ff5e541737 100644
--- a/cmis.c
+++ b/cmis.c
@@ -727,16 +727,10 @@ cmis_show_dom_chan_lvl_rx_power_bank(const struct cmis_memory_map *map,
 
 	for (i = 0; i < CMIS_CHANNELS_PER_BANK; i++) {
 		int chan = bank * CMIS_CHANNELS_PER_BANK + i;
-		char *rx_power_str;
 		char fmt_str[80];
 
-		if (!sd->rx_power_type)
-			rx_power_str = "Receiver signal OMA";
-		else
-			rx_power_str = "Rcvr signal avg optical power";
-
-		snprintf(fmt_str, 80, "%s (Channel %d)", rx_power_str,
-			 chan + 1);
+		snprintf(fmt_str, 80, "%s (Channel %d)", sd->rx_power_type ?
+			 rx_power_average : rx_power_oma, chan + 1);
 		PRINT_xX_PWR(fmt_str, sd->scd[chan].rx_power);
 	}
 }
diff --git a/qsfp.c b/qsfp.c
index fb94202757d3..a79da29de950 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -798,7 +798,6 @@ out:
 static void sff8636_show_dom(const struct sff8636_memory_map *map)
 {
 	struct sff_diags sd = {0};
-	char *rx_power_string = NULL;
 	char power_string[MAX_DESC_SIZE];
 	int i;
 
@@ -846,14 +845,14 @@ static void sff8636_show_dom(const struct sff8636_memory_map *map)
 		PRINT_xX_PWR(power_string, sd.scd[i].tx_power);
 	}
 
-	if (!sd.rx_power_type)
-		rx_power_string = "Receiver signal OMA";
-	else
-		rx_power_string = "Rcvr signal avg optical power";
-
 	for (i = 0; i < SFF8636_MAX_CHANNEL_NUM; i++) {
-		snprintf(power_string, MAX_DESC_SIZE, "%s(Channel %d)",
-					rx_power_string, i+1);
+		int chars;
+
+		chars = snprintf(power_string, MAX_DESC_SIZE,
+				 sd.rx_power_type ?
+				 rx_power_average : rx_power_oma);
+		snprintf(power_string + chars, MAX_DESC_SIZE - chars,
+			 "(Channel %d)", i + 1);
 		PRINT_xX_PWR(power_string, sd.scd[i].rx_power);
 	}
 
diff --git a/sff-common.h b/sff-common.h
index 2f58f91ab7ff..4fc78cf9ee50 100644
--- a/sff-common.h
+++ b/sff-common.h
@@ -188,6 +188,9 @@ struct sff_diags {
 	struct sff_channel_diags scd[MAX_CHANNEL_NUM];
 };
 
+static const char rx_power_oma[] = "Receiver Signal OMA";
+static const char rx_power_average[] = "Receiver Signal average optical power";
+
 double convert_mw_to_dbm(double mw);
 void sff_show_value_with_unit(const __u8 *id, unsigned int reg,
 			      const char *name, unsigned int mult,
diff --git a/sfpdiag.c b/sfpdiag.c
index 1fa8b7ba8fec..502b6e3bf11e 100644
--- a/sfpdiag.c
+++ b/sfpdiag.c
@@ -242,7 +242,6 @@ static void sff8472_parse_eeprom(const __u8 *id, struct sff_diags *sd)
 void sff8472_show_all(const __u8 *id)
 {
 	struct sff_diags sd = {0};
-	char *rx_power_string = NULL;
 	int i;
 
 	sff8472_parse_eeprom(id, &sd);
@@ -256,12 +255,8 @@ void sff8472_show_all(const __u8 *id)
 	PRINT_BIAS("Laser bias current", sd.bias_cur[MCURR]);
 	PRINT_xX_PWR("Laser output power", sd.tx_power[MCURR]);
 
-	if (!sd.rx_power_type)
-		rx_power_string = "Receiver signal OMA";
-	else
-		rx_power_string = "Receiver signal average optical power";
-
-	PRINT_xX_PWR(rx_power_string, sd.rx_power[MCURR]);
+	PRINT_xX_PWR(sd.rx_power_type ? rx_power_average : rx_power_oma,
+		     sd.rx_power[MCURR]);
 
 	PRINT_TEMP("Module temperature", sd.sfp_temp[MCURR]);
 	PRINT_VCC("Module voltage", sd.sfp_voltage[MCURR]);
-- 
2.31.1

