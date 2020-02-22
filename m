Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E77CF168BFA
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 03:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgBVCJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 21:09:43 -0500
Received: from mga12.intel.com ([192.55.52.136]:31833 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727614AbgBVCJn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 21:09:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2020 18:09:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,470,1574150400"; 
   d="scan'208";a="437140762"
Received: from anambiarhost.jf.intel.com ([10.166.224.88])
  by fmsmga006.fm.intel.com with ESMTP; 21 Feb 2020 18:09:42 -0800
Subject: [net PATCH] net: Fix Tx hash bound checking
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     alexander.h.duyck@intel.com, amritha.nambiar@intel.com,
        sridhar.samudrala@intel.com
Date:   Fri, 21 Feb 2020 18:09:22 -0800
Message-ID: <158233736265.6609.6785259084260258418.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: commit 1b837d489e06 ("net: Revoke export for __skb_tx_hash, update it to just be static skb_tx_hash")
Fixes: commit eadec877ce9c ("net: Add support for subordinate traffic classes to netdev_pick_tx")

Fixes the lower and upper bounds when there are multiple TCs and
traffic is on the the same TC on the same device.

The lower bound is represented by 'qoffset' and the upper limit for
hash value is 'qcount + qoffset'. This gives a clean Rx to Tx queue
mapping when there are multiple TCs, as the queue indices for upper TCs
will be offset by 'qoffset'.

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

