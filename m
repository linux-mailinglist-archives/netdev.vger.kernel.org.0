Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0701DBDCB
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 21:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgETTVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 15:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgETTVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 15:21:22 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BD6C061A0E;
        Wed, 20 May 2020 12:21:22 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id a13so1744298pls.8;
        Wed, 20 May 2020 12:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l+ZitJMelLTFgi5ias/6H8gqKi08+ZfSOF9+XZodPuU=;
        b=ZdA4LlDgUHVtwhZZgXQ5m7TygnrD35L/BEda6rqVXiOKOK2/8Le1bw3igGk6vIbu6o
         KN3zDi9cSAlpVfCdIp8DiIFBKJHefdioK8do+zqXzk/9fyYHYQnFCJp/GU/VozWYD3h3
         6hF637gza/GTK1/K+fmIRbAYYDLBvSe07YtQ8PP7WR/ErKvWIcB0i0aUgp8WHtaeyRli
         yxibsy31UrA74fEaCdquEWZc0z5yAoMQFrCqo0vE6lrXmLI7B9N3a4mj+pfkBtrVuDfb
         ZNeWHfsU6yO6SzNltZ9BMmTEYjRyRJM3nCqQQ9GyjUBaKTeBp2CD4IjL8iejzLmoKSUv
         9Icg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l+ZitJMelLTFgi5ias/6H8gqKi08+ZfSOF9+XZodPuU=;
        b=i4+ThEtoSw71ULyIJUiuxxa/pDkEDjElXvX27lT1nXLNbWEnSyIcYSlKgjJxY26FeR
         JZW47T7NG7ptJntvDUjKzC7Gc1+sVpy5lmEtITH6sfA+KUF4+EnePOz+mk1q9qq2HE9T
         h8HIgiOuEW9jmGHlj9quzlXqsUnVaAVlqWpPNzFTjgM8td5ymNFErSBjhemOZH+DIQub
         YpQ3NBRjDIRSffv9QW92KHt3oJoX2Hw22rKMjNRpIm6G8lFuKl/dgVA6dJY+CDrZXhDh
         Dp8+C+KA0ueTtRQyHc1O6mkuE5i11GXmT9kJ0yBr3vbU9CYdLogvNz2aMYNXeumzmrpp
         7U9A==
X-Gm-Message-State: AOAM533XA69ND/4Mvgr6RCFPBVUQ39+jMq8MIybpLeFhtCQMFAyFvb6B
        wRaONhXjLOGcid+B1DBqiR8=
X-Google-Smtp-Source: ABdhPJx0bGMp8Tb9Ih5zXgtUX5nnU5iZwsFJ9lZx6rTZX5sDCDao9GcckvMe2YDtIfhACtbE+Ln/bw==
X-Received: by 2002:a17:90a:68cd:: with SMTP id q13mr6981865pjj.177.1590002482259;
        Wed, 20 May 2020 12:21:22 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id 62sm2762424pfc.204.2020.05.20.12.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 12:21:21 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [PATCH bpf-next v5 01/15] xsk: fix xsk_umem_xdp_frame_sz()
Date:   Wed, 20 May 2020 21:20:49 +0200
Message-Id: <20200520192103.355233-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200520192103.355233-1-bjorn.topel@gmail.com>
References: <20200520192103.355233-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Calculating the "data_hard_end" for an XDP buffer coming from AF_XDP
zero-copy mode, the return value of xsk_umem_xdp_frame_sz() is added
to "data_hard_start".

Currently, the chunk size of the UMEM is returned by
xsk_umem_xdp_frame_sz(). This is not correct, if the fixed UMEM
headroom is non-zero. Fix this by returning the chunk_size without the
UMEM headroom.

Fixes: 2a637c5b1aaf ("xdp: For Intel AF_XDP drivers add XDP frame_sz")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xdp_sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index abd72de25fa4..6b1137ce1692 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -239,7 +239,7 @@ static inline u64 xsk_umem_adjust_offset(struct xdp_umem *umem, u64 address,
 
 static inline u32 xsk_umem_xdp_frame_sz(struct xdp_umem *umem)
 {
-	return umem->chunk_size_nohr + umem->headroom;
+	return umem->chunk_size_nohr;
 }
 
 #else
-- 
2.25.1

