Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A91EF1B4
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 01:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387467AbfKEANo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 19:13:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48916 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387394AbfKEANn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 19:13:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Hix89aUf4yaEakvYxH/lKvK5AuObmCni77WxlAcvG8s=; b=iXnh5TlfV5pcCFJqv1GRKty7BG
        ujfRXnW0W4JBUrrDqBUIUXPTt4HZ2G4VqvwjuBrmarH5MmqbbufoXrUcFEozoDjfnf8rY8hqtDfbk
        akCbU4exG2A1FlyzLrPqmvVcqc3lxainFj9VB7q00n19cml28+D8zL/p9FE+b9sb1kZI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iRmTD-0007Hq-1f; Tue, 05 Nov 2019 01:13:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>, jiri@mellanox.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 1/5] net: dsa: Add support for devlink resources
Date:   Tue,  5 Nov 2019 01:12:57 +0100
Message-Id: <20191105001301.27966-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191105001301.27966-1-andrew@lunn.ch>
References: <20191105001301.27966-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add wrappers around the devlink resource API, so that DSA drivers can
register and unregister devlink resources.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/net/dsa.h | 16 ++++++++++++++++
 net/dsa/dsa.c     | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index e4c697b95c70..9507611a41f0 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -586,6 +586,22 @@ int dsa_devlink_params_register(struct dsa_switch *ds,
 void dsa_devlink_params_unregister(struct dsa_switch *ds,
 				   const struct devlink_param *params,
 				   size_t params_count);
+int dsa_devlink_resource_register(struct dsa_switch *ds,
+				  const char *resource_name,
+				  u64 resource_size,
+				  u64 resource_id,
+				  u64 parent_resource_id,
+				  const struct devlink_resource_size_params *size_params);
+
+void dsa_devlink_resources_unregister(struct dsa_switch *ds);
+
+void dsa_devlink_resource_occ_get_register(struct dsa_switch *ds,
+					   u64 resource_id,
+					   devlink_resource_occ_get_t *occ_get,
+					   void *occ_get_priv);
+void dsa_devlink_resource_occ_get_unregister(struct dsa_switch *ds,
+					     u64 resource_id);
+
 struct dsa_devlink_priv {
 	struct dsa_switch *ds;
 };
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index db1c1c7e40e9..17281fec710c 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -379,6 +379,43 @@ void dsa_devlink_params_unregister(struct dsa_switch *ds,
 }
 EXPORT_SYMBOL_GPL(dsa_devlink_params_unregister);
 
+int dsa_devlink_resource_register(struct dsa_switch *ds,
+				  const char *resource_name,
+				  u64 resource_size,
+				  u64 resource_id,
+				  u64 parent_resource_id,
+				  const struct devlink_resource_size_params *size_params)
+{
+	return devlink_resource_register(ds->devlink, resource_name,
+					 resource_size, resource_id,
+					 parent_resource_id,
+					 size_params);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_resource_register);
+
+void dsa_devlink_resources_unregister(struct dsa_switch *ds)
+{
+	devlink_resources_unregister(ds->devlink, NULL);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_resources_unregister);
+
+void dsa_devlink_resource_occ_get_register(struct dsa_switch *ds,
+					   u64 resource_id,
+					   devlink_resource_occ_get_t *occ_get,
+					   void *occ_get_priv)
+{
+	return devlink_resource_occ_get_register(ds->devlink, resource_id,
+						 occ_get, occ_get_priv);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_resource_occ_get_register);
+
+void dsa_devlink_resource_occ_get_unregister(struct dsa_switch *ds,
+					     u64 resource_id)
+{
+	devlink_resource_occ_get_unregister(ds->devlink, resource_id);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_resource_occ_get_unregister);
+
 static int __init dsa_init_module(void)
 {
 	int rc;
-- 
2.23.0

