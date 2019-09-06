Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6633ABD39
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 18:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395051AbfIFQB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 12:01:27 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52284 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395043AbfIFQBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 12:01:23 -0400
Received: by mail-wm1-f67.google.com with SMTP id t17so7075060wmi.2
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 09:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XA+OI2R78fsHqlyrw1AaSbsvFpqLK1SIrK45sVXiwT0=;
        b=WXOhNVWQn3tyo+oUjVNgC6Pij3h7SIub6oil66uDomcL03002t+IYE6yepPtbpl8Kf
         I6fcr6mO2Ej3ImH++s42TIYYW07P1ZzVUrqZTOxh4W/F322tCvrxqMpg+vaWCfMI0qyt
         lLOxuO0huBA/UyQUjlMGfLN1dc/58XCBGWgzFNXRlCGzEWaw4vz1MGZah4ygJGsrjsao
         Ew+H8kxDDxnEMl5kdwQhS3i6MObhQ/XTUzP+KsqKIuWFq+rljWowWeXYliw/2vNKLmRm
         fQwZQ2ejbmr10vH2Ewpw+aldLRa/nlcmynM7gD19aKfKQucVaRw/8nOwthLGkEkLNcyh
         cf7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XA+OI2R78fsHqlyrw1AaSbsvFpqLK1SIrK45sVXiwT0=;
        b=Ply6IF9raBy3x6bh7YizSldnrrZA4sKxdoULbqOoLekqLMCijS2qwarfAdGS37YA8h
         j6sNopt4MwxqER9m9UY3it1SgxRyRLw9inDGUaWKcXc4bCnULS+xkLtMc+eDLXn1pam9
         IH+GjPj82tYeyAHSQTJ7p0svVd1EgE6a740wNUHH3MR7XO0dCN+Oft4geqeaWYSsSZVO
         wu9qWo2jW7UlXPrzqQi+R2h3cOAQkV5m0auXJWejYg1q0BdOUGxcwvWBJyYoF7QELlzq
         JtJnRqGGiNrg22748qmDt6cYnyJaeAtGTU1tGXSs29uuUXck/MwF4c/E099oqjySEe+L
         l0Sw==
X-Gm-Message-State: APjAAAW9XW2EmtX1alnN0cTePlm+u93TNjPxLEsDHPfecAQcVQv1/Xst
        ItIoak/TEfpQL7pCal4NXlLsJA==
X-Google-Smtp-Source: APXvYqyFDHxrlsoy1i61LPJ5gFa/rQqH1t3NNGnZWBcf58Mp6vClC41pHe32W0B86QJKH03rWgeLhA==
X-Received: by 2002:a7b:cbc2:: with SMTP id n2mr7492763wmi.139.1567785681245;
        Fri, 06 Sep 2019 09:01:21 -0700 (PDT)
Received: from reginn.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id s1sm8524567wrg.80.2019.09.06.09.01.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 09:01:20 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [net-next 09/11] nfp: devlink: add 'reset_dev_on_drv_probe' support
Date:   Fri,  6 Sep 2019 18:00:59 +0200
Message-Id: <20190906160101.14866-10-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190906160101.14866-1-simon.horman@netronome.com>
References: <20190906160101.14866-1-simon.horman@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Add support for the 'reset_dev_on_drv_probe' devlink parameter. The
reset control policy is controlled by the 'abi_drv_reset' hwinfo key.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 Documentation/networking/devlink-params-nfp.txt    |  3 +++
 drivers/net/ethernet/netronome/nfp/devlink_param.c | 28 ++++++++++++++++++++++
 2 files changed, 31 insertions(+)

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
index d9c74cfba560..df5a5c88ee76 100644
--- a/drivers/net/ethernet/netronome/nfp/devlink_param.c
+++ b/drivers/net/ethernet/netronome/nfp/devlink_param.c
@@ -52,6 +52,29 @@ static const struct nfp_devlink_param_u8_arg nfp_devlink_u8_args[] = {
 		.max_dl_val = DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK,
 		.max_hi_val = NFP_NSP_APP_FW_LOAD_PREF,
 	},
+	[DEVLINK_PARAM_GENERIC_ID_RESET_DEV] = {
+		.hwinfo_name = "abi_drv_reset",
+		.default_hi_val = NFP_NSP_DRV_RESET_DEFAULT,
+		.invalid_dl_val = DEVLINK_PARAM_RESET_DEV_VALUE_UNKNOWN,
+		.hi_to_dl = {
+			[NFP_NSP_DRV_RESET_ALWAYS] =
+				DEVLINK_PARAM_RESET_DEV_VALUE_ALWAYS,
+			[NFP_NSP_DRV_RESET_NEVER] =
+				DEVLINK_PARAM_RESET_DEV_VALUE_NEVER,
+			[NFP_NSP_DRV_RESET_DISK] =
+				DEVLINK_PARAM_RESET_DEV_VALUE_DISK,
+		},
+		.dl_to_hi = {
+			[DEVLINK_PARAM_RESET_DEV_VALUE_ALWAYS] =
+				NFP_NSP_DRV_RESET_ALWAYS,
+			[DEVLINK_PARAM_RESET_DEV_VALUE_NEVER] =
+				NFP_NSP_DRV_RESET_NEVER,
+			[DEVLINK_PARAM_RESET_DEV_VALUE_DISK] =
+				NFP_NSP_DRV_RESET_DISK,
+		},
+		.max_dl_val = DEVLINK_PARAM_RESET_DEV_VALUE_DISK,
+		.max_hi_val = NFP_NSP_DRV_RESET_NEVER,
+	}
 };
 
 static int
@@ -172,6 +195,11 @@ static const struct devlink_param nfp_devlink_params[] = {
 			      nfp_devlink_param_u8_get,
 			      nfp_devlink_param_u8_set,
 			      nfp_devlink_param_u8_validate),
+	DEVLINK_PARAM_GENERIC(RESET_DEV,
+			      BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			      nfp_devlink_param_u8_get,
+			      nfp_devlink_param_u8_set,
+			      nfp_devlink_param_u8_validate),
 };
 
 static int nfp_devlink_supports_params(struct nfp_pf *pf)
-- 
2.11.0

