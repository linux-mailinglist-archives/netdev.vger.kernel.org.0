Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3AA86E8806
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 04:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbjDTChb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 22:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbjDTCh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 22:37:29 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 97793F9;
        Wed, 19 Apr 2023 19:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=HXZIp
        zZdUrErn57m6e5heCl+mhUJCi/HhdJ4WRmQj1M=; b=lKdRDD6L9VYeVfWcV97e0
        eBPz2Fk2cbhR9L0PgSvI6au081QCrIoIPjBchPxNFpb81WrF8hd8PlSBgVnlo2Tt
        xLi72ynUsRTs2EMTqWeBN81/cklfYoLUsx63Fihb58Ex7rzRYya1gNLI0cY4NhCm
        jwwPJXvtSxbzRAuEV++GoI=
Received: from VM-0-27-ubuntu.. (unknown [43.134.191.38])
        by zwqz-smtp-mta-g4-3 (Coremail) with SMTP id _____wCXhVYjpUBkg2azBw--.61857S2;
        Thu, 20 Apr 2023 10:36:21 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Slark Xiao <slark_xiao@163.com>
Subject: [net-next v2] wwan: core: add print for wwan port attach/disconnect
Date:   Thu, 20 Apr 2023 10:36:17 +0800
Message-Id: <20230420023617.3919569-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wCXhVYjpUBkg2azBw--.61857S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gry3WF4xJw47tr1rJF13Arb_yoWkWrbE93
        Z8Zan5XrWUGayxtrW3GF15ZrWSkw1IvFW0qr1FqFZ3Z34DXryxW3yfu3ZrG3yxCa15uFy3
        Wr1UtF1Iv34rGjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRKPfHUUUUUU==
X-Originating-IP: [43.134.191.38]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/1tbiRxxXZFc7bap18AAAsG
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refer to USB serial device or net device, there is a notice to
let end user know the status of device, like attached or
disconnected. Add attach/disconnect print for wwan device as
well.

Signed-off-by: Slark Xiao <slark_xiao@163.com>
---

v2: Use dev_name() instead of kobj item and make print neat.
---
 drivers/net/wwan/wwan_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 2e1c01cf00a9..aa54fa6d5f90 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -492,6 +492,7 @@ struct wwan_port *wwan_create_port(struct device *parent,
 	if (err)
 		goto error_put_device;
 
+	dev_info(&wwandev->dev, "port %s attached\n", dev_name(&port->dev));
 	return port;
 
 error_put_device:
@@ -517,6 +518,8 @@ void wwan_remove_port(struct wwan_port *port)
 
 	skb_queue_purge(&port->rxq);
 	dev_set_drvdata(&port->dev, NULL);
+
+	dev_info(&wwandev->dev, "port %s disconnected\n", dev_name(&port->dev));
 	device_unregister(&port->dev);
 
 	/* Release related wwan device */
-- 
2.34.1

