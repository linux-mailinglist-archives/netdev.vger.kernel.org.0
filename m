Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243662F9292
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 14:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbhAQNho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 08:37:44 -0500
Received: from m15111.mail.126.com ([220.181.15.111]:37183 "EHLO
        m15111.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbhAQNhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 08:37:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=eWwIs7/QmCK2QierLP
        nFAEWKUmsS+o3HHAvwtkjkxe0=; b=b2IA/FtKcOsXnrjQJh9XlHxmIvhTRq36bG
        VktxpjPjhOI2EFj0unj59EKCy2yByV8jNA6bqvzGBmaSQRW5jjVQPr1tT7Bmw3wh
        jiN7n7BIgjvkN2hI1Tmcoy8m3VNH+Vkkn7lxMC6JOUwIQVARClnJlfb3NgdQg7kz
        aokqUx6xU=
Received: from localhost.localdomain (unknown [106.18.67.121])
        by smtp1 (Coremail) with SMTP id C8mowAB3fVHiPARgP38_Nw--.64554S2;
        Sun, 17 Jan 2021 21:34:29 +0800 (CST)
From:   wangyingjie55@126.com
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangyingjie55@126.com
Subject: [PATCH v1] ipv4: add iPv4_is_multicast() check in ip_mc_leave_group().
Date:   Sun, 17 Jan 2021 05:34:16 -0800
Message-Id: <1610890456-42846-1-git-send-email-wangyingjie55@126.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: C8mowAB3fVHiPARgP38_Nw--.64554S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZr1rtr43AF1rJF4xJw4ruFg_yoWDurg_t3
        WkAr18JrWfAr1Ikw47Z3Z3Ja98X398Crn3WrsF9Fy3Ja40ywnruas7XrySvr1xGa9rGFWU
        Zasrtry5Ga10yjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnaNt3UUUUU==
X-Originating-IP: [106.18.67.121]
X-CM-SenderInfo: 5zdqw5xlqjyxrhvvqiyswou0bp/1tbi7gUdp1tC5n0SnQAAsc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yingjie Wang <wangyingjie55@126.com>

There is no iPv4_is_multicast() check added to ip_mc_leave_group()
to check if imr->imr_multiaddr.s_addr is a multicast address.
If not a multicast address, it may result in an error.
In some cases, the callers of ip_mc_leave_group() don't check
whether it is multicast address or not before calling
such as do_ip_setsockopt(). So I suggest adding the ipv4_is_multicast()
check to the ip_mc_leave_group() to prevent this from happening.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yingjie Wang <wangyingjie55@126.com>
---
 net/ipv4/igmp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 7b272bbed2b4..1b6f91271cfd 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2248,6 +2248,9 @@ int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
 	u32 ifindex;
 	int ret = -EADDRNOTAVAIL;
 
+	if (!ipv4_is_multicast(group))
+		return -EINVAL;
+
 	ASSERT_RTNL();
 
 	in_dev = ip_mc_find_dev(net, imr);
-- 
2.7.4

