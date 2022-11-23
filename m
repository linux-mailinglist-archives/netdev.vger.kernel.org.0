Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883C5636B95
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236657AbiKWUvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235815AbiKWUvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:51:13 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D025697D0
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669236672; x=1700772672;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HR3zBrLvOguC77lpeeTqM32kWvWafxdrX8dFSa8LtRA=;
  b=IBDVUnWG+jnDecs0fXazmF7a2JO3Bw/uCWguTD1RY0XPNc+EbAo5JXeq
   XDWtHuDDdNOmusfueafudpzkT8ryhqILUbdizSDa2lHWMi5Qe0/TbZA0y
   TnGSifIBwFFWE7RXLgOGfC9NO/ixoxZJ71CdKSKoQus/dMkoBWAWidfcy
   GU45WXVQzE7D74Gjo3SRa+nLGmTThdUgzMqgSq+Gl07u4M3LC5FksHMlQ
   l3L2xYn0vfUsk/qHTS3v2QedmfQ+awiSar34cdqQBNaIz3ZOx/SX0NsjC
   p+U2/zrxu1GNm1L9AFlxD/Fz5pI71EMXs0evc1M+ooZq/ruzq5z01D+U2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="293862663"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="293862663"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:51:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="747947686"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="747947686"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by fmsmga002.fm.intel.com with ESMTP; 23 Nov 2022 12:51:12 -0800
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     netdev@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: [PATCH v2 net-next 0/6] Remove uses of kmap_atomic()
Date:   Wed, 23 Nov 2022 12:52:13 -0800
Message-Id: <20221123205219.31748-1-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmap_atomic() is being deprecated. This little series replaces the last
few uses of kmap_atomic() in the networking subsystem.

This series triggered a suggestion [1] that perhaps the Sun Cassini,
LDOM Virtual Switch Driver and the LDOM virtual network drivers should be
removed completely. I plan to do this in a follow up patchset. For
completeness, this series still includes kmap_atomic() conversions that
apply to the above referenced drivers. If for some reason we choose to not
remove these drivers, at least they won't be using kmap_atomic() anymore.

Also, the following maintainer entries for the Chelsio driver seem to be
defunct:

  Vinay Kumar Yadav <vinay.yadav@chelsio.com>
  Rohit Maheshwari <rohitm@chelsio.com>

I can submit a follow up patch to remove these entries, but thought
maybe the folks over at Chelsio would want to look into this first.

Changes v1 -> v2:
  Use memcpy_from_page() in patches 2/6 and 4/6
  Add new patch for the thunderbolt driver
  Update commit messages and cover letter

[1] https://lore.kernel.org/netdev/99629223-ac1b-0f82-50b8-ea307b3b0197@intel.com/T/#m3da3759652a48f958ab852fa5499009b43ff8fdd

Anirudh Venkataramanan (6):
  ch_ktls: Use memcpy_from_page() instead of k[un]map_atomic()
  sfc: Use kmap_local_page() instead of kmap_atomic()
  cassini: Use page_address() instead of kmap_atomic()
  cassini: Use memcpy_from_page() instead of k[un]map_atomic()
  sunvnet: Use kmap_local_page() instead of kmap_atomic()
  net: thunderbolt: Use kmap_local_page() instead of kmap_atomic()

 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 26 +++++-----
 drivers/net/ethernet/sfc/tx.c                 |  4 +-
 drivers/net/ethernet/sun/cassini.c            | 48 ++++++-------------
 drivers/net/ethernet/sun/sunvnet_common.c     |  4 +-
 drivers/net/thunderbolt.c                     |  8 ++--
 5 files changed, 35 insertions(+), 55 deletions(-)


base-commit: e80bd08fd75a644e2337fb535c1afdb6417357ff
-- 
2.37.2

