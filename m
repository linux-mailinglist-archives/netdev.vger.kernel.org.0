Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BAE423477
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 01:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236962AbhJEXai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 19:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236942AbhJEXah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 19:30:37 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0543BC061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 16:28:46 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id z22-20020aa79596000000b0044c8c01b7a9so351078pfj.5
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 16:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=e3+IZmOWok86/4KWqVoACtEsKb2S0af+XuScec1C+TU=;
        b=lvjsGIKuGyq6Zp3iP/OUKDvOgXSevJrfB4djxzR+I6IARc1ClsFt7DJhyGKW2FzEGV
         4p7XkENWDA97I5hcQyOhlTG9tSnUGiFqPsO7Kg3ML7zKEI2s0iLsK/cCkdJiJKHtCHTW
         /hcsDedhGGzQjIFTa7oA4QYnDvZ5hlJn5s7PwLusXngrSYkpUTy0cTHrjhVQpkreETSy
         Oq7ToEzR9fEeZNHy5yvlrWU1GBbT5j9UtERadkoaowm2fN+OARYk5gP4qydNxIS4jrUA
         qH0YK6aShNiVeyKwhKLrujdzrynEnCf/O7TFzsyOq3z1PSxkJt7Gn2fqAowr6xaLUvNc
         s6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=e3+IZmOWok86/4KWqVoACtEsKb2S0af+XuScec1C+TU=;
        b=iZZ5Rdtf4d+FKQKV7cANdUNEkgSIyTzf7n2OnSlFkwrRqECe9VS8Ccungv7B+6t02K
         IytGKHuVSeZomttfkDS9DNAHBV4nYEv0z5NEcwdscHPaNbGVmH+X4addrC9vCjf1arv4
         CvZKRn3cZQ069oKhuRhVnnDmX8LpcqqlpKKn71bhaORNocpsG8WTcsQiUnKIIyYh2aFU
         phkbCQL6FvggxPfH3DS+wawDQpWUFxIG9TmmYoCTsJCflqntF/mdAf7MFFR8aOkpoahh
         RU8taqQL0jM3gfO8WkCmLTTn3gogqUQ+oSxNZ4GRJFVktkkLc55nf2rLXmcD5cc/Ls2Q
         i/lA==
X-Gm-Message-State: AOAM533VPCKy3pmmilS2BZw/IXxCj4LCTiwya7aT/Y+ir5tdO16obOYR
        EF9tCy4Ht8LFgTJ7CZIx/jeQSlDiLPX5G2MGWngT6ZV5sAAg3N0vBeJmeYGWgPMC4M/g1SKi4UA
        jgrH8pghRAa9TJQXhw1/+WNVSD4WzK6t4pzKJ+wXiVR1efAzSfwnTrDme7SEAPRUEs5w=
X-Google-Smtp-Source: ABdhPJySrDZLyMJfOw8NAEIFE/oPfrHbU7cgj8A9A/Oricz15BQj6qd8qcosRc60nK3leDFRI4tUASe9O8aYSg==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:6a19:24ee:a05:add5])
 (user=jeroendb job=sendgmr) by 2002:a17:90a:8b8d:: with SMTP id
 z13mr663873pjn.0.1633476525148; Tue, 05 Oct 2021 16:28:45 -0700 (PDT)
Date:   Tue,  5 Oct 2021 16:28:21 -0700
Message-Id: <20211005232823.1285684-1-jeroendb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH net 1/3] gve: Correct available tx qpl check
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Catherine Sullivan <csully@google.com>,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

The qpl_map_size is rounded up to a multiple of sizeof(long), but the
number of qpls doesn't have to be.

Fixes: f5cedc84a30d2 ("gve: Add transmit and receive support")

Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
---
 drivers/net/ethernet/google/gve/gve.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 1d3188e8e3b3..92dc18a4bcc4 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -780,7 +780,7 @@ struct gve_queue_page_list *gve_assign_rx_qpl(struct gve_priv *priv)
 				    gve_num_tx_qpls(priv));
 
 	/* we are out of rx qpls */
-	if (id == priv->qpl_cfg.qpl_map_size)
+	if (id == gve_num_tx_qpls(priv) + gve_num_rx_qpls(priv))
 		return NULL;
 
 	set_bit(id, priv->qpl_cfg.qpl_id_map);
-- 
2.33.0.800.g4c38ced690-goog

