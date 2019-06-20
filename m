Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6369E4CA33
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 11:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731398AbfFTJDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 05:03:01 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41072 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731250AbfFTJDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 05:03:00 -0400
Received: by mail-ed1-f67.google.com with SMTP id p15so3586664eds.8
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 02:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=/HYBIY590cdJS2RAEvrEQw5uxHga9dzdyPJdjb+NVxA=;
        b=nQolUwC1kVi2ylKBbIliVjJyQfQ3saSQqmmP8refzxTVTGQ+lBwMto3JVbl6zUrWk5
         3dIhoRSfwzQXiseDJfiNc/33qeci4+glMBm6rdbrrTLxx0K2aBu2ZfjQwAPk5WymRpj3
         jnmzpI4ZXdXG/wE8JvDm7PHSFFScsT8yPnOZeGm05yN4HTanGGxslqsbE4jqQCL5TgQm
         sRdp00j+KROEgCWBQH3LKG4WvRMxQ2Bp///zNVE8L6S1P3qjAV+Z/vBmrxXl1RIu1q7Q
         A9cCUdjm1uQPVpq35UzxQpbOfUJjj3tiGFMGcLO7FmJCYuaHxgEB+F+UzSFXPOuMFyHJ
         XCrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/HYBIY590cdJS2RAEvrEQw5uxHga9dzdyPJdjb+NVxA=;
        b=bBgmRgKopcikFnxPbnNCQof///hr5a5iiO0XrsJFXybnPfEYPengS5WPov8g8ppZYN
         1YY/r2AZBF8pn/jC06pLlUIJrsiHp6omuwD9Pq90VaDA+HEYUnnSUlVdpOEdA4AHWFRC
         lnBYyp30Uyfnb/ZU/8btkXgNqrs/zRryEIkLD/mVuZdFXVgAjLkOKQ6M8Qgzu3PBRThf
         rrfwXBhOdqzb4nBHRXqZlcyDzeW44GAz64f8Dlnq7wIxYY7nk7SspiGTbQgRI8ewZVPr
         bbnUgx2/s3a54gi5BCcthRMPPjbgP3t9I3Mv23SkUqvAKrK24js1KptZdCtmmyJWc8dl
         6s7g==
X-Gm-Message-State: APjAAAV6NSVcuf360gxtJC/QcfYskEok4AQBwWAY61FcVKBwNmUsvCJq
        Tjpp+Ow5k+8P5xWe/vrPTZLTiOmDQrtGDQ==
X-Google-Smtp-Source: APXvYqywpfElHlweszHIQoqj/S4P9scQLle01LSqJ18yONUE9Sx+eaXek7c9vGHJDX7DbJBMoIsulw==
X-Received: by 2002:a50:be01:: with SMTP id a1mr20445837edi.287.1561021377345;
        Thu, 20 Jun 2019 02:02:57 -0700 (PDT)
Received: from tegmen.arch.suse.de (nat.nue.novell.com. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id i18sm3765803ede.65.2019.06.20.02.02.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 02:02:56 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dledford@redhat.com, mkubecek@suse.cz,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH iproute2-next v2 1/2] ipaddress: correctly print a VF hw address in the IPoIB case
Date:   Thu, 20 Jun 2019 11:02:48 +0200
Message-Id: <20190620090249.106704-1-dkirjanov@suse.com>
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

