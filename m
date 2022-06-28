Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA6755E87E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347470AbiF1OyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 10:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347459AbiF1OyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 10:54:10 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E5139A;
        Tue, 28 Jun 2022 07:54:08 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id b26so5688765wrc.2;
        Tue, 28 Jun 2022 07:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l1D/ej0/nC978gwemE1J7bKjwax9zdRenELB/Dp44DU=;
        b=RoVm6ZFftFHJ6zdKmNct/gRFxbvhEkOzLe2D4OjqmZfWV3M+tREP7LTjheZB5zLD91
         XYJIXFgAxfP1EMttzqvhFO6CDk9Q5qB10MCLJHZNo7vjnPkFxAMZgWPlqVGB0HA/xWT6
         ghKCUKqFUYwDjZ4adnlo84bC3gD14irFPfVqOazICHXwe/Pga3pfj22+inrCth/YeCBI
         M6VkNkzBfw8gpn1VU6L/2xvIKYiTFBuSaOiKdBW84KAE9IMdCJszboMsWbzomU8a6AJ9
         iW6V1NaPXFDy/KjqZ+Obikr5oWmsUmt0dRw/3dTyx1B6tEXLXlC3cKddoushEKNAJ5R1
         U2TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l1D/ej0/nC978gwemE1J7bKjwax9zdRenELB/Dp44DU=;
        b=FE2MgyfQhx0Kh5k5J3YuyoQqKDPbn/wMZFk7soJ8IYLBpFiXtdiQ1XMOQ4cYh8hx7R
         OkY0PXkvH1qSFakRutZA4PNr1GR4wb4CHxpVs0yHTw/EqYI4Ty+JBJqtnfFF+gcg1QKZ
         YDghrKCrmuWk6JFgQEHQBiHObwiBtxKrTKFKoaveNwCAnt/6OIim+OqagI0K2u1pFpHj
         IwRYps4IavP8xyur/Ec3z7IDJvZfk5hlk1YpyRp4+tZBqdWTn26gbhTImDEDEj1OD+ZE
         iZKk2cOfWccOd81DawnvlYAo+HLwGlhTCYvesL0Gu2IEZyeVNHLIQno0bsHEtiXikNLe
         7TKg==
X-Gm-Message-State: AJIora+Kl8+URZlRMYwVytNUIwTiV7PLVsltW4/FZvlpjNglLUGb/Iuo
        4Tg897baz5PvE8JXF6Zm3NA=
X-Google-Smtp-Source: AGRyM1vGxRWsvkAmvpjpn8Iv/sQN4WzcqVkLccsIZJQeipUSFtnc/I9qAUSc37nBPH7uqwSXq++W4Q==
X-Received: by 2002:a05:6000:1869:b0:21b:933c:7e2 with SMTP id d9-20020a056000186900b0021b933c07e2mr19221735wri.252.1656428047332;
        Tue, 28 Jun 2022 07:54:07 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id r21-20020a05600c35d500b003a02f957245sm22038617wmq.26.2022.06.28.07.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 07:54:06 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipv6: remove redundant store to value after addition
Date:   Tue, 28 Jun 2022 15:54:06 +0100
Message-Id: <20220628145406.183527-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

There is no need to store the result of the addition back to variable count
after the addition. The store is redundant, replace += with just +

Cleans up clang scan build warning:
warning: Although the value stored to 'count' is used in the enclosing
expression, the value is never actually read from 'count'

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 0be01a4d48c1..1d6f75eef4bd 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5934,7 +5934,7 @@ int rt6_dump_route(struct fib6_info *rt, void *p_arg, unsigned int skip)
 		rcu_read_unlock();
 
 		if (err)
-			return count += w.count;
+			return count + w.count;
 	}
 
 	return -1;
-- 
2.35.3

