Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168AA5BBB22
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 03:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiIRBzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 21:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiIRBzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 21:55:12 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E09C12D1E;
        Sat, 17 Sep 2022 18:55:10 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso4021465pjq.1;
        Sat, 17 Sep 2022 18:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=XHN5cGZNT0Mc1WiNTDqhbkIEYyJhwQWVW34NwsuZveY=;
        b=QSHtYYigKVwfSJQ6DP+KGjpL4OiZ2hVDs+Thh526SpBdUCfX9jsai2WEVnd8ivoKN3
         omMjWX7f7T43/5MJSCPjWIkTWxFoUBSjqAFTh8cHcCmJ6+q7SKLAbfCLp50Vea1DogTh
         uhv3C1XuA6vxHj5VG0KoM5abkuAG6ahPHNZQfE7yyy/3D+Rirxv+XT1KfOn0tiSW00F6
         YCwbT4Twrm6wQO7rWH0TxphB0Ml/iR0pDE/sysien149lGUWoyYgN9r5+hWwHw/SmbBl
         O7fHN0nwU7kZpQ6+jQREMJg1IApp99onmrG1jDWIyieRfwYiIjL9dYGiir6KzLACXaGZ
         eI0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=XHN5cGZNT0Mc1WiNTDqhbkIEYyJhwQWVW34NwsuZveY=;
        b=g16suYRzOdQHYvFC+05jAxOpuPhKghX0Q+AN9cduxlEN2JHThAUL7D1kX0t5CtN0gu
         Kfi9wuM16uzEsR+hNz+tKqAd4Tyw+Hd39lamU+LAmdFQAFQI/99/aUAx/6iIgtbQmHTC
         1sUXS5zGhhW41fHUz7afG956Ddxo7nWO8uQ4UW1ZUvgYyS5IqYsiORHqpFXV0/I8bthz
         09yADeN7b+toPFa0KNN0ibMxH3ndouZ5Q6TRDCtT6xybfcwTzr/c8ixwG2U/4LW2dLPb
         R7uCFLq5+BqCFCxh8CIl/cseEuj+dmMoj4Jilr1sEbNIXNgeusggrIvwD01fa25k9CEZ
         UGTg==
X-Gm-Message-State: ACrzQf1fCPQxcSL9qiQaU8KoTQr8iIS7v9ZxPq4TdS75JyKeMWjmhSgB
        6nQEwv1Peyw5vg0Kmory2DzPg3gQtYp/sQ==
X-Google-Smtp-Source: AMsMyM5fLpjvfiQRmrZ4zSxLSq7pD/FPlm3Y4ERjZknzwa5KZbNRVo/IvOYCBZou/EsdL10HUKddMg==
X-Received: by 2002:a17:903:2346:b0:178:4c17:eef7 with SMTP id c6-20020a170903234600b001784c17eef7mr6738088plh.30.1663466109246;
        Sat, 17 Sep 2022 18:55:09 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id f1-20020a170902f38100b001789b724712sm182178ple.232.2022.09.17.18.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 18:55:08 -0700 (PDT)
From:   Li Zhong <floridsleeves@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, Li Zhong <floridsleeves@gmail.com>
Subject: [PATCH v1] net/ethtool/tunnels: Check return value of nla_nest_start()
Date:   Sat, 17 Sep 2022 18:54:54 -0700
Message-Id: <20220918015454.672485-1-floridsleeves@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return value of nla_nest_start() could be null on error. We need to
check it before we pass entry to nla_nest_end().

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
---
 net/ethtool/tunnels.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/tunnels.c b/net/ethtool/tunnels.c
index efde33536687..2d6b03a35dd9 100644
--- a/net/ethtool/tunnels.c
+++ b/net/ethtool/tunnels.c
@@ -140,7 +140,7 @@ ethnl_tunnel_info_fill_reply(const struct ethnl_req_info *req_base,
 		if (nla_put_be16(skb, ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT,
 				 htons(IANA_VXLAN_UDP_PORT)) ||
 		    nla_put_u32(skb, ETHTOOL_A_TUNNEL_UDP_ENTRY_TYPE,
-				ilog2(UDP_TUNNEL_TYPE_VXLAN)))
+				ilog2(UDP_TUNNEL_TYPE_VXLAN)) || !entry)
 			goto err_cancel_entry;
 
 		nla_nest_end(skb, entry);
-- 
2.25.1

