Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0816CD507
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 10:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjC2Ipk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 04:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjC2Ipj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 04:45:39 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658201716
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 01:45:38 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1phRQz-009sQx-Bl; Wed, 29 Mar 2023 16:45:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 29 Mar 2023 16:45:33 +0800
Date:   Wed, 29 Mar 2023 16:45:33 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH] macvlan: Fix mc_filter calculation
Message-ID: <ZCP6rRY+gargYJit@gondor.apana.org.au>
References: <ZCJXefIhSrd7Hm2Z@gondor.apana.org.au>
 <168007742658.16006.9794796649627218191.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168007742658.16006.9794796649627218191.git-patchwork-notify@kernel.org>
X-Spam-Status: No, score=4.3 required=5.0 tests=HELO_DYNAMIC_IPADDR2,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 08:10:26AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> 
> Here is the summary with links:
>   - [1/2] macvlan: Skip broadcast queue if multicast with single receiver
>     https://git.kernel.org/netdev/net-next/c/d45276e75e90
>   - [2/2] macvlan: Add netlink attribute for broadcast cutoff
>     https://git.kernel.org/netdev/net-next/c/954d1fa1ac93

Sorry, I made an error and posted my patches from an earlier
revision so a follow-up fix was missing:

---8<---
The bc_cutoff patch broke the calculation of mc_filter causing
some multicast packets to not make it through to the targeted
device.

Fix this by checking whether vlan is set instead of cutoff >= 0.

Also move the cutoff < 0 logic into macvlan_recompute_bc_filter
so that it doesn't change the mc_filter at all.

Fixes: d45276e75e90 ("macvlan: Skip broadcast queue if multicast with single receiver")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/net/macvlan.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 4215106adc40..4a53debf9d7c 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -792,24 +792,20 @@ static void macvlan_compute_filter(unsigned long *mc_filter,
 				   struct macvlan_dev *vlan, int cutoff)
 {
 	if (dev->flags & (IFF_PROMISC | IFF_ALLMULTI)) {
-		if (cutoff >= 0)
-			bitmap_fill(mc_filter, MACVLAN_MC_FILTER_SZ);
-		else
-			bitmap_zero(mc_filter, MACVLAN_MC_FILTER_SZ);
+		bitmap_fill(mc_filter, MACVLAN_MC_FILTER_SZ);
 	} else {
 		DECLARE_BITMAP(filter, MACVLAN_MC_FILTER_SZ);
 		struct netdev_hw_addr *ha;
 
 		bitmap_zero(filter, MACVLAN_MC_FILTER_SZ);
 		netdev_for_each_mc_addr(ha, dev) {
-			if (cutoff >= 0 && ha->synced <= cutoff)
+			if (!vlan && ha->synced <= cutoff)
 				continue;
 
 			__set_bit(mc_hash(vlan, ha->addr), filter);
 		}
 
-		if (cutoff >= 0)
-			__set_bit(mc_hash(vlan, dev->broadcast), filter);
+		__set_bit(mc_hash(vlan, dev->broadcast), filter);
 
 		bitmap_copy(mc_filter, filter, MACVLAN_MC_FILTER_SZ);
 	}
@@ -817,6 +813,11 @@ static void macvlan_compute_filter(unsigned long *mc_filter,
 
 static void macvlan_recompute_bc_filter(struct macvlan_dev *vlan)
 {
+	if (vlan->port->bc_cutoff < 0) {
+		bitmap_zero(vlan->port->bc_filter, MACVLAN_MC_FILTER_SZ);
+		return;
+	}
+
 	macvlan_compute_filter(vlan->port->bc_filter, vlan->lowerdev, NULL,
 			       vlan->port->bc_cutoff);
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
