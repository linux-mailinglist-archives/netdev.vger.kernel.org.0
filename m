Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8964BAED
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 16:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbfFSOOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 10:14:31 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39765 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbfFSOOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 10:14:31 -0400
Received: by mail-ed1-f65.google.com with SMTP id m10so27466522edv.6
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 07:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=/HYBIY590cdJS2RAEvrEQw5uxHga9dzdyPJdjb+NVxA=;
        b=uLNntrvtIfGirEO8AEO56wnzF/PzZl3RwGkdiKRQ4CxeRIqzICSRYtlcRe3fThx1oh
         2s6Xs7lYlU8sUXHgf31IhPkL0TLN7uCIXOw1FrNhBQsThyYCf8nMJOOrT79jw+/S+ohA
         SaeYMgr6I2jn0rzK1uv2vqWHFwd8VJX0YpLkQ908yoLfeJwEiLSqC2CMqjrJaRKYr7lq
         04Tf7On3pNILGlQdazLocV3ZYR6EDGtz+YDoa1Uq5yxQiyWr0+RRbnmnRtMFL4Ug6sjy
         s1M4/Q2us7xv/hZ9g+iav6SyYZsIj6g5a5t1BQSXEDdxmgeJUoBp3d0pvQ63Mxg9T3Vh
         UNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/HYBIY590cdJS2RAEvrEQw5uxHga9dzdyPJdjb+NVxA=;
        b=jgteU5wsZFlPa3dGd61WF1yxwrvqECXgKtZjIWh1R2IkZ4KW4/OfNVl+fO+GCPPwSd
         ONgyWq7jXzBB6bUJHR0BFu8ARD2ojf0t9iuN1nQTzoUKm9IgrAg+uRL7d52uTBGfDNJ5
         NUk6q/oIeg9RMKc3Yoy4DN5e1+jkjDqZFd1v59s+1FPXNG3YsjCO0JNRXzeABJqM/QPE
         yqmdFy+HxjURPOkVxPLGdkU1z+QSTaT9aSU3PQrVFs7/B/IE3fzQto9tgHOWA9ImMrxR
         MDm7sGzMmiZbaMfE0iH7XSFrJDe6SLrNNrYZK+Lkj8+yczwg28u3Kh0ksTc/g/v/ctsV
         VTCQ==
X-Gm-Message-State: APjAAAUkFuxyjRFX+7zo8ay/V7yZpMZUtrMum8sMb/MmGxLgPP6vvOjn
        1X7FYnSOYUOD0/mmA2XugcmOVg==
X-Google-Smtp-Source: APXvYqwY3G1QoJMH8Xvq5yGwhbIHOhEE0hqZprEzI2ce1zei9N5VFz3/eOz7/8RokfCjbt7qVsQoYQ==
X-Received: by 2002:a17:906:4950:: with SMTP id f16mr22289578ejt.259.1560953668393;
        Wed, 19 Jun 2019 07:14:28 -0700 (PDT)
Received: from tegmen.arch.suse.de (nat.nue.novell.com. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id y20sm49633ejj.75.2019.06.19.07.14.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 07:14:27 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dledford@redhat.com, mkubecek@suse.cz,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH iproute2 v2 1/2] ipaddress: correctly print a VF hw address in the IPoIB case
Date:   Wed, 19 Jun 2019 16:14:13 +0200
Message-Id: <20190619141414.4242-1-dkirjanov@suse.com>
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

v1->v2: updated kernel headers to uapi commit

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 ip/ipaddress.c | 42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index b504200b..13ad76dd 100644
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
 
@@ -365,13 +367,43 @@ static void print_vfinfo(FILE *fp, struct rtattr *vfinfo)
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
@@ -1102,7 +1134,7 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
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

