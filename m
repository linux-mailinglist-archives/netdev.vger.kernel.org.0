Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B316418275
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 00:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbfEHWxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 18:53:10 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41265 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727409AbfEHWxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 18:53:10 -0400
Received: by mail-qk1-f195.google.com with SMTP id g190so320839qkf.8
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 15:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b7imStJCXt5lto2GcKtJbyVkWFqRAYKd356Rdc0iWyY=;
        b=pqpSE8D5tvFtb5goaWOMcIP+vCN4f/MwvYWAktYH+fnkhisD/D72kIUJ+jPN+px20E
         FrEpbBH8H/34WdBXWFi8fXgY0Z3lYXeq3ZBfkSZnSLS5+VBmC6dXLFQxdu/l0xDcPZ5e
         F60b7/BIp1LydZLHdQCzME8oNVRqHynP0EeG9g6dWkyrSBwGJuUrs2vGzNupCcf9RJM1
         IL39sE0/8Ac8fSdk6V8julfLLOGMCdCKatXi0SbMA2T21WfHTwDsB+ELXfH9Hyh0C8MS
         0Tps/Fmqu0Impue6Svi1ITkggMMwHBUF3GIlfXrUhpZv/Sw891Gwd6NLG4xqkhmEkmEd
         Txag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b7imStJCXt5lto2GcKtJbyVkWFqRAYKd356Rdc0iWyY=;
        b=G7bhVkSIzS0rv3P3kdJtQlhbuwCQSCQsP84yrbdiVgRf/X2bFYBz1jM3hhDSPib44M
         fEGVMsNP3nxWb8eoq6OO/SLHw/+yrfpG1YJteUM0qfP3PMwOsJ6OgnTaf9nYdFKCMXwM
         Yo9QcQLqz67Tenn2WCktFPVHdP3NbeUYQXCxmHr7WLYEvQbEvznMmF9D04Y2mxWvMRdn
         nZTZhXoQglLm3to5h6Ed5M4M5cW9YnGE1CUi+aCC8XqjFjNqTm28Gd3bbQosgfqNkmMY
         XPbymNBHEpfejrU6/MWUlRJx1ZPh8fy70uJJKeaTlMhWDFiLdsJX1j9oRkAm/ptG4Tmx
         d1CQ==
X-Gm-Message-State: APjAAAXC2VrF8bZ53vt1ZhAWqBurZk4UelpCzqvGNg+r5B4UerVz6AOV
        yCpbXdcWbuAL//YQG7IHZlxe5A==
X-Google-Smtp-Source: APXvYqyvCajMdWXjd3OFZVejgzdW5V6BdiDu71vO+qvPTPZCew1yjq8tKaU38f2scXkDQ7DiUQPS/Q==
X-Received: by 2002:a37:358:: with SMTP id 85mr436462qkd.174.1557355988994;
        Wed, 08 May 2019 15:53:08 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q5sm182702qtj.3.2019.05.08.15.53.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 15:53:08 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net, jiri@resnulli.us
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net] nfp: reintroduce ndo_get_port_parent_id for representor ports
Date:   Wed,  8 May 2019 15:52:56 -0700
Message-Id: <20190508225256.25846-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

NFP does not register devlink ports for representors (without
the "devlink: expose PF and VF representors as ports" series
there are no port flavours to expose them as).

Commit c25f08ac65e4 ("nfp: remove ndo_get_port_parent_id implementation")
went to far in removing ndo_get_port_parent_id for representors.
This causes redirection offloads to fail, and switch_id attribute
missing.

Reintroduce the ndo_get_port_parent_id callback for representor ports.

Fixes: c25f08ac65e4 ("nfp: remove ndo_get_port_parent_id implementation")
Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../net/ethernet/netronome/nfp/nfp_net_repr.c    |  1 +
 drivers/net/ethernet/netronome/nfp/nfp_port.c    | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 036edcc1fa18..1eef446036d6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -273,6 +273,7 @@ const struct net_device_ops nfp_repr_netdev_ops = {
 	.ndo_fix_features	= nfp_repr_fix_features,
 	.ndo_set_features	= nfp_port_set_features,
 	.ndo_set_mac_address    = eth_mac_addr,
+	.ndo_get_port_parent_id	= nfp_port_get_port_parent_id,
 	.ndo_get_devlink_port	= nfp_devlink_get_devlink_port,
 };
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.c b/drivers/net/ethernet/netronome/nfp/nfp_port.c
index fcd16877e6e0..93c5bfc0510b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.c
@@ -30,6 +30,22 @@ struct nfp_port *nfp_port_from_netdev(struct net_device *netdev)
 	return NULL;
 }
 
+int nfp_port_get_port_parent_id(struct net_device *netdev,
+				struct netdev_phys_item_id *ppid)
+{
+	struct nfp_port *port;
+	const u8 *serial;
+
+	port = nfp_port_from_netdev(netdev);
+	if (!port)
+		return -EOPNOTSUPP;
+
+	ppid->id_len = nfp_cpp_serial(port->app->cpp, &serial);
+	memcpy(&ppid->id, serial, ppid->id_len);
+
+	return 0;
+}
+
 int nfp_port_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 		      void *type_data)
 {
-- 
2.21.0

