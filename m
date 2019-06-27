Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7CDF58B03
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 21:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfF0TnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 15:43:09 -0400
Received: from mail-ua1-f74.google.com ([209.85.222.74]:48825 "EHLO
        mail-ua1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfF0TnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 15:43:09 -0400
Received: by mail-ua1-f74.google.com with SMTP id s14so446386uap.15
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 12:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=bwxL9AOfJq1TYcqJgvHADeWXFMs7jT1tkEM8zoDSfPs=;
        b=ODrfRPFdwVk/nOWy3+njM94t2CicsQlKJaUSN4txJSRl0h4zbpq+UFWSw7qNb61tm9
         c/iz7eyCIFJuFWHsJeZXV0xOxwK5WlRzGeXSVbEGb8PSIYuqyz9fbNZJOJADoVZtU4UH
         Y8dSYeWzzK7goyeAYESg1Cqq91oIGk1puPI3pkLY4wExbGLhflju+TiiOSdEept6icJk
         8MqN/LfTwTG6LBWt5xPI88Fb8syWgXUHsddrFPzzIV9kqo9DhTw4ZCIhnhUq8rSjfzK1
         4DR57j70pflHGIUbclydlSfbwyK+m9xbaznMkslR+2Pn8uZ7umEtazpO4crNLvMs1J/E
         F8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=bwxL9AOfJq1TYcqJgvHADeWXFMs7jT1tkEM8zoDSfPs=;
        b=Qhj5trJHqx2gu6RRVAwYxuSf6jtMgVLdP/xUEBCUkGh1n5Dx+wNswOxDUtj+qPBH81
         j0qNX/wsVXCUVnYy7rtnwBzVi5ULy/EFQ6RGGeYg1cjALDXmzVSZTW+CDWyuWo/6w7DD
         K0nDXMufWfZyilvPKx33GFDwdTn9bwmZU7scQd/ZOp6+zqcKN2LsRgSRIUh6Lmky7fmK
         wvdH/MV5THaRx6JSbCQMCAjq0z6DQLAdcAQy+ai7z1KOb0t5vu7GSepUKbkeuAHp+sTR
         OaP2J3GRZEdgLCt2qqmDxykKeg8YcHLWxqjwz8oYaPZy9e4FC1WAAhgct2K2rR7jkwfQ
         mI9A==
X-Gm-Message-State: APjAAAVCVGSP0aUxQcMiM166e4uN/ttRI0S1Jg9/QxO/U3jEQ+sK/vwO
        +vsV3+XoJd85cjfE5ZAU39NqoSj0lOLSF+K5YgJSyGdrln2AinWtSPrZ3RTNBM1EE/onlts4p3w
        AcgVGP8YAJ+3lKbasDuIj02lnLZrTeOEx/xVBtrAIeV4oQU715ztZPQKsEqRsMeBZ
X-Google-Smtp-Source: APXvYqzIukIgSgSY6fPid0W2d2msA8EHiwaJZ2+8IlNU4inLRzreROlEwhkLCQUce+zDELq0kZD/IdokMuBD
X-Received: by 2002:a67:b919:: with SMTP id q25mr3948740vsn.18.1561664588434;
 Thu, 27 Jun 2019 12:43:08 -0700 (PDT)
Date:   Thu, 27 Jun 2019 12:43:05 -0700
Message-Id: <20190627194305.93241-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCHv2 next 2/3] blackhole_netdev: use blackhole_netdev to
 invalidate dst entries
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Daniel Axtens <dja@axtens.net>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use blackhole_netdev instead of 'lo' device with lower MTU when marking
dst "dead".

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
v1 -> v2
  no change

 net/core/dst.c   | 2 +-
 net/ipv4/route.c | 3 +--
 net/ipv6/route.c | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/core/dst.c b/net/core/dst.c
index e46366228eaf..1325316d9eab 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -160,7 +160,7 @@ void dst_dev_put(struct dst_entry *dst)
 		dst->ops->ifdown(dst, dev, true);
 	dst->input = dst_discard;
 	dst->output = dst_discard_out;
-	dst->dev = dev_net(dst->dev)->loopback_dev;
+	dst->dev = blackhole_netdev;
 	dev_hold(dst->dev);
 	dev_put(dev);
 }
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 59670fafcd26..d61f43feb7fa 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1532,7 +1532,6 @@ static void ipv4_dst_destroy(struct dst_entry *dst)
 
 void rt_flush_dev(struct net_device *dev)
 {
-	struct net *net = dev_net(dev);
 	struct rtable *rt;
 	int cpu;
 
@@ -1543,7 +1542,7 @@ void rt_flush_dev(struct net_device *dev)
 		list_for_each_entry(rt, &ul->head, rt_uncached) {
 			if (rt->dst.dev != dev)
 				continue;
-			rt->dst.dev = net->loopback_dev;
+			rt->dst.dev = blackhole_netdev;
 			dev_hold(rt->dst.dev);
 			dev_put(dev);
 		}
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e7c2824435c6..ff44c6287633 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -176,7 +176,7 @@ static void rt6_uncached_list_flush_dev(struct net *net, struct net_device *dev)
 			}
 
 			if (rt_dev == dev) {
-				rt->dst.dev = loopback_dev;
+				rt->dst.dev = blackhole_netdev;
 				dev_hold(rt->dst.dev);
 				dev_put(rt_dev);
 			}
-- 
2.22.0.410.gd8fdbe21b5-goog

