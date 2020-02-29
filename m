Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2173B17440A
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 02:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgB2BAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 20:00:00 -0500
Received: from gateway22.websitewelcome.com ([192.185.47.163]:20111 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726418AbgB2BAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 20:00:00 -0500
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 57E54B4D65
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 18:59:59 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 7qU3jdMVXAGTX7qU3jmDi7; Fri, 28 Feb 2020 18:59:59 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=09qBJCuV/qfG9uVAPQck4bm+6ufBYKRI0cgJkKY3QlE=; b=TsGPF8Ib7thdSZ5hUAKHUjEtl1
        7G/Y+oqHWJBnFwf7tiD7GazelZ/06uaJjjdPxiNCQWF0mab4VIWCrDaG2YMuJcDkZewT2CoQwRZRA
        Y7k5RQOLAru1+DyYYfYWW8kQoEGOAX4VhT2FmVQFWSJaZtwD5I261dwJ8PWDOrq8GyhJ+VTBc4Vsr
        7Ig0jxIRUNkdESYJ6ej/VU2nBUyRg/8Ke3TfFGQld1ZgBhYiVFdc69Qo+vkbZZWhQVefhnooDfsel
        OFO+RVFGV1+scG3Vo8G4rG8i8wjI9s+cMQ2kNnfVdr728IwYeFJLJly8YQl3uPbNAXFj2FuScIR5Z
        wcJV1Ajg==;
Received: from [200.39.15.57] (port=20013 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j7qU1-002yoq-Gw; Fri, 28 Feb 2020 18:59:57 -0600
Date:   Fri, 28 Feb 2020 19:02:54 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] net: flow_offload: Replace zero-length array with
 flexible-array member
Message-ID: <20200229010254.GA9547@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 200.39.15.57
X-Source-L: No
X-Exim-ID: 1j7qU1-002yoq-Gw
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [200.39.15.57]:20013
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 42
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 include/net/flow_offload.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 4e864c34a1b0..cd3510ac66b0 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -229,7 +229,7 @@ struct flow_action_entry {
 
 struct flow_action {
 	unsigned int			num_entries;
-	struct flow_action_entry 	entries[0];
+	struct flow_action_entry	entries[];
 };
 
 static inline bool flow_action_has_entries(const struct flow_action *action)
-- 
2.25.0

