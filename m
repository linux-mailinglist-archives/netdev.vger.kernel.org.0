Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAB9609ED0
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 12:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiJXKRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 06:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiJXKR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 06:17:29 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECD7688AE
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 03:17:28 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso6043214pjc.0
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 03:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sB+p3H1YwsKkIV+Z5v1g8fBi0nOAx7Yvg5DG0vbIZoU=;
        b=YEPVdP4cAjeRgFNbrkykGMsSyi5SB1vEB1VD2ZgrCG840ZGorPHudaOm+EP4yc5Pfm
         0MmsXCZBHUlWUX9JD5MG6uZT1sJciJtYC71tRfi0L6URvj3UfCLRaP/czBeEmQRK1boQ
         wX82HO4nAXcDJ+8TxReRodxXnzDXngiPYTwe8H/AWXZRq4r97igk2PxtHTQbvujTtRD6
         mDQOCyrTKsFCXK3jTSgqXF4aUx691rSQxVyCyvSJt85xy9mmQ4YiA1d3UDPLqj3izxup
         8/7/+apuNQEA/UF54+jV4RqZkYCEjMPaUcgP0wguWKh+WBFf6GPN38wh6LKefK/QizW/
         aOWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sB+p3H1YwsKkIV+Z5v1g8fBi0nOAx7Yvg5DG0vbIZoU=;
        b=N0AFKpePYqn8SLxBMHM+WXwC0E0/k1fBC1C1ZhJJ5YrvHk8DFA/8nyF7TbNKhpjhfX
         YjzG62DYhFHXhBVpWwYXeP5QtJQmmHn+8Xpx1OWLogDUevr4tdvFV/f2L9ivA97AR1X/
         A9uzfqgfP74L3btm6zS16OifYmaWmDC1NtLYlwZkZtuwvGmqxl3Zw5DluqqC25T0d3++
         v4PvAGxB7ebaEXh2Gfdw5rqnowm6OZnRBFoq0rHyt1Wy2puwY6X18my1Wg9PN1mxL9wB
         FCfr6bvhb6yDJ6udNPY2Elnd6ZTCfwngnV2fUJDtptsyjlaqS7Y9/TmP+SfKchZco8Rh
         Hivg==
X-Gm-Message-State: ACrzQf0gx8/wqDoBK0238VRA2Ech/406N23I9o1yK+pWjuwmwioPTbF4
        6ZxWR4oWbwPO7tAlrBnD8dhY4Q==
X-Google-Smtp-Source: AMsMyM6+xz82hpag/PeA78zlKIAcG7ppAte4i9G2ONpYaND1PMOs5UJf2fi4zf/6YDUPj5PIiRGeSg==
X-Received: by 2002:a17:903:124e:b0:178:6946:a2ba with SMTP id u14-20020a170903124e00b001786946a2bamr32490012plh.89.1666606648483;
        Mon, 24 Oct 2022 03:17:28 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h197-20020a6283ce000000b0056bf6cd44cdsm586290pfe.91.2022.10.24.03.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 03:17:27 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/5] ionic: only save the user set VF attributes
Date:   Mon, 24 Oct 2022 03:17:14 -0700
Message-Id: <20221024101717.458-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221024101717.458-1-snelson@pensando.io>
References: <20221024101717.458-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report the current FW values for the VF attributes, but don't
save the FW values locally, only save the vf attributes that
are given to us from the user.  This allows us to replay user
data, and doesn't end up confusing things like "who set the
mac address".

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 33 ++++++++++---------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 5d593198ad72..39a2e693e715 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2220,7 +2220,7 @@ static int ionic_eth_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd
 	}
 }
 
-static int ionic_update_cached_vf_config(struct ionic *ionic, int vf)
+static int ionic_get_fw_vf_config(struct ionic *ionic, int vf, struct ionic_vf *vfdata)
 {
 	struct ionic_vf_getattr_comp comp = { 0 };
 	int err;
@@ -2231,14 +2231,14 @@ static int ionic_update_cached_vf_config(struct ionic *ionic, int vf)
 	if (err && comp.status != IONIC_RC_ENOSUPP)
 		goto err_out;
 	if (!err)
-		ionic->vfs[vf].vlanid = comp.vlanid;
+		vfdata->vlanid = comp.vlanid;
 
 	attr = IONIC_VF_ATTR_SPOOFCHK;
 	err = ionic_dev_cmd_vf_getattr(ionic, vf, attr, &comp);
 	if (err && comp.status != IONIC_RC_ENOSUPP)
 		goto err_out;
 	if (!err)
-		ionic->vfs[vf].spoofchk = comp.spoofchk;
+		vfdata->spoofchk = comp.spoofchk;
 
 	attr = IONIC_VF_ATTR_LINKSTATE;
 	err = ionic_dev_cmd_vf_getattr(ionic, vf, attr, &comp);
@@ -2247,13 +2247,13 @@ static int ionic_update_cached_vf_config(struct ionic *ionic, int vf)
 	if (!err) {
 		switch (comp.linkstate) {
 		case IONIC_VF_LINK_STATUS_UP:
-			ionic->vfs[vf].linkstate = IFLA_VF_LINK_STATE_ENABLE;
+			vfdata->linkstate = IFLA_VF_LINK_STATE_ENABLE;
 			break;
 		case IONIC_VF_LINK_STATUS_DOWN:
-			ionic->vfs[vf].linkstate = IFLA_VF_LINK_STATE_DISABLE;
+			vfdata->linkstate = IFLA_VF_LINK_STATE_DISABLE;
 			break;
 		case IONIC_VF_LINK_STATUS_AUTO:
-			ionic->vfs[vf].linkstate = IFLA_VF_LINK_STATE_AUTO;
+			vfdata->linkstate = IFLA_VF_LINK_STATE_AUTO;
 			break;
 		default:
 			dev_warn(ionic->dev, "Unexpected link state %u\n", comp.linkstate);
@@ -2266,21 +2266,21 @@ static int ionic_update_cached_vf_config(struct ionic *ionic, int vf)
 	if (err && comp.status != IONIC_RC_ENOSUPP)
 		goto err_out;
 	if (!err)
-		ionic->vfs[vf].maxrate = comp.maxrate;
+		vfdata->maxrate = comp.maxrate;
 
 	attr = IONIC_VF_ATTR_TRUST;
 	err = ionic_dev_cmd_vf_getattr(ionic, vf, attr, &comp);
 	if (err && comp.status != IONIC_RC_ENOSUPP)
 		goto err_out;
 	if (!err)
-		ionic->vfs[vf].trusted = comp.trust;
+		vfdata->trusted = comp.trust;
 
 	attr = IONIC_VF_ATTR_MAC;
 	err = ionic_dev_cmd_vf_getattr(ionic, vf, attr, &comp);
 	if (err && comp.status != IONIC_RC_ENOSUPP)
 		goto err_out;
 	if (!err)
-		ether_addr_copy(ionic->vfs[vf].macaddr, comp.macaddr);
+		ether_addr_copy(vfdata->macaddr, comp.macaddr);
 
 err_out:
 	if (err)
@@ -2295,6 +2295,7 @@ static int ionic_get_vf_config(struct net_device *netdev,
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic *ionic = lif->ionic;
+	struct ionic_vf vfdata = { 0 };
 	int ret = 0;
 
 	if (!netif_device_present(netdev))
@@ -2308,14 +2309,14 @@ static int ionic_get_vf_config(struct net_device *netdev,
 		ivf->vf = vf;
 		ivf->qos = 0;
 
-		ret = ionic_update_cached_vf_config(ionic, vf);
+		ret = ionic_get_fw_vf_config(ionic, vf, &vfdata);
 		if (!ret) {
-			ivf->vlan         = le16_to_cpu(ionic->vfs[vf].vlanid);
-			ivf->spoofchk     = ionic->vfs[vf].spoofchk;
-			ivf->linkstate    = ionic->vfs[vf].linkstate;
-			ivf->max_tx_rate  = le32_to_cpu(ionic->vfs[vf].maxrate);
-			ivf->trusted      = ionic->vfs[vf].trusted;
-			ether_addr_copy(ivf->mac, ionic->vfs[vf].macaddr);
+			ivf->vlan         = le16_to_cpu(vfdata.vlanid);
+			ivf->spoofchk     = vfdata.spoofchk;
+			ivf->linkstate    = vfdata.linkstate;
+			ivf->max_tx_rate  = le32_to_cpu(vfdata.maxrate);
+			ivf->trusted      = vfdata.trusted;
+			ether_addr_copy(ivf->mac, vfdata.macaddr);
 		}
 	}
 
-- 
2.17.1

