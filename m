Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D0264C3BE
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 07:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbiLNGVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 01:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiLNGVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 01:21:42 -0500
X-Greylist: delayed 564 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 13 Dec 2022 22:21:40 PST
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2748167ED
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 22:21:39 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 1FA3020240; Wed, 14 Dec 2022 14:12:08 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1670998328;
        bh=+TEjgi0me9dM60cYfw7PyFVyMjDiBivPXVhdaqEYR8g=;
        h=From:To:Cc:Subject:Date;
        b=YF32NegX/YMWozIIF64TVJBua8Yp6g9ij3ftw89bByanh0M4rMG4rzbj3viPiOA/K
         SiOx5U8xRTuWXzi+K+z2jmjtchRatleafc4G24LwluHLaqXM1mI++1wgQDPcOz5Sd6
         u8zId78jpxUESbuqDqsLzer0u2lQiXTONYR8cn3WMkXO0zMbdGEv0NekBHXYzwUdcx
         XAohwtjhwAa62i8lX37M+UjVbwANBibHhG0DxVdtdgPS8tj7DGcDwmeDzVSmeNcAUC
         z3KIZiHcyvHu54daeHa3s9rQs+WhBCoI8gXxqXVOWoFZy9xvr3Wu6AW9+uS3ibDNqh
         VRPZ65En7efVQ==
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, jk@codeconstruct.com.au
Subject: [PATCH net] mctp: Remove device type check at unregister
Date:   Wed, 14 Dec 2022 14:10:44 +0800
Message-Id: <20221214061044.892446-1-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The check could be incorrectly triggered if a netdev
changes its type after register. That is possible for a tun device
using TUNSETLINK ioctl, resulting in mctp unregister failing
and the netdev unregister waiting forever.

This was encountered by https://github.com/openthread/openthread/issues/8523

The check is not required, it was added in an attempt to track down mctp_ptr
being set unexpectedly, which should not happen in normal operation.

Fixes: 7b1871af75f3 ("mctp: Warn if pointer is set for a wrong dev type")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 net/mctp/device.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index 99a3bda8852f..dec730b5fe7e 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -429,12 +429,6 @@ static void mctp_unregister(struct net_device *dev)
 	struct mctp_dev *mdev;
 
 	mdev = mctp_dev_get_rtnl(dev);
-	if (mdev && !mctp_known(dev)) {
-		// Sanity check, should match what was set in mctp_register
-		netdev_warn(dev, "%s: BUG mctp_ptr set for unknown type %d",
-			    __func__, dev->type);
-		return;
-	}
 	if (!mdev)
 		return;
 
-- 
2.37.2

