Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13566356B6F
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 13:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351875AbhDGLkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 07:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbhDGLkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 07:40:00 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B941C061756;
        Wed,  7 Apr 2021 04:39:51 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id x21-20020a17090a5315b029012c4a622e4aso1154759pjh.2;
        Wed, 07 Apr 2021 04:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HirO+Q0OBJEy9dZvyn9vrel+cDU947PTKIKG1x5aZyY=;
        b=DeVZjEOrLpyIKfXVzFf3QrEuuRj74/eNunk4N0dbceNCcnRJcbjhzz6oui8K8uvH7I
         In30n6uMnyckuGKjYnrP+X+iBRAX+iVGmROCHCXU7kejM+Zd+x6fwcuHMkDMqWr3LrlY
         L9JROlGzg4DVYkU9623xx/KqrMeTzj72TpBdmDt6oEelC4uDGq/Do1M4ADSZ7wXNKY9u
         AYDI1lBRzAw/D5g7hWwBpJNwXEbr/TsDtjrplQGRMMWp3F2inKcdk5Jws9b6IRqg5b3E
         MfZkYxlNadtPYR4/9Z8J7Isrx4aRU3JYjruMBZwNjvxe4reE70tMfbwTNgMRNxuQhKmU
         6FRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HirO+Q0OBJEy9dZvyn9vrel+cDU947PTKIKG1x5aZyY=;
        b=ICsQe3SZhdGjohcz9kKyucb3UKII4pabzr191q7HRY1i8NSFOqO5H1ErOiBT8CC+Uc
         0VdCapuLzsWH5vIBwuX6YX2eFXHPbzpCf+/SBdLuJeWxY3/74QhF0yeeokg8ERYd9Imm
         agcN3QW7/KMRNq4dQNzW/3Hia2Q9jB3+WKmYs4TAMb7coQOKSvcOf9X6xiU+oWEZ7iFr
         sFPHsIQjrjQdnOcinKBJ0OkYPBL8WL4y5n0bY221ZVosJu1Onz/KD5XPSWTSc6XHE6sg
         oJ6Vn/bl8Y8n2c7L88mxvo57QrgR55X2dLgx2pcJSm8Kv1kY3mIZnzzW+3knRkWwVo1E
         I3qQ==
X-Gm-Message-State: AOAM533r2W2OTJuIOU9MXrxzw+E/NztRaUKHVoUU/JiiTJ5hmDmRCuU3
        0JxYtKQNnZy/8ylN8IyowDOT65sTca2dJQ==
X-Google-Smtp-Source: ABdhPJww07QLcE+H4zAn69VAwEZGYO7CfiGLNi1L3tPaJivFoSjfT0HKveDMQ+Zk7cmpR1XmooAtxA==
X-Received: by 2002:a17:902:9f94:b029:e9:68a3:8551 with SMTP id g20-20020a1709029f94b02900e968a38551mr1673693plq.35.1617795590482;
        Wed, 07 Apr 2021 04:39:50 -0700 (PDT)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a13sm20854321pgm.43.2021.04.07.04.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 04:39:50 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "Jason A . Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        linux-crypto@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
Date:   Wed,  7 Apr 2021 19:39:20 +0800
Message-Id: <20210407113920.3735505-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the cryptos(BLAKE2S, Curve25519, CHACHA20POLY1305) in WireGuard are not
FIPS certified, the WireGuard module should be disabled in FIPS mode.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/wireguard/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireguard/main.c b/drivers/net/wireguard/main.c
index 7a7d5f1a80fc..8a9aaea7623c 100644
--- a/drivers/net/wireguard/main.c
+++ b/drivers/net/wireguard/main.c
@@ -12,6 +12,7 @@
 
 #include <uapi/linux/wireguard.h>
 
+#include <linux/fips.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/genetlink.h>
@@ -21,6 +22,9 @@ static int __init mod_init(void)
 {
 	int ret;
 
+	if (fips_enabled)
+		return -EOPNOTSUPP;
+
 #ifdef DEBUG
 	if (!wg_allowedips_selftest() || !wg_packet_counter_selftest() ||
 	    !wg_ratelimiter_selftest())
-- 
2.26.3

