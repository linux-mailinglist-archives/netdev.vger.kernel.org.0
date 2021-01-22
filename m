Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EFF300046
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 11:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbhAVK24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 05:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727343AbhAVJsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:48:16 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE65BC06121D
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:46:56 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id a1so4444773wrq.6
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 01:46:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uGaLH/m4247xtZVtEOxFS/w4e5oCslU42uUKUjQmMV4=;
        b=z2FU/7djy/8eTtAxO1RFPH5CnHupbmfpNgCP9RenW8pdIiCGj4Mj+S1ueZ53vuUwuM
         hzb8E4+6xY44A5vzYUpmwnPUALjq0xpopi+IA83WxiidIEabnFg117yR3yF7F4wN5Ol3
         ZJN0SaLmFSTDhzQc+ugBgkvymZ5aPrz19D3dzqV9NjYiFal0XUqqpXRjW6/5wv5SrElf
         6GWcyvnca5xy9hPIvgzHfyhqxx6H4mECcqWwnLXi3AFuQuZCH2suwwHSKUt/3XC7KZIQ
         3Ekn3e2SvBabarB7oKlBbuboK+80g5M9KsXSOcd1jdMRPHHL3KHptv+0EyPXPcqwD3/d
         TeXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uGaLH/m4247xtZVtEOxFS/w4e5oCslU42uUKUjQmMV4=;
        b=km1OlYa8e6XIHic/wxglflIIbcIaC/q0I01Vf03/oCzKLnApiT3I408CE7mwkhA44D
         e22IQuieVhIR1PTUo3/AYpJ/WzT4n8pA6nGB2C1EDOBuisBYF9vTe4GV0e/BAhMOxOHg
         5ZEZGw/sVyaR46IV+t141Ky8oqGlJ1uGBE29MWtUax9hdIHcXWfiskNEnIuXiGIUeWLl
         LZB00YDzHBo3aAeW7qSnnbwDF9g4DKulD1YP+cQ1PUALk4JzycBnicXIPlIZ4gJtwOAP
         dFX4nkZRp8HRZEW5gqhluJkU7+o4Q81sjM8Hb+2AKIRuOtxXqehbbdpiTyFIS0JmYEdY
         1mbw==
X-Gm-Message-State: AOAM533qP/FYFCO8QkYkqAeDGsyLCYcaM/ism6JNXvGm8V/oT+gyH8mB
        uzEifCXhbL0oqKjc/6WEbGRiagfJstxwDF1mJXc=
X-Google-Smtp-Source: ABdhPJz/cgH3SY3rASeSITOqeje/L6v67qTKHuPgOkHQflUul36+5DruVZkpdNELXOj32gH0irlYYA==
X-Received: by 2002:a5d:6cb4:: with SMTP id a20mr3618789wra.192.1611308815474;
        Fri, 22 Jan 2021 01:46:55 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id u16sm11685417wrn.68.2021.01.22.01.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 01:46:55 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, andrew@lunn.ch, dsahern@gmail.com,
        mlxsw@nvidia.com
Subject: [patch net-next RFCv2 05/10] devlink: add port to line card relationship set
Date:   Fri, 22 Jan 2021 10:46:43 +0100
Message-Id: <20210122094648.1631078-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210122094648.1631078-1-jiri@resnulli.us>
References: <20210122094648.1631078-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

In order to properly inform user about relationship between port and
line card, introduce a driver API to set line card for a port. Use this
information to extend port devlink netlink message by line card index
and also include the line card index into phys_port_name and by that
into a netdevice name.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/net/devlink.h |  3 +++
 net/core/devlink.c    | 25 ++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index f3b0e88add90..57293a18124a 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -137,6 +137,7 @@ struct devlink_port {
 	struct delayed_work type_warn_dw;
 	struct list_head reporter_list;
 	struct mutex reporters_lock; /* Protects reporter_list */
+	struct devlink_linecard *linecard;
 };
 
 struct devlink_linecard_ops;
@@ -1438,6 +1439,8 @@ void devlink_port_attrs_pci_pf_set(struct devlink_port *devlink_port, u32 contro
 				   u16 pf, bool external);
 void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 controller,
 				   u16 pf, u16 vf, bool external);
+void devlink_port_linecard_set(struct devlink_port *devlink_port,
+			       struct devlink_linecard *linecard);
 struct devlink_linecard *
 devlink_linecard_create(struct devlink *devlink, unsigned int linecard_index,
 			const struct devlink_linecard_ops *ops, void *priv);
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 80fcfbb27024..1ec683383035 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -855,6 +855,10 @@ static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devlink,
 		goto nla_put_failure;
 	if (devlink_nl_port_function_attrs_put(msg, devlink_port, extack))
 		goto nla_put_failure;
+	if (devlink_port->linecard &&
+	    nla_put_u32(msg, DEVLINK_ATTR_LINECARD_INDEX,
+			devlink_port->linecard->index))
+		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
 	return 0;
@@ -8661,6 +8665,21 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
 }
 EXPORT_SYMBOL_GPL(devlink_port_attrs_pci_vf_set);
 
+/**
+ *	devlink_port_linecard_set - Link port with a linecard
+ *
+ *	@devlink_port: devlink port
+ *	@devlink_linecard: devlink linecard
+ */
+void devlink_port_linecard_set(struct devlink_port *devlink_port,
+			       struct devlink_linecard *linecard)
+{
+	if (WARN_ON(devlink_port->registered))
+		return;
+	devlink_port->linecard = linecard;
+}
+EXPORT_SYMBOL_GPL(devlink_port_linecard_set);
+
 static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 					     char *name, size_t len)
 {
@@ -8673,7 +8692,11 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 	switch (attrs->flavour) {
 	case DEVLINK_PORT_FLAVOUR_PHYSICAL:
 	case DEVLINK_PORT_FLAVOUR_VIRTUAL:
-		n = snprintf(name, len, "p%u", attrs->phys.port_number);
+		if (devlink_port->linecard)
+			n = snprintf(name, len, "l%u",
+				     devlink_port->linecard->index);
+		n += snprintf(name + n, len - n, "p%u",
+			      attrs->phys.port_number);
 		if (attrs->split)
 			n += snprintf(name + n, len - n, "s%u",
 				      attrs->phys.split_subport_number);
-- 
2.26.2

