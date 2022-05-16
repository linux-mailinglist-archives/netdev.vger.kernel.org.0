Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD8A527B68
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 03:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236889AbiEPBhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 21:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiEPBhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 21:37:31 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9276013F2E
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 18:37:30 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id a76so11309642qkg.12
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 18:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J/DdmzrMlcg3mU74L3fubFKVXHzEFCLzLBdMOpUzAss=;
        b=p3yaBGOImdBq3pEwIbnRy4c+HdkkVD2QHRk82+0xcaQrB84Dedq9SAJu4lqZ3gW00v
         ofuP/9Yzzi017wU6HAB8PSgGwHtVDbak6zCsw9MEXi1c0e1u8TJvnEuFPe3+S6foSgP8
         ZgmZE/EkmMG8LG7/k0tmvBMeiT9bq/ms+XU7SnW23P13/rGTYVK2cBtfTTvI+hBZaGts
         mhEuE7rovPZTaWHWLu9v4IoYAApMw+1DUURMXjPs0m89BCFcCLgnDKqF1g2k4hIb28VQ
         1c0e5QPyzWY2xu2VhPH4vgAlfBJO3S0tDnNKsPUPNchUo/BYpy/x2xkOqXdE9Ojk65t+
         P8Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J/DdmzrMlcg3mU74L3fubFKVXHzEFCLzLBdMOpUzAss=;
        b=owv9D5vsOFhL3TVjPTeYeCpcU63nEJQj2s4VGT7T1FEyU4axbKQfJ5oGQEqsA/5KBt
         WTzAM7Ri9l0BAy4nuKpHLKCMfI/Icnk80tfRf0fJb6UI5FSIE0Z/PJ3YU71XiLyzwo2i
         Wf+I1j7Nj9DDKa0vv4WYZkeTh60C5njyRlzXYSw/6EcffXHZLkQReQyJ3/yms8t57Kzm
         0J4KbcD0H5+9XAHZhWK6C1/Uw3PUVmWkcHI+T7qJ0ZjMWopkJ9BnGBK336v/B04w2cKB
         FdYE4yvG/Vj2y+Y/DKuPZr4IydnWLGzivtDVU9AYWfNvSKektPWE1yqy1Pq8dT4usULz
         uU3A==
X-Gm-Message-State: AOAM532XpBft01Or2x1lpbeeKFgIDtGHgPr78Wp65we8grrS9JBqX5Pp
        qfVGfzV5elOpPs+TD4jkpXPNJEoUgSkR7g==
X-Google-Smtp-Source: ABdhPJyjgyhCPYABO+lO62+Kul1JZd6jcEFqiMF7egwtsU0yZHLezUW6n2DxlICSF8IHmYVwQUm3rA==
X-Received: by 2002:a05:620a:170d:b0:6a0:8983:a697 with SMTP id az13-20020a05620a170d00b006a08983a697mr10612400qkb.411.1652665049065;
        Sun, 15 May 2022 18:37:29 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id h20-20020ac87d54000000b002f8f406338fsm931891qtb.42.2022.05.15.18.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 May 2022 18:37:28 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCHv2 ipsec] xfrm: set dst dev to blackhole_netdev instead of loopback_dev in ifdown
Date:   Sun, 15 May 2022 21:37:27 -0400
Message-Id: <e8c87482998ca6fcdab214f5a9d582899ec0c648.1652665047.git.lucien.xin@gmail.com>
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

The global blackhole_netdev has replaced pernet loopback_dev to become the
one given to the object that holds an netdev when ifdown in many places of
ipv4 and ipv6 since commit 8d7017fd621d ("blackhole_netdev: use
blackhole_netdev to invalidate dst entries").

Especially after commit faab39f63c1f ("net: allow out-of-order netdev
unregistration"), it's no longer safe to use loopback_dev that may be
freed before other netdev.

This patch is to set dst dev to blackhole_netdev instead of loopback_dev
in ifdown.

v1->v2:
  - add Fixes tag as Eric suggested.

Fixes: faab39f63c1f ("net: allow out-of-order netdev unregistration")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 00bd0ecff5a1..f1876ea61fdc 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3744,7 +3744,7 @@ static int stale_bundle(struct dst_entry *dst)
 void xfrm_dst_ifdown(struct dst_entry *dst, struct net_device *dev)
 {
 	while ((dst = xfrm_dst_child(dst)) && dst->xfrm && dst->dev == dev) {
-		dst->dev = dev_net(dev)->loopback_dev;
+		dst->dev = blackhole_netdev;
 		dev_hold(dst->dev);
 		dev_put(dev);
 	}
-- 
2.31.1

