Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A866683FA
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 21:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbjALUPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 15:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240739AbjALUNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 15:13:41 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B08C01;
        Thu, 12 Jan 2023 12:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673553838; x=1705089838;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nfq4nL4FT0YM5dexEnaI0SAiUHpTKSX9GeNSf0o/w10=;
  b=cTlYWKHyFQkeLwWe8wlEOAhRQEoRwwHUdOE7hJ0zlUtK6uvy3yIW8apC
   rhVMEFgfVI0SlMtGZg1qaGUVjgbYlSWKqswoFuIPlCwALujVmRN+FhQUW
   VV9KHJxu0vk6a7JDG7FnE7q5emxuoYKC4ezLAGiU9g68Ldfg0YbNuGWH9
   HgEyTzOjxiQbebOdz9zFS43iIvP+B+72V5Im68biw05CbmSiqNv4bBQHR
   59hu3f/DsVpBC28kg0iWthxQb75DzIz+Lo6n78ZH559TRXI/Z2kDJR8Oe
   Oq9msjBQ5iNLAHfb8I9oN6AUV59QoQrN00Dqsw9wKnU7FZI2qa3bNH4qz
   w==;
X-IronPort-AV: E=Sophos;i="5.97,211,1669100400"; 
   d="scan'208";a="195535553"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jan 2023 13:03:57 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 13:03:51 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 12 Jan 2023 13:03:48 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <error27@gmail.com>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <petrm@nvidia.com>,
        <vladimir.oltean@nxp.com>, <maxime.chevallier@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 0/6] Introduce new DCB rewrite table
Date:   Thu, 12 Jan 2023 21:15:48 +0100
Message-ID: <20230112201554.752144-1-daniel.machon@microchip.com>
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

There is currently no support for per-port egress mapping of priority to PCP and
priority to DSCP. Some support for expressing egress mapping of PCP is supported
through ip link, with the 'egress-qos-map', however this command only maps
priority to PCP, and for vlan interfaces only. DCB APP already has support for
per-port ingress mapping of PCP/DEI, DSCP and a bunch of other stuff. So why not
take advantage of this fact, and add a new table that does the reverse.

This patch series introduces the new DCB rewrite table. Whereas the DCB
APP table deals with ingress mapping of PID (protocol identifier) to priority,
the rewrite table deals with egress mapping of priority to PID.

It is indeed possible to integrate rewrite in the existing APP table, by
introducing new dedicated rewrite selectors, and altering existing functions
to treat rewrite entries specially. However, I feel like this is not a good
solution, and will pollute the APP namespace. APP is well-defined in IEEE, and
some userspace relies of advertised entries - for this fact, separating APP and
rewrite into to completely separate objects, seems to me the best solution.

The new table shares much functionality with the APP table, and as such, much
existing code is reused, or slightly modified, to work for both.

================================================================================
DCB rewrite table in a nutshell
================================================================================
The table is implemented as a simple linked list, and uses the same lock as the
APP table. New functions for getting, setting and deleting entries have been
added, and these are exported, so they can be used by the stack or drivers.
Additionnaly, new dcbnl_setrewr and dcnl_delrewr hooks has been added, to
support hardware offload of the entries.

================================================================================
Sparx5 per-port PCP rewrite support
================================================================================
Sparx5 supports PCP egress mapping through two eight-entry switch tables.
One table maps QoS class 0-7 to PCP for DE0 (DP levels mapped to
drop-eligibility 0) and the other for DE1. DCB does currently not have support
for expressing DP/color, so instead, the tagged DEI bit will reflect the DP
levels, for any rewrite entries> 7 ('de').

The driver will take apptrust (contributed earlier) into consideration, so
that the mapping tables only be used, if PCP is trusted *and* the rewrite table
has active mappings, otherwise classified PCP (same as frame PCP) will be used
instead.

================================================================================
Sparx5 per-port DSCP rewrite support
================================================================================
Sparx5 support DSCP egress mapping through a single 32-entry table. This table
maps classified QoS class and DP level to classified DSCP, and is consulted by
the switch Analyzer Classifier at ingress. At egress, the frame DSCP can either
be rewritten to classified DSCP to frame DSCP.

The driver will take apptrust into consideration, so that the mapping tables
only be used, if DSCP is trusted *and* the rewrite table has active mappings,
otherwise frame DSCP will be used instead.

================================================================================
Patches
================================================================================
Patch #1 modifies dcb_app_add to work for both APP and rewrite

Patch #2 adds dcbnl_apprewr_setdel() for setting and deleting both APP and
         rewrite entries.

Patch #3 adds the rewrite table and all required functions, offload hooks and
         bookkeeping for maintaining it.

Patch #4 adds two new helper functions for getting a priority to PCP bitmask
         map, and a priority to DSCP bitmask map.

Patch #5 adds support for PCP rewrite in the Sparx5 driver
Patch #6 adds support for DSCP rewrite in the Sparx5 driver

Daniel Machon (6):
  net: dcb: modify dcb_app_add to take list_head ptr as parameter
  net: dcb: add new common function for set/del of app/rewr entries
  net: dcb: add new rewrite table
  net: dcb: add helper functions to retrieve PCP and DSCP rewrite maps
  net: microchip: sparx5: add support for PCP rewrite
  net: microchip: sparx5: add support for DSCP rewrite

 .../ethernet/microchip/sparx5/sparx5_dcb.c    | 121 +++++++-
 .../microchip/sparx5/sparx5_main_regs.h       |  70 ++++-
 .../ethernet/microchip/sparx5/sparx5_port.c   |  97 ++++++
 .../ethernet/microchip/sparx5/sparx5_port.h   |  41 +++
 include/net/dcbnl.h                           |  18 ++
 include/uapi/linux/dcbnl.h                    |   1 +
 net/dcb/dcbnl.c                               | 275 ++++++++++++++----
 7 files changed, 550 insertions(+), 73 deletions(-)

--
2.34.1

