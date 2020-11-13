Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F44D2B252E
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 21:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgKMUNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 15:13:12 -0500
Received: from z5.mailgun.us ([104.130.96.5]:22412 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgKMUNL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 15:13:11 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605298391; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=HHuZmctN86uguJW1Aew2gQvoZ+95MqaWXmgQpJElTGA=; b=l41xIMbe4S5YoS/HwAcNUESYsSZJFlsvnFP0xce5BlA6P3PWMacMdjsd05sOBvM9z8nxhkCE
 nsogV5fKNpxwfQUT3BPud/Bz6q7E1H53N6uC0TW21OE8oKUDurcZH3z/K3DWLkP01aH0X/ju
 MMAICnwzHgc6af+78SmeEtUuLto=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-west-2.postgun.com with SMTP id
 5faee8d6e9dd187f533bcfbc (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 13 Nov 2020 20:13:10
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6EF81C433CB; Fri, 13 Nov 2020 20:13:10 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1227FC433C6;
        Fri, 13 Nov 2020 20:13:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1227FC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Subject: [PATCH net] net: qualcomm: rmnet: Fix incorrect receive packet handling during cleanup
Date:   Fri, 13 Nov 2020 13:12:05 -0700
Message-Id: <1605298325-3705-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During rmnet unregistration, the real device rx_handler is first cleared
followed by the removal of rx_handler_data after the rcu synchronization.

Any packets in the receive path may observe that the rx_handler is NULL.
However, there is no check when dereferencing this value to use the
rmnet_port information.

This fixes following splat by adding the NULL check.

Unable to handle kernel NULL pointer dereference at virtual
address 000000000000000d
pc : rmnet_rx_handler+0x124/0x284
lr : rmnet_rx_handler+0x124/0x284
 rmnet_rx_handler+0x124/0x284
 __netif_receive_skb_core+0x758/0xd74
 __netif_receive_skb+0x50/0x17c
 process_backlog+0x15c/0x1b8
 napi_poll+0x88/0x284
 net_rx_action+0xbc/0x23c
 __do_softirq+0x20c/0x48c

Fixes: ceed73a2cf4a ("drivers: net: ethernet: qualcomm: rmnet: Initial implementation")
Signed-off-by: Sean Tranchetti <stranche@codeaurora.org>
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 29a7bfa..3d7d3ab 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -188,6 +188,11 @@ rx_handler_result_t rmnet_rx_handler(struct sk_buff **pskb)
 
 	dev = skb->dev;
 	port = rmnet_get_port_rcu(dev);
+	if (unlikely(!port)) {
+		atomic_long_inc(&skb->dev->rx_nohandler);
+		kfree_skb(skb);
+		goto done;
+	}
 
 	switch (port->rmnet_mode) {
 	case RMNET_EPMODE_VND:
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

