Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036F725DA97
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730648AbgIDNyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730567AbgIDNyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 09:54:22 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C48C061251;
        Fri,  4 Sep 2020 06:54:14 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mm21so3231175pjb.4;
        Fri, 04 Sep 2020 06:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6p167BPsiF1zCEf+N843XcEpo+Z9u7WNQshAXfhw53E=;
        b=nGTEE85eET4Yo/K0po0+3VC/lho4Sptjai1sa27si/N2Pw9KQwRo/4JcoMOUr3AUIC
         OkZj0RRwmNGcYQOet6ZCVuUpdP3FSoudXnbTtIwVB5OyXVM0DexMLRilWu39Zi7zJew8
         SNir4AG8wQL8ytTXD0RCe0+pYBHAS32jDxSnyHFB5S2vQ6cqY2InZ3SLbjUB9UtcWHr5
         xHhUW7NT3cCcJiwZC21q1JBiJ12flAWDXjp6fjKQdifZVeUE8L1IbrISXNVvwJNFReN4
         EIPGXPS3WhRlmMG2xwNJyUYYiwHBWWQWfTBfA/eaFVAQNEJxv2cLMHSVKWiceNV2nV7s
         qbnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6p167BPsiF1zCEf+N843XcEpo+Z9u7WNQshAXfhw53E=;
        b=oHSRAV/0ZGP7qkIzqvaSIvAd0sxFWAvj98Xukftwvuq+r47/QXbtHmtPI3CVNGTkUn
         3wXbGJi18QpBv3+WHw36kqOtefbWe7hjHqz7HLjhVlvzMZQ23IWRSdxolfoxN0GtbhkO
         8n7fK4jqWqUhEaFgn73NHNBivDa4Y2uXQ8HQPIp79NQ2XqW9kPn5wyLBSLVKlodtFwkt
         59k2YUfBRbDBlcnokF28EgaGsAxM3PzrtfWXj03s1T5Lr6Q0K9CkmaKqj2ro2Ho61QY+
         eFhWNlB8WMEJ5Eky+Uc1abc552uhKxnMT7ekRnn4UBhKyKQZUS2i3eCjr70pqHZwfkq0
         1ydw==
X-Gm-Message-State: AOAM532hFD+YJCOJ8xZosU+ym6izf/sBloSUvMFaQntG//KBRf3YV/Z9
        5UASUyCMyTLIq3QfkNgiDkM=
X-Google-Smtp-Source: ABdhPJz49bRPhGh1Ztm9ufAlKTs0J93VJw8p0pB+61IOeisgN9GSLaKg24JMuQcmFL63AhwbMGyVJQ==
X-Received: by 2002:a17:90a:4046:: with SMTP id k6mr8232176pjg.11.1599227654415;
        Fri, 04 Sep 2020 06:54:14 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id g9sm6931239pfr.172.2020.09.04.06.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 06:54:13 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 1/6] xsk: improve xdp_do_redirect() error codes
Date:   Fri,  4 Sep 2020 15:53:26 +0200
Message-Id: <20200904135332.60259-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200904135332.60259-1-bjorn.topel@gmail.com>
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The error codes returned by xdp_do_redirect() when redirecting a frame
to an AF_XDP socket has not been very useful. A driver could not
distinguish between different errors. Prior this change the following
codes where used:

Socket not bound or incorrect queue/netdev: EINVAL
XDP frame/AF_XDP buffer size mismatch: ENOSPC
Could not allocate buffer (copy mode): ENOSPC
AF_XDP Rx buffer full: ENOSPC

After this change:

Socket not bound or incorrect queue/netdev: EINVAL
XDP frame/AF_XDP buffer size mismatch: ENOSPC
Could not allocate buffer (copy mode): ENOMEM
AF_XDP Rx buffer full: ENOBUFS

An AF_XDP zero-copy driver can now potentially determine if the
failure was due to a full Rx buffer, and if so stop processing more
frames, yielding to the userland AF_XDP application.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c       | 2 +-
 net/xdp/xsk_queue.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 3895697f8540..db38560c4af7 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -197,7 +197,7 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len,
 	xsk_xdp = xsk_buff_alloc(xs->pool);
 	if (!xsk_xdp) {
 		xs->rx_dropped++;
-		return -ENOSPC;
+		return -ENOMEM;
 	}
 
 	xsk_copy_xdp(xsk_xdp, xdp, len);
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 2d883f631c85..b76966cf122e 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -305,7 +305,7 @@ static inline int xskq_prod_reserve_desc(struct xsk_queue *q,
 	u32 idx;
 
 	if (xskq_prod_is_full(q))
-		return -ENOSPC;
+		return -ENOBUFS;
 
 	/* A, matches D */
 	idx = q->cached_prod++ & q->ring_mask;
-- 
2.25.1

