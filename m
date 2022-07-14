Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956F657530F
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 18:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238665AbiGNQno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 12:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237703AbiGNQnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 12:43:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78652CC1;
        Thu, 14 Jul 2022 09:43:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C60856205E;
        Thu, 14 Jul 2022 16:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDC3C341CD;
        Thu, 14 Jul 2022 16:43:30 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1oC1w1-004lPj-Nq;
        Thu, 14 Jul 2022 12:43:29 -0400
Message-ID: <20220714164329.572809096@goodmis.org>
User-Agent: quilt/0.66
Date:   Thu, 14 Jul 2022 12:43:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Subject: [for-next][PATCH 09/23] tracing/brcm: Use the new __vstring() helper
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

Instead of open coding a __dynamic_array() with a fixed length (which
defeats the purpose of the dynamic array in the first place). Use the new
__vstring() helper that will use a va_list and only write enough of the
string into the ring buffer that is needed.

Link: https://lkml.kernel.org/r/20220705224749.622796175@goodmis.org

Cc: Arend van Spriel <aspriel@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: SHA-cyfmac-dev-list@infineon.com
Cc: netdev@vger.kernel.org
Acked-by: Kalle Valo <kvalo@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .../broadcom/brcm80211/brcmfmac/tracepoint.h         | 12 ++++--------
 .../brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h    | 12 ++++--------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h
index 338c66d0c5f8..5a139d7ed47a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h
@@ -33,13 +33,11 @@ TRACE_EVENT(brcmf_err,
 	TP_ARGS(func, vaf),
 	TP_STRUCT__entry(
 		__string(func, func)
-		__dynamic_array(char, msg, MAX_MSG_LEN)
+		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
 		__assign_str(func, func);
-		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
-				       MAX_MSG_LEN, vaf->fmt,
-				       *vaf->va) >= MAX_MSG_LEN);
+		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk("%s: %s", __get_str(func), __get_str(msg))
 );
@@ -50,14 +48,12 @@ TRACE_EVENT(brcmf_dbg,
 	TP_STRUCT__entry(
 		__field(u32, level)
 		__string(func, func)
-		__dynamic_array(char, msg, MAX_MSG_LEN)
+		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
 		__entry->level = level;
 		__assign_str(func, func);
-		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
-				       MAX_MSG_LEN, vaf->fmt,
-				       *vaf->va) >= MAX_MSG_LEN);
+		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk("%s: %s", __get_str(func), __get_str(msg))
 );
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h
index 0e8a69ab909f..488456420353 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h
@@ -28,12 +28,10 @@ DECLARE_EVENT_CLASS(brcms_msg_event,
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
@@ -64,14 +62,12 @@ TRACE_EVENT(brcms_dbg,
 	TP_STRUCT__entry(
 		__field(u32, level)
 		__string(func, func)
-		__dynamic_array(char, msg, MAX_MSG_LEN)
+		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
 		__entry->level = level;
 		__assign_str(func, func);
-		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
-				       MAX_MSG_LEN, vaf->fmt,
-				       *vaf->va) >= MAX_MSG_LEN);
+		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk("%s: %s", __get_str(func), __get_str(msg))
 );
-- 
2.35.1
