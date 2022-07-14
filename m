Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A894957530A
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 18:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237312AbiGNQnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 12:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235187AbiGNQng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 12:43:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BBB4B0F4;
        Thu, 14 Jul 2022 09:43:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3046262053;
        Thu, 14 Jul 2022 16:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9458BC341CE;
        Thu, 14 Jul 2022 16:43:29 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1oC1w0-004lMO-KB;
        Thu, 14 Jul 2022 12:43:28 -0400
Message-ID: <20220714164328.461963902@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 14 Jul 2022 12:42:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [for-next][PATCH 03/23] tracing: devlink: Use static array for string in devlink_trap_report
 even
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

The trace event devlink_trap_report uses the __dynamic_array() macro to
determine the size of the input_dev_name field. This is because it needs
to test the dev field for NULL, and will use "NULL" if it is. But it also
has the size of the dynamic array as a fixed IFNAMSIZ bytes. This defeats
the purpose of the dynamic array, as this will reserve that amount of
bytes on the ring buffer, and to make matters worse, it will even save
that size in the event as the event expects it to be dynamic (for which it
is not).

Since IFNAMSIZ is just 16 bytes, just make it a static array and this will
remove the meta data from the event that records the size.

Link: https://lkml.kernel.org/r/20220712185820.002d9fb5@gandalf.local.home

Cc: Leon Romanovsky <leon@kernel.org>
Cc: Jiri Pirko <jiri@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/trace/events/devlink.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/devlink.h b/include/trace/events/devlink.h
index 2814f188d98c..24969184c534 100644
--- a/include/trace/events/devlink.h
+++ b/include/trace/events/devlink.h
@@ -186,7 +186,7 @@ TRACE_EVENT(devlink_trap_report,
 		__string(driver_name, devlink_to_dev(devlink)->driver->name)
 		__string(trap_name, metadata->trap_name)
 		__string(trap_group_name, metadata->trap_group_name)
-		__dynamic_array(char, input_dev_name, IFNAMSIZ)
+		__array(char, input_dev_name, IFNAMSIZ)
 	),
 
 	TP_fast_assign(
@@ -197,15 +197,14 @@ TRACE_EVENT(devlink_trap_report,
 		__assign_str(driver_name, devlink_to_dev(devlink)->driver->name);
 		__assign_str(trap_name, metadata->trap_name);
 		__assign_str(trap_group_name, metadata->trap_group_name);
-		__assign_str(input_dev_name,
-			     (input_dev ? input_dev->name : "NULL"));
+		strscpy(__entry->input_dev_name, input_dev ? input_dev->name : "NULL", IFNAMSIZ);
 	),
 
 	TP_printk("bus_name=%s dev_name=%s driver_name=%s trap_name=%s "
 		  "trap_group_name=%s input_dev_name=%s", __get_str(bus_name),
 		  __get_str(dev_name), __get_str(driver_name),
 		  __get_str(trap_name), __get_str(trap_group_name),
-		  __get_str(input_dev_name))
+		  __entry->input_dev_name)
 );
 
 #endif /* _TRACE_DEVLINK_H */
-- 
2.35.1
