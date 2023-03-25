Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA6C6C8EFE
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 16:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjCYP0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 11:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCYP0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 11:26:06 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2747D500;
        Sat, 25 Mar 2023 08:26:05 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so4332417pjb.0;
        Sat, 25 Mar 2023 08:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679757965;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=niKFnY0t+4MX3R2lOhT5fCEyXxOfUgTVhDHjO9rpeS8=;
        b=Xa07t1IpvMdvYSqRRh11jFCR38BL5ga6Yq7Df88By3VZeMYJd7qoZIVkP6F7dOCQr4
         IDnEP4uo+iZ/zJe/CZLjQMx3vplTGf5LNfTG1fVdD+Ft8efSVOxoTA4nIXje4MCoxei4
         I+cGdOYUe+wd2o6gye6P+OmMFi91cEIRdeyWKajPV7f4IKujitg+24ZTEvzD15BX63rW
         auFzqVeLwfn9C8KCfgJvnhsobGQgq9H0dhvoWTsm+7AvPvzBgqjWQ1XML8if3p5vmmZL
         cl5QGrlQs9ZNx2jD9Prc6m6fH9WUWzfBcFSJ1XZeUbJwYUC2HZpqB8fctkOhq4cXH78z
         DKaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679757965;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=niKFnY0t+4MX3R2lOhT5fCEyXxOfUgTVhDHjO9rpeS8=;
        b=VWw1EQarHN43Zs+Trv1gx68PZo4qaYEnr3CwtUop3S6UdJc3H6zQHjzJjGDs169ltP
         ChC/0kbRct0zaSvmZMi9C3fddsNeDIRxJK9yZwHDoZ81stMj2xeU8qygZUwmBMsdCT6Q
         pedrvA5ZcyMbUKK/OLJWCmsP3h9yXdWZPESqo+GQIadCXsgcz0Lwvod2yHxlSDH2G7C7
         fpL8nzXnpRrvd+gG22/i4RwqGDicZBvh3TdzKEcXQyq/CpBlLYvrY4JsHxl7Q/aw4vKi
         lKNSJmC18fVPc/TaqhZKwG9s2LuBZ5oEfPFbOoQW4Qu9WsW/khy7ruIy/eVSJrljMqvF
         xl7Q==
X-Gm-Message-State: AAQBX9dW4QwR+pqnb86qakZyXE2ELwKGMKDmebRlW6af9sqhFNewoRE6
        fkWxsOKdpMJ7mXKNbTeT8J4=
X-Google-Smtp-Source: AKy350bbvJ5ikaNnx5L5X2/soimE96kyq9dxgQaClL4ZqqekduyNybDgmn8U0DjGNoJ9WkbP+8Ig6g==
X-Received: by 2002:a17:903:64e:b0:1a1:b3c0:4228 with SMTP id kh14-20020a170903064e00b001a1b3c04228mr5154310plb.19.1679757965044;
        Sat, 25 Mar 2023 08:26:05 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([114.253.37.157])
        by smtp.gmail.com with ESMTPSA id d16-20020a63f250000000b004ff6b744248sm15249470pgk.48.2023.03.25.08.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 08:26:04 -0700 (PDT)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, therbert@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net] net: fix raising a softirq on the current cpu with rps enabled
Date:   Sat, 25 Mar 2023 23:24:17 +0800
Message-Id: <20230325152417.5403-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

Since we decide to put the skb into a backlog queue of another
cpu, we should not raise the softirq for the current cpu. When
to raise a softirq is based on whether we have more data left to
process later. As to the current cpu, there is no indication of
more data enqueued, so we do not need this action. After enqueuing
to another cpu, net_rx_action() function will call ipi and then
another cpu will raise the softirq as expected.

Also, raising more softirqs which set the corresponding bit field
can make the IRQ mechanism think we probably need to start ksoftirqd
on the current cpu. Actually it shouldn't happen.

Fixes: 0a9627f2649a ("rps: Receive Packet Steering")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
 net/core/dev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1518a366783b..bfaaa652f50c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4594,8 +4594,6 @@ static int napi_schedule_rps(struct softnet_data *sd)
 	if (sd != mysd) {
 		sd->rps_ipi_next = mysd->rps_ipi_list;
 		mysd->rps_ipi_list = sd;
-
-		__raise_softirq_irqoff(NET_RX_SOFTIRQ);
 		return 1;
 	}
 #endif /* CONFIG_RPS */
-- 
2.37.3

