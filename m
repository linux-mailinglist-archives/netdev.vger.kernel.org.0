Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC5A567A48
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 00:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbiGEWs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 18:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbiGEWsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 18:48:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3F41BE9B;
        Tue,  5 Jul 2022 15:47:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F02C4B81A38;
        Tue,  5 Jul 2022 22:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C91C341D5;
        Tue,  5 Jul 2022 22:47:50 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@goodmis.org>)
        id 1o8rKf-001yI8-JS;
        Tue, 05 Jul 2022 18:47:49 -0400
Message-ID: <20220705224749.430339634@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 05 Jul 2022 18:44:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ath11k@lists.infradead.org
Subject: [PATCH 03/13] tracing/ath: Use the new __vstring() helper
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

Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: ath11k@lists.infradead.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 drivers/net/wireless/ath/ath10k/trace.h  | 14 ++++----------
 drivers/net/wireless/ath/ath11k/trace.h  |  7 ++-----
 drivers/net/wireless/ath/ath6kl/trace.h  | 14 ++++----------
 drivers/net/wireless/ath/trace.h         |  7 ++-----
 drivers/net/wireless/ath/wil6210/trace.h |  7 ++-----
 5 files changed, 14 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 4714c86bb501..64e7a767d963 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -52,15 +52,12 @@ DECLARE_EVENT_CLASS(ath10k_log_event,
 	TP_STRUCT__entry(
 		__string(device, dev_name(ar->dev))
 		__string(driver, dev_driver_string(ar->dev))
-		__dynamic_array(char, msg, ATH10K_MSG_MAX)
+		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
 		__assign_str(device, dev_name(ar->dev));
 		__assign_str(driver, dev_driver_string(ar->dev));
-		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
-				       ATH10K_MSG_MAX,
-				       vaf->fmt,
-				       *vaf->va) >= ATH10K_MSG_MAX);
+		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk(
 		"%s %s %s",
@@ -92,16 +89,13 @@ TRACE_EVENT(ath10k_log_dbg,
 		__string(device, dev_name(ar->dev))
 		__string(driver, dev_driver_string(ar->dev))
 		__field(unsigned int, level)
-		__dynamic_array(char, msg, ATH10K_MSG_MAX)
+		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
 		__assign_str(device, dev_name(ar->dev));
 		__assign_str(driver, dev_driver_string(ar->dev));
 		__entry->level = level;
-		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
-				       ATH10K_MSG_MAX,
-				       vaf->fmt,
-				       *vaf->va) >= ATH10K_MSG_MAX);
+		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk(
 		"%s %s %s",
diff --git a/drivers/net/wireless/ath/ath11k/trace.h b/drivers/net/wireless/ath/ath11k/trace.h
index a02e54735e88..76560587bea0 100644
--- a/drivers/net/wireless/ath/ath11k/trace.h
+++ b/drivers/net/wireless/ath/ath11k/trace.h
@@ -126,15 +126,12 @@ DECLARE_EVENT_CLASS(ath11k_log_event,
 	TP_STRUCT__entry(
 		__string(device, dev_name(ab->dev))
 		__string(driver, dev_driver_string(ab->dev))
-		__dynamic_array(char, msg, ATH11K_MSG_MAX)
+		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
 		__assign_str(device, dev_name(ab->dev));
 		__assign_str(driver, dev_driver_string(ab->dev));
-		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
-				       ATH11K_MSG_MAX,
-				       vaf->fmt,
-				       *vaf->va) >= ATH11K_MSG_MAX);
+		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk(
 		"%s %s %s",
diff --git a/drivers/net/wireless/ath/ath6kl/trace.h b/drivers/net/wireless/ath/ath6kl/trace.h
index a3d3740419eb..231a94769ddb 100644
--- a/drivers/net/wireless/ath/ath6kl/trace.h
+++ b/drivers/net/wireless/ath/ath6kl/trace.h
@@ -253,13 +253,10 @@ DECLARE_EVENT_CLASS(ath6kl_log_event,
 	TP_PROTO(struct va_format *vaf),
 	TP_ARGS(vaf),
 	TP_STRUCT__entry(
-		__dynamic_array(char, msg, ATH6KL_MSG_MAX)
+		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
-		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
-				       ATH6KL_MSG_MAX,
-				       vaf->fmt,
-				       *vaf->va) >= ATH6KL_MSG_MAX);
+		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk("%s", __get_str(msg))
 );
@@ -284,14 +281,11 @@ TRACE_EVENT(ath6kl_log_dbg,
 	TP_ARGS(level, vaf),
 	TP_STRUCT__entry(
 		__field(unsigned int, level)
-		__dynamic_array(char, msg, ATH6KL_MSG_MAX)
+		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
 		__entry->level = level;
-		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
-				       ATH6KL_MSG_MAX,
-				       vaf->fmt,
-				       *vaf->va) >= ATH6KL_MSG_MAX);
+		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk("%s", __get_str(msg))
 );
diff --git a/drivers/net/wireless/ath/trace.h b/drivers/net/wireless/ath/trace.h
index ba711644d27e..9935cf475b6d 100644
--- a/drivers/net/wireless/ath/trace.h
+++ b/drivers/net/wireless/ath/trace.h
@@ -40,16 +40,13 @@ TRACE_EVENT(ath_log,
 	    TP_STRUCT__entry(
 		    __string(device, wiphy_name(wiphy))
 		    __string(driver, KBUILD_MODNAME)
-		    __dynamic_array(char, msg, ATH_DBG_MAX_LEN)
+		    __vstring(msg, vaf->fmt, vaf->va)
 	    ),
 
 	    TP_fast_assign(
 		    __assign_str(device, wiphy_name(wiphy));
 		    __assign_str(driver, KBUILD_MODNAME);
-		    WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
-					   ATH_DBG_MAX_LEN,
-					   vaf->fmt,
-					   *vaf->va) >= ATH_DBG_MAX_LEN);
+		    __assign_vstr(msg, vaf->fmt, vaf->va);
 	    ),
 
 	    TP_printk(
diff --git a/drivers/net/wireless/ath/wil6210/trace.h b/drivers/net/wireless/ath/wil6210/trace.h
index 11c989e95880..201f44612c31 100644
--- a/drivers/net/wireless/ath/wil6210/trace.h
+++ b/drivers/net/wireless/ath/wil6210/trace.h
@@ -70,13 +70,10 @@ DECLARE_EVENT_CLASS(wil6210_log_event,
 	TP_PROTO(struct va_format *vaf),
 	TP_ARGS(vaf),
 	TP_STRUCT__entry(
-		__dynamic_array(char, msg, WIL6210_MSG_MAX)
+		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
-		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
-				       WIL6210_MSG_MAX,
-				       vaf->fmt,
-				       *vaf->va) >= WIL6210_MSG_MAX);
+		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk("%s", __get_str(msg))
 );
-- 
2.35.1
