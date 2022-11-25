Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B166B638695
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiKYJsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:48:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiKYJrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:47:46 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADC543879;
        Fri, 25 Nov 2022 01:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669369572; x=1700905572;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wb0DFiwt9vh2SYSd91SuRv+6HLyo92IPL5J0Wg1daKA=;
  b=1mKdpTKlL8KmU1UrjqOP/Rca5NPvccbwHWDea8qQ8IGPzFRpuInxUWvD
   kHEP+YHuNlw/tMxLRcnLzvGCxD8LatXmRCcPQazgauQyNVxODYoySZP76
   JVPj8ZtTdHrFZ3qPT6zy2npG6tcdaxZoombnlZEvwiqPqD2xeVWnc5WzM
   KH75+3EhF02hFLfI7I1eapMpAeBDpQfK6na48aIuYbnZBDLPg29Xd86lh
   irBnDaiVR2AIaxsAIBaqMPcrXaJqWhasPuDdIYMxoo4JrFNwowRMFVzfS
   ImHFz63ufHnbO3L3q/1hvxcTX9iODwL9G1MjWqOa3ttdkb04SKQtmPBSa
   g==;
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="201371037"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Nov 2022 02:46:11 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 25 Nov 2022 02:46:11 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 25 Nov 2022 02:46:09 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 2/9] net: microchip: vcap: Extend vcap with lan966x
Date:   Fri, 25 Nov 2022 10:50:03 +0100
Message-ID: <20221125095010.124458-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221125095010.124458-1-horatiu.vultur@microchip.com>
References: <20221125095010.124458-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the keysets, keys, actionsets and actions used by lan966x in IS2.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/vcap/vcap_ag_api.h | 202 +++++++++++++-----
 1 file changed, 146 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h b/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
index d6d70af896165..84de2aee41698 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
@@ -36,6 +36,13 @@ enum vcap_keyfield_set {
 	VCAP_KFS_NORMAL_7TUPLE,     /* sparx5 is0 X12 */
 	VCAP_KFS_PURE_5TUPLE_IP4,   /* sparx5 is0 X3 */
 	VCAP_KFS_TRI_VID,           /* sparx5 is0 X2 */
+	VCAP_KFS_MAC_LLC,           /* lan966x is2 X2 */
+	VCAP_KFS_MAC_SNAP,          /* lan966x is2 X2 */
+	VCAP_KFS_OAM,               /* lan966x is2 X2 */
+	VCAP_KFS_IP6_TCP_UDP,       /* lan966x is2 X4 */
+	VCAP_KFS_IP6_OTHER,         /* lan966x is2 X4 */
+	VCAP_KFS_SMAC_SIP4,         /* lan966x is2 X1 */
+	VCAP_KFS_SMAC_SIP6,         /* lan966x is2 X2 */
 };
 
 /* List of keyfields with description
@@ -61,7 +68,7 @@ enum vcap_keyfield_set {
  *   Second DEI in multiple vlan tags (inner tag)
  * VCAP_KF_8021Q_DEI2: W1, sparx5: is0
  *   Third DEI in multiple vlan tags (not always available)
- * VCAP_KF_8021Q_DEI_CLS: W1, sparx5: is2/es2
+ * VCAP_KF_8021Q_DEI_CLS: W1, sparx5: is2/es2, lan966x: is2
  *   Classified DEI
  * VCAP_KF_8021Q_PCP0: W3, sparx5: is0
  *   First PCP in multiple vlan tags (outer tag or default port tag)
@@ -69,7 +76,7 @@ enum vcap_keyfield_set {
  *   Second PCP in multiple vlan tags (inner tag)
  * VCAP_KF_8021Q_PCP2: W3, sparx5: is0
  *   Third PCP in multiple vlan tags (not always available)
- * VCAP_KF_8021Q_PCP_CLS: W3, sparx5: is2/es2
+ * VCAP_KF_8021Q_PCP_CLS: W3, sparx5: is2/es2, lan966x: is2
  *   Classified PCP
  * VCAP_KF_8021Q_TPID0: W3, sparx5: is0
  *   First TPIC in multiple vlan tags (outer tag or default port tag)
@@ -83,9 +90,9 @@ enum vcap_keyfield_set {
  *   Second VID in multiple vlan tags (inner tag)
  * VCAP_KF_8021Q_VID2: W12, sparx5: is0
  *   Third VID in multiple vlan tags (not always available)
- * VCAP_KF_8021Q_VID_CLS: W13, sparx5: is2/es2
+ * VCAP_KF_8021Q_VID_CLS: W13, sparx5: is2/es2, lan966x is2 W12
  *   Classified VID
- * VCAP_KF_8021Q_VLAN_TAGGED_IS: W1, sparx5: is2/es2
+ * VCAP_KF_8021Q_VLAN_TAGGED_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Sparx5: Set if frame was received with a VLAN tag, LAN966x: Set if frame has
  *   one or more Q-tags. Independent of port VLAN awareness
  * VCAP_KF_8021Q_VLAN_TAGS: W3, sparx5: is0
@@ -93,19 +100,19 @@ enum vcap_keyfield_set {
  *   tagged, 7: Triple tagged
  * VCAP_KF_ACL_GRP_ID: W8, sparx5: es2
  *   Used in interface map table
- * VCAP_KF_ARP_ADDR_SPACE_OK_IS: W1, sparx5: is2/es2
+ * VCAP_KF_ARP_ADDR_SPACE_OK_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Set if hardware address is Ethernet
- * VCAP_KF_ARP_LEN_OK_IS: W1, sparx5: is2/es2
+ * VCAP_KF_ARP_LEN_OK_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Set if hardware address length = 6 (Ethernet) and IP address length = 4 (IP).
- * VCAP_KF_ARP_OPCODE: W2, sparx5: is2/es2
+ * VCAP_KF_ARP_OPCODE: W2, sparx5: is2/es2, lan966x: i2
  *   ARP opcode
- * VCAP_KF_ARP_OPCODE_UNKNOWN_IS: W1, sparx5: is2/es2
+ * VCAP_KF_ARP_OPCODE_UNKNOWN_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Set if not one of the codes defined in VCAP_KF_ARP_OPCODE
- * VCAP_KF_ARP_PROTO_SPACE_OK_IS: W1, sparx5: is2/es2
+ * VCAP_KF_ARP_PROTO_SPACE_OK_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Set if protocol address space is 0x0800
- * VCAP_KF_ARP_SENDER_MATCH_IS: W1, sparx5: is2/es2
+ * VCAP_KF_ARP_SENDER_MATCH_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Sender Hardware Address = SMAC (ARP)
- * VCAP_KF_ARP_TGT_MATCH_IS: W1, sparx5: is2/es2
+ * VCAP_KF_ARP_TGT_MATCH_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Target Hardware Address = SMAC (RARP)
  * VCAP_KF_COSID_CLS: W3, sparx5: es2
  *   Class of service
@@ -114,7 +121,7 @@ enum vcap_keyfield_set {
  *   fields L2_SMAC and L3_IP4_SIP
  * VCAP_KF_ES0_ISDX_KEY_ENA: W1, sparx5: es2
  *   The value taken from the IFH .FWD.ES0_ISDX_KEY_ENA
- * VCAP_KF_ETYPE: W16, sparx5: is0/is2/es2
+ * VCAP_KF_ETYPE: W16, sparx5: is0/is2/es2, lan966x: is2
  *   Ethernet type
  * VCAP_KF_ETYPE_LEN_IS: W1, sparx5: is0/is2/es2
  *   Set if frame has EtherType >= 0x600
@@ -128,7 +135,8 @@ enum vcap_keyfield_set {
  * VCAP_KF_IF_IGR_PORT: sparx5 is0 W7, sparx5 es2 W9
  *   Sparx5: Logical ingress port number retrieved from
  *   ANA_CL::PORT_ID_CFG.LPORT_NUM or ERLEG, LAN966x: ingress port nunmber
- * VCAP_KF_IF_IGR_PORT_MASK: sparx5 is0 W65, sparx5 is2 W32, sparx5 is2 W65
+ * VCAP_KF_IF_IGR_PORT_MASK: sparx5 is0 W65, sparx5 is2 W32, sparx5 is2 W65,
+ *   lan966x is2 W9
  *   Ingress port mask, one bit per port/erleg
  * VCAP_KF_IF_IGR_PORT_MASK_L3: W1, sparx5: is2
  *   If set, IF_IGR_PORT_MASK, IF_IGR_PORT_MASK_RNG, and IF_IGR_PORT_MASK_SEL are
@@ -141,7 +149,7 @@ enum vcap_keyfield_set {
  *   Mapping: 0: DEFAULT 1: LOOPBACK 2: MASQUERADE 3: CPU_VD
  * VCAP_KF_IF_IGR_PORT_SEL: W1, sparx5: es2
  *   Selector for IF_IGR_PORT: physical port number or ERLEG
- * VCAP_KF_IP4_IS: W1, sparx5: is0/is2/es2
+ * VCAP_KF_IP4_IS: W1, sparx5: is0/is2/es2, lan966x: is2
  *   Set if frame has EtherType = 0x800 and IP version = 4
  * VCAP_KF_IP_MC_IS: W1, sparx5: is0
  *   Set if frame is IPv4 frame and frame’s destination MAC address is an IPv4
@@ -153,22 +161,22 @@ enum vcap_keyfield_set {
  *   Set if frame is IPv4, IPv6, or SNAP frame
  * VCAP_KF_ISDX_CLS: W12, sparx5: is2/es2
  *   Classified ISDX
- * VCAP_KF_ISDX_GT0_IS: W1, sparx5: is2/es2
+ * VCAP_KF_ISDX_GT0_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Set if classified ISDX > 0
- * VCAP_KF_L2_BC_IS: W1, sparx5: is0/is2/es2
+ * VCAP_KF_L2_BC_IS: W1, sparx5: is0/is2/es2, lan966x: is2
  *   Set if frame’s destination MAC address is the broadcast address
  *   (FF-FF-FF-FF-FF-FF).
- * VCAP_KF_L2_DMAC: W48, sparx5: is0/is2/es2
+ * VCAP_KF_L2_DMAC: W48, sparx5: is0/is2/es2, lan966x: is2
  *   Destination MAC address
  * VCAP_KF_L2_FWD_IS: W1, sparx5: is2
  *   Set if the frame is allowed to be forwarded to front ports
- * VCAP_KF_L2_MC_IS: W1, sparx5: is0/is2/es2
+ * VCAP_KF_L2_MC_IS: W1, sparx5: is0/is2/es2, lan9966x is2
  *   Set if frame’s destination MAC address is a multicast address (bit 40 = 1).
  * VCAP_KF_L2_PAYLOAD_ETYPE: W64, sparx5: is2/es2
  *   Byte 0-7 of L2 payload after Type/Len field and overloading for OAM
- * VCAP_KF_L2_SMAC: W48, sparx5: is0/is2/es2
+ * VCAP_KF_L2_SMAC: W48, sparx5: is0/is2/es2, lan966x is2
  *   Source MAC address
- * VCAP_KF_L3_DIP_EQ_SIP_IS: W1, sparx5: is2/es2
+ * VCAP_KF_L3_DIP_EQ_SIP_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Set if Src IP matches Dst IP address
  * VCAP_KF_L3_DMAC_DIP_MATCH: W1, sparx5: is2
  *   Match found in DIP security lookup in ANA_L3
@@ -183,21 +191,22 @@ enum vcap_keyfield_set {
  * VCAP_KF_L3_FRAG_INVLD_L4_LEN: W1, sparx5: is0/is2
  *   Set if frame's L4 length is less than ANA_CL:COMMON:CLM_FRAGMENT_CFG.L4_MIN_L
  *   EN
- * VCAP_KF_L3_IP4_DIP: W32, sparx5: is0/is2/es2
+ * VCAP_KF_L3_IP4_DIP: W32, sparx5: is0/is2/es2, lan966x: is2
  *   Destination IPv4 Address
- * VCAP_KF_L3_IP4_SIP: W32, sparx5: is0/is2/es2
+ * VCAP_KF_L3_IP4_SIP: W32, sparx5: is0/is2/es2, lan966x: is2
  *   Source IPv4 Address
- * VCAP_KF_L3_IP6_DIP: W128, sparx5: is0/is2/es2
+ * VCAP_KF_L3_IP6_DIP: W128, sparx5: is0/is2/es2, lan966x: is2
  *   Sparx5: Full IPv6 DIP, LAN966x: Either Full IPv6 DIP or a subset depending on
  *   frame type
- * VCAP_KF_L3_IP6_SIP: W128, sparx5: is0/is2/es2
+ * VCAP_KF_L3_IP6_SIP: W128, sparx5: is0/is2/es2, lan966x: is2
  *   Sparx5: Full IPv6 SIP, LAN966x: Either Full IPv6 SIP or a subset depending on
  *   frame type
- * VCAP_KF_L3_IP_PROTO: W8, sparx5: is0/is2/es2
+ * VCAP_KF_L3_IP_PROTO: W8, sparx5: is0/is2/es2, lan966x: is2
  *   IPv4 frames: IP protocol. IPv6 frames: Next header, same as for IPV4
- * VCAP_KF_L3_OPTIONS_IS: W1, sparx5: is0/is2/es2
+ * VCAP_KF_L3_OPTIONS_IS: W1, sparx5: is0/is2/es2, lan966x: is2
  *   Set if IPv4 frame contains options (IP len > 5)
- * VCAP_KF_L3_PAYLOAD: sparx5 is2 W96, sparx5 is2 W40, sparx5 es2 W96
+ * VCAP_KF_L3_PAYLOAD: sparx5 is2 W96, sparx5 is2 W40, sparx5 es2 W96,
+ *   lan966x is2 W56
  *   Sparx5: Payload bytes after IP header. IPv4: IPv4 options are not parsed so
  *   payload is always taken 20 bytes after the start of the IPv4 header, LAN966x:
  *   Bytes 0-6 after IP header
@@ -205,14 +214,14 @@ enum vcap_keyfield_set {
  *   Set if frame has hit a router leg
  * VCAP_KF_L3_SMAC_SIP_MATCH: W1, sparx5: is2
  *   Match found in SIP security lookup in ANA_L3
- * VCAP_KF_L3_TOS: W8, sparx5: is2/es2
+ * VCAP_KF_L3_TOS: W8, sparx5: is2/es2, lan966x: is2
  *   Sparx5: Frame's IPv4/IPv6 DSCP and ECN fields, LAN966x: IP TOS field
- * VCAP_KF_L3_TTL_GT0: W1, sparx5: is2/es2
+ * VCAP_KF_L3_TTL_GT0: W1, sparx5: is2/es2, lan966x: is2
  *   Set if IPv4 TTL / IPv6 hop limit is greater than 0
- * VCAP_KF_L4_ACK: W1, sparx5: is2/es2
+ * VCAP_KF_L4_ACK: W1, sparx5: is2/es2, lan966x: is2
  *   Sparx5 and LAN966x: TCP flag ACK, LAN966x only: PTP over UDP: flagField bit 2
  *   (unicastFlag)
- * VCAP_KF_L4_DPORT: W16, sparx5: is2/es2
+ * VCAP_KF_L4_DPORT: W16, sparx5: is2/es2, lan966x: is2
  *   Sparx5: TCP/UDP destination port. Overloading for IP_7TUPLE: Non-TCP/UDP IP
  *   frames: L4_DPORT = L3_IP_PROTO, LAN966x: TCP/UDP destination port
  * VCAP_KF_L4_FIN: W1, sparx5: is2/es2
@@ -222,55 +231,90 @@ enum vcap_keyfield_set {
  *   frames: Payload bytes 0–7 after IP header. IPv4 options are not parsed so
  *   payload is always taken 20 bytes after the start of the IPv4 header for non
  *   TCP/UDP IPv4 frames
- * VCAP_KF_L4_PSH: W1, sparx5: is2/es2
+ * VCAP_KF_L4_PSH: W1, sparx5: is2/es2, lan966x: is2
  *   Sparx5: TCP flag PSH, LAN966x: TCP: TCP flag PSH. PTP over UDP: flagField bit
  *   1 (twoStepFlag)
- * VCAP_KF_L4_RNG: sparx5 is0 W8, sparx5 is2 W16, sparx5 es2 W16
+ * VCAP_KF_L4_RNG: sparx5 is0 W8, sparx5 is2 W16, sparx5 es2 W16, lan966x: is2
  *   Range checker bitmask (one for each range checker). Input into range checkers
  *   is taken from classified results (VID, DSCP) and frame (SPORT, DPORT, ETYPE,
  *   outer VID, inner VID)
- * VCAP_KF_L4_RST: W1, sparx5: is2/es2
+ * VCAP_KF_L4_RST: W1, sparx5: is2/es2, lan966x: is2
  *   Sparx5: TCP flag RST , LAN966x: TCP: TCP flag RST. PTP over UDP: messageType
  *   bit 3
- * VCAP_KF_L4_SEQUENCE_EQ0_IS: W1, sparx5: is2/es2
+ * VCAP_KF_L4_SEQUENCE_EQ0_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Set if TCP sequence number is 0, LAN966x: Overlayed with PTP over UDP:
  *   messageType bit 0
- * VCAP_KF_L4_SPORT: W16, sparx5: is0/is2/es2
+ * VCAP_KF_L4_SPORT: W16, sparx5: is0/is2/es2, lan966x: is2
  *   TCP/UDP source port
- * VCAP_KF_L4_SPORT_EQ_DPORT_IS: W1, sparx5: is2/es2
+ * VCAP_KF_L4_SPORT_EQ_DPORT_IS: W1, sparx5: is2/es2, lan966x: is2
  *   Set if UDP or TCP source port equals UDP or TCP destination port
- * VCAP_KF_L4_SYN: W1, sparx5: is2/es2
+ * VCAP_KF_L4_SYN: W1, sparx5: is2/es2, lan966x: is2
  *   Sparx5: TCP flag SYN, LAN966x: TCP: TCP flag SYN. PTP over UDP: messageType
  *   bit 2
- * VCAP_KF_L4_URG: W1, sparx5: is2/es2
+ * VCAP_KF_L4_URG: W1, sparx5: is2/es2, lan966x: is2
  *   Sparx5: TCP flag URG, LAN966x: TCP: TCP flag URG. PTP over UDP: flagField bit
  *   7 (reserved)
- * VCAP_KF_LOOKUP_FIRST_IS: W1, sparx5: is0/is2/es2
+ * VCAP_KF_LOOKUP_FIRST_IS: W1, sparx5: is0/is2/es2, lan966x: is2
  *   Selects between entries relevant for first and second lookup. Set for first
  *   lookup, cleared for second lookup.
  * VCAP_KF_LOOKUP_GEN_IDX: W12, sparx5: is0
  *   Generic index - for chaining CLM instances
  * VCAP_KF_LOOKUP_GEN_IDX_SEL: W2, sparx5: is0
  *   Select the mode of the Generic Index
- * VCAP_KF_LOOKUP_PAG: W8, sparx5: is2
+ * VCAP_KF_LOOKUP_PAG: W8, sparx5: is2, lan966x: is2
  *   Classified Policy Association Group: chains rules from IS1/CLM to IS2
- * VCAP_KF_OAM_CCM_CNTS_EQ0: W1, sparx5: is2/es2
+ * VCAP_KF_OAM_CCM_CNTS_EQ0: W1, sparx5: is2/es2, lan966x: is2
  *   Dual-ended loss measurement counters in CCM frames are all zero
- * VCAP_KF_OAM_MEL_FLAGS: W7, sparx5: is0
+ * VCAP_KF_OAM_MEL_FLAGS: W7, sparx5: is0, lan966x: is2
  *   Encoding of MD level/MEG level (MEL)
- * VCAP_KF_OAM_Y1731_IS: W1, sparx5: is0/is2/es2
+ * VCAP_KF_OAM_Y1731_IS: W1, sparx5: is0/is2/es2, lan966x: is2
  *   Set if frame’s EtherType = 0x8902
  * VCAP_KF_PROT_ACTIVE: W1, sparx5: es2
  *   Protection is active
- * VCAP_KF_TCP_IS: W1, sparx5: is0/is2/es2
+ * VCAP_KF_TCP_IS: W1, sparx5: is0/is2/es2, lan966x: is2
  *   Set if frame is IPv4 TCP frame (IP protocol = 6) or IPv6 TCP frames (Next
  *   header = 6)
- * VCAP_KF_TCP_UDP_IS: W1, sparx5: is0/is2/es2
+ * VCAP_KF_TCP_UDP_IS: W1, sparx5: is0/is2/es2, lan966x: is2
  *   Set if frame is IPv4/IPv6 TCP or UDP frame (IP protocol/next header equals 6
  *   or 17)
  * VCAP_KF_TYPE: sparx5 is0 W2, sparx5 is0 W1, sparx5 is2 W4, sparx5 is2 W2,
- *   sparx5 es2 W3
+ *   sparx5 es2 W3, lan966x: is2
  *   Keyset type id - set by the API
+ * VCAP_KF_HOST_MATCH: W1, lan966x: is2
+ *   The action from the SMAC_SIP4 or SMAC_SIP6 lookups. Used for IP source
+ *   guarding.
+ * VCAP_KF_L2_FRM_TYPE: W4, lan966x: is2
+ *   Frame subtype for specific EtherTypes (MRP, DLR)
+ * VCAP_KF_L2_PAYLOAD0: W16, lan966x: is2
+ *   Payload bytes 0-1 after the frame’s EtherType
+ * VCAP_KF_L2_PAYLOAD1: W8, lan966x: is2
+ *   Payload byte 4 after the frame’s EtherType. This is specifically for PTP
+ *   frames.
+ * VCAP_KF_L2_PAYLOAD2: W3, lan966x: is2
+ *   Bits 7, 2, and 1 from payload byte 6 after the frame’s EtherType. This is
+ *   specifically for PTP frames.
+ * VCAP_KF_L2_LLC: W40, lan966x: is2
+ *   LLC header and data after up to two VLAN tags and the type/length field
+ * VCAP_KF_L3_FRAGMENT: W1, lan966x: is2
+ *   Set if IPv4 frame is fragmented
+ * VCAP_KF_L3_FRAG_OFS_GT0: W1, lan966x: is2
+ *   Set if IPv4 frame is fragmented and it is not the first fragment
+ * VCAP_KF_L2_SNAP: W40, lan966x: is2
+ *   SNAP header after LLC header (AA-AA-03)
+ * VCAP_KF_L4_1588_DOM: W8, lan966x: is2
+ *   PTP over UDP: domainNumber
+ * VCAP_KF_L4_1588_VER: W4, lan966x: is2
+ *   PTP over UDP: version
+ * VCAP_KF_OAM_MEPID: W16, lan966x: is2
+ *   CCM frame’s OAM MEP ID
+ * VCAP_KF_OAM_OPCODE: W8, lan966x: is2
+ *   Frame’s OAM opcode
+ * VCAP_KF_OAM_VER: W5, lan966x: is2
+ *   Frame’s OAM version
+ * VCAP_KF_OAM_FLAGS: W8, lan966x: is2
+ *   Frame’s OAM flags
+ * VCAP_KF_OAM_DETECTED: W1, lan966x: is2
+ *   This is missing in the datasheet, but present in the OAM keyset in XML
  */
 
 /* Keyfield names */
@@ -375,17 +419,34 @@ enum vcap_key_field {
 	VCAP_KF_TCP_IS,
 	VCAP_KF_TCP_UDP_IS,
 	VCAP_KF_TYPE,
+	VCAP_KF_HOST_MATCH,
+	VCAP_KF_L2_FRM_TYPE,
+	VCAP_KF_L2_PAYLOAD0,
+	VCAP_KF_L2_PAYLOAD1,
+	VCAP_KF_L2_PAYLOAD2,
+	VCAP_KF_L2_LLC,
+	VCAP_KF_L3_FRAGMENT,
+	VCAP_KF_L3_FRAG_OFS_GT0,
+	VCAP_KF_L2_SNAP,
+	VCAP_KF_L4_1588_DOM,
+	VCAP_KF_L4_1588_VER,
+	VCAP_KF_OAM_MEPID,
+	VCAP_KF_OAM_OPCODE,
+	VCAP_KF_OAM_VER,
+	VCAP_KF_OAM_FLAGS,
+	VCAP_KF_OAM_DETECTED,
 };
 
 /* Actionset names with origin information */
 enum vcap_actionfield_set {
 	VCAP_AFS_NO_VALUE,          /* initial value */
-	VCAP_AFS_BASE_TYPE,         /* sparx5 is2 X3, sparx5 es2 X3 */
+	VCAP_AFS_BASE_TYPE,         /* sparx5 is2 X3, sparx5 es2 X3, lan966x is2 X2 */
 	VCAP_AFS_CLASSIFICATION,    /* sparx5 is0 X2 */
 	VCAP_AFS_CLASS_REDUCED,     /* sparx5 is0 X1 */
 	VCAP_AFS_FULL,              /* sparx5 is0 X3 */
 	VCAP_AFS_MLBS,              /* sparx5 is0 X2 */
 	VCAP_AFS_MLBS_REDUCED,      /* sparx5 is0 X1 */
+	VCAP_AFS_SMAC_SIP,          /* lan966x is2 x1 */
 };
 
 /* List of actionfields with description
@@ -404,10 +465,10 @@ enum vcap_actionfield_set {
  *   QSYS port number when FWD_MODE is redirect or copy
  * VCAP_AF_COPY_QUEUE_NUM: W16, sparx5: es2
  *   QSYS queue number when FWD_MODE is redirect or copy
- * VCAP_AF_CPU_COPY_ENA: W1, sparx5: is2/es2
+ * VCAP_AF_CPU_COPY_ENA: W1, sparx5: is2/es2, lan966x: is2
  *   Setting this bit to 1 causes all frames that hit this action to be copied to
  *   the CPU extraction queue specified in CPU_QUEUE_NUM.
- * VCAP_AF_CPU_QUEUE_NUM: W3, sparx5: is2/es2
+ * VCAP_AF_CPU_QUEUE_NUM: W3, sparx5: is2/es2, lan966x: is2
  *   CPU queue number. Used when CPU_COPY_ENA is set.
  * VCAP_AF_DEI_ENA: W1, sparx5: is0
  *   If set, use DEI_VAL as classified DEI value. Otherwise, DEI from basic
@@ -429,7 +490,7 @@ enum vcap_actionfield_set {
  *   DMAC translation when entering or leaving a tunnel.
  * VCAP_AF_FWD_MODE: W2, sparx5: es2
  *   Forward selector: 0: Forward. 1: Discard. 2: Redirect. 3: Copy.
- * VCAP_AF_HIT_ME_ONCE: W1, sparx5: is2/es2
+ * VCAP_AF_HIT_ME_ONCE: W1, sparx5: is2/es2, lan966x: is2
  *   Setting this bit to 1 causes the first frame that hits this action where the
  *   HIT_CNT counter is zero to be copied to the CPU extraction queue specified in
  *   CPU_QUEUE_NUM. The HIT_CNT counter is then incremented and any frames that
@@ -445,7 +506,7 @@ enum vcap_actionfield_set {
  *   = ISDX_VAL.
  * VCAP_AF_ISDX_VAL: W12, sparx5: is0
  *   See isdx_add_replace_sel
- * VCAP_AF_LRN_DIS: W1, sparx5: is2
+ * VCAP_AF_LRN_DIS: W1, sparx5: is2, lan966x: is2
  *   Setting this bit to 1 disables learning of frames hitting this action.
  * VCAP_AF_MAP_IDX: W9, sparx5: is0
  *   Index for QoS mapping table lookup
@@ -460,7 +521,7 @@ enum vcap_actionfield_set {
  *   are applied to. 0: No changes to the QoS Mapping Table lookup. 1: Update key
  *   type and index for QoS Mapping Table lookup #0. 2: Update key type and index
  *   for QoS Mapping Table lookup #1. 3: Reserved.
- * VCAP_AF_MASK_MODE: W3, sparx5: is0/is2
+ * VCAP_AF_MASK_MODE: W3, sparx5: is0/is2, lan966x is2 W2
  *   Controls the PORT_MASK use. Sparx5: 0: OR_DSTMASK, 1: AND_VLANMASK, 2:
  *   REPLACE_PGID, 3: REPLACE_ALL, 4: REDIR_PGID, 5: OR_PGID_MASK, 6: VSTAX, 7:
  *   Not applicable. LAN966X: 0: No action, 1: Permit/deny (AND), 2: Policy
@@ -497,15 +558,15 @@ enum vcap_actionfield_set {
  *   PIPELINE_PT == NONE. Overrules previous settings of pipeline point.
  * VCAP_AF_PIPELINE_PT: W5, sparx5: is0/is2
  *   Pipeline point used if PIPELINE_FORCE_ENA is set
- * VCAP_AF_POLICE_ENA: W1, sparx5: is2/es2
+ * VCAP_AF_POLICE_ENA: W1, sparx5: is2/es2, lan966x: is2
  *   Setting this bit to 1 causes frames that hit this action to be policed by the
  *   ACL policer specified in POLICE_IDX. Only applies to the first lookup.
- * VCAP_AF_POLICE_IDX: W6, sparx5: is2/es2
+ * VCAP_AF_POLICE_IDX: W6, sparx5: is2/es2, lan966x: is2 W9
  *   Selects VCAP policer used when policing frames (POLICE_ENA)
  * VCAP_AF_POLICE_REMARK: W1, sparx5: es2
  *   If set, frames exceeding policer rates are marked as yellow but not
  *   discarded.
- * VCAP_AF_PORT_MASK: sparx5 is0 W65, sparx5 is2 W68
+ * VCAP_AF_PORT_MASK: sparx5 is0 W65, sparx5 is2 W68, lan966x is2 W8
  *   Port mask applied to the forwarding decision based on MASK_MODE.
  * VCAP_AF_QOS_ENA: W1, sparx5: is0
  *   If set, use QOS_VAL as classified QoS class. Otherwise, QoS class from basic
@@ -519,6 +580,28 @@ enum vcap_actionfield_set {
  *   Actionset type id - Set by the API
  * VCAP_AF_VID_VAL: W13, sparx5: is0
  *   New VID Value
+ * VCAP_AF_MIRROR_ENA: W1, lan966x: is2
+ *   Setting this bit to 1 causes frames to be mirrored to the mirror target
+ *   port (ANA::MIRRPORPORTS).
+ * VCAP_AF_POLICE_VCAP_ONLY: W1, lan966x: is2
+ *   Disable policing from QoS, and port policers. Only the VCAP policer
+ *   selected by POLICE_IDX is active. Only applies to the second lookup.
+ * VCAP_AF_REW_OP: W16, lan966x: is2
+ *   Rewriter operation command.
+ * VCAP_AF_ISDX_ENA: W1, lan966x: is2
+ *   Setting this bit to 1 causes the classified ISDX to be set to the value of
+ *   POLICE_IDX[8:0].
+ * VCAP_AF_ACL_ID: W6, lan966x: is2
+ *   Logical ID for the entry. This ID is extracted together with the frame in
+ *   the CPU extraction header. Only applicable to actions with CPU_COPY_ENA or
+ *   HIT_ME_ONCE set.
+ * VCAP_AF_FWD_KILL_ENA: W1, lan966x: is2
+ *   Setting this bit to 1 denies forwarding of the frame forwarding to any
+ *   front port. The frame can still be copied to the CPU by other actions.
+ * VCAP_AF_HOST_MATCH: W1, lan966x: is2
+ *  Used for IP source guarding. If set, it signals that the host is a valid
+ *  (for instance a valid combination of source MAC address and source IP
+ *  address). HOST_MATCH is input to the IS2 keys.
  */
 
 /* Actionfield names */
@@ -640,6 +723,13 @@ enum vcap_action_field {
 	VCAP_AF_VLAN_PUSH_CNT,
 	VCAP_AF_VLAN_PUSH_CNT_ENA,
 	VCAP_AF_VLAN_WAS_TAGGED,
+	VCAP_AF_MIRROR_ENA,
+	VCAP_AF_POLICE_VCAP_ONLY,
+	VCAP_AF_REW_OP,
+	VCAP_AF_ISDX_ENA,
+	VCAP_AF_ACL_ID,
+	VCAP_AF_FWD_KILL_ENA,
+	VCAP_AF_HOST_MATCH,
 };
 
 #endif /* __VCAP_AG_API__ */
-- 
2.38.0

