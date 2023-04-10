Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F418F6DC6A8
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 14:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjDJMS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 08:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjDJMS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 08:18:56 -0400
Received: from mail-ej1-x661.google.com (mail-ej1-x661.google.com [IPv6:2a00:1450:4864:20::661])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD585245
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 05:18:55 -0700 (PDT)
Received: by mail-ej1-x661.google.com with SMTP id sg7so23480552ejc.9
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 05:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1681129134;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TKzhndpkxHQaGoJcxBtWzexess8OGVr/hjWI7n+mKCs=;
        b=DMtw1rNUdeK78HaJM++4Hxl3994D+oHO9KLUurJjVhK+mZdpXBESJ4Vw1DsJiOLJm9
         69fIUhi0t3HpjLxup9cpkmxAUXMrGtDnDuVlyuwk77v9leRxg48AZ6dSSYERd0T7qtIg
         gLgqoBDEQ9g2UlgsQHGxPfo8yAN6Kh26T4tSU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681129134;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TKzhndpkxHQaGoJcxBtWzexess8OGVr/hjWI7n+mKCs=;
        b=AQmS5x2qqC972cLh5O+vF4n7+db5UFcDold2I0ur503DIE95LAz0s5T2isbZM0AZcy
         9cYCBXujWIPsw1YCYh+9Bz8sUL4uDcFrc/18dCqBz6DxpUdKXHJT52EupaYs2NABtwmI
         O3YgGvJhDuL2P80vbpprPZq8W/5u2HgO//pvZ0KGFIdTt1ICygnwx/HoaxtTlto01Pzk
         HDv4DIbTkN5hFN260KTP4Ec0EzoUVi+bUhUsp5DTNqhWDNwWd8rtlz1G0Y3WMo8HTQHG
         qHm0xyoqhzQGUPisfNNoCG/GN3gXFCjaJseF/ztcqBieIUBZfPzV8NFEqKWb0f+2CGFC
         eD+g==
X-Gm-Message-State: AAQBX9c+oZC1CBKfC8sGoQj93tZfZEXP63pYbpaG0Qao9ZK7s/mzmnQH
        ea2JmTYV66qx0gxXoKCi9olzMUGbHczYGHR0oN5D5/qtx3w6
X-Google-Smtp-Source: AKy350ZkMU0s/JF20E6yb6mctLIlUuttVuOc3SupfDQb+GIrqy9L2A4xh5ef0Plqj6p/2e0odjDNgzNcscT8
X-Received: by 2002:a17:906:b041:b0:931:20fd:3d09 with SMTP id bj1-20020a170906b04100b0093120fd3d09mr7422636ejb.17.1681129134038;
        Mon, 10 Apr 2023 05:18:54 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id ga7-20020a1709070c0700b0094418efd9f7sm2115681ejc.288.2023.04.10.05.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 05:18:54 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next] xsk: Simplify xp_aligned_validate_desc implementation
Date:   Mon, 10 Apr 2023 14:18:41 +0200
Message-Id: <20230410121841.643254-1-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Perform the chunk boundary check like the page boundary check in
xp_desc_crosses_non_contig_pg(). This simplifies the implementation and
reduces the number of branches.

Signed-off-by: Kal Conley <kal.conley@dectris.com>
---
 net/xdp/xsk_queue.h | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index dea4f378327d..6d40a77fccbe 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -133,16 +133,12 @@ static inline bool xskq_cons_read_addr_unchecked(struct xsk_queue *q, u64 *addr)
 static inline bool xp_aligned_validate_desc(struct xsk_buff_pool *pool,
 					    struct xdp_desc *desc)
 {
-	u64 chunk, chunk_end;
+	u64 offset = desc->addr & (pool->chunk_size - 1);
 
-	chunk = xp_aligned_extract_addr(pool, desc->addr);
-	if (likely(desc->len)) {
-		chunk_end = xp_aligned_extract_addr(pool, desc->addr + desc->len - 1);
-		if (chunk != chunk_end)
-			return false;
-	}
+	if (offset + desc->len > pool->chunk_size)
+		return false;
 
-	if (chunk >= pool->addrs_cnt)
+	if (desc->addr >= pool->addrs_cnt)
 		return false;
 
 	if (desc->options)
-- 
2.39.2

