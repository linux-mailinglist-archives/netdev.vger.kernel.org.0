Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BFA6A6C02
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 13:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjCAMAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 07:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjCAMAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 07:00:14 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC812F7B7;
        Wed,  1 Mar 2023 04:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677672013; x=1709208013;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WRHLtls8wXHkKG0wPUdAzJHiEECJD6P2u5mrgkq32og=;
  b=VKeLANoWIAVuIIBVuspaM1v3ldoG16x1T3K29QsTGyUiwDiyyKz1IDKi
   GnNbXjgK6FNwWu0IXvJS+gO+PjrHceCwFVfU7h9nk7vzCZAJ5raup1SDU
   ImdASurrx12ydrjEFkyTE5Ivbtkeq6uTAbCRk4ol9FRCFZ0qj+wu5WZPF
   mO8FjADK549egf0XEU9HGl00F4kNdgfMNtiylilSM4livD240a4q4gr2J
   GUkOA9RD6InhcGDdfDu5UjhXrjj2sJOcbJ7JVHoRIItSXNrxxm+vJLmaM
   dDxVZIRZhc5mcd4dUvPWzfv4+D0ZtyVC4uOaO7vZczRrMoiQYJE7r6lPt
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="331870243"
X-IronPort-AV: E=Sophos;i="5.98,224,1673942400"; 
   d="scan'208";a="331870243"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 04:00:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="743405092"
X-IronPort-AV: E=Sophos;i="5.98,224,1673942400"; 
   d="scan'208";a="743405092"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga004.fm.intel.com with ESMTP; 01 Mar 2023 04:00:09 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id E2F9636A0B;
        Wed,  1 Mar 2023 12:00:08 +0000 (GMT)
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND net v1 0/2] iavf: fix double-broken HW hash report
Date:   Wed,  1 Mar 2023 12:59:06 +0100
Message-Id: <20230301115908.47995-1-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, passing HW hash from descriptors to skb is broken two times.
The first bug effectively disables hash from being filled at all, unless
%NETIF_F_RXHASH is *disabled* via Ethtool. The second incorrectly says
that IPv6 UDP packets are L3, which also triggers CPU hashing when
needed (the networking core treats only L4 HW hash as "true").
The very same problems were fixed in i40e and ice, but not in iavf,
although each of the original commits bugged at least two drivers.
It's never too late (I hope), so fix iavf this time.

Alexander Lobakin (2):
  iavf: fix inverted Rx hash condition leading to disabled hash
  iavf: fix non-tunneled IPv6 UDP packet type and hashing

 drivers/net/ethernet/intel/iavf/iavf_common.c | 2 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---
To Tony: this is very trivial and tested for a while already, I hope it
could hit one of the first couple RCs :p
-- 
2.39.2

