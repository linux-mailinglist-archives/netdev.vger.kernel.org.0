Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7243DCC3C
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 17:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbhHAPRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 11:17:09 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:34190
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231940AbhHAPRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 11:17:08 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 918353F10D;
        Sun,  1 Aug 2021 15:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627831019;
        bh=pEdVP9sw9L+WCs6++8+CCGKbsvPIF1O4aMOs5rsYADQ=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=Zvdk8o/tJ3Iw+I1sBq4XSs9l9qrWXfb6LvL7enVHOime6NL2esEUmno3dPC/+uQYh
         J/531AQYPzTSMwjHdzR4vgB20j6fXLJITFgCHcF7hq1UKNbTolfmezbSIFdoUTq89N
         4swtVJ6Y/jkK2GrHsAKWcqkD3DKE8ONjqC7gbEpy/5KwlBFGAHAqS95Uqg5omoc6o9
         whdMdOUl89lawMydHkzP6oFyNIRiLLf0l8i54KnS5HP/x8TudBpBToRfqUfDG2VEPG
         aq3OoJ5wcsZK2McIjLZwxJN4nJJEtc7TF4CKYdhoTW3tc/IijZZX9i2AA16dXutVXB
         bTmDJ5qQeNMsg==
From:   Colin King <colin.king@canonical.com>
To:     Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] qlcnic: make the array random_data static const, makes object smaller
Date:   Sun,  1 Aug 2021 16:16:59 +0100
Message-Id: <20210801151659.146113-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array random_data on the stack but instead it
static const. Makes the object code smaller by 66 bytes.

Before:
   text    data     bss     dec     hex filename
  52895   10976       0   63871    f97f ../qlogic/qlcnic/qlcnic_ethtool.o

After:
   text    data     bss     dec     hex filename
  52701   11104       0   63805    f93d ../qlogic//qlcnic/qlcnic_ethtool.o

(gcc version 10.2.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
index d8f0863b3934..f6b6651decf3 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
@@ -1021,7 +1021,7 @@ static int qlcnic_irq_test(struct net_device *netdev)
 
 static void qlcnic_create_loopback_buff(unsigned char *data, u8 mac[])
 {
-	unsigned char random_data[] = {0xa8, 0x06, 0x45, 0x00};
+	static const unsigned char random_data[] = {0xa8, 0x06, 0x45, 0x00};
 
 	memset(data, 0x4e, QLCNIC_ILB_PKT_SIZE);
 
-- 
2.31.1

