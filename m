Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B1F63E0E2
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiK3Tmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiK3Tmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:42:38 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBCB5F7E
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669837357; x=1701373357;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kexg/Tkz2qRdOZ+4lyJw8aFO+BPj2JxRaKinLBsShFk=;
  b=gmVP29JZGsTeFuqndxLTo6a6Btk9y/cVWL5NLRqrypUTQ14LZZtEzVUX
   MFX3wXdLBRc0R6WgMxX2n+NkbE0lPZY/UdVu24rnUiGtBqBAXYTEoAcwe
   rAH4SwSY+1M0JU7EnqwUJkrUa6V78gTd7c70gGitVm2eXALKqWhsjbE20
   Wwol9FNqyTULDAwptw12cFvLSxCoLBp1LWYVh0pTdDxmG3ChZq0eA3/Yt
   TUaVpdaPkpPOX5fHzj37U7jUq2B4eGXYeQOS7VIYHBPIHgYbzLi/emhWA
   5wQ/LSW3aMxlW6KqAY2lJekvPZ2VyeV5v/rR7Vf9jqAjlCn94zzkkm3uc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="315520740"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="315520740"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:42:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="646455613"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="646455613"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 30 Nov 2022 11:42:34 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Akihiko Odaki <akihiko.odaki@daynix.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net 1/2] e1000e: Fix TX dispatch condition
Date:   Wed, 30 Nov 2022 11:42:27 -0800
Message-Id: <20221130194228.3257787-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221130194228.3257787-1-anthony.l.nguyen@intel.com>
References: <20221130194228.3257787-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akihiko Odaki <akihiko.odaki@daynix.com>

e1000_xmit_frame is expected to stop the queue and dispatch frames to
hardware if there is not sufficient space for the next frame in the
buffer, but sometimes it failed to do so because the estimated maximum
size of frame was wrong. As the consequence, the later invocation of
e1000_xmit_frame failed with NETDEV_TX_BUSY, and the frame in the buffer
remained forever, resulting in a watchdog failure.

This change fixes the estimated size by making it match with the
condition for NETDEV_TX_BUSY. Apparently, the old estimation failed to
account for the following lines which determines the space requirement
for not causing NETDEV_TX_BUSY:
    ```
    	/* reserve a descriptor for the offload context */
    	if ((mss) || (skb->ip_summed == CHECKSUM_PARTIAL))
    		count++;
    	count++;

    	count += DIV_ROUND_UP(len, adapter->tx_fifo_limit);
    ```

This issue was found when running http-stress02 test included in Linux
Test Project 20220930 on QEMU with the following commandline:
```
qemu-system-x86_64 -M q35,accel=kvm -m 8G -smp 8
	-drive if=virtio,format=raw,file=root.img,file.locking=on
	-device e1000e,netdev=netdev
	-netdev tap,script=ifup,downscript=no,id=netdev
```

Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver (currently for ICH9 devices only)")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 49e926959ad3..55cf2f62bb30 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5936,9 +5936,9 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 		e1000_tx_queue(tx_ring, tx_flags, count);
 		/* Make sure there is space in the ring for the next send. */
 		e1000_maybe_stop_tx(tx_ring,
-				    (MAX_SKB_FRAGS *
+				    ((MAX_SKB_FRAGS + 1) *
 				     DIV_ROUND_UP(PAGE_SIZE,
-						  adapter->tx_fifo_limit) + 2));
+						  adapter->tx_fifo_limit) + 4));
 
 		if (!netdev_xmit_more() ||
 		    netif_xmit_stopped(netdev_get_tx_queue(netdev, 0))) {
-- 
2.35.1

