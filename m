Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63AA82212A0
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 18:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgGOQkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 12:40:53 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:42680 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgGOQkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 12:40:35 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06FGeTDp003868;
        Wed, 15 Jul 2020 11:40:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594831229;
        bh=ojXEfYtuih4BAfSq6WWG368UipUr0VPWWjTMBz+cdiE=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=pZ6J1yfQ6mO7eAp/5Xtxw8wR0DdzlhbUvi2w4u6appKixMZjhi5L15FF7YhiipUKG
         YlnMexbvjcCnHLQpxz0gMyTf3fXBwzSnZeCsG321Uw9HQBGNIMS8++nldYjYdRjFBJ
         6Vr69GpSD7D6a/3F/DHfWwaKpQF57FKTozMCkxZA=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06FGeTDF031949;
        Wed, 15 Jul 2020 11:40:29 -0500
Received: from DLEE102.ent.ti.com (157.170.170.32) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 15
 Jul 2020 11:40:29 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 15 Jul 2020 11:40:29 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06FGeCvi081717;
        Wed, 15 Jul 2020 11:40:28 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>,
        <vinicius.gomes@intel.com>
Subject: [net-next iproute2 PATCH v2 1/2] iplink: hsr: add support for creating PRP device similar to HSR
Date:   Wed, 15 Jul 2020 12:40:11 -0400
Message-ID: <20200715164012.1222-11-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715164012.1222-1-m-karicheri2@ti.com>
References: <20200715164012.1222-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enhances the iplink command to add a proto parameters to
create PRP device/interface similar to HSR. Both protocols are
quite similar and requires a pair of Ethernet interfaces. So re-use
the existing HSR iplink command to create PRP device/interface as
well. Use proto parameter to differentiate the two protocols.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 include/uapi/linux/if_link.h | 12 +++++++++++-
 ip/iplink_hsr.c              | 19 +++++++++++++++++--
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index a8901a39a345..fa2e3f642deb 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -904,7 +904,14 @@ enum {
 #define IFLA_IPOIB_MAX (__IFLA_IPOIB_MAX - 1)
 
 
-/* HSR section */
+/* HSR/PRP section, both uses same interface */
+
+/* Different redundancy protocols for hsr device */
+enum {
+	HSR_PROTOCOL_HSR,
+	HSR_PROTOCOL_PRP,
+	HSR_PROTOCOL_MAX,
+};
 
 enum {
 	IFLA_HSR_UNSPEC,
@@ -914,6 +921,9 @@ enum {
 	IFLA_HSR_SUPERVISION_ADDR,	/* Supervision frame multicast addr */
 	IFLA_HSR_SEQ_NR,
 	IFLA_HSR_VERSION,		/* HSR version */
+	IFLA_HSR_PROTOCOL,		/* Indicate different protocol than
+					 * HSR. For example PRP.
+					 */
 	__IFLA_HSR_MAX,
 };
 
diff --git a/ip/iplink_hsr.c b/ip/iplink_hsr.c
index 7d9167d4e6a3..6ea138a23cbc 100644
--- a/ip/iplink_hsr.c
+++ b/ip/iplink_hsr.c
@@ -25,7 +25,7 @@ static void print_usage(FILE *f)
 {
 	fprintf(f,
 		"Usage:\tip link add name NAME type hsr slave1 SLAVE1-IF slave2 SLAVE2-IF\n"
-		"\t[ supervision ADDR-BYTE ] [version VERSION]\n"
+		"\t[ supervision ADDR-BYTE ] [version VERSION] [proto PROTOCOL]\n"
 		"\n"
 		"NAME\n"
 		"	name of new hsr device (e.g. hsr0)\n"
@@ -35,7 +35,9 @@ static void print_usage(FILE *f)
 		"	0-255; the last byte of the multicast address used for HSR supervision\n"
 		"	frames (default = 0)\n"
 		"VERSION\n"
-		"	0,1; the protocol version to be used. (default = 0)\n");
+		"	0,1; the protocol version to be used. (default = 0)\n"
+		"PROTOCOL\n"
+		"	0 - HSR, 1 - PRP. (default = 0 - HSR)\n");
 }
 
 static void usage(void)
@@ -49,6 +51,7 @@ static int hsr_parse_opt(struct link_util *lu, int argc, char **argv,
 	int ifindex;
 	unsigned char multicast_spec;
 	unsigned char protocol_version;
+	unsigned char protocol = HSR_PROTOCOL_HSR;
 
 	while (argc > 0) {
 		if (matches(*argv, "supervision") == 0) {
@@ -64,6 +67,13 @@ static int hsr_parse_opt(struct link_util *lu, int argc, char **argv,
 				invarg("version is invalid", *argv);
 			addattr_l(n, 1024, IFLA_HSR_VERSION,
 				  &protocol_version, 1);
+		} else if (matches(*argv, "proto") == 0) {
+			NEXT_ARG();
+			if (!(get_u8(&protocol, *argv, 0) == HSR_PROTOCOL_HSR ||
+			      get_u8(&protocol, *argv, 0) == HSR_PROTOCOL_PRP))
+				invarg("protocol is invalid", *argv);
+			addattr_l(n, 1024, IFLA_HSR_PROTOCOL,
+				  &protocol, 1);
 		} else if (matches(*argv, "slave1") == 0) {
 			NEXT_ARG();
 			ifindex = ll_name_to_index(*argv);
@@ -140,6 +150,11 @@ static void hsr_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 					 RTA_PAYLOAD(tb[IFLA_HSR_SUPERVISION_ADDR]),
 					 ARPHRD_VOID,
 					 b1, sizeof(b1)));
+	if (tb[IFLA_HSR_PROTOCOL])
+		print_int(PRINT_ANY,
+			  "proto",
+			  "proto %d ",
+			  rta_getattr_u8(tb[IFLA_HSR_PROTOCOL]));
 }
 
 static void hsr_print_help(struct link_util *lu, int argc, char **argv,
-- 
2.17.1

