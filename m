Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B455057D5A4
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 23:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbiGUVP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 17:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbiGUVPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 17:15:25 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F062FFF7;
        Thu, 21 Jul 2022 14:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658438123; x=1689974123;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=70dL+TKinMdON+cgvUm+mfjuUHW7dRrlqBQG6XkWacw=;
  b=R7oBKk5+YgnxBWCZe2geYXh+35SOUDm56OVkAd4iWhR0hB/EjLZ46hSd
   7b+GiEO548E4DkxUeShBde9u7VMsL2JkpVZ5lXCxWTKyf1KoCdbWEJQLx
   cphUmMiziioLUmNSdavYzaqvEFrJ8HuNip4iqfwCIjOwqE4BUPUFJDnWC
   X59rI1iC4PIGvgT/YcvrS4HoPyxLpxAH1kEXbQYqTALPq4OJC2IzO4EBr
   blorAyOlNaqcJcqzV2TX6HiTxDW3JmXxfD0nG75U8S1puLB/mEswvytbm
   fGYlLlMu5ejphvGM2Ei+3wV+R2Lgovv93eooAkGs9DONnGGnYgW3GxtJE
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10415"; a="312892753"
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="312892753"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 14:14:58 -0700
X-IronPort-AV: E=Sophos;i="5.93,183,1654585200"; 
   d="scan'208";a="925816174"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 14:14:58 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-doc@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: [net-next v2 0/2] devlink: implement dry run support for flash update
Date:   Thu, 21 Jul 2022 14:14:45 -0700
Message-Id: <20220721211451.2475600-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.35.1.456.ga9c7032d4631
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a re-send of the dry run support I submitted nearly a year ago at
https://lore.kernel.org/netdev/CO1PR11MB50898047B9C0FAA520505AFDD6B59@CO1PR11MB5089.namprd11.prod.outlook.com/

I had delayed sending this because of conflicting work in the ice driver at
the time, but then forgot about it and never got around to resubmitting it.

This adds a DEVLINK_ATTR_DRY_RUN which is used to indicate a request to
validate a potentially destructive operation without performing the actions
yet. In theory it could be used for other devlink operations in the future.

For flash update, it allows the user to validate a flash image, including
ensuring the driver for the device is willing to program it, without
actually committing an update yet.

There is an accompanying series for iproute2 which allows adding the dry-run
attribute. It does as Jakub suggested and checks the maximum attribute
before allowing the dry run in order to avoid accidentally performing a real
update on older kernels.

Changes since v1:
* Added maintainers to Cc (thanks for pointing out the script, Jiri!)
* Replaced bool in struct with u8 : 1
* Added kernel doc to devlink_flash_update_params
* Renamed PLDMFW parameter from dry_run to validate
* Reduced indentation in devlink.c by using nla_get_flag

Cc: Jacob Keller <jacob.e.keller@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jiri Pirko <jiri@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: linux-doc@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: intel-wired-lan@lists.osuosl.org

Jacob Keller (2):
  devlink: add dry run attribute to flash update
  ice: support dry run of a flash update to validate firmware file

 Documentation/driver-api/pldmfw/index.rst     | 10 ++++++++
 .../networking/devlink/devlink-flash.rst      | 23 +++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_devlink.c  |  3 ++-
 .../net/ethernet/intel/ice/ice_fw_update.c    | 14 +++++++----
 include/linux/pldmfw.h                        |  5 ++++
 include/net/devlink.h                         |  4 ++++
 include/uapi/linux/devlink.h                  |  8 +++++++
 lib/pldmfw/pldmfw.c                           | 12 ++++++++++
 net/core/devlink.c                            | 17 +++++++++++++-
 9 files changed, 90 insertions(+), 6 deletions(-)


base-commit: 5588d628027092e66195097bdf6835ddf64418b3
-- 
2.35.1.456.ga9c7032d4631

