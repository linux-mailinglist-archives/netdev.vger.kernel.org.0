Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D0756795F
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 23:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbiGEVcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 17:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiGEVcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 17:32:23 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBB910DB
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 14:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657056742; x=1688592742;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vTj5n/IVqMNnpXG7LhYZtb5VGdMLg/9nX8w5ofJkR0M=;
  b=Guypm6Y0zIEyiGKAfwm2MV8k3yy5ORJZkv13c1+iryw7pDAD1fsWlU0g
   k7nc/PAUEY8FGOCbUr6staBH/W9mQpxZTiGJJ8TZZliMNIpoAnUXK2QFF
   s3GNouBpUubKVt3f0CSI959IR5N6MY82evyVWe5RxslAYXoDs6y2iJeg/
   1FwZZS9VBRW6xwuAWNQb8nZicD+laqmrHgRqGCIrWWPT6bi1W9Fb+s7hr
   zI3FktTvGM5EvpjIAfuyiRI/0vuiFHQh5kVQuzNgrEGtXBloFKispN9xd
   VCTsG70WiMBSTP+/eaXFZYq5yoPWr3oadZ35nn2OrSD14ePSpQWOPmUbx
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="284633917"
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="284633917"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 14:32:22 -0700
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="590558740"
Received: from rcenter-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.17.169])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 14:32:22 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, fw@strlen.de, geliang.tang@suse.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: [PATCH net 0/7] mptcp: Path manager fixes for 5.19
Date:   Tue,  5 Jul 2022 14:32:10 -0700
Message-Id: <20220705213217.146898-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MPTCP userspace path manager is new in 5.19, and these patches fix
some issues in that new code.

Patches 1-3 fix path manager locking issues.

Patches 4 and 5 allow userspace path managers to change priority of
established subflows using the existing MPTCP_PM_CMD_SET_FLAGS generic
netlink command. Includes corresponding self test update.

Patches 6 and 7 fix accounting of available endpoint IDs and the
MPTCP_MIB_RMSUBFLOW counter.

Geliang Tang (1):
  mptcp: update MIB_RMSUBFLOW in cmd_sf_destroy

Kishen Maloor (2):
  mptcp: netlink: issue MP_PRIO signals from userspace PMs
  selftests: mptcp: userspace PM support for MP_PRIO signals

Mat Martineau (2):
  mptcp: Avoid acquiring PM lock for subflow priority changes
  mptcp: Acquire the subflow socket lock before modifying MP_PRIO flags

Paolo Abeni (2):
  mptcp: fix locking in mptcp_nl_cmd_sf_destroy()
  mptcp: fix local endpoint accounting

 net/mptcp/options.c                           |  3 +
 net/mptcp/pm_netlink.c                        | 46 ++++++++----
 net/mptcp/pm_userspace.c                      | 51 +++++++++----
 net/mptcp/protocol.c                          |  9 ++-
 net/mptcp/protocol.h                          |  9 ++-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c | 73 ++++++++++++++++++-
 .../selftests/net/mptcp/userspace_pm.sh       | 32 ++++++++
 7 files changed, 192 insertions(+), 31 deletions(-)


base-commit: 029cc0963412c4f989d2731759ce4578f7e1a667
-- 
2.37.0

