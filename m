Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364AC6CCE35
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 01:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbjC1Xuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 19:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjC1Xuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 19:50:37 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9032D53
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 16:50:36 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536a4eba107so137506277b3.19
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 16:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680047435;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NEVi1Wx4ym+jY+4fwgQ4BHieQsajwpmRbk8Us63oRfc=;
        b=HKN/FhXP5emWObR1S8ZxtxMbiH8Y+QcMP8Dtz5OolgaOKS9FCP+nAv1H3Jbcmt8/vQ
         vV0yC+aHuSyirbyzgD0FLYhlHD7sBobIYyQHSAk8VbLSuceVavGIiO2zFdCJ4jBrV+mg
         UJosy6x9RkGJbmp/quXnCBmXxDLI208fnLaGRzoPDWjnu5l4SRUs98kIGhQbAFsXllos
         X/G/hzyKZm9Le4NP1q0tkjqzPdkrNZd58dcBNaopEAjKxYrFmoLahBGvzN7fPXIIPkWq
         iMUwCobldJ4KaFwdBJ/MqF2K8L7k6hgJArQpAqSGDJJgUjFlRiORtDmWqAEaOcbC1gwi
         1XfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680047435;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NEVi1Wx4ym+jY+4fwgQ4BHieQsajwpmRbk8Us63oRfc=;
        b=5rIZfX2aUPOIyK0PteIO4YX/TCRHe+T1MTgyIbS3ZAnzib+8d2jlvNf/8lww5O9HO7
         cqS7aQlMhw1mqkAkP2234sEUPrfg5exPCa+x8Tnia1T5Tpci2e/VWsKpZdwaadhId+q6
         Sqh6Ui3QV9i3A8L5dguuY/id8ORQJzt/VgPKj5A+RTu7wEUUEyGlh8VGnzI5sy4kcp2W
         e+eP+TdTpTxu7X3EBbE3sn8KDLyLOC+s6V5wLOQDO8M85hejIMyyloOa3tE5fKjhjBqs
         hf735dB2dzbAIuUYE9DIQ2cJY4grFFsZcgFP86islcjRd5LrSKgdDqKg9kr1QGw4czuo
         JMpg==
X-Gm-Message-State: AAQBX9fUk5hqkhxuviQmfAE3zKN8v/hbaZmTkpKyn9O5veHR6CrfpM6r
        YfoOYJ64R76+aOIzq3QZm+jHUT8EkEJo6g==
X-Google-Smtp-Source: AKy350baxALw5xXGpYmIEp8oGFZzoqM6ONYcXO1vSbqJngKD0TNDe7mPgEUq91xcmaX9/Kj07lhWJ8YBGlQ9jg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:688a:0:b0:b46:c5aa:86ef with SMTP id
 d132-20020a25688a000000b00b46c5aa86efmr8845028ybc.12.1680047435603; Tue, 28
 Mar 2023 16:50:35 -0700 (PDT)
Date:   Tue, 28 Mar 2023 23:50:20 +0000
In-Reply-To: <20230328235021.1048163-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230328235021.1048163-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230328235021.1048163-4-edumazet@google.com>
Subject: [PATCH net-next 3/4] net: optimize napi_schedule_rps()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jason Xing <kernelxing@tencent.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on initial patch from Jason Xing.

Idea is to not raise NET_RX_SOFTIRQ from napi_schedule_rps()
when we queued a packet into another cpu backlog.

We can do this only in the context of us being called indirectly
from net_rx_action(), to have the guarantee our rps_ipi_list
will be processed before we exit from net_rx_action().

Link: https://lore.kernel.org/lkml/20230325152417.5403-1-kerneljasonxing@gmail.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jason Xing <kernelxing@tencent.com>
---
 net/core/dev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 15331edbacf4ca59aa5772c29e95cacd3c106e3f..f34ce93f2f02e7ec71f5e84d449fa99b7a882f0c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4587,8 +4587,6 @@ static void trigger_rx_softirq(void *data)
  *
  * - If this is another cpu queue, link it to our rps_ipi_list,
  *   and make sure we will process rps_ipi_list from net_rx_action().
- *   As we do not know yet if we are called from net_rx_action(),
- *   we have to raise NET_RX_SOFTIRQ. This might change in the future.
  *
  * - If this is our own queue, NAPI schedule our backlog.
  *   Note that this also raises NET_RX_SOFTIRQ.
@@ -4602,7 +4600,11 @@ static void napi_schedule_rps(struct softnet_data *sd)
 		sd->rps_ipi_next = mysd->rps_ipi_list;
 		mysd->rps_ipi_list = sd;
 
-		__raise_softirq_irqoff(NET_RX_SOFTIRQ);
+		/* If not called from net_rx_action()
+		 * we have to raise NET_RX_SOFTIRQ.
+		 */
+		if (!mysd->in_net_rx_action)
+			__raise_softirq_irqoff(NET_RX_SOFTIRQ);
 		return;
 	}
 #endif /* CONFIG_RPS */
-- 
2.40.0.348.gf938b09366-goog

