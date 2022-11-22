Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4800C633A2F
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 11:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbiKVKeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 05:34:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbiKVKd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 05:33:58 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B28C185
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669113033; x=1700649033;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fWkkHyPwf8i9Y9pf+HKCOHoystoL8HjLKwUhyVryvCc=;
  b=KJ4E29umAIuno246RcS1O6YA2XniOoTH3zcidcgyx6B0rNLqIRS1ogfT
   G4X6Dgo7PUYlJLXNenWtHM6kBP04X3HiwQJk/kgT885q8dn6lAw36/KAi
   jKZVvDZVdF4mAaGja9bxqvdetqhElzI2/XhwJqU175L4fkpSrJ98mGBCS
   5LotEDXsMakx1pRN9ESxydKHngajp5xX/ndCVk3OGYAgG3SIoRojPMv4D
   H80Y4mLFyu31a+Vt2zX9nQOepIQxFhd7ibaxT93t4cMnvR4pDPpp5LZYh
   05NQEkcpCpNImoIzgODjhJoWUHYcxjlOZHlCR0thBXeCfV72cfGXfseB1
   w==;
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="184648167"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Nov 2022 03:30:32 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 22 Nov 2022 03:30:31 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 22 Nov 2022 03:30:29 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <petrm@nvidia.com>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <UNGLinuxDriver@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>
Subject: [PATCH iproute2-next 0/2] Add pcp-prio and new apptrust subcommand
Date:   Tue, 22 Nov 2022 11:41:10 +0100
Message-ID: <20221122104112.144293-1-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series makes use of the newly introduced [1] DCB_APP_SEL_PCP
selector, for PCP/DEI prioritization, and DCB_ATTR_IEEE_APP_TRUST
attribute for configuring per-selector trust and trust-order.

========================================================================
New parameter "pcp-prio" to existing "app" subcommand:
========================================================================

A new pcp-prio parameter has been added to the app subcommand, which can
be used to classify traffic based on PCP and DEI from the VLAN header.
PCP and DEI is specified in a combination of numerical and symbolic
form, where 'de' (as specified in the PCP Encoding Table, 802.1Q) means
DEI=1.

Map PCP 1 and DEI 0 to priority 1 $ dcb app add dev eth0 pcp-prio 1:1

Map PCP 1 and DEI 1 to priority 1 $ dcb app add dev eth0 pcp-prio 1de:1

In a hardware offloaded context, 'de' can be used by drivers, to map the
DEI bit directly to a drop-precedence.

========================================================================
New apptrust subcommand for configuring per-selector trust and trust
order:
========================================================================

This new command currently has a single parameter, which lets you
specify an ordered list of trusted selectors. The microchip sparx5
driver is already enabled to offload said list of trusted selectors. The
new command has been given the name apptrust, to indicate that the trust
covers APP table selectors only. I found that 'apptrust' was better than
plain 'trust' as the latter does not indicate the scope of what is to be
trusted.

Example:

Trust selectors dscp and pcp, in that order: $ dcb apptrust set dev eth0
order dscp pcp

Trust selectors ethertype, stream and pcp, in that order $ dcb apptrust
set dev eth0 order eth stream pcp

Show the trust order $ dcb apptrust show dev eth0 order trust-order: eth
stream pcp

A concern was raised here [2], that 'apptrust' would not work well with
matches(), so instead strcmp() has been used to match for the new
subcommand, as suggested here [3]. Same goes with pcp-prio parameter for
dcb app.

The man page for dcb_app has been extended to cover the new pcp-prio
parameter, and a new man page for dcb_apptrust has been created.

[1] https://lore.kernel.org/netdev/20221101094834.2726202-1-daniel.machon@microchip.com/
[2] https://lore.kernel.org/netdev/20220909080631.6941a770@hermes.local/
[3] https://lore.kernel.org/netdev/Y0fP+9C0tE7P2xyK@shredder/

Daniel Machon (2):
  dcb: add new pcp-prio parameter to dcb app
  dcb: add new subcommand for apptrust

 dcb/Makefile            |   3 +-
 dcb/dcb.c               |   4 +-
 dcb/dcb.h               |   7 +
 dcb/dcb_app.c           | 138 ++++++++++++++++++-
 dcb/dcb_apptrust.c      | 291 ++++++++++++++++++++++++++++++++++++++++
 man/man8/dcb-app.8      |  27 ++++
 man/man8/dcb-apptrust.8 | 118 ++++++++++++++++
 7 files changed, 580 insertions(+), 8 deletions(-)
 create mode 100644 dcb/dcb_apptrust.c
 create mode 100644 man/man8/dcb-apptrust.8

-- 
2.34.1

