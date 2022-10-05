Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1475F5B9F
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 23:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbiJEVWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 17:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiJEVWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 17:22:53 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661985AC45
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 14:22:52 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d10so113929pfh.6
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 14:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=KYs5i1UtSKwff4LZqDYKTEYs6XamWF2jUJRPKUQ5EPA=;
        b=ENPx/W4zknC86eh1Xu472j51UA6rXQLfRPei8R9uLnX/hDyDxXhjrA8v6zygagjyqD
         9Mzgfovzgler6FWxpHIiYHsczVBQn1xlB9OV2qB4Cl/6pA9tGDxOix/cmhMimB1G5Mob
         w1xT1zN1REtpO2ModVqkNHoKoyKTbwcILCKpU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=KYs5i1UtSKwff4LZqDYKTEYs6XamWF2jUJRPKUQ5EPA=;
        b=ZBAX4nmA/XzJCsvA2mIdVBDmETezQFnh+1lYN7aZWYCXRA4A0eaxPS3Ua5POrtglIW
         NlldjOMhyXfOLtcCz3N8wfS/nHFnbsee6MmBLLH0Ke7WbTTd8RNzWp9BPJQAdSA286SD
         ONciN0emBXoPDYxVwoUE1HiOGNFsnlY/d15TSyAbdxAnA2FOo9AIkmLu7kSaVPghHAjd
         /0L3j8G7ihW6Rjo7GaQUOMPB6a+4NJ9sAcwC9gUJ31uuHY/avfcB3NfFEZEnuIMBdMVw
         9Amq20M/TgMvSylvsdm/VafuJR4PZ42mmcKcM0WXGdCdMTm+eVnb6vsT+cMF13aZgYXp
         43/w==
X-Gm-Message-State: ACrzQf1kj+oFd9n7i9/+6i6zfEj7xjc3EX7tkRJEXrCZmevU3AoRYz8z
        0Llgor4O18GlTFoR+ao9IpSb/A==
X-Google-Smtp-Source: AMsMyM6F/34DajcuFO5ZPtDyGeavPnnhWjOSTOEt+ArQFZVEWUxxDvySBHX1+F76e25DGu8FU97rxw==
X-Received: by 2002:a63:90c1:0:b0:450:75b5:29fe with SMTP id a184-20020a6390c1000000b0045075b529femr1465586pge.541.1665004971939;
        Wed, 05 Oct 2022 14:22:51 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902dacc00b0017f7b6e970esm2404666plx.146.2022.10.05.14.22.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Oct 2022 14:22:51 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        maciej.fijalkowski@intel.com, Joe Damato <jdamato@fastly.com>
Subject: [next-queue v2 1/4] i40e: Store the irq number in i40e_q_vector
Date:   Wed,  5 Oct 2022 14:21:50 -0700
Message-Id: <1665004913-25656-2-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1665004913-25656-1-git-send-email-jdamato@fastly.com>
References: <1665004913-25656-1-git-send-email-jdamato@fastly.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make it easy to figure out the IRQ number for a particular i40e_q_vector by
storing the assigned IRQ in the structure itself.

Signed-off-by: Joe Damato <jdamato@fastly.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h      | 1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 9926c4e..8e1f395 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -992,6 +992,7 @@ struct i40e_q_vector {
 	struct rcu_head rcu;	/* to avoid race with update stats on free */
 	char name[I40E_INT_NAME_STR_LEN];
 	bool arm_wb_state;
+	int irq_num;		/* IRQ assigned to this q_vector */
 } ____cacheline_internodealigned_in_smp;
 
 /* lan device */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 6b7535a..6efe130 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4123,6 +4123,7 @@ static int i40e_vsi_request_irq_msix(struct i40e_vsi *vsi, char *basename)
 		}
 
 		/* register for affinity change notifications */
+		q_vector->irq_num = irq_num;
 		q_vector->affinity_notify.notify = i40e_irq_affinity_notify;
 		q_vector->affinity_notify.release = i40e_irq_affinity_release;
 		irq_set_affinity_notifier(irq_num, &q_vector->affinity_notify);
-- 
2.7.4

