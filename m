Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAE54C04B
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730329AbfFSRu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:50:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbfFSRuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 13:50:24 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FAF52177B;
        Wed, 19 Jun 2019 17:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560966623;
        bh=rJINtBRzpJSIviUU0i122pl5fmHy01mtAWLc+xF+HWc=;
        h=From:To:Cc:Subject:Date:From;
        b=NVtjvsKR2Yla86miPriFuWiY6DB3bkHFoPbR9PM4Ie7yic6XgBdxSaMmF3cKxovsr
         AQA65dRJMhG5YBoPTVea83PuzNuvoQP9yTaSqDVHWd+8fnrw8X1/hK6xm5GcaLBy2z
         vpNxJVwaFo9qP1Bjbpd48riev6QUlg07VnvyfjNk=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net] ipv6: Default fib6_type to RTN_UNICAST when not set
Date:   Wed, 19 Jun 2019 10:50:24 -0700
Message-Id: <20190619175024.17936-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

A user reported that routes are getting installed with type 0 (RTN_UNSPEC)
where before the routes were RTN_UNICAST. One example is from accel-ppp
which apparently still uses the ioctl interface and does not set
rtmsg_type. Another is the netlink interface where ipv6 does not require
rtm_type to be set (v4 does). Prior to the commit in the Fixes tag the
ipv6 stack converted type 0 to RTN_UNICAST, so restore that behavior.

Fixes: e8478e80e5a7 ("net/ipv6: Save route type in rt6_info")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 0f60eb3a2873..11ad62effd56 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3184,7 +3184,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 
 	rt->fib6_table = table;
 	rt->fib6_metric = cfg->fc_metric;
-	rt->fib6_type = cfg->fc_type;
+	rt->fib6_type = cfg->fc_type ? : RTN_UNICAST;
 	rt->fib6_flags = cfg->fc_flags & ~RTF_GATEWAY;
 
 	ipv6_addr_prefix(&rt->fib6_dst.addr, &cfg->fc_dst, cfg->fc_dst_len);
-- 
2.11.0

