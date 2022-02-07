Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFBA4AC814
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 19:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239500AbiBGR7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:59:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234663AbiBGR7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:59:14 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1357EC0401DA
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:59:14 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id x4-20020a17090ab00400b001b58c484826so15540176pjq.0
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 09:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=TxUeZ57xexMP+iDjCAQT2P+jHC45IcBQm9HnpxD61Uk=;
        b=TNeqrTqLlCXXE4j2478+JvWpoQEaeLQStns2IvUSsmCLjSiNpvjaMQdvGxwknOYJeT
         LX0L9sKw+b4vr1g2uPccTLAQ+K7iPnpth1Z8p8CTzsp4aSY4TYQZ4P5aHqOl0LcQUj9B
         7PNJ5/8sBnqOOKJ+14LOItwMi/gG3iRMYg/Ixe0nvkxKs8M+iz92J/NFuWgS7dpjEc1g
         3ErsD42hcyY9lW+o2rFk1LIOpcT2ThsJLU/Z+iOAMZl9/ytBA6Xdx03DJPu4cbXFf3oz
         cLq4i2C2I0J9KBH1w5JFPl+ZEi8PWzehdHOrvFON/dBznRNSB9JchdV3z9+5LCEWci+C
         k2oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=TxUeZ57xexMP+iDjCAQT2P+jHC45IcBQm9HnpxD61Uk=;
        b=6VtLrYRZ/PAQT2etM5mmSRGwLYcP/Dkxv+fOqecHBJL0UgJQwjol1/cOYsmIArbm9I
         NCXbetHV0zYslna0FVi8Ubyq4ZKJ2+openI+k6VZfvnyPf5p3/2QuQm1rUDVud93HxTo
         03ehiuMXr+f8N4S92s7YwuOf24fl+GtN7LMBz2CBo3SHmBotk3umT2C/k6QeK5ra3ilt
         CGARhaih48pLn+3CYytmsKDRcvx1opU1CCjHJNiadlbbTGvCMUmhPdsjccUsyC/MPQtZ
         gUHIdgtarXTL1MyTtBiqUBOqCiOZAzgc9CEJYeYk2OjKsf8ADMKcrXO40OECwUjZOQjk
         yYRA==
X-Gm-Message-State: AOAM531+RzjDngN3XeJfAr0K9q4kfHDK3c1+9rPJkasYFYu9LmylmQbh
        aPuLuv9hHLc+/ZmalA+4u3LF/FN5O8Uou0jHS7jWdOPuECIJZtCiuuD+0I/brLxq29j0G5Q2410
        UMOx94yrOPQhzVINkbeJV6qLYxL0s9Z9Fsz5S6xg5JuOZzAohpPrmpWBgiJJGpdsdCc0=
X-Google-Smtp-Source: ABdhPJz2CruA10LFl51lmMUbCiSWqZJzaAHNMUL4ad30IPfhGL+XLr6oVBkRo0H/2j9BQ8vT1cB8lgTzhPDMLA==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:29ca:339a:48e2:43ee])
 (user=jeroendb job=sendgmr) by 2002:a17:902:70ca:: with SMTP id
 l10mr586973plt.121.1644256753349; Mon, 07 Feb 2022 09:59:13 -0800 (PST)
Date:   Mon,  7 Feb 2022 09:59:01 -0800
Message-Id: <20220207175901.2486596-1-jeroendb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH net] gve: Recording rx queue before sending to napi
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, Tao Liu <xliutaox@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tao Liu <xliutaox@google.com>

This caused a significant performance degredation when using generic XDP
with multiple queues.

Fixes: f5cedc84a30d2 ("gve: Add transmit and receive support")
Signed-off-by: Tao Liu <xliutaox@google.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 2068199445bd..e4e98aa7745f 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -609,6 +609,7 @@ static bool gve_rx(struct gve_rx_ring *rx, netdev_features_t feat,
 
 	*packet_size_bytes = skb->len + (skb->protocol ? ETH_HLEN : 0);
 	*work_done = work_cnt;
+	skb_record_rx_queue(skb, rx->q_num);
 	if (skb_is_nonlinear(skb))
 		napi_gro_frags(napi);
 	else
-- 
2.35.0.263.gb82422642f-goog

