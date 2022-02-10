Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192D34B14B9
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245401AbiBJR5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:57:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243640AbiBJR5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:57:14 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEE0115A
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:57:15 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y17so2477071plg.7
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cFxNMZlPWQbTVuYU8JB6usCHQfrDU2aW/saZvvKOcjE=;
        b=ZPKKohc0v9VFscLQ/b4ZxMHz51YqKhpiziQvBJRnhTiSqg90OfDuBuZXp5cKq5E7la
         kd4tgoNStjPzmxNvgpa7TvPUw0fYtkNkjm9hm44Q3fG/I+oHertRIyIg5aZsXLAvmNia
         OiNyRm5tJbCm/NputnCh2+7FP6taDzxUYpg7tV53CDBGw6izjeTvIz675h3aTYca1EZ5
         tztAH29QrRwdRqRxjo3A9aAkWzvpYz6mrnE6wSZUM3xoZ9UcjyvA6rPH+M3imtezj2Rq
         MUxNPk8hOLFWZMRomRX/syfSdgWJhslkVaPPLGfiD0sa1yRfoKOe18OFLpV/BwbgnWfQ
         X0eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cFxNMZlPWQbTVuYU8JB6usCHQfrDU2aW/saZvvKOcjE=;
        b=I42aUIhw0YA6lHBTdhy+CCydcE01Mza04A4qyJ3uzaJIhQpN0wMaOudGFJ6W7x/12M
         haOUPvKJBGXrdZnbhvMvh9qTiFFe2EV4M/XThD2RXZZDyVPiPwRqyATpJcYoQ0t/KgVk
         yHJEX9xanhGGUy3EdcHsW8UxEaq24WTeQCE5c939Jezzu+XoIlnAOc/w4zdTFLUkjkXw
         +1nNmhYdTsTWv5GDIgIF/KYeY6eOQwoWfnWXmcOZ27GciVY/aIxvP/WFmIfc94gitAPs
         fXqgtJbuLxHUhYYhO1VckaypxmjmxC9uqhPQH2dHiCtP1B3Mq2B55T5K6IBW/IP7YBDl
         763g==
X-Gm-Message-State: AOAM5308BUT3npGt/gyHW4C5iZu6ow4aff6oXMCI0yfw23ktiaV7VgwO
        2LXgNYkHC/oj59/J3pmnrTv1T4ATNq8=
X-Google-Smtp-Source: ABdhPJz7U59X2qlw5BTCc3gSWdpZzIP9uCX6KMe2M9oEB+kZPPuJOe12824GxuXhiwOzwTfHY/IS9A==
X-Received: by 2002:a17:90a:348f:: with SMTP id p15mr4005552pjb.173.1644515834689;
        Thu, 10 Feb 2022 09:57:14 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c3d8:67ff:656a:cfd9])
        by smtp.gmail.com with ESMTPSA id t3sm26230634pfg.28.2022.02.10.09.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 09:57:14 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/4] af_packet: do not assume MAX_SKB_FRAGS is unsigned long
Date:   Thu, 10 Feb 2022 09:55:54 -0800
Message-Id: <20220210175557.1843151-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
In-Reply-To: <20220210175557.1843151-1-eric.dumazet@gmail.com>
References: <20220210175557.1843151-1-eric.dumazet@gmail.com>
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

MAX_SKB_FRAGS is small, there is no point forcing it to be
unsigned long.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ab87f22cc7ecde517ba4cd0b3804a28c3cccfc85..96ae70135bd94c4527e61621af35d6e8659ab9f7 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2606,8 +2606,8 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 		nr_frags = skb_shinfo(skb)->nr_frags;
 
 		if (unlikely(nr_frags >= MAX_SKB_FRAGS)) {
-			pr_err("Packet exceed the number of skb frags(%lu)\n",
-			       MAX_SKB_FRAGS);
+			pr_err("Packet exceed the number of skb frags(%d)\n",
+			       (int)MAX_SKB_FRAGS);
 			return -EFAULT;
 		}
 
-- 
2.35.1.265.g69c8d7142f-goog

