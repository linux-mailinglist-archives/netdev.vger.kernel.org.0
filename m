Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47DBF35643
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 07:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfFEFgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 01:36:50 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42234 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfFEFgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 01:36:49 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so3954818pff.9;
        Tue, 04 Jun 2019 22:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6pAoJMkPJ8p6YXmO6rf1rwv2o6IqrBA1VeK84hEEJHo=;
        b=j9TC7A9KW+qZ2K5BGxPQhoaIJpwvvhvzFTgbw+x/05i2SeTzofNyfgLLLiGUkhKn4o
         BeMRSqOFmbBXg+MmrIuFBQT3UfHvZzhSX6Gr8E4SPI+GTaM9jtyP3CCSwN93hGgJX+/l
         XlGdA+ZqJxUKmrRNR3ndN0/6eyvuCsWUAX/JHEskNxuUWtCTlLnk7cJtuwtlsgVnwY30
         MikcJeqN4mCOlweN9vXqKjd8SFbVnWNAil420wLiniQg0nF9M+tuml0fwHUaoHUh8tN3
         kkMDtG9CFH+wrIM4DrHAACnHIFCSkVYrk3CrMIvV4Y76ETw9as8Y/K90Xy03cuScsJEn
         Z78A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6pAoJMkPJ8p6YXmO6rf1rwv2o6IqrBA1VeK84hEEJHo=;
        b=e3DCiCcvaMbmFbQd8XDelh/3TEM0Jj0HXn3zyL5CldfXKYf6Cqyt7QGUpxoiKHpURb
         WDc3kr0a7JuzhUhPdjTv7IKPr5zYeTaS313JVHyHPaD/Mdspd+rUGYJDrzwRhsttFnuz
         TjAk4Ptf/xGZVUaHl6Ys0nAGZMPYBcjKXRregqUkq6+CaV6t4gQpNIyebrqUDeYd5s+6
         ldZzTWEc52wTenjDhs7FALv5Z5wpGBX5fubvKpCo9SXVy9UaoZreGGznJll6jnjFCJQ/
         9Z9tDDCjEjr+fxX4qZv2K8XUJEbkBHBeHdk38vSTLlsEhBR8njFp53JY12h+DxurTg66
         lOuQ==
X-Gm-Message-State: APjAAAWsH1LoqoG8xPlbHNAJbBFtdVM+rAqpnxUR0JXViGek532b7qNt
        rfpP52uR3CKHbO8aJcameOs=
X-Google-Smtp-Source: APXvYqzNKrbuKghOWGWQfvysVkhGadmk+/BFCIevOuM4/ozdSvzhV0vLyRXrpBOy8LoCmK0MYtRoXQ==
X-Received: by 2002:a63:a41:: with SMTP id z1mr1937629pgk.389.1559713008712;
        Tue, 04 Jun 2019 22:36:48 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id j15sm22745816pfn.187.2019.06.04.22.36.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 22:36:48 -0700 (PDT)
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
Subject: [PATCH v2 bpf-next 1/2] xdp: Add tracepoint for bulk XDP_TX
Date:   Wed,  5 Jun 2019 14:36:12 +0900
Message-Id: <20190605053613.22888-2-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190605053613.22888-1-toshiaki.makita1@gmail.com>
References: <20190605053613.22888-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is introduced for admins to check what is happening on XDP_TX when
bulk XDP_TX is in use, which will be first introduced in veth in next
commit.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 include/trace/events/xdp.h | 25 +++++++++++++++++++++++++
 kernel/bpf/core.c          |  1 +
 2 files changed, 26 insertions(+)

diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index e95cb86..e06ea65 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -50,6 +50,31 @@
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
+		__field(int, drops)
+		__field(int, sent)
+		__field(int, err)
+	),
+
+	TP_fast_assign(
+		__entry->ifindex	= dev->ifindex;
+		__entry->drops		= drops;
+		__entry->sent		= sent;
+		__entry->err		= err;
+	),
+
+	TP_printk("ifindex=%d sent=%d drops=%d err=%d",
+		  __entry->ifindex, __entry->sent, __entry->drops, __entry->err)
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

