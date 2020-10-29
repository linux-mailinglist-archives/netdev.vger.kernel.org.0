Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F95129F7FB
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgJ2W2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgJ2W2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 18:28:48 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB35C0613D2;
        Thu, 29 Oct 2020 15:28:48 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id l24so4659080edj.8;
        Thu, 29 Oct 2020 15:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RXMc5OSGpgSuMJ24cCnWO2LiNVxOAy2zAp+LUmQlsfc=;
        b=lj6ynL4ahqFevPNd366kcEIifQfswQRS3HkifRdvYvebwHO07T6Fvzg8KJCyz0hFY5
         FzskV9YvPFCc4Rzk4Oow+VoWKNIExu5l34uFGh/HQBimJfsADE8H6DAgKnsyM4et+2zF
         rWDUcxU9W1c0qHMUYouZCXkZEtQHXwO53rGn/P5oIqtoah3F5ItqWfcXf4eKpmlXdowr
         EU5RW8BrIg6gcYRIX7sN+OQqiNcljGuPGnOc47vk36tzJ1bNs2vJT8K31mDhvJ03dKZB
         GmRV1fW/ZFBW+P8B0WUmQGa1NrMw4Z5zAtjKKkR5uSoX/t3sBF9w9uCyiRx6fdHPgXKV
         gRtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RXMc5OSGpgSuMJ24cCnWO2LiNVxOAy2zAp+LUmQlsfc=;
        b=G8QRZkpn3AXqbeh9byhCLzQCR7uVVfakH+OcR0OgT81X2aBiLci1d+au5yzLXKyoEu
         ZdCUtTo9k8zf5Es+vBJiXtvHWDzrV+kBlo7HeYmF93xhJsYMvpK11moaI2i/Tz+odxXR
         wiuLCdHUqYi4Dul4GjSWlEJ2UY9Z16fw2WgnbM2X7SoIuCtA/LisnYnQsPDv/uAD9xrp
         1jk1x3FH5vvQOyKE16byS1pXr8FXHhdBzPT4UuWJxsXuYaZnLMiwrQjUOdYmvCbw3ECh
         LYD0ilp8cs69ro08MrEf8vazGk8+8KWN8VrgTa/Tw69RBT6Xg+E+pd2Kz3PozymDzIcj
         E09Q==
X-Gm-Message-State: AOAM533B7O3vYLnVF4hEJtcplGogs+BSn73SnTzcxWJ8M/ZDnXpnMD9/
        0y6lpAY8GGe/obCUaXODq8Q=
X-Google-Smtp-Source: ABdhPJxMla1hQY3H5lpvyzRbQs8GPoKs4WJAe/tRW4FScgMjEHEPi0tXWBQovxfJ0xdUmvgh9DqrMw==
X-Received: by 2002:aa7:c490:: with SMTP id m16mr6354399edq.298.1604010527112;
        Thu, 29 Oct 2020 15:28:47 -0700 (PDT)
Received: from localhost.localdomain ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id v6sm2154708ejj.112.2020.10.29.15.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 15:28:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Ahern <dsahern@gmail.com>, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, jiri@mellanox.com,
        idosch@idosch.org
Subject: [PATCH v2 iproute2-next] bridge: add support for L2 multicast groups
Date:   Fri, 30 Oct 2020 00:28:28 +0200
Message-Id: <20201029222828.2149980-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Extend the 'bridge mdb' command for the following syntax:
bridge mdb add dev br0 port swp0 grp 01:02:03:04:05:06 permanent

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
- Removed the const void casts.
- Removed MDB_FLAGS_L2 from the UAPI to be in sync with the latest
  kernel patch:
  https://patchwork.ozlabs.org/project/netdev/patch/20201028233831.610076-1-vladimir.oltean@nxp.com/

 bridge/mdb.c                   | 54 ++++++++++++++++++++++++++--------
 include/uapi/linux/if_bridge.h |  1 +
 2 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/bridge/mdb.c b/bridge/mdb.c
index 4cd7ca762b78..f2723ab122d0 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -149,6 +149,7 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 			    struct nlmsghdr *n, struct rtattr **tb)
 {
 	const void *grp, *src;
+	const char *addr;
 	SPRINT_BUF(abuf);
 	const char *dev;
 	int af;
@@ -156,9 +157,16 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 	if (filter_vlan && e->vid != filter_vlan)
 		return;
 
-	af = e->addr.proto == htons(ETH_P_IP) ? AF_INET : AF_INET6;
-	grp = af == AF_INET ? (const void *)&e->addr.u.ip4 :
-			      (const void *)&e->addr.u.ip6;
+	if (!e->addr.proto) {
+		af = AF_PACKET;
+		grp = &e->addr.u.mac_addr;
+	} else if (e->addr.proto == htons(ETH_P_IP)) {
+		af = AF_INET;
+		grp = &e->addr.u.ip4;
+	} else {
+		af = AF_INET6;
+		grp = &e->addr.u.ip6;
+	}
 	dev = ll_index_to_name(ifindex);
 
 	open_json_object(NULL);
@@ -168,9 +176,14 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
 	print_string(PRINT_ANY, "port", " port %s",
 		     ll_index_to_name(e->ifindex));
 
+	if (af == AF_INET || af == AF_INET6)
+		addr = inet_ntop(af, grp, abuf, sizeof(abuf));
+	else
+		addr = ll_addr_n2a(grp, ETH_ALEN, 0, abuf, sizeof(abuf));
+
 	print_color_string(PRINT_ANY, ifa_family_color(af),
-			    "grp", " grp %s",
-			    inet_ntop(af, grp, abuf, sizeof(abuf)));
+			    "grp", " grp %s", addr);
+
 	if (tb && tb[MDBA_MDB_EATTR_SOURCE]) {
 		src = (const void *)RTA_DATA(tb[MDBA_MDB_EATTR_SOURCE]);
 		print_color_string(PRINT_ANY, ifa_family_color(af),
@@ -440,6 +453,25 @@ static int mdb_show(int argc, char **argv)
 	return 0;
 }
 
+static int mdb_parse_grp(const char *grp, struct br_mdb_entry *e)
+{
+	if (inet_pton(AF_INET, grp, &e->addr.u.ip4)) {
+		e->addr.proto = htons(ETH_P_IP);
+		return 0;
+	}
+	if (inet_pton(AF_INET6, grp, &e->addr.u.ip6)) {
+		e->addr.proto = htons(ETH_P_IPV6);
+		return 0;
+	}
+	if (ll_addr_a2n((char *)e->addr.u.mac_addr, sizeof(e->addr.u.mac_addr),
+			grp) == ETH_ALEN) {
+		e->addr.proto = 0;
+		return 0;
+	}
+
+	return -1;
+}
+
 static int mdb_modify(int cmd, int flags, int argc, char **argv)
 {
 	struct {
@@ -497,14 +529,10 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 	if (!entry.ifindex)
 		return nodev(p);
 
-	if (!inet_pton(AF_INET, grp, &entry.addr.u.ip4)) {
-		if (!inet_pton(AF_INET6, grp, &entry.addr.u.ip6)) {
-			fprintf(stderr, "Invalid address \"%s\"\n", grp);
-			return -1;
-		} else
-			entry.addr.proto = htons(ETH_P_IPV6);
-	} else
-		entry.addr.proto = htons(ETH_P_IP);
+	if (mdb_parse_grp(grp, &entry)) {
+		fprintf(stderr, "Invalid address \"%s\"\n", grp);
+		return -1;
+	}
 
 	entry.vid = vid;
 	addattr_l(&req.n, sizeof(req), MDBA_SET_ENTRY, &entry, sizeof(entry));
diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 69b99901fc5a..db41a5ff34af 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -526,6 +526,7 @@ struct br_mdb_entry {
 		union {
 			__be32	ip4;
 			struct in6_addr ip6;
+			unsigned char mac_addr[ETH_ALEN];
 		} u;
 		__be16		proto;
 	} addr;
-- 
2.25.1

