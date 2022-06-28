Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928B855C860
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243981AbiF1Ibj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343880AbiF1Ibh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:31:37 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCFB275E1;
        Tue, 28 Jun 2022 01:31:35 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s206so2514055pgs.3;
        Tue, 28 Jun 2022 01:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4YUppmcH9DGFbiFvJ50NDFp5rvlwmUubF5n3PRvNMgc=;
        b=WtHQcxrKWFb2K9B9boiU1Bi//tvsO6QUM6wkTogqoKBJOSNFKMWse7SXsuuk4x+iT1
         93d6LTv5O67ZpPJI2qk3llusmAYNYSl2pN47Fvxh/TKwV6vIG2+bgUqkW7sAP4BoOTJ+
         JLH1qM9KOmKulzKmG9Amr4PsjXGKrqgb5JCItUjdHR9EwoshWGNf9NB8idZhdCmEZiZ0
         y9MuO9PxUL/9q85b/VsKWMw6Vw1ukBDiSvWOXLOl1p35WCsrOzsGsGBMEpQYcIRji3yk
         jdFMelVA4hcZ/yKnMeBrMY12se1Wq4bdOJaQUBoAg44XGAqEtLX1r3kNgfZbgSbvDqwm
         8+NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4YUppmcH9DGFbiFvJ50NDFp5rvlwmUubF5n3PRvNMgc=;
        b=BWSJXuOClOHqDX4kN6zzvfogcn7cAC6Qc4uiheE1gDEA0+IZtWyehkM/n09pkq3TIo
         +8a+jKRwO87EcGg+JLNn8wEZkttP0ZbxA3sF/uT4Io2QR/qaoaETzmKb2xx6O6gU29Kl
         c5Obwfdiskx2IldgN91V11yAr4liz6y8gxjbsGN+8PzJNtHgXLQi9F3Q98KC2JWfegla
         h4ETnEeYcWwz8AGTiE3dhU3lRdOxawxhpvY4b4a8u1C1sWp8LoN7HgDFKrHQ3f/OnDAq
         YCAq2TIHuIF8hn07YeNJWqz73NwQS/ezYYWMmUjlvyUpOlv86gUXUC5kXz7a6ajYsYvb
         8lBA==
X-Gm-Message-State: AJIora+I3RkzSDHg+NNNWvAFGhPUvYX34BLz8U64rn3WXiJLEGS3mzsv
        OcPDA7RZ8by3Rh44Rb9qj24XrOxzhEGFjdY3
X-Google-Smtp-Source: AGRyM1utu+zRDoU2mf3jHnY+RweqiTweJg5TodgmiqeLpUNAtJC6maZfLtZQwB2+4TpWugfe1Kpe6Q==
X-Received: by 2002:a63:6d7:0:b0:411:51f2:6de2 with SMTP id 206-20020a6306d7000000b0041151f26de2mr3858740pgg.184.1656405095276;
        Tue, 28 Jun 2022 01:31:35 -0700 (PDT)
Received: from localhost.localdomain ([103.84.139.165])
        by smtp.gmail.com with ESMTPSA id c16-20020a170902b69000b001678dcb4c5asm8653339pls.100.2022.06.28.01.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 01:31:34 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        tung.q.nguyen@dektech.com.au
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH v2] net: tipc: fix possible infoleak in tipc_mon_rcv()
Date:   Tue, 28 Jun 2022 16:31:22 +0800
Message-Id: <20220628083122.26942-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
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

dom_bef is use to cache current domain record only if current domain
exists. But when current domain does not exist, dom_bef will still be used
in mon_identify_lost_members. This may lead to an information leak.

Fix this by adding a memset before using dom_bef.

Fixes: 35c55c9877f8 ("tipc: add neighbor monitoring framework")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---

v2: remove redundant 'dom_bef.member_cnt = 0;'

 net/tipc/monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 2f4d23238a7e..03b5d0b65169 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -534,7 +534,7 @@ void tipc_mon_rcv(struct net *net, void *data, u16 dlen, u32 addr,
 	state->peer_gen = new_gen;
 
 	/* Cache current domain record for later use */
-	dom_bef.member_cnt = 0;
+	memset(&dom_bef, 0, sizeof(dom_bef));
 	dom = peer->domain;
 	if (dom)
 		memcpy(&dom_bef, dom, dom->len);
-- 
2.25.1

