Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19E63E1BD4
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241918AbhHES6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241061AbhHES6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 14:58:12 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D14C061765
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 11:57:57 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id t1-20020a4a54010000b02902638ef0f883so1574324ooa.11
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 11:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=McPiBDHkFlEeo+/bDbhJFKtuMToZTHJqpAeNdBcA7WE=;
        b=FtYYn0/EXNO9zPob1GSYc2LSUhoIujAjNCKWcalY0Aa9VRAUD+eYIlyii0t6WRKM2x
         w9wIDwH19yNchkNBVJHmrPs70L2REPnWYyuGCzsTPcI7XiP99I6qWjLgPohzOW38IFDN
         HmjLogBmtPOeZ3bwv1nUFF4tyPgcHFLObKumgLPm1dFqiTDFJeUgxSEW/xE/+JhwSFz1
         iyEBVqKxwpiOVs90nNs1I5fmgDCV/2kDQ07lhsw14HEUCiIUp7tr3S/e3XystttckjNg
         HkGQb8pN/oaUqMqGekWJU0W/RYlt8I8um8+9Kv4rKAhv6dP8yJHMrLoH1uF34iee7Zhw
         8bHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=McPiBDHkFlEeo+/bDbhJFKtuMToZTHJqpAeNdBcA7WE=;
        b=F4Y30Rg/eKpP0HgrbuOD7kZHNVa6hYdyB3Mf62pEA8caObIxzh1o3fEo8GOQIrm242
         n7XAWeX0gKl6mZRJwta+mgIjQF77p7FznD43u/92lDEJisck/sZapHYBVGJdxsBlbOPt
         GRqh+T6sptI6jKnhLrVaf8IDOGKtivQSPXtp/9soEPzifm8jA3TUrKBY+LJ5VFarfbRp
         trVhtJMGkHmMctDWWkDnM1GAb1A1vX5pawnU3L3gKieP9iv4bZT1ftutyisDosyEO3n9
         aDsy6Sj0COWbczExXjgjL2o2VwGab1EAh1y5v7nQW9gHCJ36iD0zTnQIXsR7xnZ3Exo7
         RMSQ==
X-Gm-Message-State: AOAM530cT0TL1YYs4r9pInnzNt/F5+/AOZeMhbLeg/BV6ooHXJUrp14m
        AYsdz2y0GzlWgPiEjiUW4L62aRU2wT8=
X-Google-Smtp-Source: ABdhPJzBDFqQS/AacMf4L02mHdvy6sYJN5r0OOTjR9UxBYK5OHuk7XIcnk51zkfWXKg1auOBjCFyLg==
X-Received: by 2002:a4a:4c55:: with SMTP id a82mr4380273oob.66.1628189876814;
        Thu, 05 Aug 2021 11:57:56 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c64b:2366:2e53:c024])
        by smtp.gmail.com with ESMTPSA id r5sm358678otk.71.2021.08.05.11.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 11:57:56 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next 03/13] tcp: introduce tracepoint trace_tcp_transmit_skb()
Date:   Thu,  5 Aug 2021 11:57:40 -0700
Message-Id: <20210805185750.4522-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Tracepoint trace_tcp_transmit_skb() is introduced to trace skb
at the exit of TCP layer on TX side.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/tcp.h | 11 +++++++++--
 net/ipv4/tcp_output.c      |  8 +++++++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index 521059d8dc0a..6147528d93ba 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -88,11 +88,18 @@ DECLARE_EVENT_CLASS(tcp_event_sk_skb,
 			      sk->sk_v6_rcv_saddr, sk->sk_v6_daddr);
 	),
 
-	TP_printk("family=%s sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c state=%s",
+	TP_printk("family=%s sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c state=%s skbaddr=%px",
 		  show_family_name(__entry->family),
 		  __entry->sport, __entry->dport, __entry->saddr, __entry->daddr,
 		  __entry->saddr_v6, __entry->daddr_v6,
-		  show_tcp_state_name(__entry->state))
+		  show_tcp_state_name(__entry->state), __entry->skbaddr)
+);
+
+DEFINE_EVENT(tcp_event_sk_skb, tcp_transmit_skb,
+
+	TP_PROTO(const struct sock *sk, const struct sk_buff *skb),
+
+	TP_ARGS(sk, skb)
 );
 
 DEFINE_EVENT(tcp_event_sk_skb, tcp_retransmit_skb,
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 29553fce8502..628b28332851 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1420,8 +1420,14 @@ static int __tcp_transmit_skb(struct sock *sk, struct sk_buff *skb,
 static int tcp_transmit_skb(struct sock *sk, struct sk_buff *skb, int clone_it,
 			    gfp_t gfp_mask)
 {
-	return __tcp_transmit_skb(sk, skb, clone_it, gfp_mask,
+	int ret;
+
+	ret = __tcp_transmit_skb(sk, skb, clone_it, gfp_mask,
 				  tcp_sk(sk)->rcv_nxt);
+	if (!ret)
+		trace_tcp_transmit_skb(sk, skb);
+	return ret;
+
 }
 
 /* This routine just queues the buffer for sending.
-- 
2.27.0

