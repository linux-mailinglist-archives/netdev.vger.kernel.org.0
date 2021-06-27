Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645753B53A1
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 16:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhF0ONE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 10:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbhF0OM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 10:12:58 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2B4C0617AE
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:34 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id r7so21173609edv.12
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3CRcEaN0Bg+xQgzR5B59tpxXfhAiXab1BE8fXxf/L7k=;
        b=eardDC0e6zliFN/Rs89L0ruYIPL/eHgpUOCM4SqWAca3nYrsBQtMY1WuqOVev+BRg5
         RFiNkygg7dxquBk6ubHIS26xib6bnfHKHuCkJW4OrsX151QiXnvnPFNDPjrzRsJPIDCV
         sRrf3uSIf2g1Z6JLcI7s4mO00mdwouZoDx/h9UiX91rD+4PzyqnGEtszHf/F9iNpydo0
         eVJskv5kG/4hdPArC1SBC5JLdv0XOXplYsE05L6gjk/iPbQ8od4ZZSsTqh4dlujNBz+v
         DdU0cH64gSGcStCuRjYiLmzN+6hW4apVWOrGk+7wqA91OO0ZlInwKwk3qsO3s51QLn6t
         d+lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3CRcEaN0Bg+xQgzR5B59tpxXfhAiXab1BE8fXxf/L7k=;
        b=tEbC69stVx3GNfJVFx4aUiIclnlCWtJeLWYveGOoR3vWPbX4ODSGwlR6aoFMoqag4N
         /E5mNBrnbqcQKosWXJDtnWK4EERXmQvpb89KscvFLyDqvHgdelKdLMXRiKM98bRr3XeX
         MwhgIo4synwXsqFZe5KXYYTwo+BmYsQe6OMhtRjVaVP620mJ5+GEgQSwCgZ3QxiPJSaD
         6eDILq9NNhilsyHeY1IFzM7z7zffQGKhP7az751mZnfsIKA9pJaK30C0BWeWqFzCOdoi
         K5++tMpW3S1yE5pZVuG8rp5PAWGk8OOiRB/kiqizbh3dGp+I8uNw84RANYI7cL0HniAD
         m/0Q==
X-Gm-Message-State: AOAM531iupsCI/6Np7GRmu5MjnwZEFQgUCNbXqHW/vH7HY/0yjvMLXGY
        pHVy6huPH49LXrEWQgoTbUl2WJwd0xc=
X-Google-Smtp-Source: ABdhPJxNs44TQt7cfd37bYUZofm/iijCIRAaR1qMFwhavisz/uN/kH+mkluaigxm23Z2KPhkb5tlvw==
X-Received: by 2002:a05:6402:30a8:: with SMTP id df8mr27301507edb.7.1624803032068;
        Sun, 27 Jun 2021 07:10:32 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7857389edu.49.2021.06.27.07.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 07:10:31 -0700 (PDT)
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
Subject: [RFC PATCH v3 net-next 10/15] net: dsa: install the host MDB and FDB entries in the master's RX filter
Date:   Sun, 27 Jun 2021 17:10:08 +0300
Message-Id: <20210627141013.1273942-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627141013.1273942-1-olteanv@gmail.com>
References: <20210627141013.1273942-1-olteanv@gmail.com>
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

