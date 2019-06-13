Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD2F443DFA
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732999AbfFMPqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:46:39 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36765 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731787AbfFMJke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 05:40:34 -0400
Received: by mail-pl1-f195.google.com with SMTP id d21so7897847plr.3;
        Thu, 13 Jun 2019 02:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+XJa3hI7C/DWe69XCCaqBEl/nyj92kKguap6+DVO3NI=;
        b=F35YehXwA8tJO2YrP4wlu/QJp4iFcaRqL71u0CNbxmRkgqoWpo+rB3kMGzXFOaQ8Ae
         h4v2FCnqOsWLhHLSih3+hzfO6YRss874jMQ5LFoJDagYEVWCy3wJ0y9G38EJPTJBKe18
         Bfv37H4x3n0AGK5hCCWXBtiu1X88JpoOyOANeH2VaX2+Xoop5CM6reZb8RAC6z8VjB7N
         6I24keRZ7cRmtUMjfWLeXdn9ZCsxBQovYsdFTDMBW7OwEGyReTKP2QlqbDShBCj+SmmM
         +r7nd9UWWBiPiMfD1lSft5hDXE+ELW+dBXLCSdtPmYYFMBgyN8bmYUxjlA60AN6PhU+L
         O/5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+XJa3hI7C/DWe69XCCaqBEl/nyj92kKguap6+DVO3NI=;
        b=Pm3EtjPEEZR7AznZvFX+CZCgBq4pJP70DKU2CRPK1lIcjulbDPPePolEdFt/3NjV9J
         sq9HdQK4rKF0PZq4n/d9NSd4c2sncO5PBT77bZfDFbyKHJdLnSLygbvOa0IM+XIEa1g1
         vbMXUkAaLZV3TQCS2v9FkziXoUkWo6Dh1Muj4Jr6KFwKcoGZU3JPlEP2X3Wy9rHBAPXK
         +bZB/56IqqVvfNVCjxDQZtkT/r700TASk/HS/HF3vtFoqCNPQVTIg3CUEfgO0hoOmU+D
         1IFld6ypZ0NDHu8lsEs8fYg+WZcNo3qtYJ4p5XVt4TkGRJEmkU5JQRdbA4a92y6dQWat
         f48w==
X-Gm-Message-State: APjAAAUTSNhamiU9DUqoI0Hww6LSfBGQp+NOBNxIPO5LRWVstsGmMrK9
        A8gyW3eWT8l3khHAte4aOaw=
X-Google-Smtp-Source: APXvYqw2yZ0GH1HP7aI+URVYis9IoIqvTykSoiw19DxS4dcZpTjsbcEdKgfiYVFMMrtbyM7I4WqnkA==
X-Received: by 2002:a17:902:bd46:: with SMTP id b6mr86149810plx.173.1560418833432;
        Thu, 13 Jun 2019 02:40:33 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id y1sm2501015pfe.19.2019.06.13.02.40.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 02:40:32 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH v3 bpf-next 1/2] xdp: Add tracepoint for bulk XDP_TX
Date:   Thu, 13 Jun 2019 18:39:58 +0900
Message-Id: <20190613093959.2796-2-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190613093959.2796-1-toshiaki.makita1@gmail.com>
References: <20190613093959.2796-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is introduced for admins to check what is happening on XDP_TX when
bulk XDP_TX is in use, which will be first introduced in veth in next
commit.

v3:
- Add act field to be in line with other XDP tracepoints.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 include/trace/events/xdp.h | 29 +++++++++++++++++++++++++++++
 kernel/bpf/core.c          |  1 +
 2 files changed, 30 insertions(+)

diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index e95cb86..01389b9 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -50,6 +50,35 @@
 		  __entry->ifindex)
 );
 
+TRACE_EVENT(xdp_bulk_tx,
+
+	TP_PROTO(const struct net_device *dev,
+		 int sent, int drops, int err),
+
+	TP_ARGS(dev, sent, drops, err),
+
+	TP_STRUCT__entry(
+		__field(int, ifindex)
+		__field(u32, act)
+		__field(int, drops)
+		__field(int, sent)
+		__field(int, err)
+	),
+
+	TP_fast_assign(
+		__entry->ifindex	= dev->ifindex;
+		__entry->act		= XDP_TX;
+		__entry->drops		= drops;
+		__entry->sent		= sent;
+		__entry->err		= err;
+	),
+
+	TP_printk("ifindex=%d action=%s sent=%d drops=%d err=%d",
+		  __entry->ifindex,
+		  __print_symbolic(__entry->act, __XDP_ACT_SYM_TAB),
+		  __entry->sent, __entry->drops, __entry->err)
+);
+
 DECLARE_EVENT_CLASS(xdp_redirect_template,
 
 	TP_PROTO(const struct net_device *dev,
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 33fb292..3a3f4af 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2106,3 +2106,4 @@ int __weak skb_copy_bits(const struct sk_buff *skb, int offset, void *to,
 #include <linux/bpf_trace.h>
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(xdp_exception);
+EXPORT_TRACEPOINT_SYMBOL_GPL(xdp_bulk_tx);
-- 
1.8.3.1

