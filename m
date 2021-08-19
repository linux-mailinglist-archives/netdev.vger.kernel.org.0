Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4F73F188E
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 13:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239061AbhHSLxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 07:53:35 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:35100
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238931AbhHSLxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 07:53:32 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id B103B40C9E;
        Thu, 19 Aug 2021 11:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629373973;
        bh=mkX3WqTYJzJnBaXl1A6JVddRvb9bCbWsb2Y1VU0m9sU=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=nHdXC2snZsKBvplIDZh1wJANkWMmG3V69OrCTxKzs5wC2kOtRXtmQvIqRNbUoBfm6
         unkPcKnbR/uuvlXm2UIbTZ4R0MgUcpCUM9D/NsNOVVxqqtKdaVPPBX0Nx2QK7f+YMe
         1e0eFTYCDZke/P2qjJblJjyvGscbEoD7kkhS6hb2WmHHttv4vNaefK25pRdX89DkB5
         T23KoCV0Yo6qvMpTgcwTIzJo/rP56tnrItaN3XelgUMLu01tIoHgYjOwpNbN1Elv10
         Rx2yCCz9mwxbTarGw7OtG1crfZYDEYHftmaqTVbb+LOvbdyt7AKfiq0m09oGx2EgHu
         73s1V6E0uqiGQ==
From:   Colin King <colin.king@canonical.com>
To:     Bin Luo <luobin9@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hinic: make array speeds static const, makes object smaller
Date:   Thu, 19 Aug 2021 12:52:53 +0100
Message-Id: <20210819115253.6324-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array speeds on the stack but instead it
static const. Makes the object code smaller by 17 bytes:

Before:
   text    data     bss     dec     hex filename
  39987   14200      64   54251    d3eb .../huawei/hinic/hinic_sriov.o

After:
   text    data     bss     dec     hex filename
  39906   14264      64   54234    d3da .../huawei/hinic/hinic_sriov.o

(gcc version 10.3.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index f8a26459ff65..a78c398bf5b2 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -836,8 +836,10 @@ int hinic_ndo_set_vf_trust(struct net_device *netdev, int vf, bool setting)
 int hinic_ndo_set_vf_bw(struct net_device *netdev,
 			int vf, int min_tx_rate, int max_tx_rate)
 {
-	u32 speeds[] = {SPEED_10, SPEED_100, SPEED_1000, SPEED_10000,
-			SPEED_25000, SPEED_40000, SPEED_100000};
+	static const u32 speeds[] = {
+		SPEED_10, SPEED_100, SPEED_1000, SPEED_10000,
+		SPEED_25000, SPEED_40000, SPEED_100000
+	};
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 	struct hinic_port_cap port_cap = { 0 };
 	enum hinic_port_link_state link_state;
-- 
2.32.0

