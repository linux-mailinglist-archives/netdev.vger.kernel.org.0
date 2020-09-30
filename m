Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF86927F277
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgI3TRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:17:14 -0400
Received: from inva020.nxp.com ([92.121.34.13]:34850 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730013AbgI3TRK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 15:17:10 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 189381A09B9;
        Wed, 30 Sep 2020 21:17:07 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 0AB8F1A0976;
        Wed, 30 Sep 2020 21:17:07 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id B17CC202DA;
        Wed, 30 Sep 2020 21:17:06 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     jiri@nvidia.com, idosch@nvidia.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 1/4] devlink: add parser error drop packet traps
Date:   Wed, 30 Sep 2020 22:16:42 +0300
Message-Id: <20200930191645.9520-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200930191645.9520-1-ioana.ciornei@nxp.com>
References: <20200930191645.9520-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add parser error drop packet traps, so that capable device driver could
register them with devlink. The new packet trap group holds any drops of
packets which were marked by the device as erroneous during header
parsing. Add documentation for every added packet trap and packet trap
group.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 .../networking/devlink/devlink-trap.rst       | 70 +++++++++++++++++++
 include/net/devlink.h                         | 52 ++++++++++++++
 net/core/devlink.c                            | 17 +++++
 3 files changed, 139 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index 7a798352b45d..ef719ceac299 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -409,6 +409,73 @@ be added to the following table:
      - ``drop``
      - Traps packets dropped due to the RED (Random Early Detection) algorithm
        (i.e., early drops)
+   * - ``vxlan_parsing``
+     - ``drop``
+     - Traps packets dropped due to an error in the VXLAN header parsing which
+       might be because of packet truncation or the I flag is not set.
+   * - ``llc_snap_parsing``
+     - ``drop``
+     - Traps packets dropped due to an error in the LLC+SNAP header parsing
+   * - ``vlan_parsing``
+     - ``drop``
+     - Traps packets dropped due to an error in the VLAN header parsing. Could
+       include unexpected packet truncation.
+   * - ``pppoe_ppp_parsing``
+     - ``drop``
+     - Traps packets dropped due to an error in the PPPoE+PPP header parsing.
+       This could include finding a session ID of 0xFFFF (which is reserved and
+       not for use), a PPPoE length which is larger than the frame received or
+       any common error on this type of header
+   * - ``mpls_parsing``
+     - ``drop``
+     - Traps packets dropped due to an error in the MPLS header parsing which
+       could include unexpected header truncation
+   * - ``arp_parsing``
+     - ``drop``
+     - Traps packets dropped due to an error in the ARP header parsing
+   * - ``ip_1_parsing``
+     - ``drop``
+     - Traps packets dropped due to an error in the first IP header parsing.
+       This packet trap could include packets which do not pass an IP checksum
+       check, a header length check (a minimum of 20 bytes), which might suffer
+       from packet truncation thus the total length field exceeds the received
+       packet length etc
+   * - ``ip_n_parsing``
+     - ``drop``
+     - Traps packets dropped due to an error in the parsing of the last IP
+       header (the inner one in case of an IP over IP tunnel). The same common
+       error checking is performed here as for the ip_1_parsing trap
+   * - ``gre_parsing``
+     - ``drop``
+     - Traps packets dropped due to an error in the GRE header parsing
+   * - ``udp_parsing``
+     - ``drop``
+     - Traps packets dropped due to an error in the UDP header parsing.
+       This packet trap could include checksum errorrs, an improper UDP
+       length detected (smaller than 8 bytes) or detection of header
+       truncation.
+   * - ``tcp_parsing``
+     - ``drop``
+     - Traps packets dropped due to an error in the TCP header parsing.
+       This could include TCP checksum errors, improper combination of SYN, FIN
+       and/or RESET etc.
+   * - ``ipsec_parsing``
+     - ``drop``
+     - Traps packets dropped due to an error in the IPSEC header parsing
+   * - ``sctp_parsing``
+     - ``drop``
+     - Traps packets dropped due to an error in the SCTP header parsing.
+       This would mean that port number 0 was used or that the header is
+       truncated.
+   * - ``dccp_parsing``
+     - ``drop``
+     - Traps packets dropped due to an error in the DCCP header parsing
+   * - ``gtp_parsing``
+     - ``drop``
+     - Traps packets dropped due to an error in the GTP header parsing
+   * - ``esp_parsing``
+     - ``drop``
+     - Traps packets dropped due to an error in the ESP header parsing
 
 Driver-specific Packet Traps
 ============================
@@ -509,6 +576,9 @@ narrow. The description of these groups must be added to the following table:
    * - ``acl_trap``
      - Contains packet traps for packets that were trapped (logged) by the
        device during ACL processing
+   * - ``parser_error_drops``
+     - Contains packet traps for packets that were marked by the device during
+       parsing as erroneous
 
 Packet Trap Policers
 ====================
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 7339bf9ba6b4..20db4a070fc8 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -768,6 +768,22 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_FLOW_ACTION_SAMPLE,
 	DEVLINK_TRAP_GENERIC_ID_FLOW_ACTION_TRAP,
 	DEVLINK_TRAP_GENERIC_ID_EARLY_DROP,
+	DEVLINK_TRAP_GENERIC_ID_VXLAN_PARSING,
+	DEVLINK_TRAP_GENERIC_ID_LLC_SNAP_PARSING,
+	DEVLINK_TRAP_GENERIC_ID_VLAN_PARSING,
+	DEVLINK_TRAP_GENERIC_ID_PPPOE_PPP_PARSING,
+	DEVLINK_TRAP_GENERIC_ID_MPLS_PARSING,
+	DEVLINK_TRAP_GENERIC_ID_ARP_PARSING,
+	DEVLINK_TRAP_GENERIC_ID_IP_1_PARSING,
+	DEVLINK_TRAP_GENERIC_ID_IP_N_PARSING,
+	DEVLINK_TRAP_GENERIC_ID_GRE_PARSING,
+	DEVLINK_TRAP_GENERIC_ID_UDP_PARSING,
+	DEVLINK_TRAP_GENERIC_ID_TCP_PARSING,
+	DEVLINK_TRAP_GENERIC_ID_IPSEC_PARSING,
+	DEVLINK_TRAP_GENERIC_ID_SCTP_PARSING,
+	DEVLINK_TRAP_GENERIC_ID_DCCP_PARSING,
+	DEVLINK_TRAP_GENERIC_ID_GTP_PARSING,
+	DEVLINK_TRAP_GENERIC_ID_ESP_PARSING,
 
 	/* Add new generic trap IDs above */
 	__DEVLINK_TRAP_GENERIC_ID_MAX,
@@ -803,6 +819,7 @@ enum devlink_trap_group_generic_id {
 	DEVLINK_TRAP_GROUP_GENERIC_ID_PTP_GENERAL,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_ACL_SAMPLE,
 	DEVLINK_TRAP_GROUP_GENERIC_ID_ACL_TRAP,
+	DEVLINK_TRAP_GROUP_GENERIC_ID_PARSER_ERROR_DROPS,
 
 	/* Add new generic trap group IDs above */
 	__DEVLINK_TRAP_GROUP_GENERIC_ID_MAX,
@@ -958,6 +975,39 @@ enum devlink_trap_group_generic_id {
 	"flow_action_trap"
 #define DEVLINK_TRAP_GENERIC_NAME_EARLY_DROP \
 	"early_drop"
+#define DEVLINK_TRAP_GENERIC_NAME_VXLAN_PARSING \
+	"vxlan_parsing"
+#define DEVLINK_TRAP_GENERIC_NAME_LLC_SNAP_PARSING \
+	"llc_snap_parsing"
+#define DEVLINK_TRAP_GENERIC_NAME_VLAN_PARSING \
+	"vlan_parsing"
+#define DEVLINK_TRAP_GENERIC_NAME_PPPOE_PPP_PARSING \
+	"pppoe_ppp_parsing"
+#define DEVLINK_TRAP_GENERIC_NAME_MPLS_PARSING \
+	"mpls_parsing"
+#define DEVLINK_TRAP_GENERIC_NAME_ARP_PARSING \
+	"arp_parsing"
+#define DEVLINK_TRAP_GENERIC_NAME_IP_1_PARSING \
+	"ip_1_parsing"
+#define DEVLINK_TRAP_GENERIC_NAME_IP_N_PARSING \
+	"ip_n_parsing"
+#define DEVLINK_TRAP_GENERIC_NAME_GRE_PARSING \
+	"gre_parsing"
+#define DEVLINK_TRAP_GENERIC_NAME_UDP_PARSING \
+	"udp_parsing"
+#define DEVLINK_TRAP_GENERIC_NAME_TCP_PARSING \
+	"tcp_parsing"
+#define DEVLINK_TRAP_GENERIC_NAME_IPSEC_PARSING \
+	"ipsec_parsing"
+#define DEVLINK_TRAP_GENERIC_NAME_SCTP_PARSING \
+	"sctp_parsing"
+#define DEVLINK_TRAP_GENERIC_NAME_DCCP_PARSING \
+	"dccp_parsing"
+#define DEVLINK_TRAP_GENERIC_NAME_GTP_PARSING \
+	"gtp_parsing"
+#define DEVLINK_TRAP_GENERIC_NAME_ESP_PARSING \
+	"esp_parsing"
+
 
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_L2_DROPS \
 	"l2_drops"
@@ -1009,6 +1059,8 @@ enum devlink_trap_group_generic_id {
 	"acl_sample"
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_ACL_TRAP \
 	"acl_trap"
+#define DEVLINK_TRAP_GROUP_GENERIC_NAME_PARSER_ERROR_DROPS \
+	"parser_error_drops"
 
 #define DEVLINK_TRAP_GENERIC(_type, _init_action, _id, _group_id,	      \
 			     _metadata_cap)				      \
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7a38f9e25922..10fea5854bc2 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -8925,6 +8925,22 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	DEVLINK_TRAP(FLOW_ACTION_SAMPLE, CONTROL),
 	DEVLINK_TRAP(FLOW_ACTION_TRAP, CONTROL),
 	DEVLINK_TRAP(EARLY_DROP, DROP),
+	DEVLINK_TRAP(VXLAN_PARSING, DROP),
+	DEVLINK_TRAP(LLC_SNAP_PARSING, DROP),
+	DEVLINK_TRAP(VLAN_PARSING, DROP),
+	DEVLINK_TRAP(PPPOE_PPP_PARSING, DROP),
+	DEVLINK_TRAP(MPLS_PARSING, DROP),
+	DEVLINK_TRAP(ARP_PARSING, DROP),
+	DEVLINK_TRAP(IP_1_PARSING, DROP),
+	DEVLINK_TRAP(IP_N_PARSING, DROP),
+	DEVLINK_TRAP(GRE_PARSING, DROP),
+	DEVLINK_TRAP(UDP_PARSING, DROP),
+	DEVLINK_TRAP(TCP_PARSING, DROP),
+	DEVLINK_TRAP(IPSEC_PARSING, DROP),
+	DEVLINK_TRAP(SCTP_PARSING, DROP),
+	DEVLINK_TRAP(DCCP_PARSING, DROP),
+	DEVLINK_TRAP(GTP_PARSING, DROP),
+	DEVLINK_TRAP(ESP_PARSING, DROP),
 };
 
 #define DEVLINK_TRAP_GROUP(_id)						      \
@@ -8959,6 +8975,7 @@ static const struct devlink_trap_group devlink_trap_group_generic[] = {
 	DEVLINK_TRAP_GROUP(PTP_GENERAL),
 	DEVLINK_TRAP_GROUP(ACL_SAMPLE),
 	DEVLINK_TRAP_GROUP(ACL_TRAP),
+	DEVLINK_TRAP_GROUP(PARSER_ERROR_DROPS),
 };
 
 static int devlink_trap_generic_verify(const struct devlink_trap *trap)
-- 
2.28.0

