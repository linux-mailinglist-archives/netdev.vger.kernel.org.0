Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDF324921B
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgHSBH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbgHSBHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 21:07:24 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D82C061389;
        Tue, 18 Aug 2020 18:07:23 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mt12so334756pjb.4;
        Tue, 18 Aug 2020 18:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mzBSluQ6mqyIVMuRi2ojSGjM+D4X/wlWcsHhPwNSdIU=;
        b=StO/KDkryIDm355jHPzc2OJN+l25RHo2rsDNfvr+/2cPMEa9yrHeIOXAC0/BrW+Gmn
         vtf4riwT4cJDSaWR04ESXNad4C0nIfo/WXuwnqBXUXq0aTY65sE0EvErddFnBKLdckXG
         IvjishHENFX2YV0IBCZTo8mmrs4DAKTXmJPQ/NBNgXbN92h/+4T+ap2AtS7VqPJ/WLe3
         K+y8kOGCEI2cv5AUYy45j59jYZisoWL15ocDjQnfXzRK7lYRfY/WAMBov6Qzjc+qq5HC
         7/U9eTANzkKXcSvdX6VgOp23Vh/9+2vg7n0C0bus0HapepcXRPYkkRq1ZsAgv4ycfWQZ
         M6dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mzBSluQ6mqyIVMuRi2ojSGjM+D4X/wlWcsHhPwNSdIU=;
        b=e/m085B5QDzSxqB2HW9Q928SVSzjq6rnwmqa89J1xr87vyDPZcH8feNrfMlqJga/GG
         B5WcdGh5erT1hXWBCOarjhL9wd8ORgog76syCBX697TbI/VNVQyX9P00oqBgmTLllNCB
         pgCxYVTxjDOihbBliOMWBbxqlGjKLTyR2DD7X7cY2ZZdHSN1z+G4tGLrb+1hTXKKaSDZ
         0wWgb8OeWq5PVsd7glHOyQsMrQBgNh9YecH84+b/gFYqAQ3GmNiZ8Bv6dAmBWtryTNR8
         htiDyZ5RtaQGH1fO1UL66zqrZ7OEJzZ6KgPnOiBBhrRsRQKBHRoSgfd7+HfGYuJsviDt
         17kg==
X-Gm-Message-State: AOAM533E1BLA6gUJZ1XB9W67uwj204wM7KKpy9b9InEmFWOb7wNjinBJ
        xpKy/OClmRRPkS7tJ7l9yeI=
X-Google-Smtp-Source: ABdhPJwyvJ/T5PYNuVUQilWtQeYqkoX46QhAdfXd0VeN7ukEkYw/rlecjQttxxkbL99vUKhPMZiXIQ==
X-Received: by 2002:a17:902:7897:: with SMTP id q23mr17417597pll.310.1597799243274;
        Tue, 18 Aug 2020 18:07:23 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:a28c:fdff:fee1:f370])
        by smtp.gmail.com with ESMTPSA id 193sm25881853pfu.169.2020.08.18.18.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 18:07:22 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH bpf-next 2/2] net-tun: eliminate two tun/xdp related function calls from vhost-net
Date:   Tue, 18 Aug 2020 18:07:10 -0700
Message-Id: <20200819010710.3959310-2-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
In-Reply-To: <20200819010710.3959310-1-zenczykowski@gmail.com>
References: <20200819010710.3959310-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This provides a minor performance boost by virtue of inlining
instead of cross module function calls.

Test: builds
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 drivers/net/tun.c      | 18 ------------------
 include/linux/if_tun.h | 15 ++++++++++++---
 2 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 5dd7f353eeef..efaef83b8897 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -219,24 +219,6 @@ struct veth {
 	__be16 h_vlan_TCI;
 };
 
-bool tun_is_xdp_frame(void *ptr)
-{
-	return (unsigned long)ptr & TUN_XDP_FLAG;
-}
-EXPORT_SYMBOL(tun_is_xdp_frame);
-
-void *tun_xdp_to_ptr(struct xdp_frame *xdp)
-{
-	return (void *)((unsigned long)xdp | TUN_XDP_FLAG);
-}
-EXPORT_SYMBOL(tun_xdp_to_ptr);
-
-struct xdp_frame *tun_ptr_to_xdp(void *ptr)
-{
-	return (void *)((unsigned long)ptr & ~TUN_XDP_FLAG);
-}
-EXPORT_SYMBOL(tun_ptr_to_xdp);
-
 static int tun_napi_receive(struct napi_struct *napi, int budget)
 {
 	struct tun_file *tfile = container_of(napi, struct tun_file, napi);
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 6c37e1dbc5df..2a7660843444 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -27,9 +27,18 @@ struct tun_xdp_hdr {
 #if defined(CONFIG_TUN) || defined(CONFIG_TUN_MODULE)
 struct socket *tun_get_socket(struct file *);
 struct ptr_ring *tun_get_tx_ring(struct file *file);
-bool tun_is_xdp_frame(void *ptr);
-void *tun_xdp_to_ptr(struct xdp_frame *xdp);
-struct xdp_frame *tun_ptr_to_xdp(void *ptr);
+static inline bool tun_is_xdp_frame(void *ptr)
+{
+       return (unsigned long)ptr & TUN_XDP_FLAG;
+}
+static inline void *tun_xdp_to_ptr(struct xdp_frame *xdp)
+{
+       return (void *)((unsigned long)xdp | TUN_XDP_FLAG);
+}
+static inline struct xdp_frame *tun_ptr_to_xdp(void *ptr)
+{
+       return (void *)((unsigned long)ptr & ~TUN_XDP_FLAG);
+}
 void tun_ptr_free(void *ptr);
 #else
 #include <linux/err.h>
-- 
2.28.0.220.ged08abb693-goog

