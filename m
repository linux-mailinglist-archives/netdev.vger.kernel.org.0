Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8597717745B
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 11:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgCCKg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 05:36:28 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:54343 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728506AbgCCKg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 05:36:28 -0500
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id BF5844000E;
        Tue,  3 Mar 2020 10:36:26 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     dsahern@gmail.com, sd@queasysnail.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, netdev@vger.kernel.org
Subject: [PATCH iproute2-next v2 1/4] macsec: report the offloading mode currently selected
Date:   Tue,  3 Mar 2020 11:36:16 +0100
Message-Id: <20200303103619.818985-2-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303103619.818985-1-antoine.tenart@bootlin.com>
References: <20200303103619.818985-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support to report the MACsec offloading mode currently
being enabled, which as of now can either be 'off' or 'phy'. This
information is reported through the `ip macsec show` command:

  # ip macsec show
  18: macsec0: protect on validate strict sc off sa off encrypt on send_sci on end_station off scb off replay off
      cipher suite: GCM-AES-128, using ICV length 16
      TXSC: 3e5035b67c860001 on SA 0
          0: PN 1, state on, key 00000000000000000000000000000000
      RXSC: b4969112700f0001, state on
          0: PN 1, state on, key 01000000000000000000000000000000
      offload: phy
  19: macsec1: protect on validate strict sc off sa off encrypt on send_sci on end_station off scb off replay off
      cipher suite: GCM-AES-128, using ICV length 16
      TXSC: 3e5035b67c880001 on SA 0
          1: PN 1, state on, key 00000000000000000000000000000000
      RXSC: b4969112700f0001, state on
          1: PN 1, state on, key 01000000000000000000000000000000
      offload: off

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 ip/ipmacsec.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
index ad6ad7d6b79f..4327c796aa1f 100644
--- a/ip/ipmacsec.c
+++ b/ip/ipmacsec.c
@@ -31,6 +31,11 @@ static const char * const validate_str[] = {
 	[MACSEC_VALIDATE_STRICT] = "strict",
 };
 
+static const char * const offload_str[] = {
+	[MACSEC_OFFLOAD_OFF] = "off",
+	[MACSEC_OFFLOAD_PHY] = "phy",
+};
+
 struct sci {
 	__u64 sci;
 	__u16 port;
@@ -605,6 +610,14 @@ static const char *cs_id_to_name(__u64 cid)
 	}
 }
 
+static const char *offload_to_str(__u8 offload)
+{
+	if (offload >= ARRAY_SIZE(offload_str))
+		return "(unknown)";
+
+	return offload_str[offload];
+}
+
 static void print_attrs(struct rtattr *attrs[])
 {
 	print_flag(attrs, "protect", MACSEC_SECY_ATTR_PROTECT);
@@ -997,6 +1010,19 @@ static int process(struct nlmsghdr *n, void *arg)
 	if (attrs[MACSEC_ATTR_RXSC_LIST])
 		print_rxsc_list(attrs[MACSEC_ATTR_RXSC_LIST]);
 
+	if (attrs[MACSEC_ATTR_OFFLOAD]) {
+		struct rtattr *attrs_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
+		__u8 offload;
+
+		parse_rtattr_nested(attrs_offload, MACSEC_OFFLOAD_ATTR_MAX,
+				    attrs[MACSEC_ATTR_OFFLOAD]);
+
+		offload = rta_getattr_u8(attrs_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
+		print_string(PRINT_ANY, "offload",
+			     "    offload: %s ", offload_to_str(offload));
+		print_nl();
+	}
+
 	close_json_object();
 
 	return 0;
-- 
2.24.1

