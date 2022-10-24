Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7863609ECF
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 12:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiJXKR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 06:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiJXKR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 06:17:28 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE179688B6
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 03:17:27 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d24so8065863pls.4
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 03:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=S0d7gcEhnJJ5kpkSJwxTbH/pz03nzSwFV7yqmr90Y34=;
        b=GLBnozeLXsN1+0v3P5hTyWFTSKiEbTEBL1sQEYITxIYXxOzoLxQ/fzBHDonRyDW7EL
         YDBLROAtFwHLix2D3CjPyZBbKMnAA7aizhyB1IyKRobF/i5u+oAzzvbEbomEwOp58793
         dxsA8sZVL4ehD77NTWb8oX4B3LmW9321/lClVIvqB/sbtPKXlRCT9/aXaKcZp5sUEHh9
         KeRBKwvSMYWnP2IEuRVEVEIBtKEbI8Dsf+NJd/fv9hd6QSLUXECMFuFZ/AKo+g5g67gN
         bHD0xDp6lKVjry83ulQOtUKCD6Wai+eY/7LBQLIrMfUot8NI6tmFQIObd/wi0P7LYOzp
         S7aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S0d7gcEhnJJ5kpkSJwxTbH/pz03nzSwFV7yqmr90Y34=;
        b=LIJ0tnAnCKqqNJxPp0okjVJ/lT2cWGv4n37v8NYC7lGaF3S2EF9UuRki/8xg1cjvE+
         kYY+2p/VDniBBT/sECTxJOHfeVd1P5LIK5vP4JjbxGPC/qsF7ty3WUV2JHQeFV8+eYl3
         xSeYAnHWx2qKB+8ntpUN4HfM4RKAXLmjMivku0N9kEyvA2rVysv1igATkiymXGbD0/k1
         mbiAh3sz2KmtMDMlaWRT6FCmueJEVZI9w6foiM0dzS12qn1WGEfkwMgqZ48kNm8hCj9d
         gBn1MtfTJMIBC/IbmvWUbLG9gIdicsB3SsYH+cr4bISf/7hZuHeDj3ER6icjChRPCGx4
         4YgQ==
X-Gm-Message-State: ACrzQf2W+7i3O3cN0dhwkjERG3C5fakU4v8otTb+puGxrsoyv6OXsLf3
        ORHjk2uRSfEhynOUcjfNoz2JYKS6N9OMuQ==
X-Google-Smtp-Source: AMsMyM6lVgSye+SV00SKWFayJGPfVo/IoaSTpCRSAHc+8c+1L1F2Cze0TEU9etlNC6wjz8D0fOMDlA==
X-Received: by 2002:a17:90b:4a0b:b0:212:d400:4173 with SMTP id kk11-20020a17090b4a0b00b00212d4004173mr17879686pjb.195.1666606647214;
        Mon, 24 Oct 2022 03:17:27 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h197-20020a6283ce000000b0056bf6cd44cdsm586290pfe.91.2022.10.24.03.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 03:17:26 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/5] ionic: replay VF attributes after fw crash recovery
Date:   Mon, 24 Oct 2022 03:17:13 -0700
Message-Id: <20221024101717.458-2-snelson@pensando.io>
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

The VF attributes that the user has set into the FW through
the PF can be lost over a FW crash recovery.  Much like we
already replay the PF mac/vlan filters, we now add a replay
in the recovery path to be sure the FW has the up-to-date
VF configurations.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 70 +++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 19d4848df17d..5d593198ad72 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2562,6 +2562,74 @@ static int ionic_set_vf_link_state(struct net_device *netdev, int vf, int set)
 	return ret;
 }
 
+static void ionic_vf_attr_replay(struct ionic_lif *lif)
+{
+	struct ionic_vf_setattr_cmd vfc = { 0 };
+	struct ionic *ionic = lif->ionic;
+	struct ionic_vf *v;
+	int i;
+
+	if (!ionic->vfs)
+		return;
+
+	down_read(&ionic->vf_op_lock);
+
+	for (i = 0; i < ionic->num_vfs; i++) {
+		v = &ionic->vfs[i];
+
+		if (v->stats_pa) {
+			vfc.attr = IONIC_VF_ATTR_STATSADDR;
+			vfc.stats_pa = cpu_to_le64(v->stats_pa);
+			(void)ionic_set_vf_config(ionic, i, &vfc);
+			vfc.stats_pa = 0;
+		}
+
+		if (!is_zero_ether_addr(v->macaddr)) {
+			vfc.attr = IONIC_VF_ATTR_MAC;
+			ether_addr_copy(vfc.macaddr, v->macaddr);
+			(void)ionic_set_vf_config(ionic, i, &vfc);
+			eth_zero_addr(vfc.macaddr);
+		}
+
+		if (v->vlanid) {
+			vfc.attr = IONIC_VF_ATTR_VLAN;
+			vfc.vlanid = v->vlanid;
+			(void)ionic_set_vf_config(ionic, i, &vfc);
+			vfc.vlanid = 0;
+		}
+
+		if (v->maxrate) {
+			vfc.attr = IONIC_VF_ATTR_RATE;
+			vfc.maxrate = v->maxrate;
+			(void)ionic_set_vf_config(ionic, i, &vfc);
+			vfc.maxrate = 0;
+		}
+
+		if (v->spoofchk) {
+			vfc.attr = IONIC_VF_ATTR_SPOOFCHK;
+			vfc.spoofchk = v->spoofchk;
+			(void)ionic_set_vf_config(ionic, i, &vfc);
+			vfc.spoofchk = 0;
+		}
+
+		if (v->trusted) {
+			vfc.attr = IONIC_VF_ATTR_TRUST;
+			vfc.trust = v->trusted;
+			(void)ionic_set_vf_config(ionic, i, &vfc);
+			vfc.trust = 0;
+		}
+
+		if (v->linkstate) {
+			vfc.attr = IONIC_VF_ATTR_LINKSTATE;
+			vfc.linkstate = v->linkstate;
+			(void)ionic_set_vf_config(ionic, i, &vfc);
+			vfc.linkstate = 0;
+		}
+	}
+
+	up_read(&ionic->vf_op_lock);
+}
+
 static const struct net_device_ops ionic_netdev_ops = {
 	.ndo_open               = ionic_open,
 	.ndo_stop               = ionic_stop,
@@ -3042,6 +3110,8 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 	if (err)
 		goto err_qcqs_free;
 
+	ionic_vf_attr_replay(lif);
+
 	if (lif->registered)
 		ionic_lif_set_netdev_info(lif);
 
-- 
2.17.1

