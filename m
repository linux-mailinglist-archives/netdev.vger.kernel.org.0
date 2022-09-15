Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CF55B981A
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 11:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiIOJvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 05:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiIOJvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 05:51:25 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F759C227
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 02:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663235359; x=1694771359;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=q70WwKGxyUvyHH4OXv8q0orZO31IQhsIlh477aei6fc=;
  b=P5p/HjQScPLLkqnxheG5qsGELA37+6fAG6Jrr+G6MKFLM2vVYVt8VK5i
   wIsGjAaJNfTnTCErRki4s7K+5CYGOoT2IIIy6W2DP8JxOHWWf5EnPxfvd
   7hJF8rPBjRiOBi29wa+CcpGESXkNB44wO+TB4v8lPo23kJM+WY6pqszam
   t4OTrOLznwEUgSXScIUkkhFgkOIapA+5YXgmelCtdxP1WspwjrhZAV1UF
   /KNKe7hQdp0kPuRy4n7xrIk+XgXIaNLjKpQ0KkiQeS6hH0v7siyd7HwlZ
   39Hx8EuHCMJEKhAIlNhCO2vEYCEGELeqr4xuG+L5TYhVbJwGTa+R6mQXk
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,317,1654585200"; 
   d="scan'208";a="177279608"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Sep 2022 02:48:52 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 15 Sep 2022 02:48:52 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 15 Sep 2022 02:48:50 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <Allan.Nielsen@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <petrm@nvidia.com>, <kuba@kernel.org>, <vinicius.gomes@intel.com>,
        <thomas.petazzoni@bootlin.com>,
        Daniel Machon <daniel.machon@microchip.com>
Subject: [RFC PATCH v2 net-next 0/2] Add PCP selector and new APPTRUST attribute
Date:   Thu, 15 Sep 2022 11:57:55 +0200
Message-ID: <20220915095757.2861822-1-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for offloading PCP-based queue
classification and introduces a new APPTRUST extension attribute to the
8021Qaz APP managed object.  Prior to implemenation, it has been
discussed on the netdev mailing list here:

https://lore.kernel.org/netdev/Yv9VO1DYAxNduw6A@DEN-LT-70577/

In summary: there currently exist no conveinent way to offload per-port
PCP-based queue classification to hardware. Similarly, there is no way
to indicate the notion of trust for APP table selectors. This patch
series addresses both topics.

PCP based queue classification:

	8021Q standardizes the Priority Code Point table (see 6.9.3 of
	IEEE Std 802.1Q-2018).  This patch series makes it possible, to
	offload the PCP classification to said table.  The new PCP
	selector is not a standard part of the APP managed object,
	therefore it has been assigned a value of 255 to avoid any
	clashes with future DCB standard extensions.

Selector trust:

	ASIC's often has the notion of trust DSCP and trust PCP. This
	new object makes it possible to specify a trust order of app
	selectors, which drivers can then react on.

Patch #1 introduces a new PCP selector to the APP object, which makes it
possible to encode PCP and DEI in the app triplet and offload it to the
PCP table of the ASIC.

Patch #2 Introduces the new extension attributes
DCB_ATTR_DCB_APP_TRUST_TABLE and DCB_ATTR_DCB_APP_TRUST. Trusted
selectors are passed in the nested DCB_ATTR_DCB_APP_TRUST_TABLE
attribute, and assembled into an array of selectors:

  u8 selectors[256];

where lower indexes has higher precedence.  In the array, selectors are
stored consecutively, starting from index zero. With a maximum number of
256 unique selectors, the list has the same maximum size.

The userspace part of this will be posted in a separate patch series.

================================================================================

RFC v1:
https://lore.kernel.org/netdev/20220908120442.3069771-1-daniel.machon@microchip.com/

RFC v1 -> RFC v2:
  - Added new nested attribute type DCB_ATTR_DCB_APP_TRUST_TABLE.
  - Renamed attributes from DCB_ATTR_IEEE_* to DCB_ATTR_DCB_*
  - Renamed ieee_set/getapptrust to dcbnl_set/getapptrust
  - Added -EOPNOTSUPP if dcbnl_setapptrust is not set.
  - Added sanitization of selector array, before passing to driver.


Daniel Machon (2):
  net: dcb: add new pcp selector to app object
  net: dcb: add new apptrust attribute

 include/net/dcbnl.h        |  5 +++
 include/uapi/linux/dcbnl.h |  5 +++
 net/dcb/dcbnl.c            | 66 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 73 insertions(+), 3 deletions(-)

--
2.34.1

