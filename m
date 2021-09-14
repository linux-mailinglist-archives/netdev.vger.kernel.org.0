Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF1D40A417
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 05:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238466AbhINDDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 23:03:25 -0400
Received: from out0.migadu.com ([94.23.1.103]:47472 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238376AbhINDDX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 23:03:23 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1631588525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ThIcA5wwm4yaIeNqvqt2RNEZEBRWU70DJZiCB1PQQXw=;
        b=jyOVao0kkFHTGPLWRkUO2MvYlE74kfVgRMf8n3rBv2ZuchWvHBzblw4f55KbvURfzHU8oH
        QbES5oDJ/ZabGkFdBgzgpM5KEc3EWIrcmMbicVnRsdwZWfBRA33uRbYAkOW99E8eQZmN7w
        9vuCNhPCg0CDMJtAP4qZCdUSSNs0w/Q=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     nikolay@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] net: core: fix the order in dev_put() and rtnl_lock()
Date:   Tue, 14 Sep 2021 11:01:50 +0800
Message-Id: <20210914030150.5838-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dev_put() should be after rtnl_lock() in case for race.

Fixes: 893b19587534 ("net: bridge: fix ioctl locking")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/core/dev_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 0e87237fd871..9796fa35fe88 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -384,8 +384,8 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 		dev_hold(dev);
 		rtnl_unlock();
 		err = br_ioctl_call(net, netdev_priv(dev), cmd, ifr, NULL);
-		dev_put(dev);
 		rtnl_lock();
+		dev_put(dev);
 		return err;
 
 	case SIOCSHWTSTAMP:
-- 
2.32.0

