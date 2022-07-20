Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7462857B708
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 15:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbiGTNKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 09:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbiGTNKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 09:10:40 -0400
Received: from mail-m964.mail.126.com (mail-m964.mail.126.com [123.126.96.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B7E082A41B
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 06:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=lSmuT
        M75PvagcQie85QvqQNFHT6R/Ri4tR/YhMsOIqo=; b=X39kE1ib3e6ufYm1X+E/Q
        18tH+4+iqCNmBQf/GLzERFRmLSD9a09aN0XMISHYcreQwLbLjJn/sIfK5jsBkL02
        9jqeAkOteR+eG+wIbluAG9C54WUoHiuhntiLHvZ3izzG60X47fInftVeJmb1fDqY
        TNvKIxEYlXkFjSg4hOCHb8=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by smtp9 (Coremail) with SMTP id NeRpCgDXmcas_tdi2aiiGw--.16782S2;
        Wed, 20 Jul 2022 21:10:05 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, windhl@126.com
Subject: [PATCH] net: sungem_phy: Add of_node_put() for reference returned by of_get_parent()
Date:   Wed, 20 Jul 2022 21:10:03 +0800
Message-Id: <20220720131003.1287426-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: NeRpCgDXmcas_tdi2aiiGw--.16782S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7XFyrGw4xXryUur13Ww1xKrg_yoW3ZFb_Wr
        97XFnxZF1UKw1vyFWYv3yavryrt3Z5uFs5CFn2yrWYvw1UZw17trs5ZFnrA3srW3yUA34k
        GF4DuryDA3s2qjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUBWlJUUUUU==
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbi7Q1EF1pEAbtLywAAsX
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bcm5421_init(), we should call of_node_put() for the reference
returned by of_get_parent() which has increased the refcount.

Fixes: 3c326fe9cb7a ("[PATCH] ppc64: Add new PHY to sungem")
Signed-off-by: Liang He <windhl@126.com>
---
 drivers/net/sungem_phy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/sungem_phy.c b/drivers/net/sungem_phy.c
index ff22b6b1c686..36803d932dff 100644
--- a/drivers/net/sungem_phy.c
+++ b/drivers/net/sungem_phy.c
@@ -450,6 +450,7 @@ static int bcm5421_init(struct mii_phy* phy)
 		int can_low_power = 1;
 		if (np == NULL || of_get_property(np, "no-autolowpower", NULL))
 			can_low_power = 0;
+		of_node_put(np);
 		if (can_low_power) {
 			/* Enable automatic low-power */
 			sungem_phy_write(phy, 0x1c, 0x9002);
-- 
2.25.1

