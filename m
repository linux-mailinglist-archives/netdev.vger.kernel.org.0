Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA181FFD51
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 23:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbgFRVVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 17:21:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:40849 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbgFRVVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 17:21:20 -0400
IronPort-SDR: z0ePmumLLYRKhsN0mwGJ3gK/AAAFL4x6u/+b6kg/wbDE1AA3Qx5ltZPpFRunpTZ1hsG4CVBcVG
 QeG0iirBMStQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9656"; a="227435971"
X-IronPort-AV: E=Sophos;i="5.75,253,1589266800"; 
   d="scan'208";a="227435971"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2020 14:21:19 -0700
IronPort-SDR: V72qSZfTE0OfLh2ZHfoHTaBTYgtOKBTX4UGgOCEW+ZiKYnt5L2dZvsummyx9IJLpUOjFezRCtp
 RbSBYPTPh5cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,253,1589266800"; 
   d="scan'208";a="317935839"
Received: from anambiarhost.jf.intel.com ([10.166.224.238])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Jun 2020 14:21:19 -0700
Subject: [net-next PATCH] net: Avoid overwriting valid skb->napi_id
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     edumazet@google.com, alexander.h.duyck@intel.com,
        eliezer.tamir@linux.intel.com, sridhar.samudrala@intel.com,
        amritha.nambiar@intel.com
Date:   Thu, 18 Jun 2020 14:22:15 -0700
Message-ID: <159251533557.7557.5381023439094175695.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be useful to allow busy poll for tunneled traffic. In case of
busy poll for sessions over tunnels, the underlying physical device's
queues need to be polled.

Tunnels schedule NAPI either via netif_rx() for backlog queue or
schedule the gro_cell_poll(). netif_rx() propagates the valid skb->napi_id
to the socket. OTOH, gro_cell_poll() stamps the skb->napi_id again by
calling skb_mark_napi_id() with the tunnel NAPI which is not a busy poll
candidate. This was preventing tunneled traffic to use busy poll. A valid
NAPI ID in the skb indicates it was already marked for busy poll by a
NAPI driver and hence needs to be copied into the socket.

Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
---
 include/net/busy_poll.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 86e028388bad..b001fa91c14e 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -114,7 +114,11 @@ static inline void skb_mark_napi_id(struct sk_buff *skb,
 				    struct napi_struct *napi)
 {
 #ifdef CONFIG_NET_RX_BUSY_POLL
-	skb->napi_id = napi->napi_id;
+	/* If the skb was already marked with a valid NAPI ID, avoid overwriting
+	 * it.
+	 */
+	if (skb->napi_id < MIN_NAPI_ID)
+		skb->napi_id = napi->napi_id;
 #endif
 }
 

