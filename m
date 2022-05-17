Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197C95296BA
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 03:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbiEQBad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 21:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiEQBac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 21:30:32 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACD845AD1
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 18:30:32 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id ej7so1378052qvb.13
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 18:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oiJDKckqHYmWe5sIgItdbM+eYa/JdgHnsnbYaNGv7BQ=;
        b=Iil+/oLC9IVEVOXCx8AOjbsAcAlKHNV73ssEQzUkEorvcsut9eJtuxs4wpvX80SAkf
         +jmFX6IvWCzVDbrms8wuet5/O3HX2h/NLFqX5pHXRZkgYlS8qjcGCUYBzTDqRSvSiOJz
         vEcrPiFOeznLduSNxzFj1xjfrw4xNZrwtNkoasKagEDkyAX5/WCr03a8wWVFY8HWX38f
         Buruyyj5ONNsoQlUAFbyCo6z1Ph7z8WUW1gF31PMloTnUx4gpYhEHFP5Ywep7IpkLMEy
         bL1MojtLk2fPNozsbeAhb17GM2Fm2BZltiU4pyceccez9lO8Yk81jcIMesbI6wSCCr6d
         8+aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oiJDKckqHYmWe5sIgItdbM+eYa/JdgHnsnbYaNGv7BQ=;
        b=r80vmFv3zMqsnMiVg3YlWJXz38MRYJifCEIlhfiIULSNiQN9M8/NjK3Q123nO1toSa
         Uchs6p7yYEPhMGRbLpa1+rSSTvhZmekFBkgq6/SIH2EFVnOgpTmjWA+Qr2fC35M4tTKp
         uql/Rh9SEMg5dfzEUdd0QonN/apaTqHurdkw4tMWMhLRtJjWeC2vL+rLFnzfDsgMot70
         rJS0i24HGfdP2QCrFvzXAeQkzEkOxyqPQ7mQVe4Xyz2JFV2mSIGjSMdCozCMfxi0smL9
         x8avEsxxuWurKKvotJ1SDEVpxK8w4HcMSY5bdyYeBDswp0C1panoBrDk+2VxSfg2OFII
         4XCw==
X-Gm-Message-State: AOAM533F+jg3BhhoY0vzMrLrk4gAt+JwDg7jS8wnhP9+ML0W7kThVJqI
        PMoefe+4IaB8UVXmwMxEj3DesUJPmp4QAg==
X-Google-Smtp-Source: ABdhPJwFen3g1b+Y+USWnJhDWjLL/IgShtGJUiHCJHPrDvLZXMJujbo3aJwSKGCsyj4vG56LI2Pvtg==
X-Received: by 2002:a05:6214:21af:b0:45b:ab2:6cf7 with SMTP id t15-20020a05621421af00b0045b0ab26cf7mr18070715qvc.0.1652751030998;
        Mon, 16 May 2022 18:30:30 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id g23-20020a05620a109700b0069fc13ce1e9sm6844454qkk.26.2022.05.16.18.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 18:30:30 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCHv2 net-next] dn_route: set rt neigh to blackhole_netdev instead of loopback_dev in ifdown
Date:   Mon, 16 May 2022 21:30:29 -0400
Message-Id: <0cdf10e5a4af509024f08644919121fb71645bc2.1652751029.git.lucien.xin@gmail.com>
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

v1->v2:
  - remove the improper fixes tag as Eric noticed.
  - aim at net-next.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/decnet/dn_route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index d1d78a463a06..552a53f1d5d0 100644
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

