Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99DD6123BE7
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 01:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfLRAvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 19:51:32 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35794 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfLRAvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 19:51:31 -0500
Received: by mail-pf1-f196.google.com with SMTP id b19so217613pfo.2;
        Tue, 17 Dec 2019 16:51:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JLVhcc9VMHoyHLdT46bTemZl3YozDpYDY3B3T/6/MFI=;
        b=EaPlsDQbiHPB5yqbOe203la7fBcV4w3x4L2rbh+pgliBiiX7bDksYdVvhVVUsKgVTJ
         AH0uqqOX9GMu6dGNS+YKsPdPnX/mpgPKYUsFa9T1t2x39BwOfRMVU27mmABfoyea3Uph
         iMMD4msoQ4sJjvPwWS19yMelLDoWN52xVA1xBh8hR2cLbnVaKHbSH5JWud0+eJJBaovw
         rAG3bZY1bRoLAS+Ow9UN6G3ltgFOptIG071t9bhgxLuByvrdwhpGK9uTksy4MNxxzpFI
         VfsUhQuTQjHtDbwLUmJ3CucuQoQnNFSehutZCEoy+GvSDAgcrKLo6SAapjm4a/tMypk+
         K2aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JLVhcc9VMHoyHLdT46bTemZl3YozDpYDY3B3T/6/MFI=;
        b=MAqV7yFCPCUAS5s3p2CIghBR37UkesUQzG+gHqpZzoruWBCQ6alfdKRUAOqlZSlBiI
         GW6vtBn5lPWXNlxBESDdCBMEgKMUo2AsHVRJToYGw0K1kkf1kXFMhv6h9ulEPEsDGv1P
         I83QcO9MdxhhLtDDOI265rOKoNDLZZFe98I0lhrWlfZAGO/B1TY2E9crWC0Ayhs1O5H4
         W/Rh7j8rAr/RHlQk+5gjJnuPbubtcgy3dqRUIisroEHhYOfyqXfN/Cb0aKOR0z9uQ0Jf
         xOjl/IXw5JcECOyRJBrtUcrTNfhDYsC5Na6/zMOX8ObY5BuoGe9VJbQpV9AQPMJ+2S1b
         qA1g==
X-Gm-Message-State: APjAAAWHP/E1R0L6/8rMJFJDtXBnKT1msqVTL3EQR0C95T9ih7osrBgw
        hgvfHxTC046wiFGyelCndhk=
X-Google-Smtp-Source: APXvYqyATA/5yWth8lWCDMpRJD/Y+3wdK5BSIpgNiPRXFyJA8BQkLrCvtySl4Te39OD/Fks73zKBOA==
X-Received: by 2002:aa7:98d0:: with SMTP id e16mr663203pfm.77.1576630290713;
        Tue, 17 Dec 2019 16:51:30 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 81sm274819pfx.30.2019.12.17.16.51.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 16:51:30 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next v2 5/8] net: bcmgenet: Utilize bcmgenet_set_features() during resume/open
Date:   Tue, 17 Dec 2019 16:51:12 -0800
Message-Id: <1576630275-17591-6-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576630275-17591-1-git-send-email-opendmb@gmail.com>
References: <1576630275-17591-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During driver resume and open, the HW may have lost its context/state,
utilize bcmgenet_set_features() to make sure we do restore the correct
set of features that were previously configured.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 811713e3d230..0e57effd5b19 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2884,6 +2884,11 @@ static int bcmgenet_open(struct net_device *dev)
 
 	init_umac(priv);
 
+	/* Apply features again in case we changed them while interface was
+	 * down
+	 */
+	bcmgenet_set_features(dev, dev->features);
+
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
 	if (priv->internal_phy) {
@@ -3687,6 +3692,9 @@ static int bcmgenet_resume(struct device *d)
 	genphy_config_aneg(dev->phydev);
 	bcmgenet_mii_config(priv->dev, false);
 
+	/* Restore enabled features */
+	bcmgenet_set_features(dev, dev->features);
+
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
 	if (priv->internal_phy) {
-- 
2.7.4

