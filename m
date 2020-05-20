Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7402B1DAF2D
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 11:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgETJsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 05:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgETJsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 05:48:11 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA121C061A0E;
        Wed, 20 May 2020 02:48:11 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id k7so983761pjs.5;
        Wed, 20 May 2020 02:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l+ZitJMelLTFgi5ias/6H8gqKi08+ZfSOF9+XZodPuU=;
        b=urOGjHEvvfDZOMfxGGsVn77xLW488fkDDB3YxNx8S+0fKwTnSVxbZJPoN/SDeqrUsv
         wxYrRlx4xUTAjxsAIsf+p+9sVXGgvNargtnvhaxBOcGJkqLSoeOjl6D1jOVS9a6OBRfk
         yJDLEe/2mic9G6ufwKfNpdgFkn0GRe2PcuHidVNid7iPqUms3tkdBYNJ5vzvO6IZURs3
         HKIZgGwMjBhluf5nCEiHyWnvN3T5x657THjOM2KAZoO3udtnf40umD360BUNqPy9D7uV
         ITQb2YSwwVgwGJyQtr+La6SJJouagY5ObCAZMQ2uzwLo6MVNAe4gTS4b0XW0ZlQ1RsD1
         DPQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l+ZitJMelLTFgi5ias/6H8gqKi08+ZfSOF9+XZodPuU=;
        b=gpKYZDJT+knK0SdvJH4r0x6EJP+zANot9uv8N7qwuG4QLY+MLrYh71k62CBe0GnqKe
         gd1aPolnc0tkcc5FoOVI445kO8shtkE7vLU/LWJ+79DTs8xT3tWkeGoZqSAP5eBakwiP
         ns08+3fuyYTFpOeVtgns45PQWr5TMNVRVO6foZ/Y1vWLOfdZB3E5fbfkI0B+HqKbXJbP
         l/DFlRakAoMsgqXdIlUPvCgw7xHRLraKdzr41CPUJV3LhMj2MpPfPvXJdRJqpP9lvnUg
         +g+G6w0awsYJbXXE0A33SIn9BqqoFIB6Zw/Ne0/Y72Vpg+fvQVX2tU1E7vNn7y19IsOX
         PqsA==
X-Gm-Message-State: AOAM533kjn+szNGlUAdFNZEXJx1VjAYCMecPTTnadk3Q1Eo0Q4GhmWBS
        AGOK96+bY4dpF369XJiUSqc=
X-Google-Smtp-Source: ABdhPJwabysdCgw+AzUrJjDr+9z0fE/0kybJF2G78DTPj9eNoUOz9qsxre0XkLPiLBQlCT3nM06WCg==
X-Received: by 2002:a17:90a:e016:: with SMTP id u22mr4447313pjy.28.1589968091376;
        Wed, 20 May 2020 02:48:11 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id c124sm1707494pfb.187.2020.05.20.02.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 02:48:10 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [PATCH bpf-next v4 01/15] xsk: fix xsk_umem_xdp_frame_sz()
Date:   Wed, 20 May 2020 11:47:28 +0200
Message-Id: <20200520094742.337678-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200520094742.337678-1-bjorn.topel@gmail.com>
References: <20200520094742.337678-1-bjorn.topel@gmail.com>
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

