Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9445F60D1
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 07:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiJFFxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 01:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiJFFxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 01:53:13 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DFE4E57E39;
        Wed,  5 Oct 2022 22:53:12 -0700 (PDT)
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id AA88220D5F38;
        Wed,  5 Oct 2022 22:53:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AA88220D5F38
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1665035592;
        bh=Iv/HyXwyWvio7WsumWzIXqsQdEUafXvlyqJC/QOR3Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQgoGmU/B+Xt6CDxjxC4KN+h7idTPWtuB/f4noggdDGXsIqGLtj16F/37PJqw5jtc
         BZRwHEHIRUd3PUzJ0OyVs4wWER6+wuVrX8pQIkSK1c9IzHHxajf4tRawaOCwG9DivY
         ZCVvBbzBzvsivw9JLa+RACNkLZpO7xhMosmiecsI=
From:   Gaurav Kohli <gauravkohli@linux.microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2 net] hv_netvsc: Fix race between VF offering and VF association message from host
Date:   Wed,  5 Oct 2022 22:52:59 -0700
Message-Id: <1665035579-13755-2-git-send-email-gauravkohli@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1665035579-13755-1-git-send-email-gauravkohli@linux.microsoft.com>
References: <1665035579-13755-1-git-send-email-gauravkohli@linux.microsoft.com>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During vm boot, there might be possibility that vf registration
call comes before the vf association from host to vm.

And this might break netvsc vf path, To prevent the same block
vf registration until vf bind message comes from host.

Cc: stable@vger.kernel.org
Fixes: 00d7ddba11436 ("hv_netvsc: pair VF based on serial number")
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Gaurav Kohli <gauravkohli@linux.microsoft.com>
---
v2: Move reinit completion to vf unregister call
---
 drivers/net/hyperv/hyperv_net.h |  3 ++-
 drivers/net/hyperv/netvsc.c     |  4 ++++
 drivers/net/hyperv/netvsc_drv.c | 19 +++++++++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 25b38a374e3c..dd5919ec408b 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -1051,7 +1051,8 @@ struct net_device_context {
 	u32 vf_alloc;
 	/* Serial number of the VF to team with */
 	u32 vf_serial;
-
+	/* completion variable to confirm vf association */
+	struct completion vf_add;
 	/* Is the current data path through the VF NIC? */
 	bool  data_path_is_vf;
 
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 8bcba6f21aa9..8843cbeadabf 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1582,6 +1582,10 @@ static void netvsc_send_vf(struct net_device *ndev,
 
 	net_device_ctx->vf_alloc = nvmsg->msg.v4_msg.vf_assoc.allocated;
 	net_device_ctx->vf_serial = nvmsg->msg.v4_msg.vf_assoc.serial;
+
+	if (net_device_ctx->vf_alloc)
+		complete(&net_device_ctx->vf_add);
+
 	netdev_info(ndev, "VF slot %u %s\n",
 		    net_device_ctx->vf_serial,
 		    net_device_ctx->vf_alloc ? "added" : "removed");
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index c27cb1267ca5..664a30aa46ea 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2309,6 +2309,18 @@ static struct net_device *get_netvsc_byslot(const struct net_device *vf_netdev)
 
 	}
 
+	/* Fallback path to check synthetic vf with
+	 * help of mac addr
+	 */
+	list_for_each_entry(ndev_ctx, &netvsc_dev_list, list) {
+		ndev = hv_get_drvdata(ndev_ctx->device_ctx);
+		if (ether_addr_equal(vf_netdev->perm_addr, ndev->perm_addr)) {
+			netdev_notice(vf_netdev,
+				      "falling back to mac addr based matching\n");
+			return ndev;
+		}
+	}
+
 	netdev_notice(vf_netdev,
 		      "no netdev found for vf serial:%u\n", serial);
 	return NULL;
@@ -2405,6 +2417,11 @@ static int netvsc_vf_changed(struct net_device *vf_netdev, unsigned long event)
 	if (net_device_ctx->data_path_is_vf == vf_is_up)
 		return NOTIFY_OK;
 
+	if (vf_is_up && !net_device_ctx->vf_alloc) {
+		netdev_info(ndev, "Waiting for the VF association from host\n");
+		wait_for_completion(&net_device_ctx->vf_add);
+	}
+
 	ret = netvsc_switch_datapath(ndev, vf_is_up);
 
 	if (ret) {
@@ -2436,6 +2453,7 @@ static int netvsc_unregister_vf(struct net_device *vf_netdev)
 
 	netvsc_vf_setxdp(vf_netdev, NULL);
 
+	reinit_completion(&net_device_ctx->vf_add);
 	netdev_rx_handler_unregister(vf_netdev);
 	netdev_upper_dev_unlink(vf_netdev, ndev);
 	RCU_INIT_POINTER(net_device_ctx->vf_netdev, NULL);
@@ -2475,6 +2493,7 @@ static int netvsc_probe(struct hv_device *dev,
 
 	INIT_DELAYED_WORK(&net_device_ctx->dwork, netvsc_link_change);
 
+	init_completion(&net_device_ctx->vf_add);
 	spin_lock_init(&net_device_ctx->lock);
 	INIT_LIST_HEAD(&net_device_ctx->reconfig_events);
 	INIT_DELAYED_WORK(&net_device_ctx->vf_takeover, netvsc_vf_setup);
-- 
2.17.1

