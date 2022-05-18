Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDB952C3DF
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 21:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242189AbiERT4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 15:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242251AbiERT4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 15:56:08 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2C325EAA
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 12:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652903766; x=1684439766;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NvADOC92tgFfzwNAm1YNP8ktaOeJZhmEMU5o/ONMg4Y=;
  b=SxLPSOs6TsiNNTZtEnsuZvWupBffi/ZOucPJHvGIdlQSaGBq7ZiRY3Z/
   6cmR/e55r499v+TNorCtOhVx+08J1rDPsiUWZ3WZlrOdstahzYVRpoqEY
   yr6bHPlh3o1sGjFn8I/a7/CVH5fDBnD+IUtY9ssT5mC0aGz3/l6lE6fjp
   mb172m7QjUwhaoLCsYP1ReKcEYYK1ZY2U9/EIOMwGgKSuLRBYc/s12hzo
   //2W2JVz7NoMDmVRz0bLIIc2RJFDu8fSmLg1Dk8D7lv+rrPO9gBl3fr5p
   PMGTSPH7Qh2CUSxkA/Nuy9zZBbqbkegEsLuSemx38Od3F19iSLaF5NRpJ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="297166592"
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="297166592"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 12:56:06 -0700
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="575253739"
Received: from tjthrave-mobl.amr.corp.intel.com (HELO rmarti10-nuc3.hsd1.or.comcast.net) ([10.209.55.61])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 12:56:05 -0700
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, haijun.liu@mediatek.com,
        ilpo.jarvinen@linux.intel.com, moises.veleta@intel.com,
        sreehari.kancharla@intel.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net-next 1/1] net: wwan: t7xx: Fix smatch errors
Date:   Wed, 18 May 2022 12:55:29 -0700
Message-Id: <20220518195529.126246-1-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

t7xx_request_irq() error: uninitialized symbol 'ret'.

t7xx_core_hk_handler() error: potentially dereferencing uninitialized 'event'.
If the condition to enter the loop that waits for the handshake event
is false on the first iteration then the uninitialized 'event' will be
dereferenced, fix this by initializing 'event' to NULL.

t7xx_port_proxy_recv_skb() warn: variable dereferenced before check 'skb'.
No need to check skb at t7xx_port_proxy_recv_skb() since we know it
is always called with a valid skb by t7xx_cldma_gpd_rx_from_q().

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
---
 drivers/net/wwan/t7xx/t7xx_modem_ops.c  | 4 ++--
 drivers/net/wwan/t7xx/t7xx_pci.c        | 2 +-
 drivers/net/wwan/t7xx/t7xx_port_proxy.c | 3 ---
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
index 1056ad9bf34f..3458af31e864 100644
--- a/drivers/net/wwan/t7xx/t7xx_modem_ops.c
+++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
@@ -458,9 +458,9 @@ static void t7xx_core_hk_handler(struct t7xx_modem *md, struct t7xx_fsm_ctl *ctl
 				 enum t7xx_fsm_event_state event_id,
 				 enum t7xx_fsm_event_state err_detect)
 {
+	struct t7xx_fsm_event *event = NULL, *event_next;
 	struct t7xx_sys_info *core_info = &md->core_md;
 	struct device *dev = &md->t7xx_dev->pdev->dev;
-	struct t7xx_fsm_event *event, *event_next;
 	unsigned long flags;
 	int ret;
 
@@ -493,7 +493,7 @@ static void t7xx_core_hk_handler(struct t7xx_modem *md, struct t7xx_fsm_ctl *ctl
 			goto err_free_event;
 	}
 
-	if (ctl->exp_flg)
+	if (!event || ctl->exp_flg)
 		goto err_free_event;
 
 	ret = t7xx_parse_host_rt_data(ctl, core_info, dev, event->data, event->length);
diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
index 5f1bb8d6afb6..871f2a27a398 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.c
+++ b/drivers/net/wwan/t7xx/t7xx_pci.c
@@ -568,7 +568,7 @@ static const struct dev_pm_ops t7xx_pci_pm_ops = {
 static int t7xx_request_irq(struct pci_dev *pdev)
 {
 	struct t7xx_pci_dev *t7xx_dev;
-	int ret, i;
+	int ret = 0, i;
 
 	t7xx_dev = pci_get_drvdata(pdev);
 
diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
index 7d2c0e81e33d..d4de047ff0d4 100644
--- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
+++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
@@ -350,9 +350,6 @@ static int t7xx_port_proxy_recv_skb(struct cldma_queue *queue, struct sk_buff *s
 	u16 seq_num, channel;
 	int ret;
 
-	if (!skb)
-		return -EINVAL;
-
 	channel = FIELD_GET(CCCI_H_CHN_FLD, le32_to_cpu(ccci_h->status));
 	if (t7xx_fsm_get_md_state(ctl) == MD_STATE_INVALID) {
 		dev_err_ratelimited(dev, "Packet drop on channel 0x%x, modem not ready\n", channel);
-- 
2.25.1

