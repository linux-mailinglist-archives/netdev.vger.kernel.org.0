Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950874B8640
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 11:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiBPK4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 05:56:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiBPK4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 05:56:06 -0500
X-Greylist: delayed 379 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Feb 2022 02:55:54 PST
Received: from out203-205-221-190.mail.qq.com (out203-205-221-190.mail.qq.com [203.205.221.190])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A2427B4BA;
        Wed, 16 Feb 2022 02:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1645008952;
        bh=44irEAu7HYsUU1LrOfpuftcIOp/Z1agD6pE0pOXaBuE=;
        h=From:To:Cc:Subject:Date;
        b=vcUzR1Ten3yc6IgpOFoHjFatb84ZfI5cE02Bx0UafpXwEG266qJVXN2OzL6CgsJOl
         IcSmt2ivRO6giAjgljEZMjJJdDp076fthx2rpArlmdmqfXzi/jbFvvQoYqX4nyZzsp
         jsp+CzMsxOH9IBLp2Cji8cvxf+C3LjhXh8Dt+WBs=
Received: from localhost.localdomain ([218.197.153.188])
        by newxmesmtplogicsvrszb6.qq.com (NewEsmtp) with SMTP
        id C10A88E3; Wed, 16 Feb 2022 18:48:16 +0800
X-QQ-mid: xmsmtpt1645008496tfc9na2j0
Message-ID: <tencent_A528B1FF77813031ABE6C6738453F084570A@qq.com>
X-QQ-XMAILINFO: OUyBsK7uGFiXPLpZ43m0FLL7hKXWW5AYRr9ZwLPs81v+g9agswISwcWxa45TWO
         BFGtzf8p/+bjwM5NYyyYIX/IVSy2bVNbtoz/x9D42X7+5wplwvS8h3fnZ5kWOwgFdjQM818oqR8M
         CrbSigYd5RuIu8kJbePf/G7K4ZJttmDsmGG2qHw0dLFvX/mYPDDumiYolVil4+NcXJ5wDzHVUdGJ
         gLkButoxAvqNlmco25JsPIFXoWfXAbFlx0iO2W6xWoXnWu/Y4cJLnJWKCOdtqHJ1wu8x8t7s6ULn
         n551Ox88dydVYVBpnA6c7JdTGPc45YNJDhR4TsMo0ldorlhePXMXfa+97HBonX2ADPkzKuzQiTnw
         xdnLPupSQUfWxaMZYzmbMvesSGhbU22JCDj8sZ9cfIBGIgt3ifwFJuRlOLj/92HsbUVx9/ZfwCN8
         vF5Ko9cznd0JQNxClXGkvRDGOm6beo5VKKMBVvkvdlZMsguSuqYP0J+hxqz524ne03QFKmYHkxLT
         N4fJCaygs1oXYHk/2+S1i9colcbJf+O1OOEo/MemPrmY05tguA7rgF4+EFjs5CrfWYcqvy6q9JSD
         tvwyy16Cta9iGo+AZeuuvKX2SxdcYRx5CCfw+NkHiUfFimoTdikb2EN/iBh1IIIfclUpBor1rqWm
         yJJE4LmvF1NNBdjkVmh4RC1csu0Ibk+IbKrTPkfXIzgtvr7yn8jBSIfQM3W3U9o1hLzg16j1EhzJ
         NOihgGfK4nYSZv0rx8Xag3eCjzXfw6z+TKgytpc0DDfsHR8IOw+cXPjheXhbQV1h+id1/et4t5kj
         kbfC8ldQPMn7n9XfTTF9Dr3uZV+vn8k41Q22QIZ5mDSxq/dsIryLfvjCyTr4OlRq9YjzM3pPVAje
         vQudgLkXNmwZABcb2MEcw=
From:   xkernel.wang@foxmail.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Xiaoke Wang <xkernel.wang@foxmail.com>
Subject: [PATCH] net: ll_temac: check the return value of devm_kmalloc()
Date:   Wed, 16 Feb 2022 18:46:42 +0800
X-OQ-MSGID: <20220216104642.285-1-xkernel.wang@foxmail.com>
X-Mailer: git-send-email 2.33.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

devm_kmalloc() returns a pointer to allocated memory on success, NULL
on failure. While lp->indirect_lock is allocated by devm_kmalloc()
without proper check. It is better to check the value of it to
prevent potential wrong memory access.

Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 463094c..7c5dd39 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1427,6 +1427,11 @@ static int temac_probe(struct platform_device *pdev)
 		lp->indirect_lock = devm_kmalloc(&pdev->dev,
 						 sizeof(*lp->indirect_lock),
 						 GFP_KERNEL);
+		if (!lp->indirect_lock) {
+			dev_err(&pdev->dev,
+				"indirect register lock allocation failed\n");
+			return -ENOMEM;
+		}
 		spin_lock_init(lp->indirect_lock);
 	}
 
-- 
