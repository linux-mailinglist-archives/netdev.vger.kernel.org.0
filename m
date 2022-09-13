Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E4D5B6474
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 02:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiIMAJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 20:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiIMAJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 20:09:46 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7044A188
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 17:09:45 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s68-20020a632c47000000b00434e0e75076so4731241pgs.7
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 17:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=mf6gAa2FUuC/TKAAUA//hrbOcrhI3EIimGrDttSq75s=;
        b=dq3G6iOyKmOi1nu+z32aUMEoD4tnTN9UyCOkvgcSBuWo4PfZq5yavLzF4PEedzdP6R
         2TGjpRwfBIxOQCfGxom29OJZ7AMmEioC24Q4gG15AY5qS2hV0XWprDBX+L3pS8pzhqFU
         CQyCZdRWraUPaozPeqp5RugfZqK7LvusXkv8buWMgSiwh2i64Z2taaercBBBhTGSe78l
         lg6ZhEe5mmNSmkVy9rnCHqyioLPyy7viedqREsD0DiYRmFE6H3CFrmPss3CL2iZ2JMnZ
         PYqJHURGxuy07KBONh2WwMl79qAqvN//rq1cdKHatawePNY55D3FNg7WLvZrWOpPLUxh
         CxCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=mf6gAa2FUuC/TKAAUA//hrbOcrhI3EIimGrDttSq75s=;
        b=rujQ3GPi8hfwLE15s6FsV3W5r1JJe51SxUJ05HpWZurefVOfoZCIXbgdLpK7f774Xv
         1ZedsloxMwgLfFBfqa6vwwkX8Mz2zAJi95bO3BmxIwfgSEz+OcSdi3B68ffX9esRrvse
         vwObRoet5zj7yjBGgKldGa76IsMbm408pF4hgmSLJ+T8YqpuxxgoJI52G3RpLoKJHQc7
         /T9MfFyK78wXNFXEIekDPOn065ulp/c5MqREQj2MlMJeh2Z9qjts5Bhz1OTBYG/XY6Ae
         Nyqvu5+S81G05EzNrW7eL+pwlJcy1qbBsEXyPrmQD4MB2Ts3oHGonSXxa1Tg3yH7l/he
         BzAA==
X-Gm-Message-State: ACgBeo00ieFzjIdQevHWfOSw+8+0VC3v8avu6ixWfMaCsRoM4ZkcwMRv
        DiQQpns0S18G5puwCavf2+5qzm/W8bW6pzHF8iOIfg0G/Utpoeu1Fx4OYDhb7qP1mfR/qDxDhFv
        NAz4f5FBzi9Hsc3fMAj8KtFuakh95YhxOKcstEFOaFNKLFZCxwJ/SWvvNewmx7AQHGCQ=
X-Google-Smtp-Source: AA6agR4OqTC0e+DLad/HHxyFq3S4H2cNMRv3jLQomEbyo/KrUJJ+G65qjqGrXHST8WElepi0mLKxhguBSrmGWw==
X-Received: from jeroendb9128802.sea.corp.google.com ([2620:15c:100:202:9a4d:8a2b:134e:1e68])
 (user=jeroendb job=sendgmr) by 2002:a17:90a:1912:b0:1f7:8c6c:4fde with SMTP
 id 18-20020a17090a191200b001f78c6c4fdemr1035189pjg.8.1663027785151; Mon, 12
 Sep 2022 17:09:45 -0700 (PDT)
Date:   Mon, 12 Sep 2022 17:09:01 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220913000901.959546-1-jeroendb@google.com>
Subject: [PATCH net] gve: Fix GFP flags when allocing pages
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Shailend Chand <shailend@google.com>,
        Jeroen de Borst <jeroendb@google.com>
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

From: Shailend Chand <shailend@google.com>

Use GFP_ATOMIC when allocating pages out of the hotpath,
continue to use GFP_KERNEL when allocating pages during setup.

GFP_KERNEL will allow blocking which allows it to succeed
more often in a low memory enviornment but in the hotpath we do
not want to allow the allocation to block.

Fixes: 9b8dd5e5ea48b ("gve: DQO: Add RX path")
Signed-off-by: Shailend Chand <shailend@google.com>
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
---
 drivers/net/ethernet/google/gve/gve_rx_dqo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 8c939628e2d8..2e6461b0ea8b 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -157,7 +157,7 @@ static int gve_alloc_page_dqo(struct gve_priv *priv,
 	int err;
 
 	err = gve_alloc_page(priv, &priv->pdev->dev, &buf_state->page_info.page,
-			     &buf_state->addr, DMA_FROM_DEVICE, GFP_KERNEL);
+			     &buf_state->addr, DMA_FROM_DEVICE, GFP_ATOMIC);
 	if (err)
 		return err;
 
-- 
2.37.2.789.g6183377224-goog

