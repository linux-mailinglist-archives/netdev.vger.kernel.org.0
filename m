Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5B125DAA3
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 15:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730682AbgIDNzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 09:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730705AbgIDNy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 09:54:26 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4E5C061246;
        Fri,  4 Sep 2020 06:54:24 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k13so1172037plk.13;
        Fri, 04 Sep 2020 06:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ndlvsQFIeAXfc3bcbH6mbqQWsrzfWC6PhjjCGX9XLA8=;
        b=Edvfi7J9dq/mGVeTaUoSyXhsYATv0l+s2ALa97MuHv8o4cr4zqviEdBmBps0FWI+XC
         DnpzaaBRMb/pmRy9XntxBWagDNu+rKf8OXgltLwPK8S1Ye4vvu176e5ICCHhsg1HW8kR
         SC/khNiqpJTblNrrFCODwQmfhdklLZAVno2vEgO7eaLdOEZPWwlgg5iQLORKUipo/TzM
         IDrp6GMOmjd+ieuKLb7FyFr8Rv7a13+xQg4zvfmKNujpgionXQFFyn6wvRiwo0HAxzsE
         L/60XL562FzCK7CF7iLLG7oRN1PGfrhTEiDU2+mjhNmOB+zlBZty6TDk/nC8q7njJQgY
         GUCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ndlvsQFIeAXfc3bcbH6mbqQWsrzfWC6PhjjCGX9XLA8=;
        b=qBqi+ZLTi1ks8w6ivuJbMMktdNcF0LW5o0m9A4avqOvCnEa5iJgpZdSlYQn1e1ikbX
         ry8nErpXG8TJ2gR2ZYnDJP4/xEBAwdSlgLozQTs7kNGWPIMEpMkgvK/omckn9+Hg4Gel
         s5M98aAUZErkBubNw2xhSpL719D7qiHDFMvtEofwJS8laZ+9UEzsDPdt/ZRZ7KAdHFXX
         jDG7UWdxbavq+5Ye9P2+QnVkxcHxcrhRJrMbFxUA1IO8VCDAZDsAnWZZu34/SWemR3DJ
         235JywMx2BFMDrokrtoEmDyDknPT84y0Hct38SubyAO6J+K3rz98dDmlPi7WEYZnw0wY
         bQjg==
X-Gm-Message-State: AOAM533M7G3hiy7B4RksM1snElfyc/4ZEVLgZqXt09u1pIqY4qf8zibr
        eM8gJlc53SL3ij5Bllb2nxE=
X-Google-Smtp-Source: ABdhPJweTAGZ9F7Kn14qT3nNdQ72xvhDC1jpCcaeNMvBJHFxl/NA7IL76Ulfc8SEUIDLSb+nE6kthA==
X-Received: by 2002:a17:902:7607:: with SMTP id k7mr8577410pll.91.1599227664587;
        Fri, 04 Sep 2020 06:54:24 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id g9sm6931239pfr.172.2020.09.04.06.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 06:54:24 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 3/6] xsk: introduce xsk_do_redirect_rx_full() helper
Date:   Fri,  4 Sep 2020 15:53:28 +0200
Message-Id: <20200904135332.60259-4-bjorn.topel@gmail.com>
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

The xsk_do_redirect_rx_full() helper can be used to check if a failure
of xdp_do_redirect() was due to the AF_XDP socket had a full Rx ring.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xdp_sock_drv.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 5b1ee8a9976d..34c58b5fbc28 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -116,6 +116,11 @@ static inline void xsk_buff_raw_dma_sync_for_device(struct xsk_buff_pool *pool,
 	xp_dma_sync_for_device(pool, dma, size);
 }
 
+static inline bool xsk_do_redirect_rx_full(int err, enum bpf_map_type map_type)
+{
+	return err == -ENOBUFS && map_type == BPF_MAP_TYPE_XSKMAP;
+}
+
 #else
 
 static inline void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries)
@@ -235,6 +240,10 @@ static inline void xsk_buff_raw_dma_sync_for_device(struct xsk_buff_pool *pool,
 {
 }
 
+static inline bool xsk_do_redirect_rx_full(int err, enum bpf_map_type map_type)
+{
+	return false;
+}
 #endif /* CONFIG_XDP_SOCKETS */
 
 #endif /* _LINUX_XDP_SOCK_DRV_H */
-- 
2.25.1

