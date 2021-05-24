Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1F938EB83
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 17:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbhEXPDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 11:03:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233822AbhEXPBi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 11:01:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C87561483;
        Mon, 24 May 2021 14:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867814;
        bh=tQZdtYbWLdg5SswCUN0BLKrwEcQO7/7BTQOA25kVGX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6jS3C7Tj0+PJmxzZCXG10+/VAcyDJA0WorhLK+muCToQ/qvum+B6kOfK5Qzsjnt1
         q+Eq0mBmIF+7MnTrYmtYRQ61cCj0WpOf/E0YR+5ib0+Ynm+ACVw8dpIwml6mVo9hJl
         e59KSI8D7b0wOZJ2anrB7FydNUPUUH/a46gojxXwYXvM5Co/Q+D2XvurVkw4wJCUCZ
         VUIfBs19TRcamjV7m9W4wjTupysfw42X53EqnviIl0nofAm74vJ8UBJqVq/BKaBuQ0
         dZxeXLMATPNGCAAF3LEpx0Ur3xOMhRcwkM7GHiAsloItpcw3dNVRZ73sp6u9RvAksf
         amjo+yAUDXuCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Du Cheng <ducheng2@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/25] net: caif: remove BUG_ON(dev == NULL) in caif_xmit
Date:   Mon, 24 May 2021 10:49:47 -0400
Message-Id: <20210524145008.2499049-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524145008.2499049-1-sashal@kernel.org>
References: <20210524145008.2499049-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Du Cheng <ducheng2@gmail.com>

[ Upstream commit 65a67792e3416f7c5d7daa47d99334cbb19a7449 ]

The condition of dev == NULL is impossible in caif_xmit(), hence it is
for the removal.

Explanation:
The static caif_xmit() is only called upon via a function pointer
`ndo_start_xmit` defined in include/linux/netdevice.h:
```
struct net_device_ops {
    ...
    netdev_tx_t     (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev);
    ...
}
```

The exhausive list of call points are:
```
drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c
    dev->netdev_ops->ndo_start_xmit(skb, dev);
    ^                                    ^

drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
    struct opa_vnic_adapter *adapter = opa_vnic_priv(netdev);
			     ^                       ^
    return adapter->rn_ops->ndo_start_xmit(skb, netdev); // adapter would crash first
	   ^                                    ^

drivers/usb/gadget/function/f_ncm.c
    ncm->netdev->netdev_ops->ndo_start_xmit(NULL, ncm->netdev);
	      ^                                   ^

include/linux/netdevice.h
static inline netdev_tx_t __netdev_start_xmit(...
{
    return ops->ndo_start_xmit(skb, dev);
				    ^
}

    const struct net_device_ops *ops = dev->netdev_ops;
				       ^
    rc = __netdev_start_xmit(ops, skb, dev, more);
				       ^
```

In each of the enumerated scenarios, it is impossible for the NULL-valued dev to
reach the caif_xmit() without crashing the kernel earlier, therefore `BUG_ON(dev ==
NULL)` is rather useless, hence the removal.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Du Cheng <ducheng2@gmail.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-20-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/caif/caif_serial.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index a0f954f36c09..94d5ce9419ca 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -279,7 +279,6 @@ static int caif_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ser_device *ser;
 
-	BUG_ON(dev == NULL);
 	ser = netdev_priv(dev);
 
 	/* Send flow off once, on high water mark */
-- 
2.30.2

