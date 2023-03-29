Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661A06CEF7C
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjC2QcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjC2QcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:32:20 -0400
X-Greylist: delayed 178 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 29 Mar 2023 09:31:53 PDT
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:df01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A8C6595;
        Wed, 29 Mar 2023 09:31:53 -0700 (PDT)
Received: from mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net [IPv6:2a02:6b8:c08:19a8:0:640:4e87:0])
        by forwardcorp1b.mail.yandex.net (Yandex) with ESMTP id AE410601D5;
        Wed, 29 Mar 2023 19:26:37 +0300 (MSK)
Received: from den-plotnikov-w.yandex-team.ru (unknown [2a02:6b8:b081:8006::1:12])
        by mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id TQLB0205PSw0-V6zF1MzS;
        Wed, 29 Mar 2023 19:26:37 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1680107197; bh=6xP5y4W5QFPSk1AXfrdVudo8s0DTuSkKJxaO1A8JJHE=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=QuxwFmqIp1IFWlnAJl5VdYchtcy92MtlMfH/WedZ5fRsP06ABM9T9ajgroWbqXD5f
         3NyMkhITMdt2P/ATDFgqBgOywWc1JcOeKPOWfZl+GqFEQQJBROU+cPNTBk6SVuAY5u
         jQo4x/iaFBgJ+646MP5cs5crtnA8DBO01owl4SfU=
Authentication-Results: mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Denis Plotnikov <den-plotnikov@yandex-team.ru>
To:     GR-Linux-NIC-Dev@marvell.com
Cc:     manishc@marvell.com, rahulv@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: [PATCH] net: netxen: report error on version offset reading
Date:   Wed, 29 Mar 2023 19:26:29 +0300
Message-Id: <20230329162629.96590-1-den-plotnikov@yandex-team.ru>
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

A static analyzer complains for non-checking the function returning value.
Although, the code looks like not expecting any problems with version
reading on netxen_p3_has_mn call, it seems the error still may happen.
So, at least, add error reporting to ease problems investigation.

Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
index 35ec9aab3dc7b..92962dbb73ad0 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
@@ -1192,8 +1192,13 @@ netxen_p3_has_mn(struct netxen_adapter *adapter)
 	if (NX_IS_REVISION_P2(adapter->ahw.revision_id))
 		return 1;
 
-	netxen_rom_fast_read(adapter,
-			NX_FW_VERSION_OFFSET, (int *)&flashed_ver);
+	if (netxen_rom_fast_read(adapter,
+			NX_FW_VERSION_OFFSET, (int *)&flashed_ver)) {
+		printk(KERN_ERR "%s: ERROR on flashed version reading",
+				netxen_nic_driver_name);
+		return 0;
+	}
+
 	flashed_ver = NETXEN_DECODE_VERSION(flashed_ver);
 
 	if (flashed_ver >= NETXEN_VERSION_CODE(4, 0, 220)) {
-- 
2.25.1

