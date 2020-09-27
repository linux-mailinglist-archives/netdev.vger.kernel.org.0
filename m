Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6ABA27A0A6
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 13:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgI0Ld1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 07:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgI0LdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 07:33:22 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38392C0613CE;
        Sun, 27 Sep 2020 04:33:22 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e16so8641318wrm.2;
        Sun, 27 Sep 2020 04:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X8ZyNsCUpYJGxJ1LAFnadZoDWBj4MmXSSLPD6TPqGEY=;
        b=hOcLtcGfXgBwfkj4WksJeogV2rrGaS6xyx5UCLIjfwTZ9SQMtFLNj5IpoHPS7ATwDR
         nKhrIFSMpxO06LeL8NA8Ey7RI7V52k74cF5oLha/L6QsM5QOSgJMiZX6mb4K/jIud7G3
         6T7o46lcdc71eSAR1FC+ZiomCHkY9zvn5PidqN9XarvpVhP95l6ye7Wl77r8iBkf0DUa
         sXdy87caluAus046i1oLVIJFNPxiRI/qv1i63Q+28hjrR8+H7lCV95VSyMfWnMazgr/k
         OuMBPZwaNkRA4CsDn1QbaU7UXmq9oKf8gek3WCQI5dvWdyikI//FpzTRIgF2vHGE9ehD
         KkPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X8ZyNsCUpYJGxJ1LAFnadZoDWBj4MmXSSLPD6TPqGEY=;
        b=rRhA4v1GCgVyUV1msFsRZjdLynKVb4ltt2piv7hX39aPHa+CiFqc+M5pPG/tG+wSQl
         A0Rox0MJlOUlG6nKWOAzvcuMdk7YLjTEhezEfAhyDHLFRPHP1IVzEm3TuyHhUF4xAYod
         CeQDZY/5OqJP9MLfHn+rVbvlttxcgbWjUq28+EHGxb/cfbJePEQutUv8bb+NvhtH5oTN
         KpCIr3PPkuBzMOgVPjqNRpmm8fGS+k8Uq8N0jEJosdNKq1K+RpBalJUZMHb4au67ZxNY
         mOOM6hImBLA8dbBQsBLKL9f6NKx/AxuAgq7QOxxbka/ryFxnAxoO5XtlPU4GNaKtlxqp
         jt1w==
X-Gm-Message-State: AOAM531zIutgzrZNtpiTTq5YKfEwbCxHenSvu3hulHEMALy53b99MR+h
        ae3GZHK3/GhlDfqpaoRfLL4=
X-Google-Smtp-Source: ABdhPJza/VVgGMGfqQKcxSScatkdL84tX5GH9Wee0cezdqcmcqjdQWaubN+J/Dy5xQsahX1ZDtj/Kg==
X-Received: by 2002:adf:f88d:: with SMTP id u13mr14582436wrp.213.1601206400899;
        Sun, 27 Sep 2020 04:33:20 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id d83sm5671565wmf.23.2020.09.27.04.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2020 04:33:20 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Eli Britstein <elibr@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] net/mlx5e: Fix use of freed pointer
Date:   Sun, 27 Sep 2020 12:32:53 +0100
Message-Id: <20200927113254.362480-3-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200927113254.362480-1-alex.dewar90@gmail.com>
References: <20200927113254.362480-1-alex.dewar90@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the call to mlx5_fc_create() fails, then shared_counter will be freed
before its member, shared_counter->counter, is accessed to retrieve the
error code. Fix by using an intermediate variable.

Addresses-Coverity: CID 1497153: Memory - illegal accesses (USE_AFTER_FREE)
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index b5f8ed30047b..5851a1dfe6e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -738,6 +738,7 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 	struct mlx5_ct_shared_counter *shared_counter;
 	struct mlx5_core_dev *dev = ct_priv->dev;
 	struct mlx5_ct_entry *rev_entry;
+	struct mlx5_fc *counter;
 	__be16 tmp_port;
 
 	/* get the reversed tuple */
@@ -775,12 +776,13 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 	if (!shared_counter)
 		return ERR_PTR(-ENOMEM);
 
-	shared_counter->counter = mlx5_fc_create(dev, true);
-	if (IS_ERR(shared_counter->counter)) {
+	counter = mlx5_fc_create(dev, true);
+	if (IS_ERR(counter)) {
 		ct_dbg("Failed to create counter for ct entry");
 		kfree(shared_counter);
-		return ERR_PTR(PTR_ERR(shared_counter->counter));
+		return (struct mlx5_ct_shared_counter *)counter;
 	}
+	shared_counter->counter = counter;
 
 	refcount_set(&shared_counter->refcount, 1);
 	return shared_counter;
-- 
2.28.0

