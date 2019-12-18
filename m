Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36E2D124528
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbfLRKym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:54:42 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46751 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbfLRKym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:54:42 -0500
Received: by mail-pf1-f195.google.com with SMTP id y14so983320pfm.13;
        Wed, 18 Dec 2019 02:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nOoyfv29tdJB4Cs2FbUE63tPrsUbwCLUOgeYj7AkNpw=;
        b=sXxYQ7OFkbeLBwrv7XlGtpc7WKBBp/am6dU7zwMn2JLT+DNeyeVLLyGWS5n9tnZBVH
         s7CLWdnr2Wsv7n+vNB9r78jCR/88fUeb15dSlznMWHDfZV4T5mEeI+YmLSMCeDfZzcjZ
         tKGw4+fgkuH6AZeQgHuDMdPZ/aMD9Uf4pZBJWzvZ59qTALg1ObDYMzT8qIMi4FJOgja2
         TRz/B26E9vHcekNxEKwvXP7+H+sF75om0nlkOSxzZAbwZ8TSSGLErRDZG2XmKRoDdU9T
         LKROOBFO5eSZ/aeSdtn/7rgn12AnnQNJoFtGSXJS9FIyN+AU1zcJ5Cz0j5pEj+8g6txR
         zdPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nOoyfv29tdJB4Cs2FbUE63tPrsUbwCLUOgeYj7AkNpw=;
        b=j7Y8SApdMwrwrtGZPj4qcsmen0UyLHNmWH1UjbO4QerWkGOUYAfUJoNnrdtsy3ehrQ
         xjBS9UMtv9QhavIHbEfUtFOqDEdCXG9xIQYcfm44acqIsJRceG5c8LixiRcjN5uRgxGr
         GsltyFo9RfCVVAJd0OAWVqwf3iatSLsOK+s8kSMFQ9G5uTecS1m1F2KOH8Y5SqZwunqp
         KeTBfitcJLcxYHTirmVugU1OlELMsGVqHhC/8ocoOdrVmCVCZc3mDG3PaSUHaYA5ZG0N
         lWdKnpN8i1cYa8bn8l1ChuWU5KQ6SSL0MjQfBcImsioIIoqb6s7ZhnL+b1kgqxK1/l05
         ruhg==
X-Gm-Message-State: APjAAAUftpRJMkTduwIakQuekn+c3xC+zF8tCKYvxP07TjdRFrRI60HY
        hVthiJi6A5g657aeMbTJoZOTNm/WEFKEsw==
X-Google-Smtp-Source: APXvYqz5AWUhF8otd0DX09ERUQqvzpklTKXj3rtZoEZowWQjaT1ZIYXzww66RXXMUIVJK9TQ9Qktlw==
X-Received: by 2002:a63:5062:: with SMTP id q34mr2311286pgl.378.1576666481581;
        Wed, 18 Dec 2019 02:54:41 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id k9sm2339000pje.26.2019.12.18.02.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 02:54:41 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 8/8] xdp: simplify __bpf_tx_xdp_map()
Date:   Wed, 18 Dec 2019 11:54:00 +0100
Message-Id: <20191218105400.2895-9-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191218105400.2895-1-bjorn.topel@gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The explicit error checking is not needed. Simply return the error
instead.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/core/filter.c | 33 +++++++--------------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index d9caa3e57ea1..217af9974c86 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3510,35 +3510,16 @@ xdp_do_redirect_slow(struct net_device *dev, struct xdp_buff *xdp,
 }
 
 static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
-			    struct bpf_map *map,
-			    struct xdp_buff *xdp)
+			    struct bpf_map *map, struct xdp_buff *xdp)
 {
-	int err;
-
 	switch (map->map_type) {
 	case BPF_MAP_TYPE_DEVMAP:
-	case BPF_MAP_TYPE_DEVMAP_HASH: {
-		struct bpf_dtab_netdev *dst = fwd;
-
-		err = dev_map_enqueue(dst, xdp, dev_rx);
-		if (unlikely(err))
-			return err;
-		break;
-	}
-	case BPF_MAP_TYPE_CPUMAP: {
-		struct bpf_cpu_map_entry *rcpu = fwd;
-
-		err = cpu_map_enqueue(rcpu, xdp, dev_rx);
-		if (unlikely(err))
-			return err;
-		break;
-	}
-	case BPF_MAP_TYPE_XSKMAP: {
-		struct xdp_sock *xs = fwd;
-
-		err = __xsk_map_redirect(xs, xdp);
-		return err;
-	}
+	case BPF_MAP_TYPE_DEVMAP_HASH:
+		return dev_map_enqueue(fwd, xdp, dev_rx);
+	case BPF_MAP_TYPE_CPUMAP:
+		return cpu_map_enqueue(fwd, xdp, dev_rx);
+	case BPF_MAP_TYPE_XSKMAP:
+		return __xsk_map_redirect(fwd, xdp);
 	default:
 		break;
 	}
-- 
2.20.1

