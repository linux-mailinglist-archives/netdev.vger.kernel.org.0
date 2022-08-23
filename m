Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B34D59E978
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbiHWR22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbiHWR0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:26:25 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFD0F2D4F
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 08:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661267089; x=1692803089;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZcvBUjHxVyzpqbjS5hgbqcdBRFu5Ik5pSDZcXEphY1k=;
  b=ZrBpO71zQ/XtFlePsYnrTzOd8wKMHVxifMpNVt4chDI1qRNToloM3JFj
   Q2Trq2rQ6biaC8dzcDJIaW8ZxcPLeeGmwvIDGszyfB3xW6XUxWSTFk1G0
   2irLd/TSNLJqJ9oFW/+sCtF/ahHRHbXWqyLtD71toKp0+y2oEsqAHIn0H
   whr/YVekCwM8gENTQXt2JTFwNb/IXPk0u9QhIBV/5Q3Yo4LUik1BSwMT4
   7Y5rCf38vYlGuWnWcWi9fh5ycSQ4VDzvvbUg6FaCpg31z2m+UabIA+n5F
   wWrLE7C27LxZbugEl80BZSLT5m51lDGAmO6QcPr6mTy0/dTMRP9cWfsaL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="273464956"
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="273464956"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 08:04:48 -0700
X-IronPort-AV: E=Sophos;i="5.93,258,1654585200"; 
   d="scan'208";a="854894249"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 08:04:48 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next 0/2] ice: support FEC automatic disable
Date:   Tue, 23 Aug 2022 08:04:36 -0700
Message-Id: <20220823150438.3613327-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.394.gc50926e1f488
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements support for users to configure automatic FEC
selection including the option of disabling FEC. It implements similar
behavior as a previous submission we made at

https://lore.kernel.org/netdev/20220714180311.933648-1-anthony.l.nguyen@intel.com/

This implementation varies, in that we now honor ETHTOOL_FEC_AUTO |
ETHTOOL_FEC_OFF as the new automatic plus disable mode.

This is in line with the request Jakub made to avoid using a new private
flag. I opted to use a bit-wise or of the two already supported flags rather
than trying to introduce a new flag.

I think this makes sense as essentially this is a request to automatically
select but also include "off" as a possible option. I'm not sure if this is
the best approach, but it seemed better than trying to add a new
ETHTOOL_FEC_AUTO_DISABLE or similarly confusing option. The need for this is
due to the quirk of how the ice firmware Link Establishment State Machine
works to decide what FEC mode to use.

Current userspace and the API already support multiple bit selection, though
it does have the downside of not guaranteeing consistency across drivers...
I'm open to alternative suggestions and implementations if someone has a
better suggestion.

Some alternatives we've considered already:

1) use a private flag

  Rejected for good reason, as private flags are difficult to discover and
  vary wildly across drivers. It also makes the driver behave differently to
  the same userspace request which may not be obvious to applications.

2) always treat ETHTOOL_FEC_AUTO as "automatic + allow disable"

  This could work, but it means that behavior will differ depending on the
  firmware version. Users have no way to know that and might be surprised to
  find the behavior differ across devices which have different firmware
  which do or don't support this variation of automatic selection.

2) introduce a new FEC mode to the ETHTOOL interface

  I considered just adding a brand new flag, but choosing a name here is
  relatively difficult. Most names read as some sort of "disable automatic
  selection" which isn't the best meaning.

3) use combined ETHTOOL_FEC_AUTO | ETHTOOL_FEC_OFF (this series)

  This version simply accepts a combined bitwise OR of ETHTOOL_FEC_AUTO and
  ETHTOOL_FEC_OFF. This was previously rejected by ice so it should not
  cause compatibility issues. The API already supports it, though it was
  noted the semantics of this combination are not well defined and could
  behave differently across drivers.

  This version has the downside of not being explicit in the API now since
  drivers may not all interpret this combination the same way. Thats
  understandably a concern, but I'm not sure what the best approach to avoid
  that here.

  This version does allow users to explicitly request the new behavior, and
  allows reporting an error when firmware can't support it.

To aid in reporting errors to userspace, I also extended the .set_fecparam
to take the netlink extended ACK struct. This allows directly reporting why
the option didn't take when using the netlink backed interface for ethtool.


Jacob Keller (2):
  ethtool: pass netlink extended ACK to .set_fecparam
  ice: add support for Auto FEC with FEC disabled via ETHTOOL_SFECPARAM

 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  3 +-
 .../ethernet/cavium/liquidio/lio_ethtool.c    |  3 +-
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |  3 +-
 .../ethernet/fungible/funeth/funeth_ethtool.c |  3 +-
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  3 +-
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  3 +-
 .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_common.c   | 54 ++++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_common.h   |  1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 15 ++++--
 drivers/net/ethernet/intel/ice/ice_main.c     |  3 +-
 drivers/net/ethernet/intel/ice/ice_type.h     |  9 +++-
 .../marvell/octeontx2/nic/otx2_ethtool.c      |  3 +-
 .../marvell/prestera/prestera_ethtool.c       |  3 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  3 +-
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  3 +-
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  3 +-
 .../net/ethernet/qlogic/qede/qede_ethtool.c   |  3 +-
 drivers/net/ethernet/sfc/ethtool_common.c     |  3 +-
 drivers/net/ethernet/sfc/ethtool_common.h     |  3 +-
 .../net/ethernet/sfc/siena/ethtool_common.c   |  3 +-
 .../net/ethernet/sfc/siena/ethtool_common.h   |  3 +-
 drivers/net/netdevsim/ethtool.c               |  3 +-
 include/linux/ethtool.h                       |  3 +-
 net/ethtool/fec.c                             |  2 +-
 net/ethtool/ioctl.c                           |  2 +-
 26 files changed, 115 insertions(+), 26 deletions(-)


base-commit: 90b3bee3a23249977852079b908270afc6ee03bb
-- 
2.37.1.394.gc50926e1f488

