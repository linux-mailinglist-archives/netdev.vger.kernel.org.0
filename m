Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13BE0604486
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 14:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbiJSMHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 08:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiJSMG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 08:06:58 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CDB18DD56;
        Wed, 19 Oct 2022 04:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666179826; x=1697715826;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UfzP9G/SBs4tsFqTQSE6DmVHlIdmeBAx54/bqwvgVxc=;
  b=xduvgn6za9gzPtMgQ9lwJ3wTbfvk0tuE3Uy1/Mi7P/aOtvMUqM1ECCh/
   ybtOYraxnsrZvz4AKqiXDrPllyptJSIjigA0Vus4Z4HrGSuZM9ylvBNOe
   h8tYiqCVlU1OM96RbgrR2j8Ju/027s/VZ3XS4WdDwVr76Gkv+vt1BlTwN
   8OrM3vkfCX8KsiztHp6E0icNdKpp5IMPqExJvncOXy/QXzRDIdRUkz5Vt
   TUcdYobuabnmOwhxJmfMJiwpz0GiCsILnafDCAwDZ86Nw/w6Xg29ICk1/
   NsXB6JDHsMVQnfULfwOhdeOpLhh4IoqXnpVdierKzXN2Ygca6D85U9nEa
   g==;
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="182926211"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Oct 2022 04:42:22 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 19 Oct 2022 04:42:22 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 19 Oct 2022 04:42:19 -0700
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
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next v2 0/9]  Add support for Sparx5 IS2 VCAP
Date:   Wed, 19 Oct 2022 13:42:06 +0200
Message-ID: <20221019114215.620969-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides initial support for the Sparx5 VCAP functionality via the 'tc'
traffic control userspace tool and its flower filter.

Version History:
================
v2      Made the KUNIT test model a superset of the real model to fix a
        kernel robot build error.

v1      Initial version

Overview:
=========

The supported flower filter keys and actions are:

- source and destination MAC address keys
- trap action
- pass action

The supported Sparx5 VCAPs are: IS2 (see below for more info)

The VCAP (Versatile Content-Aware Processor) feature is essentially a TCAM with
rules consisting of:

- Programmable key fields
- Programmable action fields
- A counter (which may be only one bit wide)

Besides this each VCAP has:

- A number of independent lookups
- A keyset configuration typically per port per lookup

VCAPs are used in many of the TSN features such as PSFP, PTP, FRER as well as
the general shaping, policing and access control, so it is an important building
block for these advanced features.

Functionality:
==============

When a frame is passed to a VCAP the VCAP will generate a set of keys (keyset)
based on the traffic type.  If there is a rule created with this keyset in the
VCAP and the values of the keys matches the values in the keyset of the frame,
the rule is said to match and the actions in the rule will be executed and the
rule counter will be incremented.  No more rules will be examined in this VCAP
lookup.

If there is no match in the current lookup the frame will be matched against the
next lookup (some VCAPs do the processing of the lookups in parallel).

The Sparx5 SoC has 6 different VCAP types:

- IS0: Ingress Stage 0 (AKA CLM) mostly handles classification
- IS2: Ingress Stage 2 mostly handles access control
- IP6PFX: IPv6 prefix: Provides tables for IPV6 address management
- LPM: Longest Path Match for IP guarding and routing
- ES0: Egress Stage 0 is mostly used for CPU copying and multicast handling
- ES2: Egress Stage 2 is known as the rewriter and mostly updates tags


Design:
=======

The VCAP implementation provides switchcore independent handling of rules
and supports:

- Creating and deleting rules
- Updating and getting rules

The platform specific API implementation as well as the platform specific model
of the VCAP instances are attached to the VCAP API and a client can then
access rules via the API in a platform independent way, with the
limitations that each VCAP has in terms of is supported keys and actions.

The VCAP model is generated from information delivered by the designers if the
VCAP hardware.

Here is an illustration of this:

  +------------------+     +------------------+
  | TC flower filter |     | PTP client       |
  | for Sparx5       |     | for Sparx5       |
  +-------------\----+     +---------/--------+
                 \                  /
                  \                /
                   \              /
                    \            /
                     \          /
                 +----v--------v----+
                 |     VCAP API     |
                 +---------|--------+
                           |
                           |
                           |
                           |
                 +---------v--------+
                 |   VCAP control   |
                 |   instance       |
                 +----/--------|----+
                     /         |
                    /          |
                   /           |
                  /            |
  +--------------v---+    +----v-------------+
  |   Sparx5 VCAP    |    | Sparx5 VCAP API  |
  |   model          |    | Implementation   |
  +------------------+    +---------|--------+
                                    |
                                    |
                                    |
                                    |
                          +---------v--------+
                          | Sparx5 VCAP HW   |
                          +------------------+

Delivery:
=========

For now only the IS2 is supported but later the IS0, ES0 and ES2 will be added.
There are currently no plans to support the IP6PFX and the LPM VCAPs.

The IS2 VCAP has 4 lookups and they are accessible with a TC chain id:

- chain 8000000: IS2 Lookup 0
- chain 8100000: IS2 Lookup 1
- chain 8200000: IS2 Lookup 2
- chain 8300000: IS2 Lookup 3

These lookups are executed in parallel by the IS2 VCAP but the actions are
executed in series (the datasheet explains what happens if actions overlap).

The functionality of TC flower as well as TC matchall filters will be expanded
in later submissions as well as the number of VCAPs supported.

This is current plan:

- add support for more TC flower filter keys and extend the Sparx5 port keyset
  configuration
- support for TC protocol all
- debugfs support for inspecting rules
- TC flower filter statistics
- Sparx5 IS0 VCAP support and more TC keys and actions to support this
- add TC policer and drop action support (depends on the Sparx5 QoS support
  upstreamed separately)
- Sparx5 ES0 VCAP support and more TC actions to support this
- TC flower template support
- TC matchall filter support for mirroring and policing ports
- TC flower filter mirror action support
- Sparx5 ES2 VCAP support


The LAN966x switchcore will also be updated to use the VCAP API as well as
future Microchip switches.
The LAN966x has 3 VCAPS (IS1, IS2 and ES0) and a slightly different keyset and
actionset portfolio than Sparx5.

Steen Hegelund (9):
  net: microchip: sparx5: Adding initial VCAP API support
  net: microchip: sparx5: Adding IS2 VCAP model to VCAP API
  net: microchip: sparx5: Adding IS2 VCAP register interface
  net: microchip: sparx5: Adding initial tc flower support for VCAP API
  net: microchip: sparx5: Adding port keyset config and callback
    interface
  net: microchip: sparx5: Adding basic rule management in VCAP API
  net: microchip: sparx5: Writing rules to the IS2 VCAP
  net: microchip: sparx5: Adding KUNIT test VCAP model
  net: microchip: sparx5: Adding KUNIT test for the VCAP API

 MAINTAINERS                                   |    1 +
 drivers/net/ethernet/microchip/Kconfig        |    1 +
 drivers/net/ethernet/microchip/Makefile       |    1 +
 drivers/net/ethernet/microchip/sparx5/Kconfig |    1 +
 .../net/ethernet/microchip/sparx5/Makefile    |    8 +-
 .../ethernet/microchip/sparx5/sparx5_main.c   |    9 +
 .../ethernet/microchip/sparx5/sparx5_main.h   |    6 +
 .../microchip/sparx5/sparx5_main_regs.h       |  460 +-
 .../net/ethernet/microchip/sparx5/sparx5_tc.c |   46 +
 .../net/ethernet/microchip/sparx5/sparx5_tc.h |   14 +
 .../microchip/sparx5/sparx5_tc_flower.c       |  256 +
 .../microchip/sparx5/sparx5_vcap_ag_api.c     | 1351 ++++
 .../microchip/sparx5/sparx5_vcap_ag_api.h     |   18 +
 .../microchip/sparx5/sparx5_vcap_impl.c       |  527 ++
 .../microchip/sparx5/sparx5_vcap_impl.h       |   20 +
 drivers/net/ethernet/microchip/vcap/Kconfig   |   52 +
 drivers/net/ethernet/microchip/vcap/Makefile  |    9 +
 .../net/ethernet/microchip/vcap/vcap_ag_api.h |  326 +
 .../microchip/vcap/vcap_ag_api_kunit.h        |  643 ++
 .../net/ethernet/microchip/vcap/vcap_api.c    | 1142 ++++
 .../net/ethernet/microchip/vcap/vcap_api.h    |  272 +
 .../ethernet/microchip/vcap/vcap_api_client.h |  195 +
 .../ethernet/microchip/vcap/vcap_api_kunit.c  |  933 +++
 .../microchip/vcap/vcap_model_kunit.c         | 5570 +++++++++++++++++
 .../microchip/vcap/vcap_model_kunit.h         |   10 +
 25 files changed, 11867 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
 create mode 100644 drivers/net/ethernet/microchip/vcap/Kconfig
 create mode 100644 drivers/net/ethernet/microchip/vcap/Makefile
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_ag_api_kunit.h
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api.c
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api.h
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api_client.h
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_model_kunit.c
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_model_kunit.h

-- 
2.38.1

