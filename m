Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C9C3E1BD9
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242014AbhHES6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241889AbhHES6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 14:58:17 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47855C0617A3
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 11:58:02 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id f20-20020a9d6c140000b02904bb9756274cso6201918otq.6
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 11:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3NDv+2mkKlSB+W/MaDynaGijbuMKowO0Dp3HF5S/4+Y=;
        b=GsM45pdYOR2O9617KOLK5xeKEBAJYLFbA5Lu6DlxDfa9w0PhjZtNMHFJcgqSGAOnnt
         6Cp4h7hSXyGCHvmzodP8arOaByohsS+wOxD5btYqedZbn3L6M3qnmhFhoRQbF83JOqps
         9aRltHXr29frrxLy+YdtoadEeIydfVd/4RKD0D3ijICv/prCHd5H2BRplxQoJt6/LLx0
         FthtaSPlshxQlcbdg+e7YNkaxiik6/clvU/2rUz2xtjG7h1F2naFtFRXP2JlYOkWaG8O
         FmqeCZeSRAeNiOLBaJXCVNUe4SzW7G1OAXaJipJWJjm1oUAeN9KNKy5yZ9qQXrsPBcQ8
         u2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3NDv+2mkKlSB+W/MaDynaGijbuMKowO0Dp3HF5S/4+Y=;
        b=YQgjoo7BoDWfnrP6Wwm4CG/PcFW8S/pmUhrjYEmxKoxvsfJrKo2k/FpSWI+fJ8fwD8
         /Hfp12aAST2785Kv9b/Xhq2Ab5bpQway913ZeByCgt+pe+35xqU4ASyHqCJ09NQwInMP
         XpXmU15Ol4KyQUezi+RJh+ohaFus/eKs4FAgU+PDP8oDPzWtd4yAoOsWMhHThOW1bwxk
         wdXSldaebcwcBsi/GWWu7eq6k6nRVN2on0tdLp/2ORRCo2vY24c/m6J9laEpokcgOOG9
         MdW/gF6JEahv+WRWHBQJ+4HgK38tdGnBYtgdSSLJ39uhjMp1CC/Az400TDQS+g+WVMJ3
         7Kjg==
X-Gm-Message-State: AOAM532SsYxEWi2Qu0lLULsybNGiKPN56Uyil1kYrKavuWngYNmL3YDP
        s26GsUA55toKdc6nP7f5FmBKUT2Nsr8=
X-Google-Smtp-Source: ABdhPJwqJadlgsrL8ORkjVJvstrOA1JZpTysudp+/k6/+8qXAQyJ3PP7SS32MdtX2mflOLd0pNJjQg==
X-Received: by 2002:a05:6830:b84:: with SMTP id a4mr4661375otv.357.1628189881551;
        Thu, 05 Aug 2021 11:58:01 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:c64b:2366:2e53:c024])
        by smtp.gmail.com with ESMTPSA id r5sm358678otk.71.2021.08.05.11.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 11:58:01 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next 08/13] ipv4: introduce tracepoint trace_ip_local_deliver_finish()
Date:   Thu,  5 Aug 2021 11:57:45 -0700
Message-Id: <20210805185750.4522-9-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
References: <20210805185750.4522-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Tracepoint trace_ip_local_deliver_finish() is introduced to trace
skb at the exit of IP layer on RX side.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/ip.h | 17 +++++++++++++++++
 net/ipv4/ip_input.c       |  7 ++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/ip.h b/include/trace/events/ip.h
index 6cd0907728ce..9653bc3c7fa0 100644
--- a/include/trace/events/ip.h
+++ b/include/trace/events/ip.h
@@ -117,6 +117,23 @@ TRACE_EVENT(ipv6_rcv,
 );
 #endif
 
+TRACE_EVENT(ip_local_deliver_finish,
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
 #endif /* _TRACE_IP_H */
 
 /* This part must be outside protection */
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 2eb7a0cbc0d3..31c5c6903fff 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -244,15 +244,20 @@ int ip_local_deliver(struct sk_buff *skb)
 	 *	Reassemble IP fragments.
 	 */
 	struct net *net = dev_net(skb->dev);
+	int ret;
 
 	if (ip_is_fragment(ip_hdr(skb))) {
 		if (ip_defrag(net, skb, IP_DEFRAG_LOCAL_DELIVER))
 			return 0;
 	}
 
-	return NF_HOOK(NFPROTO_IPV4, NF_INET_LOCAL_IN,
+	ret = NF_HOOK(NFPROTO_IPV4, NF_INET_LOCAL_IN,
 		       net, NULL, skb, skb->dev, NULL,
 		       ip_local_deliver_finish);
+	if (!ret)
+		trace_ip_local_deliver_finish(skb);
+	return ret;
+
 }
 EXPORT_SYMBOL(ip_local_deliver);
 
-- 
2.27.0

