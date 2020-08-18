Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0652480D6
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 10:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHRIjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 04:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbgHRIju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 04:39:50 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE052C061389;
        Tue, 18 Aug 2020 01:39:49 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g33so9438075pgb.4;
        Tue, 18 Aug 2020 01:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Szr8EtqoKxD74yWqDOQxAcPs9ZeTVxiab5ueq4OGU6Y=;
        b=AGKLBpd6DiQ8ArmgM6O0SiIELJCQXN39GPHLvgq5Eua+gNyoIxfdDozdlsLkxCSObK
         TbHTWlFEjTqGj3i/1+ZYL/jl0D76vPrLZ5TQcXd7AXf+Ib9Jy7MZ+G2xrmavJ88Tk6oo
         JIgkv7Pg7B4a2VsWTCGyz7+X0cAsvW4YY1loQv/JjgvfKsPduBVnv2NZxemYZCC01UB2
         ctsxCK/UhAVn1r6OqETC6RavC4ObCuqUTxdOO2gicsnvLMdH4qyr1Ut6WJ7tM7l24vrO
         kg9BLjzo18CA7PI/cM9eMVsePRTbaieKu8dvx8GezWFqbZTpgJYUB4ci9dxvlGUz4bQL
         LdOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Szr8EtqoKxD74yWqDOQxAcPs9ZeTVxiab5ueq4OGU6Y=;
        b=I8gOwgwUTI8GvgEHwv9gBUCjNDqAQYksVrlXi1WGL1SRldxnnjsDLKjU6SLlQdLxWe
         tKfxnSP7kvuFGBLyZFZ7LXKabeLQyyzwqPEtfDIIfNHK7jIbWDQTT8X08BC+n1wU934I
         DHQgnHaf+EtXLA1FS4lmJD2ptg9SNNCY2B3j6Hzq0NSGl2DUfdAx2kp9kpA/Hl3UtpHx
         SAWfnP/NY0rfmXJih4/4l8s8hIlS/rsYDXaja91RVyomEU3fmzrKtbTjOpRLHnGA93N4
         VlCEUT9eRhkOeFUjzAakNFkruD3IuX4EiEM8sW3q6RXykPRCd4LHkS/PL0BqDjpdpxzj
         gBsw==
X-Gm-Message-State: AOAM531fRV7LWTLesM+qpuAmXs0AMU6ur7XDl6hPkIOBHq9vIduzQGhX
        dzCNebEgPmBnSl617gpxGhs=
X-Google-Smtp-Source: ABdhPJwkRn/N1ZR7JCMW4jGtx7JECzhM8a4y5dAhPYYRchM61PQz6fLv3CLF2MYXPqo0ryy1GUkPLQ==
X-Received: by 2002:a63:5049:: with SMTP id q9mr12977345pgl.219.1597739989272;
        Tue, 18 Aug 2020 01:39:49 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:a28c:fdff:fee1:f370])
        by smtp.gmail.com with ESMTPSA id na16sm20867317pjb.30.2020.08.18.01.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 01:39:48 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH bpf] net-tun: add type safety to tun_xdp_to_ptr() and tun_ptr_to_xdp()
Date:   Tue, 18 Aug 2020 01:39:39 -0700
Message-Id: <20200818083939.3592763-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Test: builds
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 drivers/net/tun.c      | 6 +++---
 include/linux/if_tun.h | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3c11a77f5709..5dd7f353eeef 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -225,13 +225,13 @@ bool tun_is_xdp_frame(void *ptr)
 }
 EXPORT_SYMBOL(tun_is_xdp_frame);
 
-void *tun_xdp_to_ptr(void *ptr)
+void *tun_xdp_to_ptr(struct xdp_frame *xdp)
 {
-	return (void *)((unsigned long)ptr | TUN_XDP_FLAG);
+	return (void *)((unsigned long)xdp | TUN_XDP_FLAG);
 }
 EXPORT_SYMBOL(tun_xdp_to_ptr);
 
-void *tun_ptr_to_xdp(void *ptr)
+struct xdp_frame *tun_ptr_to_xdp(void *ptr)
 {
 	return (void *)((unsigned long)ptr & ~TUN_XDP_FLAG);
 }
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 5bda8cf457b6..6c37e1dbc5df 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -28,8 +28,8 @@ struct tun_xdp_hdr {
 struct socket *tun_get_socket(struct file *);
 struct ptr_ring *tun_get_tx_ring(struct file *file);
 bool tun_is_xdp_frame(void *ptr);
-void *tun_xdp_to_ptr(void *ptr);
-void *tun_ptr_to_xdp(void *ptr);
+void *tun_xdp_to_ptr(struct xdp_frame *xdp);
+struct xdp_frame *tun_ptr_to_xdp(void *ptr);
 void tun_ptr_free(void *ptr);
 #else
 #include <linux/err.h>
@@ -48,11 +48,11 @@ static inline bool tun_is_xdp_frame(void *ptr)
 {
 	return false;
 }
-static inline void *tun_xdp_to_ptr(void *ptr)
+static inline void *tun_xdp_to_ptr(struct xdp_frame *xdp)
 {
 	return NULL;
 }
-static inline void *tun_ptr_to_xdp(void *ptr)
+static inline struct xdp_frame *tun_ptr_to_xdp(void *ptr)
 {
 	return NULL;
 }
-- 
2.28.0.220.ged08abb693-goog

