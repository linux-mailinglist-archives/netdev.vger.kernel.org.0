Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7282A6D3786
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 13:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjDBLPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 07:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbjDBLPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 07:15:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9AFAF0C;
        Sun,  2 Apr 2023 04:15:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D65FFB8068D;
        Sun,  2 Apr 2023 11:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7C9C4339B;
        Sun,  2 Apr 2023 11:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680434141;
        bh=qDuCb9jB6m4dPBHgb/ksN36Hij3KDguXmS0bhWU2DiA=;
        h=From:Date:Subject:To:Cc:From;
        b=e4gDTBliFoU/oaCbgZJa+s1wt9Jia1+DIGqn5B/Wb51kBv+CKPgFkcPoQ/am+Y6YI
         Nvf1+Qgg0f+ds+ohoTYLjQerbMSovH5MXpEWJvzz9tX9ztqgGWPLhTq14FrRp1ZrsS
         CQguvUyybzd9vyTkBDIplQz2VYvYC9CRA6ONz+l9yIsQKAa/ZyJco6Qif7n/TpFecl
         DnLAei72nZQPnfZWu1/qZALbMM0qZ61lSkWp3wi7v6L8/QTI0NgU7RMg9VOYxshkJR
         UxZSaydpcShXcGOPzZ/vWXSp5sM8J/JKTPwaSi2wuvAyjCiAL4IwipM66nqQCP1dfH
         eBoJqNQm2cnTw==
From:   Simon Horman <horms@kernel.org>
Date:   Sun, 02 Apr 2023 13:15:33 +0200
Subject: [PATCH RFC] net: qrtr: correct types of trace event parameters
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230402-qrtr-trace-types-v1-1-da062d368e74@kernel.org>
X-B4-Tracking: v=1; b=H4sIANRjKWQC/x2NQQrCQAwAv1JyNrDGpYpXwQd4FQ/pNrULZa3JK
 krp3w0eZ2CYBUw0i8GxWUDlnS0/isN200AaudwFc+8MFGgXYiB8alWsykmwfmcxpMhE+7aPh6E
 Fzzo2wU65pNHD8poml7PKkD//zxUu5xPc1vUHZpq9onwAAAA=
To:     Manivannan Sadhasivam <mani@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The arguments passed to the trace events are of type unsigned int,
however the signature of the events used __le32 parameters.

I may be missing the point here, but sparse flagged this and it
does seem incorrect to me.

  net/qrtr/ns.c: note: in included file (through include/trace/trace_events.h, include/trace/define_trace.h, include/trace/events/qrtr.h):
  ./include/trace/events/qrtr.h:11:1: warning: cast to restricted __le32
  ./include/trace/events/qrtr.h:11:1: warning: restricted __le32 degrades to integer
  ./include/trace/events/qrtr.h:11:1: warning: restricted __le32 degrades to integer
  ... (a lot more similar warnings)
  net/qrtr/ns.c:115:47:    expected restricted __le32 [usertype] service
  net/qrtr/ns.c:115:47:    got unsigned int service
  net/qrtr/ns.c:115:61: warning: incorrect type in argument 2 (different base types)
  ... (a lot more similar warnings)

Signed-off-by: Simon Horman <horms@kernel.org>
---
 include/trace/events/qrtr.h | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/include/trace/events/qrtr.h b/include/trace/events/qrtr.h
index b1de14c3bb93..441132c67133 100644
--- a/include/trace/events/qrtr.h
+++ b/include/trace/events/qrtr.h
@@ -10,15 +10,16 @@
 
 TRACE_EVENT(qrtr_ns_service_announce_new,
 
-	TP_PROTO(__le32 service, __le32 instance, __le32 node, __le32 port),
+	TP_PROTO(unsigned int service, unsigned int instance,
+		 unsigned int node, unsigned int port),
 
 	TP_ARGS(service, instance, node, port),
 
 	TP_STRUCT__entry(
-		__field(__le32, service)
-		__field(__le32, instance)
-		__field(__le32, node)
-		__field(__le32, port)
+		__field(unsigned int, service)
+		__field(unsigned int, instance)
+		__field(unsigned int, node)
+		__field(unsigned int, port)
 	),
 
 	TP_fast_assign(
@@ -36,15 +37,16 @@ TRACE_EVENT(qrtr_ns_service_announce_new,
 
 TRACE_EVENT(qrtr_ns_service_announce_del,
 
-	TP_PROTO(__le32 service, __le32 instance, __le32 node, __le32 port),
+	TP_PROTO(unsigned int service, unsigned int instance,
+		 unsigned int node, unsigned int port),
 
 	TP_ARGS(service, instance, node, port),
 
 	TP_STRUCT__entry(
-		__field(__le32, service)
-		__field(__le32, instance)
-		__field(__le32, node)
-		__field(__le32, port)
+		__field(unsigned int, service)
+		__field(unsigned int, instance)
+		__field(unsigned int, node)
+		__field(unsigned int, port)
 	),
 
 	TP_fast_assign(
@@ -62,15 +64,16 @@ TRACE_EVENT(qrtr_ns_service_announce_del,
 
 TRACE_EVENT(qrtr_ns_server_add,
 
-	TP_PROTO(__le32 service, __le32 instance, __le32 node, __le32 port),
+	TP_PROTO(unsigned int service, unsigned int instance,
+		 unsigned int node, unsigned int port),
 
 	TP_ARGS(service, instance, node, port),
 
 	TP_STRUCT__entry(
-		__field(__le32, service)
-		__field(__le32, instance)
-		__field(__le32, node)
-		__field(__le32, port)
+		__field(unsigned int, service)
+		__field(unsigned int, instance)
+		__field(unsigned int, node)
+		__field(unsigned int, port)
 	),
 
 	TP_fast_assign(

