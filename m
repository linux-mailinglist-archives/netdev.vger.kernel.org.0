Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2364218BFBC
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 19:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbgCSS4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 14:56:30 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44147 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbgCSS4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 14:56:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id o12so3966413wrh.11
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 11:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+FeXyvxzR442C4gaxk0bVJQRYEvvYGyfppUkfFgwoB4=;
        b=Fwg2rdQNVgaqgsB+geqGiTVIkJf0lfxGLGc5p3YGiWhzQd0LFpA/mQ7MdFhhXvBbTY
         goHY6JMX34pd+Lib8RNUaokJMBpCbOY3t4pFnQQtRfAQdzCl4muE6+uWA+wR1u+2m3SF
         weD86mEwI6S+Wilw1MRUebmBTSRSOrFcDIZ2xFsE5gkiiaDzGmLov5o8Od9bkR9Jy8iT
         ZH9udJTVv6acRQUi/mX6bVK5Fjn1F0zu4RaN1yT6N/QnuCcPUZchKeHy05UyuzJ0oTI0
         vfbVYYil0MQFevGj8EOVho6+JNT2y4HbiU/G5fv0qu0LxdJFQqwxW+7K8i7IeqfzLnmF
         pjqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+FeXyvxzR442C4gaxk0bVJQRYEvvYGyfppUkfFgwoB4=;
        b=QvvAzIlba/uNtZ4z+KoHvFqMMn/VJ3brYg4e8rM51+U96QrVB8/YdHmhE/cQdmRjce
         3ItcnMTsY7F1DYdfoJKO7rOBDSqah28w8DFPH1bpAjEsyqpFxiCEUMkZU2wX6vFz/xvV
         lDnMzYXOo9KvMQnqGH6vXH+0CNxwX6K+TWG3viF6KUlWEkFDEN14S07BCLV76SYiKZSc
         qfzEaS+LbBZlkj7SiuOxDOZ1Q7Km8aAnRvuxn+sQrdubF8co+iJQ8TyAkij1BtySh/QC
         rXCKlxhWCgiYTGq9S3wv8Sms/R0WMAyIkzPSWZcr+z47fbprIP8PhmrD8tutUC0QiUT4
         a7TQ==
X-Gm-Message-State: ANhLgQ2W2Us5wfy7dzExKxmDiX3Y2kNPAeK0iYCDnS4KBZV6OHiuFvrL
        NPUDPQba5lEKytet70zPHFM=
X-Google-Smtp-Source: ADFU+vt794EPhCJnLSie3ROVKQPUwBPlkaI46XdnzP3co7jzy2Gw5TMHF3rRy2jqQ9sUgpz0f8zpEw==
X-Received: by 2002:a5d:6ac3:: with SMTP id u3mr6310633wrw.358.1584644188085;
        Thu, 19 Mar 2020 11:56:28 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id i9sm4314452wmd.37.2020.03.19.11.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 11:56:27 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: [PATCH net-next 1/2] net: dsa: add a dsa_port_is_enabled helper function
Date:   Thu, 19 Mar 2020 20:56:19 +0200
Message-Id: <20200319185620.1581-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Sometimes drivers need to do per-port operation outside the port DSA
methods, and in that case they typically iterate through their port list
themselves.

Give them an aid to skip ports that are disabled in the device tree
(which the DSA core already skips).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h |  2 ++
 net/dsa/dsa2.c    | 29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index beeb81a532e3..813792e6f0be 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -376,6 +376,8 @@ static inline bool dsa_port_is_vlan_filtering(const struct dsa_port *dp)
 		return dp->vlan_filtering;
 }
 
+bool dsa_port_is_enabled(struct dsa_switch *ds, int port);
+
 typedef int dsa_fdb_dump_cb_t(const unsigned char *addr, u16 vid,
 			      bool is_static, void *data);
 struct dsa_switch_ops {
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index e7c30b472034..752f21273bd6 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -727,6 +727,35 @@ static int dsa_switch_parse_ports_of(struct dsa_switch *ds,
 	return err;
 }
 
+bool dsa_port_is_enabled(struct dsa_switch *ds, int port)
+{
+	struct device_node *dn = ds->dev->of_node;
+	struct device_node *ports, *port_node;
+	bool found = false;
+	int reg, err;
+
+	ports = of_get_child_by_name(dn, "ports");
+	if (!ports) {
+		dev_err(ds->dev, "no ports child node found\n");
+		return false;
+	}
+
+	for_each_available_child_of_node(ports, port_node) {
+		err = of_property_read_u32(port_node, "reg", &reg);
+		if (err)
+			goto out_put_node;
+
+		if (reg == port) {
+			found = true;
+			break;
+		}
+	}
+
+out_put_node:
+	of_node_put(ports);
+	return found;
+}
+
 static int dsa_switch_parse_member_of(struct dsa_switch *ds,
 				      struct device_node *dn)
 {
-- 
2.17.1

