Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650D960CAD9
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbiJYLYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbiJYLYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:24:39 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F8113C1FA
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:24:37 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so15929979pji.1
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eTIJsZgmqePOP9eZKpB6HgjGD81o6xb78AHrtf1ewuw=;
        b=DQpvxxeLqCF9uIV+4/nAUuXbfRIb2WwqbKU4HfAkZBBA5P1L7ogRELWNYr0703kns2
         awZDfByRDbB08Y0aY/6oPnU2h0Dyi0nKWkt94WUeIVKkLSNUaCVxSAchuB+JK7AO7N4T
         P0eHeGC3jN60vX/Pq105TDn7G0R528x5hggUabxn7BAypIFIv3cXjJWm1jTVjC5hrenw
         QKyhpw+sB2dYd/oZ499E35VWiWAzK6FXoppO/iARAQ6XeCj+8S9xwd2Ynh5G9O7Knt0B
         2wTKtZVq1pRfg72agdGa1uB6+yBPYOtmP2eZwT698ssI98Af8DhuScyokSyMA3bu5R7f
         OkYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eTIJsZgmqePOP9eZKpB6HgjGD81o6xb78AHrtf1ewuw=;
        b=DxmSyAZteaf/1pYX7nh4NuKgUGOacJrrtsZN7sGuCE58/jGrk/h681EYuiW6+Fhy/l
         LrcHqa25Jt8M422octTEm9m0TzXE6xiLHA3g/XVxi4+qQzVMk6fJApySBh3xTYvoMEjd
         Gw6Un6O2pIEA1+7LV25U5KZFEDmmBLd+EQuZeQdtUToW7inJo05A1jBzBDgS6IptPylX
         j6Vg13A1+xT1fk2Ir/WLeLiz9g2iLUKQqhrY9a3eCypwCIZYkdjT3++LRKUOaLI23Xiq
         o/HTWjn7rPyN5JlAUisokp9Mz5BGkLCbC+yjAdMRVO2DOiBlm1bwXP1vqKacMFcHKJi7
         XAYw==
X-Gm-Message-State: ACrzQf3SOUbP7ey/qSt3J1ouvBA71yVh9FxeSEXRRuqgJzIz3IpD46V9
        2Zdou+VMs9cwpE+l71T08aHV8g==
X-Google-Smtp-Source: AMsMyM75GqlI/2xU9PkwQMz2XrvK3qcypNY7Kj3ZvRxO2Gor92Syu5agSJoe/hlNpfnd8ZNVNvKTrg==
X-Received: by 2002:a17:90a:a017:b0:213:ad3:4d1a with SMTP id q23-20020a17090aa01700b002130ad34d1amr12064867pjp.120.1666697077192;
        Tue, 25 Oct 2022 04:24:37 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id w20-20020a1709029a9400b00185507b5ef8sm1073425plp.50.2022.10.25.04.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 04:24:36 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        leon@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 2/5] ionic: only save the user set VF attributes
Date:   Tue, 25 Oct 2022 04:24:23 -0700
Message-Id: <20221025112426.8954-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221025112426.8954-1-snelson@pensando.io>
References: <20221025112426.8954-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
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
index 865ee58a3b1f..a06b2da1e0c4 100644
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

