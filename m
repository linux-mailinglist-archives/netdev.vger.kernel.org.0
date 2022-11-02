Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19EBF616250
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 12:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiKBL5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 07:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiKBL5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 07:57:48 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3575D201A3;
        Wed,  2 Nov 2022 04:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667390268; x=1698926268;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eHXjCjR53EpmujEkku0tYqKqKQxplCZnvIGw4J5fU5o=;
  b=iUgyuB5pzPAraouWrSyKO/36yi/3KjM31hCDnlmvo5nJy0gy+3g8Dte2
   w3aY9iH7iRoB99hXXH6o9pd/Ai2c+wuxrx8c4+IwhXsKWopOtWdp+77En
   9ABMJH+lmcsWbvCQpqTEYx92lS50GMWRvi+DadBDR7l3Ck7Q9igElYjGT
   rrSYBkvDjSoUJWnXcmUGeeIUQPvgFouEcZTWA4GA5AlzqYg76lqwIsONj
   7kzfbRkI4HXPRYvc3Kt1bf5Avxv8N3vO7pbUQ8REAZ0XCB+PSxVZb7MyI
   S3Tn7+eBOSFkzy5XvGPy7sXR4STWWlODRANH8DHTD+eooVtM6aEet3DDj
   g==;
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="121449310"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Nov 2022 04:57:47 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 2 Nov 2022 04:57:46 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 2 Nov 2022 04:57:43 -0700
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
Subject: [PATCH net-next v4 0/7] Extend TC key support for Sparx5 IS2 VCAP
Date:   Wed, 2 Nov 2022 12:57:30 +0100
Message-ID: <20221102115737.4118808-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
chain id must specify a destination outside the current VCAP lookup.

Delivery:
=========

This is current plan for delivering the full VCAP feature set of Sparx5:

Version History:
================
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

Steen Hegelund (7):
  net: microchip: sparx5: Differentiate IPv4 and IPv6 traffic in keyset
    config
  net: microchip: sparx5: Adding more tc flower keys for the IS2 VCAP
  net: microchip: sparx5: Find VCAP lookup from chain id
  net: microchip: sparx5: Adding TC goto action and action checking
  net: microchip: sparx5: Match keys in configured port keysets
  net: microchip: sparx5: Let VCAP API validate added key- and
    actionfields
  net: microchip: sparx5: Adding KUNIT tests of key/action values in
    VCAP API

 .../microchip/sparx5/sparx5_tc_flower.c       | 481 +++++++++++++++++-
 .../microchip/sparx5/sparx5_vcap_impl.c       | 168 +++++-
 .../net/ethernet/microchip/vcap/vcap_api.c    | 268 +++++++++-
 .../ethernet/microchip/vcap/vcap_api_client.h |  15 +
 .../ethernet/microchip/vcap/vcap_api_kunit.c  | 447 ++++++++++++++++
 5 files changed, 1338 insertions(+), 41 deletions(-)

-- 
2.38.1

