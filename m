Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8558E248B40
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 18:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgHRQOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 12:14:47 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60190 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbgHRQOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 12:14:43 -0400
Date:   Tue, 18 Aug 2020 18:14:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597767280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=2EJhoSAvrqLLzrWAoDWlLS3RTlTnaiM88eJOyWE45Uo=;
        b=kTsdcYKWPtMAz96T1w5plwRfulJkYc0BIQ69O7aE53bv9sN9tyAMKapAmjCewyYcXf6Dcc
        zn1ejL+sKYZg49vcxltDnCTR9Ea+JF3+tNUAYNt2YlFI6zXwiS7HCfHCTUU9J1As21aOmw
        KqEk/UXpGVD1HvOLPIH4P8kRbHKGpizg4/0gixEIP8TFI4hlppSwTwI/3CE7snShUFnUaC
        hoUpWuhDPF59CJz9q8PA3tBc4YqAjjYJDEggfBAGY01fmUFM2aQPkPkZhJafan2vCLdDtX
        t7m/1TUqlykNT3qrKOB9vp/Rzg5twCjHVeooksOlfU1eQctGIAGrjUQgg0z/5w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597767280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=2EJhoSAvrqLLzrWAoDWlLS3RTlTnaiM88eJOyWE45Uo=;
        b=qxKK9yWy8cwdoHWmRYiwc3npz77LgOo+9hCpwSR3EuTRIPDAJd0kHrILEmmfgO/4K6+Wke
        iV4mbsPtopE2sLCQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Igor Russkikh <irusskikh@marvell.com>, netdev@vger.kernel.org,
        Mark Starovoytov <mstarovoitov@marvell.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH NET] net: atlantic: Use readx_poll_timeout() for large timeout
Message-ID: <20200818161439.3dkf6jzp3vuwmvvh@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit
   8dcf2ad39fdb2 ("net: atlantic: add hwmon getter for MAC temperature")

implemented a read callback with an udelay(10000U). This fails to
compile on ARM because the delay is >1ms. I doubt that it is needed to
spin for 10ms even if possible on x86.

From looking at the code, the context appears to be preemptible so using
usleep() should work and avoid busy spinning.

Use readx_poll_timeout() in the poll loop.

Cc: Mark Starovoytov <mstarovoitov@marvell.com>
Cc: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---

Could someone with hardware please verify it? It compiles, yes.

 drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 16a944707ba90..8941ac4df9e37 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -1631,8 +1631,8 @@ static int hw_atl_b0_get_mac_temp(struct aq_hw_s *self, u32 *temp)
 		hw_atl_ts_reset_set(self, 0);
 	}
 
-	err = readx_poll_timeout_atomic(hw_atl_b0_ts_ready_and_latch_high_get,
-					self, val, val == 1, 10000U, 500000U);
+	err = readx_poll_timeout(hw_atl_b0_ts_ready_and_latch_high_get, self,
+				 val, val == 1, 10000U, 500000U);
 	if (err)
 		return err;
 
-- 
2.28.0

