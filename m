Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B925724929E
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 04:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgHSCAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 22:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbgHSCAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 22:00:39 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F84C061389;
        Tue, 18 Aug 2020 19:00:37 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id c10so465906pjn.1;
        Tue, 18 Aug 2020 19:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PN3fIhrJJyl3pPILHSdeC20nIVFKLI7QiZuW9O5IrG8=;
        b=nyuFA3kTs2vyDGWig2dHP/Ats5sZqUVGiHjlEiAlC7fXpMSOaL1Me1NmdnnY9yJXfg
         n2+leRzk4IrRkKQr9MaJHE4t7uMUp1+UOUOgiWHobt5sWglD0qSV+E1mKVc2pDyLJpe8
         zF2w87+6FhxbDkIumxHyCcujBTmQsBvFjJpNsViuaSs63zzjOnqk99ns8B7/MOBAeU1T
         /Coah0bsoyQoXM9Md+in2c8+vA/2CSpRx/B6BmBUHOfk13WpQ+0XYURdi67708dvrQLQ
         LNzjm1u8WBH6/tqSt3ChxzKhj1B5hpSVcUJbOkDhheVHGCIhAqFoHuPdE4eH3lcBiasj
         FCRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PN3fIhrJJyl3pPILHSdeC20nIVFKLI7QiZuW9O5IrG8=;
        b=X7YszeNH432Q5c/0RtA3xeriMNuEkghk5eJ3B0gnHZfSy9PS3ACZcCZroOfcbpHxgY
         czsQUzivGictq532G9GGYQMSKrZAYm3xitoodVmwai/K9uH+eM8aI6z0UfHlvCN5Yell
         lv2n5/Y0ygPaHD42Hh0QEYQ0lqirAjwmuYFz65Hk0mPjrNUU29tf/NZtwfUzl7f8bYK5
         wRShB9t37aWc8K6uBo+HDzBIu1UVijNd0k/r5bl5K/u/Pgkbuzw38ret1hrt91rSyq8c
         NQgB9a8ZK14HS9HDd3FSFf5KtZ6U+9cIQz7D3+5io8VJb8+/KeILv6sCg8RVvUF2k/Bs
         9G+w==
X-Gm-Message-State: AOAM531Rk16VEjALnooEpNM/cqgGYVMiJcfbl+PLyoU7txZL+Cjo9xyg
        mmNfmUeegLbI+RvyjuGQOXg=
X-Google-Smtp-Source: ABdhPJyHoPlHv2D4U6jfifzRErwvbcJHRRK4idYx+IiPISLEG7z6KKd8UIDsQ02S29N9d7Z7a3s/UA==
X-Received: by 2002:a17:90a:77ca:: with SMTP id e10mr2157509pjs.150.1597802436327;
        Tue, 18 Aug 2020 19:00:36 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:a28c:fdff:fee1:f370])
        by smtp.gmail.com with ESMTPSA id q6sm1120812pjr.20.2020.08.18.19.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 19:00:35 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH bpf-next] net-veth: add type safety to veth_xdp_to_ptr() and veth_ptr_to_xdp()
Date:   Tue, 18 Aug 2020 19:00:27 -0700
Message-Id: <20200819020027.4072288-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This reduces likelihood of incorrect use.

Test: builds
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 drivers/net/veth.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index e56cd562a664..b80cbffeb88e 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -234,14 +234,14 @@ static bool veth_is_xdp_frame(void *ptr)
 	return (unsigned long)ptr & VETH_XDP_FLAG;
 }
 
-static void *veth_ptr_to_xdp(void *ptr)
+static struct xdp_frame *veth_ptr_to_xdp(void *ptr)
 {
 	return (void *)((unsigned long)ptr & ~VETH_XDP_FLAG);
 }
 
-static void *veth_xdp_to_ptr(void *ptr)
+static void *veth_xdp_to_ptr(struct xdp_frame *xdp)
 {
-	return (void *)((unsigned long)ptr | VETH_XDP_FLAG);
+	return (void *)((unsigned long)xdp | VETH_XDP_FLAG);
 }
 
 static void veth_ptr_free(void *ptr)
-- 
2.28.0.220.ged08abb693-goog

