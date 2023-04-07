Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15ACF6DA94F
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 09:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbjDGHTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 03:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjDGHTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 03:19:05 -0400
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:df01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8CD8A51;
        Fri,  7 Apr 2023 00:19:03 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-main-11.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-11.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:2cab:0:640:424b:0])
        by forwardcorp1b.mail.yandex.net (Yandex) with ESMTP id 1317860473;
        Fri,  7 Apr 2023 10:19:01 +0300 (MSK)
Received: from den-plotnikov-w.yandex-team.ru (unknown [2a02:6b8:b081:b507::1:25])
        by mail-nwsmtp-smtp-corp-main-11.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id oILXHQ0OnqM0-39MbbKTE;
        Fri, 07 Apr 2023 10:19:00 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1680851940; bh=M+GrHpEWlWJ+1XHyNjMAAazJmelEfcLsWVnAWIFUk0o=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=aPqNLWCehkyy/XA+eWjfN8NmsLPJhORDekWxFmoPtw9DyT+QXydmSI4M3cHei9oxU
         does330mUfCch0sD0wLANLFPFw4HQfhhW4tFUBefUfqquXhE6jp8KkwI0J8fg4t9xp
         OrEIw7fE2hx5ojVvgo3/iepSSaxeRPP49ZQJq9mY=
Authentication-Results: mail-nwsmtp-smtp-corp-main-11.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Denis Plotnikov <den-plotnikov@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, anirban.chakraborty@qlogic.com,
        sony.chacko@qlogic.com, GR-Linux-NIC-Dev@marvell.com,
        helgaas@kernel.org, simon.horman@corigine.com, manishc@marvell.com,
        shshaikh@marvell.com, den-plotnikov@yandex-team.ru
Subject: [PATCH net-next v2] qlcnic: check pci_reset_function result
Date:   Fri,  7 Apr 2023 10:18:49 +0300
Message-Id: <20230407071849.309516-1-den-plotnikov@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Static code analyzer complains to unchecked return value.
The result of pci_reset_function() is unchecked.
Despite, the issue is on the FLR supported code path and in that
case reset can be done with pcie_flr(), the patch uses less invasive
approach by adding the result check of pci_reset_function().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 7e2cf4feba05 ("qlcnic: change driver hardware interface mechanism")
Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
index 87f76bac2e463..eb827b86ecae8 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
@@ -628,7 +628,13 @@ int qlcnic_fw_create_ctx(struct qlcnic_adapter *dev)
 	int i, err, ring;
 
 	if (dev->flags & QLCNIC_NEED_FLR) {
-		pci_reset_function(dev->pdev);
+		err = pci_reset_function(dev->pdev);
+		if (err) {
+			dev_err(&dev->pdev->dev,
+				"Adapter reset failed (%d). Please reboot\n",
+				err);
+			return err;
+		}
 		dev->flags &= ~QLCNIC_NEED_FLR;
 	}
 
-- 
2.25.1

