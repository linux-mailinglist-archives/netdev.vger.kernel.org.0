Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C81619937
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiKDOSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiKDOSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:18:43 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D8A2B248;
        Fri,  4 Nov 2022 07:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667571520; x=1699107520;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SaywjCO5H3xFPsbNlrBx1X+9egfqjODkQ9l6pNxCoIY=;
  b=BNO1SRSKgLH+Q/7OHR3W1yFqiODabB3WqdyYOnIK61/QKcHR3rhQgRCl
   EWC2mYZD44FZW3/ic9sfTB74F5Vk5qYs5oTmeR57uqItIgxntiiFm4k4x
   fXvRMVOwgplaU5X7JepmsUju/Fg99kYf3NAtQE6m3BK4ocrySIGp/I0U4
   bhtXK+oVcVhcKhsRHPCeMMbssJniMS7Re9o5xP2xHs86jhCKQgNnSCVHB
   yZW3HG24x3RuFhFkiHgerWlAuH8d/+Imuqo/v5Bjy+6lZiqybrem/SU7s
   sRz+RJr6L0wAE4JFxgr3uj3Q5M76T959fv8TD0wQ8KtZ3pAfEbKWQz5Ar
   g==;
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="181977469"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Nov 2022 07:18:39 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 4 Nov 2022 07:18:38 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 4 Nov 2022 07:18:35 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next v5 0/8] Extend TC key support for Sparx5 IS2 VCAP
Date:   Fri, 4 Nov 2022 15:18:22 +0100
Message-ID: <20221104141830.1527159-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides extended tc flower filter key support for the Sparx5 VCAP
functionality.

It builds on top of the initial IS2 VCAP support found in this series:

https://lore.kernel.org/all/20221020130904.1215072-1-steen.hegelund@microchip.com/

Overview:
=========

The added flower filter key (dissector) support is this:

- ipv4_addr (sip and dip)
- ipv6_addr (sip and dip)
- control (IPv4 fragments)
- portnum (tcp and udp port numbers)
- basic (L3 and L4 protocol)
- vlan (outer vlan tag info)
- tcp (tcp flags)
- ip (tos field)

The IS2 VCAP supports classified VLAN information which amounts to the
outer VLAN info in case of multiple tags.

Functionality:
==============

Before frames can match IS2 VCAP rules with e.g an IPv4 source address, the
IS2 VCAPs keyset configuration must include keyset that contains a IPv4
source address and this must be configured for the lookup/port/traffic-type
that you want to match on.

The Sparx5 IS2 VCAP has the following traffic types:

- Non-Ethernet frames
- IPv4 Unicast frames
- IPv4 Multicast frames
- IPv6 Unicast frames
- IPv6 Multicast frames
- ARP frames

So to cover IPv4 traffic the two IPv4 categories must be configured with a
keyset that contains IPv4 address information such as the
VCAP_KFS_IP4_TCP_UDP keyset.

The IPv4 and IPv6 traffic types are configured with useful default keysets,
in later series we will use the tc template functionality when we want to
change these defaults.

The flower filter must contain a goto action as its last action and the
chain id must specify the chain id of the next lookup in a VCAP or a
destination outside the VCAP ranges.

To activate the VCAP lookups on a port you must add a TC matchall filter on
the port containing a single goto action that points to the chain id of the
first lookup in the IS2 VCAP.

From then on frames arriving on this port will be matched against the
rules in the IS2 VCAP lookups.

Removing the matchall filter will deactivate the IS2 lookups, but will
leave the VCAP rules in the memory of the VCAP instance, and from then in
frames will no longer be matched against the rules the in IS2 VCAP.

If the matchall rule is added back again the IS2 rules will be active
once more.

Delivery:
=========

This is current plan for delivering the full VCAP feature set of Sparx5:

- TC flower filter statistics and rule order by size and priority
- debugfs support for inspecting rules
- support for TC protocol all
- Sparx5 IS0 VCAP support
- add TC policer and drop action support (depends on the Sparx5 QoS support
  upstreamed separately)
- Sparx5 ES0 VCAP support
- TC flower template support
- TC matchall filter support for mirroring and policing ports
- TC flower filter mirror action support
- Sparx5 ES2 VCAP support


Version History:
================
v5      Add support for a TC matchall filter with a single goto action
        which will activate the lookups of the VCAP.  Removing this filter
        will deactivate the VCAP lookups again.

v4      Add support for TC flower filter goto action and a check of the
        actions: check action combinations and the goto chain id.

v3      Add some more details to the explanation in the commit message
        about support for MAC_ETYPE keysets and "protocol all" as well as
        the classified VLAN information.  This is done to help testing the
        feature.
        No implementation changes in this version.

v2      Split one of the KUNIT tests into 3 tests to fix a kernel robot
        build warning.

v1      Initial version

Steen Hegelund (8):
  net: microchip: sparx5: Differentiate IPv4 and IPv6 traffic in keyset
    config
  net: microchip: sparx5: Adding more tc flower keys for the IS2 VCAP
  net: microchip: sparx5: Find VCAP lookup from chain id
  net: microchip: sparx5: Adding TC goto action and action checking
  net: microchip: sparx5: Match keys in configured port keysets
  net: microchip: sparx5: Let VCAP API validate added key- and
    actionfields
  net: microchip: sparx5: Add tc matchall filter and enable VCAP lookups
  net: microchip: sparx5: Adding KUNIT tests of key/action values in
    VCAP API

 .../net/ethernet/microchip/sparx5/Makefile    |   2 +-
 .../net/ethernet/microchip/sparx5/sparx5_tc.c |   9 +-
 .../net/ethernet/microchip/sparx5/sparx5_tc.h |   5 +
 .../microchip/sparx5/sparx5_tc_flower.c       | 480 +++++++++++++-
 .../microchip/sparx5/sparx5_tc_matchall.c     |  97 +++
 .../microchip/sparx5/sparx5_vcap_impl.c       | 197 +++++-
 .../net/ethernet/microchip/vcap/vcap_api.c    | 424 ++++++++++++-
 .../net/ethernet/microchip/vcap/vcap_api.h    |   6 +
 .../ethernet/microchip/vcap/vcap_api_client.h |  21 +
 .../ethernet/microchip/vcap/vcap_api_kunit.c  | 592 ++++++++++++++++++
 10 files changed, 1783 insertions(+), 50 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_tc_matchall.c

-- 
2.38.1

