Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91749527B69
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 03:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239102AbiEPBhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 21:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiEPBhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 21:37:34 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5573413F41
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 18:37:33 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id c1so11297150qkf.13
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 18:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SYwbZ+ApqE7uxQRIzyLXQScAj7rfAoFNwe9aJH7YGb4=;
        b=ONHBsrlvIA89D8f3ceS0Ix61+8FSe9MvP/IBpsL+l73+TuGfIKFFHdsCg9k4iYs2zE
         2VIJ461s751zz312dI/dkwMJSHaauBxAaRzCKtJMtFJVB2oyto3B+5G9bD0fGCD8t67s
         1Le3OUA2sucgnlHiNjWe4dkq/tAdaZvXLQrjiDzb4besUbiOLomagVpaoqQSFOlmiS3E
         3lzaKTAv8UYzm6kAqD6c6ISz6ahUyP28bdy0gbCqdgclWt7iYq+AYWjjwQkMdhO7oWBt
         lzzPRD6YPpoQwm0Eu6kBvhFaA9pkukuB/oen6rTgd5GsA1Z86kZ1eEJ+WisdFz2Ztx6g
         LlJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SYwbZ+ApqE7uxQRIzyLXQScAj7rfAoFNwe9aJH7YGb4=;
        b=6OnWL8AoZCAuhYurpHEbd64KlweZ+mRKh/OkfwUTcHrpO542rmBNpR+cTsK9cUCUr2
         cST/o6C8stJDNK9wh12qULaV0Q3dkri5DNQ8Gtyss67EmnEfCpkONJ2GdSXv4d7w5c6S
         ghcgNKkL13YZ9gxX7kqsbnfhNS1o7I6w5r0n2h4sJBp1x1ktnScTJKiAxvD7oxxwisCh
         4Iy6VpRZFQZ59q7Ej1z+/RUvZR1NwUjHAsqtATD2LzFwnZ6RakO27AnoZvOMCBUF+uTn
         67ygHhTgIJH/j21UW9LHezSpDNxGyC9man2X6Th/iUAoQOMATk5uj+mA71d9zmDfGiQD
         bRaQ==
X-Gm-Message-State: AOAM533u1zif4v+KnKiOjgJlk2kPzCtwe4e3n9Wrvfkj+AgMcP8qHKR3
        qW7G/9n7CwcTds4UQnBGk1Gg5Y40wwq0zA==
X-Google-Smtp-Source: ABdhPJz7SyE3eeMmTWBFpqf2hZk5KUMy1DFVTQaMSm/Erm+RfXB39OnHbEOBWbKUhQTLTqyAEUn5cw==
X-Received: by 2002:a37:5ec1:0:b0:69f:9c38:6791 with SMTP id s184-20020a375ec1000000b0069f9c386791mr10797935qkb.46.1652665052220;
        Sun, 15 May 2022 18:37:32 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id cg5-20020a05622a408500b002f77a8bc37fsm2643720qtb.51.2022.05.15.18.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 18:37:31 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] dn_route: set rt neigh to blackhole_netdev instead of loopback_dev in ifdown
Date:   Sun, 15 May 2022 21:37:31 -0400
Message-Id: <68cf685582fe02e86d5320c9048faeb3d2b5a833.1652665051.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

Like other places in ipv4/6 dst ifdown, change to use blackhole_netdev
instead of pernet loopback_dev in dn dst ifdown.

Since commit faab39f63c1f ("net: allow out-of-order netdev
unregistration"), in .ifdown it's been no longer safe to use loopback_dev
that may be freed before other netdev.

Fixes: faab39f63c1f ("net: allow out-of-order netdev unregistration")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/decnet/dn_route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index 7e85f2a1ae25..99cc52e672b3 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -159,7 +159,7 @@ static void dn_dst_ifdown(struct dst_entry *dst, struct net_device *dev, int how
 		struct neighbour *n = rt->n;
 
 		if (n && n->dev == dev) {
-			n->dev = dev_net(dev)->loopback_dev;
+			n->dev = blackhole_netdev;
 			dev_hold(n->dev);
 			dev_put(dev);
 		}
-- 
2.31.1

