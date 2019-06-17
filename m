Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96E6647F8A
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 12:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbfFQKVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 06:21:33 -0400
Received: from foss.arm.com ([217.140.110.172]:44492 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbfFQKVd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 06:21:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 607ED344;
        Mon, 17 Jun 2019 03:21:32 -0700 (PDT)
Received: from e119884-lin.cambridge.arm.com (e119884-lin.cambridge.arm.com [10.1.196.72])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C390C3F246;
        Mon, 17 Jun 2019 03:23:16 -0700 (PDT)
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        vincenzo.frascino@arm.com
Subject: [PATCH] fib_semantics: Fix warning in fib_check_nh_v4_gw
Date:   Mon, 17 Jun 2019 11:21:19 +0100
Message-Id: <20190617102119.56253-1-vincenzo.frascino@arm.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the err variable in fib_check_nh_v4_gw may be used
uninitialized leading to the warning below:

  fib_semantics.c: In function ‘fib_check_nh_v4_gw’:
  fib_semantics.c:1023:12: warning: ‘err’ may be used
    uninitialised in this function [-Wmaybe-uninitialized]
       if (!tbl || err) {
                   ^~

Initialize err to 0 to fix the warning.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
---
 net/ipv4/fib_semantics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index b80410673915..bfa49a88d03a 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -964,7 +964,7 @@ static int fib_check_nh_v4_gw(struct net *net, struct fib_nh *nh, u32 table,
 {
 	struct net_device *dev;
 	struct fib_result res;
-	int err;
+	int err = 0;
 
 	if (nh->fib_nh_flags & RTNH_F_ONLINK) {
 		unsigned int addr_type;
-- 
2.21.0

