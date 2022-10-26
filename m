Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1D4D60E379
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbiJZOhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234041AbiJZOhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:37:52 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCF7B6036
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:37:51 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 192so8312554pfx.5
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 07:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ryvnisjp6FqvGD+eQPde85PGfq1lBI/RzVG5wn3Q2SY=;
        b=im1QuXd5ckK20zGoNiDhifi0upbX55rj0m08F5kiqP1WMFjwS2kew+Z6MJTMdLX1La
         9Mt0az7ioAWcOFDRb1qN2RjDsWj17Kl/Rju6IUA1hYNekLQPswSeLCLfiUU4LpMgUtKB
         U1y0RM35E90XnQ7ryj+Dylr0iTuJpUGYHiZB54HYJKF8zNSuz6mypjJmyiNHEubRu3Zn
         S4BrHo1K6XcUIjc7PxMcycChmHBoGWdCSdgHiK6ylvraTt4ksvSX9CnWRnPbRE3vv7Jv
         E38NwqrJgjwzNNGxgz7cXYmtg/Q3HygjUNtxNBVk/gLLboCQUbTbMGZzHZTlMxZc9IKk
         eg+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ryvnisjp6FqvGD+eQPde85PGfq1lBI/RzVG5wn3Q2SY=;
        b=OInxJOYqRErzBHz92vuG2tI2tOm6Q+wUdT29bU5m5ccLjqjpmTpzQ7Dix5ONYIuW5c
         APGTx9b/iNEeeDywyaHNZaN1jmXOSSv5ibYM4k8AgB5cJphp6UUvaWG9BWd9ydlUJskf
         9zDsA0ILjqQ/U6ny34xYOyKGpdtzzGBrfWO0xBg047RdG3zqj35vSLS5mkDriCFzSxfJ
         94Bmft6/4Ux8VG1L7r5ku9LOrGX7qj39irgcqqOPUh/UxWBeSgByr9j2JlZ/JvhPcZJe
         xViiINTeRiQ/506sLfdDjCOPMmAOz3cVRLzuTTuiObvD9PlyXG6dk1U0Sz2P7PEjgbEy
         1B/g==
X-Gm-Message-State: ACrzQf1GUPZ+5tiTx0zO3mnD9XBjX+ix57HTzWwDb4jiDZEH2N9GXNWQ
        C5Q3tRW9AdEU3gtbP+Hwi5l6MQ==
X-Google-Smtp-Source: AMsMyM7ED+/vDqrKfoE9FWqFyva4u1MsLU4DxWq8bH40xjI9Kou0Giow+yhurMxmWMTpB3R/9quxyg==
X-Received: by 2002:a63:2a8b:0:b0:46e:9fda:2171 with SMTP id q133-20020a632a8b000000b0046e9fda2171mr28359799pgq.106.1666795071175;
        Wed, 26 Oct 2022 07:37:51 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id d185-20020a6236c2000000b0056286c552ecsm3060484pfa.184.2022.10.26.07.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 07:37:50 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        leon@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 1/5] ionic: replay VF attributes after fw crash recovery
Date:   Wed, 26 Oct 2022 07:37:40 -0700
Message-Id: <20221026143744.11598-2-snelson@pensando.io>
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

