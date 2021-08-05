Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132AE3E1BDA
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242042AbhHES6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241899AbhHES6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 14:58:17 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D91C0617A5
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 11:58:03 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id o185so8650036oih.13
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 11:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DUY4lKwppCJiRHA1jTheA/1frTIkO707O3tPxlgy9nw=;
        b=gINrXuu5PsHTcbrHVnaX2UnZB3cdCoxzlCivJ+OXOgD1K6SfPBm8Ucnjsb/u5RMVdo
         71G+AwgrUrFrO/pSMF3CVn6BS7f/pccKH7tyfjgxpZEcIKJa+vG93JnsRfHZFKYsHDWV
         y5MaxINlLpICA9249ZDe4AFN5xQbZDHDKXMRNgXdZSYQ4C0nGm8PtJll6mOs4fJYDqOd
         0mVKzvV4ubhDt+pkB/GFnru4vwp0LW0S3QZEOQE/qS/b+56uGqzn/BthQAc+tP89UcZW
         xqjGIJ2zgcrnwzxsU8rRA+xrWHb4M95Nb/ogavx47zz/19Aqo5o1wcR7/mjyb1lAR23C
         BXQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DUY4lKwppCJiRHA1jTheA/1frTIkO707O3tPxlgy9nw=;
        b=m06DbKmvBZyhcvD+hJ3fTMdC25QG1Je/RgT+mdxxjBHi3FfQia1LhPGD5SlTgeZyxg
         yVED46mcscZXu1mn5fTntr8yYm9sY8/68sH05kRQ8g/phFQ+a7fZOYN2SKdD2l+nTOKf
         7lhjngJe8b6fs4YRpsgGqngwlbn1cTqGPO3bErHgOnnWU22bCt0PkGRTjCNKHW2hq9go
         vT4fQVZBtCIzEKM+aDCwe19fq+uvlerACjNIkpJ1R+4J44u1lfY7hOWK8fw1GEGN/sT4
         f67povuU9JdZSEB9cnTmD8RotIQPY/vY0hiFqCqYth62kCm56o0VWZrD0KnjUYubDT2t
         6XeQ==
X-Gm-Message-State: AOAM530Oe8lvHfQwT32akW+JGRVdb49Atj82ybPM2G3GzL82sRHefZV2
        6s48GB5RLadwGB2VjqwNSKp/hCj/M6M=
X-Google-Smtp-Source: ABdhPJyk2ZhWGYIeugzoshqsRhY8SItQic8sIZE+EQohEXyUdRMu0aKLttK4q0It+7bVOuLL/qmG+w==
X-Received: by 2002:aca:4e94:: with SMTP id c142mr1869700oib.177.1628189882425;
        Thu, 05 Aug 2021 11:58:02 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c64b:2366:2e53:c024])
        by smtp.gmail.com with ESMTPSA id r5sm358678otk.71.2021.08.05.11.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 11:58:02 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next 09/13] udp: introduce tracepoint trace_udp_rcv()
Date:   Thu,  5 Aug 2021 11:57:46 -0700
Message-Id: <20210805185750.4522-10-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Tracepoint trace_udp_rcv() is introduced to trace skb at
the entrance of UDP layer on RX side.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/udp.h | 17 +++++++++++++++++
 net/ipv4/udp.c             |  8 +++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/udp.h b/include/trace/events/udp.h
index 6af4b402237a..5008bdd546e8 100644
--- a/include/trace/events/udp.h
+++ b/include/trace/events/udp.h
@@ -27,6 +27,23 @@ TRACE_EVENT(udp_fail_queue_rcv_skb,
 	TP_printk("rc=%d port=%hu", __entry->rc, __entry->lport)
 );
 
+TRACE_EVENT(udp_rcv,
+
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
 TRACE_EVENT(udp_send_skb,
 
 	TP_PROTO(const struct sock *sk, const struct sk_buff *skb),
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index daa618465a1d..4751a8f9acff 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2617,7 +2617,13 @@ int udp_v4_early_demux(struct sk_buff *skb)
 
 int udp_rcv(struct sk_buff *skb)
 {
-	return __udp4_lib_rcv(skb, &udp_table, IPPROTO_UDP);
+	int ret;
+
+	ret = __udp4_lib_rcv(skb, &udp_table, IPPROTO_UDP);
+	if (!ret)
+		trace_udp_rcv(skb);
+	return ret;
+
 }
 
 void udp_destroy_sock(struct sock *sk)
-- 
2.27.0

