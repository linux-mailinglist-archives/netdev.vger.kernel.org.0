Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 109214F7B2
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 20:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfFVSAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 14:00:48 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:38806 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfFVSAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 14:00:47 -0400
Received: by mail-ed1-f68.google.com with SMTP id r12so15022293edo.5
        for <netdev@vger.kernel.org>; Sat, 22 Jun 2019 11:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=+0dbgQdh1alJJ8L/rg8gILoxp7pGVLPVx2FbN8k3ou0=;
        b=W6ocLpkY1BE3FvpAj/Jx2f6VWeoA/iUUTN/X2eIOvl27L6nCgo++0PqLtJy698W++x
         g3jUlIBbvG1iFb6WM/8u36Es4C/l3yMRdZEHXifHH/j2EV9ls5hW7nFi8sm/D+RoU8qQ
         sqW2j/YNTpMigadivf4KmQzFYQ6bqu16DMLJinQOswPpTY5woTM9ksjRpgYBRRfixz6S
         WFDWbxA9vrUi+2Zc8RIN+Un9A4vb8CZbXmqhIGxstbAnzMa8ASWYP0iwDzs+OyAAiIDo
         OaTsZtABQ5Tqkbxl8ttqxE2xIiBRTreYZyqytnmWURrPmbdV+L2nuPCOiily5NTSSqOQ
         cM6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+0dbgQdh1alJJ8L/rg8gILoxp7pGVLPVx2FbN8k3ou0=;
        b=IKu8SlZ+wkr4akmNARXysqOGbU7eAZk63pEbTwpTBT+ur89QDiozVKulOyZWI0wus+
         IIceBSXNWRSF2fIaTpRUPzQTXc0E7W/iFRhhD+hN9pyCBmIMMS2XFuJDM8ygPOeXy/0n
         9tfLho6Hi3Pe1EeJ45DwiA2JaJc3GvW7wXLmqXPcebehW5PK3ummrevwRqU0HCfyfPIh
         ijHBxiUzsltGzniLIsid7XnBxLfETu7ZqtPKdr5JmxnFHRxlEVArlNxkRchAwtsv6g/q
         Fdo7sV2PZxNPTZZbIuVNtjU/ZG19rguiIG3Pll3JHuyZ51JhEH/qKZE/F/J3dJrvS9aC
         IEuA==
X-Gm-Message-State: APjAAAX5dIJNlxFhK9tcQSMMbNmYidfvbYe3UKJDHWGFHclAKU9sPhyd
        jsnJp4QW/X5cGeMeoICFtTGpXQ==
X-Google-Smtp-Source: APXvYqwXlufYaLKyjX9Ki5Ml6RroaUqNe7GnNmZwa5YLKqKaBVznDoxRw1c5StvkWEmTouBHjnVOuQ==
X-Received: by 2002:a50:86dc:: with SMTP id 28mr126658112edu.132.1561226445983;
        Sat, 22 Jun 2019 11:00:45 -0700 (PDT)
Received: from tegmen.arch.suse.de (charybdis-ext.suse.de. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id a8sm1955560edt.56.2019.06.22.11.00.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 11:00:45 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     stephen@networkplumber.org, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dledford@redhat.com, mkubecek@suse.cz,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH iproute2-next v3 1/2] ipaddress: correctly print a VF hw address in the IPoIB case
Date:   Sat, 22 Jun 2019 20:00:34 +0200
Message-Id: <20190622180035.40245-1-dkirjanov@suse.com>
X-Mailer: git-send-email 2.12.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current code assumes that we print ethernet mac and
that doesn't work in the IPoIB case with SRIOV-enabled hardware

Before:
11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
state UP mode DEFAULT group default qlen 256
        link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
        vf 0 MAC 14:80:00:00:66:fe, spoof checking off, link-state disable,
    trust off, query_rss off
    ...

After:
11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
state UP mode DEFAULT group default qlen 256
        link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
        vf 0     link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff, spoof
checking off, link-state disable, trust off, query_rss off

v1->v2: updated kernel headers to uapi commit
v2->v3: fixed alignment

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 ip/ipaddress.c | 44 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index b504200b..52078675 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -26,6 +26,7 @@
 
 #include <linux/netdevice.h>
 #include <linux/if_arp.h>
+#include <linux/if_infiniband.h>
 #include <linux/sockios.h>
 #include <linux/net_namespace.h>
 
@@ -349,9 +350,10 @@ static void print_af_spec(FILE *fp, struct rtattr *af_spec_attr)
 
 static void print_vf_stats64(FILE *fp, struct rtattr *vfstats);
 
-static void print_vfinfo(FILE *fp, struct rtattr *vfinfo)
+static void print_vfinfo(struct ifinfomsg *ifi, FILE *fp, struct rtattr *vfinfo)
 {
 	struct ifla_vf_mac *vf_mac;
+	struct ifla_vf_broadcast *vf_broadcast;
 	struct ifla_vf_tx_rate *vf_tx_rate;
 	struct rtattr *vf[IFLA_VF_MAX + 1] = {};
 
@@ -365,13 +367,45 @@ static void print_vfinfo(FILE *fp, struct rtattr *vfinfo)
 	parse_rtattr_nested(vf, IFLA_VF_MAX, vfinfo);
 
 	vf_mac = RTA_DATA(vf[IFLA_VF_MAC]);
+	vf_broadcast = RTA_DATA(vf[IFLA_VF_BROADCAST]);
 	vf_tx_rate = RTA_DATA(vf[IFLA_VF_TX_RATE]);
 
 	print_string(PRINT_FP, NULL, "%s    ", _SL_);
 	print_int(PRINT_ANY, "vf", "vf %d ", vf_mac->vf);
-	print_string(PRINT_ANY, "mac", "MAC %s",
-		     ll_addr_n2a((unsigned char *) &vf_mac->mac,
-				 ETH_ALEN, 0, b1, sizeof(b1)));
+
+	print_string(PRINT_ANY,
+			"link_type",
+			"    link/%s ",
+			ll_type_n2a(ifi->ifi_type, b1, sizeof(b1)));
+
+	print_color_string(PRINT_ANY,
+				COLOR_MAC,
+				"address",
+				"%s",
+				ll_addr_n2a((unsigned char *) &vf_mac->mac,
+					ifi->ifi_type == ARPHRD_ETHER ?
+					ETH_ALEN : INFINIBAND_ALEN,
+					ifi->ifi_type,
+					b1, sizeof(b1)));
+
+	if (vf[IFLA_VF_BROADCAST]) {
+		if (ifi->ifi_flags&IFF_POINTOPOINT) {
+			print_string(PRINT_FP, NULL, " peer ", NULL);
+			print_bool(PRINT_JSON,
+					"link_pointtopoint", NULL, true);
+		} else
+			print_string(PRINT_FP, NULL, " brd ", NULL);
+
+		print_color_string(PRINT_ANY,
+				COLOR_MAC,
+				"broadcast",
+				"%s",
+				ll_addr_n2a((unsigned char *) &vf_broadcast->broadcast,
+					ifi->ifi_type == ARPHRD_ETHER ?
+					ETH_ALEN : INFINIBAND_ALEN,
+					ifi->ifi_type,
+					b1, sizeof(b1)));
+	}
 
 	if (vf[IFLA_VF_VLAN_LIST]) {
 		struct rtattr *i, *vfvlanlist = vf[IFLA_VF_VLAN_LIST];
@@ -1102,7 +1136,7 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 		open_json_array(PRINT_JSON, "vfinfo_list");
 		for (i = RTA_DATA(vflist); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
 			open_json_object(NULL);
-			print_vfinfo(fp, i);
+			print_vfinfo(ifi, fp, i);
 			close_json_object();
 		}
 		close_json_array(PRINT_JSON, NULL);
-- 
2.12.3

