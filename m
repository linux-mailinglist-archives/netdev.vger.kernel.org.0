Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A59C1CFCB7
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 20:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgELR76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 13:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728039AbgELR75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 13:59:57 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C82BC061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 10:59:57 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id z72so15012599wmc.2
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 10:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3NNNl+admW51ArOnz3DFZNJt6RTX+7wBAqLIs+fo8c4=;
        b=drLwkK0F+ajGprHINWhMjtK4xo6Nfzsx0wasvnkm+CicTB9ITBtUrabCesyEeFe3+8
         efZeMtk6geFrt61yhYQUgTQ0SQ+RnMBfsbsWjzIXE5/JqrvQCe6LqDpD/WIIZthqPtff
         VsMwvmV3ZtCXk8t4QAyeEhNsuvYVsMyZibL5xeDorhPkrC0njyPCQZBkgaKq8REFo0g0
         /BBIFROYyLBwUjI4S8D9AQ9T53MSoZUkbZ1L1BuSf+GOG3y+p006gecPBe2BWlFW8Tz+
         xoqP5ziJG0+iriWnOJo/ntVUUACu1kXEumuvf585W3H2XqezUbCAUbYsQX5tcEXh+qWI
         XScA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3NNNl+admW51ArOnz3DFZNJt6RTX+7wBAqLIs+fo8c4=;
        b=bZddq/92KuDj600JJfmPRqZnx56YVwKhqiD/SCEEKZNKDEcjNYevaC5ntDlxn2m2j1
         Eu1gHKQ+DEyhraG1tsk9vddgafLQTNEoMBr/M62s9Hi/OTu2ukUa+Xi/eVdgbjdk6AYu
         MREfExYPDWkkQ+do83luwGuBnyEqdGOwtoq6aQflu4WNoyULJAqJPTSAv98B3HfyPdM5
         lVtA3J1GTL7C2eN9NlYVOS2m8UvRa+702mGQXJGZIG2A5EkjQk8lT7VgnBmT49UfYco9
         +w1G0f5+/Rc1ooKltDDFDO06/3Yg5FRT4sMlNUoS//JMqqV5oGX8rgObC7glmySIeGtl
         750Q==
X-Gm-Message-State: AGi0PubP85KfDfR/Aoo7BwmZbYpVx0AdqrxvihwvYj9BMWRuRGeumtiO
        ElZCoailOq5tC+2kV0Hm//O2qbJYfC4=
X-Google-Smtp-Source: APiQypJmIMM8vx2ft/nc7sjJbUzuZKqvpPALk2HBksmzaekduSLM2t5LcfRiHJKBlfL+ImAz2UfeoQ==
X-Received: by 2002:a1c:b104:: with SMTP id a4mr37350887wmf.24.1589306395764;
        Tue, 12 May 2020 10:59:55 -0700 (PDT)
Received: from tool.localnet ([213.177.197.81])
        by smtp.googlemail.com with ESMTPSA id x5sm25077761wro.12.2020.05.12.10.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 10:59:55 -0700 (PDT)
From:   Daniel =?ISO-8859-1?Q?Gonz=E1lez?= Cabanelas <dgcbueu@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, thomas.petazzoni@bootlin.com
Subject: [PATCH] net: mvneta: speed down the PHY, if WoL used, to save energy
Date:   Tue, 12 May 2020 19:59:48 +0200
Message-ID: <32495177.Bv3dSJjO3Z@tool>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some PHYs connected to this ethernet hardware support the WoL feature.
But when WoL is enabled and the machine is powered off, the PHY remains
waiting for a magic packet at max speed (i.e. 1Gbps), which is a waste of
energy.

Slow down the PHY speed before stopping the ethernet if WoL is enabled,
and save some energy while the machine is powered off or sleeping.

Tested using an Armada 370 based board (LS421DE) equipped with a Marvell
88E1518 PHY.

Signed-off-by: Daniel Gonz=C3=A1lez Cabanelas <dgcbueu@gmail.com>
=2D--
 drivers/net/ethernet/marvell/mvneta.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/m=
arvell/mvneta.c
index 5188977095..e0e9e56830 100644
=2D-- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3561,6 +3561,10 @@ static void mvneta_start_dev(struct mvneta_port *pp)
 		    MVNETA_CAUSE_LINK_CHANGE);
=20
 	phylink_start(pp->phylink);
+
+	/* We may have called phy_speed_down before */
+	phy_speed_up(pp->dev->phydev);
+
 	netif_tx_start_all_queues(pp->dev);
 }
=20
@@ -3568,6 +3572,9 @@ static void mvneta_stop_dev(struct mvneta_port *pp)
 {
 	unsigned int cpu;
=20
+	if (device_may_wakeup(&pp->dev->dev))
+		phy_speed_down(pp->dev->phydev, false);
+
 	phylink_stop(pp->phylink);
=20
 	if (!pp->neta_armada3700) {
@@ -4040,6 +4047,10 @@ static int mvneta_mdio_probe(struct mvneta_port *pp)
 	phylink_ethtool_get_wol(pp->phylink, &wol);
 	device_set_wakeup_capable(&pp->dev->dev, !!wol.supported);
=20
+	/* PHY WoL may be enabled but device wakeup disabled */
+	if (wol.supported)
+		device_set_wakeup_enable(&pp->dev->dev, !!wol.wolopts);
+
 	return err;
 }
=20
=2D-=20
2.26.2




