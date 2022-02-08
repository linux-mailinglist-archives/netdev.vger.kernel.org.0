Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B1A4AD0E9
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbiBHFdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347050AbiBHEvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:51:21 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31621C0401E5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:51:21 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id r19so1072013pfh.6
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=peBaA7kLTFMHNdqrp6EFqwBYzVxcQ7eDSyelvqpjrPw=;
        b=YA1eZoM2cGPYHaBn2kGnAA+jeqXRQFurQFQsfMboN5gotBRB4EhDB3WWvOI3xkuqYb
         DEBSURqmj/PFGhny1CSJIX9KieIr1uPE2YtgM3YvO7a485Nv7cFN4zZtJ9tdL+5Uuy//
         COBm8tcnBKII8uTvfrBO1Kidd1rNu82hoNkF8LcBY35cGt6zx7KQmbiK+wb/08kcRiNR
         7680Pqixjj2JJ4tBp/hFpOp+9WQHe+c5y4V1uNDob+ihZ4wIUdy6d5JYNvUCVJJEkjrs
         FwGrrxNa6cKT/nHydqojo3sWcZyS7iv34fyOwmyO6QyRdOR4V95sm0OmtTmeBoeg5X3j
         6XDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=peBaA7kLTFMHNdqrp6EFqwBYzVxcQ7eDSyelvqpjrPw=;
        b=iJM0yN01W/tcAMswA2bfiwvsqpAhW1pznj9NWCvgHfjytn9BdMlwLurE1u6qv3Wp7g
         yC3eGT3IlqrfETVkmbaycq+w7qIzlXSesS5WZCzFOitI0CwNc7y5JqVQGPr6OF5yM197
         n6Qua/psgzDu6OW3A1bADQ1wL+/KSQTU0nG7zvZw5/AfBokMeRL5X05G5C/i5z5dB5f+
         aRQkEMxOJ14d4vuadbKzG2TxLgZ9oxp4tWhUrshEFLmo5RZOZdjP6ogwukn8DmpubmJn
         NWrD5sChz5C0fNESm/iT+xdYwWE68mFuUAZhrQRqKZgomcXvttTWgMvt2A0j5DzxFjFM
         5uTw==
X-Gm-Message-State: AOAM5315Bu6VKu7KHG4VJzBXibIgZtSkauj9fpoZWPaRohzJ38IMmDAT
        wKBB/lwaR5RXIiyqrRBPcSErUa62Eec=
X-Google-Smtp-Source: ABdhPJxzZc1+DbaQN6ZdAuTiVGYUdbcbzOD5e38A5ofb0TlJulSobfuPfQL2lAkIqjKNOXAVbfTcTg==
X-Received: by 2002:a63:f958:: with SMTP id q24mr2179371pgk.372.1644295880764;
        Mon, 07 Feb 2022 20:51:20 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8f56:515b:a442:2bd5])
        by smtp.gmail.com with ESMTPSA id j23sm9810257pgb.75.2022.02.07.20.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 20:51:20 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH v2 net-next 09/11] can: gw: switch cangw_pernet_exit() to batch mode
Date:   Mon,  7 Feb 2022 20:50:36 -0800
Message-Id: <20220208045038.2635826-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220208045038.2635826-1-eric.dumazet@gmail.com>
References: <20220208045038.2635826-1-eric.dumazet@gmail.com>
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

cleanup_net() is competing with other rtnl users.

Avoiding to acquire rtnl for each netns before calling
cgw_remove_all_jobs() gives chance for cleanup_net()
to progress much faster, holding rtnl a bit longer.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/gw.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/can/gw.c b/net/can/gw.c
index d8861e862f157aec36c417b71eb7e8f59bd064b9..24221352e059be9fb9aca3819be6a7ac4cdef144 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -1239,16 +1239,19 @@ static int __net_init cangw_pernet_init(struct net *net)
 	return 0;
 }
 
-static void __net_exit cangw_pernet_exit(struct net *net)
+static void __net_exit cangw_pernet_exit_batch(struct list_head *net_list)
 {
+	struct net *net;
+
 	rtnl_lock();
-	cgw_remove_all_jobs(net);
+	list_for_each_entry(net, net_list, exit_list)
+		cgw_remove_all_jobs(net);
 	rtnl_unlock();
 }
 
 static struct pernet_operations cangw_pernet_ops = {
 	.init = cangw_pernet_init,
-	.exit = cangw_pernet_exit,
+	.exit_batch = cangw_pernet_exit_batch,
 };
 
 static __init int cgw_module_init(void)
-- 
2.35.0.263.gb82422642f-goog

