Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2D85437DB
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244777AbiFHPrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244783AbiFHPq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:46:56 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159E73BFA9
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 08:46:52 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so18663264pjq.2
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 08:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=isNEOexDaumJYfdbVbhqASaaLBLEiJ73yngrsc/JaoI=;
        b=etwohc2H+dgjMOyMwGS+B/hk3XaHrwx31AEKnEsPKrSsFBlBQ1UEBgBLRvMv5u5XbK
         EQqQHWPLLqZMZuPnjUhoukUOn5lnWKFDh11CE6d5K0eo33I4WMiQ169JBpRfJ0dROLQ+
         jJ3WKMhtUDkN0WVAjch64yYjt8soUC7LDUQyldaTA/vLXN/fykKP4mfI4SfxObRMXFQZ
         rCuBV3vA7nIKLmkXT0Vuj83+iIFrSPlQslTNKjRpJ1koW5bfVSRf0qq5t7z1X+qLz5UM
         uB9HY9U38mnlpu93plqQZAjoa0ph60nWqZ+tZtSc5MRVVNAnLzFnSupJvpFjXkJ/6btE
         srOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=isNEOexDaumJYfdbVbhqASaaLBLEiJ73yngrsc/JaoI=;
        b=GiLN1pNh/PMx1jA8FX6umT2wixnhTQqUz4LdEChfkFu5OPRXAySvtCywsYrJkjFCd0
         KiLLR56daZXs40hEi40+UvcS5rhMNzzLt0m34q0QLJGU9Us28gx5rKo6VBLxn+Hj4O2G
         9yrOI35lzWQleszK4fQ3fBGc9Pb2fj7nFfrDuiCdjpDbzgylbxwNZwsix0gSH264tUIg
         6TolR11OQx+PHWI52bq2PdvZBskVb0D5xS79PhikrHLf2LLXL0diJJwmGHmW94PEL2fD
         ILSFVwrMM9U2GA2U4XMd2uAfWwdRz/lQyh86YoRrug8T1CWpHym33yxxwh67skFGWXLn
         hNRw==
X-Gm-Message-State: AOAM532Lrn6ZikLRmrMxWJ8VtOnewZD+d96ezZ3tCOrACkET/PENb9fZ
        +QZ1mREo9btiEXjWcMR5854=
X-Google-Smtp-Source: ABdhPJwkXqwjryT8xwjOC5oqjSsZvVSrgyA+mj2WCXqtZp/AWfWNE4/EsqxVdn2gIkqAt58vmio5YA==
X-Received: by 2002:a17:903:41d1:b0:166:3c6:f055 with SMTP id u17-20020a17090341d100b0016603c6f055mr35011170ple.112.1654703211632;
        Wed, 08 Jun 2022 08:46:51 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id a10-20020a056a001d0a00b0051be2ae1fb5sm10885973pfx.61.2022.06.08.08.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 08:46:51 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v2 net-next 5/9] wireguard: receive: use dev_sw_netstats_rx_add()
Date:   Wed,  8 Jun 2022 08:46:36 -0700
Message-Id: <20220608154640.1235958-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220608154640.1235958-1-eric.dumazet@gmail.com>
References: <20220608154640.1235958-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We have a convenient helper, let's use it.
This will make the following patch easier to review and smaller.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/receive.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 7b8df406c7737398f0270361afcb196af4b6a76e..7135d51d2d872edb66c856379ce2923b214289e9 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -19,15 +19,8 @@
 /* Must be called with bh disabled. */
 static void update_rx_stats(struct wg_peer *peer, size_t len)
 {
-	struct pcpu_sw_netstats *tstats =
-		get_cpu_ptr(peer->device->dev->tstats);
-
-	u64_stats_update_begin(&tstats->syncp);
-	++tstats->rx_packets;
-	tstats->rx_bytes += len;
+	dev_sw_netstats_rx_add(peer->device->dev, len);
 	peer->rx_bytes += len;
-	u64_stats_update_end(&tstats->syncp);
-	put_cpu_ptr(tstats);
 }
 
 #define SKB_TYPE_LE32(skb) (((struct message_header *)(skb)->data)->type)
-- 
2.36.1.255.ge46751e96f-goog

