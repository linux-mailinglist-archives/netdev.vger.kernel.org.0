Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F422567A21
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 00:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiGEWhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 18:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiGEWhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 18:37:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50EDDECF;
        Tue,  5 Jul 2022 15:37:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27AF461D45;
        Tue,  5 Jul 2022 22:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98ACC341C7;
        Tue,  5 Jul 2022 22:37:42 +0000 (UTC)
Date:   Tue, 5 Jul 2022 18:37:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] neighbor: tracing: Have neigh_create event use __string()
Message-ID: <20220705183741.35387e3f@rorschach.local.home>
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

The dev field of the neigh_create event uses __dynamic_array() with a
fixed size, which defeats the purpose of __dynamic_array(). Looking at the
logic, as it already uses __assign_str(), just use the same logic in
__string to create the size needed. It appears that because "dev" can be
NULL, it needs the check. But __string() can have the same checks as
__assign_str() so use them there too.

Cc: David Ahern <dsahern@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---

[ This is simpler logic than the fib* events, so I figured just
  convert to __string() instead of a static __array() ]

 include/trace/events/neigh.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/neigh.h b/include/trace/events/neigh.h
index 62bb17516713..5eaa1fa99171 100644
--- a/include/trace/events/neigh.h
+++ b/include/trace/events/neigh.h
@@ -30,7 +30,7 @@ TRACE_EVENT(neigh_create,
 
 	TP_STRUCT__entry(
 		__field(u32, family)
-		__dynamic_array(char,  dev,   IFNAMSIZ )
+		__string(dev, dev ? dev->name : "NULL")
 		__field(int, entries)
 		__field(u8, created)
 		__field(u8, gc_exempt)
-- 
2.35.1

