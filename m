Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376B2307892
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhA1Osx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:48:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232265AbhA1OqI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 09:46:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C67864DED;
        Thu, 28 Jan 2021 14:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611845077;
        bh=a8WqvuXs37iaOzjpCKR/WWfzIPAFUVRSP/CDa4D6agA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U9+zNP+ChywRUuOUreyITvwVN7fllHG35Q+NmsBjVqmYBZifrpoCk310ro2NK3XFx
         p48qpY7b1yiu2hzAjkddD40RM19ey1k2Wjkx/dwY6b5AUcHABHBgHci3jlC1M1DlYK
         2MtzrEbRK/1DUe6zduoOhiOfrYyoO9Thrp8ulPrgjCROCTR131hFij8BPazNluVNoB
         3MFdnGRffFY8veNQpblaSXd2ZBfhW0atXNdRnT1IeX7aqfpYsBCYHSaaUn9yqEESLU
         m24NOGu8EQVwaYgTLDBCsSqOMZj5kXAE3dqzo1NJERkFa2NkNcQh0V4SnKj7y+1lDz
         UEKwR9pkYhYuA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 10/11] net-sysfs: remove the rtnl lock when accessing the xps maps
Date:   Thu, 28 Jan 2021 15:44:04 +0100
Message-Id: <20210128144405.4157244-11-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128144405.4157244-1-atenart@kernel.org>
References: <20210128144405.4157244-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that nr_ids and num_tc are stored in the xps dev_maps, which are RCU
protected, we do not have the need to protect the xps_queue_show
function with the rtnl lock.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/net-sysfs.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 0c564f288460..08c7a494d0e1 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1314,7 +1314,6 @@ static const struct attribute_group dql_group = {
 #endif /* CONFIG_BQL */
 
 #ifdef CONFIG_XPS
-/* Should be called with the rtnl lock held. */
 static int xps_queue_show(struct net_device *dev, unsigned long **mask,
 			  unsigned int index, bool is_rxqs_map)
 {
@@ -1375,14 +1374,7 @@ static ssize_t xps_cpus_show(struct netdev_queue *queue, char *buf)
 	if (!mask)
 		return -ENOMEM;
 
-	if (!rtnl_trylock()) {
-		bitmap_free(mask);
-		return restart_syscall();
-	}
-
 	ret = xps_queue_show(dev, &mask, index, false);
-	rtnl_unlock();
-
 	if (ret) {
 		bitmap_free(mask);
 		return ret;
@@ -1447,14 +1439,7 @@ static ssize_t xps_rxqs_show(struct netdev_queue *queue, char *buf)
 	if (!mask)
 		return -ENOMEM;
 
-	if (!rtnl_trylock()) {
-		bitmap_free(mask);
-		return restart_syscall();
-	}
-
 	ret = xps_queue_show(dev, &mask, index, true);
-	rtnl_unlock();
-
 	if (ret) {
 		bitmap_free(mask);
 		return ret;
-- 
2.29.2

