Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA6238013
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbfFFV5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:57:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54656 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727441AbfFFV5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 17:57:22 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3925F30832C6;
        Thu,  6 Jun 2019 21:57:22 +0000 (UTC)
Received: from dhcppc1.redhat.com (ovpn-116-49.ams2.redhat.com [10.36.116.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9E187C45F;
        Thu,  6 Jun 2019 21:57:20 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next v2 2/3] indirect call wrappers: add helpers for 3 and 4 ways switch
Date:   Thu,  6 Jun 2019 23:56:49 +0200
Message-Id: <da0ed4bdd5be343770847b2f48fe4d91e4ea37dd.1559857734.git.pabeni@redhat.com>
In-Reply-To: <cover.1559857734.git.pabeni@redhat.com>
References: <cover.1559857734.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 06 Jun 2019 21:57:22 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Experimental results[1] has shown that resorting to several branches
and a direct-call is faster than indirect call via retpoline, even
when the number of added branches go up 5.

This change adds two additional helpers, to cope with indirect calls
with up to 4 available direct call option. We will use them
in the next patch.

[1] https://linuxplumbersconf.org/event/2/contributions/99/attachments/98/117/lpc18_paper_af_xdp_perf-v2.pdf

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/indirect_call_wrapper.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/indirect_call_wrapper.h b/include/linux/indirect_call_wrapper.h
index 00d7e8e919c6..7c4cac87eaf7 100644
--- a/include/linux/indirect_call_wrapper.h
+++ b/include/linux/indirect_call_wrapper.h
@@ -23,6 +23,16 @@
 		likely(f == f2) ? f2(__VA_ARGS__) :			\
 				  INDIRECT_CALL_1(f, f1, __VA_ARGS__);	\
 	})
+#define INDIRECT_CALL_3(f, f3, f2, f1, ...)				\
+	({								\
+		likely(f == f3) ? f3(__VA_ARGS__) :			\
+				  INDIRECT_CALL_2(f, f2, f1, __VA_ARGS__); \
+	})
+#define INDIRECT_CALL_4(f, f4, f3, f2, f1, ...)				\
+	({								\
+		likely(f == f4) ? f4(__VA_ARGS__) :			\
+				  INDIRECT_CALL_3(f, f3, f2, f1, __VA_ARGS__); \
+	})
 
 #define INDIRECT_CALLABLE_DECLARE(f)	f
 #define INDIRECT_CALLABLE_SCOPE
@@ -30,6 +40,8 @@
 #else
 #define INDIRECT_CALL_1(f, f1, ...) f(__VA_ARGS__)
 #define INDIRECT_CALL_2(f, f2, f1, ...) f(__VA_ARGS__)
+#define INDIRECT_CALL_3(f, f3, f2, f1, ...) f(__VA_ARGS__)
+#define INDIRECT_CALL_4(f, f4, f3, f2, f1, ...) f(__VA_ARGS__)
 #define INDIRECT_CALLABLE_DECLARE(f)
 #define INDIRECT_CALLABLE_SCOPE		static
 #endif
-- 
2.20.1

