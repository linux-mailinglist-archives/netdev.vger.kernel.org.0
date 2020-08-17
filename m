Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B20F2478A9
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 23:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgHQVSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 17:18:10 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:37908 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbgHQVSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 17:18:06 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07HLHfDB072302;
        Mon, 17 Aug 2020 16:17:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1597699061;
        bh=9391HzA9X31BkYsn5De/TCgEsqAHK3DrCsE1IzlxOYg=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=vEq1Yo5uRye1ISLR09m+gltJLPIoVcVi/Hh49LtnUBHWzEJDXGyACOCGXtsR+U97F
         WIxoH1XDnchosBCLWDkRM+9m+ZkcIXgDqkb+aegHK2T5mdnhpjUuUP79O1aWPPN6qY
         f0oBR3hGalqcn+wAclIlzw/7RLAqsJRCUXNCKq3c=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07HLHf2Z083010
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 16:17:41 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 17
 Aug 2020 16:17:41 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 17 Aug 2020 16:17:41 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07HLHb8S073931;
        Mon, 17 Aug 2020 16:17:40 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <vinicius.gomes@intel.com>,
        <stephen@networkplumber.org>
Subject: [PATCH iproute2 v5 1/2] iplink: hsr: add support for creating PRP device similar to HSR
Date:   Mon, 17 Aug 2020 17:17:36 -0400
Message-ID: <20200817211737.576-2-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817211737.576-1-m-karicheri2@ti.com>
References: <20200817211737.576-1-m-karicheri2@ti.com>
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
 ip/iplink_hsr.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/ip/iplink_hsr.c b/ip/iplink_hsr.c
index 7d9167d4e6a3..da2d03d4bcbc 100644
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
@@ -140,6 +150,9 @@ static void hsr_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 					 RTA_PAYLOAD(tb[IFLA_HSR_SUPERVISION_ADDR]),
 					 ARPHRD_VOID,
 					 b1, sizeof(b1)));
+	if (tb[IFLA_HSR_PROTOCOL])
+		print_hhu(PRINT_ANY, "proto", "proto %hhu ",
+			  rta_getattr_u8(tb[IFLA_HSR_PROTOCOL]));
 }
 
 static void hsr_print_help(struct link_util *lu, int argc, char **argv,
-- 
2.17.1

