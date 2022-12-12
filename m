Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B9F649E20
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbiLLLrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiLLLrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:47:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B0E23D;
        Mon, 12 Dec 2022 03:47:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7A7F60FD4;
        Mon, 12 Dec 2022 11:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E18C433EF;
        Mon, 12 Dec 2022 11:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670845637;
        bh=lWioGeYIzIqesYApk/JLuJOXnJyD7SbY2I0mQPcKIf4=;
        h=From:To:Cc:Subject:Date:From;
        b=q2dVmV6WTikcdIc/5QOlHYjekbmceuvLBIbn/4dUN2RrdzUR9NuvOsOv0wuCX7s1w
         d/yIWo7deyNFS6gFnNcLw2VUtIymGjxptAA2rp3KR10Qs0aAJOb7Fio46OxFaHTmJu
         wqh6b0toEmp8bdm0rVHZgDdRdVRjuVyfCqtLEpoov1bbjYMcWH05MXb8eWgoHnS67+
         k2viP/B7jHJIBKzgNMuj58+5bCz1kM92RcH7HsCBUG+MwR206G1lMi1x7vQIF1PoGI
         dnqKB7pjkb+y0u5ob1RinY8P4T2H90caG1gcEPj9SK9Aaa6ZaL/qc1BBxtu/6D/hUW
         hi+2lwA2vH4QA==
From:   "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
To:     Jason@zx2c4.com
Cc:     linux-kernel@vger.kernel.org,
        "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        Martin Liska <mliska@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org
Subject: [PATCH v2] wireguard (gcc13): move ULLs limits away from enum
Date:   Mon, 12 Dec 2022 12:47:12 +0100
Message-Id: <20221212114712.11802-1-jirislaby@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since gcc13, each member of an enum has the same type as the enum [1]. And
that is inherited from its members. Provided these two:
  REKEY_AFTER_MESSAGES = 1ULL << 60
  REJECT_AFTER_MESSAGES = U64_MAX - COUNTER_WINDOW_SIZE - 1
the named type is unsigned long.

This generates warnings with gcc-13:
  error: format '%d' expects argument of type 'int', but argument 6 has type 'long unsigned int'

Define such high values as macros instead of in the enum. Note that
enums are not guaranteed to hold unsigned longs in any way.

And use BIT_ULL() for REKEY_AFTER_MESSAGES.

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=36113

Cc: Martin Liska <mliska@suse.cz>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: wireguard@lists.zx2c4.com
Cc: netdev@vger.kernel.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
---

Notes:
    [v2] move the constant out of enum (David)

 drivers/net/wireguard/messages.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireguard/messages.h b/drivers/net/wireguard/messages.h
index 208da72673fc..048125bdcd23 100644
--- a/drivers/net/wireguard/messages.h
+++ b/drivers/net/wireguard/messages.h
@@ -37,9 +37,10 @@ enum counter_values {
 	COUNTER_WINDOW_SIZE = COUNTER_BITS_TOTAL - COUNTER_REDUNDANT_BITS
 };
 
+#define REKEY_AFTER_MESSAGES	BIT_ULL(60)
+#define REJECT_AFTER_MESSAGES	(U64_MAX - COUNTER_WINDOW_SIZE - 1)
+
 enum limits {
-	REKEY_AFTER_MESSAGES = 1ULL << 60,
-	REJECT_AFTER_MESSAGES = U64_MAX - COUNTER_WINDOW_SIZE - 1,
 	REKEY_TIMEOUT = 5,
 	REKEY_TIMEOUT_JITTER_MAX_JIFFIES = HZ / 3,
 	REKEY_AFTER_TIME = 120,
-- 
2.38.1

