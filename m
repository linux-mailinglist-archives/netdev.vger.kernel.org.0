Return-Path: <netdev+bounces-7076-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59786719AF9
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 13:29:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EEB0281790
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 11:29:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BC4523426;
	Thu,  1 Jun 2023 11:29:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD0B2341B
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 11:28:59 +0000 (UTC)
Received: from mail-m12745.qiye.163.com (mail-m12745.qiye.163.com [115.236.127.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AC818F;
	Thu,  1 Jun 2023 04:28:47 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPV6:240e:3b7:327f:140:e827:966c:49bc:3060])
	by mail-m12745.qiye.163.com (Hmail) with ESMTPA id 94D9E9A0A0F;
	Thu,  1 Jun 2023 19:28:42 +0800 (CST)
From: Ding Hui <dinghui@sangfor.com.cn>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pengdonglin@sangfor.com.cn,
	huangcun@sangfor.com.cn,
	Ding Hui <dinghui@sangfor.com.cn>
Subject: [PATCH net-next] net: ethtool: Fix out-of-bounds copy to user
Date: Thu,  1 Jun 2023 19:28:39 +0800
Message-Id: <20230601112839.13799-1-dinghui@sangfor.com.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDQkxOVkxJGkpOHUxKHUlKT1UTARMWGhIXJBQOD1
	lXWRgSC1lBWUlPSx5BSBlMQUhJTB1BSk9LQR5DSUxBQk1NGEFPQhkYQUhLTUtZV1kWGg8SFR0UWU
	FZT0tIVUpKS0hKTFVKS0tVS1kG
X-HM-Tid: 0a8876b79570b218kuuu94d9e9a0a0f
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OFE6Tgw5FD1CDD4qKhNCKx8Z
	Iw5PCjpVSlVKTUNOTUpDQklISEtNVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
	QVlJT0seQUgZTEFISUwdQUpPS0EeQ0lMQUJNTRhBT0IZGEFIS01LWVdZCAFZQUhDTks3Bg++
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

When we get statistics by ethtool during changing the number of NIC
channels greater, the utility may crash due to memory corruption.

The NIC drivers callback get_sset_count() could return a calculated
length depends on current number of channels (e.g. i40e, igb).

The ethtool allocates a user buffer with the first ioctl returned
length and invokes the second ioctl to get data. The kernel copies
data to the user buffer but without checking its length. If the length
returned by the second get_sset_count() is greater than the length
allocated by the user, it will lead to an out-of-bounds copy.

Fix it by restricting the copy length not exceed the buffer length
specified by userspace.

Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
---
 net/ethtool/ioctl.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 6bb778e10461..82a975a9c895 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1902,7 +1902,7 @@ static int ethtool_self_test(struct net_device *dev, char __user *useraddr)
 	if (copy_from_user(&test, useraddr, sizeof(test)))
 		return -EFAULT;
 
-	test.len = test_len;
+	test.len = min_t(u32, test.len, test_len);
 	data = kcalloc(test_len, sizeof(u64), GFP_USER);
 	if (!data)
 		return -ENOMEM;
@@ -1915,7 +1915,8 @@ static int ethtool_self_test(struct net_device *dev, char __user *useraddr)
 	if (copy_to_user(useraddr, &test, sizeof(test)))
 		goto out;
 	useraddr += sizeof(test);
-	if (copy_to_user(useraddr, data, array_size(test.len, sizeof(u64))))
+	if (test.len &&
+	    copy_to_user(useraddr, data, array_size(test.len, sizeof(u64))))
 		goto out;
 	ret = 0;
 
@@ -1940,10 +1941,10 @@ static int ethtool_get_strings(struct net_device *dev, void __user *useraddr)
 		return -ENOMEM;
 	WARN_ON_ONCE(!ret);
 
-	gstrings.len = ret;
+	gstrings.len = min_t(u32, gstrings.len, ret);
 
 	if (gstrings.len) {
-		data = vzalloc(array_size(gstrings.len, ETH_GSTRING_LEN));
+		data = vzalloc(array_size(ret, ETH_GSTRING_LEN));
 		if (!data)
 			return -ENOMEM;
 
@@ -2055,9 +2056,9 @@ static int ethtool_get_stats(struct net_device *dev, void __user *useraddr)
 	if (copy_from_user(&stats, useraddr, sizeof(stats)))
 		return -EFAULT;
 
-	stats.n_stats = n_stats;
+	stats.n_stats = min_t(u32, stats.n_stats, n_stats);
 
-	if (n_stats) {
+	if (stats.n_stats) {
 		data = vzalloc(array_size(n_stats, sizeof(u64)));
 		if (!data)
 			return -ENOMEM;
@@ -2070,7 +2071,8 @@ static int ethtool_get_stats(struct net_device *dev, void __user *useraddr)
 	if (copy_to_user(useraddr, &stats, sizeof(stats)))
 		goto out;
 	useraddr += sizeof(stats);
-	if (n_stats && copy_to_user(useraddr, data, array_size(n_stats, sizeof(u64))))
+	if (stats.n_stats &&
+	    copy_to_user(useraddr, data, array_size(stats.n_stats, sizeof(u64))))
 		goto out;
 	ret = 0;
 
-- 
2.17.1


