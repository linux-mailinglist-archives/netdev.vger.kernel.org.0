Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40334B5AE1
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 21:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiBNUOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 15:14:08 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiBNUOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 15:14:06 -0500
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54161693AC
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 12:13:50 -0800 (PST)
Received: by mail-oo1-xc34.google.com with SMTP id v17-20020a4ac911000000b002eac41bb3f4so20563099ooq.10
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 12:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=utXSItMH7ZMjMs25tYCmqg/YVcI9+ZlfZqclm1PiLxY=;
        b=Oa8FmXfMYQ7JNagTvXt/DT9WTJvQcysOR6DjEQca7eMRuXNXj7wHw6hwDf238KO7K8
         ZPoPYzxdKLwM2vfiOedYYmxtwtJ/f21HtRttZZ9I16u+PKkvaeyhJJVdFd6taZJ6/phQ
         L4pgyMKg7RPu/0WKhmmmw3b6ye9oThpwU4xYJlCfW0luc/bXVppkKq0OjWXlGrBafzJ1
         zc1aG2Hu2X4G1k2vctTaqGsuRaPJtwlYkomG89+IZej4r+uymKic7lW9qYrp2lLX+XpL
         fQOi1tSkZHkMcQGHh6H7x5iomino2jnMVmcZRhTODI42JyFtzE0jL/DpccYJMmOzQyx8
         IUQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=utXSItMH7ZMjMs25tYCmqg/YVcI9+ZlfZqclm1PiLxY=;
        b=Vt7/fPUeZCVCh18W7iqqjlEq4p5WKiogAFKle59CxPZQFQX4Q+juelqRSwILWn4mYc
         9dVu9UNAklHCZ2gc+PiR9DhSnhTR/WzJ0oGxTIMDFWu2dziiklYCYYdfk65OsdHO35Q5
         qYr0FGJqDX1HF3MFlWf44W6DPhLQxfzTjF6vc5RnHoTh7bLjeX6noKJTEnHCW0eSRLV2
         fCEe5wSsCJP/aHwB0vWNIyjOjOZmR3DOLmRYgBp8+5PZj45ES6vtk3GtliPBbJV7TOJf
         kTERNY0+NlxBYoI4G0y+5j/Ms//uAl+se320OFf11OAFiJrbQGCBuNS/+UKxBX9Ia6Ti
         tvEQ==
X-Gm-Message-State: AOAM533+D4geDD+1cjiTmHdRDKqBfnDiCgQ/V0MncPWQ9REKcfGCNieA
        l6v0VW2FCPuVA4lbrqS90YB2ml2GYZ0=
X-Google-Smtp-Source: ABdhPJyPzYBneabOLF3e/PgI4dgHygOMWPzDwB9/19lsqWl/KboHi6+75z/1H2oWo3NE2XN0HiI3Rg==
X-Received: by 2002:a05:6870:1391:: with SMTP id 17mr84581oas.38.1644864794217;
        Mon, 14 Feb 2022 10:53:14 -0800 (PST)
Received: from nyarly.redhat.com ([179.233.246.234])
        by smtp.gmail.com with ESMTPSA id o14sm3403813oaq.37.2022.02.14.10.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 10:53:13 -0800 (PST)
From:   Thiago Rafael Becker <trbecker@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, dhowells@redhat.com,
        Thiago Rafael Becker <trbecker@gmail.com>
Subject: [PATCH] dns_resolver: Add dns_query tracing
Date:   Mon, 14 Feb 2022 15:53:04 -0300
Message-Id: <20220214185304.3146173-1-trbecker@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Thiago Rafael Becker <trbecker@gmail.com>
---
 include/trace/events/dns_resolver.h | 39 +++++++++++++++++++++++++++++
 net/dns_resolver/dns_query.c        |  5 ++++
 2 files changed, 44 insertions(+)
 create mode 100644 include/trace/events/dns_resolver.h

diff --git a/include/trace/events/dns_resolver.h b/include/trace/events/dns_resolver.h
new file mode 100644
index 000000000000..c733e61ccd1e
--- /dev/null
+++ b/include/trace/events/dns_resolver.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM dns_resolver
+
+#if !defined(_TRACE_DNS_RESOLVER_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_DNS_RESOLVER_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(dns_query,
+	TP_PROTO(
+		const char *type,
+		const char *name,
+		size_t namelen,
+		const char *options
+	),
+
+	TP_ARGS(type, name, namelen, options),
+
+	TP_STRUCT__entry(
+		__string(type, type)
+		__string_len(name, name, namelen)
+		__string(options, options)
+	),
+
+	TP_fast_assign(
+		__assign_str(type, type);
+		__assign_str_len(name, name, namelen);
+		__assign_str(options, options);
+	),
+
+	TP_printk("t=%s n=%s o=%s",
+		__get_str(type), __get_str(name), __get_str(options))
+);
+
+#endif /* _TRACE_DNS_RESOLVER_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
index 82b084cc1cc6..610938dfbf6b 100644
--- a/net/dns_resolver/dns_query.c
+++ b/net/dns_resolver/dns_query.c
@@ -47,6 +47,9 @@
 
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/dns_resolver.h>
+
 /**
  * dns_query - Query the DNS
  * @net: The network namespace to operate in.
@@ -86,6 +89,8 @@ int dns_query(struct net *net,
 	kenter("%s,%*.*s,%zu,%s",
 	       type, (int)namelen, (int)namelen, name, namelen, options);
 
+	trace_dns_query(type, name, namelen, options);
+
 	if (!name || namelen == 0)
 		return -EINVAL;
 
-- 
2.31.1

