Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDB5AD147
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 01:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731531AbfIHXyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 19:54:54 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43391 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731203AbfIHXyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 19:54:54 -0400
Received: by mail-qk1-f194.google.com with SMTP id h126so3656641qke.10
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 16:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OAfWibDu4zRz2cliMjfQmubuVEIcTGefP06/QaW45tI=;
        b=bulcnN0Kso0i5oCcwNL9LZdjFmkzBws3NAIs0GsdmHCEgfwzy32eyCVeS7TX/hK7q3
         ljXooPYGTNL1/sVgZ/EOYDJNTxcaga5gN5nzviaXLoyVy3mYFQiCrxy3J794DNPN8wdF
         mVj/FdnSa+hcVhzcJLPiZCcXCNPG+nCoxElOw1YYz2O3JtlYCRYdQu2CvY/tiLG+GF0H
         Gub4MWFC+XQ/3tbsGk77btweHkZxaSaqm5MCkJYIjnjpCdKIpfuAacSx81w+ZSHxBlEu
         bCdmPTvHzlrsbWxmISc1S0zuA7IsXk/UUTdYh5PXlFhg35bJe9UcGTovV9EX9fP/OnoG
         meuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OAfWibDu4zRz2cliMjfQmubuVEIcTGefP06/QaW45tI=;
        b=aEenv0Zxnv0WZ69TTmNOj/jXmo3CYaKgYx1KTutNh7LMSwbNkYoos9Bhk8nVGM4Phc
         bUWySfzWH3vXRG0KoxXtvp/lERCNfB7LSKGRn9UrGpMiXlNUNKyGTtyWMCLB8nGErsAb
         CjuUA8uAE/pqu2mTef3Ko4EhXIWp1rVTXX4TLK7r1Z1lmIhsDXBZ/jtC9A8b/bVrDCzx
         225gZeQuwFJGnJuZEyaCZFmVm/MOkfuviZV9sgp8UxhRVIFqcmR0UdPDSjjoJZU3kIS/
         V4w+H0MDVAWXEK1fjwmLXyap0L37F2+mOYD97axLB1vSLe6Y09nAPYoDuKDqW9GMfFGp
         9zpw==
X-Gm-Message-State: APjAAAXO/M2ANK0SYPneZkK/6sDCYIvd9lYe7is18l8FbppfMGzIdKKQ
        l6k3yj8M7Cb+nuMTCeQxZRT5GA==
X-Google-Smtp-Source: APXvYqy0zJJ3Qw6bnmjV3fvj6SvgDz3SKUhnKP6CvXnLxEqtzS55PaHpkC4xTuTu1xKgX68GRpYpUw==
X-Received: by 2002:ae9:f445:: with SMTP id z5mr20302523qkl.121.1567986892942;
        Sun, 08 Sep 2019 16:54:52 -0700 (PDT)
Received: from penelope.pa.netronome.com (195-23-252-147.net.novis.pt. [195.23.252.147])
        by smtp.gmail.com with ESMTPSA id p27sm5464406qkm.92.2019.09.08.16.54.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 16:54:52 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next v2 02/11] devlink: add 'reset_dev_on_drv_probe' param
Date:   Mon,  9 Sep 2019 00:54:18 +0100
Message-Id: <20190908235427.9757-3-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190908235427.9757-1-simon.horman@netronome.com>
References: <20190908235427.9757-1-simon.horman@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Add the 'reset_dev_on_drv_probe' devlink parameter, controlling the
device reset policy on driver probe.

This parameter is useful in conjunction with the existing
'fw_load_policy' parameter.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 Documentation/networking/devlink-params.txt | 14 ++++++++++++++
 include/net/devlink.h                       |  5 +++++
 include/uapi/linux/devlink.h                |  7 +++++++
 net/core/devlink.c                          |  5 +++++
 4 files changed, 31 insertions(+)

diff --git a/Documentation/networking/devlink-params.txt b/Documentation/networking/devlink-params.txt
index fadb5436188d..ddba3e9b55b1 100644
--- a/Documentation/networking/devlink-params.txt
+++ b/Documentation/networking/devlink-params.txt
@@ -51,3 +51,17 @@ fw_load_policy		[DEVICE, GENERIC]
 			* DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK (2)
 			  Load firmware currently available on host's disk.
 			Type: u8
+
+reset_dev_on_drv_probe	[DEVICE, GENERIC]
+			Controls the device's reset policy on driver probe.
+			Valid values:
+			* DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_UNKNOWN (0)
+			  Unknown or invalid value.
+			* DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_ALWAYS (1)
+			  Always reset device on driver probe.
+			* DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_NEVER (2)
+			  Never reset device on driver probe.
+			* DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_DISK (3)
+			  Reset only if device firmware can be found in the
+			  filesystem.
+			Type: u8
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 460bc629d1a4..03e4d9244ff3 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -398,6 +398,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_MSIX_VEC_PER_PF_MAX,
 	DEVLINK_PARAM_GENERIC_ID_MSIX_VEC_PER_PF_MIN,
 	DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
+	DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -428,6 +429,10 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_FW_LOAD_POLICY_NAME "fw_load_policy"
 #define DEVLINK_PARAM_GENERIC_FW_LOAD_POLICY_TYPE DEVLINK_PARAM_TYPE_U8
 
+#define DEVLINK_PARAM_GENERIC_RESET_DEV_ON_DRV_PROBE_NAME \
+	"reset_dev_on_drv_probe"
+#define DEVLINK_PARAM_GENERIC_RESET_DEV_ON_DRV_PROBE_TYPE DEVLINK_PARAM_TYPE_U8
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index c25cc29a6647..1da3e83f1fd4 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -205,6 +205,13 @@ enum devlink_param_fw_load_policy_value {
 	DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK,
 };
 
+enum devlink_param_reset_dev_on_drv_probe_value {
+	DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_UNKNOWN,
+	DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_ALWAYS,
+	DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_NEVER,
+	DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_DISK,
+};
+
 enum {
 	DEVLINK_ATTR_STATS_RX_PACKETS,		/* u64 */
 	DEVLINK_ATTR_STATS_RX_BYTES,		/* u64 */
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6e52d639dac6..4a2fb94c44cf 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -2852,6 +2852,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_FW_LOAD_POLICY_NAME,
 		.type = DEVLINK_PARAM_GENERIC_FW_LOAD_POLICY_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
+		.name = DEVLINK_PARAM_GENERIC_RESET_DEV_ON_DRV_PROBE_NAME,
+		.type = DEVLINK_PARAM_GENERIC_RESET_DEV_ON_DRV_PROBE_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.11.0

