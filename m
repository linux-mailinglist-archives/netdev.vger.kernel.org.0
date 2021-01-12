Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD592F2A51
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 09:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405719AbhALIt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 03:49:26 -0500
Received: from mail-m964.mail.126.com ([123.126.96.4]:55452 "EHLO
        mail-m964.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbhALIt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 03:49:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=cqruJVwkrblbTyarRV
        FSbVbRTcJ/ToavTJieQEH/wc4=; b=pat0A4m7wWt3t7i0+CpeTD6g/HD4jNkeQY
        DEEeyUJ+oi1qaTa7zJl4V0AAeS+pvzmtNjiSbgz/QkXBllOOn0HLA1sdvBAozHI6
        V+LqTMtt/J+hCkqOmzK3oaKPR4ghBYIKhL5L0RNvEJZbiL4xXeTL8l+StCgul9l8
        etLqQIBOg=
Received: from localhost.localdomain (unknown [116.162.2.123])
        by smtp9 (Coremail) with SMTP id NeRpCgC3BS4uYv1ftHE7Qw--.4196S2;
        Tue, 12 Jan 2021 16:47:43 +0800 (CST)
From:   wangyingjie55@126.com
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, wangyingjie55@126.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1] net/ipv4: add IPv4_is_multicast() check in ip_mc_leave_group().
Date:   Tue, 12 Jan 2021 00:47:09 -0800
Message-Id: <1610441229-13195-1-git-send-email-wangyingjie55@126.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: NeRpCgC3BS4uYv1ftHE7Qw--.4196S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtF15Zw1xArWDAFW5GF1DAwb_yoWkGrX_t3
        Z8Zr18XrW7Jr4Ikw47Z3ZxJa98W398Arn3Xr4I9a43Ja4Fyr1DCas3XrySvr1xJa9rGrWU
        uasrtry5Ga10yjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8imitUUUUU==
X-Originating-IP: [116.162.2.123]
X-CM-SenderInfo: 5zdqw5xlqjyxrhvvqiyswou0bp/1tbiVw8Yp1pECb9aSAAAsd
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yingjie Wang <wangyingjie55@126.com>

There is no IPv4_is_multicast() check added to ip_mc_leave_group()
to determine whether imr->imr_multiaddr.s_addr is a multicast address.
If not a multicast address, it may result in an error.
In some cases, the callers of ip_mc_leave_group don't check
whether it is multicast address or not such as do_ip_setsockopt().
So I suggest added the ipv4_is_multicast() check to the
ip_mc_leave_group function to prevent this from happening.

Fixes: d519aa299494 ("net/ipv4: add IPv4_is_multicast() check in ip_mc_leave_group().")
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

