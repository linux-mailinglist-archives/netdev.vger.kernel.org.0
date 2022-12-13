Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D1564B3B5
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 12:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbiLMLEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 06:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235225AbiLMLEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 06:04:15 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C32625D1;
        Tue, 13 Dec 2022 03:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670929454; x=1702465454;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qUgI9kJMyxfeIBUg1MqvWukhfpYdTN7aNnJshDSAb0o=;
  b=IPw/dRoPVE1aEQp0LPUWPHFQly03zqFLYB4zhoMg8AceZR0eqeaa1cKE
   LrmBpxsSlNAiQptWVgfDUGkUXv9NaQL8n64rvbUvdRkxjXcF791O0mK8X
   3GPSb4jkM0MVxbtNBNscVhEwSmhz1oZeQKmlYVMKjKWlU7YArwxHLbX3T
   NqZpp73vCZo1f9Pvz7wR99ai0Kn18NW6wDmFyLxaEGNCeH7JXH7Yn6yG4
   deXb/cm2jB0aYvLmc7Fa9ICULqTWh0S82IkhGi06G5efsYHnlRDaC+I1+
   RJz1J3exr9uM+GZ7UItAf3AWJ2xnXDVfwspuXHqCdURWWmFp22GthxuDD
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="305744344"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="305744344"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 03:04:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="679263020"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="679263020"
Received: from unknown (HELO paamrpdk12-S2600BPB.aw.intel.com) ([10.228.151.145])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 03:04:11 -0800
From:   Tirthendu Sarkar <tirthendu.sarkar@intel.com>
To:     tirtha@gmail.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com
Subject: [PATCH intel-next 0/5] i40e: support XDP multi-buffer
Date:   Tue, 13 Dec 2022 16:20:18 +0530
Message-Id: <20221213105023.196409-1-tirthendu.sarkar@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds multi-buffer support for XDP. The first four patches
are prepatory patches while the fifth one contains actual multi-buffer
changes. 

Tirthendu Sarkar (5):
  i40e: add pre-xdp page_count in rx_buffer
  i40e: avoid per buffer next_to_clean access from i40e_ring
  i40e: introduce next_to_process to i40e_ring
  i40e: pull out rx buffer allocation to end of i40e_clean_rx_irq()
  i40e: add support for XDP multi-buffer Rx

 drivers/net/ethernet/intel/i40e/i40e_main.c |  18 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 378 ++++++++++++++------
 drivers/net/ethernet/intel/i40e/i40e_txrx.h |  13 +-
 3 files changed, 280 insertions(+), 129 deletions(-)

-- 
2.34.1

