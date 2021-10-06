Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09393423607
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 04:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237216AbhJFCoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 22:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhJFCoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 22:44:18 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9187C061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 19:42:26 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id a16-20020a63d410000000b00268ebc7f4faso742869pgh.17
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 19:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=lXh9uBOfLTRnEX/C53DJjD07NPHJmE4SotDbW0uoTtg=;
        b=QTMeRIKT5IxshLxL5kzXWJkus/8v94KLZsNNmW6erEmg5Hay4oPyYskxUkvpdlKSdn
         FSXTsqNtq7YVp41qDQHZA9UU2DKSgIVVmQ4lcohZPjGF1wP+tMFsKNpAXepjs/f67O0V
         B289ckvlxFpbWBgUQeYZN2W0kfm0zM0NzfNJsebp6npddWmV63ML4VgG56TXPi7/kUxx
         QhXOrJWwxDopKDMB554q5viQ76U8kTSaj42KHFaGlpPldQBkOTMOTjjugMY94tRwchPB
         7OkTzsK/6gvB5G4iFFdW6uoCXShAgU5scSg13kIy5R2RfJAgB2pvWgqWu4dAQn++qj9O
         1ZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=lXh9uBOfLTRnEX/C53DJjD07NPHJmE4SotDbW0uoTtg=;
        b=KC+5G6CnmWF6MMAt4j10LItOWZteYMzvvEiyfqtIfdCCbcI3kWppy5xLJWxQtX+Xqz
         +KSoNplhzqs7ZrgKZ2rjXCLf96uP7iMDZZbmwEpQkaKuLY//IcTkJ1sLfloD2RauMuci
         oFpl8vIkbKeS6/NuU+vfM4kDuSLQJDP2FqwIJHuOqFUGGsc+/sdggPyGuOdhr7TecYrP
         H2zhSrBh3M0nyMPVgkWY58brXqq4FpkYCPW5KTs9/ADS5SWqzoqzVaKNeQ+vem/jobWy
         sX4DbE1J5Q1iY4NlaqInCZiYNvWkioPRejf9AkreyEoHWAJkZ+yRlVuH31sT5UfbTdUK
         6Tfw==
X-Gm-Message-State: AOAM532X7mwWiyJql9jcc7+ZSh0AV+dtC6ANj/fHfETNhFSy/05kqKZ4
        /E3LtCDdhdDJ0rSyUdkutHZm/T11JziI/sfD1km2r1KH4s3sn3y/YjPcoNAdJFdxOxi4XHhUc82
        Y93f1EXrQ2940LclOoiN21WF/C9t/cdemHcoFbOgYicEjW7t+TdjJd4Alsec+jhhh5sU=
X-Google-Smtp-Source: ABdhPJzeWaadYyAbNSlogHarg9JtLaTNwIfT+6tAacLJ4zRTGQ2v9ZyFr7z5bSt7ZJKGYgzoNQGzDPtleMRq1A==
X-Received: from jeroendb.sea.corp.google.com ([2620:15c:100:202:6a19:24ee:a05:add5])
 (user=jeroendb job=sendgmr) by 2002:a17:902:c401:b0:13e:f5f2:f852 with SMTP
 id k1-20020a170902c40100b0013ef5f2f852mr1546358plk.29.1633488146135; Tue, 05
 Oct 2021 19:42:26 -0700 (PDT)
Date:   Tue,  5 Oct 2021 19:42:19 -0700
Message-Id: <20211006024221.1301628-1-jeroendb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH net v2 1/3] gve: Correct available tx qpl check
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

v2: Removed empty line between Fixes and the other tags.
