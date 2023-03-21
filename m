Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104246C381D
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 18:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjCURYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 13:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjCURYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 13:24:07 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC4F4BE89
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 10:24:03 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id n8-20020a17090a2bc800b0023f06808981so5689368pje.8
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 10:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679419443;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1t/BzD2c40GrkHjyq2+5co4mW/oHWvYaXIZpqIQybYk=;
        b=cVgz5xE73QUlpX9EUgi0lGPIqrWQVEVQSXPLAB4K1svoZuP+yKSq2rafTCXG0zmv1L
         EvaRJzVGvm+GhBZbk2FTgFtQ4mazmRTFUv3hc/HDtOCoTneBwJhd6F61Hzp9nc+j0tv5
         ZAWGV9apD06j52Jo7QiORhbR3IWtsNeUn0zXcEn5WnGhZtxOPCnIh7mPYOowba7WXWPc
         0OS1cf0KZdrbWX2lJ0hPeH/vYDAOkUEYzqo4FI8WhGSsg9cCnv2lwbSixAKHVQm9xkRQ
         Op/A5tymlVB4y+U4KjCsCPCuhKe64g1Ei9GS3/2F93gbq+9wgH0kXSfT3FEo5lfaVO2Q
         eGxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679419443;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1t/BzD2c40GrkHjyq2+5co4mW/oHWvYaXIZpqIQybYk=;
        b=mJr+2XftHmGY2XRcM2mV0OrT6Uh6NgPUMHQ7Q+UG+oIlK43CAgN5LHitVHJoM6Lq0d
         8UJLp4RECnaxaO26XTKjT+EjH9V/tQ4Me+AWG4xuNRVJVvqloMNOcvEwV/L3Wx6oepFX
         b6/IzgKTbJasGnA8Uwly725pwBrGZ/sBu1MpOQjqcvU78NPpCCX/KxHjdqP6SQa2nSmb
         ja5onXI9NvCEn107SOEDXEE2iDeczo+7IaVJBUblRcA/9P3mNz0yih0jAjCAM+146qCk
         pV7WE58P4f1sUIedvIPq5diQDIWyFyT9mV+SpmuFw2fEUe8pJbKF2FXt0cagibLNafLk
         Mcag==
X-Gm-Message-State: AO0yUKWR2LYAqjzt+pth10PxFFONI0N+d0G3rJI+1DHOKdxJgm/NoNiL
        NrG0wEzNWfYJE/FbbiOEexW96xt0yZgwSMCkGare5IpCKfRCVBiMyVupb0dMKgRtHp0P1ToFGok
        PcMbKudPNGmE2kjE9WzYRhDFKFusHPpqRTGNihB7fm8n6r3QIVEfgrmZMbkMZutTNIU8=
X-Google-Smtp-Source: AK7set+entoqdRX/RL00FpBFLIWVxAoUPZ2YpPWqng5STW99BD2q31UZ47B+uB6A89sNTHAE2pbogMV90CYa3A==
X-Received: from joshwash.sea.corp.google.com ([2620:15c:100:202:3e59:ed3b:7ae3:7afa])
 (user=joshwash job=sendgmr) by 2002:a65:5187:0:b0:50b:d724:98e3 with SMTP id
 h7-20020a655187000000b0050bd72498e3mr911877pgq.0.1679419443304; Tue, 21 Mar
 2023 10:24:03 -0700 (PDT)
Date:   Tue, 21 Mar 2023 10:23:32 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230321172332.91678-1-joshwash@google.com>
Subject: [PATCH net v2] gve: Cache link_speed value from device
From:   joshwash@google.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Joshua Washington <joshwash@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joshua Washington <joshwash@google.com>

The link speed is never changed for the uptime of a VM, and the current
implementation sends an admin queue command for each call. Admin queue
command invocations have nontrivial overhead (e.g., VM exits), which can
be disruptive to users if triggered frequently. Our telemetry data shows
that there are VMs that make frequent calls to this admin queue command.
Caching the result of the original admin queue command would eliminate
the need to send multiple admin queue commands on subsequent calls to
retrieve link speed.

Fixes: 7e074d5a76ca ("gve: Enable Link Speed Reporting in the driver.")
Signed-off-by: Joshua Washington <joshwash@google.com>
---
 drivers/net/ethernet/google/gve/gve_ethtool.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index ce574d097e28..5f81470843b4 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -537,7 +537,10 @@ static int gve_get_link_ksettings(struct net_device *netdev,
 				  struct ethtool_link_ksettings *cmd)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
-	int err = gve_adminq_report_link_speed(priv);
+	int err = 0;
+
+	if (priv->link_speed == 0)
+		err = gve_adminq_report_link_speed(priv);
 
 	cmd->base.speed = priv->link_speed;
 	return err;
-- 
2.40.0.rc1.284.g88254d51c5-goog

