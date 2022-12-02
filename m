Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D9C6402F6
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 10:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbiLBJLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 04:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbiLBJLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 04:11:34 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8448CBA0A6
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 01:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669972291; x=1701508291;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AABV7zjKvV25XIpIiBtUI3DsXO+r4iTch5c0JtJRpzo=;
  b=BnOLPByecbE+kA0EfO/Ja8fFjMKJRYaTsgxyVIR1kMvPoVE9Jj4Y8CfX
   rC5MbWNZlxXBIKwUN5Uu/TSVFDbLB1bCUiRgq8wdhq5F3ovVFAv4Awa0u
   aWyY5C2quLdlu4gqwseU8IkwgHebU+aQzf1s5RLcEUQvNrfIB7PGi9t7b
   30e2QDVQMQl87jvCW1MpjH6sFOhchMz5Eeb42xMFv3pJ6kYhDyoitreN3
   qOlsa1T08Qtgzuqx0igIEwEYh3J64ITxZRgQXSbBNPkHmw5oZRJ1bhC1p
   gdtvkGq+gORvTXjTqljbsFtSXAGEUoK5hgU5hF159nYtCoxVLxofUHg8A
   g==;
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="191431568"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Dec 2022 02:11:31 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Dec 2022 02:11:30 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 2 Dec 2022 02:11:28 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <petrm@nvidia.com>, <maxime.chevallier@bootlin.com>,
        <vladimir.oltean@nxp.com>, <UNGLinuxDriver@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>
Subject: [PATCH iproute2-next v3 0/2] Add pcp-prio and new apptrust subcommand
Date:   Fri, 2 Dec 2022 10:22:33 +0100
Message-ID: <20221202092235.224022-1-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
form, where 'de' (drop-eligible) means DEI=1 and 'nd' (not-drop-eligible)
means DEI=0.

Map PCP 1 and DEI 0 to priority 1
$ dcb app add dev eth0 pcp-prio 1nd:1

Map PCP 1 and DEI 1 to priority 1
$ dcb app add dev eth0 pcp-prio 1de:1

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

Trust selectors dscp and pcp, in that order:
$ dcb apptrust set dev eth0 order dscp pcp

Trust selectors ethtype, stream-port and pcp, in that order
$ dcb apptrust set dev eth0 order ethtype stream-port pcp

Show the trust order
$ dcb apptrust show dev eth0 order order: ethtype stream-port pcp

A concern was raised here [2], that 'apptrust' would not work well with
matches(), so instead strcmp() has been used to match for the new
subcommand, as suggested here [3]. Same goes with pcp-prio parameter for
dcb app.

The man page for dcb_app has been extended to cover the new pcp-prio
parameter, and a new man page for dcb_apptrust has been created.

[1] https://lore.kernel.org/netdev/20221101094834.2726202-1-daniel.machon@microchip.com/
[2] https://lore.kernel.org/netdev/20220909080631.6941a770@hermes.local/
[3] https://lore.kernel.org/netdev/Y0fP+9C0tE7P2xyK@shredder/

================================================================================

v2 -> v3:
  - Add macro for maximum pcp/dei value.

v1 -> v2:
  - Modified dcb_cmd_apptrust_set() to allow multiple consecutive parameters.
  - Added dcb_apptrust_print() to print everything in case of no argument.
  - Renamed pcp keys 0-7 to 0nd-7nd.
  - Renamed selector names in dcb-apptrust to reflect names used in dcb-app.
  - Updated dcb-app manpage to reflect new selector names, and removed part
    about hardware offload.
  - Updated dcb-apptrust manpage to reflect new selector names, and modified the
    description of the 'order' parameter.
  - Replaced uses of parse_one_of() with loops, for new 1nd:1 semantics to be
    parsed correctly, and not printing an error if selector was not found in
    list.

Daniel Machon (2):
  dcb: add new pcp-prio parameter to dcb app
  dcb: add new subcommand for apptrust

 dcb/Makefile            |   3 +-
 dcb/dcb.c               |   4 +-
 dcb/dcb.h               |   7 +
 dcb/dcb_app.c           | 142 ++++++++++++++++++-
 dcb/dcb_apptrust.c      | 307 ++++++++++++++++++++++++++++++++++++++++
 man/man8/dcb-app.8      |  32 +++++
 man/man8/dcb-apptrust.8 | 109 ++++++++++++++
 7 files changed, 595 insertions(+), 9 deletions(-)
 create mode 100644 dcb/dcb_apptrust.c
 create mode 100644 man/man8/dcb-apptrust.8

--
2.34.1

