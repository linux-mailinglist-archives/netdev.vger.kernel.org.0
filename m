Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9C55AA93C
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 09:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235572AbiIBH5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 03:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235570AbiIBH5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 03:57:39 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B704B99FF;
        Fri,  2 Sep 2022 00:57:38 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id f12so1078000plb.11;
        Fri, 02 Sep 2022 00:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=vIy9hDwkx4yZn4J8a69vMd0+2priltLA6LrvRstnlSw=;
        b=fpA4Y3ToNbXxHsdaEE0lX/1oD4nWABvDQl4PNC1J/7Ck4uuwpYzTTHBHaOuIiom1ew
         6nsaohKhgJpMhiBruxbK7FzsuYWlvgLMtlULpP7TvgTqzSkKpSX5BS1eoSHAAxhcjP+Q
         ny1m+i5dzAv+nfzb/zIJIvQSx4/zH1ztjaW91DI3SzHe2bTy9s7yIwoUh5NdpohJ+uvd
         8XRuTlwakpDT8jQefggv19R/6MYevAa98mAlPvCXyHXgdqAijutgb3hETd2Ah5hCH5zt
         T34chFMsoHY8y4cV8BIzm2Yg24A5TYjKsbmGBXA0SULu5CNAVIIyWsoX7inyug/pVzlL
         zWtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=vIy9hDwkx4yZn4J8a69vMd0+2priltLA6LrvRstnlSw=;
        b=anJ2Crh0EAeUiL0m+P89sdlbEWRcS+/KiB2waiIXzXYxfTiQp+LiHokySAXo9HcfH/
         Ty1tNqF6M8GmICR3lqj5Bv3IxokREpjkpzzU8/fKXFqBCa5E3ArkpB0hIyQ41fWgRpWo
         nsfHyCaFOTdfjwU4jykA8wiqJ4gX0duX8SwMj/ngD+p3hS/Hmi1CqI8ROR8vOt6Dh989
         uSF/014l9JorvtHDyeakwuECb2gko47r90Hh9x3b572G1h6oauXcTGNb7+F08XcpXMB2
         gzGfMECefLbmTOBAl5ZuDhJJbr0FKhSsXgbA9MVvSSJIZaaKe7HAeMU+S9jqIrc0SWxA
         JSbg==
X-Gm-Message-State: ACgBeo1TSJcysRGbMY+koXOkQoNmwy2WwBXwYYgCpEnMn+3AOWSOBALr
        C+9S0euLIlFvpuSS6MYDdLY3nkgy0VmyFQ==
X-Google-Smtp-Source: AA6agR5UAq2hV61FB3FoMipbuvEVVIYjmubJuI4EbaRWyxqf2LPOGobOPPaHb1QY9ryGj21rLTHeBQ==
X-Received: by 2002:a17:90b:4a82:b0:1f5:5eaa:68a with SMTP id lp2-20020a17090b4a8200b001f55eaa068amr3422244pjb.13.1662105457472;
        Fri, 02 Sep 2022 00:57:37 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id q96-20020a17090a17e900b001fd6460c2dcsm4519455pja.44.2022.09.02.00.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 00:57:36 -0700 (PDT)
From:   Li Zhong <floridsleeves@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lily <floridsleeves@gmail.com>
Subject: [PATCH v1] net/mac80211/agg-tx: check the return value of rcu_dereference_protected_tid_tx()
Date:   Fri,  2 Sep 2022 00:57:25 -0700
Message-Id: <20220902075725.2214351-1-floridsleeves@gmail.com>
X-Mailer: git-send-email 2.25.1
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

From: lily <floridsleeves@gmail.com>

Check the return value of rcu_dereference_protected_tid_tx(), which
could be NULL and result in null pointer dereference if not checked.

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
---
 net/mac80211/agg-tx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 07c892aa8c73..ce5f4a39bce2 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -503,6 +503,8 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	int ret;
 
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
+	if (!tid_tx)
+		return;
 
 	/*
 	 * Start queuing up packets for this aggregation session.
@@ -742,6 +744,8 @@ static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
 	lockdep_assert_held(&sta->ampdu_mlme.mtx);
 
 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
+	if (!tid_tx)
+		return;
 	params.buf_size = tid_tx->buf_size;
 	params.amsdu = tid_tx->amsdu;
 
-- 
2.25.1

