Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D15DCAF5A0
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 08:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfIKGPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 02:15:49 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:52462 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbfIKGPt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 02:15:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 105ED2057E;
        Wed, 11 Sep 2019 08:15:48 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dhHli4JPtoZq; Wed, 11 Sep 2019 08:15:47 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 912F320569;
        Wed, 11 Sep 2019 08:15:47 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 11 Sep 2019
 08:15:47 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 34BF63180AC8;
 Wed, 11 Sep 2019 08:15:47 +0200 (CEST)
Date:   Wed, 11 Sep 2019 08:15:47 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Michael Marley <michael@michaelmarley.com>
CC:     Shannon Nelson <snelson@pensando.io>, <netdev@vger.kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: ixgbe: driver drops packets routed from an IPSec interface with
 a "bad sa_idx" error
Message-ID: <20190911061547.GR2879@gauss3.secunet.de>
References: <10ba81d178d4ade76741c1a6e1672056@michaelmarley.com>
 <4caa4fb7-9963-99ab-318f-d8ada4f19205@pensando.io>
 <fb63dec226170199e9b0fd1b356d2314@michaelmarley.com>
 <90dd9f8c-57fa-14c7-5d09-207b84ec3292@pensando.io>
 <6ab15854-154a-2c7c-b429-7ba6dfe785ae@michaelmarley.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ab15854-154a-2c7c-b429-7ba6dfe785ae@michaelmarley.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 06:53:30PM -0400, Michael Marley wrote:
> 
> StrongSwan has hardware offload disabled by default, and I didn't enable
> it explicitly.  I also already tried turning off all those switches with
> ethtool and it has no effect.  This doesn't surprise me though, because
> as I said, I don't actually have the IPSec connection running over the
> ixgbe device.  The IPSec connection runs over another network adapter
> that doesn't support IPSec offload at all.  The problem comes when
> traffic received over the IPSec interface is then routed back out
> (unencrypted) through the ixgbe device into the local network.


Seems like the ixgbe driver tries to use the sec_path
from RX to setup an offload at the TX side.

Can you please try this (completely untested) patch?

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
