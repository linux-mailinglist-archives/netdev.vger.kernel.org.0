Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790772F4B14
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbhAMMNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 07:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbhAMMNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 07:13:46 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313D2C0617A2
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 04:12:31 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id q18so1893994wrn.1
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 04:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=teuEjPh52h3oV1ShtApks7daisOe6Febjyada3/d28o=;
        b=BdKdNPcvNjL2nNL3ZQ7/aNO7WOPaPBPlR3wp9z9DBwRkVlcbS5K1C4mvIpDCplzVFq
         FFK2fMZ4rgdbNDfyCOGjYZjoEblEdqT4bRK3bRHU2xZIuntzhXDUmS9U4J0AOuh7+SbM
         kQmBpxBtHZQZNk1tNQW/tt4LbWR13CJn9CGBfXM5EPqgdirqFdgmAJikRlCCXbW2ekdK
         J4Kvak+IdJ8G8PEjNTNR/jbTmAfYUPDXVImVa0byKb9Rg1ZGkljwoqOMCZuxZ7uHXFm2
         b6QK4UTtdr3E98qBrGrKJWIsEfKMu7c+9rRgJp3dReAUadxXxQB8iB5rIqrgOLLDSo8R
         GHoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=teuEjPh52h3oV1ShtApks7daisOe6Febjyada3/d28o=;
        b=DPoRij/AIp6PUCFb4YZvnyoy9R4iDH/80j+Kqg7w/oq9tidXSzJGx7PzQQ/gbQSrfJ
         n2pWfSAd/sbEXtcq/J5fCTIwsaw3u8LB/n6d5ii2xXdBeeU0VDVxKbInb22DaELoMgJU
         RYPtk1Y3uBz8F4BxuiqnedkUXaD+HoBP/bekx8wmUNC3xMuNLwYc/rOYjTY9fdXMT5fk
         e8bq1cSl3/MViUnzCjMGDMUZeeLvKL7VG4wJ46kHKQW8sND+10xKlhMDmhcFmQulNV6i
         ZI9/RQcz84ctaS7bHpgRy75jUCZyMwK421r4i8JP3jchpbB0mF3sW9eYdRmZI5Qxnc8+
         1vdA==
X-Gm-Message-State: AOAM533WEh1ake9hafoJyujStlFEOfcDc9qPZ+R+EZJT2ZbFWR3kednW
        Ce0rlVZByAsphkxVj6X7bwMQIFB4ueSAbbZo
X-Google-Smtp-Source: ABdhPJwQ1OArMWrEE69pix+F6MLx9tHbZg/imnX80/F71y2PiNBs60iE1eH/64q6Kt/rk38tq1rW9Q==
X-Received: by 2002:a5d:4ad0:: with SMTP id y16mr2288778wrs.424.1610539949631;
        Wed, 13 Jan 2021 04:12:29 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id c6sm3176111wrh.7.2021.01.13.04.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 04:12:29 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, mlxsw@nvidia.com
Subject: [patch net-next RFC 05/10] devlink: add port to line card relationship set
Date:   Wed, 13 Jan 2021 13:12:17 +0100
Message-Id: <20210113121222.733517-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210113121222.733517-1-jiri@resnulli.us>
References: <20210113121222.733517-1-jiri@resnulli.us>
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
index ec00cd94c626..cb911b6fdeda 100644
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
index 347976b88404..2faa30cc5cce 100644
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
@@ -8642,6 +8646,21 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port, u32 contro
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
@@ -8654,7 +8673,11 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
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

