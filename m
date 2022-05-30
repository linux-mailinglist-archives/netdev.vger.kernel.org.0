Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9466053791C
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbiE3KVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 06:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234884AbiE3KVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 06:21:05 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03017C156;
        Mon, 30 May 2022 03:21:04 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id h1so734389plf.11;
        Mon, 30 May 2022 03:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WFiLnT3W0j8YmQ0vGQC0wNX6AZ3ylQaFctxEdup2GHM=;
        b=UX2JZrN6MoAhDt/j+Zn9ZOZyPHpUxAF4IPjUZHmNkR0VuZau1KdXma4z1quyinbDa+
         j1XqTYlnXl/VM4nKoWwGGpsdtGf10qFomEJBmLGrscpa3bh4hullTu1Xv8gkgGe9zu4K
         DYjEY409DHg9hgQn3CDLrEDWs6+PIvoLqOrJbn9y+8+0ZkTfipIvwwpynkX24rr/jy4O
         GtP51+zWNtZh6UcsNNsWjkMI4ctY6j25po81UVqxdKSAdEoRSiMNGAGIZIk91T2zJVjz
         isppPI+1LZks7ygPZIBXbAlVommKkd10UU24SpBSHLf4F6jlu4jXDKPTzXsF1TqOoGd4
         Eovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WFiLnT3W0j8YmQ0vGQC0wNX6AZ3ylQaFctxEdup2GHM=;
        b=cETzjROe6j3kvOk0n1a7OMNg2PXhCQYT7sbuzBXzTjfDtjOEbvbD1vbkUADweThKnT
         7sdh8Zy3p4rNJ23wiTt2YBZgXbvcsvydFYvNEJi+QYpWNTYGWv28MSrOZ53VtcX3L9dp
         ozkyXhX8opzxxdqbnITNmFqQsBkDbuxWskyjoUcA27vmKKyKde9Bno/3Yex1pbXSxbaB
         pfspuEpJBTgb2PqS42dnrwRHlioc7kB//t2yAR8dLT+0SJ83hvli74YrDX0itmb/35ut
         fOaF0fGqRUb3d6slOSvt8shb/RN0234VTpEGEs28kV34VAsXX0e8LCM/V4stjUNvOamT
         cjzA==
X-Gm-Message-State: AOAM531kDCeSaU5Ax+lpUpaITzd0MpPV0SKhhNVoTtaJ132+ZXHjl0nQ
        NfZocfo2+1wPs7S53LPuuVLGkGHKhVXU2w==
X-Google-Smtp-Source: ABdhPJy+3XPSzi01KJqkr8y6fTyshXo/Ufa+RXFCY+n/Bj4tzOg/364b3UZt9n+2PSJsOvSL4al8xA==
X-Received: by 2002:a17:90b:3b46:b0:1e2:f8a2:cd03 with SMTP id ot6-20020a17090b3b4600b001e2f8a2cd03mr5115415pjb.229.1653906064375;
        Mon, 30 May 2022 03:21:04 -0700 (PDT)
Received: from localhost.localdomain ([103.84.139.165])
        by smtp.gmail.com with ESMTPSA id j18-20020aa783d2000000b00518a9c82d28sm8450275pfn.21.2022.05.30.03.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 03:21:04 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] xfrm: xfrm_input: fix a possible memory leak in xfrm_input()
Date:   Mon, 30 May 2022 18:20:46 +0800
Message-Id: <20220530102046.41249-1-hbh25y@gmail.com>
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

xfrm_input needs to handle skb internally. But skb is not freed When
xo->flags & XFRM_GRO == 0 and decaps == 0.

Fixes: 7785bba299a8 ("esp: Add a software GRO codepath")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 net/xfrm/xfrm_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 144238a50f3d..6f9576352f30 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -742,7 +742,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			gro_cells_receive(&gro_cells, skb);
 			return err;
 		}
-
+		kfree_skb(skb);
 		return err;
 	}
 
-- 
2.25.1

