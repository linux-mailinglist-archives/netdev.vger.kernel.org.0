Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8168E495635
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 23:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377984AbiATWDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 17:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347676AbiATWDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 17:03:32 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5212C061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 14:03:32 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id t18so6578396plg.9
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 14:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=vkeM4ZdaoX9JKSeOZJ1Z5S3sGMLlchGg2FAGrDURiuI=;
        b=EG/Fqs2rDVMfMu77qFIRy9Gh7odQfZy5DkmTOpuBgw/0oCIUGTR7R1RoQGWshhna2m
         iRFSejVHsDLX0RHZblcXnaTKxlXTRhC4qnOxqD4gYNws3B1npJ24nVQwZL5cIRJrERPg
         Nx7YWyBrCRpdb1Bwbdw+BAOaIKOIF6tFBAzF8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vkeM4ZdaoX9JKSeOZJ1Z5S3sGMLlchGg2FAGrDURiuI=;
        b=jBFfnPWDkuhLVziqgweRUWyvKXQCOc0EEAX/guwTG5ASybiqWqny3FQpyTvLJtcapo
         IsYdWK3Wus4Dxo5on5FP24/j6KfLjPT9IFN6TxrF/YVm6yoOSzhxm1YsaMRKTh22jIU0
         CkOLiqxTI6CAMnvubL/QhZO8z98Uhnic7Yba9PTbN1OOSmBLNmi0eLKpEMbCnCv5Ozc4
         Q9t+zZErPyoAeBu6JC+2Y46tYofwgZRPb3k6nN0bobn5fmTHXA/12K002BJgr2IrXZYv
         h9gTXIqL9xkahYI+RzzDHRRJwljg1lrvzoi7QqmVRBiifn/Ed+Z3BgaUtN8AdkzdXxz0
         Lfgw==
X-Gm-Message-State: AOAM532leXRYcyXWRlEFb1/cs+swkeFUPP2yfy85CHC+4rw3uQ8g4LVv
        5fl5dNeugd7MIdr2dl6KR18e2drF+4R+a+y1bnx+aVLaG544Wt3pDBccPWPFj/VhL7ETOYGdgne
        kvFAWoXYyntfVMIiJop3UWZ1Xsq3WV/vbXkOTK96q2BEpeMkjefiZb+Zs3BeYSJNJWN2u
X-Google-Smtp-Source: ABdhPJxJsHBOoePaDRGjwyDqEvwsBOCoOauP7XQqud9lJA9KtayieRljn7/z4JRZLEiN9Z/g/JynQA==
X-Received: by 2002:a17:902:ce8d:b0:14a:70dc:2050 with SMTP id f13-20020a170902ce8d00b0014a70dc2050mr742439plg.11.1642716211624;
        Thu, 20 Jan 2022 14:03:31 -0800 (PST)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id nk11sm3270937pjb.55.2022.01.20.14.03.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jan 2022 14:03:31 -0800 (PST)
From:   Joe Damato <jdamato@fastly.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Joe Damato <jdamato@fastly.com>
Subject: [PATCH net-next] sock: add sndbuff full perf trace event
Date:   Thu, 20 Jan 2022 14:02:30 -0800
Message-Id: <1642716150-100589-1-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calls to sock_alloc_send_pskb can fail or trigger a wait if there is no
sndbuf space available.

Add a perf trace event to help users monitor when and how this occurs so
appropriate application level changes can be made, if necessary.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 include/trace/events/sock.h | 21 +++++++++++++++++++++
 net/core/sock.c             |  1 +
 2 files changed, 22 insertions(+)

diff --git a/include/trace/events/sock.h b/include/trace/events/sock.h
index 12c3157..de6f6a7 100644
--- a/include/trace/events/sock.h
+++ b/include/trace/events/sock.h
@@ -68,6 +68,27 @@ skmem_kind_names
 #define show_skmem_kind_names(val)	\
 	__print_symbolic(val, skmem_kind_names)
 
+TRACE_EVENT(sock_sndbuf_full,
+	TP_PROTO(struct sock *sk, long timeo),
+
+	TP_ARGS(sk, timeo),
+
+	TP_STRUCT__entry(
+		__field(int, wmem_alloc)
+		__field(int, sk_sndbuf)
+		__field(long, timeo)
+	),
+
+	TP_fast_assign(
+		__entry->wmem_alloc = refcount_read(&sk->sk_wmem_alloc);
+		__entry->sk_sndbuf = READ_ONCE(sk->sk_sndbuf);
+		__entry->timeo = timeo;
+	),
+
+	TP_printk("wmem_alloc=%d sk_sndbf=%d timeo=%ld",
+		__entry->wmem_alloc, __entry->sk_sndbuf, __entry->timeo)
+);
+
 TRACE_EVENT(sock_rcvqueue_full,
 
 	TP_PROTO(struct sock *sk, struct sk_buff *skb),
diff --git a/net/core/sock.c b/net/core/sock.c
index e21485a..674627c 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2571,6 +2571,7 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 
 		sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
+		trace_sock_sndbuf_full(sk, timeo);
 		err = -EAGAIN;
 		if (!timeo)
 			goto failure;
-- 
2.7.4

