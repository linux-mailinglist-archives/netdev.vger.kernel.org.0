Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4476D4C38
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbjDCPnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbjDCPnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:43:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C012A173C;
        Mon,  3 Apr 2023 08:43:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37744611E4;
        Mon,  3 Apr 2023 15:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB82C433D2;
        Mon,  3 Apr 2023 15:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680536601;
        bh=/nTJ/4bKDJ/WqlH5THKtzdy/s9UbbcglRfZ7A7Rr4g0=;
        h=From:Date:Subject:To:Cc:From;
        b=KzIEdFeFu61URFI6EDe5EqZ5KxuxODX3vHbUSNUBiF7Ws1Wm5zVlP5tsS+CdDOVoX
         IpG9HTi388LWqmFLLArpkAu6Inl1Z7zTc7CPxhWftEoRlPJgN1+rXb4W8AHqigKWfR
         na1x2cKZupdE4ABL5T3RaTL4YuXBkylyCx/FxPPKu2/O5oxnZ3gjj3UrKzZKE/RjDn
         FvibN+t7Ko0eJqlLBpCG35vtHB9wtAJCd4iqABdYIykHlksz57UJPR0+nMyJrM5EN3
         IHck0+KC7Kx7+VljtU+82OTYwj67gT7CNrahULHEOGqP8Yh8IjsotU0YenzP3ljOut
         yoDujDxEkPKqg==
From:   Simon Horman <horms@kernel.org>
Date:   Mon, 03 Apr 2023 17:43:16 +0200
Subject: [PATCH net-next] net: qrtr: correct types of trace event
 parameters
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230402-qrtr-trace-types-v1-1-92ad55008dd3@kernel.org>
X-B4-Tracking: v=1; b=H4sIABP0KmQC/3WOwQqDMBBEf0X23C1JDFF66n8UD9GsGirRblJRx
 H9v8N7jm2F4c0Ak9hThURzAtPro55BB3groRhsGQu8ygxKqFFoo/HBiTGw7wrQvFFFpq1RlnK5
 7A3nW2kjYsg3dmIfhO005XJh6v12eFwRKGGhL0ORm9DHNvF8HVnn1/12rRInOCqNcaWqq9PNNH
 Gi6zzxAc57nD4OqzffQAAAA
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Manivannan Sadhasivam <mani@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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

Fixes: dfddb54043f0 ("net: qrtr: Add tracepoint support")
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Simon Horman <horms@kernel.org>
---
v1
* Drop RFC designation
* Add Fixes and Reviewed-by tags
* Target at 'net-next' (not sure if that is correct)

RFC
* Link: https://lore.kernel.org/r/20230402-qrtr-trace-types-v1-1-da062d368e74@kernel.org
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

