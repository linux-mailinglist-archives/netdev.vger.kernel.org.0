Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF5230F9F7
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 18:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238705AbhBDRl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 12:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238488AbhBDRkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 12:40:43 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA90BC061786;
        Thu,  4 Feb 2021 09:40:02 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id w2so6734490ejk.13;
        Thu, 04 Feb 2021 09:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WGtGHJsvUwG5MwUcckxmFqwFncMzsH+2ot6iLYnWons=;
        b=djLyUkuXKwVIXkHnp0OfEjoeNt1KBL3j5BeTzsOAAiQYwGXJqkOjT2yaFrMighB6oG
         NxBzQuVmnGLRJgXooHlF/pa6Nfw2SMy+D7jft0AOckgT50j8DPZeZgsk4wVaNBf21zkW
         MUdSxWePPYNFo3BCxPo2b5tQKLalApYkBBB8BWTwDt5d7XnqfUh7jzi4XCMT6z3nkG2T
         72rtbwpRBYD0fjiwvgR4qir+feFD+jZOq8zV3Q64gmbcdxNNkDt+mYFPKzrd6iJhuMun
         4gVQA2gd2gQjAqiUsA0e9sMcohvphb2Jw6BCsXV92fqcGEu3SzVQAhSaAdUWrf2qVEjI
         IPcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=WGtGHJsvUwG5MwUcckxmFqwFncMzsH+2ot6iLYnWons=;
        b=k1UmQ1HGq/uo1QHnqlNh5V4zS2dw1KxsfvXlFVy2iuUgU6ZwWD36H1IzM8rdIVrGIu
         NKyCSLDL14EaK+DbwEWjBgTO2Zz/T9WtDwRXLxCUwllColuhAzDJDVwuWd8GbR/b6cKr
         ZCc9ur+4cCkjI3lvTgGmSfA3NEDN1zpj7MUH9BR8Q4eisoXGMIpTmMSZxm/4LrLKYFFn
         k61Pk3yF5GhpTHlWsTITsk4L4oalCRi6iNkx62cJc5zRQUlDqOtN1Nz5KDQNisXce43c
         Umh2TCajWkFxoa6eqZN93uxZbnGeNLqRP9lTfTiU3l0xeJVHLc5J8vxZ4gfwCuhbYaOv
         Hv1A==
X-Gm-Message-State: AOAM532mj/5ewN163XMOt2CSV6ubmCdbpaapPAFCw1/HytPSMq7YjKYh
        tA7w1CYkLzkSxFWrSkDTFfQRBSYq+UUylVen
X-Google-Smtp-Source: ABdhPJxb9pG2YvThn6s7n91Fw5VyR/BYZ6xvzs3ldLw9+9DEJ8aqzzlMZkR3h89swCZrtaFQUS5oag==
X-Received: by 2002:a17:906:b50:: with SMTP id v16mr221417ejg.298.1612460401728;
        Thu, 04 Feb 2021 09:40:01 -0800 (PST)
Received: from stitch.. ([80.71.140.73])
        by smtp.gmail.com with ESMTPSA id o11sm2775886edt.96.2021.02.04.09.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 09:40:01 -0800 (PST)
Sender: Emil Renner Berthing <emil.renner.berthing@gmail.com>
From:   Emil Renner Berthing <kernel@esmil.dk>
To:     netdev@vger.kernel.org
Cc:     Emil Renner Berthing <kernel@esmil.dk>,
        Kevin Curtis <kevin.curtis@farsite.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] net: wan: farsync: use new tasklet API
Date:   Thu,  4 Feb 2021 18:39:47 +0100
Message-Id: <20210204173947.92884-1-kernel@esmil.dk>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts the driver to use the new tasklet API introduced in
commit 12cc923f1ccc ("tasklet: Introduce new initialization API")

The new API changes the argument passed to callback functions,
but fortunately it is unused so it is straight forward to use
DECLARE_TASKLET rather than DECLARE_TASLKLET_OLD.

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
---
 drivers/net/wan/farsync.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index b50cf11d197d..686a25d3b512 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -566,11 +566,11 @@ MODULE_DEVICE_TABLE(pci, fst_pci_dev_id);
 
 static void do_bottom_half_tx(struct fst_card_info *card);
 static void do_bottom_half_rx(struct fst_card_info *card);
-static void fst_process_tx_work_q(unsigned long work_q);
-static void fst_process_int_work_q(unsigned long work_q);
+static void fst_process_tx_work_q(struct tasklet_struct *unused);
+static void fst_process_int_work_q(struct tasklet_struct *unused);
 
-static DECLARE_TASKLET_OLD(fst_tx_task, fst_process_tx_work_q);
-static DECLARE_TASKLET_OLD(fst_int_task, fst_process_int_work_q);
+static DECLARE_TASKLET(fst_tx_task, fst_process_tx_work_q);
+static DECLARE_TASKLET(fst_int_task, fst_process_int_work_q);
 
 static struct fst_card_info *fst_card_array[FST_MAX_CARDS];
 static spinlock_t fst_work_q_lock;
@@ -600,7 +600,7 @@ fst_q_work_item(u64 * queue, int card_index)
 }
 
 static void
-fst_process_tx_work_q(unsigned long /*void **/work_q)
+fst_process_tx_work_q(struct tasklet_struct *unused)
 {
 	unsigned long flags;
 	u64 work_txq;
@@ -630,7 +630,7 @@ fst_process_tx_work_q(unsigned long /*void **/work_q)
 }
 
 static void
-fst_process_int_work_q(unsigned long /*void **/work_q)
+fst_process_int_work_q(struct tasklet_struct *unused)
 {
 	unsigned long flags;
 	u64 work_intq;
-- 
2.30.0

