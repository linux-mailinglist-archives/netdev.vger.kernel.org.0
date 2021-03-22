Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011F7344985
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 16:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhCVPnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 11:43:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230507AbhCVPnc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 11:43:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BA6E61984;
        Mon, 22 Mar 2021 15:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616427812;
        bh=HCaMd0v4oO3cu7PvylWU91LCRrFV4pLAwmS2MBDeTKQ=;
        h=From:To:Cc:Subject:Date:From;
        b=omLld9SIR2Ijes0DjFYW55aqfA6+Lc8WKdJiY9uxfz73BZKy7KDNlneTGXc6LmIcw
         7zDbDIqq9POdKYUExUX2cYJ6JPGmXPV3JlzunwM6BrrL+PqGVjQIXgPxdELJ0LplR6
         U7Dgpw7B74wEvfZ+kgE1Uv1GGtaFgyFxy213J6QAVUgW1KURb4KG85/bB+cMj4Homk
         +d73Bktyfjdbn4vm3qvdDmPUInw20BJ8N0kw3pb/tYjne7kTQGj3KosOH8tB70VKiF
         I3PtETR2VvNgPdT3LuE5N4cbgv2oyHVttJmwRInsTI22S6Bt6C27OJuAEKmgDh3UlM
         A+VFhoCiPIpDA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        kernel test robot <oliver.sang@intel.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: [PATCH net-next] net-sysfs: remove possible sleep from an RCU read-side critical section
Date:   Mon, 22 Mar 2021 16:43:29 +0100
Message-Id: <20210322154329.340048-1-atenart@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xps_queue_show is mostly made of an RCU read-side critical section and
calls bitmap_zalloc with GFP_KERNEL in the middle of it. That is not
allowed as this call may sleep and such behaviours aren't allowed in RCU
read-side critical sections. Fix this by using GFP_NOWAIT instead.

Fixes: 5478fcd0f483 ("net: embed nr_ids in the xps maps")
Reported-by: kernel test robot <oliver.sang@intel.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---

Fix sent to net-next as it fixes an issue only in net-next.

 net/core/net-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 562a42fcd437..f6197774048b 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1378,7 +1378,7 @@ static ssize_t xps_queue_show(struct net_device *dev, unsigned int index,
 	nr_ids = dev_maps ? dev_maps->nr_ids :
 		 (type == XPS_CPUS ? nr_cpu_ids : dev->num_rx_queues);
 
-	mask = bitmap_zalloc(nr_ids, GFP_KERNEL);
+	mask = bitmap_zalloc(nr_ids, GFP_NOWAIT);
 	if (!mask) {
 		rcu_read_unlock();
 		return -ENOMEM;
-- 
2.30.2

