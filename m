Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF165575307
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 18:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237666AbiGNQnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 12:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235379AbiGNQng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 12:43:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30C64B483;
        Thu, 14 Jul 2022 09:43:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DB1C62054;
        Thu, 14 Jul 2022 16:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C179AC341D0;
        Thu, 14 Jul 2022 16:43:29 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1oC1w0-004lMw-QG;
        Thu, 14 Jul 2022 12:43:28 -0400
Message-ID: <20220714164328.646104564@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 14 Jul 2022 12:43:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>
Subject: [for-next][PATCH 04/23] tracing/ipv4/ipv6: Use static array for name field in
 fib*_lookup_table event
References: <20220714164256.403842845@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The fib_lookup_table and fib6_lookup_table events declare name as a
dynamic_array, but also give it a fixed size, which defeats the purpose of
the dynamic array, especially since the dynamic array also includes meta
data in the event to specify its size.

Since the size of the name is at most 16 bytes (defined by IFNAMSIZ),
it is not worth spending the effort to determine the size of the string.

Just use a fixed size array and copy into it. This will save 4 bytes that
are used for the meta data that saves the size and position of a dynamic
array, and even slightly speed up the event processing.

Link: https://lkml.kernel.org/r/20220704091436.3705edbf@rorschach.local.home

Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Acked-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/trace/events/fib.h  | 6 +++---
 include/trace/events/fib6.h | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/trace/events/fib.h b/include/trace/events/fib.h
index 6f2a4dc35e37..c2300c407f58 100644
--- a/include/trace/events/fib.h
+++ b/include/trace/events/fib.h
@@ -32,7 +32,7 @@ TRACE_EVENT(fib_table_lookup,
 		__array(	__u8,	gw6,	16	)
 		__field(	u16,	sport		)
 		__field(	u16,	dport		)
-		__dynamic_array(char,  name,   IFNAMSIZ )
+		__array(char,  name,   IFNAMSIZ )
 	),
 
 	TP_fast_assign(
@@ -66,7 +66,7 @@ TRACE_EVENT(fib_table_lookup,
 		}
 
 		dev = nhc ? nhc->nhc_dev : NULL;
-		__assign_str(name, dev ? dev->name : "-");
+		strlcpy(__entry->name, dev ? dev->name : "-", IFNAMSIZ);
 
 		if (nhc) {
 			if (nhc->nhc_gw_family == AF_INET) {
@@ -95,7 +95,7 @@ TRACE_EVENT(fib_table_lookup,
 		  __entry->tb_id, __entry->oif, __entry->iif, __entry->proto,
 		  __entry->src, __entry->sport, __entry->dst, __entry->dport,
 		  __entry->tos, __entry->scope, __entry->flags,
-		  __get_str(name), __entry->gw4, __entry->gw6, __entry->err)
+		  __entry->name, __entry->gw4, __entry->gw6, __entry->err)
 );
 #endif /* _TRACE_FIB_H */
 
diff --git a/include/trace/events/fib6.h b/include/trace/events/fib6.h
index c6abdcc77c12..6e821eb79450 100644
--- a/include/trace/events/fib6.h
+++ b/include/trace/events/fib6.h
@@ -31,7 +31,7 @@ TRACE_EVENT(fib6_table_lookup,
 		__field(        u16,	dport		)
 		__field(        u8,	proto		)
 		__field(        u8,	rt_type		)
-		__dynamic_array(	char,	name,	IFNAMSIZ )
+		__array(		char,	name,	IFNAMSIZ )
 		__array(		__u8,	gw,	16	 )
 	),
 
@@ -63,9 +63,9 @@ TRACE_EVENT(fib6_table_lookup,
 		}
 
 		if (res->nh && res->nh->fib_nh_dev) {
-			__assign_str(name, res->nh->fib_nh_dev);
+			strlcpy(__entry->name, res->nh->fib_nh_dev->name, IFNAMSIZ);
 		} else {
-			__assign_str(name, "-");
+			strcpy(__entry->name, "-");
 		}
 		if (res->f6i == net->ipv6.fib6_null_entry) {
 			struct in6_addr in6_zero = {};
@@ -83,7 +83,7 @@ TRACE_EVENT(fib6_table_lookup,
 		  __entry->tb_id, __entry->oif, __entry->iif, __entry->proto,
 		  __entry->src, __entry->sport, __entry->dst, __entry->dport,
 		  __entry->tos, __entry->scope, __entry->flags,
-		  __get_str(name), __entry->gw, __entry->err)
+		  __entry->name, __entry->gw, __entry->err)
 );
 
 #endif /* _TRACE_FIB6_H */
-- 
2.35.1
