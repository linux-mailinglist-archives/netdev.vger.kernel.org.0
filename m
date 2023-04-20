Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A7C6E8C9E
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbjDTIW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbjDTIWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:22:53 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2A44692
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:22:43 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1a69f686345so7515405ad.2
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681978962; x=1684570962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4CKVN4OgWp070dKsrCkzTlYbbB9LErF2cMznFtz8ihA=;
        b=U+q2QZFhbZYxMbF0dbFyb9S5GKs0L3HFdPBnNXVdBBQlhBECn0KI/bxq1RaMbTw7u5
         K+VtRMO5dRvnj8NRjp6syeRTdJNFMsj3bsvH39wM1MFyM6XTcFog28PsIdle5Hf5BPk7
         HOfQqEkuocV77bRU6HqnOSiVpJwZhKZDmec8Sh10aHlpbDRtlFN44j/9swE/05P4+jT1
         YvKmlBQ0ae8Q5ccKxcgD1ZcQZCo190d6EgdTP/0ocAHBRkVAc3d+r0T4rb0tbKm2EqSC
         7lSSIDeX1UUPmvTWuubWqOmO9m8vl66MGb/fjEvUdsx/OQIxNjX3F7As9JYTHTk1dCHZ
         FY7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681978962; x=1684570962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4CKVN4OgWp070dKsrCkzTlYbbB9LErF2cMznFtz8ihA=;
        b=iTijhZZfhamfKzEm8GlSICjsrV+TYBklyY2HKhyWnLi8hYNiOnuVyieVevSbKrtVeF
         n3Wo9e0GVnTNflcDTpeWLMnHpb2h1KUFw+kII/F8ljRewTI3gHmTdxl6T0UJOUNUD/sG
         OZV9//Sg/dc5YB73zpBROMHua/UlhlyKUiA53YpveQNSkXTBK3TK3ZXE3J5PZOyJeBSY
         me9uxwj2gpbahg4jSSuXB9ymBUNgapRb708WDVaTVDtXjeoQXrZXUzLGj3xIaikBH0l+
         Bmx6ZpbCmoUKY/WV9kzOrEYFXKQyfwLax8rd3EFtqVwEu/tsa986TLCCfIOYflp0+EZC
         zLBw==
X-Gm-Message-State: AAQBX9eGhZsWa9e5cI5OOrcdTM4UG0VsQSNRxjbiGEgZWdmDb85NsHzK
        OxoF6vVVsTOBsrCcy/gm0Eg//6dHRFPlI5T7RPc=
X-Google-Smtp-Source: AKy350YJqcGbiwB2bgu7QFs0lE5fjqGwPHbI6UVJFivkq/6M9NxmFItuqLfL+icy0uzjF33mcszCJw==
X-Received: by 2002:a17:903:2444:b0:1a9:23b7:9182 with SMTP id l4-20020a170903244400b001a923b79182mr1303987pls.27.1681978962525;
        Thu, 20 Apr 2023 01:22:42 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l11-20020a170902d34b00b001a1ed2fce9asm662175plk.235.2023.04.20.01.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 01:22:41 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Vincent Bernat <vincent@bernat.ch>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 1/4] bonding: fix send_peer_notif overflow
Date:   Thu, 20 Apr 2023 16:22:27 +0800
Message-Id: <20230420082230.2968883-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230420082230.2968883-1-liuhangbin@gmail.com>
References: <20230420082230.2968883-1-liuhangbin@gmail.com>
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

Bonding send_peer_notif was defined as u8. Since commit 07a4ddec3ce9
("bonding: add an option to specify a delay between peer notifications").
the bond->send_peer_notif will be num_peer_notif multiplied by
peer_notif_delay, which is u8 * u32. This would cause the send_peer_notif
overflow easily. e.g.

  ip link add bond0 type bond mode 1 miimon 100 num_grat_arp 30 peer_notify_delay 1000

To fix the overflow, we have to set the send_peer_notif large enough.

Fixes: 07a4ddec3ce9 ("bonding: add an option to specify a delay between peer notifications")
Reported-by: Liang Li <liali@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/net/bonding.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/bonding.h b/include/net/bonding.h
index c3843239517d..f4d376420e4d 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -233,7 +233,7 @@ struct bonding {
 	 */
 	spinlock_t mode_lock;
 	spinlock_t stats_lock;
-	u8	 send_peer_notif;
+	u64	 send_peer_notif;
 	u8       igmp_retrans;
 #ifdef CONFIG_PROC_FS
 	struct   proc_dir_entry *proc_entry;
-- 
2.38.1

