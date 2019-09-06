Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEBDBABD37
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 18:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395049AbfIFQBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 12:01:24 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35285 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfIFQBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 12:01:21 -0400
Received: by mail-wm1-f65.google.com with SMTP id n10so7703010wmj.0
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 09:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=39DItuO4WiQ6caSELzSQFtKaaFqyuKgI3/dKRZK4KK4=;
        b=vHX1vaXoyABPil4nazCNqVVyBLB8q/scXcz9W9h6ivNecc12ig+jCehZuAkVWfnWrh
         F0daZpb3+Ljj0B5eIFhtHBW8Ecw3Bv65RN0THOhuO6GQchwMc91XmvMuihxaj9lCyqw3
         kb4fcQjIbFxpMADRkoy7pKqlmZ/IPxGH+asdll6Tb84a7ohE4EkaYa1JBwbxh3OPVrrA
         dhlZkAbobGqa+hfW/vAqVC1C28s8t1vcIDKtT51UiYMrd21NRaTcszDvPqgxvOeIJGJz
         JFdjbteqgZMHZtv2RtuSTqoplVuEMPaNi3CMvB3N2BS4LYetmumNBLdtVDDwu7HhKsQI
         qBzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=39DItuO4WiQ6caSELzSQFtKaaFqyuKgI3/dKRZK4KK4=;
        b=PcAu0W7Y9R459sPCG94Fy8PHf2eSWneHkOknWKuW9Z40QxHcfbCPrf86Fvs+K8PssL
         j2QR2l04eC3AhnuMUiYIcoIbDfQcr/qTg+B1U2xaVgViLuhT5GD/cNP5CmOrkB5vywVt
         6oP85q/P2a3OQ4C5kDxu6W4oTQBEGMvpeSWAbdvMNB9wzzOTTGIuKvfg0F+EjZjwbWlr
         4wJRXpVDpUrZutRzXs8N0oJjNBlO48KkC3INJIuRqz8L/A59m4RO7aMbtjUZdfbBSmWv
         BvVNk+FThdOmZROLm4VjOjw5T6bmPA1uFsxJfvCQKDmUmAXD+crcQwSXzvWhy63WV9w+
         yXXw==
X-Gm-Message-State: APjAAAXHpFOKQHBvGBUP4kP8uuqWUKZImEg4vbA+zrD79ZgJ+G8jA5pa
        zjHvXXfYvAX8Ri5BwLSAXtm68Q==
X-Google-Smtp-Source: APXvYqxLtm1hga97pZYHiWg/zikzepIZn3QHMYI0bPipNVmPG4IXtV5nDgyIeQ9Ed9aFWd6WqScO/A==
X-Received: by 2002:a1c:6782:: with SMTP id b124mr8482686wmc.143.1567785680143;
        Fri, 06 Sep 2019 09:01:20 -0700 (PDT)
Received: from reginn.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id s1sm8524567wrg.80.2019.09.06.09.01.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 09:01:19 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [net-next 08/11] nfp: devlink: add 'fw_load_policy' support
Date:   Fri,  6 Sep 2019 18:00:58 +0200
Message-Id: <20190906160101.14866-9-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190906160101.14866-1-simon.horman@netronome.com>
References: <20190906160101.14866-1-simon.horman@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Add support for the 'fw_load_policy' devlink parameter. The FW load
policy is controlled by the 'app_fw_from_flash' hwinfo key.

Remap the values from devlink to the hwinfo key and back.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 Documentation/networking/devlink-params-nfp.txt    |   2 +
 drivers/net/ethernet/netronome/nfp/devlink_param.c | 165 +++++++++++++++++++++
 2 files changed, 167 insertions(+)
 create mode 100644 Documentation/networking/devlink-params-nfp.txt

diff --git a/Documentation/networking/devlink-params-nfp.txt b/Documentation/networking/devlink-params-nfp.txt
new file mode 100644
index 000000000000..85b1e36f73a8
--- /dev/null
+++ b/Documentation/networking/devlink-params-nfp.txt
@@ -0,0 +1,2 @@
+fw_load_policy		[DEVICE, GENERIC]
+			Configuration mode: permanent
diff --git a/drivers/net/ethernet/netronome/nfp/devlink_param.c b/drivers/net/ethernet/netronome/nfp/devlink_param.c
index aece98586e32..d9c74cfba560 100644
--- a/drivers/net/ethernet/netronome/nfp/devlink_param.c
+++ b/drivers/net/ethernet/netronome/nfp/devlink_param.c
@@ -3,10 +3,175 @@
 
 #include <net/devlink.h>
 
+#include "nfpcore/nfp.h"
 #include "nfpcore/nfp_nsp.h"
 #include "nfp_main.h"
 
+/**
+ * struct nfp_devlink_param_u8_arg - Devlink u8 parameter get/set arguments
+ * @hwinfo_name:	HWinfo key name
+ * @default_hi_val:	Default HWinfo value if HWinfo doesn't exist
+ * @invalid_dl_val:	Devlink value to use if HWinfo is unknown/invalid.
+ *			-errno if there is no unknown/invalid value available
+ * @hi_to_dl:	HWinfo to devlink value mapping
+ * @dl_to_hi:	Devlink to hwinfo value mapping
+ * @max_dl_val:	Maximum devlink value supported, for validation only
+ * @max_hi_val:	Maximum HWinfo value supported, for validation only
+ */
+struct nfp_devlink_param_u8_arg {
+	const char *hwinfo_name;
+	const char *default_hi_val;
+	int invalid_dl_val;
+	u8 hi_to_dl[4];
+	u8 dl_to_hi[4];
+	u8 max_dl_val;
+	u8 max_hi_val;
+};
+
+static const struct nfp_devlink_param_u8_arg nfp_devlink_u8_args[] = {
+	[DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY] = {
+		.hwinfo_name = "app_fw_from_flash",
+		.default_hi_val = NFP_NSP_APP_FW_LOAD_DEFAULT,
+		.invalid_dl_val = -EINVAL,
+		.hi_to_dl = {
+			[NFP_NSP_APP_FW_LOAD_DISK] =
+				DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK,
+			[NFP_NSP_APP_FW_LOAD_FLASH] =
+				DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_FLASH,
+			[NFP_NSP_APP_FW_LOAD_PREF] =
+				DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DRIVER,
+		},
+		.dl_to_hi = {
+			[DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DRIVER] =
+				NFP_NSP_APP_FW_LOAD_PREF,
+			[DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_FLASH] =
+				NFP_NSP_APP_FW_LOAD_FLASH,
+			[DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK] =
+				NFP_NSP_APP_FW_LOAD_DISK,
+		},
+		.max_dl_val = DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK,
+		.max_hi_val = NFP_NSP_APP_FW_LOAD_PREF,
+	},
+};
+
+static int
+nfp_devlink_param_u8_get(struct devlink *devlink, u32 id,
+			 struct devlink_param_gset_ctx *ctx)
+{
+	const struct nfp_devlink_param_u8_arg *arg;
+	struct nfp_pf *pf = devlink_priv(devlink);
+	struct nfp_nsp *nsp;
+	char hwinfo[32];
+	long value;
+	int err;
+
+	if (id >= ARRAY_SIZE(nfp_devlink_u8_args))
+		return -EOPNOTSUPP;
+
+	arg = &nfp_devlink_u8_args[id];
+
+	nsp = nfp_nsp_open(pf->cpp);
+	if (IS_ERR(nsp)) {
+		err = PTR_ERR(nsp);
+		nfp_warn(pf->cpp, "can't access NSP: %d\n", err);
+		return err;
+	}
+
+	snprintf(hwinfo, sizeof(hwinfo), arg->hwinfo_name);
+	err = nfp_nsp_hwinfo_lookup_optional(nsp, hwinfo, sizeof(hwinfo),
+					     arg->default_hi_val);
+	if (err) {
+		nfp_warn(pf->cpp, "HWinfo lookup failed: %d\n", err);
+		goto exit_close_nsp;
+	}
+
+	err = kstrtol(hwinfo, 0, &value);
+	if (err || value < 0 || value > arg->max_hi_val) {
+		nfp_warn(pf->cpp, "HWinfo '%s' value %li invalid\n",
+			 arg->hwinfo_name, value);
+
+		if (arg->invalid_dl_val >= 0)
+			ctx->val.vu8 = arg->invalid_dl_val;
+		else
+			err = arg->invalid_dl_val;
+
+		goto exit_close_nsp;
+	}
+
+	ctx->val.vu8 = arg->hi_to_dl[value];
+
+exit_close_nsp:
+	nfp_nsp_close(nsp);
+	return err;
+}
+
+static int
+nfp_devlink_param_u8_set(struct devlink *devlink, u32 id,
+			 struct devlink_param_gset_ctx *ctx)
+{
+	const struct nfp_devlink_param_u8_arg *arg;
+	struct nfp_pf *pf = devlink_priv(devlink);
+	struct nfp_nsp *nsp;
+	char hwinfo[32];
+	int err;
+
+	if (id >= ARRAY_SIZE(nfp_devlink_u8_args))
+		return -EOPNOTSUPP;
+
+	arg = &nfp_devlink_u8_args[id];
+
+	nsp = nfp_nsp_open(pf->cpp);
+	if (IS_ERR(nsp)) {
+		err = PTR_ERR(nsp);
+		nfp_warn(pf->cpp, "can't access NSP: %d\n", err);
+		return err;
+	}
+
+	/* Note the value has already been validated. */
+	snprintf(hwinfo, sizeof(hwinfo), "%s=%u",
+		 arg->hwinfo_name, arg->dl_to_hi[ctx->val.vu8]);
+	err = nfp_nsp_hwinfo_set(nsp, hwinfo, sizeof(hwinfo));
+	if (err) {
+		nfp_warn(pf->cpp, "HWinfo set failed: %d\n", err);
+		goto exit_close_nsp;
+	}
+
+exit_close_nsp:
+	nfp_nsp_close(nsp);
+	return err;
+}
+
+static int
+nfp_devlink_param_u8_validate(struct devlink *devlink, u32 id,
+			      union devlink_param_value val,
+			      struct netlink_ext_ack *extack)
+{
+	const struct nfp_devlink_param_u8_arg *arg;
+
+	if (id >= ARRAY_SIZE(nfp_devlink_u8_args))
+		return -EOPNOTSUPP;
+
+	arg = &nfp_devlink_u8_args[id];
+
+	if (val.vu8 > arg->max_dl_val) {
+		NL_SET_ERR_MSG_MOD(extack, "parameter out of range");
+		return -EINVAL;
+	}
+
+	if (val.vu8 == arg->invalid_dl_val) {
+		NL_SET_ERR_MSG_MOD(extack, "unknown/invalid value specified");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static const struct devlink_param nfp_devlink_params[] = {
+	DEVLINK_PARAM_GENERIC(FW_LOAD_POLICY,
+			      BIT(DEVLINK_PARAM_CMODE_PERMANENT),
+			      nfp_devlink_param_u8_get,
+			      nfp_devlink_param_u8_set,
+			      nfp_devlink_param_u8_validate),
 };
 
 static int nfp_devlink_supports_params(struct nfp_pf *pf)
-- 
2.11.0

