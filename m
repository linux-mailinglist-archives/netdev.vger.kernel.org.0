Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33C5575308
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 18:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbiGNQnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 12:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235593AbiGNQng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 12:43:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085F74B496;
        Thu, 14 Jul 2022 09:43:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E87B62058;
        Thu, 14 Jul 2022 16:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2B7C341D5;
        Thu, 14 Jul 2022 16:43:29 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1oC1w0-004lNU-W7;
        Thu, 14 Jul 2022 12:43:28 -0400
Message-ID: <20220714164328.829739741@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 14 Jul 2022 12:43:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>
Subject: [for-next][PATCH 05/23] neighbor: tracing: Have neigh_create event use __string()
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

The dev field of the neigh_create event uses __dynamic_array() with a
fixed size, which defeats the purpose of __dynamic_array(). Looking at the
logic, as it already uses __assign_str(), just use the same logic in
__string to create the size needed. It appears that because "dev" can be
NULL, it needs the check. But __string() can have the same checks as
__assign_str() so use them there too.

Link: https://lkml.kernel.org/r/20220705183741.35387e3f@rorschach.local.home

Cc: David Ahern <dsahern@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Acked-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
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
