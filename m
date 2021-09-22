Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465F841544B
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 01:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238553AbhIVX5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 19:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238631AbhIVX5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 19:57:49 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A306C061574;
        Wed, 22 Sep 2021 16:56:18 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id k24so4485853pgh.8;
        Wed, 22 Sep 2021 16:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8GeJbL+pJAm/EEcPNSUQ0H815jUQQBV0JAJ1k+wFbAw=;
        b=fLwby+9MqsGywGa75uLqPn+OZKy4r7MyL627jF1XB3vUoaI/hSyMfF6iec25aAb8Vi
         l1eppt6OERCN/xJhOG7UXw6PrbKKKeaVVYMXWl5C03nBaNRqmoPOMo/Nt5qPIR3cGYEt
         VRKoTxglziaAyjz826FLwr/VhXkBWysbz4rU79LREHLhYDRqrqSP7jjDXVZFJvdy4jWd
         CWZg5zDUKYaBpeeM8zobANjahoY7xJdf1Z2bhEhfFlhDvTQ0s4zcrsA2IT2j7V9gElIL
         amIy9LqTMt3EuXbvmkFZHfDh+e45AEOvoNcX3mqfrhbaB/uE/JNtDkHbXTmuR31o01R6
         Zjzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8GeJbL+pJAm/EEcPNSUQ0H815jUQQBV0JAJ1k+wFbAw=;
        b=1YeOrXbOd1XjdYSt4daG1qpZZVZvbCyxAtTaCpW2HzxvnRjVLnWQCEYRMgmI8p89cx
         ov9s8Wb1jRjVLeXOXbc98kk49r99yO1cpSlLj/+xUOrC/yzGlDbPihl52XWL1vzhgqvK
         o/IqCbWfxavqzAUfGKVBLnr2VK5YmegAmCwl7XyJbUf+uJdyA2y/cS0cZdY5pOs4Q/2r
         bWEPBkeROPhM039wknnCJG752XYUa2BKBa0z+e3vcE5kV+eK4S+4ZS8lT2C0Hh3pPYuV
         1C9nZDZ9P6abfoXzcSWyML6rY1iCcKKqS1DqSS/W9Y1rW/wlfYNQ/1HUP6o3PtjOcp94
         c5bg==
X-Gm-Message-State: AOAM533d7Ywofx8payBmrk9Uv7sw3ay/uRRLA8N3kPn84SzuIIqJ7y9Y
        PSwZQYktrgzbdeqU7G5hy6U=
X-Google-Smtp-Source: ABdhPJy0RcjDGsoi5EgJ+AtjgaucjarMi7aKc30L/g+lbRhenYwQWd7f22F1aFJtBKpNLClesolNhg==
X-Received: by 2002:a63:d002:: with SMTP id z2mr1480578pgf.234.1632354977727;
        Wed, 22 Sep 2021 16:56:17 -0700 (PDT)
Received: from ilya-fury.hpicorp.net ([2602:61:734d:a400::b87])
        by smtp.gmail.com with ESMTPSA id qe17sm3332445pjb.39.2021.09.22.16.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 16:56:17 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net] net: ethernet: mtk_eth_soc: avoid creating duplicate offload entries
Date:   Wed, 22 Sep 2021 16:55:48 -0700
Message-Id: <20210922235548.26300-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

Sometimes multiple CLS_REPLACE calls are issued for the same connection.
rhashtable_insert_fast does not check for these duplicates, so multiple
hardware flow entries can be created.
Fix this by checking for an existing entry early

Fixes: 502e84e2382d ("net: ethernet: mtk_eth_soc: add flow offloading support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index b5f68f66d42a..7bb1f20002b5 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -186,6 +186,9 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	int hash;
 	int i;
 
+	if (rhashtable_lookup(&eth->flow_table, &f->cookie, mtk_flow_ht_params))
+		return -EEXIST;
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_META)) {
 		struct flow_match_meta match;
 
-- 
2.33.0

