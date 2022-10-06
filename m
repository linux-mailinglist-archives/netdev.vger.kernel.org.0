Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E4B5F71FE
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 01:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbiJFXo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 19:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbiJFXov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 19:44:51 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EB61FCF3
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 16:44:49 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id v186so3437132pfv.11
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 16:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KYs5i1UtSKwff4LZqDYKTEYs6XamWF2jUJRPKUQ5EPA=;
        b=q79sAlRdGXhPz5dtP63w6mgBfEtup7KvbQmDgnUaYLrmFH3wb2FL5owr6t+Jdg7Mec
         0Bf1fNqXkuYbJW+RnQF8ij1o57WLj9AeQokUytJxBCUybXvLpJpbb1UXCRQrjs/JG/AQ
         WnwYTdt5dYqDmmG6EfzyPXnHJGy08FC43J0pQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KYs5i1UtSKwff4LZqDYKTEYs6XamWF2jUJRPKUQ5EPA=;
        b=MDbvvjErY6rFhzPM9O2w9sSdggZWa/v6QgGMHoH5smTUh2Dg5el9bU4Y1hIuk1IIfi
         PrhWiY/Er+jmMCK5DTU3Q2irUaoMnDUEYKo1vNDXp1dr5JMxWNG9ScsASxaAOjXpfdxi
         u7gwkv+ScGjU3b0g26GrGT3HVLkQk/amlN36Xz5VRzCPkHpN3JJqCArba7I4uXbkugSi
         0eveuraR7C4J24YXO9pxyexD1iumyAuOW6r/8jr7YxEJ/+lF83QZHIvB1nCIB5Wi7qcy
         5Lt0JzWx6KMZgTN87tPGmOGZpK6LF5SFBAQrc4JbAyK/oFXd7lorx8vtf+z/MyNqxHV3
         sn9Q==
X-Gm-Message-State: ACrzQf1KrjdAsLXGNTv2xKDGhAHZI2Fn8GHY78te4x/urVM2dhSu3zWV
        xZlZgDK//xta6q7J9p3ESTbpVg==
X-Google-Smtp-Source: AMsMyM6RHbKnxW53bQQnwAVI6lfHCITHB2Yxxj/1gw8QgizO4uWRcy6v4YZK+H1j2jnB6LScspj4Qg==
X-Received: by 2002:a05:6a00:1392:b0:561:8156:d8d8 with SMTP id t18-20020a056a00139200b005618156d8d8mr2327090pfg.43.1665099888971;
        Thu, 06 Oct 2022 16:44:48 -0700 (PDT)
Received: from localhost.localdomain (c-24-6-151-244.hsd1.ca.comcast.net. [24.6.151.244])
        by smtp.gmail.com with ESMTPSA id u4-20020a631404000000b0045935b12e97sm308124pgl.36.2022.10.06.16.44.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Oct 2022 16:44:48 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        maciej.fijalkowski@intel.com, Joe Damato <jdamato@fastly.com>
Subject: [next-queue v3 1/4] i40e: Store the irq number in i40e_q_vector
Date:   Thu,  6 Oct 2022 16:43:55 -0700
Message-Id: <1665099838-94839-2-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1665099838-94839-1-git-send-email-jdamato@fastly.com>
References: <1665099838-94839-1-git-send-email-jdamato@fastly.com>
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

