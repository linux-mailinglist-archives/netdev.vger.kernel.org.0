Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 761DE46FCC
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 13:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfFOLlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 07:41:13 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34356 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbfFOLlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 07:41:13 -0400
Received: by mail-ed1-f65.google.com with SMTP id s49so7722637edb.1
        for <netdev@vger.kernel.org>; Sat, 15 Jun 2019 04:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=9I46tGBbT9+w35m5bJ1ncVHQch6rXn7H0BYLUD7m83g=;
        b=kE4WtVk0ZupsjJ7FT24vcNGaNcUuF66uNeZDhbhwuJFQQWK7cw+4Tb4WqR5ODQ6J44
         8j67UOGPyTTpQjW0U5uGFmfec3NwOEKI6kLv8puA6/LRwVWUOMX7zLjRfL8DTGwVT6T/
         x6ClN1YqlXTCmyOsO5GoLGU91STn/UJr6roR8wFpjyRlwv0M2+PkyBNiHOlzbGgkb14x
         m9dfHCIXBWVVx/4dBoyqjnr+RWgZ2z90vi9cd4VJ+eLMRT2pZ5W9JzfzWobpJgbcwP6/
         S7EwXvnA7cNM4nMTf8A8klngW/ES1sk4ZWyBzgCVKyWu5s9O7kW5YLm3CRu1USdpSvRE
         Qy+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9I46tGBbT9+w35m5bJ1ncVHQch6rXn7H0BYLUD7m83g=;
        b=El1RU1M9ys7mmvnQW1BDrgx51CVhuZFLxiRGxzuichf3OplWDzmMuVv//p7TTQs2xG
         Nu7RrTzqjcARk/uDJmS3rVoaapJ81sP5Rb0O7YKxKEgli3EmseubpHdAXTeRdoyQjgiK
         Elgp4PVy7Y+2XxTdzef3ohMUe8LeC94uRG3G4lGcWPaebO3+1Gr7wqAz7W/IBfmabPFJ
         5C6+cAti1ZZsnZP3B+Q43yqf9JywZpINWFl9n1juPR7X4E57WLDJ1fFOjAQasyscsyql
         Hc+WVjnOL8z1M/AUEhujYTOcmblXeiK7SOvbbZsbTKwy4L0LDMXvIkbZM2nFmhSWtGFQ
         K3NQ==
X-Gm-Message-State: APjAAAXaE0AyitDCm5IjvkKvR49ph/WzqhuoYxG9xw/o1TgeAuCObTTT
        qPuCcioZM9w0e8UgVHaw6Tv1yZ5YZ76RMA==
X-Google-Smtp-Source: APXvYqwvoZiDmf1bysiIEwN+mSwG76z/6m5hss0LlQOXFfoi61EJ91KgPqe1RWmU9DXZI28tA1md+w==
X-Received: by 2002:a17:906:1f48:: with SMTP id d8mr57724775ejk.288.1560598871190;
        Sat, 15 Jun 2019 04:41:11 -0700 (PDT)
Received: from tegmen.arch.suse.de (charybdis-ext.suse.de. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id y18sm1107229ejh.84.2019.06.15.04.41.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 15 Jun 2019 04:41:10 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     stephen@networkplumber.org
Cc:     dledford@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, mkubecek@suse.cz,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH] ipaddress: correctly print a VF hw address in the IPoIB case
Date:   Sat, 15 Jun 2019 13:40:55 +0200
Message-Id: <20190615114056.100808-1-dkirjanov@suse.com>
X-Mailer: git-send-email 2.12.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current code assumes that we print Etheret mac and
that doesn't work in IPoIB case with SRIOV-enabled hardware

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

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 include/uapi/linux/if_infiniband.h | 29 +++++++++++++++++++++++++++
 include/uapi/linux/if_link.h       |  5 +++++
 include/uapi/linux/netdevice.h     |  2 +-
 ip/ipaddress.c                     | 41 +++++++++++++++++++++++++++++++++-----
 4 files changed, 71 insertions(+), 6 deletions(-)
 create mode 100644 include/uapi/linux/if_infiniband.h

diff --git a/include/uapi/linux/if_infiniband.h b/include/uapi/linux/if_infiniband.h
new file mode 100644
index 00000000..7d958475
--- /dev/null
+++ b/include/uapi/linux/if_infiniband.h
@@ -0,0 +1,29 @@
+/*
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available at
+ * <http://www.fsf.org/copyleft/gpl.html>, or the OpenIB.org BSD
+ * license, available in the LICENSE.TXT file accompanying this
+ * software.  These details are also available at
+ * <http://www.openfabrics.org/software_license.htm>.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ * Copyright (c) 2004 Topspin Communications.  All rights reserved.
+ *
+ * $Id$
+ */
+
+#ifndef _LINUX_IF_INFINIBAND_H
+#define _LINUX_IF_INFINIBAND_H
+
+#define INFINIBAND_ALEN		20	/* Octets in IPoIB HW addr	*/
+
+#endif /* _LINUX_IF_INFINIBAND_H */
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index bfe7f9e6..831f1849 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -692,6 +692,7 @@ enum {
 	IFLA_VF_IB_NODE_GUID,	/* VF Infiniband node GUID */
 	IFLA_VF_IB_PORT_GUID,	/* VF Infiniband port GUID */
 	IFLA_VF_VLAN_LIST,	/* nested list of vlans, option for QinQ */
+	IFLA_VF_BROADCAST,	/* VF broadcast */
 	__IFLA_VF_MAX,
 };
 
@@ -702,6 +703,10 @@ struct ifla_vf_mac {
 	__u8 mac[32]; /* MAX_ADDR_LEN */
 };
 
+struct ifla_vf_broadcast {
+       __u8 broadcast[32];
+};
+
 struct ifla_vf_vlan {
 	__u32 vf;
 	__u32 vlan; /* 0 - 4095, 0 disables VLAN filter */
diff --git a/include/uapi/linux/netdevice.h b/include/uapi/linux/netdevice.h
index 86d961c9..aaa48818 100644
--- a/include/uapi/linux/netdevice.h
+++ b/include/uapi/linux/netdevice.h
@@ -30,7 +30,7 @@
 #include <linux/if_ether.h>
 #include <linux/if_packet.h>
 #include <linux/if_link.h>
-
+#include <linux/if_infiniband.h>
 
 #define MAX_ADDR_LEN	32		/* Largest hardware address length */
 
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index b504200b..99e62621 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -349,9 +349,10 @@ static void print_af_spec(FILE *fp, struct rtattr *af_spec_attr)
 
 static void print_vf_stats64(FILE *fp, struct rtattr *vfstats);
 
-static void print_vfinfo(FILE *fp, struct rtattr *vfinfo)
+static void print_vfinfo(struct ifinfomsg *ifi, FILE *fp, struct rtattr *vfinfo)
 {
 	struct ifla_vf_mac *vf_mac;
+	struct ifla_vf_broadcast *vf_broadcast;
 	struct ifla_vf_tx_rate *vf_tx_rate;
 	struct rtattr *vf[IFLA_VF_MAX + 1] = {};
 
@@ -365,13 +366,43 @@ static void print_vfinfo(FILE *fp, struct rtattr *vfinfo)
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
+					ifi->ifi_type == ARPHRD_ETHER ? ETH_ALEN : INFINIBAND_ALEN,
+					ifi->ifi_type,
+					b1, sizeof(b1)));
+
+	if (vf[IFLA_VF_BROADCAST]) {
+		if (ifi->ifi_flags&IFF_POINTOPOINT) {
+			print_string(PRINT_FP, NULL, " peer ", NULL);
+			print_bool(PRINT_JSON,
+					"link_pointtopoint", NULL, true);
+                        } else {
+				print_string(PRINT_FP, NULL, " brd ", NULL);
+                        }
+                        print_color_string(PRINT_ANY,
+                                           COLOR_MAC,
+                                           "broadcast",
+                                           "%s",
+                                           ll_addr_n2a((unsigned char *) &vf_broadcast->broadcast,
+                                                       ifi->ifi_type == ARPHRD_ETHER ? ETH_ALEN : INFINIBAND_ALEN,
+                                                       ifi->ifi_type,
+                                                       b1, sizeof(b1)));
+	}
 
 	if (vf[IFLA_VF_VLAN_LIST]) {
 		struct rtattr *i, *vfvlanlist = vf[IFLA_VF_VLAN_LIST];
@@ -1102,7 +1133,7 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
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

