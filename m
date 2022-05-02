Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E8C51789C
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 22:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387434AbiEBU4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 16:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbiEBU4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 16:56:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025596586
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 13:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651524763; x=1683060763;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sqqmemZ/5L+jEE02qzBX7TEd2cH2QoD6+mOw1SFfd2E=;
  b=HHkHvigbptZJxsOx1NjpkIcAmK1v8KM9r6I2UYH3n56mttM8xQgvVnGa
   6bn5JjGEuvKzMYO0zNDmnBhsFvjR3nwC/57dTVkwyGRk4RkEGb+Xa14+Y
   VUkISJtBprK3b1JijqqV4cCMWBoovAK2+n65zPJ9+CSVb2fPOzSdQIxlS
   wqwZ4fEkhtzmY05NG50ns+MFkpCeATZ9H7GEgRd/f6yRZL0doicn/02u7
   hUHLycQwg0aembDatAULOLn3WPyVhxXAcUurGP0rCkQW0jEnv1uiUHRVv
   WZ9hHp0k2+ySZAT2nSbStsWyHDjZeEHtn0pHBuLkwJ77oTw2SQDyThm8Y
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="353761110"
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="353761110"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 13:52:43 -0700
X-IronPort-AV: E=Sophos;i="5.91,193,1647327600"; 
   d="scan'208";a="733619564"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.141.55])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 13:52:43 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: [PATCH net-next 0/7] mptcp: Userspace path manager prerequisites
Date:   Mon,  2 May 2022 13:52:30 -0700
Message-Id: <20220502205237.129297-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series builds upon the path manager mode selection changes merged
in 4994d4fa99ba ("Merge branch 'mptcp-path-manager-mode-selection'") to
further modify the path manager code in preparation for adding the new
netlink commands to announce/remove advertised addresses and
create/destroy subflows of an MPTCP connection. The third and final
patch series for the userspace path manager will implement those
commands as discussed in
https://lore.kernel.org/netdev/23ff3b49-2563-1874-fa35-3af55d3088e7@linux.intel.com/#r

Patches 1, 5, and 7 remove some internal constraints on path managers
(in general) without changing in-kernel PM behavior.

Patch 2 adds a self test to validate MPTCP address advertisement ack
behavior.

Patches 3, 4, and 6 add new attributes to existing MPTCP netlink events
and track internal state for populating those attributes.


Kishen Maloor (6):
  mptcp: bypass in-kernel PM restrictions for non-kernel PMs
  mptcp: store remote id from MP_JOIN SYN/ACK in local ctx
  mptcp: reflect remote port (not 0) in ANNOUNCED events
  mptcp: establish subflows from either end of connection
  mptcp: expose server_side attribute in MPTCP netlink events
  mptcp: allow ADD_ADDR reissuance by userspace PMs

Mat Martineau (1):
  selftests: mptcp: ADD_ADDR echo test with missing userspace daemon

 include/uapi/linux/mptcp.h                    |  1 +
 net/mptcp/options.c                           |  4 +--
 net/mptcp/pm.c                                | 21 ++++++++---
 net/mptcp/pm_netlink.c                        | 36 ++++++++++++++++---
 net/mptcp/protocol.c                          |  5 +--
 net/mptcp/protocol.h                          | 18 +++++++---
 net/mptcp/subflow.c                           |  5 ++-
 .../testing/selftests/net/mptcp/mptcp_join.sh | 11 ++++++
 8 files changed, 81 insertions(+), 20 deletions(-)


base-commit: 0decb97cb105e85be979432bfc17491df7c6d6d1
-- 
2.36.0

