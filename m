Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9784855D82C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243706AbiF1Duj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 23:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242883AbiF1Dui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 23:50:38 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF5B65C4;
        Mon, 27 Jun 2022 20:50:37 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id 65so10807215pfw.11;
        Mon, 27 Jun 2022 20:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2mE67TKZ7nV6LNm2sosBHj70/Sv9GsuCCC7o3MxRk4s=;
        b=FFRTmbKqeJhxROs5kn2b9HWN8ZFs2rpCIBEcPoG6wWM1lbNkqPIm7RjA/F47NkFQNB
         3Lpvo5fRx2Wl9gCxI++SlwF+PLBEVhy0BITz5o0vRF7HenuRuZVunz8onH/R2GVY123N
         vZ1emQ7SfxObvDTvq6chp0qdnbvdIWM5+LjG8PRC1EQe5NjQ21JzTIIVdvFoJTrJcKOv
         avhDCrF6T1sh1IZsxrl/DW6GhOvFSqqrMXI8ttPlWuNg72UGZni7nGW91L9ix7boFZXv
         +8o7Wn1wsjWXIWuA0BFbK6Ikr0W8LrSPRz+DZuAedJsebnu7Xdf2YVQtE7Aws43JE2Ur
         XkGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2mE67TKZ7nV6LNm2sosBHj70/Sv9GsuCCC7o3MxRk4s=;
        b=ijpL0chToofMRbI8lcXM/0iUODaF3JZLYmQTKvZ4d3FGdzIDKkIhxBr1vkM+4ToQ++
         BVBmqw10RDnJKe+GR61Z4NdcpBptDj4wyahdD7cKMyCgqaKc+vZPVYESgOgu3+wbE/zg
         1dH4E0Mu5Nd4hV4D1sukmIDeWOEvBt82mXnyHYxAwgS5Uh6RYA8sM8XsKYqBKOgTCRvp
         Q4yOaEu+VdAv7qFq+ibvsdbtprGxPC80suVG6/YReb+r8ylx5JOez7BrozgFHe1TojOo
         krfnfPFHpNuAmr1hc+4z9tUMd1wnoQ03fChVV8RiXz783yF8ChIWglh5WDO7vjIBY7hv
         VUOw==
X-Gm-Message-State: AJIora9/M+z/eASGtym3zBt6eScmpaEOsVaaTg9F3op1HCEUJ75Yu+KT
        nZrDROip1SR4qoLIVY/vtgWH9vfJ2tI/iam+
X-Google-Smtp-Source: AGRyM1voI8ENcbSgwb3J7hytezZA6KI6pxn3znSL3YJ8TfQl5USbQU40mm75g74ktSiscHmCBlL2Kg==
X-Received: by 2002:a05:6a02:117:b0:3fa:de2:357a with SMTP id bg23-20020a056a02011700b003fa0de2357amr15380795pgb.169.1656388236687;
        Mon, 27 Jun 2022 20:50:36 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id v187-20020a6261c4000000b005255f5d8f9fsm8150739pfb.112.2022.06.27.20.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 20:50:36 -0700 (PDT)
From:   zys.zljxml@gmail.com
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org
Cc:     dsahern@kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, eric.dumazet@gmail.com, pabeni@redhat.com,
        katrinzhou <katrinzhou@tencent.com>
Subject: [PATCH v3] ipv6/sit: fix ipip6_tunnel_get_prl return value
Date:   Tue, 28 Jun 2022 11:50:30 +0800
Message-Id: <20220628035030.1039171-1-zys.zljxml@gmail.com>
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

When kcalloc fails, ipip6_tunnel_get_prl() should return -ENOMEM.
Move the position of label "out" to return correctly.

Addresses-Coverity: ("Unused value")
Fixes: 300aaeeaab5f ("[IPV6] SIT: Add SIOCGETPRL ioctl to get/dump PRL.")
Signed-off-by: katrinzhou <katrinzhou@tencent.com>
---

Changes in v2:
- Move the position of label "out"

Changes in v3:
- Modify commit message

 net/ipv6/sit.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index c0b138c20992..6bcd5e419a08 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -323,8 +323,6 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 		kcalloc(cmax, sizeof(*kp), GFP_KERNEL_ACCOUNT | __GFP_NOWARN) :
 		NULL;
 
-	rcu_read_lock();
-
 	ca = min(t->prl_count, cmax);
 
 	if (!kp) {
@@ -341,7 +339,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 		}
 	}
 
-	c = 0;
+	rcu_read_lock();
 	for_each_prl_rcu(t->prl) {
 		if (c >= cmax)
 			break;
@@ -353,7 +351,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 		if (kprl.addr != htonl(INADDR_ANY))
 			break;
 	}
-out:
+
 	rcu_read_unlock();
 
 	len = sizeof(*kp) * c;
@@ -362,7 +360,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ip_tunnel_prl __u
 		ret = -EFAULT;
 
 	kfree(kp);
-
+out:
 	return ret;
 }
 
-- 
2.27.0

