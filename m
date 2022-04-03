Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4C14F09A2
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358633AbiDCNKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358468AbiDCNKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:17 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BB8393F5
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:19 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id p189so4336427wmp.3
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vbNrUqcL+5B6jcAJE+OFILYZJBfw/FalxK3WQ8Mdyzs=;
        b=mKOweO1WNQC1Zb05N6p78EA1oUpHKUxcRWq4Wzpdl8elw9NzOahMaEm3JGxINiK0+z
         GT6v/26M3yK/6nPJtwk/7Cvn5H2ZJ3SJZ4pD1RQaQ3dP5/UKTvTF0gYIR+bxi3XYWuGk
         EZOtU63Nik2aWbeAkuvN7HLBbdGJRBCLYLf+bGPvsuv2du1TXaHgAKxUvKC1ypHAiH5S
         z5bLlWqgFGFJHE3upWEjKvX2+5A/+6YIM0gub1BX478K+9sfS0f7yJnvf9CrfPhofWLZ
         yHQqd9ZgbA66v/8mwfAnC5LXI8HGBITRxyJ5hPrkQ1aFiTDlcanmtdmQ5NOlnbKlTvsv
         K1QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vbNrUqcL+5B6jcAJE+OFILYZJBfw/FalxK3WQ8Mdyzs=;
        b=8RgnJJIRCCeCwg7HmSYMnnsHB6LneEZCb4T5YNnjnpJk9Zm9trOXfPSllbdGB5TnmA
         9Xt67t6iGXLuCpbzOOHwRyNKCQAJ5odrhcWT/kXaNS6dLU1uEDdawzHDBvtdBt4O8y2L
         tngdOvQ9Et+SEqFT8oqKbwCmzHiZIrX82hyz/xQFZwxZLfeaBRcI4TUFm228YZSrpm2l
         dw7WIHFIq4oS+ArK1tC5V3/UrUHR9djMIezEmFhsWXAlYnqXTJi2ymYAhJ8kiWXD6vHW
         pIPnZGOE4crko77cXtldehLsdI2TtAYYTuEhtaHvmcp4duqmoh5j1OMTFw4VYUSO+I4/
         5d1g==
X-Gm-Message-State: AOAM531woPAvKGMpjAO/+MVbnWDjj3j3Sh9YANI2aOSknAgrdBeaMWj+
        OG5xtfEZJ/YWGbLgc61qefUID7IuAD0=
X-Google-Smtp-Source: ABdhPJz7HbfRMzb7o1fNHPI2tavbXmldCXPyJOU4wO94Oey4Z5NWWjCFtONF5BpQTjMuTRlh2bjv+Q==
X-Received: by 2002:a05:600c:5113:b0:38d:d8f:67e9 with SMTP id o19-20020a05600c511300b0038d0d8f67e9mr15422593wms.107.1648991297600;
        Sun, 03 Apr 2022 06:08:17 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 06/27] net: xen: set zc flags only when there is ubuf
Date:   Sun,  3 Apr 2022 14:06:18 +0100
Message-Id: <3b75e002109483819858dd303ca91981b33ee0d9.1648981571.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
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

In preparation to changing zc ubuf invariants, set SKBFL_ZEROCOPY_ENABLE
IFF there is a ubuf set.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/net/xen-netback/interface.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index fe8e21ad8ed9..0a0c36a38fd4 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -55,7 +55,8 @@
 void xenvif_skb_zerocopy_prepare(struct xenvif_queue *queue,
 				 struct sk_buff *skb)
 {
-	skb_shinfo(skb)->flags |= SKBFL_ZEROCOPY_ENABLE;
+	if (skb_uarg(skb))
+		skb_shinfo(skb)->flags |= SKBFL_ZEROCOPY_ENABLE;
 	atomic_inc(&queue->inflight_packets);
 }
 
-- 
2.35.1

