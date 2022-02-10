Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 405A84B1946
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 00:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345563AbiBJXQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 18:16:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345568AbiBJXQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 18:16:11 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD305F57;
        Thu, 10 Feb 2022 15:16:11 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id f13so5648145ilq.5;
        Thu, 10 Feb 2022 15:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=h1925twPT3iSM3qheWQhZ9lCv/Q+dhcPfdo+0L9UR6M=;
        b=FmZrCbIuuWKcUa6zV5OkwYnsnhTEUlIwU3u7B4rFa9iv9rogxDfUrkC8iT50ElDrDJ
         V/LzmYUzN4KTICqQQrjcvGO0wHklus09GVJUy44lN8vcaxmXjobi8Dr6/6a6Gheo1UIf
         6ZVGk/RUan0TW8dFSwWVwH57oqfIjLrfKcmhzfFRgYG7Twbk86HqrSoSWZt8ZFX533Cn
         4V8AlTRgOg62gIynVCyufSHpgzhDihN3Mipttmzn2Ub5dY+etr1IqCTmeJOPXe8QvPRv
         rAcqxTsM6XK/RIMsgAA5tCXqxJdSESyW1TcRBcT5YER/neKAsTtsfzTPBB0ie0DRQnPO
         wGmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h1925twPT3iSM3qheWQhZ9lCv/Q+dhcPfdo+0L9UR6M=;
        b=xc+wZTL5Y5Oflh9zNZPBoY6OYGuFSESO3dv8YR3uxcVM7JL5c1Zusz3D2C3V3xE5Wi
         DUjMdcSbCwQm584d8PjLAlU0Mg8Ob+V0XrRk11GkOTFH+IUjmNHVtrh2lwQjFdbf4GvV
         iKIIMXxa6u07vmFVWecMge0KCzPX2Qu5N+cjOMrYFOt5VZoBTZu0DKr6YWFS4AjLZZLD
         78GaLfxS++vel5Zx0b/yxLT7mXMbDaNQ+ffLbFmd1zbWC7aXY82tXdxGVYeYdljFmHgI
         SKrbh5Fiv10G6xbz7kTKk8zXtDvrRkIbiVTr5wafXqhW5BfbIAFslwPRgCWbArz6Kgzk
         9pfw==
X-Gm-Message-State: AOAM530psnUwDkBWscs5LlQomuZ4JSN4fYB0rKCB0GLP3uLyM/3g8aMs
        gYWJynspUenhlykVV3DL2VM=
X-Google-Smtp-Source: ABdhPJwNz15I7lWfFObm7DT3E8n4zBq2XHpU9H/Y5oNqt2y0xQ5ILb07o8ZNPvUbz9qZoJ7yYmpd8Q==
X-Received: by 2002:a05:6e02:144d:: with SMTP id p13mr5306936ilo.47.1644534970739;
        Thu, 10 Feb 2022 15:16:10 -0800 (PST)
Received: from localhost ([12.28.44.171])
        by smtp.gmail.com with ESMTPSA id h3sm11666270ild.11.2022.02.10.15.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 15:16:10 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Laight <David.Laight@aculab.com>,
        Joe Perches <joe@perches.com>, Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Nicholas Piggin <npiggin@gmail.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-kernel@vger.kernel.org, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 11/49] qed: replace bitmap_weight with bitmap_empty in qed_roce_stop()
Date:   Thu, 10 Feb 2022 14:48:55 -0800
Message-Id: <20220210224933.379149-12-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210224933.379149-1-yury.norov@gmail.com>
References: <20220210224933.379149-1-yury.norov@gmail.com>
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

qed_roce_stop() calls bitmap_weight() to check if any bit of a given
bitmap is set. We can do it more efficiently with bitmap_empty() because
bitmap_empty() stops traversing the bitmap as soon as it finds first set
bit, while bitmap_weight() counts all bits unconditionally.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 drivers/net/ethernet/qlogic/qed/qed_roce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index 071b4aeaddf2..134ecfca96a3 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -76,7 +76,7 @@ void qed_roce_stop(struct qed_hwfn *p_hwfn)
 	 * We delay for a short while if an async destroy QP is still expected.
 	 * Beyond the added delay we clear the bitmap anyway.
 	 */
-	while (bitmap_weight(rcid_map->bitmap, rcid_map->max_count)) {
+	while (!bitmap_empty(rcid_map->bitmap, rcid_map->max_count)) {
 		/* If the HW device is during recovery, all resources are
 		 * immediately reset without receiving a per-cid indication
 		 * from HW. In this case we don't expect the cid bitmap to be
-- 
2.32.0

