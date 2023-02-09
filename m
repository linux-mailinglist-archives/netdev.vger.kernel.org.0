Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82C76908A4
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 13:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjBIM02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 07:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjBIM01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 07:26:27 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAEB1CACA
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 04:26:25 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id da9so1915299edb.12
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 04:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5YFGvWHONsZaq676i+5BQUR6fT+K1OZMUM624Of9vyY=;
        b=pn/bWfmDky37Tek+LVpF3BQm5uYd+ZMYBSTu7gxAOQHKC+48qei0gojpXl6X0visn3
         rseGDFiMVjV5HYJ2ncTVUrYkiuMn15RFkqzzEw9bgLbl6txVoE15muyMMXr5j4wK2oWP
         DrKqyortHFQqxwURAD5JAU8zwigRmHJu3NyLo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5YFGvWHONsZaq676i+5BQUR6fT+K1OZMUM624Of9vyY=;
        b=5ZdIz4XXmktI7vEkBaINU/hzffEYfVVx3JIz+0QKyfzqccnoxuuzWqjD4c/VpF5M39
         shIM/qiQNM7TjlZj9zW8U8B5no6uP/FimctsLNTwbzmwR1S9RhqthQq2xyi2esJJFSNg
         rmFXHVftJOJuFGFko2QVhj+qfr1s60cIl3ilCwZY/y8MtB1w/7x/OEO2W0yKnaIzck0J
         VACeQM26r68692LwAjztmnksoJ7ZYZIBmk38KaT0Khs6KXSnVFjpiYahT+SgUlQgheq8
         eEAGM9/8v1TItrcunhnbQpG8VmXHlaiIsAJKVmJk4/yLfFJGv8S34/uZ/+DyHBeRKw/h
         2hgA==
X-Gm-Message-State: AO0yUKVZBi4RpeE855/GteD4EHNljVWtKhVBLDMKMXA/0XK4LX3PnYJR
        Nlcg/d3/xjRU4HpOeMi/4GAm+w==
X-Google-Smtp-Source: AK7set/ru8CUI8c6WpTA2FeFNHdHENt9JS4H+RebLU17rNnUCdDG5WDW1tuUdlAeWsMkdKQJtcqEew==
X-Received: by 2002:a50:ce4d:0:b0:4ab:ed5:dd46 with SMTP id k13-20020a50ce4d000000b004ab0ed5dd46mr5558221edj.6.1675945584370;
        Thu, 09 Feb 2023 04:26:24 -0800 (PST)
Received: from [192.168.17.2] (wolkje-127.labs.vu.nl. [130.37.198.127])
        by smtp.gmail.com with ESMTPSA id la12-20020a170907780c00b008a7936de7b4sm802264ejc.119.2023.02.09.04.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 04:26:24 -0800 (PST)
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Date:   Thu, 09 Feb 2023 12:26:23 +0000
Subject: [PATCH net-next] rds: rds_rm_zerocopy_callback() correct order for
 list_add_tail()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230209-rds-list-add-tail-v1-1-5f928eb81713@diag.uniroma1.it>
X-B4-Tracking: v=1; b=H4sIAG7m5GMC/x2NSQrDMAwAvxJ0rsB2CV2+UnqQI6URpG6RTAiE/
 L1Oj8MwzAYupuJw7zYwWdT1UxrEUwfDROUlqNwYUkjnkMINjR1n9YrEjJV0xhivHPpLjn0eoXW
 ZXDAblWE6yjd5FTvE12TU9T97QJGKRdYKz33/AUPd74OGAAAA
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Sowmini Varadhan <sowmini.varadhan@oracle.com>
Cc:     Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        Pietro Borrello <borrello@diag.uniroma1.it>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1675945583; l=1189;
 i=borrello@diag.uniroma1.it; s=20221223; h=from:subject:message-id;
 bh=1+oqBi1a+MGySfKXgQ/C9VVxNB2UcZkL12bRQa+5lhw=;
 b=z6C7Q3vCOIgmEb64xOGg1+IsHU2oCBwRfxtKTmN1eR6g2EzJ4zyCQVReXbLwTOxWSJkgxTfDoNyM
 6uuO8YZ7AtOdC3mPdar3mFuKm7lbppaa9vjdBBhaSVhuAdYsHesW
X-Developer-Key: i=borrello@diag.uniroma1.it; a=ed25519;
 pk=4xRQbiJKehl7dFvrG33o2HpveMrwQiUPKtIlObzKmdY=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rds_rm_zerocopy_callback() uses list_add_tail() with swapped
arguments. This links the list head with the new entry, losing
the references to the remaining part of the list.

Fixes: 9426bbc6de99 ("rds: use list structure to track information for zerocopy completion notification")
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
---
 net/rds/message.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index b47e4f0a1639..ff10efa51632 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -118,7 +118,7 @@ static void rds_rm_zerocopy_callback(struct rds_sock *rs,
 	ck = &info->zcookies;
 	memset(ck, 0, sizeof(*ck));
 	WARN_ON(!rds_zcookie_add(info, cookie));
-	list_add_tail(&q->zcookie_head, &info->rs_zcookie_next);
+	list_add_tail(&info->rs_zcookie_next, &q->zcookie_head);
 
 	spin_unlock_irqrestore(&q->lock, flags);
 	/* caller invokes rds_wake_sk_sleep() */

---
base-commit: 4ec5183ec48656cec489c49f989c508b68b518e3
change-id: 20230209-rds-list-add-tail-118d057b15bf

Best regards,
-- 
Pietro Borrello <borrello@diag.uniroma1.it>

