Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE8159D0B1
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239430AbiHWFpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbiHWFpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:45:41 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0BF5E657;
        Mon, 22 Aug 2022 22:45:40 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id f21so13069096pjt.2;
        Mon, 22 Aug 2022 22:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=DMv/Cp6g1Wy/prezT31JZh8OxuEc+Ivqj+KzocFCZYY=;
        b=DNBi6FtDqClEC5JnQyd52gjLDmwAhRsbvMrhwP2jkwDQ1ymOxytnWJX2bR8+UkLiIO
         iApuSYPB0R/yqZwVqtydvb89K60E+wqjgab9sB3leMDv53DvRWgzEyfTdv4+gt34KbAu
         4yACiCMBfVGr5ticbwTggPwJidSP8UT96kiqXtNSSnkAxf5F3wIVJJoCrfE5dYxtnfQQ
         y8bzq255SOlmJSHe8dS8o9a/PA4aeUYuQsTQvBpbAvGgpt8Mlu3CG3fybayGTRNMubdu
         y7Q0CmUVy0+tlIayEZY3YPKROCmyb2B6v2j0bPXfhN35RivMtIf5e2C8k4XGDPyGOkvx
         wc5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=DMv/Cp6g1Wy/prezT31JZh8OxuEc+Ivqj+KzocFCZYY=;
        b=hG8NChBsOgF6RswZeAgrTu8mY10jY1sVGMWg9USKRIx4OEkrSUamsaOyvtsCslECzP
         PTPldHnCpbQTDujFaNbvgozCE64qDYBq6/LvgLEqHGLF/I/68k6iq2vQaC3YOPRCyj6h
         32EtM7jcoR/JRgTPVeYN0iTR8RHXUH8TrAPahmsipJ+5cFmKhpjzh6QYSz+naDFc1u93
         oTTfS9yC5CgQpt2vboSMH1mUz4LXgaRQpk6AtF376+J5LiYXmV1qqZ0E9ejzfDAObom2
         gvLLCcxoPZbpY23IMC8gA1vLKchBT9cp2r+qnei2BHb/mT1NrJyiORpY/fkOWQI9IkfA
         +IAA==
X-Gm-Message-State: ACgBeo0nA9sLuln/+R7RkZHCVpQL98rKqq0rf1LlzbixGBLlGZelVxe4
        8dolh2/QHe6/bg44C2fgKYbNRxLtxNVJ8g==
X-Google-Smtp-Source: AA6agR7KWb5gnSOZSG0SFpfLEp7o40V9MQXVwJD1Ze0ELTyL6/XvzeaxmE5GSGqYAdxdWfsdONHOFw==
X-Received: by 2002:a17:90a:b302:b0:1fa:ee2f:23a1 with SMTP id d2-20020a17090ab30200b001faee2f23a1mr1755379pjr.81.1661233540068;
        Mon, 22 Aug 2022 22:45:40 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id 9-20020a17090a0e8900b001f56315f9efsm10933519pjx.32.2022.08.22.22.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 22:45:39 -0700 (PDT)
From:   lily <floridsleeves@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, lily <floridsleeves@gmail.com>
Subject: [PATCH v1] net/core/skbuff: Check the return value of skb_copy_bits()
Date:   Mon, 22 Aug 2022 22:44:11 -0700
Message-Id: <20220823054411.1447432-1-floridsleeves@gmail.com>
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

skb_copy_bits() could fail, which requires a check on the return
value.

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
---
 net/core/skbuff.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 974bbbbe7138..5ea1d074a920 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4205,9 +4205,8 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 				SKB_GSO_CB(nskb)->csum_start =
 					skb_headroom(nskb) + doffset;
 			} else {
-				skb_copy_bits(head_skb, offset,
-					      skb_put(nskb, len),
-					      len);
+				if (skb_copy_bits(head_skb, offset, skb_put(nskb, len), len))
+					goto err;
 			}
 			continue;
 		}
-- 
2.25.1

