Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBEF6D195F
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbjCaIGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjCaIG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:06:28 -0400
X-Greylist: delayed 93879 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 31 Mar 2023 01:06:18 PDT
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:df01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CFC1C1F4;
        Fri, 31 Mar 2023 01:06:17 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c18:1421:0:640:53a0:0])
        by forwardcorp1a.mail.yandex.net (Yandex) with ESMTP id E0BFB60412;
        Fri, 31 Mar 2023 11:06:15 +0300 (MSK)
Received: from den-plotnikov-w.yandex-team.ru (unknown [2a02:6b8:b081:b509::1:8])
        by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 56FrmA0Od0U0-3fNi8o71;
        Fri, 31 Mar 2023 11:06:15 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1680249975; bh=+sWL6z24WHkI1mHsF//PDU19LhlB9QYnVo3MDVRJCvs=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=HOgrJ+JVfs5Ft5A1WbeXah7jZLHc3X71KUOXPA80G94ozeiBdqzUkdt6/y4fKh4GG
         IyXGXERoVppbXUwD+3yHmqlEqeAQ/QQV2Lky4B6gJcf3FPikxLVi0HNo0p5mW4z0dN
         n5B8wncTzqFWDoip329rX0uGcytcKjeGwAENjKlU=
Authentication-Results: mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Denis Plotnikov <den-plotnikov@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, shshaikh@marvell.com,
        manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, den-plotnikov@yandex-team.ru
Subject: [PATCH] qlcnic: check pci_reset_function result
Date:   Fri, 31 Mar 2023 11:06:05 +0300
Message-Id: <20230331080605.42961-1-den-plotnikov@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Static code analyzer complains to unchecked return value.
It seems that pci_reset_function return something meaningful
only if "reset_methods" is set.
Even if reset_methods isn't used check the return value to avoid
possible bugs leading to undefined behavior in the future.

Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
index 87f76bac2e463..39ecfc1a1dbd0 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ctx.c
@@ -628,7 +628,9 @@ int qlcnic_fw_create_ctx(struct qlcnic_adapter *dev)
 	int i, err, ring;
 
 	if (dev->flags & QLCNIC_NEED_FLR) {
-		pci_reset_function(dev->pdev);
+		err = pci_reset_function(dev->pdev);
+		if (err && err != -ENOTTY)
+			return err;
 		dev->flags &= ~QLCNIC_NEED_FLR;
 	}
 
-- 
2.25.1

