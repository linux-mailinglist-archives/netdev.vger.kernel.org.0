Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B415426BC
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbiFHFnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 01:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbiFHFlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 01:41:17 -0400
Received: from EX-PRD-EDGE01.vmware.com (ex-prd-edge01.vmware.com [208.91.3.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE27D408F12;
        Tue,  7 Jun 2022 20:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
    s=s1024; d=vmware.com;
    h=from:to:cc:subject:date:message-id:mime-version:content-type;
    bh=1BUi8d5EMlZl/6FL5lU4CcT+7fh78Kg9w0myO9YPw44=;
    b=t/YdP0N7G0KLNXkFy7MZlPc94BdVX3mEXUKsA2yVexppkt0Mw3L6uDXLeMkNe2
      cc5J71eRmbmSJvRLGn4ID4UHWJeFrP620CogO8D3oGJoJ8D1eVGQ+m2SLZ/LyE
      cgoeZxoo52l/odIOEzM6KrVCBxH6CSEm3nJc2rvCW5MV5u4=
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX-PRD-EDGE01.vmware.com (10.188.245.6) with Microsoft SMTP Server id
 15.1.2308.20; Tue, 7 Jun 2022 20:23:42 -0700
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.216])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id CF895202DC;
        Tue,  7 Jun 2022 20:23:57 -0700 (PDT)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id C87B3AA454; Tue,  7 Jun 2022 20:23:57 -0700 (PDT)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 net-next 0/8] vmxnet3: upgrade to version 7
Date:   Tue, 7 Jun 2022 20:23:45 -0700
Message-ID: <20220608032353.964-1-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX-PRD-EDGE01.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vmxnet3 emulation has recently added several new features including
support for uniform passthrough(UPT). To make UPT work vmxnet3 has
to be enhanced as per the new specification. This patch series
extends the vmxnet3 driver to leverage these new features.

Compatibility is maintained using existing vmxnet3 versioning mechanism as
follows:
 - new features added to vmxnet3 emulation are associated with new vmxnet3
   version viz. vmxnet3 version 7.
 - emulation advertises all the versions it supports to the driver.
 - during initialization, vmxnet3 driver picks the highest version number
 supported by both the emulation and the driver and configures emulation
 to run at that version.

In particular, following changes are introduced:

Patch 1:
  This patch introduces utility macros for vmxnet3 version 7 comparison
  and updates Copyright information.

Patch 2:
  This patch adds new capability registers to fine control enablement of
  individual features based on emulation and passthrough.

Patch 3:
  This patch adds support for large passthrough BAR register.

Patch 4:
  This patch adds support for out of order rx completion processing.

Patch 5:
  This patch introduces new command to set ring buffer sizes to pass this
  information to the hardware.

Patch 6:
  For better performance, hardware has a requirement to limit number of TSO
  descriptors. This patch adds that support.

Patch 7:
  With vmxnet3 version 7, new descriptor fields are used to indicate
  encapsulation offload.

Patch 8:
  With all vmxnet3 version 7 changes incorporated in the vmxnet3 driver,
  with this patch, the driver can configure emulation to run at vmxnet3
  version 7.

Changes in v2->v3:
 - use correct byte ordering for ringBufSize

Changes in v2:
 - use local rss_fields variable for the rss capability checks in patch 2

Ronak Doshi (8):
  vmxnet3: prepare for version 7 changes
  vmxnet3: add support for capability registers
  vmxnet3: add support for large passthrough BAR register
  vmxnet3: add support for out of order rx completion
  vmxnet3: add command to set ring buffer sizes
  vmxnet3: limit number of TXDs used for TSO packet
  vmxnet3: use ext1 field to indicate encapsulated packet
  vmxnet3: update to version 7

 drivers/net/vmxnet3/Makefile          |   2 +-
 drivers/net/vmxnet3/upt1_defs.h       |   2 +-
 drivers/net/vmxnet3/vmxnet3_defs.h    |  80 ++++++++--
 drivers/net/vmxnet3/vmxnet3_drv.c     | 291 ++++++++++++++++++++++++++++++----
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 116 ++++++++++++--
 drivers/net/vmxnet3/vmxnet3_int.h     |  24 ++-
 6 files changed, 457 insertions(+), 58 deletions(-)

-- 
2.11.0

