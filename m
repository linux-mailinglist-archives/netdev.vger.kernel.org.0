Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A204A323D
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 10:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfH3IZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 04:25:34 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35465 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728279AbfH3IZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 04:25:33 -0400
Received: by mail-wm1-f68.google.com with SMTP id l2so6491816wmg.0
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 01:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=chGJzotQzpqPYa/5dG4+tvNQV2yEbKw+dZVLc3ZYFWk=;
        b=Lv8dVZTWe7OSPFe6f2de+cnXlHYoVPnBnyj1D5qVlulztrPk74HX4dy6MLWx9LYYM7
         AQHIX7kSUUnqB1EyJgBFsSE9w+JFx9B3HcqE6zyhBNt+BMI1DmH2Fg0I7V9CywFSJ+l7
         vIOb1GrNC41waBfSIqn19LNo9eSKCqkRnlUCqzL06l9iZmp03hEnyW7iOnGsSt2nGeLK
         CMWLWlbtvfTW8DkaNVHQLSPxkgXRPB+5bwFlR/4YJcRJY5xKiujmxp5UM6PLVwyySp24
         7Y1oFmRgniG4PvJN0+2bhIBBJzet7glhk03LA/jlxLHX/AgHA4uvfCHMo1Cp45b+25YP
         sa7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=chGJzotQzpqPYa/5dG4+tvNQV2yEbKw+dZVLc3ZYFWk=;
        b=Cd+ApzNEwVG6lnuAjdHGMM0XzAgFsyjRB3X3B/Fkhl4zaxEOk0AdHwK6Djb7HythKx
         95u1UZSBMSoe+qdnTgrn8IxWDsNQKeDuhoLqsWbJyEDX9zmX36w/4fY2U4bYW9ugydJs
         WGg8Gyz0ocS8+x5tmpQQ86PxSAyz5bNAgppocD2zcDP1VPI0K0y/r/uPVbQbv7WLXKFA
         WwePNBgUiOVGsMBQK9vz2uj2SbMlxUulvFmEPMoShUT6kMxlOmEitco+IWHMEa8nbKah
         OXf3tJIvfXUaN1SdLLgQVs+PtHNGe2Bfjp8fr6k+uI+B2i1u2VGsvjJ7MFwcQx/mwjhb
         dxmg==
X-Gm-Message-State: APjAAAUdGFW0K6G6BqI7XTFpMFmOJdWizIYCMRfYluisZRS94XzllSVF
        NIXEpMPE6TMAi91FsxGqMKcV6UP5Idw=
X-Google-Smtp-Source: APXvYqz10/RHGt92PiWSUtL6TfbcxYLThjbD/IUwdJP7mhDxpBMOVPlGwweD6gFt/lDn8W15lkrdUQ==
X-Received: by 2002:a1c:9648:: with SMTP id y69mr15671508wmd.122.1567153531319;
        Fri, 30 Aug 2019 01:25:31 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id b15sm7807427wmb.28.2019.08.30.01.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 01:25:31 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, saeedm@mellanox.com, leon@kernel.org,
        roid@mellanox.com, mlxsw@mellanox.com
Subject: [patch net-next v2] mlx5: Add missing init_net check in FIB notifier
Date:   Fri, 30 Aug 2019 10:25:30 +0200
Message-Id: <20190830082530.8958-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Take only FIB events that are happening in init_net into account. No other
namespaces are supported.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- no change, just cced maintainers (fat finger made me avoid them in v1)
---
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
index e69766393990..5d20d615663e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c
@@ -248,6 +248,9 @@ static int mlx5_lag_fib_event(struct notifier_block *nb,
 	struct net_device *fib_dev;
 	struct fib_info *fi;
 
+	if (!net_eq(info->net, &init_net))
+		return NOTIFY_DONE;
+
 	if (info->family != AF_INET)
 		return NOTIFY_DONE;
 
-- 
2.21.0

