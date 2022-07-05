Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC567567A4D
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 00:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbiGEWtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 18:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbiGEWsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 18:48:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42041900A;
        Tue,  5 Jul 2022 15:47:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC8CBB81A3D;
        Tue,  5 Jul 2022 22:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF072C341DB;
        Tue,  5 Jul 2022 22:47:50 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1o8rKf-001yJE-VT;
        Tue, 05 Jul 2022 18:47:49 -0400
Message-ID: <20220705224749.806599472@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 05 Jul 2022 18:44:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 05/13] tracing/iwlwifi: Use the new __vstring() helper
References: <20220705224453.120955146@goodmis.org>
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

Instead of open coding a __dynamic_array() with a fixed length (which
defeats the purpose of the dynamic array in the first place). Use the new
__vstring() helper that will use a va_list and only write enough of the
string into the ring buffer that is needed.

Cc: Gregory Greenman <gregory.greenman@intel.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../net/wireless/intel/iwlwifi/iwl-devtrace-msg.h    | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h
index 7dd70011fd1e..1d6c292cf545 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h
@@ -18,12 +18,10 @@ DECLARE_EVENT_CLASS(iwlwifi_msg_event,
 	TP_PROTO(struct va_format *vaf),
 	TP_ARGS(vaf),
 	TP_STRUCT__entry(
-		__dynamic_array(char, msg, MAX_MSG_LEN)
+		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
-		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
-				       MAX_MSG_LEN, vaf->fmt,
-				       *vaf->va) >= MAX_MSG_LEN);
+		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk("%s", __get_str(msg))
 );
@@ -55,14 +53,12 @@ TRACE_EVENT(iwlwifi_dbg,
 	TP_STRUCT__entry(
 		__field(u32, level)
 		__string(function, function)
-		__dynamic_array(char, msg, MAX_MSG_LEN)
+		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
 		__entry->level = level;
 		__assign_str(function, function);
-		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
-				       MAX_MSG_LEN, vaf->fmt,
-				       *vaf->va) >= MAX_MSG_LEN);
+		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk("%s", __get_str(msg))
 );
-- 
2.35.1
