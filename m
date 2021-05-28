Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACC7393B8D
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 04:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbhE1CsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 22:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhE1CsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 22:48:12 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FAAC061574;
        Thu, 27 May 2021 19:46:38 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id c20so2821728qkm.3;
        Thu, 27 May 2021 19:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=63x/uDQdlSiWdgfjl3Ict0S+sheF4xMnvJJh/SQ9eeM=;
        b=YkA70FdjJt6hKIfJed9dsDJ3HyVm+emcF1E75Nmo56r70jCEjfJgDoFDLsrpoXG2Yr
         gn59e+SYW/qk/LjxWoMw9lqtrACoaQx1PJysPza1DaFXA0UHoAiBPTATmhxyp5s/e/mV
         3umwvn1lRrnV6fyyZk1Bms6Talt5xwBLYblEr+gj9D2FCZF2aQ3Xp5vtvX4QbcOlWRuz
         BYAzQZbfUMGZfFdjoN7gGYNzYW/Y6Pu7hkqG4Vl6nQtoxZHuqp03TyChgyKmlJW8n6ml
         wneRaHEoJ02bJfik+MvzrR+B00yDmlGaptwx+g/waaU4Cx5X6iHU22Wke+HivSaurkRM
         CdpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=63x/uDQdlSiWdgfjl3Ict0S+sheF4xMnvJJh/SQ9eeM=;
        b=q4SJJwMx2TnHlNZ4E1b28pnEbGfYsjNPo9SUy2zVeh26xG6wgI6tNC9JjtiWTaz5U6
         +FwZwERCUtss0VQut1yJ+aL0VLf76Jl1qpfnw0DR3WCXiTGWndE/+M6mJECeLA2wMv6N
         e9DXnm2sM/ZsxfM9nPiB4jFY9YrhYwmabWKmXNWVrYHuQGN+1RorJPWJ5euY1nWcQmMh
         3C49GK4dQkbxD+chsv31IdITS5TZxX+EeQ6BS9gCqBmBQXixfUy+EfhbTGsToDvc0toQ
         zbTt1GTnbdCtmfqNiGyKVFyYktEmD+F0mcLvfTb1y/Psk69AhEcsTwTE+gNcoyM0721D
         SZGQ==
X-Gm-Message-State: AOAM532UG6BlbRaxl0cevCQQH2l5Q7VjUMBd18xfB/p/47QwqHOFgQUv
        QsjxMRwZID2ilB0/ktHW6RQNJqZrKXzFaQ==
X-Google-Smtp-Source: ABdhPJw8nbDd2icp+LhNJJOM7IWzYJcvRY8qR9/E6Abb7n9Wm5iO6tLWiikMChnmW3qZnsygIuGHfg==
X-Received: by 2002:a37:e205:: with SMTP id g5mr1722928qki.449.1622169997878;
        Thu, 27 May 2021 19:46:37 -0700 (PDT)
Received: from wsfd-netdev-buildsys.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j15sm2497542qtv.11.2021.05.27.19.46.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 May 2021 19:46:37 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf-next] bpf/devmap: remove drops variable from bq_xmit_all()
Date:   Thu, 27 May 2021 22:43:56 -0400
Message-Id: <20210528024356.24333-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Colin pointed out, the first drops assignment after declaration will
be overwritten by the second drops assignment before using, which makes
it useless.

Since the drops variable will be used only once. Just remove it and
use "cnt - sent" in trace_xdp_devmap_xmit()

Reported-by: Colin Ian King <colin.king@canonical.com>
Fixes: cb261b594b41 ("bpf: Run devmap xdp_prog on flush instead of bulk enqueue")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 kernel/bpf/devmap.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index f9148daab0e3..2a75e6c2d27d 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -370,8 +370,8 @@ static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
 static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 {
 	struct net_device *dev = bq->dev;
-	int sent = 0, drops = 0, err = 0;
 	unsigned int cnt = bq->count;
+	int sent = 0, err = 0;
 	int to_send = cnt;
 	int i;
 
@@ -388,8 +388,6 @@ static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 		to_send = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
 		if (!to_send)
 			goto out;
-
-		drops = cnt - to_send;
 	}
 
 	sent = dev->netdev_ops->ndo_xdp_xmit(dev, to_send, bq->q, flags);
@@ -408,9 +406,8 @@ static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
 		xdp_return_frame_rx_napi(bq->q[i]);
 
 out:
-	drops = cnt - sent;
 	bq->count = 0;
-	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
+	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, cnt - sent, err);
 }
 
 /* __dev_flush is called from xdp_do_flush() which _must_ be signaled
-- 
2.26.3

