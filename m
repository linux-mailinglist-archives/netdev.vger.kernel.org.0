Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556015F802B
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 23:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiJGVjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 17:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiJGVjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 17:39:40 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004D7DD8
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 14:39:36 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id e11-20020a17090a77cb00b00205edbfd646so8352598pjs.1
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 14:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eahtucVHdG81huhJm8/Cz/GmI9h1getEoGvrIDntCUs=;
        b=yRBYm3Q1SVvY1Gms/XvF4cWbV6d5C+lkm6N9bQvWLNTX1hoEDMrjmDZV390YdoWDKB
         aN+24OuHYHPnMKLS2ws2LAzDWu6OMee5tV8Zsz2WwiABj2Iza5IWDGhIr6kD2yPkMCTs
         sfgoQBnijBo9uIDBaLuKaAhqFWTIBdK96NlX0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eahtucVHdG81huhJm8/Cz/GmI9h1getEoGvrIDntCUs=;
        b=Ua9o0xg0nLFg1K4Y8lt7Z+Y0TQFzbrecs5r3VDubURMIzRHlHaE9uuh/W2CxX661rY
         SHdxd/JPb1xjxtqF8d6JALlsYRJNnjqI32rZ2GuB37a43NOl81fjQgJmvMJTKwCvUO7l
         SgmXBKGbFVwN/mWo3r5ad3CqPuZYmaaTeRY/KfV55/TJKakyVIvA8e7K5uSBb5FMhw54
         LUgjFuvySmpB24fSDxlPmWJ494FvdKcJrbEvE37eSerW9Zgqd8bIznhRTc1NLTYgLKal
         783GAHN8ZX+cyipRKIqVzr2D6UrxSPkH/OFSzSH4Tu9/DPkP+nBEJSICf/JNp7c1gXvT
         rrTA==
X-Gm-Message-State: ACrzQf2Ssh1o5M+YhheBq3aP/USPgPM4C8j6iKr4KdMBNBtGJXIFzUfv
        2QG7R/tky4whE49fejDd+3lNbQ==
X-Google-Smtp-Source: AMsMyM52/lUKswCS/qZYuMBJ9BEqQth2q6NFgpmZ+k4uSbNmCL63VQOtZl3dYuhLGZOySTf1AZzGDQ==
X-Received: by 2002:a17:903:1d0:b0:178:1d5b:faf8 with SMTP id e16-20020a17090301d000b001781d5bfaf8mr6878942plh.9.1665178776544;
        Fri, 07 Oct 2022 14:39:36 -0700 (PDT)
Received: from localhost.localdomain (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id m24-20020a17090a7f9800b001f2fa09786asm2012655pjl.19.2022.10.07.14.39.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Oct 2022 14:39:36 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        Joe Damato <jdamato@fastly.com>
Subject: [next-queue v4 1/4] i40e: Store the irq number in i40e_q_vector
Date:   Fri,  7 Oct 2022 14:38:40 -0700
Message-Id: <1665178723-52902-2-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1665178723-52902-1-git-send-email-jdamato@fastly.com>
References: <1665178723-52902-1-git-send-email-jdamato@fastly.com>
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
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
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

