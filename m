Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18894989BF
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344558AbiAXS6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344529AbiAXSyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:54:46 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1532C061392
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:35 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d18so3962526plg.2
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7vQNBaHG6Ptstllb0Cqk3fQCnDZdvoLkhVTkNBipFEM=;
        b=mWcWV6nUITsbWsndFiLAK7pQR2qH/o5CxFLaBELytiFdvn4KBDaeEcZGzPRYYs9xrX
         IBC3KcTT38AYsHdrDe9x0EJTSNBHNw+1KUYvvU4vSiqywOIlrqADiBdeGZ3qwUKV4Hfa
         dYedk9S92BF2pa73OmGNfHTkzvEdphaAMn3gBHvfnwwZenC0PYGRSBGAiICq4lrICOse
         mgYTbcytJWNdR+oaekzioi5Q3MhStNmRDpJcw/2g7jx8ed3gwi/Y6JunFGkBY0wW5L31
         MvCTICjoNPQKCthshzRutkNEEM8Jy06xby2p8VW34ymCl6Gsq6ht+3A43Ez6GJ0C2r9u
         Dkew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7vQNBaHG6Ptstllb0Cqk3fQCnDZdvoLkhVTkNBipFEM=;
        b=eln9ArDeRTuuVSDKTBselQslWl0tIiH8kKCMB4pZXOofciTyO1ctarqpRLTtz12C3G
         9BuzxZorK4I/ldwi3Z4PmYtZ4DiOfrfHg4I5fG2y/osc1E39dwGfozKHmXeDk2hbo9Dv
         hpc/p5klv+vvA0uDsEpLA2O5RhVegcdfZFcKWZd8OeBa4VojbztYxf1eF7blemFtpuZz
         rTLXHQVQkoj+d1aQSlYQBQjrf/s+1o7h+CPQRHfaIPvOqOsj6krPQa4L6g4qHXAPndEt
         ZWeS7kBF9C3bxOSGwzExGJK8ZiiJf1n9caCNFAToDXdNiDcIUn9Dcptynq80rwqdqLqv
         AO8g==
X-Gm-Message-State: AOAM533JhxYZROMLFf55L89eIWFjwS5QwiLvOyq4XZqVGHugKtmZNrU7
        mqdPmOUZJHawZzw+8esPvRUEEA==
X-Google-Smtp-Source: ABdhPJz+YHPZqzlbDtLaUIcyjPzOg3ZB40QqnBd4bOx3d0PW+dHWe9CNWReEIZMoAJ3/sf4PXXAKXQ==
X-Received: by 2002:a17:902:8ec5:b0:149:d41a:baa8 with SMTP id x5-20020a1709028ec500b00149d41abaa8mr15020726plo.115.1643050415389;
        Mon, 24 Jan 2022 10:53:35 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id cq14sm85177pjb.33.2022.01.24.10.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:53:34 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Brett Creeley <brett@pensando.io>,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 08/16] ionic: Correctly print AQ errors if completions aren't received
Date:   Mon, 24 Jan 2022 10:53:04 -0800
Message-Id: <20220124185312.72646-9-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124185312.72646-1-snelson@pensando.io>
References: <20220124185312.72646-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett@pensando.io>

Recent changes went into the driver to allow flexibility when
printing error messages. Unfortunately this had the unexpected
consequence of printing confusing messages like the following:

IONIC_CMD_RX_FILTER_ADD (31) failed: IONIC_RC_SUCCESS (-6)

In cases like this the completion of the admin queue command never
completes, so the completion status is 0, hence IONIC_RC_SUCCESS
is printed even though the command clearly failed. For example,
this could happen when the driver tries to add a filter and at
the same time the FW goes through a reset, so the AQ command
never completes.

Fix this by forcing the FW completion status to IONIC_RC_ERROR
in cases where we never get the completion.

Fixes: 8c9d956ab6fb ("ionic: allow adminq requests to override default error message")
Signed-off-by: Brett Creeley <brett@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 04fc2342b055..7693b4336394 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -322,6 +322,7 @@ int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx,
 		if (do_msg && !test_bit(IONIC_LIF_F_FW_RESET, lif->state))
 			netdev_err(netdev, "Posting of %s (%d) failed: %d\n",
 				   name, ctx->cmd.cmd.opcode, err);
+		ctx->comp.comp.status = IONIC_RC_ERROR;
 		return err;
 	}
 
@@ -342,6 +343,7 @@ int ionic_adminq_wait(struct ionic_lif *lif, struct ionic_admin_ctx *ctx,
 			if (do_msg)
 				netdev_err(netdev, "%s (%d) interrupted, FW in reset\n",
 					   name, ctx->cmd.cmd.opcode);
+			ctx->comp.comp.status = IONIC_RC_ERROR;
 			return -ENXIO;
 		}
 
-- 
2.17.1

