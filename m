Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C83CA6C2FD
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 00:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbfGQWHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 18:07:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbfGQWHk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 18:07:40 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB418205F4;
        Wed, 17 Jul 2019 22:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563401259;
        bh=E3HeMHJzji7XjV2syyDT2sJd4Lj6TFvLVdfiv0mxPzI=;
        h=From:To:Cc:Subject:Date:From;
        b=BfP8JRuzQ7Rb72MbauEu0MOSHMO+2q/6+PH+mrdueZgwxX7c5ipWVE3WMtFhXmGOi
         8ZEslCubf1qeIBF+KabQ0kYF88aQ6bOTxFppl5ArAB4MGsKnfSimwEqsWT6fw8zXpH
         HchQp5P0Cnz5Uwo/MfeoS2vtWAtsQWaakvrdqzDg=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@PaulSD.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net] ipv6: rt6_check should return NULL if 'from' is NULL
Date:   Wed, 17 Jul 2019 15:08:43 -0700
Message-Id: <20190717220843.974-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Paul reported that l2tp sessions were broken after the commit referenced
in the Fixes tag. Prior to this commit rt6_check returned NULL if the
rt6_info 'from' was NULL - ie., the dst_entry was disconnected from a FIB
entry. Restore that behavior.

Fixes: 93531c674315 ("net/ipv6: separate handling of FIB entries from dst based routes")
Reported-by: Paul Donohue <linux-kernel@PaulSD.com>
Tested-by: Paul Donohue <linux-kernel@PaulSD.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 4d2e6b31a8d6..6fe3097b9ab7 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2563,7 +2563,7 @@ static struct dst_entry *rt6_check(struct rt6_info *rt,
 {
 	u32 rt_cookie = 0;
 
-	if ((from && !fib6_get_cookie_safe(from, &rt_cookie)) ||
+	if (!from || !fib6_get_cookie_safe(from, &rt_cookie) ||
 	    rt_cookie != cookie)
 		return NULL;
 
-- 
2.11.0

