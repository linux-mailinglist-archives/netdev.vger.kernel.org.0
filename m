Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C3D3E1BD7
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241964AbhHES6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241874AbhHES6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 14:58:15 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A58C061765
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 11:58:00 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id g5-20020a9d6b050000b02904f21e977c3eso6198144otp.5
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 11:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f9xNd5eeH//uZK4rdGG0Bkb7evn7uqrFuY6PgG+WyoA=;
        b=uG0MUaokP1mOWoOw5+u2f657Wq7I6C3aP3Dt2HxjIVN55vW8jJnUe9NDW+Ws5KEcJ1
         b9IgIAzZA/9iVJ0xanW3vCEwgdi+Ua40CwhEEm/thAGY8mlT0r0nZm7EBCRMkI8SoEfz
         YOJGHegJhXjp2F8aq6X+I2wHGYjg9Gl9DQpQ5hua0jcGop7qpuCK5a53wsT9tWX78aXo
         mSApIM/KHv7WvoxKGIK0L9ivwiyJB+FT2ejbsvcnSowR7xE9fbMxnDViu5UwC3jR1zDr
         VgA4UPbJm3Dy52I0+3AEqqHI8k/mIfcpvY6pV2xpZiXzZ/gt1zL5L7EFN+bWss5QHXYY
         53fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f9xNd5eeH//uZK4rdGG0Bkb7evn7uqrFuY6PgG+WyoA=;
        b=G+d0lBH1hTO0uEKubvmZLQ4TZv4UrCOk0Pm0wqr4W9Wh8eRpHVNmK9CalHRCJKI9Ed
         WKAdaNOI3KEqVitN1IMF8tjFZigMcoGbUCDi23d6FiJf9VwEgLL9ufG+U4ZMwYlVGtSu
         OOwJKV/9e1qJFZnc1XkGEA8hSXMM2dhYP9ygWtt8SuL14d23lJx1jYJOa1nLpAjyYOtA
         76ciRW30lmlAlnbA4Toa863Krvi3ZomJoD4xNIr/dBHe24TJvBOc74WN2Z8Oc/LlI1k+
         be9PXT55wa21lcSuseYCA8EPUOtEsgUOi/GujqpnF9hthipZF4lJGPvPUkrWjHdpx5ej
         8aQw==
X-Gm-Message-State: AOAM530g177/46ueya1YOwzdKGZb7nG5UqVO+VV3PnDcpOaVGGMzQW+L
        koROiZCzt+ZN4dpolKV+KPEQ9yG4FoU=
X-Google-Smtp-Source: ABdhPJyAD9IqL1Cxf8X3dUioenrzcM4BOZ/hGxi6T/AftevlskBPGMl0XB2pCWgSv8J68FB0lrKSag==
X-Received: by 2002:a05:6830:150e:: with SMTP id k14mr4852874otp.351.1628189879752;
        Thu, 05 Aug 2021 11:57:59 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c64b:2366:2e53:c024])
        by smtp.gmail.com with ESMTPSA id r5sm358678otk.71.2021.08.05.11.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 11:57:59 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next 06/13] ipv4: introduce tracepoint trace_ip_rcv()
Date:   Thu,  5 Aug 2021 11:57:43 -0700
Message-Id: <20210805185750.4522-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Tracepoint trace_ip_rcv() is introduced to trace skb at the
entrance of IP layer on RX side.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/ip.h | 16 ++++++++++++++++
 net/ipv4/ip_input.c       |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/include/trace/events/ip.h b/include/trace/events/ip.h
index 553ae7276732..20ee1a81405c 100644
--- a/include/trace/events/ip.h
+++ b/include/trace/events/ip.h
@@ -83,6 +83,22 @@ TRACE_EVENT(ip_queue_xmit,
 		  __entry->saddr_v6, __entry->daddr_v6, __entry->skbaddr)
 );
 
+TRACE_EVENT(ip_rcv,
+	TP_PROTO(const struct sk_buff *skb),
+
+	TP_ARGS(skb),
+
+	TP_STRUCT__entry(
+		__field(const void *, skbaddr)
+	),
+
+	TP_fast_assign(
+		__entry->skbaddr = skb;
+	),
+
+	TP_printk("skbaddr=%px", __entry->skbaddr)
+);
+
 #endif /* _TRACE_IP_H */
 
 /* This part must be outside protection */
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 3a025c011971..2eb7a0cbc0d3 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -141,6 +141,7 @@
 #include <linux/mroute.h>
 #include <linux/netlink.h>
 #include <net/dst_metadata.h>
+#include <trace/events/ip.h>
 
 /*
  *	Process Router Attention IP option (RFC 2113)
@@ -400,6 +401,7 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 			goto drop;
 	}
 
+	trace_ip_rcv(skb);
 	return NET_RX_SUCCESS;
 
 drop:
-- 
2.27.0

