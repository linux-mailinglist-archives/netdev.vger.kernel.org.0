Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787391B5CBD
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 15:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbgDWNk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 09:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726361AbgDWNk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 09:40:56 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809DDC08E934
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 06:40:55 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z1so1266735pfn.3
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 06:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6mkC0WY6HULSFZ8YT/pOSmxeXQvUrcI/s78zoMN0bBw=;
        b=tKZEHzON1pS583iBymPZK/LWIjEIcs1Bfg/2QBqFsD0EVRuVBxQH+8YEe2AROB6zoa
         PN9pIY1zm54mPIuRIhdq327qcj3Qgvua9qVaI2KP3/67upstfvB4udcye55xTq2PDQNI
         bHHAUnNUp7QYDsdRJwKIcQCowaFbvirlSSCxtg0lJNY7m5y+Uh4jdfDo+4i2+Iw8/cHH
         I/mpc/wCTwLZrlvuDUV2wDBsqP8wdR8S4ER76EUK5vYxCy72as0FE8SS1sAJ/edM5LoN
         9T4vyN2W8f5DG+VoILvBunI/Pi7NIHhBy3cHxKRvLmxKAec/KyG3+S8+AjmMegTB+VGl
         H8Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6mkC0WY6HULSFZ8YT/pOSmxeXQvUrcI/s78zoMN0bBw=;
        b=ELThn7+UBKsLDTCll+iEFDL76fgcXbu37Ie5ztKr7MYHDOf62OSSMk+d822VmcS5Bj
         UOLa8eCeDThw4CqCqeknyccncpNS/L9QyN4OkhPiHKeTeivdTNyUtti8m9KXHPKqaInn
         SNOP3Tikll9HaCMy4jqHTEcazFmkVMiHxGaViBk3C/lJw8q1mXb6oISIS5xN7o6lyyhu
         ijX+xtp8Iv9Ny/xXmZ8wVu4rEDjnGzT0fYY34kYNXjPhnU2SMjgF9iYjt8YlW2Uq2AGq
         VXULFleVf2f70ByY4+qzUf+thH3v4XXKPY0ds6HisUbJjV3reCfUoDLvqw10/T76jyWs
         aBNA==
X-Gm-Message-State: AGi0PubVFivdBOSNl0JhUEbWIN32caaO1DNm1iK7XfhkaJbTh7DqPYeU
        RS/+fc2TNfHcQw3knlSWMP5H+hzhtgM=
X-Google-Smtp-Source: APiQypIyIHOkDIDfrxfUYijTQhE3KWaWh2skeBFdJ9gMIg+dmLzZncyCpGHQTc1nB8Z+mYnaeok5Bw==
X-Received: by 2002:a62:1b84:: with SMTP id b126mr3796607pfb.123.1587649254834;
        Thu, 23 Apr 2020 06:40:54 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id c144sm2560080pfb.172.2020.04.23.06.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 06:40:53 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, sd@queasysnail.net,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] macsec: avoid to set wrong mtu
Date:   Thu, 23 Apr 2020 13:40:47 +0000
Message-Id: <20200423134047.21644-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a macsec interface is created, the mtu is calculated with the lower
interface's mtu value.
If the mtu of lower interface is lower than the length, which is needed
by macsec interface, macsec's mtu value will be overflowed.
So, if the lower interface's mtu is too low, macsec interface's mtu
should be set to 0.

Test commands:
    ip link add dummy0 mtu 10 type dummy
    ip link add macsec0 link dummy0 type macsec
    ip link show macsec0

Before:
    11: macsec0@dummy0: <BROADCAST,MULTICAST,M-DOWN> mtu 4294967274
After:
    11: macsec0@dummy0: <BROADCAST,MULTICAST,M-DOWN> mtu 0

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/macsec.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index a183250ff66a..758baf7cb8a1 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -4002,11 +4002,11 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 			  struct netlink_ext_ack *extack)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
+	rx_handler_func_t *rx_handler;
+	u8 icv_len = DEFAULT_ICV_LEN;
 	struct net_device *real_dev;
-	int err;
+	int err, mtu;
 	sci_t sci;
-	u8 icv_len = DEFAULT_ICV_LEN;
-	rx_handler_func_t *rx_handler;
 
 	if (!tb[IFLA_LINK])
 		return -EINVAL;
@@ -4033,7 +4033,11 @@ static int macsec_newlink(struct net *net, struct net_device *dev,
 
 	if (data && data[IFLA_MACSEC_ICV_LEN])
 		icv_len = nla_get_u8(data[IFLA_MACSEC_ICV_LEN]);
-	dev->mtu = real_dev->mtu - icv_len - macsec_extra_len(true);
+	mtu = real_dev->mtu - icv_len - macsec_extra_len(true);
+	if (mtu < 0)
+		dev->mtu = 0;
+	else
+		dev->mtu = mtu;
 
 	rx_handler = rtnl_dereference(real_dev->rx_handler);
 	if (rx_handler && rx_handler != macsec_handle_frame)
-- 
2.17.1

