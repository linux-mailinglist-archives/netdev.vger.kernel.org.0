Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4954D4CE3EC
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 10:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiCEJPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 04:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiCEJPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 04:15:13 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2AE1D0D43;
        Sat,  5 Mar 2022 01:14:23 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id e24so2946873wrc.10;
        Sat, 05 Mar 2022 01:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=+jcjDvTviayxHNEaO7JzOjjCB/KYKi291VYP63Cxcos=;
        b=bJKP2j6sjNmytp2Q2v59JRaLyVom6Xg6lCxJmB3IrmrdjcbiPzKz1HKS0IQmgLcCsI
         TCpkhSLFDtG7sd2wlXYxJmo4QxoSf/kZ7fsfv5wDAo+gz17DoeVs7KcQoRwcnQNO9ajH
         amdYh9hody/uygb8ZjtWt6RdnMsjcr+rjD5yi2r/VRcannMDWPL3RlKyWSgW4kQdJpse
         Fcm6E8k703oBEYfQM0dq2W8fzZPVZJ8dwvQ81GYb4Ccm7gyBNjymj7F/Uj6J+QU3DMFT
         Qb1QjDhP8c1vW/xMF/sKgJCwkf1Ya93DKZhJzO1qKmaur0R/AInzYeVID8rxRWjBll/8
         Lagw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+jcjDvTviayxHNEaO7JzOjjCB/KYKi291VYP63Cxcos=;
        b=RXlv7FrHa/myCZVtMOT922v2tvmQ6d2bcXFJ1/4yR1Z45joVVP0jRMYK688IAUpjhH
         Yfrf89k0qlX02KSnJvBt7EDJVSYXaWzrbY/g6v3tqwJ5KRmaQ3OFTJPw0OuTmqYYDwol
         n3QB3KaeF3oQc6poChWCsuSDWUpwrTjRwEN6pHpYR52S8QbTq6v0AEOFa7pRWr1V/ig7
         Sj4HSDcwpT0kOzN13j0G687EbhaTQimIxG+3iPY+7WaZqpqRg8nvvniPX2AC5dgZRFzj
         gjv0UVGRgPp/w9bqIMM6WNb/QJIM1AWKVs0mCsh+U83BrborwAmg7/t+1lmZ0JH3hvXH
         mF7Q==
X-Gm-Message-State: AOAM532vEmZoZXyYp4ppy0OazD4UxXd3LbUQ6maePg3HqNhmKQ8UaOQb
        qJqTuZdcGSaKai+Um11nHtU=
X-Google-Smtp-Source: ABdhPJx869HHhgMXyV5vDaAg0IoJVZaELTeiBdvjqAhlGJt/+nmUxCVxEUyA5dv9/XnnzAezh4vI8g==
X-Received: by 2002:adf:a48b:0:b0:1f1:e16f:3c4f with SMTP id g11-20020adfa48b000000b001f1e16f3c4fmr1256862wrb.176.1646471662016;
        Sat, 05 Mar 2022 01:14:22 -0800 (PST)
Received: from localhost.localdomain ([64.64.123.48])
        by smtp.gmail.com with ESMTPSA id l10-20020a056000022a00b001f017dfb5cdsm8570394wrz.90.2022.03.05.01.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 01:14:21 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH v2] net: qlogic: check the return value of dma_alloc_coherent() in qed_vf_hw_prepare()
Date:   Sat,  5 Mar 2022 01:14:11 -0800
Message-Id: <20220305091411.18255-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function dma_alloc_coherent() in qed_vf_hw_prepare() can fail, so
its return value should be checked.

Fixes: 1408cc1fa48c ("qed: Introduce VFs")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
v2:
* Fix a memory leak of p_iov->pf2vf_reply in error handling code.
  Thank Jakub for good advice.

---
 drivers/net/ethernet/qlogic/qed/qed_vf.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_vf.c b/drivers/net/ethernet/qlogic/qed/qed_vf.c
index 597cd9cd57b5..7b0e390c0b07 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_vf.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_vf.c
@@ -513,6 +513,9 @@ int qed_vf_hw_prepare(struct qed_hwfn *p_hwfn)
 						    p_iov->bulletin.size,
 						    &p_iov->bulletin.phys,
 						    GFP_KERNEL);
+	if (!p_iov->bulletin.p_virt)
+		goto free_pf2vf_reply;
+
 	DP_VERBOSE(p_hwfn, QED_MSG_IOV,
 		   "VF's bulletin Board [%p virt 0x%llx phys 0x%08x bytes]\n",
 		   p_iov->bulletin.p_virt,
@@ -552,6 +555,10 @@ int qed_vf_hw_prepare(struct qed_hwfn *p_hwfn)
 
 	return rc;
 
+free_pf2vf_reply:
+	dma_free_coherent(&p_hwfn->cdev->pdev->dev,
+			  sizeof(union pfvf_tlvs),
+			  p_iov->pf2vf_reply, p_iov->pf2vf_reply_phys);
 free_vf2pf_request:
 	dma_free_coherent(&p_hwfn->cdev->pdev->dev,
 			  sizeof(union vfpf_tlvs),
-- 
2.17.1

