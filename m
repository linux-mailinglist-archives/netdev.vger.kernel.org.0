Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00913B6AB5
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 00:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238092AbhF1WD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 18:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236827AbhF1WDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 18:03:12 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1210CC061767
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:45 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id w13so22291519edc.0
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3CRcEaN0Bg+xQgzR5B59tpxXfhAiXab1BE8fXxf/L7k=;
        b=jn5xJmiNdoN6KAjqGkM51cGC79topffl8hOvskITt+5O844KhoStE2l7zyPxmFRtiQ
         CoW0h4EMPCmh+zi/dP5sbSbrzFQMCowQ74tti3WXGMhIYKt7SLuRMtJHRk2wcliIE+RC
         T/lAzRnZkjolajVR5qYNG22c0J/To2/t33gpUcdniKpzdn7WuXdOxQlpEX8nGjax+i0G
         rKyW9rBp+fwoUnt9YL7MMT0H1pEQPEMUatdjoPG5qkuBo8f1GwFUvzCxcm0x3bBUhLAk
         sXDrGBQjEAGSaQo4pjVU7CRFdQdgSblpLLvgl6MTpszVGb13vuWPa84bpQTbIiDmUNPV
         QBNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3CRcEaN0Bg+xQgzR5B59tpxXfhAiXab1BE8fXxf/L7k=;
        b=bkhnK1fGrvscOK201WzIP0W5F44vdC9iHhy0cfEEuZVOY+hSuR44nvs6ve18ZwAlRD
         9f1sAg84Q7GjWdKw9lfUGKWwqLSFwGmJhBLEKBQwXQ5kBlol9RCL/Ap0XjgFkq1Zsh30
         RZMz5tv4z+6txRWysOrEW396nTYmqauS1Xmt7+TAE4aoyucHqNU2tZulTRhudNAsV3VO
         krIPuTbW+sKvg9UyGyaOfHf4kNmUwLe56zSXIw8uCTnb6cdT/D8VD6ZLpJ6l8tJ4oOMD
         bcA/B6eHm2O5PaoeePmgd3qFROC28jGfU+LenaEeLh0MzsV/aZtCsJH4ps/Cc+LHVyy7
         tGcg==
X-Gm-Message-State: AOAM530QQe6l39OH5Xgp6K52A9/oLa4Hump0n/Is4KvzxskZ6k0AedlP
        Bqvq+PMz7LJl7WjWy5X7OfXYonDYX2Y=
X-Google-Smtp-Source: ABdhPJxdNBYJQRyMh6W+ppR+Cj7VhHugNiu+ulM1BZAcli/K8CWkqC3rpqmffSX0wUnDwlcYdeCFbg==
X-Received: by 2002:a05:6402:27d1:: with SMTP id c17mr35672719ede.17.1624917643557;
        Mon, 28 Jun 2021 15:00:43 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id dn7sm10146615edb.29.2021.06.28.15.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 15:00:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 09/14] net: dsa: install the host MDB and FDB entries in the master's RX filter
Date:   Tue, 29 Jun 2021 01:00:06 +0300
Message-Id: <20210628220011.1910096-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628220011.1910096-1-olteanv@gmail.com>
References: <20210628220011.1910096-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

If the DSA master implements strict address filtering, then the unicast
and multicast addresses kept by the DSA CPU ports should be synchronized
with the address lists of the DSA master.

Note that we want the synchronization of the master's address lists even
if the DSA switch doesn't support unicast/multicast database operations,
on the premises that the packets will be flooded to the CPU in that
case, and we should still instruct the master to receive them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 1b80e0fbdfaa..255172a8599a 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -655,8 +655,14 @@ int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		.addr = addr,
 		.vid = vid,
 	};
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	int err;
+
+	err = dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_ADD, &info);
+	if (err)
+		return err;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_ADD, &info);
+	return dev_uc_add(cpu_dp->master, addr);
 }
 
 int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
@@ -668,8 +674,14 @@ int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		.addr = addr,
 		.vid = vid,
 	};
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	int err;
+
+	err = dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
+	if (err)
+		return err;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
+	return dev_uc_del(cpu_dp->master, addr);
 }
 
 int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data)
@@ -715,8 +727,14 @@ int dsa_port_host_mdb_add(const struct dsa_port *dp,
 		.port = dp->index,
 		.mdb = mdb,
 	};
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	int err;
+
+	err = dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_ADD, &info);
+	if (err)
+		return err;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_ADD, &info);
+	return dev_mc_add(cpu_dp->master, mdb->addr);
 }
 
 int dsa_port_host_mdb_del(const struct dsa_port *dp,
@@ -727,8 +745,14 @@ int dsa_port_host_mdb_del(const struct dsa_port *dp,
 		.port = dp->index,
 		.mdb = mdb,
 	};
+	struct dsa_port *cpu_dp = dp->cpu_dp;
+	int err;
+
+	err = dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_DEL, &info);
+	if (err)
+		return err;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_DEL, &info);
+	return dev_mc_del(cpu_dp->master, mdb->addr);
 }
 
 int dsa_port_vlan_add(struct dsa_port *dp,
-- 
2.25.1

