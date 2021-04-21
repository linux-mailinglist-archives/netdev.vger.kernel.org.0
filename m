Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4337C3667E3
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 11:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbhDUJZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 05:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238103AbhDUJZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 05:25:00 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7517AC06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 02:24:22 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id j12so23472013edy.3
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 02:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5/6NnvWCC3BUtMk2BuW+B+5BFJmj0DAO2+/gtSGcMcs=;
        b=TsDe8lmr70lEErf5fOLPcPmGKldWTN5EdkaNbyp5tLLLT1G6ibchwfPAtz/1lbntlC
         JgHFWDezvHGkMeNf+azP9RdqLUejr29TBUhU/RH3CDqQy9qCMH4nMHvZ4MlbNsjyALdh
         6SohG4xvlxTbjvqYoUiPmrb19f3BBhL939v/czzOjsKhKWykdSNtgaNUSrQzhwqFQBo+
         IXs7o63g4uCp/o+tnnhEmxcgqj6zdtTOaCOnITv75orI6qT2OjaYVylqJyrT37n8YSUw
         UmaBBbpYMCUp1kjUJmgbjYqho0F8c31tYk4dgOmO5lj4/+C33h20MsB3BE618SqDbbU2
         siDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5/6NnvWCC3BUtMk2BuW+B+5BFJmj0DAO2+/gtSGcMcs=;
        b=cl2ghVUBvaA5vnCt7zGV984PW0jW26RwRdEXwaXkXPtduEC+6QO07NM4Jk2FgBzmN4
         f6Ai5v/gshsg8Hr2m5MQ/GF9oDYcZQ/SMixld4eS+tBz9oWh3SHQEZ4w5YGOqqeJqX/Y
         cIoDUKHBMM1GvsF6wAW6p2HtSoSYqiixCAwXNyaveN4L4wr5JICn2Aggz5xi/RDkZ9u4
         CnR+Mx4GDtIXpT7XVDJ4YWFQDuk2rpx342mizsgNgP1x1Rn70i37PrCKPHUrG6dp/lZ9
         RtJLAgrWeoQ5gWUn5tUSq5NBB3fI85mc6YLPHnYbyE4AL+cg97D/231TQmTtYQ0nUYmO
         bwog==
X-Gm-Message-State: AOAM533aokvYr9quvudSwHmMOt5wJm4wxDyaQawaQgKWucGSfqxzZbcZ
        NB8cdsyuHwW6N69Tz7hUv71EXQ==
X-Google-Smtp-Source: ABdhPJy1D1gCspY1TFjNuzBY9p6iTztJGNTjae864R2gpsF3KfaX9H+rByfSx/GxA6nV85fwrhxYaw==
X-Received: by 2002:a50:eb45:: with SMTP id z5mr37701623edp.243.1618997061081;
        Wed, 21 Apr 2021 02:24:21 -0700 (PDT)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id k12sm2352950edo.50.2021.04.21.02.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 02:24:20 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net] nfp: devlink: initialize the devlink port attribute "lanes"
Date:   Wed, 21 Apr 2021 11:24:15 +0200
Message-Id: <20210421092415.13094-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

The number of lanes of devlink port should be correctly initialized
when registering the port, so that the input check when running
"devlink port split <port> count <N>" can pass.

Fixes: a21cf0a8330b ("devlink: Add a new devlink port lanes attribute and pass to netlink")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index 713ee3041d49..bea978df7713 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -364,6 +364,7 @@ int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
 
 	attrs.split = eth_port.is_split;
 	attrs.splittable = !attrs.split;
+	attrs.lanes = eth_port.port_lanes;
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	attrs.phys.port_number = eth_port.label_port;
 	attrs.phys.split_subport_number = eth_port.label_subport;
-- 
2.20.1

