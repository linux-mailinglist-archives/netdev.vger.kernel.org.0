Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496C560E37A
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbiJZOhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbiJZOhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:37:54 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0B1B7F77
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:37:53 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id m2so10204307pjr.3
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eTIJsZgmqePOP9eZKpB6HgjGD81o6xb78AHrtf1ewuw=;
        b=qY5k0bGUliMlMkMIGiXsMhV4MhvoTGyhrqL2U33LUvfABYWBec0LxgfSktqEEoHVh+
         5P6Tfug8NYVEPkXKB3ebKcj3LM81g7GbF6z9zVslPlXFKq91UMDWUeRBzNjC1/zXXLsa
         6wQx6zHKUKik2iLAWOvhuyI9ER4w47LmJnvbW2kBu2f36k+mm5/WEX0HoH1XsH8zwNxj
         YvyZqPq2IuWy8Cfn0LnNNiXxRWkPFec/AAy7XOzIC+hB7ujzddxBA90n6PBXWb6FkZum
         MaG+i4ut1QxlEZQTQDIU8b8vXjaLFsdYoSTfpzTjYnwM7y7wednK8njhHKpiAe0VQte7
         wGpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eTIJsZgmqePOP9eZKpB6HgjGD81o6xb78AHrtf1ewuw=;
        b=bxthBw15qcDqcDfRewD7ubcPveQZoeAoUZdR4YFxBuMrDF0kwdtCJ5kOVretPnV5H+
         Qpr+6wCI8j+/1Wq9+rosblYMuz/hOWN+kQBmuvH884v8adFqVLXxQ+G55DrB26xanveF
         Jgts0+jKw/RcHki5iFjMqgM6fyc/aYivDq9Cg6vEQWSOCueEOHOTnRxghsSYtQZ4yuv7
         LJOj89fTi170HSwiWcczJbYUJaZBqZGZf6L6EoGRXbbjvyLx95ODWpbe1ZJXL2ReYnKz
         KyMNpE3pgVXIBnKYTDR2MD3zgeycmIuNu6Lt4KiGitV8dA3WBbYyNCwpVZk2pLYi0vvK
         wtVw==
X-Gm-Message-State: ACrzQf2xDO99WmMAT/71SaHJYjXk0DKYR2sJZhtj4Z8dpSdjS17n2VRN
        WK2ghy1PNwrxBnAY/HpimrTcRQ==
X-Google-Smtp-Source: AMsMyM5ux1+aNBrTHG+f+YoYmcU2KwaZxTccm2TcOWFRVs14CPxNI27ySID4cbHGua4BkJEOJxqnMw==
X-Received: by 2002:a17:903:1112:b0:178:a030:5f72 with SMTP id n18-20020a170903111200b00178a0305f72mr44293966plh.12.1666795072771;
        Wed, 26 Oct 2022 07:37:52 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id d185-20020a6236c2000000b0056286c552ecsm3060484pfa.184.2022.10.26.07.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 07:37:51 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        leon@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 2/5] ionic: only save the user set VF attributes
Date:   Wed, 26 Oct 2022 07:37:41 -0700
Message-Id: <20221026143744.11598-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221026143744.11598-1-snelson@pensando.io>
References: <20221026143744.11598-1-snelson@pensando.io>
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

