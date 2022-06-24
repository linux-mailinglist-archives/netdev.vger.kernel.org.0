Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0466559529
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 10:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiFXIND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 04:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiFXINC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 04:13:02 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD6665E8;
        Fri, 24 Jun 2022 01:13:00 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id n16-20020a17090ade9000b001ed15b37424so2087944pjv.3;
        Fri, 24 Jun 2022 01:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5AbbIy759o/Iqe1P9OHT5ftFcpaWtdvxPS9b7YlrKZ4=;
        b=WtMzW7YXzI15QW7XTko1pw5/dFcC1X37MeT2M//UW9Mv6Ngr727tBHNNz2EF8pQ8QT
         aJxQlSp6aYKt6dlDPr4kczQLndgM2qdm7pS8wDcHCbIMyrkYHl1GnmVoAnDU5QX+WBy8
         BfSx514DvpTYvWqofWZXfXpYzxx/HC+pz2HcLUepvoFm3sSIFpKUy1tHesEUw92JjUx0
         3IOYHS/gQYf/rMFKpTVGdBlcN81GhRl4/bdBIWjrWtCaBx6X8CY/IIO+W84oI2zrbBaV
         u5FtC4uoqy6mKoeVDE8niYMYI0yeyG/2pCUHOPNATqOQ345KZl3Av9hs28D69MdMZHUV
         fdHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5AbbIy759o/Iqe1P9OHT5ftFcpaWtdvxPS9b7YlrKZ4=;
        b=iZT4yTKedBdYgg57oipKWBF96ksWrX4zIDSgiPR5TJ34JV6p9lwAwp3yyw8iRnvZEt
         PHCemqpWxoQQTz2OsX8XX+CpTqNhnzEoRHTeHLFYuStli6J5SgKsusm/H0Gs7Nl7Dr8u
         tgyuGcvJDwZXj3oIqzSKa1XgCAWQlV3SYPIdMO1cmKCzY3SEY3XB71B8+fFaYvpwa/Pb
         ZU2cuxbrg1ST6ob0g/bkgf9eilYPsk6/bTKVZKzmOPPiobQ6W4SdNrgUXSEp/u0B6j4E
         HgM6suh9deXGLCsVi8QJHwugDC+6XP2Yzq1zQAqTh3vIhAxf/1Z+31bYii87AntoRNQB
         PGjA==
X-Gm-Message-State: AJIora841JilHfn8vc35JNeE54hJIMkagPq/nw9q0RJAFDklBgA/2LMl
        K2xIXfqPktpsdwXAxs7h5nxMtN5p2+w4AA==
X-Google-Smtp-Source: AGRyM1vvQESFnIM7BOcBApZsUqQJehNOrF5HB5doGEwk2ExbTmM5fw5qW4nulvaADcSzOb5CP8k8WA==
X-Received: by 2002:a17:902:c40a:b0:163:d38e:3049 with SMTP id k10-20020a170902c40a00b00163d38e3049mr42926852plk.87.1656058379871;
        Fri, 24 Jun 2022 01:12:59 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id f10-20020a631f0a000000b003fbb455040dsm945846pgf.84.2022.06.24.01.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 01:12:59 -0700 (PDT)
From:   zys.zljxml@gmail.com
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org
Cc:     dsahern@kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, eric.dumazet@gmail.com, pabeni@redhat.com,
        katrinzhou <katrinzhou@tencent.com>
Subject: [PATCH] ipv6/sit: fix ipip6_tunnel_get_prl when memory allocation fails
Date:   Fri, 24 Jun 2022 16:12:54 +0800
Message-Id: <20220624081254.1251316-1-zys.zljxml@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: katrinzhou <katrinzhou@tencent.com>

Fix an illegal copy_to_user() attempt when the system fails to
allocate memory for prl due to a lack of memory.

Addresses-Coverity: ("Unused value")
Fixes: 300aaeeaab5f ("[IPV6] SIT: Add SIOCGETPRL ioctl to get/dump PRL.")
Signed-off-by: katrinzhou <katrinzhou@tencent.com>
---
 net/ipv6/sit.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index c0b138c20992..4fb84c0b30be 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -323,8 +323,6 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 		kcalloc(cmax, sizeof(*kp), GFP_KERNEL_ACCOUNT | __GFP_NOWARN) :
 		NULL;
 
-	rcu_read_lock();
-
 	ca = min(t->prl_count, cmax);
 
 	if (!kp) {
@@ -337,11 +335,12 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 					      __GFP_NOWARN);
 		if (!kp) {
 			ret = -ENOMEM;
-			goto out;
+			goto err;
 		}
 	}
 
 	c = 0;
+	rcu_read_lock();
 	for_each_prl_rcu(t->prl) {
 		if (c >= cmax)
 			break;
@@ -362,7 +361,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 		ret = -EFAULT;
 
 	kfree(kp);
-
+err:
 	return ret;
 }
 
-- 
2.27.0

