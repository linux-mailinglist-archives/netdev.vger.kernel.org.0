Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41B77DCACD
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436603AbfJRQRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:17:22 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33527 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727429AbfJRQRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:17:22 -0400
Received: by mail-lj1-f194.google.com with SMTP id a22so6823950ljd.0
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 09:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1WkJprAHiN7sDoSOxNNVm0RvsWZSrgVUIVIS1xKdj1A=;
        b=QKjGpmThgUe5uPfi6H5Y4tizrWbIdyy4oRLl1HFcymoYJpbbudFTHX+/SvHtKf5jxc
         xLBseXcLVgnO1SsCL9FSYkypyoL4hAKyZCbgwI5fokA9qb8WVyFnQmZfYLHFyrGtZVe2
         42PTt9+grb/kw5vOA5R+kTVWgKWvBPDY1VzNEsE+CZmJXRUJc6Wkw0YNJftKXFWtve/1
         Wdqe87oseGkhsdgAz0kYLs3gPugTEV8CjFhCWR6npS5R9beno9+e6SZeNa1XEkJRssfB
         u0WlOTZNOcO0Q4zm2UrMWBBU9LA1CG7JhnsCtVHrGw/aty4qM060GHY8qR7GpSCwMQwa
         2x2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1WkJprAHiN7sDoSOxNNVm0RvsWZSrgVUIVIS1xKdj1A=;
        b=QES/NgFl8XBdj4Qh/MXIgnp8SHBNyJGxPfm/mmBxhOZ4S3vvECcQE9qedX2YsWuwPD
         Uaaz0tF0teZBNBmKq0SrQBqk1nRmJT5Uw+tRb2x8pl0k9O2GD53BfJtHwtAkilJ857Y1
         tFuVHDaDdX1cCYTun1GPwD54LacunWCCSKRuE/nlNKh9D9I3/Vdxae9QqgF80nLv2sqO
         7GcWBGfpowtg7U378k8H7ZGcQ5N3rf4DcE5zLL+mCj4AAc1FzosRq9YBJngC8iuDZIwk
         62iUduQHz7VpODY9+utdz1cWVhlXyu5N/Sf6HmtUyQNHzqWctIvpcKa+ek0caDZtHRIM
         1MaQ==
X-Gm-Message-State: APjAAAUGN2ePjNqBf/ETliBX1tOjb4q33/L0MbQw00OQVKToqUFWvQms
        YrFHhk4StgYL0taoXivR0EWVSQ==
X-Google-Smtp-Source: APXvYqwQT2nu+pYGYkHl2zf9f85R9CBkjVB6/d2yStdWQocxuqbmhJmrNARWR0IEwsaA0gNP7SElsQ==
X-Received: by 2002:a2e:9848:: with SMTP id e8mr6744420ljj.148.1571415439738;
        Fri, 18 Oct 2019 09:17:19 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r75sm1086365lff.93.2019.10.18.09.17.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 09:17:19 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        stephen@networkplumber.org, xiyou.wangcong@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net v2 2/2] net: netem: correct the parent's backlog when corrupted packet was dropped
Date:   Fri, 18 Oct 2019 09:16:58 -0700
Message-Id: <20191018161658.26481-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191018161658.26481-1-jakub.kicinski@netronome.com>
References: <20191018161658.26481-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If packet corruption failed we jump to finish_segs and return
NET_XMIT_SUCCESS. Seeing success will make the parent qdisc
increment its backlog, that's incorrect - we need to return
NET_XMIT_DROP.

Fixes: 6071bd1aa13e ("netem: Segment GSO packets on enqueue")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 net/sched/sch_netem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 942eb17f413c..42e557d48e4e 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -616,6 +616,8 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		}
 		/* Parent qdiscs accounted for 1 skb of size @prev_len */
 		qdisc_tree_reduce_backlog(sch, -(nb - 1), -(len - prev_len));
+	} else if (!skb) {
+		return NET_XMIT_DROP;
 	}
 	return NET_XMIT_SUCCESS;
 }
-- 
2.23.0

