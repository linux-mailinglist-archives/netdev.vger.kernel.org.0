Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75D0482102
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 01:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242385AbhLaAgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 19:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242376AbhLaAgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 19:36:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26176C06173F
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 16:36:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F64A61767
        for <netdev@vger.kernel.org>; Fri, 31 Dec 2021 00:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E738CC36AED;
        Fri, 31 Dec 2021 00:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640911000;
        bh=SADsJkcvRyqA8lYJUXxAYJpuycgbiWK2zcclMETF26I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZtvrGFAh/yIcY0GyN5J+ctfPwmo3rH03J7fpbGt8cS+A+tcGsJshD/6MK+q63KAb
         sqQX/89Bglbpu6eEWsQFO2g34106XFgJAN0IjJnJeBSnx0Cvx7uarrvm/KGe8W1fHY
         8eg4zUXIb5Zv1xtqzgQcKD82aYDtHgIJ/xbOxGSVeUWgQr9KxIdcQWCaqiyH9zaJ6m
         zPkcPmh6EQK/wO634ZOTthjCAJN60ZLraoW2iUtwLjKC1+QVhyNjo6uSXLIbp7WWVq
         yygOumYQvW5Q+m9R8M9HVmpCIn2K/PyVMF61GJdiMAFtw7paOJa2mtGgn38sqZm8Yt
         E8foQFHlf3IbQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     idosch@idosch.org, David Ahern <dsahern@kernel.org>,
        syzbot+d4b9a2851cc3ce998741@syzkaller.appspotmail.com,
        Thomas Graf <tgraf@suug.ch>
Subject: [PATCH net 1/5] ipv4: Check attribute length for RTA_GATEWAY in multipath route
Date:   Thu, 30 Dec 2021 17:36:31 -0700
Message-Id: <20211231003635.91219-2-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20211231003635.91219-1-dsahern@kernel.org>
References: <20211231003635.91219-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported uninit-value:
============================================================
  BUG: KMSAN: uninit-value in fib_get_nhs+0xac4/0x1f80
  net/ipv4/fib_semantics.c:708
   fib_get_nhs+0xac4/0x1f80 net/ipv4/fib_semantics.c:708
   fib_create_info+0x2411/0x4870 net/ipv4/fib_semantics.c:1453
   fib_table_insert+0x45c/0x3a10 net/ipv4/fib_trie.c:1224
   inet_rtm_newroute+0x289/0x420 net/ipv4/fib_frontend.c:886

Add helper to validate RTA_GATEWAY length before using the attribute.

Fixes: 4e902c57417c ("[IPv4]: FIB configuration using struct fib_config")
Reported-by: syzbot+d4b9a2851cc3ce998741@syzkaller.appspotmail.com
Signed-off-by: David Ahern <dsahern@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>
---
 net/ipv4/fib_semantics.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index fde7797b5806..f1caa2c1c041 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -662,6 +662,19 @@ static int fib_count_nexthops(struct rtnexthop *rtnh, int remaining,
 	return nhs;
 }
 
+static int fib_gw_from_attr(__be32 *gw, struct nlattr *nla,
+			    struct netlink_ext_ack *extack)
+{
+	if (nla_len(nla) < sizeof(*gw)) {
+		NL_SET_ERR_MSG(extack, "Invalid IPv4 address in RTA_GATEWAY");
+		return -EINVAL;
+	}
+
+	*gw = nla_get_in_addr(nla);
+
+	return 0;
+}
+
 /* only called when fib_nh is integrated into fib_info */
 static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
 		       int remaining, struct fib_config *cfg,
@@ -704,7 +717,11 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
 				return -EINVAL;
 			}
 			if (nla) {
-				fib_cfg.fc_gw4 = nla_get_in_addr(nla);
+				ret = fib_gw_from_attr(&fib_cfg.fc_gw4, nla,
+						       extack);
+				if (ret)
+					goto errout;
+
 				if (fib_cfg.fc_gw4)
 					fib_cfg.fc_gw_family = AF_INET;
 			} else if (nlav) {
@@ -902,6 +919,7 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 		attrlen = rtnh_attrlen(rtnh);
 		if (attrlen > 0) {
 			struct nlattr *nla, *nlav, *attrs = rtnh_attrs(rtnh);
+			int err;
 
 			nla = nla_find(attrs, attrlen, RTA_GATEWAY);
 			nlav = nla_find(attrs, attrlen, RTA_VIA);
@@ -912,12 +930,17 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 			}
 
 			if (nla) {
+				__be32 gw;
+
+				err = fib_gw_from_attr(&gw, nla, extack);
+				if (err)
+					return err;
+
 				if (nh->fib_nh_gw_family != AF_INET ||
-				    nla_get_in_addr(nla) != nh->fib_nh_gw4)
+				    gw != nh->fib_nh_gw4)
 					return 1;
 			} else if (nlav) {
 				struct fib_config cfg2;
-				int err;
 
 				err = fib_gw_from_via(&cfg2, nlav, extack);
 				if (err)
-- 
2.24.3 (Apple Git-128)

