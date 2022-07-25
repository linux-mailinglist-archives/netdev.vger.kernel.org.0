Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD06580609
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbiGYU5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237265AbiGYU5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:57:00 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB5C23165;
        Mon, 25 Jul 2022 13:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658782619; x=1690318619;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7ccEV+/xeo51k2kZfZEV/UHYAHUAvNzlKxTD/caoJQs=;
  b=PFVm3dmHQyY45bgMFy6fqnys7ZdvaacKkwxW0anRIljSNUvaMeHhPvrp
   fQULED96HvXpvmEYJvbbjDkCaEbyQPuuziWt6wiIY+9Mq7V3eVE2DFPFP
   C0ukwgzoLQE9btfcYLQ8dsZ01sA37mimyZQhTLDmSTnPltNL08IOzEuvn
   zlWatLoRWzdg+ph8VhOYhyI3c41hUoUZZ2A033b4YoW47VFhLx4XOBfr7
   Vkk23exyTzUTJYgv1xWrCMiO97yrxL2oc9YwF/euKzNXHx6m9IJWitFTu
   cwqyEFyAkw8446HEB3g9KoSAe/bWuR6QbNkxHjewd61yt6CQw54D5UbR9
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="313548921"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="313548921"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 13:56:58 -0700
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="550135505"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.7])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 13:56:58 -0700
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
        linux-doc@vger.kernel.org
Subject: [iproute2-next v3 0/3] devlink: support dry run attribute for flash update
Date:   Mon, 25 Jul 2022 13:56:47 -0700
Message-Id: <20220725205650.4018731-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.208.ge72d93e88cb2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

Changes since v1
* Add Cc for maintainers
* Make dl_kernel_supports_dry_run more generic

Changes since v2
* Remove unnecessary () with return
* Reduce indentation of dl_get_max_attr

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

Jacob Keller (3):
  update <linux/devlink.h> UAPI header
  mnlg: add function to get CTRL_ATTR_MAXATTR value
  devlink: add dry run attribute support to devlink flash

 devlink/devlink.c            | 46 +++++++++++++++++++++++++++--
 devlink/mnlg.c               | 56 ++++++++++++++++++++++++++++++++++++
 devlink/mnlg.h               |  1 +
 include/uapi/linux/devlink.h |  8 ++++++
 4 files changed, 109 insertions(+), 2 deletions(-)


base-commit: 4cb0bec3744ac4f8d21de0e769f170e4059c6b9e
-- 
2.35.1.456.ga9c7032d4631

