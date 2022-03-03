Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3354CB57E
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 04:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiCCDft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 22:35:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiCCDfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 22:35:47 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC4511E3F3;
        Wed,  2 Mar 2022 19:35:03 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id u1so5702411wrg.11;
        Wed, 02 Mar 2022 19:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=ZkicDJZTVuvTu65ovn3Nc78Li/+ieXuplJO/yWIopgk=;
        b=OSNzxa0cMdfWQn2xDmwaEvhQKMg23H4Q31dAe0cu2erG6xebB70wt4l9x2XBp7S6Eb
         TtJFUxsHZ5VBtLzF7pwmyrZ7CO+kEVl+cMERteWV5+Fw1lPwtzSjYYB4Mm4cEvdAu6xk
         TOiwoxSCr5RWIcPfWaColq+K7nm8705AK82H6hOWB9iMlYq4pAPI3dWwQAmuDV9oSdJF
         dA4y+HkWnvahZ7LvcsEYqG54pg/mY4Q1X7uQxrSFLkWlJzLhHZufJkTmlp890k2O6HAN
         r8k+IqReL0E5po1F2PKK56ciTWJuy+PXq+TfbaiLgs7uWQ3IMr8Iv5Qdkev2bZzbFPNv
         ywYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZkicDJZTVuvTu65ovn3Nc78Li/+ieXuplJO/yWIopgk=;
        b=ai2MuJgPQLFPufisRt3gg/yEaV0dPk8EpR0N1B2MSZbg2K78TmLrqs2HODweoRVbvp
         dD9QiIARTaYL8pqifRJnM5UtV9ukcxnfJjK3/6dqDAtlLOeTFXp0n6D5f105DrksP+UQ
         xQkwaH+drn5152lVzY/bkJZNchQ8HaT6dYoJARE9Dy28+vL5DLFOlNMhye6ES/CCQ8/w
         sH5JJWw3sa+rxmyHR5YE4nBoUBnO9smWqWKgc4Bhc7NS97FLrj1QfpwGAv6NVvGSzwp3
         5f9+wb/64zER0AkpfpXLCQvkvEW3Tri6sJBNVm5RiSsm3zUUVC2ZAscBrTLaWxOFvuH4
         4poA==
X-Gm-Message-State: AOAM5329bv0Nt6Ekx63t0USz21N/HW5AnGx7OI5Fs/+V/vWtC8ikixBU
        LV4J+juB1iabvTPbkXRF5sE=
X-Google-Smtp-Source: ABdhPJxnZ2vYKdh9A6MxQ9xDZEw5cuXZWYhUTaA04Xx6JG3w7IXW0JiEFo7nCMUYZbJMmcev7NVDIw==
X-Received: by 2002:adf:f5c5:0:b0:1ed:bc44:63e4 with SMTP id k5-20020adff5c5000000b001edbc4463e4mr25300125wrp.236.1646278501902;
        Wed, 02 Mar 2022 19:35:01 -0800 (PST)
Received: from localhost.localdomain ([64.64.123.48])
        by smtp.gmail.com with ESMTPSA id n65-20020a1c2744000000b003862bfb509bsm2202706wmn.46.2022.03.02.19.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 19:35:01 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: qlogic: check the return value of dma_alloc_coherent() in qed_vf_hw_prepare()
Date:   Wed,  2 Mar 2022 19:34:50 -0800
Message-Id: <20220303033450.2108-1-baijiaju1990@gmail.com>
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
 drivers/net/ethernet/qlogic/qed/qed_vf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_vf.c b/drivers/net/ethernet/qlogic/qed/qed_vf.c
index 597cd9cd57b5..5786d7ab6310 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_vf.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_vf.c
@@ -513,6 +513,9 @@ int qed_vf_hw_prepare(struct qed_hwfn *p_hwfn)
 						    p_iov->bulletin.size,
 						    &p_iov->bulletin.phys,
 						    GFP_KERNEL);
+	if (!p_iov->bulletin.p_virt)
+		goto free_vf2pf_request;
+
 	DP_VERBOSE(p_hwfn, QED_MSG_IOV,
 		   "VF's bulletin Board [%p virt 0x%llx phys 0x%08x bytes]\n",
 		   p_iov->bulletin.p_virt,
-- 
2.17.1

