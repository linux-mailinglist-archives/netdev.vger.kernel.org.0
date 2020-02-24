Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9381D16AFC3
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 19:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgBXS43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 13:56:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:44821 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbgBXS42 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 13:56:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 10:56:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,481,1574150400"; 
   d="scan'208";a="437802141"
Received: from anambiarhost.jf.intel.com ([10.166.224.88])
  by fmsmga006.fm.intel.com with ESMTP; 24 Feb 2020 10:56:27 -0800
Subject: [net PATCH v2] net: Fix Tx hash bound checking
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     alexander.h.duyck@intel.com, amritha.nambiar@intel.com,
        sridhar.samudrala@intel.com, sergei.shtylyov@cogentembedded.com
Date:   Mon, 24 Feb 2020 10:56:00 -0800
Message-ID: <158257056094.10327.890174763453610916.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the lower and upper bounds when there are multiple TCs and
traffic is on the the same TC on the same device.

The lower bound is represented by 'qoffset' and the upper limit for
hash value is 'qcount + qoffset'. This gives a clean Rx to Tx queue
mapping when there are multiple TCs, as the queue indices for upper TCs
will be offset by 'qoffset'.

v2: Fixed commit description based on comments.

Fixes: 1b837d489e06 ("net: Revoke export for __skb_tx_hash, update it to just be static skb_tx_hash")
Fixes: eadec877ce9c ("net: Add support for subordinate traffic classes to netdev_pick_tx")
Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
---
 net/core/dev.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index e10bd680dc03..c6c985fe7b1b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3076,6 +3076,8 @@ static u16 skb_tx_hash(const struct net_device *dev,
 
 	if (skb_rx_queue_recorded(skb)) {
 		hash = skb_get_rx_queue(skb);
+		if (hash >= qoffset)
+			hash -= qoffset;
 		while (unlikely(hash >= qcount))
 			hash -= qcount;
 		return hash + qoffset;

