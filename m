Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C000A33B07
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfFCWSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:18:08 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:32774 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbfFCWSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:18:05 -0400
Received: by mail-qt1-f196.google.com with SMTP id 14so11497015qtf.0
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 15:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3d048mVOeDrPtF1eB2oDurMhRktHjnqmEuxlJhCc1Kc=;
        b=Vapekh6uMXZuPoL9yaGmvmaiMyMJE7vBGmgFesXnvjfKf6ap8TSb3BpI6fey8B39Dw
         zm0pLhGDEaNUnLbtR9sKUr9+1+Inawergk4gv+FaJk21Jr9PT+7F6IER8vamWrEBPKz1
         0S1GfksA2vy+Q9uQ21BspMhb+1EX47sHYtjZAKtEhSJo3Y+RUfwpHXjJntJUzBBibBJc
         LCqXZLERDKnkX01cCpvyfDhg+TshxN9ZqSnbvXOhSsofJoCBtGaBCiWi1zEY5XkxfZc8
         LYsRThua6o94YBP07Be7lm91cfN3s4vMHNBDSP+HBo1fxKGG948mF8ZN0Q3IfKTa+U0K
         F7gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3d048mVOeDrPtF1eB2oDurMhRktHjnqmEuxlJhCc1Kc=;
        b=O5Wzycv+nvfJvSMDovnlVoNB3jlGb4xbB0Yo2BIMHN/dkxcPKhFjgORBscsL12beQp
         mEFJPGrxr07GZ41kgydpJF0/nwYb1R5EmwsdZdMYj4BvLhLpLc40hp0XZjJzLGmP+SL9
         HrIL2+lmtaYoFwNTrExsdsnBhKFVzymDLsOyNT2WQWJ4xiu9QGOjwOgNBMyRmzkCytX5
         Bws7KbXTwEyYx+ZnfN6bzcqNhZWB4KgzRMrhF1WATdkqG4fRcvtxcoTQcKha932jsM4x
         DqRKo6AgPVEIEKCV+tXTNWJfbtLOIplAYwgXv17/oY5mOu9nhwm82QWcwGbXKVkuJSFs
         /HlQ==
X-Gm-Message-State: APjAAAXGxZnSQLXLaIqv2oB7N6iP7cW9H11Emn4/RplrYTeuV+ybEFb/
        bgp6OhU6ctWVLMdLpTsM88JAJX8P0Ns=
X-Google-Smtp-Source: APXvYqwN22d/uRax1SmMm1n++3y6iLt31smWDw9qXwOu2eaQhmjrqE7RlStWuDfaojpHgG0sp1AfTw==
X-Received: by 2002:ad4:5345:: with SMTP id v5mr12031925qvs.103.1559600284616;
        Mon, 03 Jun 2019 15:18:04 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m4sm4332391qka.70.2019.06.03.15.18.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 15:18:04 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 6/8] net/tls: use version from prot
Date:   Mon,  3 Jun 2019 15:17:03 -0700
Message-Id: <20190603221705.12602-7-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603221705.12602-1-jakub.kicinski@netronome.com>
References: <20190603221705.12602-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ctx->prot holds the same information as per-direction contexts.
Almost all code gets TLS version from this structure, convert
the last two stragglers, this way we can improve the cache
utilization by moving the per-direction data into cold cache lines.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index bb9d229832cc..8ffc8f95f55f 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -252,7 +252,7 @@ static int tls_push_record(struct sock *sk,
 			 skb_frag_address(frag),
 			 record->len - prot->prepend_size,
 			 record_type,
-			 ctx->crypto_send.info.version);
+			 prot->version);
 
 	/* HW doesn't care about the data in the tag, because it fills it. */
 	dummy_tag_frag.page = skb_frag_page(frag);
@@ -264,7 +264,7 @@ static int tls_push_record(struct sock *sk,
 	list_add_tail(&record->list, &offload_ctx->records_list);
 	spin_unlock_irq(&offload_ctx->lock);
 	offload_ctx->open_record = NULL;
-	tls_advance_record_sn(sk, &ctx->tx, ctx->crypto_send.info.version);
+	tls_advance_record_sn(sk, &ctx->tx, prot->version);
 
 	for (i = 0; i < record->num_frags; i++) {
 		frag = &record->frags[i];
-- 
2.21.0

