Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1793A564811
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 16:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbiGCOYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 10:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbiGCOYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 10:24:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7038251;
        Sun,  3 Jul 2022 07:24:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CB96B80A28;
        Sun,  3 Jul 2022 14:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92283C341C6;
        Sun,  3 Jul 2022 14:24:00 +0000 (UTC)
Date:   Sun, 3 Jul 2022 10:23:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] tracing/ipv4/ipv6: Give size to name field in
 fib*_lookup_table event
Message-ID: <20220703102359.30f12e39@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

Considering that the intent was to only reserve the size needed for the
name and not a fixed size, convert the size part of the __dynamic_array()
field to contain the necessary code to determine the size needed to save
the name.

Alternatively, if the intent was to use a fixed size, then it should be
converted into __array() of type char, which will remove the meta data in
the event that stores the size.

Cc: David Ahern <dsahern@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/trace/events/fib.h  | 2 +-
 include/trace/events/fib6.h | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/fib.h b/include/trace/events/fib.h
index 6f2a4dc35e37..76f925f5519a 100644
--- a/include/trace/events/fib.h
+++ b/include/trace/events/fib.h
@@ -32,7 +32,7 @@ TRACE_EVENT(fib_table_lookup,
 		__array(	__u8,	gw6,	16	)
 		__field(	u16,	sport		)
 		__field(	u16,	dport		)
-		__dynamic_array(char,  name,   IFNAMSIZ )
+		__dynamic_array(char,  name,   nhc && nhc->nhc_dev ? strlen(nhc->nhc_dev->name) + 1 : sizeof("-") )
 	),
 
 	TP_fast_assign(
diff --git a/include/trace/events/fib6.h b/include/trace/events/fib6.h
index c6abdcc77c12..d3aee58e58fd 100644
--- a/include/trace/events/fib6.h
+++ b/include/trace/events/fib6.h
@@ -31,7 +31,8 @@ TRACE_EVENT(fib6_table_lookup,
 		__field(        u16,	dport		)
 		__field(        u8,	proto		)
 		__field(        u8,	rt_type		)
-		__dynamic_array(	char,	name,	IFNAMSIZ )
+		__dynamic_array(	char,	name,	res->nh && res->nh->fib_nh_dev ?
+							strlen(res->nh->fib_nh_dev->name) + 1 : sizeof("-") )
 		__array(		__u8,	gw,	16	 )
 	),
 
-- 
2.35.1

