Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9366951A1D8
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 16:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351074AbiEDONH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 10:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346211AbiEDONG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 10:13:06 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F82E419A9
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 07:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651673370; x=1683209370;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=y9vBG3r8gn3h07Ddr/d6O7mDisn8gP2LaIqQJqTouI4=;
  b=Uv9ELbFI9zKY8bfyMl7Q/simgEyc2FzQTiN8QslPc1MPvPPWgn7nfzmg
   Ylnmq96Op8Im1TSBAJXN1aHXApY8zxoMCqtieA7hwBKKuOJoZNW9jrbSI
   Ft41EwhCALc06a/c1PhC8P1mdsFUfyed7Nlt0yWyV5wJlblWRJ7gLH8WY
   VwsD16YIzoZl+8BBYphQOZfAJTUfY8hEzgjyfYd+rnAeegKLEWqHWZV+C
   dh+iMQTKaNZm2nx1aLdtrrgBfXQef5N/8Cp3v0gPq+qUX4EabHUV7wWYd
   +WE9Cnl7EjbRGPW69dKgEyh6OwDW1DE3mtnO+5wRBFPVn62Qvd/MIZE33
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="354211894"
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="354211894"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 07:09:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="694059407"
Received: from bswcg005.iind.intel.com ([10.224.174.19])
  by orsmga004.jf.intel.com with ESMTP; 04 May 2022 07:09:10 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH] net: wwan: fix port open
Date:   Wed,  4 May 2022 19:50:06 +0530
Message-Id: <20220504142006.3804-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wwan device registered port can be opened as many number of times.
The first port open() call binds dev file to driver wwan port device
and subsequent open() call references to same wwan port instance.

When dev file is opened multiple times, all contexts still refers to
same instance of wwan port. So in tx path, the received data will be
fwd to wwan device but in rx path the wwan port has a single rx queue.
Depending on which context goes for early read() the rx data gets
dispatched to it.

Since the wwan port is not handling dispatching of rx data to right
context restrict wwan port open to single context.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/wwan_core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index b8c7843730ed..9ca2d8d76587 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -33,6 +33,7 @@ static struct dentry *wwan_debugfs_dir;
 
 /* WWAN port flags */
 #define WWAN_PORT_TX_OFF	0
+#define WWAN_PORT_OPEN		1
 
 /**
  * struct wwan_device - The structure that defines a WWAN device
@@ -58,7 +59,6 @@ struct wwan_device {
 /**
  * struct wwan_port - The structure that defines a WWAN port
  * @type: Port type
- * @start_count: Port start counter
  * @flags: Store port state and capabilities
  * @ops: Pointer to WWAN port operations
  * @ops_lock: Protect port ops
@@ -70,7 +70,6 @@ struct wwan_device {
  */
 struct wwan_port {
 	enum wwan_port_type type;
-	unsigned int start_count;
 	unsigned long flags;
 	const struct wwan_port_ops *ops;
 	struct mutex ops_lock; /* Serialize ops + protect against removal */
@@ -496,7 +495,7 @@ void wwan_remove_port(struct wwan_port *port)
 	struct wwan_device *wwandev = to_wwan_dev(port->dev.parent);
 
 	mutex_lock(&port->ops_lock);
-	if (port->start_count)
+	if (test_and_clear_bit(WWAN_PORT_OPEN, &port->flags))
 		port->ops->stop(port);
 	port->ops = NULL; /* Prevent any new port operations (e.g. from fops) */
 	mutex_unlock(&port->ops_lock);
@@ -549,11 +548,14 @@ static int wwan_port_op_start(struct wwan_port *port)
 	}
 
 	/* If port is already started, don't start again */
-	if (!port->start_count)
-		ret = port->ops->start(port);
+	if (test_bit(WWAN_PORT_OPEN, &port->flags)) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+	ret = port->ops->start(port);
 
 	if (!ret)
-		port->start_count++;
+		set_bit(WWAN_PORT_OPEN, &port->flags);
 
 out_unlock:
 	mutex_unlock(&port->ops_lock);
@@ -564,8 +566,7 @@ static int wwan_port_op_start(struct wwan_port *port)
 static void wwan_port_op_stop(struct wwan_port *port)
 {
 	mutex_lock(&port->ops_lock);
-	port->start_count--;
-	if (!port->start_count) {
+	if (test_and_clear_bit(WWAN_PORT_OPEN, &port->flags)) {
 		if (port->ops)
 			port->ops->stop(port);
 		skb_queue_purge(&port->rxq);
-- 
2.25.1

