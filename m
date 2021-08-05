Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1583E1BD5
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241912AbhHES6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241866AbhHES6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 14:58:14 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2910C06179A
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 11:57:58 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id d10-20020a9d4f0a0000b02904f51c5004e3so1814236otl.9
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 11:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5gXqt201hXQPzHGNu6FBADW/OpgGLxD/Q2DnkbRCYQs=;
        b=btL3zEcHti9xHY6bFF3zqG+rClYmeB4FIwPChMnYj17KN58DKmgVyMJoDDjHr4yhCm
         kwajc6plXcPB/MC1S3b6LsziMfcQfPOsyaiMbK/BjAC8rmciabHRS5CmeSFRUAYlQSDk
         bs3CrJm1Gom/QbDlyDpX9OCxFRDAvJhjXPvLsbhseW7GA0SvZJojfWQWfkskLfNTvP9E
         aysi4lovf9vbePeZYsGALx500CetTtW+4nLpWXrhgifFlTE8Ez5dSBd9WTMTBAUwdxZk
         4AzCW7HTYm8xCMzOrO2PTfrYCGHkBP4Y+3fzn29WhlcTMfxtZLcTMPiw9xJ3WXSZe30/
         gD/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5gXqt201hXQPzHGNu6FBADW/OpgGLxD/Q2DnkbRCYQs=;
        b=pmEooaaxX3NTd7ULBFg+j2eMMKMAZ74KKw9JKmBO/2lb5Oa88yp+am7pUlxW3ZKYzA
         OjwISDSdWPKfRXbBQSuyLrnNxAQcaqxZ4E4nyKu7ttDYUmiPkr9i0X1dO6loAbQgmmCd
         7G03ywW5NdwEoJ4ws0Bzi10OWtrKGn4p9+hhtEWjty+eWfdGOACARHzmnuU+6grA2snC
         8lMiNkIyEQpEbsrYNWwB7WzTcrUqLBsJ1tosVS15YXvoRav7jq9qV6YCOA32V7E7gToq
         zMWk9ZXDP85N7edaw2YokBvgV4eaSW3Yz82IgoIl5vjPOrCXs7QZKrdarc/j7l8CyqyO
         o6lQ==
X-Gm-Message-State: AOAM533ig3IeVOU3Ine+Uo0BKqGzuGUpZt5wVhdLFej+6QlNOoo/+P7w
        tMxYvjzgJ85NkE4bkjZ9ks2B+2D+Tx0=
X-Google-Smtp-Source: ABdhPJxdF86KmgBFU0b2g3TfaPv9PtSts+bYnalBB9PU8Nb/s69EG/Za2ZbEqaPiR/hk7cEcZNDCSg==
X-Received: by 2002:a05:6830:3113:: with SMTP id b19mr4767289ots.152.1628189877849;
        Thu, 05 Aug 2021 11:57:57 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c64b:2366:2e53:c024])
        by smtp.gmail.com with ESMTPSA id r5sm358678otk.71.2021.08.05.11.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 11:57:57 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next 04/13] udp: introduce tracepoint trace_udp_send_skb()
Date:   Thu,  5 Aug 2021 11:57:41 -0700
Message-Id: <20210805185750.4522-5-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Tracepoint trace_udp_send_skb() is introduced to trace skb
at the exit of UDP layer on TX side.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/udp.h | 19 +++++++++++++++++++
 net/ipv4/udp.c             |  4 +++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/udp.h b/include/trace/events/udp.h
index 336fe272889f..7babc1a11693 100644
--- a/include/trace/events/udp.h
+++ b/include/trace/events/udp.h
@@ -27,6 +27,25 @@ TRACE_EVENT(udp_fail_queue_rcv_skb,
 	TP_printk("rc=%d port=%hu", __entry->rc, __entry->lport)
 );
 
+TRACE_EVENT(udp_send_skb,
+
+	TP_PROTO(const struct sock *sk, const struct sk_buff *skb),
+
+	TP_ARGS(sk, skb),
+
+	TP_STRUCT__entry(
+		__field(const void *, skaddr)
+		__field(const void *, skbaddr)
+	),
+
+	TP_fast_assign(
+		__entry->skaddr = sk;
+		__entry->skbaddr = skb;
+	),
+
+	TP_printk("skaddr=%px, skbaddr=%px", __entry->skaddr, __entry->skbaddr)
+);
+
 #endif /* _TRACE_UDP_H */
 
 /* This part must be outside protection */
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 1a742b710e54..daa618465a1d 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -970,9 +970,11 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
 				      UDP_MIB_SNDBUFERRORS, is_udplite);
 			err = 0;
 		}
-	} else
+	} else {
 		UDP_INC_STATS(sock_net(sk),
 			      UDP_MIB_OUTDATAGRAMS, is_udplite);
+		trace_udp_send_skb(sk, skb);
+	}
 	return err;
 }
 
-- 
2.27.0

