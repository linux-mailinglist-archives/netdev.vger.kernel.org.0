Return-Path: <netdev+bounces-6453-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 601B6716604
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:04:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D57011C20A80
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:04:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0107F23C94;
	Tue, 30 May 2023 15:04:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6D217AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:04:16 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04506E8;
	Tue, 30 May 2023 08:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685459051; x=1716995051;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EPeesJyV6ux8pKUL0l4OgzRpXXw2wr55jTBMDWb8IS4=;
  b=APPbcOuFEvgU7fNE4gsAA12emdAFiYi6V2VB2gnmcaVnuKPxrjhbRnRg
   kZC6FPO6Gi4o7nhy3ZgWJFNdYKgUYOZNex7O4XMOiwx6ZY+lj1JC2ZqBA
   vRilFqoo3w4f+W+RzvGNukg1kt3EO85GFhlfK/W0WD9mi0d7CbLy/ZWtg
   K8shH6G7Xune8BHI/9NjzoIdEF6U4xvsFLo3w7xx8EsnwEy79GbMfi+LI
   Bo0Uyjh9UuVwYuz2JpNxt1P9mXZOXOfGmd9JbhYjK06v5+AV/UhnbQUAk
   lIkqgsgYVy2TA0NPnoapu8mDcpq+ZygjEIaqoThzAWkfqEuXlCPEe8ipW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="358192212"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="358192212"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 08:03:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="796304140"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="796304140"
Received: from newjersey.igk.intel.com ([10.102.20.203])
  by FMSMGA003.fm.intel.com with ESMTP; 30 May 2023 08:03:08 -0700
From: Alexander Lobakin <aleksander.lobakin@intel.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Alexander Lobakin <aleksander.lobakin@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Christoph Hellwig <hch@lst.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 01/12] net: intel: introduce Intel Ethernet common library
Date: Tue, 30 May 2023 17:00:24 +0200
Message-Id: <20230530150035.1943669-2-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530150035.1943669-1-aleksander.lobakin@intel.com>
References: <20230530150035.1943669-1-aleksander.lobakin@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Not a secret there's a ton of code duplication between two and more Intel
ethernet modules.
Before introducing new changes, which would need to be copied over again,
start decoupling the already existing duplicate functionality into a new
module, which will be shared between several Intel Ethernet drivers.
Add the lookup table which converts 8/10-bit hardware packet type into
a parsed bitfield structure for easy checking packet format parameters,
such as payload level, IP version, etc. This is currently used by i40e,
ice and iavf and it's all the same in all three drivers.
The only difference introduced in this implementation is that instead of
defining a 256 (or 1024 in case of ice) element array, add unlikely()
condition to limit the input to 154 (current maximum non-reserved packet
type). There's no reason to waste 600 (or even 3600) bytes only to not
hurt very unlikely exception packets.
The hash computation function now takes payload level directly as a
pkt_hash_type. There's a couple cases when non-IP ptypes are marked as
L3 payload and in the previous versions their hash level would be 2, not
3. But skb_set_hash() only sees difference between L4 and non-L4, thus
this won't change anything at all.
The module is behind the hidden Kconfig symbol, which the drivers will
select when needed. The exports are behind 'LIBIE' namespace to limit
the scope of the functions.

Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 MAINTAINERS                                   |   3 +-
 drivers/net/ethernet/intel/Kconfig            |  11 +-
 drivers/net/ethernet/intel/Makefile           |   1 +
 drivers/net/ethernet/intel/i40e/i40e_common.c | 253 --------------
 drivers/net/ethernet/intel/i40e/i40e_main.c   |   1 +
 .../net/ethernet/intel/i40e/i40e_prototype.h  |   7 -
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  74 +---
 drivers/net/ethernet/intel/i40e/i40e_type.h   |  88 -----
 drivers/net/ethernet/intel/iavf/iavf_common.c | 253 --------------
 drivers/net/ethernet/intel/iavf/iavf_main.c   |   1 +
 .../net/ethernet/intel/iavf/iavf_prototype.h  |   7 -
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  70 +---
 drivers/net/ethernet/intel/iavf/iavf_type.h   |  88 -----
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    | 316 ------------------
 drivers/net/ethernet/intel/ice/ice_main.c     |   1 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  74 +---
 drivers/net/ethernet/intel/libie/Makefile     |   6 +
 drivers/net/ethernet/intel/libie/rx.c         | 110 ++++++
 include/linux/net/intel/libie/rx.h            | 128 +++++++
 19 files changed, 312 insertions(+), 1180 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/libie/Makefile
 create mode 100644 drivers/net/ethernet/intel/libie/rx.c
 create mode 100644 include/linux/net/intel/libie/rx.h

diff --git a/MAINTAINERS b/MAINTAINERS
index c904dba1733b..bd65fa9e39c8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10340,7 +10340,8 @@ F:	Documentation/networking/device_drivers/ethernet/intel/
 F:	drivers/net/ethernet/intel/
 F:	drivers/net/ethernet/intel/*/
 F:	include/linux/avf/virtchnl.h
-F:	include/linux/net/intel/iidc.h
+F:	include/linux/net/intel/
+F:	include/linux/net/intel/*/
 
 INTEL ETHERNET PROTOCOL DRIVER FOR RDMA
 M:	Mustafa Ismail <mustafa.ismail@intel.com>
diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 9bc0a9519899..cec4a938fbd0 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -84,6 +84,12 @@ config E1000E_HWTS
 	 devices. The cross-timestamp is available through the PTP clock
 	 driver precise cross-timestamp ioctl (PTP_SYS_OFFSET_PRECISE).
 
+config LIBIE
+	tristate
+	help
+	  libie (Intel Ethernet library) is a common library containing
+	  routines shared by several Intel Ethernet drivers.
+
 config IGB
 	tristate "Intel(R) 82575/82576 PCI-Express Gigabit Ethernet support"
 	depends on PCI
@@ -225,6 +231,7 @@ config I40E
 	depends on PTP_1588_CLOCK_OPTIONAL
 	depends on PCI
 	select AUXILIARY_BUS
+	select LIBIE
 	help
 	  This driver supports Intel(R) Ethernet Controller XL710 Family of
 	  devices.  For more information on how to identify your adapter, go
@@ -254,8 +261,9 @@ config IAVF
 	tristate
 config I40EVF
 	tristate "Intel(R) Ethernet Adaptive Virtual Function support"
-	select IAVF
 	depends on PCI_MSI
+	select IAVF
+	select LIBIE
 	help
 	  This driver supports virtual functions for Intel XL710,
 	  X710, X722, XXV710, and all devices advertising support for
@@ -282,6 +290,7 @@ config ICE
 	depends on GNSS || GNSS = n
 	select AUXILIARY_BUS
 	select DIMLIB
+	select LIBIE
 	select NET_DEVLINK
 	select PLDMFW
 	help
diff --git a/drivers/net/ethernet/intel/Makefile b/drivers/net/ethernet/intel/Makefile
index d80d04132073..ce622b4d825d 100644
--- a/drivers/net/ethernet/intel/Makefile
+++ b/drivers/net/ethernet/intel/Makefile
@@ -15,3 +15,4 @@ obj-$(CONFIG_I40E) += i40e/
 obj-$(CONFIG_IAVF) += iavf/
 obj-$(CONFIG_FM10K) += fm10k/
 obj-$(CONFIG_ICE) += ice/
+obj-$(CONFIG_LIBIE) += libie/
diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index ed88e38d488b..25bb858268fc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -383,259 +383,6 @@ int i40e_aq_set_rss_key(struct i40e_hw *hw,
 	return i40e_aq_get_set_rss_key(hw, vsi_id, key, true);
 }
 
-/* The i40e_ptype_lookup table is used to convert from the 8-bit ptype in the
- * hardware to a bit-field that can be used by SW to more easily determine the
- * packet type.
- *
- * Macros are used to shorten the table lines and make this table human
- * readable.
- *
- * We store the PTYPE in the top byte of the bit field - this is just so that
- * we can check that the table doesn't have a row missing, as the index into
- * the table should be the PTYPE.
- *
- * Typical work flow:
- *
- * IF NOT i40e_ptype_lookup[ptype].known
- * THEN
- *      Packet is unknown
- * ELSE IF i40e_ptype_lookup[ptype].outer_ip == I40E_RX_PTYPE_OUTER_IP
- *      Use the rest of the fields to look at the tunnels, inner protocols, etc
- * ELSE
- *      Use the enum i40e_rx_l2_ptype to decode the packet type
- * ENDIF
- */
-
-/* macro to make the table lines short, use explicit indexing with [PTYPE] */
-#define I40E_PTT(PTYPE, OUTER_IP, OUTER_IP_VER, OUTER_FRAG, T, TE, TEF, I, PL)\
-	[PTYPE] = { \
-		1, \
-		I40E_RX_PTYPE_OUTER_##OUTER_IP, \
-		I40E_RX_PTYPE_OUTER_##OUTER_IP_VER, \
-		I40E_RX_PTYPE_##OUTER_FRAG, \
-		I40E_RX_PTYPE_TUNNEL_##T, \
-		I40E_RX_PTYPE_TUNNEL_END_##TE, \
-		I40E_RX_PTYPE_##TEF, \
-		I40E_RX_PTYPE_INNER_PROT_##I, \
-		I40E_RX_PTYPE_PAYLOAD_LAYER_##PL }
-
-#define I40E_PTT_UNUSED_ENTRY(PTYPE) [PTYPE] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
-
-/* shorter macros makes the table fit but are terse */
-#define I40E_RX_PTYPE_NOF		I40E_RX_PTYPE_NOT_FRAG
-#define I40E_RX_PTYPE_FRG		I40E_RX_PTYPE_FRAG
-#define I40E_RX_PTYPE_INNER_PROT_TS	I40E_RX_PTYPE_INNER_PROT_TIMESYNC
-
-/* Lookup table mapping in the 8-bit HW PTYPE to the bit field for decoding */
-struct i40e_rx_ptype_decoded i40e_ptype_lookup[BIT(8)] = {
-	/* L2 Packet types */
-	I40E_PTT_UNUSED_ENTRY(0),
-	I40E_PTT(1,  L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),
-	I40E_PTT(2,  L2, NONE, NOF, NONE, NONE, NOF, TS,   PAY2),
-	I40E_PTT(3,  L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),
-	I40E_PTT_UNUSED_ENTRY(4),
-	I40E_PTT_UNUSED_ENTRY(5),
-	I40E_PTT(6,  L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),
-	I40E_PTT(7,  L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),
-	I40E_PTT_UNUSED_ENTRY(8),
-	I40E_PTT_UNUSED_ENTRY(9),
-	I40E_PTT(10, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),
-	I40E_PTT(11, L2, NONE, NOF, NONE, NONE, NOF, NONE, NONE),
-	I40E_PTT(12, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-	I40E_PTT(13, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-	I40E_PTT(14, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-	I40E_PTT(15, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-	I40E_PTT(16, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-	I40E_PTT(17, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-	I40E_PTT(18, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-	I40E_PTT(19, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-	I40E_PTT(20, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-	I40E_PTT(21, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-
-	/* Non Tunneled IPv4 */
-	I40E_PTT(22, IP, IPV4, FRG, NONE, NONE, NOF, NONE, PAY3),
-	I40E_PTT(23, IP, IPV4, NOF, NONE, NONE, NOF, NONE, PAY3),
-	I40E_PTT(24, IP, IPV4, NOF, NONE, NONE, NOF, UDP,  PAY4),
-	I40E_PTT_UNUSED_ENTRY(25),
-	I40E_PTT(26, IP, IPV4, NOF, NONE, NONE, NOF, TCP,  PAY4),
-	I40E_PTT(27, IP, IPV4, NOF, NONE, NONE, NOF, SCTP, PAY4),
-	I40E_PTT(28, IP, IPV4, NOF, NONE, NONE, NOF, ICMP, PAY4),
-
-	/* IPv4 --> IPv4 */
-	I40E_PTT(29, IP, IPV4, NOF, IP_IP, IPV4, FRG, NONE, PAY3),
-	I40E_PTT(30, IP, IPV4, NOF, IP_IP, IPV4, NOF, NONE, PAY3),
-	I40E_PTT(31, IP, IPV4, NOF, IP_IP, IPV4, NOF, UDP,  PAY4),
-	I40E_PTT_UNUSED_ENTRY(32),
-	I40E_PTT(33, IP, IPV4, NOF, IP_IP, IPV4, NOF, TCP,  PAY4),
-	I40E_PTT(34, IP, IPV4, NOF, IP_IP, IPV4, NOF, SCTP, PAY4),
-	I40E_PTT(35, IP, IPV4, NOF, IP_IP, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv4 --> IPv6 */
-	I40E_PTT(36, IP, IPV4, NOF, IP_IP, IPV6, FRG, NONE, PAY3),
-	I40E_PTT(37, IP, IPV4, NOF, IP_IP, IPV6, NOF, NONE, PAY3),
-	I40E_PTT(38, IP, IPV4, NOF, IP_IP, IPV6, NOF, UDP,  PAY4),
-	I40E_PTT_UNUSED_ENTRY(39),
-	I40E_PTT(40, IP, IPV4, NOF, IP_IP, IPV6, NOF, TCP,  PAY4),
-	I40E_PTT(41, IP, IPV4, NOF, IP_IP, IPV6, NOF, SCTP, PAY4),
-	I40E_PTT(42, IP, IPV4, NOF, IP_IP, IPV6, NOF, ICMP, PAY4),
-
-	/* IPv4 --> GRE/NAT */
-	I40E_PTT(43, IP, IPV4, NOF, IP_GRENAT, NONE, NOF, NONE, PAY3),
-
-	/* IPv4 --> GRE/NAT --> IPv4 */
-	I40E_PTT(44, IP, IPV4, NOF, IP_GRENAT, IPV4, FRG, NONE, PAY3),
-	I40E_PTT(45, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, NONE, PAY3),
-	I40E_PTT(46, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, UDP,  PAY4),
-	I40E_PTT_UNUSED_ENTRY(47),
-	I40E_PTT(48, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, TCP,  PAY4),
-	I40E_PTT(49, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, SCTP, PAY4),
-	I40E_PTT(50, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv4 --> GRE/NAT --> IPv6 */
-	I40E_PTT(51, IP, IPV4, NOF, IP_GRENAT, IPV6, FRG, NONE, PAY3),
-	I40E_PTT(52, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, NONE, PAY3),
-	I40E_PTT(53, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, UDP,  PAY4),
-	I40E_PTT_UNUSED_ENTRY(54),
-	I40E_PTT(55, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, TCP,  PAY4),
-	I40E_PTT(56, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, SCTP, PAY4),
-	I40E_PTT(57, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, ICMP, PAY4),
-
-	/* IPv4 --> GRE/NAT --> MAC */
-	I40E_PTT(58, IP, IPV4, NOF, IP_GRENAT_MAC, NONE, NOF, NONE, PAY3),
-
-	/* IPv4 --> GRE/NAT --> MAC --> IPv4 */
-	I40E_PTT(59, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, FRG, NONE, PAY3),
-	I40E_PTT(60, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, NONE, PAY3),
-	I40E_PTT(61, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, UDP,  PAY4),
-	I40E_PTT_UNUSED_ENTRY(62),
-	I40E_PTT(63, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, TCP,  PAY4),
-	I40E_PTT(64, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, SCTP, PAY4),
-	I40E_PTT(65, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv4 --> GRE/NAT -> MAC --> IPv6 */
-	I40E_PTT(66, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, FRG, NONE, PAY3),
-	I40E_PTT(67, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, NONE, PAY3),
-	I40E_PTT(68, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, UDP,  PAY4),
-	I40E_PTT_UNUSED_ENTRY(69),
-	I40E_PTT(70, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, TCP,  PAY4),
-	I40E_PTT(71, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, SCTP, PAY4),
-	I40E_PTT(72, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, ICMP, PAY4),
-
-	/* IPv4 --> GRE/NAT --> MAC/VLAN */
-	I40E_PTT(73, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, NONE, NOF, NONE, PAY3),
-
-	/* IPv4 ---> GRE/NAT -> MAC/VLAN --> IPv4 */
-	I40E_PTT(74, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, FRG, NONE, PAY3),
-	I40E_PTT(75, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, NONE, PAY3),
-	I40E_PTT(76, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, UDP,  PAY4),
-	I40E_PTT_UNUSED_ENTRY(77),
-	I40E_PTT(78, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, TCP,  PAY4),
-	I40E_PTT(79, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, SCTP, PAY4),
-	I40E_PTT(80, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv4 -> GRE/NAT -> MAC/VLAN --> IPv6 */
-	I40E_PTT(81, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, FRG, NONE, PAY3),
-	I40E_PTT(82, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, NONE, PAY3),
-	I40E_PTT(83, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, UDP,  PAY4),
-	I40E_PTT_UNUSED_ENTRY(84),
-	I40E_PTT(85, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, TCP,  PAY4),
-	I40E_PTT(86, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, SCTP, PAY4),
-	I40E_PTT(87, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, ICMP, PAY4),
-
-	/* Non Tunneled IPv6 */
-	I40E_PTT(88, IP, IPV6, FRG, NONE, NONE, NOF, NONE, PAY3),
-	I40E_PTT(89, IP, IPV6, NOF, NONE, NONE, NOF, NONE, PAY3),
-	I40E_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY4),
-	I40E_PTT_UNUSED_ENTRY(91),
-	I40E_PTT(92, IP, IPV6, NOF, NONE, NONE, NOF, TCP,  PAY4),
-	I40E_PTT(93, IP, IPV6, NOF, NONE, NONE, NOF, SCTP, PAY4),
-	I40E_PTT(94, IP, IPV6, NOF, NONE, NONE, NOF, ICMP, PAY4),
-
-	/* IPv6 --> IPv4 */
-	I40E_PTT(95,  IP, IPV6, NOF, IP_IP, IPV4, FRG, NONE, PAY3),
-	I40E_PTT(96,  IP, IPV6, NOF, IP_IP, IPV4, NOF, NONE, PAY3),
-	I40E_PTT(97,  IP, IPV6, NOF, IP_IP, IPV4, NOF, UDP,  PAY4),
-	I40E_PTT_UNUSED_ENTRY(98),
-	I40E_PTT(99,  IP, IPV6, NOF, IP_IP, IPV4, NOF, TCP,  PAY4),
-	I40E_PTT(100, IP, IPV6, NOF, IP_IP, IPV4, NOF, SCTP, PAY4),
-	I40E_PTT(101, IP, IPV6, NOF, IP_IP, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv6 --> IPv6 */
-	I40E_PTT(102, IP, IPV6, NOF, IP_IP, IPV6, FRG, NONE, PAY3),
-	I40E_PTT(103, IP, IPV6, NOF, IP_IP, IPV6, NOF, NONE, PAY3),
-	I40E_PTT(104, IP, IPV6, NOF, IP_IP, IPV6, NOF, UDP,  PAY4),
-	I40E_PTT_UNUSED_ENTRY(105),
-	I40E_PTT(106, IP, IPV6, NOF, IP_IP, IPV6, NOF, TCP,  PAY4),
-	I40E_PTT(107, IP, IPV6, NOF, IP_IP, IPV6, NOF, SCTP, PAY4),
-	I40E_PTT(108, IP, IPV6, NOF, IP_IP, IPV6, NOF, ICMP, PAY4),
-
-	/* IPv6 --> GRE/NAT */
-	I40E_PTT(109, IP, IPV6, NOF, IP_GRENAT, NONE, NOF, NONE, PAY3),
-
-	/* IPv6 --> GRE/NAT -> IPv4 */
-	I40E_PTT(110, IP, IPV6, NOF, IP_GRENAT, IPV4, FRG, NONE, PAY3),
-	I40E_PTT(111, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, NONE, PAY3),
-	I40E_PTT(112, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, UDP,  PAY4),
-	I40E_PTT_UNUSED_ENTRY(113),
-	I40E_PTT(114, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, TCP,  PAY4),
-	I40E_PTT(115, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, SCTP, PAY4),
-	I40E_PTT(116, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv6 --> GRE/NAT -> IPv6 */
-	I40E_PTT(117, IP, IPV6, NOF, IP_GRENAT, IPV6, FRG, NONE, PAY3),
-	I40E_PTT(118, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, NONE, PAY3),
-	I40E_PTT(119, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, UDP,  PAY4),
-	I40E_PTT_UNUSED_ENTRY(120),
-	I40E_PTT(121, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, TCP,  PAY4),
-	I40E_PTT(122, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, SCTP, PAY4),
-	I40E_PTT(123, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, ICMP, PAY4),
-
-	/* IPv6 --> GRE/NAT -> MAC */
-	I40E_PTT(124, IP, IPV6, NOF, IP_GRENAT_MAC, NONE, NOF, NONE, PAY3),
-
-	/* IPv6 --> GRE/NAT -> MAC -> IPv4 */
-	I40E_PTT(125, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, FRG, NONE, PAY3),
-	I40E_PTT(126, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, NONE, PAY3),
-	I40E_PTT(127, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, UDP,  PAY4),
-	I40E_PTT_UNUSED_ENTRY(128),
-	I40E_PTT(129, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, TCP,  PAY4),
-	I40E_PTT(130, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, SCTP, PAY4),
-	I40E_PTT(131, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv6 --> GRE/NAT -> MAC -> IPv6 */
-	I40E_PTT(132, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, FRG, NONE, PAY3),
-	I40E_PTT(133, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, NONE, PAY3),
-	I40E_PTT(134, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, UDP,  PAY4),
-	I40E_PTT_UNUSED_ENTRY(135),
-	I40E_PTT(136, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, TCP,  PAY4),
-	I40E_PTT(137, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, SCTP, PAY4),
-	I40E_PTT(138, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, ICMP, PAY4),
-
-	/* IPv6 --> GRE/NAT -> MAC/VLAN */
-	I40E_PTT(139, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, NONE, NOF, NONE, PAY3),
-
-	/* IPv6 --> GRE/NAT -> MAC/VLAN --> IPv4 */
-	I40E_PTT(140, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, FRG, NONE, PAY3),
-	I40E_PTT(141, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, NONE, PAY3),
-	I40E_PTT(142, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, UDP,  PAY4),
-	I40E_PTT_UNUSED_ENTRY(143),
-	I40E_PTT(144, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, TCP,  PAY4),
-	I40E_PTT(145, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, SCTP, PAY4),
-	I40E_PTT(146, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv6 --> GRE/NAT -> MAC/VLAN --> IPv6 */
-	I40E_PTT(147, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, FRG, NONE, PAY3),
-	I40E_PTT(148, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, NONE, PAY3),
-	I40E_PTT(149, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, UDP,  PAY4),
-	I40E_PTT_UNUSED_ENTRY(150),
-	I40E_PTT(151, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, TCP,  PAY4),
-	I40E_PTT(152, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, SCTP, PAY4),
-	I40E_PTT(153, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, ICMP, PAY4),
-
-	/* unused entries */
-	[154 ... 255] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
-};
-
 /**
  * i40e_init_shared_code - Initialize the shared code
  * @hw: pointer to hardware structure
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b847bd105b16..f3bca6e9bd18 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -97,6 +97,7 @@ MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all), Debug mask (0x8XXXXXXX
 
 MODULE_AUTHOR("Intel Corporation, <e1000-devel@lists.sourceforge.net>");
 MODULE_DESCRIPTION("Intel(R) Ethernet Connection XL710 Network Driver");
+MODULE_IMPORT_NS(LIBIE);
 MODULE_LICENSE("GPL v2");
 
 static struct workqueue_struct *i40e_wq;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_prototype.h b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
index fe845987d99a..5287d0ef32d5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_prototype.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_prototype.h
@@ -380,13 +380,6 @@ void i40e_set_pci_config_data(struct i40e_hw *hw, u16 link_status);
 
 int i40e_set_mac_type(struct i40e_hw *hw);
 
-extern struct i40e_rx_ptype_decoded i40e_ptype_lookup[];
-
-static inline struct i40e_rx_ptype_decoded decode_rx_desc_ptype(u8 ptype)
-{
-	return i40e_ptype_lookup[ptype];
-}
-
 /**
  * i40e_virtchnl_link_speed - Convert AdminQ link_speed to virtchnl definition
  * @link_speed: the speed to convert
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 8b8bf4880faa..c4b6cdbf3611 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1,8 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
-#include <linux/prefetch.h>
 #include <linux/bpf_trace.h>
+#include <linux/net/intel/libie/rx.h>
+#include <linux/prefetch.h>
 #include <net/mpls.h>
 #include <net/xdp.h>
 #include "i40e.h"
@@ -1758,40 +1759,32 @@ static inline void i40e_rx_checksum(struct i40e_vsi *vsi,
 				    struct sk_buff *skb,
 				    union i40e_rx_desc *rx_desc)
 {
-	struct i40e_rx_ptype_decoded decoded;
+	struct libie_rx_ptype_parsed parsed;
 	u32 rx_error, rx_status;
 	bool ipv4, ipv6;
 	u8 ptype;
 	u64 qword;
 
+	skb->ip_summed = CHECKSUM_NONE;
+
 	qword = le64_to_cpu(rx_desc->wb.qword1.status_error_len);
 	ptype = (qword & I40E_RXD_QW1_PTYPE_MASK) >> I40E_RXD_QW1_PTYPE_SHIFT;
+
+	parsed = libie_parse_rx_ptype(ptype);
+	if (!libie_has_rx_checksum(vsi->netdev, parsed))
+		return;
+
 	rx_error = (qword & I40E_RXD_QW1_ERROR_MASK) >>
 		   I40E_RXD_QW1_ERROR_SHIFT;
 	rx_status = (qword & I40E_RXD_QW1_STATUS_MASK) >>
 		    I40E_RXD_QW1_STATUS_SHIFT;
-	decoded = decode_rx_desc_ptype(ptype);
-
-	skb->ip_summed = CHECKSUM_NONE;
-
-	skb_checksum_none_assert(skb);
-
-	/* Rx csum enabled and ip headers found? */
-	if (!(vsi->netdev->features & NETIF_F_RXCSUM))
-		return;
 
 	/* did the hardware decode the packet and checksum? */
 	if (!(rx_status & BIT(I40E_RX_DESC_STATUS_L3L4P_SHIFT)))
 		return;
 
-	/* both known and outer_ip must be set for the below code to work */
-	if (!(decoded.known && decoded.outer_ip))
-		return;
-
-	ipv4 = (decoded.outer_ip == I40E_RX_PTYPE_OUTER_IP) &&
-	       (decoded.outer_ip_ver == I40E_RX_PTYPE_OUTER_IPV4);
-	ipv6 = (decoded.outer_ip == I40E_RX_PTYPE_OUTER_IP) &&
-	       (decoded.outer_ip_ver == I40E_RX_PTYPE_OUTER_IPV6);
+	ipv4 = parsed.outer_ip == LIBIE_RX_PTYPE_OUTER_IPV4;
+	ipv6 = parsed.outer_ip == LIBIE_RX_PTYPE_OUTER_IPV6;
 
 	if (ipv4 &&
 	    (rx_error & (BIT(I40E_RX_DESC_ERROR_IPE_SHIFT) |
@@ -1819,49 +1812,16 @@ static inline void i40e_rx_checksum(struct i40e_vsi *vsi,
 	 * we need to bump the checksum level by 1 to reflect the fact that
 	 * we are indicating we validated the inner checksum.
 	 */
-	if (decoded.tunnel_type >= I40E_RX_PTYPE_TUNNEL_IP_GRENAT)
+	if (parsed.tunnel_type >= LIBIE_RX_PTYPE_TUNNEL_IP_GRENAT)
 		skb->csum_level = 1;
 
-	/* Only report checksum unnecessary for TCP, UDP, or SCTP */
-	switch (decoded.inner_prot) {
-	case I40E_RX_PTYPE_INNER_PROT_TCP:
-	case I40E_RX_PTYPE_INNER_PROT_UDP:
-	case I40E_RX_PTYPE_INNER_PROT_SCTP:
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-		fallthrough;
-	default:
-		break;
-	}
-
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	return;
 
 checksum_fail:
 	vsi->back->hw_csum_rx_error++;
 }
 
-/**
- * i40e_ptype_to_htype - get a hash type
- * @ptype: the ptype value from the descriptor
- *
- * Returns a hash type to be used by skb_set_hash
- **/
-static inline int i40e_ptype_to_htype(u8 ptype)
-{
-	struct i40e_rx_ptype_decoded decoded = decode_rx_desc_ptype(ptype);
-
-	if (!decoded.known)
-		return PKT_HASH_TYPE_NONE;
-
-	if (decoded.outer_ip == I40E_RX_PTYPE_OUTER_IP &&
-	    decoded.payload_layer == I40E_RX_PTYPE_PAYLOAD_LAYER_PAY4)
-		return PKT_HASH_TYPE_L4;
-	else if (decoded.outer_ip == I40E_RX_PTYPE_OUTER_IP &&
-		 decoded.payload_layer == I40E_RX_PTYPE_PAYLOAD_LAYER_PAY3)
-		return PKT_HASH_TYPE_L3;
-	else
-		return PKT_HASH_TYPE_L2;
-}
-
 /**
  * i40e_rx_hash - set the hash value in the skb
  * @ring: descriptor ring
@@ -1874,17 +1834,19 @@ static inline void i40e_rx_hash(struct i40e_ring *ring,
 				struct sk_buff *skb,
 				u8 rx_ptype)
 {
+	struct libie_rx_ptype_parsed parsed;
 	u32 hash;
 	const __le64 rss_mask =
 		cpu_to_le64((u64)I40E_RX_DESC_FLTSTAT_RSS_HASH <<
 			    I40E_RX_DESC_STATUS_FLTSTAT_SHIFT);
 
-	if (!(ring->netdev->features & NETIF_F_RXHASH))
+	parsed = libie_parse_rx_ptype(rx_ptype);
+	if (!libie_has_rx_hash(ring->netdev, parsed))
 		return;
 
 	if ((rx_desc->wb.qword1.status_error_len & rss_mask) == rss_mask) {
 		hash = le32_to_cpu(rx_desc->wb.qword0.hi_dword.rss);
-		skb_set_hash(skb, hash, i40e_ptype_to_htype(rx_ptype));
+		libie_skb_set_hash(skb, hash, parsed);
 	}
 }
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_type.h b/drivers/net/ethernet/intel/i40e/i40e_type.h
index 388c3d36d96a..05b8510f99a9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_type.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_type.h
@@ -773,94 +773,6 @@ enum i40e_rx_desc_error_l3l4e_fcoe_masks {
 #define I40E_RXD_QW1_PTYPE_SHIFT	30
 #define I40E_RXD_QW1_PTYPE_MASK		(0xFFULL << I40E_RXD_QW1_PTYPE_SHIFT)
 
-/* Packet type non-ip values */
-enum i40e_rx_l2_ptype {
-	I40E_RX_PTYPE_L2_RESERVED			= 0,
-	I40E_RX_PTYPE_L2_MAC_PAY2			= 1,
-	I40E_RX_PTYPE_L2_TIMESYNC_PAY2			= 2,
-	I40E_RX_PTYPE_L2_FIP_PAY2			= 3,
-	I40E_RX_PTYPE_L2_OUI_PAY2			= 4,
-	I40E_RX_PTYPE_L2_MACCNTRL_PAY2			= 5,
-	I40E_RX_PTYPE_L2_LLDP_PAY2			= 6,
-	I40E_RX_PTYPE_L2_ECP_PAY2			= 7,
-	I40E_RX_PTYPE_L2_EVB_PAY2			= 8,
-	I40E_RX_PTYPE_L2_QCN_PAY2			= 9,
-	I40E_RX_PTYPE_L2_EAPOL_PAY2			= 10,
-	I40E_RX_PTYPE_L2_ARP				= 11,
-	I40E_RX_PTYPE_L2_FCOE_PAY3			= 12,
-	I40E_RX_PTYPE_L2_FCOE_FCDATA_PAY3		= 13,
-	I40E_RX_PTYPE_L2_FCOE_FCRDY_PAY3		= 14,
-	I40E_RX_PTYPE_L2_FCOE_FCRSP_PAY3		= 15,
-	I40E_RX_PTYPE_L2_FCOE_FCOTHER_PA		= 16,
-	I40E_RX_PTYPE_L2_FCOE_VFT_PAY3			= 17,
-	I40E_RX_PTYPE_L2_FCOE_VFT_FCDATA		= 18,
-	I40E_RX_PTYPE_L2_FCOE_VFT_FCRDY			= 19,
-	I40E_RX_PTYPE_L2_FCOE_VFT_FCRSP			= 20,
-	I40E_RX_PTYPE_L2_FCOE_VFT_FCOTHER		= 21,
-	I40E_RX_PTYPE_GRENAT4_MAC_PAY3			= 58,
-	I40E_RX_PTYPE_GRENAT4_MACVLAN_IPV6_ICMP_PAY4	= 87,
-	I40E_RX_PTYPE_GRENAT6_MAC_PAY3			= 124,
-	I40E_RX_PTYPE_GRENAT6_MACVLAN_IPV6_ICMP_PAY4	= 153
-};
-
-struct i40e_rx_ptype_decoded {
-	u32 known:1;
-	u32 outer_ip:1;
-	u32 outer_ip_ver:1;
-	u32 outer_frag:1;
-	u32 tunnel_type:3;
-	u32 tunnel_end_prot:2;
-	u32 tunnel_end_frag:1;
-	u32 inner_prot:4;
-	u32 payload_layer:3;
-};
-
-enum i40e_rx_ptype_outer_ip {
-	I40E_RX_PTYPE_OUTER_L2	= 0,
-	I40E_RX_PTYPE_OUTER_IP	= 1
-};
-
-enum i40e_rx_ptype_outer_ip_ver {
-	I40E_RX_PTYPE_OUTER_NONE	= 0,
-	I40E_RX_PTYPE_OUTER_IPV4	= 0,
-	I40E_RX_PTYPE_OUTER_IPV6	= 1
-};
-
-enum i40e_rx_ptype_outer_fragmented {
-	I40E_RX_PTYPE_NOT_FRAG	= 0,
-	I40E_RX_PTYPE_FRAG	= 1
-};
-
-enum i40e_rx_ptype_tunnel_type {
-	I40E_RX_PTYPE_TUNNEL_NONE		= 0,
-	I40E_RX_PTYPE_TUNNEL_IP_IP		= 1,
-	I40E_RX_PTYPE_TUNNEL_IP_GRENAT		= 2,
-	I40E_RX_PTYPE_TUNNEL_IP_GRENAT_MAC	= 3,
-	I40E_RX_PTYPE_TUNNEL_IP_GRENAT_MAC_VLAN	= 4,
-};
-
-enum i40e_rx_ptype_tunnel_end_prot {
-	I40E_RX_PTYPE_TUNNEL_END_NONE	= 0,
-	I40E_RX_PTYPE_TUNNEL_END_IPV4	= 1,
-	I40E_RX_PTYPE_TUNNEL_END_IPV6	= 2,
-};
-
-enum i40e_rx_ptype_inner_prot {
-	I40E_RX_PTYPE_INNER_PROT_NONE		= 0,
-	I40E_RX_PTYPE_INNER_PROT_UDP		= 1,
-	I40E_RX_PTYPE_INNER_PROT_TCP		= 2,
-	I40E_RX_PTYPE_INNER_PROT_SCTP		= 3,
-	I40E_RX_PTYPE_INNER_PROT_ICMP		= 4,
-	I40E_RX_PTYPE_INNER_PROT_TIMESYNC	= 5
-};
-
-enum i40e_rx_ptype_payload_layer {
-	I40E_RX_PTYPE_PAYLOAD_LAYER_NONE	= 0,
-	I40E_RX_PTYPE_PAYLOAD_LAYER_PAY2	= 1,
-	I40E_RX_PTYPE_PAYLOAD_LAYER_PAY3	= 2,
-	I40E_RX_PTYPE_PAYLOAD_LAYER_PAY4	= 3,
-};
-
 #define I40E_RXD_QW1_LENGTH_PBUF_SHIFT	38
 #define I40E_RXD_QW1_LENGTH_PBUF_MASK	(0x3FFFULL << \
 					 I40E_RXD_QW1_LENGTH_PBUF_SHIFT)
diff --git a/drivers/net/ethernet/intel/iavf/iavf_common.c b/drivers/net/ethernet/intel/iavf/iavf_common.c
index dd11dbbd5551..ba6c9f154d18 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_common.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_common.c
@@ -499,259 +499,6 @@ enum iavf_status iavf_aq_set_rss_key(struct iavf_hw *hw, u16 vsi_id,
 	return iavf_aq_get_set_rss_key(hw, vsi_id, key, true);
 }
 
-/* The iavf_ptype_lookup table is used to convert from the 8-bit ptype in the
- * hardware to a bit-field that can be used by SW to more easily determine the
- * packet type.
- *
- * Macros are used to shorten the table lines and make this table human
- * readable.
- *
- * We store the PTYPE in the top byte of the bit field - this is just so that
- * we can check that the table doesn't have a row missing, as the index into
- * the table should be the PTYPE.
- *
- * Typical work flow:
- *
- * IF NOT iavf_ptype_lookup[ptype].known
- * THEN
- *      Packet is unknown
- * ELSE IF iavf_ptype_lookup[ptype].outer_ip == IAVF_RX_PTYPE_OUTER_IP
- *      Use the rest of the fields to look at the tunnels, inner protocols, etc
- * ELSE
- *      Use the enum iavf_rx_l2_ptype to decode the packet type
- * ENDIF
- */
-
-/* macro to make the table lines short, use explicit indexing with [PTYPE] */
-#define IAVF_PTT(PTYPE, OUTER_IP, OUTER_IP_VER, OUTER_FRAG, T, TE, TEF, I, PL)\
-	[PTYPE] = { \
-		1, \
-		IAVF_RX_PTYPE_OUTER_##OUTER_IP, \
-		IAVF_RX_PTYPE_OUTER_##OUTER_IP_VER, \
-		IAVF_RX_PTYPE_##OUTER_FRAG, \
-		IAVF_RX_PTYPE_TUNNEL_##T, \
-		IAVF_RX_PTYPE_TUNNEL_END_##TE, \
-		IAVF_RX_PTYPE_##TEF, \
-		IAVF_RX_PTYPE_INNER_PROT_##I, \
-		IAVF_RX_PTYPE_PAYLOAD_LAYER_##PL }
-
-#define IAVF_PTT_UNUSED_ENTRY(PTYPE) [PTYPE] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
-
-/* shorter macros makes the table fit but are terse */
-#define IAVF_RX_PTYPE_NOF		IAVF_RX_PTYPE_NOT_FRAG
-#define IAVF_RX_PTYPE_FRG		IAVF_RX_PTYPE_FRAG
-#define IAVF_RX_PTYPE_INNER_PROT_TS	IAVF_RX_PTYPE_INNER_PROT_TIMESYNC
-
-/* Lookup table mapping the 8-bit HW PTYPE to the bit field for decoding */
-struct iavf_rx_ptype_decoded iavf_ptype_lookup[BIT(8)] = {
-	/* L2 Packet types */
-	IAVF_PTT_UNUSED_ENTRY(0),
-	IAVF_PTT(1,  L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),
-	IAVF_PTT(2,  L2, NONE, NOF, NONE, NONE, NOF, TS,   PAY2),
-	IAVF_PTT(3,  L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),
-	IAVF_PTT_UNUSED_ENTRY(4),
-	IAVF_PTT_UNUSED_ENTRY(5),
-	IAVF_PTT(6,  L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),
-	IAVF_PTT(7,  L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),
-	IAVF_PTT_UNUSED_ENTRY(8),
-	IAVF_PTT_UNUSED_ENTRY(9),
-	IAVF_PTT(10, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),
-	IAVF_PTT(11, L2, NONE, NOF, NONE, NONE, NOF, NONE, NONE),
-	IAVF_PTT(12, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-	IAVF_PTT(13, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-	IAVF_PTT(14, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-	IAVF_PTT(15, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-	IAVF_PTT(16, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-	IAVF_PTT(17, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-	IAVF_PTT(18, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-	IAVF_PTT(19, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-	IAVF_PTT(20, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-	IAVF_PTT(21, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY3),
-
-	/* Non Tunneled IPv4 */
-	IAVF_PTT(22, IP, IPV4, FRG, NONE, NONE, NOF, NONE, PAY3),
-	IAVF_PTT(23, IP, IPV4, NOF, NONE, NONE, NOF, NONE, PAY3),
-	IAVF_PTT(24, IP, IPV4, NOF, NONE, NONE, NOF, UDP,  PAY4),
-	IAVF_PTT_UNUSED_ENTRY(25),
-	IAVF_PTT(26, IP, IPV4, NOF, NONE, NONE, NOF, TCP,  PAY4),
-	IAVF_PTT(27, IP, IPV4, NOF, NONE, NONE, NOF, SCTP, PAY4),
-	IAVF_PTT(28, IP, IPV4, NOF, NONE, NONE, NOF, ICMP, PAY4),
-
-	/* IPv4 --> IPv4 */
-	IAVF_PTT(29, IP, IPV4, NOF, IP_IP, IPV4, FRG, NONE, PAY3),
-	IAVF_PTT(30, IP, IPV4, NOF, IP_IP, IPV4, NOF, NONE, PAY3),
-	IAVF_PTT(31, IP, IPV4, NOF, IP_IP, IPV4, NOF, UDP,  PAY4),
-	IAVF_PTT_UNUSED_ENTRY(32),
-	IAVF_PTT(33, IP, IPV4, NOF, IP_IP, IPV4, NOF, TCP,  PAY4),
-	IAVF_PTT(34, IP, IPV4, NOF, IP_IP, IPV4, NOF, SCTP, PAY4),
-	IAVF_PTT(35, IP, IPV4, NOF, IP_IP, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv4 --> IPv6 */
-	IAVF_PTT(36, IP, IPV4, NOF, IP_IP, IPV6, FRG, NONE, PAY3),
-	IAVF_PTT(37, IP, IPV4, NOF, IP_IP, IPV6, NOF, NONE, PAY3),
-	IAVF_PTT(38, IP, IPV4, NOF, IP_IP, IPV6, NOF, UDP,  PAY4),
-	IAVF_PTT_UNUSED_ENTRY(39),
-	IAVF_PTT(40, IP, IPV4, NOF, IP_IP, IPV6, NOF, TCP,  PAY4),
-	IAVF_PTT(41, IP, IPV4, NOF, IP_IP, IPV6, NOF, SCTP, PAY4),
-	IAVF_PTT(42, IP, IPV4, NOF, IP_IP, IPV6, NOF, ICMP, PAY4),
-
-	/* IPv4 --> GRE/NAT */
-	IAVF_PTT(43, IP, IPV4, NOF, IP_GRENAT, NONE, NOF, NONE, PAY3),
-
-	/* IPv4 --> GRE/NAT --> IPv4 */
-	IAVF_PTT(44, IP, IPV4, NOF, IP_GRENAT, IPV4, FRG, NONE, PAY3),
-	IAVF_PTT(45, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, NONE, PAY3),
-	IAVF_PTT(46, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, UDP,  PAY4),
-	IAVF_PTT_UNUSED_ENTRY(47),
-	IAVF_PTT(48, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, TCP,  PAY4),
-	IAVF_PTT(49, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, SCTP, PAY4),
-	IAVF_PTT(50, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv4 --> GRE/NAT --> IPv6 */
-	IAVF_PTT(51, IP, IPV4, NOF, IP_GRENAT, IPV6, FRG, NONE, PAY3),
-	IAVF_PTT(52, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, NONE, PAY3),
-	IAVF_PTT(53, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, UDP,  PAY4),
-	IAVF_PTT_UNUSED_ENTRY(54),
-	IAVF_PTT(55, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, TCP,  PAY4),
-	IAVF_PTT(56, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, SCTP, PAY4),
-	IAVF_PTT(57, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, ICMP, PAY4),
-
-	/* IPv4 --> GRE/NAT --> MAC */
-	IAVF_PTT(58, IP, IPV4, NOF, IP_GRENAT_MAC, NONE, NOF, NONE, PAY3),
-
-	/* IPv4 --> GRE/NAT --> MAC --> IPv4 */
-	IAVF_PTT(59, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, FRG, NONE, PAY3),
-	IAVF_PTT(60, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, NONE, PAY3),
-	IAVF_PTT(61, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, UDP,  PAY4),
-	IAVF_PTT_UNUSED_ENTRY(62),
-	IAVF_PTT(63, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, TCP,  PAY4),
-	IAVF_PTT(64, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, SCTP, PAY4),
-	IAVF_PTT(65, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv4 --> GRE/NAT -> MAC --> IPv6 */
-	IAVF_PTT(66, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, FRG, NONE, PAY3),
-	IAVF_PTT(67, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, NONE, PAY3),
-	IAVF_PTT(68, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, UDP,  PAY4),
-	IAVF_PTT_UNUSED_ENTRY(69),
-	IAVF_PTT(70, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, TCP,  PAY4),
-	IAVF_PTT(71, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, SCTP, PAY4),
-	IAVF_PTT(72, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, ICMP, PAY4),
-
-	/* IPv4 --> GRE/NAT --> MAC/VLAN */
-	IAVF_PTT(73, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, NONE, NOF, NONE, PAY3),
-
-	/* IPv4 ---> GRE/NAT -> MAC/VLAN --> IPv4 */
-	IAVF_PTT(74, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, FRG, NONE, PAY3),
-	IAVF_PTT(75, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, NONE, PAY3),
-	IAVF_PTT(76, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, UDP,  PAY4),
-	IAVF_PTT_UNUSED_ENTRY(77),
-	IAVF_PTT(78, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, TCP,  PAY4),
-	IAVF_PTT(79, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, SCTP, PAY4),
-	IAVF_PTT(80, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv4 -> GRE/NAT -> MAC/VLAN --> IPv6 */
-	IAVF_PTT(81, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, FRG, NONE, PAY3),
-	IAVF_PTT(82, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, NONE, PAY3),
-	IAVF_PTT(83, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, UDP,  PAY4),
-	IAVF_PTT_UNUSED_ENTRY(84),
-	IAVF_PTT(85, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, TCP,  PAY4),
-	IAVF_PTT(86, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, SCTP, PAY4),
-	IAVF_PTT(87, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, ICMP, PAY4),
-
-	/* Non Tunneled IPv6 */
-	IAVF_PTT(88, IP, IPV6, FRG, NONE, NONE, NOF, NONE, PAY3),
-	IAVF_PTT(89, IP, IPV6, NOF, NONE, NONE, NOF, NONE, PAY3),
-	IAVF_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY4),
-	IAVF_PTT_UNUSED_ENTRY(91),
-	IAVF_PTT(92, IP, IPV6, NOF, NONE, NONE, NOF, TCP,  PAY4),
-	IAVF_PTT(93, IP, IPV6, NOF, NONE, NONE, NOF, SCTP, PAY4),
-	IAVF_PTT(94, IP, IPV6, NOF, NONE, NONE, NOF, ICMP, PAY4),
-
-	/* IPv6 --> IPv4 */
-	IAVF_PTT(95,  IP, IPV6, NOF, IP_IP, IPV4, FRG, NONE, PAY3),
-	IAVF_PTT(96,  IP, IPV6, NOF, IP_IP, IPV4, NOF, NONE, PAY3),
-	IAVF_PTT(97,  IP, IPV6, NOF, IP_IP, IPV4, NOF, UDP,  PAY4),
-	IAVF_PTT_UNUSED_ENTRY(98),
-	IAVF_PTT(99,  IP, IPV6, NOF, IP_IP, IPV4, NOF, TCP,  PAY4),
-	IAVF_PTT(100, IP, IPV6, NOF, IP_IP, IPV4, NOF, SCTP, PAY4),
-	IAVF_PTT(101, IP, IPV6, NOF, IP_IP, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv6 --> IPv6 */
-	IAVF_PTT(102, IP, IPV6, NOF, IP_IP, IPV6, FRG, NONE, PAY3),
-	IAVF_PTT(103, IP, IPV6, NOF, IP_IP, IPV6, NOF, NONE, PAY3),
-	IAVF_PTT(104, IP, IPV6, NOF, IP_IP, IPV6, NOF, UDP,  PAY4),
-	IAVF_PTT_UNUSED_ENTRY(105),
-	IAVF_PTT(106, IP, IPV6, NOF, IP_IP, IPV6, NOF, TCP,  PAY4),
-	IAVF_PTT(107, IP, IPV6, NOF, IP_IP, IPV6, NOF, SCTP, PAY4),
-	IAVF_PTT(108, IP, IPV6, NOF, IP_IP, IPV6, NOF, ICMP, PAY4),
-
-	/* IPv6 --> GRE/NAT */
-	IAVF_PTT(109, IP, IPV6, NOF, IP_GRENAT, NONE, NOF, NONE, PAY3),
-
-	/* IPv6 --> GRE/NAT -> IPv4 */
-	IAVF_PTT(110, IP, IPV6, NOF, IP_GRENAT, IPV4, FRG, NONE, PAY3),
-	IAVF_PTT(111, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, NONE, PAY3),
-	IAVF_PTT(112, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, UDP,  PAY4),
-	IAVF_PTT_UNUSED_ENTRY(113),
-	IAVF_PTT(114, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, TCP,  PAY4),
-	IAVF_PTT(115, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, SCTP, PAY4),
-	IAVF_PTT(116, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv6 --> GRE/NAT -> IPv6 */
-	IAVF_PTT(117, IP, IPV6, NOF, IP_GRENAT, IPV6, FRG, NONE, PAY3),
-	IAVF_PTT(118, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, NONE, PAY3),
-	IAVF_PTT(119, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, UDP,  PAY4),
-	IAVF_PTT_UNUSED_ENTRY(120),
-	IAVF_PTT(121, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, TCP,  PAY4),
-	IAVF_PTT(122, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, SCTP, PAY4),
-	IAVF_PTT(123, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, ICMP, PAY4),
-
-	/* IPv6 --> GRE/NAT -> MAC */
-	IAVF_PTT(124, IP, IPV6, NOF, IP_GRENAT_MAC, NONE, NOF, NONE, PAY3),
-
-	/* IPv6 --> GRE/NAT -> MAC -> IPv4 */
-	IAVF_PTT(125, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, FRG, NONE, PAY3),
-	IAVF_PTT(126, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, NONE, PAY3),
-	IAVF_PTT(127, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, UDP,  PAY4),
-	IAVF_PTT_UNUSED_ENTRY(128),
-	IAVF_PTT(129, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, TCP,  PAY4),
-	IAVF_PTT(130, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, SCTP, PAY4),
-	IAVF_PTT(131, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv6 --> GRE/NAT -> MAC -> IPv6 */
-	IAVF_PTT(132, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, FRG, NONE, PAY3),
-	IAVF_PTT(133, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, NONE, PAY3),
-	IAVF_PTT(134, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, UDP,  PAY4),
-	IAVF_PTT_UNUSED_ENTRY(135),
-	IAVF_PTT(136, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, TCP,  PAY4),
-	IAVF_PTT(137, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, SCTP, PAY4),
-	IAVF_PTT(138, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, ICMP, PAY4),
-
-	/* IPv6 --> GRE/NAT -> MAC/VLAN */
-	IAVF_PTT(139, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, NONE, NOF, NONE, PAY3),
-
-	/* IPv6 --> GRE/NAT -> MAC/VLAN --> IPv4 */
-	IAVF_PTT(140, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, FRG, NONE, PAY3),
-	IAVF_PTT(141, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, NONE, PAY3),
-	IAVF_PTT(142, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, UDP,  PAY4),
-	IAVF_PTT_UNUSED_ENTRY(143),
-	IAVF_PTT(144, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, TCP,  PAY4),
-	IAVF_PTT(145, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, SCTP, PAY4),
-	IAVF_PTT(146, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv6 --> GRE/NAT -> MAC/VLAN --> IPv6 */
-	IAVF_PTT(147, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, FRG, NONE, PAY3),
-	IAVF_PTT(148, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, NONE, PAY3),
-	IAVF_PTT(149, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, UDP,  PAY4),
-	IAVF_PTT_UNUSED_ENTRY(150),
-	IAVF_PTT(151, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, TCP,  PAY4),
-	IAVF_PTT(152, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, SCTP, PAY4),
-	IAVF_PTT(153, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, ICMP, PAY4),
-
-	/* unused entries */
-	[154 ... 255] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
-};
-
 /**
  * iavf_aq_send_msg_to_pf
  * @hw: pointer to the hardware structure
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 2de4baff4c20..c17e909d3ff0 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -46,6 +46,7 @@ MODULE_DEVICE_TABLE(pci, iavf_pci_tbl);
 MODULE_ALIAS("i40evf");
 MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
 MODULE_DESCRIPTION("Intel(R) Ethernet Adaptive Virtual Function Network Driver");
+MODULE_IMPORT_NS(LIBIE);
 MODULE_LICENSE("GPL v2");
 
 static const struct net_device_ops iavf_netdev_ops;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_prototype.h b/drivers/net/ethernet/intel/iavf/iavf_prototype.h
index edebfbbcffdc..c2e5dbc0a75a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_prototype.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_prototype.h
@@ -51,13 +51,6 @@ enum iavf_status iavf_aq_set_rss_key(struct iavf_hw *hw, u16 seid,
 
 enum iavf_status iavf_set_mac_type(struct iavf_hw *hw);
 
-extern struct iavf_rx_ptype_decoded iavf_ptype_lookup[];
-
-static inline struct iavf_rx_ptype_decoded decode_rx_desc_ptype(u8 ptype)
-{
-	return iavf_ptype_lookup[ptype];
-}
-
 void iavf_vf_parse_hw_config(struct iavf_hw *hw,
 			     struct virtchnl_vf_resource *msg);
 enum iavf_status iavf_vf_reset(struct iavf_hw *hw);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index e989feda133c..a83b96e9b6fc 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
+#include <linux/net/intel/libie/rx.h>
 #include <linux/prefetch.h>
 
 #include "iavf.h"
@@ -982,40 +983,32 @@ static inline void iavf_rx_checksum(struct iavf_vsi *vsi,
 				    struct sk_buff *skb,
 				    union iavf_rx_desc *rx_desc)
 {
-	struct iavf_rx_ptype_decoded decoded;
+	struct libie_rx_ptype_parsed parsed;
 	u32 rx_error, rx_status;
 	bool ipv4, ipv6;
 	u8 ptype;
 	u64 qword;
 
+	skb->ip_summed = CHECKSUM_NONE;
+
 	qword = le64_to_cpu(rx_desc->wb.qword1.status_error_len);
 	ptype = (qword & IAVF_RXD_QW1_PTYPE_MASK) >> IAVF_RXD_QW1_PTYPE_SHIFT;
+
+	parsed = libie_parse_rx_ptype(ptype);
+	if (!libie_has_rx_checksum(vsi->netdev, parsed))
+		return;
+
 	rx_error = (qword & IAVF_RXD_QW1_ERROR_MASK) >>
 		   IAVF_RXD_QW1_ERROR_SHIFT;
 	rx_status = (qword & IAVF_RXD_QW1_STATUS_MASK) >>
 		    IAVF_RXD_QW1_STATUS_SHIFT;
-	decoded = decode_rx_desc_ptype(ptype);
-
-	skb->ip_summed = CHECKSUM_NONE;
-
-	skb_checksum_none_assert(skb);
-
-	/* Rx csum enabled and ip headers found? */
-	if (!(vsi->netdev->features & NETIF_F_RXCSUM))
-		return;
 
 	/* did the hardware decode the packet and checksum? */
 	if (!(rx_status & BIT(IAVF_RX_DESC_STATUS_L3L4P_SHIFT)))
 		return;
 
-	/* both known and outer_ip must be set for the below code to work */
-	if (!(decoded.known && decoded.outer_ip))
-		return;
-
-	ipv4 = (decoded.outer_ip == IAVF_RX_PTYPE_OUTER_IP) &&
-	       (decoded.outer_ip_ver == IAVF_RX_PTYPE_OUTER_IPV4);
-	ipv6 = (decoded.outer_ip == IAVF_RX_PTYPE_OUTER_IP) &&
-	       (decoded.outer_ip_ver == IAVF_RX_PTYPE_OUTER_IPV6);
+	ipv4 = parsed.outer_ip == LIBIE_RX_PTYPE_OUTER_IPV4;
+	ipv6 = parsed.outer_ip == LIBIE_RX_PTYPE_OUTER_IPV6;
 
 	if (ipv4 &&
 	    (rx_error & (BIT(IAVF_RX_DESC_ERROR_IPE_SHIFT) |
@@ -1039,46 +1032,13 @@ static inline void iavf_rx_checksum(struct iavf_vsi *vsi,
 	if (rx_error & BIT(IAVF_RX_DESC_ERROR_PPRS_SHIFT))
 		return;
 
-	/* Only report checksum unnecessary for TCP, UDP, or SCTP */
-	switch (decoded.inner_prot) {
-	case IAVF_RX_PTYPE_INNER_PROT_TCP:
-	case IAVF_RX_PTYPE_INNER_PROT_UDP:
-	case IAVF_RX_PTYPE_INNER_PROT_SCTP:
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-		fallthrough;
-	default:
-		break;
-	}
-
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	return;
 
 checksum_fail:
 	vsi->back->hw_csum_rx_error++;
 }
 
-/**
- * iavf_ptype_to_htype - get a hash type
- * @ptype: the ptype value from the descriptor
- *
- * Returns a hash type to be used by skb_set_hash
- **/
-static inline int iavf_ptype_to_htype(u8 ptype)
-{
-	struct iavf_rx_ptype_decoded decoded = decode_rx_desc_ptype(ptype);
-
-	if (!decoded.known)
-		return PKT_HASH_TYPE_NONE;
-
-	if (decoded.outer_ip == IAVF_RX_PTYPE_OUTER_IP &&
-	    decoded.payload_layer == IAVF_RX_PTYPE_PAYLOAD_LAYER_PAY4)
-		return PKT_HASH_TYPE_L4;
-	else if (decoded.outer_ip == IAVF_RX_PTYPE_OUTER_IP &&
-		 decoded.payload_layer == IAVF_RX_PTYPE_PAYLOAD_LAYER_PAY3)
-		return PKT_HASH_TYPE_L3;
-	else
-		return PKT_HASH_TYPE_L2;
-}
-
 /**
  * iavf_rx_hash - set the hash value in the skb
  * @ring: descriptor ring
@@ -1091,17 +1051,19 @@ static inline void iavf_rx_hash(struct iavf_ring *ring,
 				struct sk_buff *skb,
 				u8 rx_ptype)
 {
+	struct libie_rx_ptype_parsed parsed;
 	u32 hash;
 	const __le64 rss_mask =
 		cpu_to_le64((u64)IAVF_RX_DESC_FLTSTAT_RSS_HASH <<
 			    IAVF_RX_DESC_STATUS_FLTSTAT_SHIFT);
 
-	if (!(ring->netdev->features & NETIF_F_RXHASH))
+	parsed = libie_parse_rx_ptype(rx_ptype);
+	if (!libie_has_rx_hash(ring->netdev, parsed))
 		return;
 
 	if ((rx_desc->wb.qword1.status_error_len & rss_mask) == rss_mask) {
 		hash = le32_to_cpu(rx_desc->wb.qword0.hi_dword.rss);
-		skb_set_hash(skb, hash, iavf_ptype_to_htype(rx_ptype));
+		libie_skb_set_hash(skb, hash, parsed);
 	}
 }
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_type.h b/drivers/net/ethernet/intel/iavf/iavf_type.h
index 9f1f523807c4..3030ba330326 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_type.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_type.h
@@ -339,94 +339,6 @@ enum iavf_rx_desc_error_l3l4e_fcoe_masks {
 #define IAVF_RXD_QW1_PTYPE_SHIFT	30
 #define IAVF_RXD_QW1_PTYPE_MASK		(0xFFULL << IAVF_RXD_QW1_PTYPE_SHIFT)
 
-/* Packet type non-ip values */
-enum iavf_rx_l2_ptype {
-	IAVF_RX_PTYPE_L2_RESERVED			= 0,
-	IAVF_RX_PTYPE_L2_MAC_PAY2			= 1,
-	IAVF_RX_PTYPE_L2_TIMESYNC_PAY2			= 2,
-	IAVF_RX_PTYPE_L2_FIP_PAY2			= 3,
-	IAVF_RX_PTYPE_L2_OUI_PAY2			= 4,
-	IAVF_RX_PTYPE_L2_MACCNTRL_PAY2			= 5,
-	IAVF_RX_PTYPE_L2_LLDP_PAY2			= 6,
-	IAVF_RX_PTYPE_L2_ECP_PAY2			= 7,
-	IAVF_RX_PTYPE_L2_EVB_PAY2			= 8,
-	IAVF_RX_PTYPE_L2_QCN_PAY2			= 9,
-	IAVF_RX_PTYPE_L2_EAPOL_PAY2			= 10,
-	IAVF_RX_PTYPE_L2_ARP				= 11,
-	IAVF_RX_PTYPE_L2_FCOE_PAY3			= 12,
-	IAVF_RX_PTYPE_L2_FCOE_FCDATA_PAY3		= 13,
-	IAVF_RX_PTYPE_L2_FCOE_FCRDY_PAY3		= 14,
-	IAVF_RX_PTYPE_L2_FCOE_FCRSP_PAY3		= 15,
-	IAVF_RX_PTYPE_L2_FCOE_FCOTHER_PA		= 16,
-	IAVF_RX_PTYPE_L2_FCOE_VFT_PAY3			= 17,
-	IAVF_RX_PTYPE_L2_FCOE_VFT_FCDATA		= 18,
-	IAVF_RX_PTYPE_L2_FCOE_VFT_FCRDY			= 19,
-	IAVF_RX_PTYPE_L2_FCOE_VFT_FCRSP			= 20,
-	IAVF_RX_PTYPE_L2_FCOE_VFT_FCOTHER		= 21,
-	IAVF_RX_PTYPE_GRENAT4_MAC_PAY3			= 58,
-	IAVF_RX_PTYPE_GRENAT4_MACVLAN_IPV6_ICMP_PAY4	= 87,
-	IAVF_RX_PTYPE_GRENAT6_MAC_PAY3			= 124,
-	IAVF_RX_PTYPE_GRENAT6_MACVLAN_IPV6_ICMP_PAY4	= 153
-};
-
-struct iavf_rx_ptype_decoded {
-	u32 known:1;
-	u32 outer_ip:1;
-	u32 outer_ip_ver:1;
-	u32 outer_frag:1;
-	u32 tunnel_type:3;
-	u32 tunnel_end_prot:2;
-	u32 tunnel_end_frag:1;
-	u32 inner_prot:4;
-	u32 payload_layer:3;
-};
-
-enum iavf_rx_ptype_outer_ip {
-	IAVF_RX_PTYPE_OUTER_L2	= 0,
-	IAVF_RX_PTYPE_OUTER_IP	= 1
-};
-
-enum iavf_rx_ptype_outer_ip_ver {
-	IAVF_RX_PTYPE_OUTER_NONE	= 0,
-	IAVF_RX_PTYPE_OUTER_IPV4	= 0,
-	IAVF_RX_PTYPE_OUTER_IPV6	= 1
-};
-
-enum iavf_rx_ptype_outer_fragmented {
-	IAVF_RX_PTYPE_NOT_FRAG	= 0,
-	IAVF_RX_PTYPE_FRAG	= 1
-};
-
-enum iavf_rx_ptype_tunnel_type {
-	IAVF_RX_PTYPE_TUNNEL_NONE		= 0,
-	IAVF_RX_PTYPE_TUNNEL_IP_IP		= 1,
-	IAVF_RX_PTYPE_TUNNEL_IP_GRENAT		= 2,
-	IAVF_RX_PTYPE_TUNNEL_IP_GRENAT_MAC	= 3,
-	IAVF_RX_PTYPE_TUNNEL_IP_GRENAT_MAC_VLAN	= 4,
-};
-
-enum iavf_rx_ptype_tunnel_end_prot {
-	IAVF_RX_PTYPE_TUNNEL_END_NONE	= 0,
-	IAVF_RX_PTYPE_TUNNEL_END_IPV4	= 1,
-	IAVF_RX_PTYPE_TUNNEL_END_IPV6	= 2,
-};
-
-enum iavf_rx_ptype_inner_prot {
-	IAVF_RX_PTYPE_INNER_PROT_NONE		= 0,
-	IAVF_RX_PTYPE_INNER_PROT_UDP		= 1,
-	IAVF_RX_PTYPE_INNER_PROT_TCP		= 2,
-	IAVF_RX_PTYPE_INNER_PROT_SCTP		= 3,
-	IAVF_RX_PTYPE_INNER_PROT_ICMP		= 4,
-	IAVF_RX_PTYPE_INNER_PROT_TIMESYNC	= 5
-};
-
-enum iavf_rx_ptype_payload_layer {
-	IAVF_RX_PTYPE_PAYLOAD_LAYER_NONE	= 0,
-	IAVF_RX_PTYPE_PAYLOAD_LAYER_PAY2	= 1,
-	IAVF_RX_PTYPE_PAYLOAD_LAYER_PAY3	= 2,
-	IAVF_RX_PTYPE_PAYLOAD_LAYER_PAY4	= 3,
-};
-
 #define IAVF_RXD_QW1_LENGTH_PBUF_SHIFT	38
 #define IAVF_RXD_QW1_LENGTH_PBUF_MASK	(0x3FFFULL << \
 					 IAVF_RXD_QW1_LENGTH_PBUF_SHIFT)
diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index 89f986a75cc8..611577ebc29d 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -160,64 +160,6 @@ struct ice_fltr_desc {
 				(0x1ULL << ICE_FXD_FLTR_WB_QW1_FAIL_PROF_S)
 #define ICE_FXD_FLTR_WB_QW1_FAIL_PROF_YES	0x1ULL
 
-struct ice_rx_ptype_decoded {
-	u32 known:1;
-	u32 outer_ip:1;
-	u32 outer_ip_ver:2;
-	u32 outer_frag:1;
-	u32 tunnel_type:3;
-	u32 tunnel_end_prot:2;
-	u32 tunnel_end_frag:1;
-	u32 inner_prot:4;
-	u32 payload_layer:3;
-};
-
-enum ice_rx_ptype_outer_ip {
-	ICE_RX_PTYPE_OUTER_L2	= 0,
-	ICE_RX_PTYPE_OUTER_IP	= 1,
-};
-
-enum ice_rx_ptype_outer_ip_ver {
-	ICE_RX_PTYPE_OUTER_NONE	= 0,
-	ICE_RX_PTYPE_OUTER_IPV4	= 1,
-	ICE_RX_PTYPE_OUTER_IPV6	= 2,
-};
-
-enum ice_rx_ptype_outer_fragmented {
-	ICE_RX_PTYPE_NOT_FRAG	= 0,
-	ICE_RX_PTYPE_FRAG	= 1,
-};
-
-enum ice_rx_ptype_tunnel_type {
-	ICE_RX_PTYPE_TUNNEL_NONE		= 0,
-	ICE_RX_PTYPE_TUNNEL_IP_IP		= 1,
-	ICE_RX_PTYPE_TUNNEL_IP_GRENAT		= 2,
-	ICE_RX_PTYPE_TUNNEL_IP_GRENAT_MAC	= 3,
-	ICE_RX_PTYPE_TUNNEL_IP_GRENAT_MAC_VLAN	= 4,
-};
-
-enum ice_rx_ptype_tunnel_end_prot {
-	ICE_RX_PTYPE_TUNNEL_END_NONE	= 0,
-	ICE_RX_PTYPE_TUNNEL_END_IPV4	= 1,
-	ICE_RX_PTYPE_TUNNEL_END_IPV6	= 2,
-};
-
-enum ice_rx_ptype_inner_prot {
-	ICE_RX_PTYPE_INNER_PROT_NONE		= 0,
-	ICE_RX_PTYPE_INNER_PROT_UDP		= 1,
-	ICE_RX_PTYPE_INNER_PROT_TCP		= 2,
-	ICE_RX_PTYPE_INNER_PROT_SCTP		= 3,
-	ICE_RX_PTYPE_INNER_PROT_ICMP		= 4,
-	ICE_RX_PTYPE_INNER_PROT_TIMESYNC	= 5,
-};
-
-enum ice_rx_ptype_payload_layer {
-	ICE_RX_PTYPE_PAYLOAD_LAYER_NONE	= 0,
-	ICE_RX_PTYPE_PAYLOAD_LAYER_PAY2	= 1,
-	ICE_RX_PTYPE_PAYLOAD_LAYER_PAY3	= 2,
-	ICE_RX_PTYPE_PAYLOAD_LAYER_PAY4	= 3,
-};
-
 /* Rx Flex Descriptor
  * This descriptor is used instead of the legacy version descriptor when
  * ice_rlan_ctx.adv_desc is set
@@ -651,262 +593,4 @@ struct ice_tlan_ctx {
 	u8 int_q_state;	/* width not needed - internal - DO NOT WRITE!!! */
 };
 
-/* The ice_ptype_lkup table is used to convert from the 10-bit ptype in the
- * hardware to a bit-field that can be used by SW to more easily determine the
- * packet type.
- *
- * Macros are used to shorten the table lines and make this table human
- * readable.
- *
- * We store the PTYPE in the top byte of the bit field - this is just so that
- * we can check that the table doesn't have a row missing, as the index into
- * the table should be the PTYPE.
- *
- * Typical work flow:
- *
- * IF NOT ice_ptype_lkup[ptype].known
- * THEN
- *      Packet is unknown
- * ELSE IF ice_ptype_lkup[ptype].outer_ip == ICE_RX_PTYPE_OUTER_IP
- *      Use the rest of the fields to look at the tunnels, inner protocols, etc
- * ELSE
- *      Use the enum ice_rx_l2_ptype to decode the packet type
- * ENDIF
- */
-
-/* macro to make the table lines short, use explicit indexing with [PTYPE] */
-#define ICE_PTT(PTYPE, OUTER_IP, OUTER_IP_VER, OUTER_FRAG, T, TE, TEF, I, PL)\
-	[PTYPE] = { \
-		1, \
-		ICE_RX_PTYPE_OUTER_##OUTER_IP, \
-		ICE_RX_PTYPE_OUTER_##OUTER_IP_VER, \
-		ICE_RX_PTYPE_##OUTER_FRAG, \
-		ICE_RX_PTYPE_TUNNEL_##T, \
-		ICE_RX_PTYPE_TUNNEL_END_##TE, \
-		ICE_RX_PTYPE_##TEF, \
-		ICE_RX_PTYPE_INNER_PROT_##I, \
-		ICE_RX_PTYPE_PAYLOAD_LAYER_##PL }
-
-#define ICE_PTT_UNUSED_ENTRY(PTYPE) [PTYPE] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
-
-/* shorter macros makes the table fit but are terse */
-#define ICE_RX_PTYPE_NOF		ICE_RX_PTYPE_NOT_FRAG
-#define ICE_RX_PTYPE_FRG		ICE_RX_PTYPE_FRAG
-
-/* Lookup table mapping in the 10-bit HW PTYPE to the bit field for decoding */
-static const struct ice_rx_ptype_decoded ice_ptype_lkup[BIT(10)] = {
-	/* L2 Packet types */
-	ICE_PTT_UNUSED_ENTRY(0),
-	ICE_PTT(1, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),
-	ICE_PTT_UNUSED_ENTRY(2),
-	ICE_PTT_UNUSED_ENTRY(3),
-	ICE_PTT_UNUSED_ENTRY(4),
-	ICE_PTT_UNUSED_ENTRY(5),
-	ICE_PTT(6, L2, NONE, NOF, NONE, NONE, NOF, NONE, NONE),
-	ICE_PTT(7, L2, NONE, NOF, NONE, NONE, NOF, NONE, NONE),
-	ICE_PTT_UNUSED_ENTRY(8),
-	ICE_PTT_UNUSED_ENTRY(9),
-	ICE_PTT(10, L2, NONE, NOF, NONE, NONE, NOF, NONE, NONE),
-	ICE_PTT(11, L2, NONE, NOF, NONE, NONE, NOF, NONE, NONE),
-	ICE_PTT_UNUSED_ENTRY(12),
-	ICE_PTT_UNUSED_ENTRY(13),
-	ICE_PTT_UNUSED_ENTRY(14),
-	ICE_PTT_UNUSED_ENTRY(15),
-	ICE_PTT_UNUSED_ENTRY(16),
-	ICE_PTT_UNUSED_ENTRY(17),
-	ICE_PTT_UNUSED_ENTRY(18),
-	ICE_PTT_UNUSED_ENTRY(19),
-	ICE_PTT_UNUSED_ENTRY(20),
-	ICE_PTT_UNUSED_ENTRY(21),
-
-	/* Non Tunneled IPv4 */
-	ICE_PTT(22, IP, IPV4, FRG, NONE, NONE, NOF, NONE, PAY3),
-	ICE_PTT(23, IP, IPV4, NOF, NONE, NONE, NOF, NONE, PAY3),
-	ICE_PTT(24, IP, IPV4, NOF, NONE, NONE, NOF, UDP,  PAY4),
-	ICE_PTT_UNUSED_ENTRY(25),
-	ICE_PTT(26, IP, IPV4, NOF, NONE, NONE, NOF, TCP,  PAY4),
-	ICE_PTT(27, IP, IPV4, NOF, NONE, NONE, NOF, SCTP, PAY4),
-	ICE_PTT(28, IP, IPV4, NOF, NONE, NONE, NOF, ICMP, PAY4),
-
-	/* IPv4 --> IPv4 */
-	ICE_PTT(29, IP, IPV4, NOF, IP_IP, IPV4, FRG, NONE, PAY3),
-	ICE_PTT(30, IP, IPV4, NOF, IP_IP, IPV4, NOF, NONE, PAY3),
-	ICE_PTT(31, IP, IPV4, NOF, IP_IP, IPV4, NOF, UDP,  PAY4),
-	ICE_PTT_UNUSED_ENTRY(32),
-	ICE_PTT(33, IP, IPV4, NOF, IP_IP, IPV4, NOF, TCP,  PAY4),
-	ICE_PTT(34, IP, IPV4, NOF, IP_IP, IPV4, NOF, SCTP, PAY4),
-	ICE_PTT(35, IP, IPV4, NOF, IP_IP, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv4 --> IPv6 */
-	ICE_PTT(36, IP, IPV4, NOF, IP_IP, IPV6, FRG, NONE, PAY3),
-	ICE_PTT(37, IP, IPV4, NOF, IP_IP, IPV6, NOF, NONE, PAY3),
-	ICE_PTT(38, IP, IPV4, NOF, IP_IP, IPV6, NOF, UDP,  PAY4),
-	ICE_PTT_UNUSED_ENTRY(39),
-	ICE_PTT(40, IP, IPV4, NOF, IP_IP, IPV6, NOF, TCP,  PAY4),
-	ICE_PTT(41, IP, IPV4, NOF, IP_IP, IPV6, NOF, SCTP, PAY4),
-	ICE_PTT(42, IP, IPV4, NOF, IP_IP, IPV6, NOF, ICMP, PAY4),
-
-	/* IPv4 --> GRE/NAT */
-	ICE_PTT(43, IP, IPV4, NOF, IP_GRENAT, NONE, NOF, NONE, PAY3),
-
-	/* IPv4 --> GRE/NAT --> IPv4 */
-	ICE_PTT(44, IP, IPV4, NOF, IP_GRENAT, IPV4, FRG, NONE, PAY3),
-	ICE_PTT(45, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, NONE, PAY3),
-	ICE_PTT(46, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, UDP,  PAY4),
-	ICE_PTT_UNUSED_ENTRY(47),
-	ICE_PTT(48, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, TCP,  PAY4),
-	ICE_PTT(49, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, SCTP, PAY4),
-	ICE_PTT(50, IP, IPV4, NOF, IP_GRENAT, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv4 --> GRE/NAT --> IPv6 */
-	ICE_PTT(51, IP, IPV4, NOF, IP_GRENAT, IPV6, FRG, NONE, PAY3),
-	ICE_PTT(52, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, NONE, PAY3),
-	ICE_PTT(53, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, UDP,  PAY4),
-	ICE_PTT_UNUSED_ENTRY(54),
-	ICE_PTT(55, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, TCP,  PAY4),
-	ICE_PTT(56, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, SCTP, PAY4),
-	ICE_PTT(57, IP, IPV4, NOF, IP_GRENAT, IPV6, NOF, ICMP, PAY4),
-
-	/* IPv4 --> GRE/NAT --> MAC */
-	ICE_PTT(58, IP, IPV4, NOF, IP_GRENAT_MAC, NONE, NOF, NONE, PAY3),
-
-	/* IPv4 --> GRE/NAT --> MAC --> IPv4 */
-	ICE_PTT(59, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, FRG, NONE, PAY3),
-	ICE_PTT(60, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, NONE, PAY3),
-	ICE_PTT(61, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, UDP,  PAY4),
-	ICE_PTT_UNUSED_ENTRY(62),
-	ICE_PTT(63, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, TCP,  PAY4),
-	ICE_PTT(64, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, SCTP, PAY4),
-	ICE_PTT(65, IP, IPV4, NOF, IP_GRENAT_MAC, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv4 --> GRE/NAT -> MAC --> IPv6 */
-	ICE_PTT(66, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, FRG, NONE, PAY3),
-	ICE_PTT(67, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, NONE, PAY3),
-	ICE_PTT(68, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, UDP,  PAY4),
-	ICE_PTT_UNUSED_ENTRY(69),
-	ICE_PTT(70, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, TCP,  PAY4),
-	ICE_PTT(71, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, SCTP, PAY4),
-	ICE_PTT(72, IP, IPV4, NOF, IP_GRENAT_MAC, IPV6, NOF, ICMP, PAY4),
-
-	/* IPv4 --> GRE/NAT --> MAC/VLAN */
-	ICE_PTT(73, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, NONE, NOF, NONE, PAY3),
-
-	/* IPv4 ---> GRE/NAT -> MAC/VLAN --> IPv4 */
-	ICE_PTT(74, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, FRG, NONE, PAY3),
-	ICE_PTT(75, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, NONE, PAY3),
-	ICE_PTT(76, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, UDP,  PAY4),
-	ICE_PTT_UNUSED_ENTRY(77),
-	ICE_PTT(78, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, TCP,  PAY4),
-	ICE_PTT(79, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, SCTP, PAY4),
-	ICE_PTT(80, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv4 -> GRE/NAT -> MAC/VLAN --> IPv6 */
-	ICE_PTT(81, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, FRG, NONE, PAY3),
-	ICE_PTT(82, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, NONE, PAY3),
-	ICE_PTT(83, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, UDP,  PAY4),
-	ICE_PTT_UNUSED_ENTRY(84),
-	ICE_PTT(85, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, TCP,  PAY4),
-	ICE_PTT(86, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, SCTP, PAY4),
-	ICE_PTT(87, IP, IPV4, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, ICMP, PAY4),
-
-	/* Non Tunneled IPv6 */
-	ICE_PTT(88, IP, IPV6, FRG, NONE, NONE, NOF, NONE, PAY3),
-	ICE_PTT(89, IP, IPV6, NOF, NONE, NONE, NOF, NONE, PAY3),
-	ICE_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY4),
-	ICE_PTT_UNUSED_ENTRY(91),
-	ICE_PTT(92, IP, IPV6, NOF, NONE, NONE, NOF, TCP,  PAY4),
-	ICE_PTT(93, IP, IPV6, NOF, NONE, NONE, NOF, SCTP, PAY4),
-	ICE_PTT(94, IP, IPV6, NOF, NONE, NONE, NOF, ICMP, PAY4),
-
-	/* IPv6 --> IPv4 */
-	ICE_PTT(95, IP, IPV6, NOF, IP_IP, IPV4, FRG, NONE, PAY3),
-	ICE_PTT(96, IP, IPV6, NOF, IP_IP, IPV4, NOF, NONE, PAY3),
-	ICE_PTT(97, IP, IPV6, NOF, IP_IP, IPV4, NOF, UDP,  PAY4),
-	ICE_PTT_UNUSED_ENTRY(98),
-	ICE_PTT(99, IP, IPV6, NOF, IP_IP, IPV4, NOF, TCP,  PAY4),
-	ICE_PTT(100, IP, IPV6, NOF, IP_IP, IPV4, NOF, SCTP, PAY4),
-	ICE_PTT(101, IP, IPV6, NOF, IP_IP, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv6 --> IPv6 */
-	ICE_PTT(102, IP, IPV6, NOF, IP_IP, IPV6, FRG, NONE, PAY3),
-	ICE_PTT(103, IP, IPV6, NOF, IP_IP, IPV6, NOF, NONE, PAY3),
-	ICE_PTT(104, IP, IPV6, NOF, IP_IP, IPV6, NOF, UDP,  PAY4),
-	ICE_PTT_UNUSED_ENTRY(105),
-	ICE_PTT(106, IP, IPV6, NOF, IP_IP, IPV6, NOF, TCP,  PAY4),
-	ICE_PTT(107, IP, IPV6, NOF, IP_IP, IPV6, NOF, SCTP, PAY4),
-	ICE_PTT(108, IP, IPV6, NOF, IP_IP, IPV6, NOF, ICMP, PAY4),
-
-	/* IPv6 --> GRE/NAT */
-	ICE_PTT(109, IP, IPV6, NOF, IP_GRENAT, NONE, NOF, NONE, PAY3),
-
-	/* IPv6 --> GRE/NAT -> IPv4 */
-	ICE_PTT(110, IP, IPV6, NOF, IP_GRENAT, IPV4, FRG, NONE, PAY3),
-	ICE_PTT(111, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, NONE, PAY3),
-	ICE_PTT(112, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, UDP,  PAY4),
-	ICE_PTT_UNUSED_ENTRY(113),
-	ICE_PTT(114, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, TCP,  PAY4),
-	ICE_PTT(115, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, SCTP, PAY4),
-	ICE_PTT(116, IP, IPV6, NOF, IP_GRENAT, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv6 --> GRE/NAT -> IPv6 */
-	ICE_PTT(117, IP, IPV6, NOF, IP_GRENAT, IPV6, FRG, NONE, PAY3),
-	ICE_PTT(118, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, NONE, PAY3),
-	ICE_PTT(119, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, UDP,  PAY4),
-	ICE_PTT_UNUSED_ENTRY(120),
-	ICE_PTT(121, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, TCP,  PAY4),
-	ICE_PTT(122, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, SCTP, PAY4),
-	ICE_PTT(123, IP, IPV6, NOF, IP_GRENAT, IPV6, NOF, ICMP, PAY4),
-
-	/* IPv6 --> GRE/NAT -> MAC */
-	ICE_PTT(124, IP, IPV6, NOF, IP_GRENAT_MAC, NONE, NOF, NONE, PAY3),
-
-	/* IPv6 --> GRE/NAT -> MAC -> IPv4 */
-	ICE_PTT(125, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, FRG, NONE, PAY3),
-	ICE_PTT(126, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, NONE, PAY3),
-	ICE_PTT(127, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, UDP,  PAY4),
-	ICE_PTT_UNUSED_ENTRY(128),
-	ICE_PTT(129, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, TCP,  PAY4),
-	ICE_PTT(130, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, SCTP, PAY4),
-	ICE_PTT(131, IP, IPV6, NOF, IP_GRENAT_MAC, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv6 --> GRE/NAT -> MAC -> IPv6 */
-	ICE_PTT(132, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, FRG, NONE, PAY3),
-	ICE_PTT(133, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, NONE, PAY3),
-	ICE_PTT(134, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, UDP,  PAY4),
-	ICE_PTT_UNUSED_ENTRY(135),
-	ICE_PTT(136, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, TCP,  PAY4),
-	ICE_PTT(137, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, SCTP, PAY4),
-	ICE_PTT(138, IP, IPV6, NOF, IP_GRENAT_MAC, IPV6, NOF, ICMP, PAY4),
-
-	/* IPv6 --> GRE/NAT -> MAC/VLAN */
-	ICE_PTT(139, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, NONE, NOF, NONE, PAY3),
-
-	/* IPv6 --> GRE/NAT -> MAC/VLAN --> IPv4 */
-	ICE_PTT(140, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, FRG, NONE, PAY3),
-	ICE_PTT(141, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, NONE, PAY3),
-	ICE_PTT(142, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, UDP,  PAY4),
-	ICE_PTT_UNUSED_ENTRY(143),
-	ICE_PTT(144, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, TCP,  PAY4),
-	ICE_PTT(145, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, SCTP, PAY4),
-	ICE_PTT(146, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV4, NOF, ICMP, PAY4),
-
-	/* IPv6 --> GRE/NAT -> MAC/VLAN --> IPv6 */
-	ICE_PTT(147, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, FRG, NONE, PAY3),
-	ICE_PTT(148, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, NONE, PAY3),
-	ICE_PTT(149, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, UDP,  PAY4),
-	ICE_PTT_UNUSED_ENTRY(150),
-	ICE_PTT(151, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, TCP,  PAY4),
-	ICE_PTT(152, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, SCTP, PAY4),
-	ICE_PTT(153, IP, IPV6, NOF, IP_GRENAT_MAC_VLAN, IPV6, NOF, ICMP, PAY4),
-
-	/* unused entries */
-	[154 ... 1023] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
-};
-
-static inline struct ice_rx_ptype_decoded ice_decode_rx_desc_ptype(u16 ptype)
-{
-	return ice_ptype_lkup[ptype];
-}
-
-
 #endif /* _ICE_LAN_TX_RX_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 62e91512aeab..2f039f48d7a0 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -34,6 +34,7 @@ static const char ice_copyright[] = "Copyright (c) 2018, Intel Corporation.";
 
 MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
 MODULE_DESCRIPTION(DRV_SUMMARY);
+MODULE_IMPORT_NS(LIBIE);
 MODULE_LICENSE("GPL v2");
 MODULE_FIRMWARE(ICE_DDP_PKG_FILE);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index c8322fb6f2b3..7543aba4ff9f 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2019, Intel Corporation. */
 
 #include <linux/filter.h>
+#include <linux/net/intel/libie/rx.h>
 
 #include "ice_txrx_lib.h"
 #include "ice_eswitch.h"
@@ -38,30 +39,6 @@ void ice_release_rx_desc(struct ice_rx_ring *rx_ring, u16 val)
 	}
 }
 
-/**
- * ice_ptype_to_htype - get a hash type
- * @ptype: the ptype value from the descriptor
- *
- * Returns appropriate hash type (such as PKT_HASH_TYPE_L2/L3/L4) to be used by
- * skb_set_hash based on PTYPE as parsed by HW Rx pipeline and is part of
- * Rx desc.
- */
-static enum pkt_hash_types ice_ptype_to_htype(u16 ptype)
-{
-	struct ice_rx_ptype_decoded decoded = ice_decode_rx_desc_ptype(ptype);
-
-	if (!decoded.known)
-		return PKT_HASH_TYPE_NONE;
-	if (decoded.payload_layer == ICE_RX_PTYPE_PAYLOAD_LAYER_PAY4)
-		return PKT_HASH_TYPE_L4;
-	if (decoded.payload_layer == ICE_RX_PTYPE_PAYLOAD_LAYER_PAY3)
-		return PKT_HASH_TYPE_L3;
-	if (decoded.outer_ip == ICE_RX_PTYPE_OUTER_L2)
-		return PKT_HASH_TYPE_L2;
-
-	return PKT_HASH_TYPE_NONE;
-}
-
 /**
  * ice_rx_hash - set the hash value in the skb
  * @rx_ring: descriptor ring
@@ -74,9 +51,11 @@ ice_rx_hash(struct ice_rx_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
 	    struct sk_buff *skb, u16 rx_ptype)
 {
 	struct ice_32b_rx_flex_desc_nic *nic_mdid;
+	struct libie_rx_ptype_parsed parsed;
 	u32 hash;
 
-	if (!(rx_ring->netdev->features & NETIF_F_RXHASH))
+	parsed = libie_parse_rx_ptype(rx_ptype);
+	if (!libie_has_rx_hash(rx_ring->netdev, parsed))
 		return;
 
 	if (rx_desc->wb.rxdid != ICE_RXDID_FLEX_NIC)
@@ -84,7 +63,7 @@ ice_rx_hash(struct ice_rx_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
 
 	nic_mdid = (struct ice_32b_rx_flex_desc_nic *)rx_desc;
 	hash = le32_to_cpu(nic_mdid->rss_hash);
-	skb_set_hash(skb, hash, ice_ptype_to_htype(rx_ptype));
+	libie_skb_set_hash(skb, hash, parsed);
 }
 
 /**
@@ -92,7 +71,7 @@ ice_rx_hash(struct ice_rx_ring *rx_ring, union ice_32b_rx_flex_desc *rx_desc,
  * @ring: the ring we care about
  * @skb: skb currently being received and modified
  * @rx_desc: the receive descriptor
- * @ptype: the packet type decoded by hardware
+ * @ptype: the packet type parsed by hardware
  *
  * skb->protocol must be set before this function is called
  */
@@ -100,34 +79,26 @@ static void
 ice_rx_csum(struct ice_rx_ring *ring, struct sk_buff *skb,
 	    union ice_32b_rx_flex_desc *rx_desc, u16 ptype)
 {
-	struct ice_rx_ptype_decoded decoded;
+	struct libie_rx_ptype_parsed parsed;
 	u16 rx_status0, rx_status1;
 	bool ipv4, ipv6;
 
-	rx_status0 = le16_to_cpu(rx_desc->wb.status_error0);
-	rx_status1 = le16_to_cpu(rx_desc->wb.status_error1);
-
-	decoded = ice_decode_rx_desc_ptype(ptype);
-
 	/* Start with CHECKSUM_NONE and by default csum_level = 0 */
 	skb->ip_summed = CHECKSUM_NONE;
-	skb_checksum_none_assert(skb);
 
-	/* check if Rx checksum is enabled */
-	if (!(ring->netdev->features & NETIF_F_RXCSUM))
+	parsed = libie_parse_rx_ptype(ptype);
+	if (!libie_has_rx_checksum(ring->netdev, parsed))
 		return;
 
-	/* check if HW has decoded the packet and checksum */
-	if (!(rx_status0 & BIT(ICE_RX_FLEX_DESC_STATUS0_L3L4P_S)))
-		return;
+	rx_status0 = le16_to_cpu(rx_desc->wb.status_error0);
+	rx_status1 = le16_to_cpu(rx_desc->wb.status_error1);
 
-	if (!(decoded.known && decoded.outer_ip))
+	/* check if HW has parsed the packet and checksum */
+	if (!(rx_status0 & BIT(ICE_RX_FLEX_DESC_STATUS0_L3L4P_S)))
 		return;
 
-	ipv4 = (decoded.outer_ip == ICE_RX_PTYPE_OUTER_IP) &&
-	       (decoded.outer_ip_ver == ICE_RX_PTYPE_OUTER_IPV4);
-	ipv6 = (decoded.outer_ip == ICE_RX_PTYPE_OUTER_IP) &&
-	       (decoded.outer_ip_ver == ICE_RX_PTYPE_OUTER_IPV6);
+	ipv4 = parsed.outer_ip == LIBIE_RX_PTYPE_OUTER_IPV4;
+	ipv6 = parsed.outer_ip == LIBIE_RX_PTYPE_OUTER_IPV6;
 
 	if (ipv4 && (rx_status0 & (BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_IPE_S) |
 				   BIT(ICE_RX_FLEX_DESC_STATUS0_XSUM_EIPE_S))))
@@ -151,19 +122,10 @@ ice_rx_csum(struct ice_rx_ring *ring, struct sk_buff *skb,
 	 * we need to bump the checksum level by 1 to reflect the fact that
 	 * we are indicating we validated the inner checksum.
 	 */
-	if (decoded.tunnel_type >= ICE_RX_PTYPE_TUNNEL_IP_GRENAT)
+	if (parsed.tunnel_type >= LIBIE_RX_PTYPE_TUNNEL_IP_GRENAT)
 		skb->csum_level = 1;
 
-	/* Only report checksum unnecessary for TCP, UDP, or SCTP */
-	switch (decoded.inner_prot) {
-	case ICE_RX_PTYPE_INNER_PROT_TCP:
-	case ICE_RX_PTYPE_INNER_PROT_UDP:
-	case ICE_RX_PTYPE_INNER_PROT_SCTP:
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-		break;
-	default:
-		break;
-	}
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	return;
 
 checksum_fail:
@@ -175,7 +137,7 @@ ice_rx_csum(struct ice_rx_ring *ring, struct sk_buff *skb,
  * @rx_ring: Rx descriptor ring packet is being transacted on
  * @rx_desc: pointer to the EOP Rx descriptor
  * @skb: pointer to current skb being populated
- * @ptype: the packet type decoded by hardware
+ * @ptype: the packet type parsed by hardware
  *
  * This function checks the ring, descriptor, and packet information in
  * order to populate the hash, checksum, VLAN, protocol, and
diff --git a/drivers/net/ethernet/intel/libie/Makefile b/drivers/net/ethernet/intel/libie/Makefile
new file mode 100644
index 000000000000..95e81d09b474
--- /dev/null
+++ b/drivers/net/ethernet/intel/libie/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0-only
+# Copyright(c) 2023 Intel Corporation.
+
+obj-$(CONFIG_LIBIE)	+= libie.o
+
+libie-objs		+= rx.o
diff --git a/drivers/net/ethernet/intel/libie/rx.c b/drivers/net/ethernet/intel/libie/rx.c
new file mode 100644
index 000000000000..f503476d8eef
--- /dev/null
+++ b/drivers/net/ethernet/intel/libie/rx.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Intel Corporation. */
+
+#include <linux/net/intel/libie/rx.h>
+
+/* O(1) converting i40e/ice/iavf's 8/10-bit hardware packet type to a parsed
+ * bitfield struct.
+ */
+
+#define LIBIE_RX_PTYPE(oip, ofrag, tun, tp, tefr, iprot, pl) {		   \
+		.outer_ip		= LIBIE_RX_PTYPE_OUTER_##oip,	   \
+		.outer_frag		= LIBIE_RX_PTYPE_##ofrag,	   \
+		.tunnel_type		= LIBIE_RX_PTYPE_TUNNEL_IP_##tun,  \
+		.tunnel_end_prot	= LIBIE_RX_PTYPE_TUNNEL_END_##tp,  \
+		.tunnel_end_frag	= LIBIE_RX_PTYPE_##tefr,	   \
+		.inner_prot		= LIBIE_RX_PTYPE_INNER_##iprot,	   \
+		.payload_layer		= LIBIE_RX_PTYPE_PAYLOAD_##pl,	   \
+	}
+
+#define LIBIE_RX_PTYPE_UNUSED		{ }
+
+#define __LIBIE_RX_PTYPE_L2(iprot, pl)					   \
+	LIBIE_RX_PTYPE(L2, NOT_FRAG, NONE, NONE, NOT_FRAG, iprot, pl)
+#define LIBIE_RX_PTYPE_L2		__LIBIE_RX_PTYPE_L2(NONE, L2)
+#define LIBIE_RX_PTYPE_TS		__LIBIE_RX_PTYPE_L2(TIMESYNC, L2)
+#define LIBIE_RX_PTYPE_L3		__LIBIE_RX_PTYPE_L2(NONE, L3)
+
+#define LIBIE_RX_PTYPE_IP_FRAG(oip)					   \
+	LIBIE_RX_PTYPE(IPV##oip, FRAG, NONE, NONE, NOT_FRAG, NONE, L3)
+#define LIBIE_RX_PTYPE_IP_L3(oip, tun, teprot, tefr)			   \
+	LIBIE_RX_PTYPE(IPV##oip, NOT_FRAG, tun, teprot, tefr, NONE, L3)
+#define LIBIE_RX_PTYPE_IP_L4(oip, tun, teprot, iprot)			   \
+	LIBIE_RX_PTYPE(IPV##oip, NOT_FRAG, tun, teprot, NOT_FRAG, iprot, L4)
+
+#define LIBIE_RX_PTYPE_IP_NOF(oip, tun, ver)				   \
+	LIBIE_RX_PTYPE_IP_L3(oip, tun, ver, NOT_FRAG),			   \
+	LIBIE_RX_PTYPE_IP_L4(oip, tun, ver, UDP),			   \
+	LIBIE_RX_PTYPE_UNUSED,						   \
+	LIBIE_RX_PTYPE_IP_L4(oip, tun, ver, TCP),			   \
+	LIBIE_RX_PTYPE_IP_L4(oip, tun, ver, SCTP),			   \
+	LIBIE_RX_PTYPE_IP_L4(oip, tun, ver, ICMP)
+
+/* IPv oip --> tun --> IPv ver */
+#define LIBIE_RX_PTYPE_IP_TUN_VER(oip, tun, ver)			   \
+	LIBIE_RX_PTYPE_IP_L3(oip, tun, ver, FRAG),			   \
+	LIBIE_RX_PTYPE_IP_NOF(oip, tun, ver)
+
+/* Non Tunneled IPv oip */
+#define LIBIE_RX_PTYPE_IP_RAW(oip)					   \
+	LIBIE_RX_PTYPE_IP_FRAG(oip),					   \
+	LIBIE_RX_PTYPE_IP_NOF(oip, NONE, NONE)
+
+/* IPv oip --> tun --> { IPv4, IPv6 } */
+#define LIBIE_RX_PTYPE_IP_TUN(oip, tun)					   \
+	LIBIE_RX_PTYPE_IP_TUN_VER(oip, tun, IPV4),			   \
+	LIBIE_RX_PTYPE_IP_TUN_VER(oip, tun, IPV6)
+
+/* IPv oip --> GRE/NAT tun --> { x, IPv4, IPv6 } */
+#define LIBIE_RX_PTYPE_IP_GRE(oip, tun)					   \
+	LIBIE_RX_PTYPE_IP_L3(oip, tun, NONE, NOT_FRAG),			   \
+	LIBIE_RX_PTYPE_IP_TUN(oip, tun)
+
+/* Non Tunneled IPv oip
+ * IPv oip --> { IPv4, IPv6 }
+ * IPv oip --> GRE/NAT --> { x, IPv4, IPv6 }
+ * IPv oip --> GRE/NAT --> MAC --> { x, IPv4, IPv6 }
+ * IPv oip --> GRE/NAT --> MAC/VLAN --> { x, IPv4, IPv6 }
+ */
+#define LIBIE_RX_PTYPE_IP(oip)						   \
+	LIBIE_RX_PTYPE_IP_RAW(oip),					   \
+	LIBIE_RX_PTYPE_IP_TUN(oip, IP),					   \
+	LIBIE_RX_PTYPE_IP_GRE(oip, GRENAT),				   \
+	LIBIE_RX_PTYPE_IP_GRE(oip, GRENAT_MAC),				   \
+	LIBIE_RX_PTYPE_IP_GRE(oip, GRENAT_MAC_VLAN)
+
+/* Lookup table mapping for O(1) parsing */
+const struct libie_rx_ptype_parsed libie_rx_ptype_lut[LIBIE_RX_PTYPE_NUM] = {
+	/* L2 packet types */
+	LIBIE_RX_PTYPE_UNUSED,
+	LIBIE_RX_PTYPE_L2,
+	LIBIE_RX_PTYPE_TS,
+	LIBIE_RX_PTYPE_L2,
+	LIBIE_RX_PTYPE_UNUSED,
+	LIBIE_RX_PTYPE_UNUSED,
+	LIBIE_RX_PTYPE_L2,
+	LIBIE_RX_PTYPE_L2,
+	LIBIE_RX_PTYPE_UNUSED,
+	LIBIE_RX_PTYPE_UNUSED,
+	LIBIE_RX_PTYPE_L2,
+	LIBIE_RX_PTYPE_UNUSED,
+
+	LIBIE_RX_PTYPE_L3,
+	LIBIE_RX_PTYPE_L3,
+	LIBIE_RX_PTYPE_L3,
+	LIBIE_RX_PTYPE_L3,
+	LIBIE_RX_PTYPE_L3,
+	LIBIE_RX_PTYPE_L3,
+	LIBIE_RX_PTYPE_L3,
+	LIBIE_RX_PTYPE_L3,
+	LIBIE_RX_PTYPE_L3,
+	LIBIE_RX_PTYPE_L3,
+
+	LIBIE_RX_PTYPE_IP(4),
+	LIBIE_RX_PTYPE_IP(6),
+};
+EXPORT_SYMBOL_NS_GPL(libie_rx_ptype_lut, LIBIE);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("Intel(R) Ethernet common library");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/net/intel/libie/rx.h b/include/linux/net/intel/libie/rx.h
new file mode 100644
index 000000000000..58bd0f35d025
--- /dev/null
+++ b/include/linux/net/intel/libie/rx.h
@@ -0,0 +1,128 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Intel Corporation. */
+
+#ifndef __LIBIE_RX_H
+#define __LIBIE_RX_H
+
+#include <linux/netdevice.h>
+
+/* O(1) converting i40e/ice/iavf's 8/10-bit hardware packet type to a parsed
+ * bitfield struct.
+ */
+
+struct libie_rx_ptype_parsed {
+	u16	outer_ip:2;
+	u16	outer_frag:1;
+	u16	tunnel_type:3;
+	u16	tunnel_end_prot:2;
+	u16	tunnel_end_frag:1;
+	u16	inner_prot:3;
+	u16	payload_layer:2;
+};
+
+enum libie_rx_ptype_outer_ip {
+	LIBIE_RX_PTYPE_OUTER_L2				= 0U,
+	LIBIE_RX_PTYPE_OUTER_IPV4,
+	LIBIE_RX_PTYPE_OUTER_IPV6,
+};
+
+enum libie_rx_ptype_outer_fragmented {
+	LIBIE_RX_PTYPE_NOT_FRAG				= 0U,
+	LIBIE_RX_PTYPE_FRAG,
+};
+
+enum libie_rx_ptype_tunnel_type {
+	LIBIE_RX_PTYPE_TUNNEL_IP_NONE			= 0U,
+	LIBIE_RX_PTYPE_TUNNEL_IP_IP,
+	LIBIE_RX_PTYPE_TUNNEL_IP_GRENAT,
+	LIBIE_RX_PTYPE_TUNNEL_IP_GRENAT_MAC,
+	LIBIE_RX_PTYPE_TUNNEL_IP_GRENAT_MAC_VLAN,
+};
+
+enum libie_rx_ptype_tunnel_end_prot {
+	LIBIE_RX_PTYPE_TUNNEL_END_NONE			= 0U,
+	LIBIE_RX_PTYPE_TUNNEL_END_IPV4,
+	LIBIE_RX_PTYPE_TUNNEL_END_IPV6,
+};
+
+enum libie_rx_ptype_inner_prot {
+	LIBIE_RX_PTYPE_INNER_NONE			= 0U,
+	LIBIE_RX_PTYPE_INNER_UDP,
+	LIBIE_RX_PTYPE_INNER_TCP,
+	LIBIE_RX_PTYPE_INNER_SCTP,
+	LIBIE_RX_PTYPE_INNER_ICMP,
+	LIBIE_RX_PTYPE_INNER_TIMESYNC,
+};
+
+enum libie_rx_ptype_payload_layer {
+	LIBIE_RX_PTYPE_PAYLOAD_NONE			= PKT_HASH_TYPE_NONE,
+	LIBIE_RX_PTYPE_PAYLOAD_L2			= PKT_HASH_TYPE_L2,
+	LIBIE_RX_PTYPE_PAYLOAD_L3			= PKT_HASH_TYPE_L3,
+	LIBIE_RX_PTYPE_PAYLOAD_L4			= PKT_HASH_TYPE_L4,
+};
+
+#define LIBIE_RX_PTYPE_NUM				154
+
+extern const struct libie_rx_ptype_parsed
+libie_rx_ptype_lut[LIBIE_RX_PTYPE_NUM];
+
+/**
+ * libie_parse_rx_ptype - convert HW packet type to software bitfield structure
+ * @ptype: 10-bit hardware packet type value from the descriptor
+ *
+ * @libie_rx_ptype_lut must be accessed only using this wrapper.
+ *
+ * Returns the parsed bitfield struct corresponding to the provided ptype.
+ */
+static inline struct libie_rx_ptype_parsed libie_parse_rx_ptype(u32 ptype)
+{
+	if (unlikely(ptype >= LIBIE_RX_PTYPE_NUM))
+		ptype = 0;
+
+	return libie_rx_ptype_lut[ptype];
+}
+
+/* libie_has_*() can be used to quickly check whether the HW metadata is
+ * available to avoid further expensive processing such as descriptor reads.
+ * They already check for the corresponding netdev feature to be enabled,
+ * thus can be used as drop-in replacements.
+ */
+
+static inline bool libie_has_rx_checksum(const struct net_device *dev,
+					 struct libie_rx_ptype_parsed parsed)
+{
+	/* _INNER_{SCTP,TCP,UDP} are possible only when _OUTER_IPV* is set,
+	 * it is enough to check only for the L4 type.
+	 */
+	switch (parsed.inner_prot) {
+	case LIBIE_RX_PTYPE_INNER_TCP:
+	case LIBIE_RX_PTYPE_INNER_UDP:
+	case LIBIE_RX_PTYPE_INNER_SCTP:
+		return dev->features & NETIF_F_RXCSUM;
+	default:
+		return false;
+	}
+}
+
+static inline bool libie_has_rx_hash(const struct net_device *dev,
+				     struct libie_rx_ptype_parsed parsed)
+{
+	if (parsed.payload_layer < LIBIE_RX_PTYPE_PAYLOAD_L2)
+		return false;
+
+	return dev->features & NETIF_F_RXHASH;
+}
+
+/**
+ * libie_skb_set_hash - fill in skb hash value basing on the parsed ptype
+ * @skb: skb to fill the hash in
+ * @hash: 32-bit hash value from the descriptor
+ * @parsed: parsed packet type
+ */
+static inline void libie_skb_set_hash(struct sk_buff *skb, u32 hash,
+				      struct libie_rx_ptype_parsed parsed)
+{
+	skb_set_hash(skb, hash, parsed.payload_layer);
+}
+
+#endif /* __LIBIE_RX_H */
-- 
2.40.1


