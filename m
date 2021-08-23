Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408023F5006
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 20:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhHWSCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 14:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230154AbhHWSCX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 14:02:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76BA66136F;
        Mon, 23 Aug 2021 18:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629741698;
        bh=0B2qdTv92rKWMA+k7yziz/ZczrgVn5a9+8KKRcnKE9E=;
        h=From:To:Cc:Subject:Date:From;
        b=NGi0qWGXU98d7QAHSwDAboTvWyalK++pAo5IA4t0llHkFTeckfJD5PcxpWEvgXrod
         0/5o6dqB/opzm/IC8OxzE5nYA5sn28enA8opq5mPKXvzvBfOvp3h7/P3x39oAjThKi
         XYZM1gKebSK//eYGY0oqztCNRFTI6tds8ccIl+ltiohwc99w4x9eiqJBoD+z/PKYCE
         pRh4FAUss09GNPngAd9sgpflCnOXEEUI/1r+o/7hzv8WHbFoEvD1fTaXpBcmaSa98Y
         6FK67w9uL/CnV3lQI/ddBtw3uW843HIxdgOun5LcXeTRCotGOavty3Yfvy8A6hrwuD
         eqhcXELVwwUdQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, hawk@kernel.org,
        magnus.karlsson@intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] netdevice: move xdp_rxq within netdev_rx_queue
Date:   Mon, 23 Aug 2021 11:01:35 -0700
Message-Id: <20210823180135.1153608-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both struct netdev_rx_queue and struct xdp_rxq_info are cacheline
aligned. This causes extra padding before and after the xdp_rxq
member. Move the member upfront, so that it's naturally aligned.

Before:
	/* size: 256, cachelines: 4, members: 6 */
	/* sum members: 160, holes: 1, sum holes: 40 */
	/* padding: 56 */
	/* paddings: 1, sum paddings: 36 */
	/* forced alignments: 1, forced holes: 1, sum forced holes: 40 */

After:
	/* size: 192, cachelines: 3, members: 6 */
	/* padding: 32 */
	/* paddings: 1, sum paddings: 36 */
	/* forced alignments: 1 */

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/netdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9579942ac2fd..514ec3a0507c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -722,13 +722,13 @@ bool rps_may_expire_flow(struct net_device *dev, u16 rxq_index, u32 flow_id,
 
 /* This structure contains an instance of an RX queue. */
 struct netdev_rx_queue {
+	struct xdp_rxq_info		xdp_rxq;
 #ifdef CONFIG_RPS
 	struct rps_map __rcu		*rps_map;
 	struct rps_dev_flow_table __rcu	*rps_flow_table;
 #endif
 	struct kobject			kobj;
 	struct net_device		*dev;
-	struct xdp_rxq_info		xdp_rxq;
 #ifdef CONFIG_XDP_SOCKETS
 	struct xsk_buff_pool            *pool;
 #endif
-- 
2.31.1

