Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 358EC7E4D5
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 23:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389211AbfHAVgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 17:36:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731662AbfHAVgi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 17:36:38 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 147CE2064A;
        Thu,  1 Aug 2019 21:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564695398;
        bh=iiI4sT9zcK5ZzoAg0ZjWXALrJaDjNWtGmWpUma1O8UM=;
        h=From:To:Cc:Subject:Date:From;
        b=CFFX8+W3IOUWJtAQf9JRLCmCT3dUMO/Uf0n4z6RkjNyq/Zl4pwZaQaxV+mpwgqBAU
         iQyuCckG1iQQ45FRYS4qGCNLxxbC3PHW3pcAln3mtqojCJgkgkO/Sb6XPUBCSknIL1
         jNmfhZ57Y5LHdkZudTNRpHk1MIXMupCH1Sd9TGsk=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH net] ipv6: Fix unbalanced rcu locking in rt6_update_exception_stamp_rt
Date:   Thu,  1 Aug 2019 14:36:35 -0700
Message-Id: <20190801213635.9278-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The nexthop path in rt6_update_exception_stamp_rt needs to call
rcu_read_unlock if it fails to find a fib6_nh match rather than
just returning.

Fixes: e659ba31d806 ("ipv6: Handle all fib6_nh in a nexthop in exception handling")
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e49fec767a10..fd059e08785a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1951,7 +1951,7 @@ static void rt6_update_exception_stamp_rt(struct rt6_info *rt)
 		nexthop_for_each_fib6_nh(from->nh, fib6_nh_find_match, &arg);
 
 		if (!arg.match)
-			return;
+			goto unlock;
 		fib6_nh = arg.match;
 	} else {
 		fib6_nh = from->fib6_nh;
-- 
2.11.0

