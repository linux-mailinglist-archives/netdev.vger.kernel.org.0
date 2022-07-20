Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A8957BDE4
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbiGTSfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbiGTSfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:35:03 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8765971BE9
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658342099; x=1689878099;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eblHT8gwx87a4epEigzYVB1XgfABttu+xSFRop3r89E=;
  b=P+w6FHI/B3FcVkv5VmxZanMirZ4/nO/oGexi5tH16RTkQvSiK4w9L6pH
   CIS0zCmliZV0Svbkyglqwc816HHjfBSoPjWveFFW2dgqjzrF2oAV5f7jb
   do/WIPYsdIlu97Dmof9ln6uqYSRfhhIpLivOyscZJAVNskOoTObDB/xmD
   bC7lkmimQnIqZAY3aIjg92MuzvYriWqs1+JUfDvUTp7YQHpZbftQrgixn
   EJ+Uz+NQUJDSPHtxE/KtkUg7vMSQNh9Z8885pbTKvFjUhSzXcbC3L0hEG
   2BLasghaUtvHalPWJil76xYPdRaHK0qIJV32E/+Km6JSI1d4RRzsQNaGU
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="285620851"
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="285620851"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 11:34:57 -0700
X-IronPort-AV: E=Sophos;i="5.92,287,1650956400"; 
   d="scan'208";a="925337483"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 11:34:57 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [iproute2-next PATCH 0/3] devlink: support dry run attribute for flash update
Date:   Wed, 20 Jul 2022 11:34:46 -0700
Message-Id: <20220720183449.2070222-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.35.1.456.ga9c7032d4631
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow users to request a dry run of a flash update by adding the
DEVLINK_ATTR_DRY_RUN.

Because many devlink commands do not validate and reject unknown attributes,
this could have unexpected side effects on older kernels which lack the
attribute. To handle this, check the socket and determine the maximum
attribute the kernel supports. Only allow passing the DEVLINK_ATTR_DRY_RUN
for kernels which have the attribute.

This allows a user to validate that a flash update will be accepted by the
driver and device without being forced to commit to updating.

Jacob Keller (3):
  update <linux/devlink.h> UAPI header
  mnlg: add function to get CTRL_ATTR_MAXATTR value
  devlink: add dry run attribute support to devlink flash

 devlink/devlink.c            | 45 +++++++++++++++++++++++++++--
 devlink/mnlg.c               | 56 ++++++++++++++++++++++++++++++++++++
 devlink/mnlg.h               |  1 +
 include/uapi/linux/devlink.h |  8 ++++++
 4 files changed, 108 insertions(+), 2 deletions(-)

-- 
2.36.1

