Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA0CB0D73
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 13:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731265AbfILLBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 07:01:48 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48544 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730680AbfILLBr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 07:01:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 97E8420547;
        Thu, 12 Sep 2019 13:01:45 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7v5Q3AiaYgAd; Thu, 12 Sep 2019 13:01:45 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1698220422;
        Thu, 12 Sep 2019 13:01:45 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 12 Sep 2019
 13:01:45 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id AD5863180394;
 Thu, 12 Sep 2019 13:01:44 +0200 (CEST)
Date:   Thu, 12 Sep 2019 13:01:44 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        <intel-wired-lan@lists.osuosl.org>
CC:     Michael Marley <michael@michaelmarley.com>,
        Shannon Nelson <snelson@pensando.io>, <netdev@vger.kernel.org>
Subject: [PATCH] ixgbe: Fix secpath usage for IPsec TX offload.
Message-ID: <20190912110144.GS2879@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ixgbe driver currently does IPsec TX offloading
based on an existing secpath. However, the secpath
can also come from the RX side, in this case it is
misinterpreted for TX offload and the packets are
dropped with a "bad sa_idx" error. Fix this by using
the xfrm_offload() function to test for TX offload.

Fixes: 592594704761 ("ixgbe: process the Tx ipsec offload")
Reported-by: Michael Marley <michael@michaelmarley.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 9bcae44e9883..ae31bd57127c 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -36,6 +36,7 @@
 #include <net/vxlan.h>
 #include <net/mpls.h>
 #include <net/xdp_sock.h>
+#include <net/xfrm.h>
 
 #include "ixgbe.h"
 #include "ixgbe_common.h"
@@ -8696,7 +8697,7 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 #endif /* IXGBE_FCOE */
 
 #ifdef CONFIG_IXGBE_IPSEC
-	if (secpath_exists(skb) &&
+	if (xfrm_offload(skb) &&
 	    !ixgbe_ipsec_tx(tx_ring, first, &ipsec_tx))
 		goto out_drop;
 #endif
-- 
2.17.1

