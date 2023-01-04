Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE84A65CE25
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 09:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbjADIRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 03:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbjADIRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 03:17:11 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A2C1A04A
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 00:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672820228; x=1704356228;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sSvBcBI12vw1MARAbO1ubBywZxt4Qob6xj+HODXivy0=;
  b=nPvqkOJOLoR74lvtJd2nX8C1NLkwo6SlIl871jgFme5fDpCtExx3dknQ
   hP5aq0ty4X2y8uH3xw2Ca2EgOM4QiYirrkgRRxgmQP9+YCo4j8nkflvtY
   QalrLEGSUfh2EvDn6sAztB50X85YzYz6lJtbEAaM6n5dV4NPX3Z58alMq
   mNIChzwYrNft395sc0XB4thSW/LvRFRzwiOzF6cwEWgSMDruWkiLUf5E/
   hI4PI8BQRzbXblEMwZj3ZZDwBHgebsG5lz0fhDQUQpeCHrdPzKxZqbgsE
   bVTPkXjJPGhgWBa/WBacNeCBq+aipJ4yQCyl/m9ApaCA2fGxlNKMuvujP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="301561369"
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="301561369"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 00:17:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="632726101"
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="632726101"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 04 Jan 2023 00:16:59 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id BF2E319E; Wed,  4 Jan 2023 10:17:31 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 2/3] net: thunderbolt: Add debugging when sending/receiving control packets
Date:   Wed,  4 Jan 2023 10:17:30 +0200
Message-Id: <20230104081731.45928-3-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230104081731.45928-1-mika.westerberg@linux.intel.com>
References: <20230104081731.45928-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These can be useful when debugging possible issues around USB4NET
control packet exchange.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/net/thunderbolt/main.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/thunderbolt/main.c b/drivers/net/thunderbolt/main.c
index 990484776f2d..bd0c2af1172d 100644
--- a/drivers/net/thunderbolt/main.c
+++ b/drivers/net/thunderbolt/main.c
@@ -305,6 +305,8 @@ static int tbnet_logout_request(struct tbnet *net)
 
 static void start_login(struct tbnet *net)
 {
+	netdev_dbg(net->dev, "login started\n");
+
 	mutex_lock(&net->connection_lock);
 	net->login_sent = false;
 	net->login_received = false;
@@ -318,6 +320,8 @@ static void stop_login(struct tbnet *net)
 {
 	cancel_delayed_work_sync(&net->login_work);
 	cancel_work_sync(&net->connected_work);
+
+	netdev_dbg(net->dev, "login stopped\n");
 }
 
 static inline unsigned int tbnet_frame_size(const struct tbnet_frame *tf)
@@ -374,6 +378,8 @@ static void tbnet_tear_down(struct tbnet *net, bool send_logout)
 		int ret, retries = TBNET_LOGOUT_RETRIES;
 
 		while (send_logout && retries-- > 0) {
+			netdev_dbg(net->dev, "sending logout request %u\n",
+				   retries);
 			ret = tbnet_logout_request(net);
 			if (ret != -ETIMEDOUT)
 				break;
@@ -400,6 +406,8 @@ static void tbnet_tear_down(struct tbnet *net, bool send_logout)
 	net->login_sent = false;
 	net->login_received = false;
 
+	netdev_dbg(net->dev, "network traffic stopped\n");
+
 	mutex_unlock(&net->connection_lock);
 }
 
@@ -431,12 +439,15 @@ static int tbnet_handle_packet(const void *buf, size_t size, void *data)
 
 	switch (pkg->hdr.type) {
 	case TBIP_LOGIN:
+		netdev_dbg(net->dev, "remote login request received\n");
 		if (!netif_running(net->dev))
 			break;
 
 		ret = tbnet_login_response(net, route, sequence,
 					   pkg->hdr.command_id);
 		if (!ret) {
+			netdev_dbg(net->dev, "remote login response sent\n");
+
 			mutex_lock(&net->connection_lock);
 			net->login_received = true;
 			net->remote_transmit_path = pkg->transmit_path;
@@ -458,9 +469,12 @@ static int tbnet_handle_packet(const void *buf, size_t size, void *data)
 		break;
 
 	case TBIP_LOGOUT:
+		netdev_dbg(net->dev, "remote logout request received\n");
 		ret = tbnet_logout_response(net, route, sequence, command_id);
-		if (!ret)
+		if (!ret) {
+			netdev_dbg(net->dev, "remote logout response sent\n");
 			queue_work(system_long_wq, &net->disconnect_work);
+		}
 		break;
 
 	default:
@@ -612,6 +626,8 @@ static void tbnet_connected_work(struct work_struct *work)
 	if (!connected)
 		return;
 
+	netdev_dbg(net->dev, "login successful, enabling paths\n");
+
 	ret = tb_xdomain_alloc_in_hopid(net->xd, net->remote_transmit_path);
 	if (ret != net->remote_transmit_path) {
 		netdev_err(net->dev, "failed to allocate Rx HopID\n");
@@ -647,6 +663,8 @@ static void tbnet_connected_work(struct work_struct *work)
 
 	netif_carrier_on(net->dev);
 	netif_start_queue(net->dev);
+
+	netdev_dbg(net->dev, "network traffic started\n");
 	return;
 
 err_free_tx_buffers:
@@ -668,8 +686,13 @@ static void tbnet_login_work(struct work_struct *work)
 	if (netif_carrier_ok(net->dev))
 		return;
 
+	netdev_dbg(net->dev, "sending login request, retries=%u\n",
+		   net->login_retries);
+
 	ret = tbnet_login_request(net, net->login_retries % 4);
 	if (ret) {
+		netdev_dbg(net->dev, "sending login request failed, ret=%d\n",
+			   ret);
 		if (net->login_retries++ < TBNET_LOGIN_RETRIES) {
 			queue_delayed_work(system_long_wq, &net->login_work,
 					   delay);
@@ -677,6 +700,8 @@ static void tbnet_login_work(struct work_struct *work)
 			netdev_info(net->dev, "ThunderboltIP login timed out\n");
 		}
 	} else {
+		netdev_dbg(net->dev, "received login reply\n");
+
 		net->login_retries = 0;
 
 		mutex_lock(&net->connection_lock);
-- 
2.35.1

