Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE07147406F
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 11:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbhLNK1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 05:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbhLNK1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 05:27:04 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA1F7C061574;
        Tue, 14 Dec 2021 02:27:03 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id a9so31531797wrr.8;
        Tue, 14 Dec 2021 02:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TMyGa1ZURjU4WC46Rk0LZynE/EHJadQsWtw3kSUAXB8=;
        b=L+hUiq55QFzpZ7byn3M6JwQEpNCuZxUyywcuLHq5vDRok8DY6a7NwNQvJZnMm2jfzv
         c8aDogvddjUy6/c4i1d57I6NGNemEy+4rp6hgQz7ZQONxKGogxyKP8rv8cLU2YR3hDUl
         G5QzHy+ZO+M/J75ZjzkKBV+HNb3A1rGOgiFXBgX3Wn7+dM5dcd7BJcNwVehuNDwxWe2o
         xAm/K9H7maFYteCV9H+3NYZtOkfR5Yp4M3oZ9Y70k2OIw5hKDoc/ABRoopDvqaEYICcE
         baJNnj3bFEIBDnYhx0JYz+VwBQoEQUiqQ0cs/pv5cBYJ/9ScHQpGqXxhRp3aqHFnDb/q
         /WzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TMyGa1ZURjU4WC46Rk0LZynE/EHJadQsWtw3kSUAXB8=;
        b=EznWvSwtci2mjuIffax5t2pCA3FVUZU0H1LE+HdOh40IIw+7/AK7+Fam9G56t9qANw
         glAgmWD3vBoz+Nw4IJo/bTSOxtHb7N37pjE04FSZM7rlR/cP8rxJK24tPGQQnMFfk04/
         cefHe2xFfDj+42gH6I3gGIyH7hh68mhe3fBwBVQDiPUCxQ/YuOoTM1Zai9bDv6mz95vA
         fWRXoeYvEn42tQ/dlxoLIvimEKHebUII4Bk++wFzjVxzMbeQIVqgkVNoRuoR78TCkkj7
         C310MSHiAnqyxaWRTmgW+A8cUfBKCrXkIbv+gS5jIkXyiZzUxgWmL2RaMjPcTHUrNS+j
         /7jg==
X-Gm-Message-State: AOAM532iIt8bnFiJkcCukVvAqTytE8jTHDJO97Sf+7DzW6n1Eb0wxu4N
        cPc2NXuYRAbBFqORA0l+LIo=
X-Google-Smtp-Source: ABdhPJwcUZxZEEScQtU2ozI8WKoVZdULNqWWZF7QIdj/paQhu59VlIjO3ncylyfaQZIFN9AyAv9Njg==
X-Received: by 2002:a5d:4d8b:: with SMTP id b11mr4911663wru.393.1639477622459;
        Tue, 14 Dec 2021 02:27:02 -0800 (PST)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id z8sm15566276wrh.54.2021.12.14.02.27.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Dec 2021 02:27:01 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next] xsk: add test for tx_writeable to batched path
Date:   Tue, 14 Dec 2021 11:26:47 +0100
Message-Id: <20211214102647.7734-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add a test for the tx_writeable condition to the batched Tx processing
path. This test is in the skb and non-batched code paths but not in the
batched code path. So add it there. This test makes sure that a
process is not woken up until there are a sufficiently large number of
free entries in the Tx ring. Currently, any driver using the batched
interface will be woken up even if there is only one free entry,
impacting performance negatively.

Fixes: 3413f04141aa ("xsk: Change the tx writeable condition")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 28ef3f4465ae..3772fcaa76ed 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -392,7 +392,8 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *
 
 	xskq_cons_release_n(xs->tx, nb_pkts);
 	__xskq_cons_release(xs->tx);
-	xs->sk.sk_write_space(&xs->sk);
+	if (xsk_tx_writeable(xs))
+		xs->sk.sk_write_space(&xs->sk);
 
 out:
 	rcu_read_unlock();

base-commit: d27a662290963a1cde26cdfdbac71a546c06e94a
-- 
2.29.0

