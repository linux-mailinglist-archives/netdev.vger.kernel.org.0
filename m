Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524066DF40A
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 13:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjDLLpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 07:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDLLpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 07:45:38 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA3589C;
        Wed, 12 Apr 2023 04:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=TGkvq
        8vP47zhOGd0OAIzfEiajGPLc3JGihR2TortqD0=; b=BUp0DsFhPg2iBN8toXe1s
        SSEcW3YfODlm+dZzQCHC973cT0VCTBJuXN3kRhs5Hd8cvDEz/RRMFs9Bv9weUXGP
        P897N5Rxl5a9lCWLITAR1HYsonEn7bB1EkjM4MIu+moQ4c7D9PLfbxsQsQJfGfGC
        Pic8M9T2hI5A1b/ZPOEC+M=
Received: from VM-0-27-ubuntu.. (unknown [43.134.191.38])
        by zwqz-smtp-mta-g2-2 (Coremail) with SMTP id _____wA3K8mKmTZkyjvwBA--.16313S2;
        Wed, 12 Apr 2023 19:44:12 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Slark Xiao <slark_xiao@163.com>
Subject: [PATCH net] wwan: core: add print for wwan port attach/disconnect
Date:   Wed, 12 Apr 2023 19:44:02 +0800
Message-Id: <20230412114402.1119956-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wA3K8mKmTZkyjvwBA--.16313S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrWrGFyUXw4DZF1ktw48tFb_yoWkKrgE9w
        n8ZaykWw4UGFWxtryaqF13ArWS9w4IqFWkJr4FqFZ3Zr98XryfW34fZanrKw1vva15Zry7
        Wr1DKF4vv34rGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRKPfHUUUUUU==
X-Originating-IP: [43.134.191.38]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/1tbiNQ9PZGI0cwvb6QAAsN
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refer to USB serial device or net device, there is notice to
let end user know the status of device, like attached or
disconnected. Add attach/disconnect print for wwan device as
well. This change works for MHI device and USB device.

Signed-off-by: Slark Xiao <slark_xiao@163.com>
---
 drivers/net/wwan/wwan_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 2e1c01cf00a9..d3ac6c5b0b26 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -492,6 +492,8 @@ struct wwan_port *wwan_create_port(struct device *parent,
 	if (err)
 		goto error_put_device;
 
+	dev_info(&wwandev->dev, "%s converter now attached to %s\n",
+		 wwan_port_dev_type.name, port->dev.kobj.name);
 	return port;
 
 error_put_device:
@@ -517,6 +519,9 @@ void wwan_remove_port(struct wwan_port *port)
 
 	skb_queue_purge(&port->rxq);
 	dev_set_drvdata(&port->dev, NULL);
+
+	dev_info(&wwandev->dev, "%s converter now disconnected from %s\n",
+		 wwan_port_dev_type.name, port->dev.kobj.name);
 	device_unregister(&port->dev);
 
 	/* Release related wwan device */
-- 
2.34.1

