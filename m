Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FC96ACFD9
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCFVJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjCFVJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:09:40 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB4443456;
        Mon,  6 Mar 2023 13:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678136979; x=1709672979;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Dk9EQNXEx5Ojom+4VsTQkpeaN0P38kKz18vt5a8IrE0=;
  b=ETRaKQaJJ0aT+YyRxmgR5oTpzOjd5i+vZL1USnTRjWQTUhGeve+8LYL+
   wqHzzpHS19fso5JeB/agKsZBFVIUJxQOC5FiCAr0BKTYJDeLkdoOZTmbT
   p+35GmCm+c7TFrYFPwDUCK2rtJLsC4BxDFIXAu87/usvRi92635hHs17M
   x9oAlQWbWjBX+Oyos8qGbRIy8VXyHQsB2VOlruyqLhlbJk8vwa4KQHgQH
   TzLLZFScg73cTSaOXKg01QV2QfsqOBB9eHCieGEb39SkPcTwWcHoXNKP4
   6q5NQMvIP33IM2OhQZ62xNWtqhvuhnP2DbSEe2HYlhFhKyxnJqvu9lAvJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="337999299"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="337999299"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 13:09:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="800137860"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="800137860"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga004.jf.intel.com with ESMTP; 06 Mar 2023 13:09:38 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org
Subject: [PATCH net-next 0/8][pull request] i40e: support XDP multi-buffer
Date:   Mon,  6 Mar 2023 13:08:14 -0800
Message-Id: <20230306210822.3381942-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
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

Tirthendu Sarkar says:

This patchset adds multi-buffer support for XDP. Tx side already has
support for multi-buffer. This patchset focuses on Rx side. The last
patch contains actual multi-buffer changes while the previous ones are
preparatory patches.

On receiving the first buffer of a packet, xdp_buff is built and its
subsequent buffers are added to it as frags. While 'next_to_clean' keeps
pointing to the first descriptor, the newly introduced 'next_to_process'
keeps track of every descriptor for the packet. 

On receiving EOP buffer the XDP program is called and appropriate action
is taken (building skb for XDP_PASS, reusing page for XDP_DROP, adjusting
page offsets for XDP_{REDIRECT,TX}).

The patchset also streamlines page offset adjustments for buffer reuse
to make it easier to post process the rx_buffers after running XDP prog.

With this patchset there does not seem to be any performance degradation
for XDP_PASS and some improvement (~1% for XDP_TX, ~5% for XDP_DROP) when
measured using xdp_rxq_info program from samples/bpf/ for 64B packets.

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

The following are changes since commit 5ca26d6039a6b42341f7f5cc8d10d30ca1561a7b:
  Merge tag 'net-6.3-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Tirthendu Sarkar (8):
  i40e: consolidate maximum frame size calculation for vsi
  i40e: change Rx buffer size for legacy-rx to support XDP multi-buffer
  i40e: add pre-xdp page_count in rx_buffer
  i40e: Change size to truesize when using i40e_rx_buffer_flip()
  i40e: use frame_sz instead of recalculating truesize for building skb
  i40e: introduce next_to_process to i40e_ring
  i40e: add xdp_buff to i40e_ring struct
  i40e: add support for XDP multi-buffer Rx

 drivers/net/ethernet/intel/i40e/i40e_main.c  |  78 ++--
 drivers/net/ethernet/intel/i40e/i40e_trace.h |  20 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c  | 420 +++++++++++--------
 drivers/net/ethernet/intel/i40e/i40e_txrx.h  |  21 +-
 4 files changed, 307 insertions(+), 232 deletions(-)

-- 
2.38.1

