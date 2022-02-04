Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30CC64A916F
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 01:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356113AbiBDAG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 19:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351538AbiBDAG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 19:06:58 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7360C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 16:06:58 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id g67-20020a25db46000000b0061437d5e4b3so9349985ybf.10
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 16:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=lUp9nMoUiFyrieV5KbbENv6/JdiLns0yIW0fWDItt30=;
        b=fKnAE+s6fwM3gJHN5x37bm3cyFiTou2OMJB5EQlQci+TLEA8sZznLGAL9FJaY3I+GK
         Mz5O8SyXTl4+QO8U36tF9A4KT/KWnotdmu63/ywtTkH1nyUtvd3wC9p2gaF9XtEPzO9a
         pz8Zw8UHm71Zmxvnt/jtPg7K02H3ItT2DpTEEQAUx0jjZSnGL0ZES3+BkK4LRe0byqO/
         MTPU+RmCZigBGgvJY7BOfuZK9YTmw9bhcSqcNneh5EPzsURnFjc0u2tqGoMlAyY/Vo0T
         R7wFfhSfn0IEbcOqWNof0TvabjEa/ralrgbSTze0viYIgj0+RgXh9hQZDxEVCKQn2XXZ
         jvFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=lUp9nMoUiFyrieV5KbbENv6/JdiLns0yIW0fWDItt30=;
        b=004WCuzdC39rJWO/b4/od15mgVOjPiG6n00K/YrCqcixUtPG06a2conZZGna1GfHJt
         MAfjlze+pFDNM0jiDQp5/7jBoguKhiXBe2nc4MnEaj+YAnNDzh7xhjGWzgPts5kLJOwF
         N7MfBL18OL6u/tPpxvelqMt/X4169flZxe+0bMvytGmHz8XBjMJWfnr5qmXL2Bepuwb7
         Cx55NPorm8Ibo6tTyi5WYo/Dh7D16LrqhiZ7NHOcUVaW3iHwX99cxADganwXTAJDRn2N
         sOijw6CpPIXjVZ22ONGlRhLV6x/bOwgvAeP7pm/uwHTMfMPNoHDGFCxBCG4u3NQ30T4f
         pVhQ==
X-Gm-Message-State: AOAM530RvcMsqQmyC899CqH6EYubv+I5TNmL9NFHTi4L6N7Wmv83yw+S
        vU0SnW4Df70VbmUqK1w6BuevnIe9/fAvS9kk0C0+QqwyKdf5niarupOVbC5w1PBKpOF8HNJrO2v
        HqXTLTklyBYv9ZZeNUvEcRSYCnC65MPlxUAMLaQkDvZY6UT8G+6ryZIirXH+MbSll
X-Google-Smtp-Source: ABdhPJzNuA41KV/WmNQG0kw8l1K8YQLBKyCXrSptamc83vac34kQDUYSYCR0Tf6pWauTpVq2p9DpIQU37iQw
X-Received: from coldfire2.svl.corp.google.com ([2620:15c:2c4:201:ec9:a2d6:da20:e935])
 (user=maheshb job=sendgmr) by 2002:a25:dd06:: with SMTP id
 u6mr591155ybg.357.1643933217963; Thu, 03 Feb 2022 16:06:57 -0800 (PST)
Date:   Thu,  3 Feb 2022 16:06:53 -0800
Message-Id: <20220204000653.364358-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH v3 net-next] bonding: pair enable_port with slave_arr_updates
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When 803.2ad mode enables a participating port, it should update
the slave-array. I have observed that the member links are participating
and are part of the active aggregator while the traffic is egressing via
only one member link (in a case where two links are participating). Via
krpobes I discovered that that slave-arr has only one link added while
the other participating link wasn't part of the slave-arr.

I couldn't see what caused that situation but the simple code-walk
through provided me hints that the enable_port wasn't always associated
with the slave-array update.

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
 drivers/net/bonding/bond_3ad.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 6006c2e8fa2b..9fd1d6cba3cd 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1021,8 +1021,8 @@ static void ad_mux_machine(struct port *port, bool *update_slave_arr)
 				if (port->aggregator &&
 				    port->aggregator->is_active &&
 				    !__port_is_enabled(port)) {
-
 					__enable_port(port);
+					*update_slave_arr = true;
 				}
 			}
 			break;
@@ -1779,6 +1779,7 @@ static void ad_agg_selection_logic(struct aggregator *agg,
 			     port = port->next_port_in_aggregator) {
 				__enable_port(port);
 			}
+			*update_slave_arr = true;
 		}
 	}
 
-- 
2.35.0.263.gb82422642f-goog

