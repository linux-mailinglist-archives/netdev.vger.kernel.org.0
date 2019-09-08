Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4258CAD14E
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 01:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731670AbfIHXzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 19:55:09 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41111 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731649AbfIHXzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 19:55:07 -0400
Received: by mail-qk1-f193.google.com with SMTP id o11so11352050qkg.8
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 16:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=V6RCP6M4YEyWGsl8TrDKulGop/UMht/FxAzB5SUwGN4=;
        b=ZF+lq0U0idjBei/+FHL2SV9NR9bAjfvtfacw7Hoh9uSn//t9+r7q/iHgneHydLt55S
         oYvFOj8rf7YmcIItz5cD4dQLqVZqtF7KB01ChaMzbL8UEHqg3XmR1FNGCHHmvxnl2aYo
         ZTU2K72FTu/lgL05+xEyCdEfVMp7IOvATQlKJ1x6SSYpy6UNpLXHiwTlvnfuRdL2lpdP
         cAQlw9Z6H/y++4k37U1vQP7HZyqupMX0EW8jMgolEJrRXgUtWdKmu+OLdjAkcZwSRcH0
         ULyDWE6Z3G+FVQxHw5CJp7OLjjvbX5zexxpcWAGlD+wabjXT26hS0kj0GbK4kmab0Ymn
         kW5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=V6RCP6M4YEyWGsl8TrDKulGop/UMht/FxAzB5SUwGN4=;
        b=kJ3LPY4NLoytAscYH2yZl7Mzq2RhiQl+KRCOgOPNoDYtaGu8mjfd9lmx92PtAhEcHK
         sDvdm1eT8q0QccikL6N7flKOaCz6j/5iexgmHFEIpXm6qgu+e2J0wa96yawDKX3XjRWa
         RQlv2ViQxFv7+fNg+RO31gf1P96XUcYfbX63BJffmiyFAAQemJG5sNVA5PAjeoaHuxTw
         MxxJbviBVjyObijHFhKf3TCYNHTD91xjVRkMMAX/h8hUDjvqHBwmnTbWYv3PD4sBR0C7
         25r9RqRbh5nVidSQhplVkBJGt3kxbWBC5aNeZmkQO5PHbEvqJMcSAD/7JzwSNuqLL+wz
         9xOw==
X-Gm-Message-State: APjAAAVehs57G3X929YtLCWj0R7sZTwbd1bQ/2Hf0ZJFXgW+S7odaoe8
        s9tnrt3e3h7oiYqEXSazcK/BlA==
X-Google-Smtp-Source: APXvYqy9a+628NesnNTLDV0sP9Eo+4LqRv+Y8e1bHlkk+bacMREw6Ykge5IGczKi7pjDwD8eqazunQ==
X-Received: by 2002:a37:b981:: with SMTP id j123mr18014550qkf.201.1567986906412;
        Sun, 08 Sep 2019 16:55:06 -0700 (PDT)
Received: from penelope.pa.netronome.com (195-23-252-147.net.novis.pt. [195.23.252.147])
        by smtp.gmail.com with ESMTPSA id p27sm5464406qkm.92.2019.09.08.16.55.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Sep 2019 16:55:05 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next v2 09/11] nfp: devlink: add 'reset_dev_on_drv_probe' support
Date:   Mon,  9 Sep 2019 00:54:25 +0100
Message-Id: <20190908235427.9757-10-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190908235427.9757-1-simon.horman@netronome.com>
References: <20190908235427.9757-1-simon.horman@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Add support for the 'reset_dev_on_drv_probe' devlink parameter. The
reset control policy is controlled by the 'abi_drv_reset' hwinfo key.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 Documentation/networking/devlink-params-nfp.txt    |  3 +++
 drivers/net/ethernet/netronome/nfp/devlink_param.c | 29 ++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/Documentation/networking/devlink-params-nfp.txt b/Documentation/networking/devlink-params-nfp.txt
index 85b1e36f73a8..43e4d4034865 100644
--- a/Documentation/networking/devlink-params-nfp.txt
+++ b/Documentation/networking/devlink-params-nfp.txt
@@ -1,2 +1,5 @@
 fw_load_policy		[DEVICE, GENERIC]
 			Configuration mode: permanent
+
+reset_dev_on_drv_probe	[DEVICE, GENERIC]
+			Configuration mode: permanent
diff --git a/drivers/net/ethernet/netronome/nfp/devlink_param.c b/drivers/net/ethernet/netronome/nfp/devlink_param.c
index d9c74cfba560..4a8141b4d625 100644
--- a/drivers/net/ethernet/netronome/nfp/devlink_param.c
+++ b/drivers/net/ethernet/netronome/nfp/devlink_param.c
@@ -52,6 +52,30 @@ static const struct nfp_devlink_param_u8_arg nfp_devlink_u8_args[] = {
 		.max_dl_val = DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK,
 		.max_hi_val = NFP_NSP_APP_FW_LOAD_PREF,
 	},
+	[DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE] = {
+		.hwinfo_name = "abi_drv_reset",
+		.default_hi_val = NFP_NSP_DRV_RESET_DEFAULT,
+		.invalid_dl_val =
+			DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_UNKNOWN,
+		.hi_to_dl = {
+			[NFP_NSP_DRV_RESET_ALWAYS] =
+				DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_ALWAYS,
+			[NFP_NSP_DRV_RESET_NEVER] =
+				DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_NEVER,
+			[NFP_NSP_DRV_RESET_DISK] =
+				DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_DISK,
+		},
+		.dl_to_hi = {
+			[DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_ALWAYS] =
+				NFP_NSP_DRV_RESET_ALWAYS,
+			[DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_NEVER] =
+				NFP_NSP_DRV_RESET_NEVER,
+			[DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_DISK] =
+				NFP_NSP_DRV_RESET_DISK,
+		},
+		.max_dl_val = DEVLINK_PARAM_RESET_DEV_ON_DRV_PROBE_VALUE_DISK,
+		.max_hi_val = NFP_NSP_DRV_RESET_NEVER,
+	}
 };
 
 static int
@@ -172,6 +196,11 @@ static const struct devlink_param nfp_devlink_params[] = {
 			      nfp_devlink_param_u8_get,
 			      nfp_devlink_param_u8_set,
 			      nfp_devlink_param_u8_validate),
+	DEVLINK_PARAM_GENERIC(RESET_DEV_ON_DRV_PROBE,
+			      BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			      nfp_devlink_param_u8_get,
+			      nfp_devlink_param_u8_set,
+			      nfp_devlink_param_u8_validate),
 };
 
 static int nfp_devlink_supports_params(struct nfp_pf *pf)
-- 
2.11.0

