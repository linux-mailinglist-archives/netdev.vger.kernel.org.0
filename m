Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B038B60CADA
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiJYLYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbiJYLYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:24:39 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6061211DC
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:24:36 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so6358561pjc.3
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ryvnisjp6FqvGD+eQPde85PGfq1lBI/RzVG5wn3Q2SY=;
        b=YiY9IMDqdculw6vYihrguNmCp5hHFXIrfw/JKfoUQrvSJ/YFc/L7MK5LaJfI4r/JRE
         HubVFJhtiokom2pOYwyoj6n5u613VgEoKUAnQ8BLHWMaK+jZmB7rdGX9R42BrrkWOqaj
         AT/U0kglnOedPfx8ES5jtO0fQm4pg3WBrfKmUzuICh3KBbKBhZ1doqLOalqo1lpvYXJs
         gN3VUYqzRJmMVaqFx1l0rQRXZNCshhBw/rpF0NQEoDOXi75k78grOIcdDdTxKffRJeoU
         01ZD5zJYXXh3EbBsTbG9JyBtgfco2eLVJxAM4KpDVvS7JIG0qj8H85hSmmeQ3KGq9H60
         dOdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ryvnisjp6FqvGD+eQPde85PGfq1lBI/RzVG5wn3Q2SY=;
        b=yjwMMXWf38Cthajjk4rVIxVK2AGxQNYhUOMvmchL/hISl/9JV0Se0tlK49P/Dulinv
         gX9iAnFWKBsC+czMAFHvCikEvp5nfyWypVhP+wQaj/kNpusyd+zN8lVS4AJfb8qkj3vi
         z8tmp68/2yZUK+HafxfSHl7dAH+WwfNNCR5cthTPb06fxbFmuEi1+bnOt1NeeVD+cNFh
         3LgFHIalW/W18MJ/UpYly+VU9yTnPYBZb0Er3txbgSNZ7F1Zj5cXLVZ2+SuNBQ0ZMGB2
         YaY/C4h6P/qjL19bsy+zliyILjIGE9Ai1Cy9/Do8sHah3V8iVVfSwSbvgRQ3M2DYdq/5
         2TvA==
X-Gm-Message-State: ACrzQf1Dkwnhg5gFRO/7dbSJEOfMe2jTBH8lFEqqjYhiI2M0NXNv7ebM
        qsveITIOX6xsBDcjhgWzcUA7iQ==
X-Google-Smtp-Source: AMsMyM4xM/IVd3JJukdqKD08igMpYIu423A9A775cQfrXkXp2Jgka8ZSgPUwDyICcDaOv5SF6Sh0bw==
X-Received: by 2002:a17:90b:3b8d:b0:20d:5c7a:abf1 with SMTP id pc13-20020a17090b3b8d00b0020d5c7aabf1mr45350856pjb.118.1666697075753;
        Tue, 25 Oct 2022 04:24:35 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id w20-20020a1709029a9400b00185507b5ef8sm1073425plp.50.2022.10.25.04.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 04:24:35 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        leon@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 1/5] ionic: replay VF attributes after fw crash recovery
Date:   Tue, 25 Oct 2022 04:24:22 -0700
Message-Id: <20221025112426.8954-2-snelson@pensando.io>
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
index 19d4848df17d..865ee58a3b1f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2562,6 +2562,74 @@ static int ionic_set_vf_link_state(struct net_device *netdev, int vf, int set)
 	return ret;
 }
 
+static void ionic_vf_attr_replay(struct ionic_lif *lif)
+{
+	struct ionic_vf_setattr_cmd vfc = { };
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
+			ionic_set_vf_config(ionic, i, &vfc);
+			vfc.stats_pa = 0;
+		}
+
+		if (!is_zero_ether_addr(v->macaddr)) {
+			vfc.attr = IONIC_VF_ATTR_MAC;
+			ether_addr_copy(vfc.macaddr, v->macaddr);
+			ionic_set_vf_config(ionic, i, &vfc);
+			eth_zero_addr(vfc.macaddr);
+		}
+
+		if (v->vlanid) {
+			vfc.attr = IONIC_VF_ATTR_VLAN;
+			vfc.vlanid = v->vlanid;
+			ionic_set_vf_config(ionic, i, &vfc);
+			vfc.vlanid = 0;
+		}
+
+		if (v->maxrate) {
+			vfc.attr = IONIC_VF_ATTR_RATE;
+			vfc.maxrate = v->maxrate;
+			ionic_set_vf_config(ionic, i, &vfc);
+			vfc.maxrate = 0;
+		}
+
+		if (v->spoofchk) {
+			vfc.attr = IONIC_VF_ATTR_SPOOFCHK;
+			vfc.spoofchk = v->spoofchk;
+			ionic_set_vf_config(ionic, i, &vfc);
+			vfc.spoofchk = 0;
+		}
+
+		if (v->trusted) {
+			vfc.attr = IONIC_VF_ATTR_TRUST;
+			vfc.trust = v->trusted;
+			ionic_set_vf_config(ionic, i, &vfc);
+			vfc.trust = 0;
+		}
+
+		if (v->linkstate) {
+			vfc.attr = IONIC_VF_ATTR_LINKSTATE;
+			vfc.linkstate = v->linkstate;
+			ionic_set_vf_config(ionic, i, &vfc);
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

