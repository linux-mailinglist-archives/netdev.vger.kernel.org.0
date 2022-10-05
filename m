Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360385F50D6
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 10:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiJEIcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 04:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiJEIck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 04:32:40 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA42171BE1
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 01:32:39 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso2623150pjq.1
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 01:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date;
        bh=KYs5i1UtSKwff4LZqDYKTEYs6XamWF2jUJRPKUQ5EPA=;
        b=BNpQVvhEgCIekoG+t0cPqZeXurSlQZRXpEwPW8enJ92DBNA0QI4277kT1cO1fEJR/0
         b3GLCRn3d3x34ITuilfh48b1uO2erhW6yFJlzyj6F+puarqJPa0G7TQtEz308oFKzkMi
         DTNWQc6KBRHqjUVKmtk+dcsjciI3D6zVRGM98=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=KYs5i1UtSKwff4LZqDYKTEYs6XamWF2jUJRPKUQ5EPA=;
        b=1TE+jzS2Kibnpof8/vUlrppSERcrcQ2nvqbvhd8CcOdGFD1ea/ivxisjxeshuiMuVu
         tHwToQnQZRtUqZ0jmLdFgOGJRiNs88JEhz5Z+vFcvvRF+6NXH0tJZ4KHJrhNpkzETLhK
         NbUftrF7H/CTam1yx0CTOyV6lbAkR8sKkZdP0i52kt+MwlIh3krl1eoBYI/T/RftMNLz
         KwqBJlYyP0PaDAhBwnYZSW15COypQ5O1H/oKBYW2ei7UNZwHXWFba2aIjnzgb5Yo77ao
         mhhrBqb4L0g/QNGX25gVWlVysFJWRfByig/ldp5giEWbJnA4KvKFaLRWfb+ZNmT4yWGe
         783A==
X-Gm-Message-State: ACrzQf0PxLEeSVUvKCoRdtnh4+LJhl37QEZfCsB7GKg+D1h64tXx/Dq1
        GUueVQIF4GbuCIXHzuwKM6MDDg==
X-Google-Smtp-Source: AMsMyM5uvV2N+z8o7Lps/R5jdrkwdk2pbiCEvdcvFm3zqeAqi/0UM8OGHPa6MZ/YEzKEVyK9Rq3/Vw==
X-Received: by 2002:a17:90a:ea95:b0:20a:f65b:143b with SMTP id h21-20020a17090aea9500b0020af65b143bmr167924pjz.230.1664958759422;
        Wed, 05 Oct 2022 01:32:39 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id jj9-20020a170903048900b0017ec1b1bf9fsm5899320plb.217.2022.10.05.01.32.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Oct 2022 01:32:39 -0700 (PDT)
From:   Joe Damato <jdamato@fastly.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, jesse.brandeburg@intel.com,
        Joe Damato <jdamato@fastly.com>
Subject: [next-queue 1/3] i40e: Store the irq number in i40e_q_vector
Date:   Wed,  5 Oct 2022 01:31:41 -0700
Message-Id: <1664958703-4224-2-git-send-email-jdamato@fastly.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1664958703-4224-1-git-send-email-jdamato@fastly.com>
References: <1664958703-4224-1-git-send-email-jdamato@fastly.com>
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

