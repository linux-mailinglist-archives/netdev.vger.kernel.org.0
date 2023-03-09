Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDDE06B2F86
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 22:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjCIV3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 16:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjCIV3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 16:29:44 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A76637FB;
        Thu,  9 Mar 2023 13:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678397383; x=1709933383;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=80zyLhOThSYk7O2hMgd2l5n+WSDRyjihPaH07zm+19c=;
  b=M3QXWnMbHCTwd6HJE3WGzJGH7jvu9bw0nUKjenfxPMURzscicIOm3T9l
   Ojlebxgtmn9cmebeP4HcAHCAtqo41PFdK0gQTrvSI5mdthkum1q22uUhy
   vXqfotVJQlBS/PR+3/v6etPJF8y5JkeKnxpy1TGzxnACLYSi0jpXc8r4g
   Gg5o2R995T8t2rS9sqpFEgbZHpprKqCTIn6YeQ5eL+hgHPtH8rZILDVLl
   k4CUnzYDNYhlGogCZ4PdkzXBqQbjnjirT2OxNeSQASjf0LS3BuAQQxhxI
   IA9strKxS+nHL7l4v9ezvD12uRwme/HNcxPx+nQqFiu/IQ2ir2HTQ0Twj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="338126092"
X-IronPort-AV: E=Sophos;i="5.98,247,1673942400"; 
   d="scan'208";a="338126092"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 13:29:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="710011389"
X-IronPort-AV: E=Sophos;i="5.98,247,1673942400"; 
   d="scan'208";a="710011389"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 09 Mar 2023 13:29:41 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        tirthendu.sarkar@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org
Subject: [PATCH net-next v2 0/8][pull request] i40e: support XDP multi-buffer
Date:   Thu,  9 Mar 2023 13:28:11 -0800
Message-Id: <20230309212819.1198218-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
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

Changelog:
	v1 -> v2:
	- Make rx_buffer_len dependent on size of skb_shared_info instead
	  of fixed size for legaxy-rx mode [Jakub Kicinski]
	- Add checks to error out when size of skb_shared_info does not
	  match expected size [Jakub Kicinski]

v1: https://lore.kernel.org/netdev/20230306210822.3381942-1-anthony.l.nguyen@intel.com/

The following are changes since commit db47fa2e4cbf180a39d8e6d6170962bd7d82e52d:
  Merge branch 'sctp-add-another-two-stream-schedulers'
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

 .../net/ethernet/intel/i40e/i40e_ethtool.c    |   7 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  88 ++--
 drivers/net/ethernet/intel/i40e/i40e_trace.h  |  20 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 420 ++++++++++--------
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  20 +-
 5 files changed, 321 insertions(+), 234 deletions(-)

-- 
2.38.1

